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

Unsigned or untrusted DLLs are skipped at `Import-Module` time. They are **not** silent:
every candidate — loaded or rejected — is recorded and surfaced by
[`Get-PSDataRepositoryExtension`](Get-PSDataRepositoryExtension.md) with the reason.
See [Extensions.md § Trusting 3rd‑party extensions](Extensions.md) and
[`Security.md`](Security.md).

---

## Extension contract

Trust answers *whose code may run*. A second, independent question is *whether that code can
still work*, and it is answered by the **contract version**.

The contract is the public API of `PSDataRepository.Abstractions`, `.Formatters`, `.Providers`
and `.Authentications`. Those assemblies are always loaded from the **module root**, so an
extension runs against the host's copy, never the one it compiled against. A breaking change
therefore produces no build error and no load error — the extension's types simply fail to
materialise and the capability disappears.

| Change to the contract | Effect on an already-built extension |
|---|---|
| Patch | none |
| Minor (additive, default interface members) | keeps loading |
| **Major** | **rejected** with a message naming both versions |

The version is versioned **independently of the module**: `PSDataRepositoryContractVersion` in
`src/Directory.Build.props`. The SDK stamps it into every extension it builds, and the loader
compares majors. Extensions carrying no stamp at all are treated as contract `1.0`, so
introducing the gate did not disable anything that already worked.

Two build-time guards keep the number honest: `Microsoft.CodeAnalysis.PublicApiAnalyzers`
makes every public API change appear as a reviewable diff, and
`src/build/vsts-validate-contract-version.ps1` fails the build when a breaking change lands
without a major bump.

---

## Assembly loading

Each extension gets its **own** `AssemblyLoadContext`, built with
`AssemblyDependencyResolver` from the extension's `.deps.json` — the supported .NET plugin
model. Resolution order inside that context:

1. `PSDataRepository.*` → module root or a sibling extension's context (one type identity)
2. **anything the module root ships** → default context — the sharing rule
3. the extension's own `.deps.json` → private to this extension
4. the extension's folder

Step 2 comes before step 3 deliberately. Everything in the module root has exactly one
identity in the process, which is what lets a value produced by one extension (an
`Azure.Core.TokenCredential` from the auth extension) be consumed by another. It also means an
extension can only ever hold a private copy of something the host does **not** ship — exactly
the subset where a second copy cannot break anything, with no list to maintain.

Extensions may ship dependencies privately
(`<PSDataRepositoryPrivateDependencies>true</...>`), which deploys them into a folder of their
own rather than the shared root. Note that a private copy of an assembly the host also ships is
inert, by the rule above.

---

## Related docs

- [Extensions SDK guide](Extensions.md) — author your own provider / auth / formatter
- [Security model](Security.md) — plugin trust, SNK threat model, encryption formats
- [MCP server](MCP.md) — LLM agent integration
- [Providers](Providers.md) · [Cmdlets](Cmdlets.md) · [Observability](Observability.md)
