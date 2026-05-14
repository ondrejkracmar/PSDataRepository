# Architecture

How **core**, **extensions** (provider / auth / formatter), the **AzAuth +
Isystem.AzAuth.Core** stack, the **ExtensionLoader / AssemblyLoadContext**
isolation, and the **PSDataRepository.MCP** server all wire into the same
shared registries.

---

## Component graph

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  HOST PROCESS  (PowerShell 7.4+ / .NET 8 or .NET 10)                         │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────────────┐  │
│  │  PSDataRepository module  (Import-Module)                              │  │
│  │                                                                        │  │
│  │  ┌──────────────────────────────┐    ┌─────────────────────────────┐   │  │
│  │  │ 20 Cmdlets                   │    │ ModuleInitializer.OnImport  │   │  │
│  │  │ Connect / Get / Set /        │──> │  → ExtensionLoader.LoadAll  │   │  │
│  │  │ Send / Receive / Secret /…   │    │  → scans Auth\,Providers\,  │   │  │
│  │  │ IDynamicParameters composes  │    │      Formatters\            │   │  │
│  │  │ params from registries       │    │  → trust check (SNK +       │   │  │
│  │  │                              │    │      extensions.trust.json) │   │  │
│  │  └─────────┬────────────────────┘    └──────────────┬──────────────┘   │  │
│  │            │                                        │                  │  │
│  │            ▼                                        ▼                  │  │
│  │  ┌────────────────────────────────────────────────────────────────┐    │  │
│  │  │ Shared Registries (singletons in PSDataRepository.Core)        │    │  │
│  │  │   ProviderRegistry · AuthenticationRegistry · FormatterRegistry│    │  │
│  │  └────────┬─────────────────┬─────────────────┬─────────────────┬─┘    │  │
│  │           │                 │                 │                 │      │  │
│  │   ┌───────▼──────────┐ ┌────▼─────────────┐ ┌─▼───────────────┐ │      │  │
│  │   │ Providers\ ALC   │ │ Auth\ ALC        │ │ Formatters\ ALC │ │      │  │
│  │   │ AzureBlob        │ │ AzAuth ─────┐    │ │ Csv · Json      │ │      │  │
│  │   │ AzureQueue       │ │ (AwsAuth?)  │    │ │ Xml · Yml       │ │      │  │
│  │   │ AzureKeyVault    │ │ (GcpAuth?)  │    │ │                 │ │      │  │
│  │   │ AzureServiceBus  │ │ (SpoAuth?)  │    │ └─────────────────┘ │      │  │
│  │   │ Disk · InMemory  │ └─────┬───────┘    │                     │      │  │
│  │   │ Scp · Ftp        │       │            │                     │      │  │
│  │   └────────┬─────────┘       ▼            │                     │      │  │
│  │            │      ┌──────────────────────────────┐              │      │  │
│  │            │      │ AzureAuthResolver            │              │      │  │
│  │            │      │  3-way dispatch:             │              │      │  │
│  │            │      │   ConnectionString / SAS /   │              │      │  │
│  │            │      │   TokenCredential            │              │      │  │
│  │            │      └──────────────┬───────────────┘              │      │  │
│  │            │                     ▼                              │      │  │
│  │            │      ┌──────────────────────────────────────────┐  │      │  │
│  │            │      │ Isystem.AzAuth.Core + Azure.Identity     │  │      │  │
│  │            │      │ (Default ALC — single Type identity      │  │      │  │
│  │            │      │  shared across every extension ALC)      │  │      │  │
│  │            │      └──────────────┬───────────────────────────┘  │      │  │
│  │            │                     │                              │      │  │
│  │            ▼                     ▼                              ▼      │  │
│  │     Cloud SDK clients (BlobServiceClient, QueueServiceClient,          │  │
│  │     ServiceBusClient, SecretClient) · SshClient · FtpClient            │  │
│  └────────────────────────────────────────────────────────────────────────┘  │
│                              ▲                                               │
└──────────────────────────────┼───────────────────────────────────────────────┘
                               │ (re-uses the same registries in-process,
                               │  or runs out-of-process over MCP transport)
                  ┌────────────┴──────────────────┐
                  │ PSDataRepository.MCP  server  │
                  │  RepositoryManagementTools.*  │
                  │   • Storage · Queue · Secrets │
                  │   • Scaffolding · Docs        │
                  │  (schemas generated runtime)  │
                  └───────────────────────────────┘
```

---

## How the pieces connect

- **Cmdlets** never reference a concrete provider. `Connect-PSDataRepository`
  reads the `-Provider` parameter, asks `ProviderRegistry`, and uses
  `IDynamicParameters` to compose the remaining parameters from the provider's
  `GetConnectParameters()` ∩ matching entries in `AuthenticationRegistry`.
- **ExtensionLoader** scans the three subfolders next to the module
  (`Providers\`, `Auth\`, `Formatters\`) on import, creates **one
  `AssemblyLoadContext` per subfolder**, and registers any discovered
  `IProviderDefinition` / `IAuthenticationProvider` / `IFormatterDefinition`.
  Shared types (`PSDataRepository.*` and any third‑party DLL present in the
  module root) are delegated to the **Default ALC** so every plugin sees the
  same `Type` identity (this is what makes
  `context.Authentication as SampleAuthInfo` actually succeed across plugin
  boundaries).
- **AzAuth** is just a reference authentication extension built on top of the
  reusable **`Isystem.AzAuth.Core`** library and `Azure.Identity`. New cloud
  vendors (AWS, GCP, SharePoint Online) follow the exact same pattern: drop a
  signed DLL into `Auth\`, expose mode constants + an option bag + a
  credential factory.
- **Formatters** are pure serialization plugins selected by file extension or
  content sniffing — they never touch a provider directly.
- **PSDataRepository.MCP** consumes the **same registries** (in‑process when
  hosted alongside the module, or out‑of‑process via the MCP transport) and
  generates tool schemas at runtime, so any extension installed for the module
  is automatically reachable from an LLM agent — no code changes needed.

---

## Trust model

PSDataRepository is **fail‑closed**: extensions are loaded only when

1. **Strong‑named with the Core SNK** (implicitly trusted), **or**
2. Their public‑key token is listed in `extensions.trust.json` next to
   `PSDataRepository.psd1` (administrator‑managed allow‑list).

Unsigned or untrusted DLLs are silently skipped at `Import-Module` time.
See [Extensions.md § Trusting 3rd‑party extensions](Extensions.md) and
[`SECURITY.md`](../SECURITY.md).

---

## Related docs

- [Extensions SDK guide](Extensions.md) — author your own provider / auth / formatter
- [MCP server](MCP.md) — LLM agent integration
- [Providers](Providers.md) · [Cmdlets](Cmdlets.md) · [Observability](Observability.md)
