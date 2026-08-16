# PSDataRepository — 3rd-party Extension Author Guide

PSDataRepository is extensible by **3rd-party providers, authentications, and
formatters**. This guide walks you through authoring an extension, signing it,
deploying it locally, and getting an administrator to trust it on a production
host.

> **Trust model — read first.** PSDataRepository is **fail-closed**: only
> strong-named DLLs whose public-key token is on the trust list are loaded.
> The Core SNK token is implicitly trusted; every other (3rd-party) token
> must be added to `extensions.trust.json` by an administrator. There is
> **no opt-out** — unsigned plugins are silently skipped at `Import-Module`
> time. See [SECURITY.md](../SECURITY.md) § *Trusting 3rd-party extensions*.

---

## 1. Project setup

Create a class library targeting `net8.0` and/or `net10.0` and add the SDK
package:

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFrameworks>net8.0;net10.0</TargetFrameworks>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>

    <!-- Required by the SDK targets. One of: Providers, Auth, Formatters -->
    <ExtensionSubfolder>Providers</ExtensionSubfolder>

    <!-- Strong-name signing is REQUIRED. The loader rejects unsigned DLLs. -->
    <SignAssembly>true</SignAssembly>
    <AssemblyOriginatorKeyFile>Contoso.Extensions.snk</AssemblyOriginatorKeyFile>

    <!-- Optional: deploy after build to your locally installed module
         for an inner-loop dev/test cycle. -->
    <PSDataRepositoryModuleDir>$(USERPROFILE)\Documents\PowerShell\Modules\PSDataRepository\1.0.0</PSDataRepositoryModuleDir>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="PSDataRepository.Extensions.Sdk" Version="1.0.0" />
  </ItemGroup>

</Project>
```

Generate `Contoso.Extensions.snk` once and keep it secret:

```pwsh
sn -k Contoso.Extensions.snk
```

---

## 2. Implement a contract

The SDK exposes three contracts. Pick **one** per project (you can ship
multiple projects in the same NuGet package if you need more).

### 2.1 Provider — `IProviderDefinition`

```csharp
using PSDataRepository.Abstractions;
using PSDataRepository.Providers;

namespace Contoso.PSDataRepository.MyProvider;

public sealed class MyProviderDefinition : IProviderDefinition
{
    public string Name => "Contoso";
    public string DisplayName => "Contoso internal storage";
    public ProviderCapabilities Capabilities => ProviderCapabilities.Storage;
    public IReadOnlyList<AuthenticationMode> SupportedAuthModes => new[]
    {
        AuthenticationMode.ConnectionString
    };

    public IRepositorySession CreateSession(ConnectContext ctx) => new MyProviderSession(ctx);
}
```

`MyProviderSession` derives from `BaseProviderSession` (or implements
`IRepositorySession` directly) and implements the operations relevant to
`Capabilities` (`IStorageRepository`, `IQueueRepository`, `ISecretRepository`).

### 2.2 Authentication — `IAuthenticationProvider`

```csharp
using PSDataRepository.Authentications;

namespace Contoso.PSDataRepository.MyAuth;

public sealed class MyAuthProvider : IAuthenticationProvider
{
    public string Name => "ContosoSso";
    public AuthenticationMode Mode => AuthenticationMode.Custom;

    public IAuthenticationInfo Authenticate(ConnectContext ctx) =>
        new MyAuthInfo(ctx.GetString("ContosoTenant"));
}
```

### 2.3 Formatter — `IFormatterDefinition`

```csharp
using PSDataRepository.Formatters;

namespace Contoso.PSDataRepository.MyFormat;

public sealed class TomlFormatter : IFormatterDefinition
{
    public string Name => "Toml";
    public string ContentType => "application/toml";
    public IEnumerable<string> Extensions => new[] { ".toml" };

    public byte[] Serialize(object? value) => /* ... */;
    public object? Deserialize(byte[] data, Type targetType) => /* ... */;
}
```

---

## 3. Build & local deploy

```pwsh
dotnet build -c Release
```

The SDK targets:

- **PSDR1001/1002** fail the build if `<ExtensionSubfolder>` is missing or invalid.
- **PSDR1003** warns if `<SignAssembly>` is not `true`.
- When `<PSDataRepositoryModuleDir>` is set and the directory exists,
  the built DLL is copied to
  `{ModuleDir}/bin/{TFM}/{ExtensionSubfolder}/`, and runtime dependencies
  (filtered for PowerShell host & `PSDataRepository.*` assemblies) are
  copied to `{ModuleDir}/bin/{TFM}/`.

> The deployment step is purely **for local testing**. Production
> distribution should be a NuGet/Zip package consumed by your release
> tooling — the loader does not auto-discover from `$env:PSModulePath`.

---

## 4. Get the extension trusted

After deploying the DLL, an administrator must add its public-key token
to `extensions.trust.json` next to `PSDataRepository.psd1`:

```pwsh
# Extract the token in the right format
Get-PSDataRepositoryExtensionToken -Path .\Contoso.PSDataRepository.MyProvider.dll
# Path                                      Name                                       Token             IsSigned
# ----                                      ----                                       -----             --------
# C:\...\Contoso.PSDataRepository.MyProvider Contoso.PSDataRepository.MyProvider.dll    a1b2c3d4e5f60708  True
```

Then edit the trust list:

```jsonc
{
  "trustedPublicKeyTokens": [
    "a1b2c3d4e5f60708"
  ]
}
```

Restart the PowerShell session — the trust file is read once at
`Import-Module` time. To revoke trust, remove the entry and restart.

> The Core SNK token is **always** implicitly trusted; this file only
> *adds* trust. Editing it is equivalent to allowing arbitrary code
> execution under the calling user's identity — treat it like a
> trusted-publisher entry.

---

## 5. Verify it loads

```pwsh
Import-Module PSDataRepository

# Every discovered extension, loaded or rejected, with the reason
Get-PSDataRepositoryExtension

# Only the ones that were refused
Get-PSDataRepositoryExtension -Rejected | Format-List Name, ContractVersion, Reason

# Providers — yours should be listed
Get-PSDataRepositoryProvider
```

`Get-PSDataRepositoryExtension` is the first thing to reach for: it reports one
row per candidate assembly the loader saw, so a missing provider is a rejection
with a stated reason rather than a mystery. Loader tracing below remains useful
for the surrounding detail. Set the
`PSDATAREPOSITORY_EXTENSION_TRACE` environment variable to `1` before
importing the module — the loader then mirrors every decision (including the
reason an extension was skipped) to the error stream:

```pwsh
$env:PSDATAREPOSITORY_EXTENSION_TRACE = '1'
Import-Module PSDataRepository -Force
# Loader diagnostics are written to stderr, e.g.:
#   [PSDataRepository] Found 1 assembly candidates in ...\bin\net8.0\Providers
#   [PSDataRepository] Skipping assembly 'Contoso...dll' — public key token not trusted...
```

The same messages always go to `Debug.WriteLine`, so DebugView (Sysinternals)
or an attached debugger remain an alternative when a console stream is not
available.

Common reasons an extension is silently skipped (visible in the diagnostics):

| Diagnostic                                       | Fix                                                                  |
| ------------------------------------------------ | -------------------------------------------------------------------- |
| `Skipping unsigned assembly '...'`               | Set `<SignAssembly>true</SignAssembly>` and supply an SNK key.       |
| `Skipping assembly '...' — public key token not trusted` | Add the token to `extensions.trust.json` and restart pwsh.   |
| `Plugin directory not found: ...`                | Wrong `<ExtensionSubfolder>`, or the DLL was not deployed to `{ModuleDir}/bin/{TFM}/{ExtensionSubfolder}/`. |
| `Failed to load '...': ...FileNotFoundException` | A runtime dependency was filtered out — verify `bin/{TFM}/` content. |
| `was built against contract X, but this module provides contract Y` | Rebuild against `PSDataRepository.Extensions.Sdk` `Y.x`. See §6. |

---

## 6. The extension contract

The SDK stamps every extension it builds with the contract version it was
compiled against, and the loader refuses to load an extension whose contract
**major** does not match the module's. You do not write the attribute — merely
referencing `PSDataRepository.Extensions.Sdk` applies it.

This exists because the contract assemblies (`PSDataRepository.Abstractions`,
`.Formatters`, `.Providers`, `.Authentications`) are always loaded from the
**module root**, never from your output folder. The version you compiled against
is discarded at runtime, so a breaking contract change does not produce a build
error or a load error — your types simply fail to materialise and your provider
is absent. The gate turns that into one message that names both versions.

| Change on the host | Effect on an already-built extension |
| --- | --- |
| Patch bump (`1.2.0` → `1.2.1`) | Nothing; no API moved. |
| Minor bump (`1.2` → `1.3`) | Keeps loading — additions are made non-breaking via default interface members. |
| Major bump (`1.x` → `2.0`) | **Rejected.** Rebuild against the new SDK. |

An extension carrying no attribute at all — anything built before this existed —
is treated as contract `1.0` and still loads.

The contract version is deliberately **not** recorded in
`extensions.trust.json`. That file answers "whose code may run"; the contract
answers "can this code work". A publisher does not become untrusted because
their extension needs a rebuild, and pinning versions per token would mean
editing a security file on every contract bump.

---

## 7. Installing and removing

An administrator installs the `.zip` produced by `publish-extension.ps1`:

```pwsh
Install-PSDataRepositoryExtension -Path .\Contoso.PSDataRepository.MyProvider-1.2.0.zip
```

The install applies the same checks the loader applies — strong name, contract
compatibility — **before** copying anything, so an incompatible extension fails
at install time instead of silently missing after the next restart.

Trust is never granted implicitly. An extension signed with an untrusted key is
installed but will not load, and the cmdlet says so; `-Trust` adds the token as
an explicit decision:

```pwsh
Install-PSDataRepositoryExtension -Path .\MyProvider.zip -Trust

# From a registered NuGet repository
Install-PSDataRepositoryExtension -Name Contoso.PSDataRepository.Sftp -Repository Corp

Uninstall-PSDataRepositoryExtension -Name Contoso.PSDataRepository.MyProvider
```

> A **library-shaped** `.nupkg` (`lib/<tfm>/`) installs only its own assemblies and leaves the
> NuGet dependencies unresolved. Publish a **payload** package instead — the layout
> `publish-extension.ps1` produces — which carries the resolved dependency set. The install
> warns when it detects the library shape.

### Shared or private dependencies

By default an extension's dependencies go into the module's `bin/{TFM}/` root, shared with the
host and every other extension. One identity per assembly, which is required for anything whose
types cross the plugin boundary.

An extension can instead keep them to itself:

```xml
<PSDataRepositoryPrivateDependencies>true</PSDataRepositoryPrivateDependencies>
```

which deploys to `bin/{TFM}/{Subfolder}/{AssemblyName}/` together with the `.deps.json` the
loader resolves from. Two extensions can then use different versions of the same library.

**The module root still wins.** A private copy of an assembly the host also ships is never
used — that is what stops a private copy from breaking the host or another extension. So
private mode helps only for libraries the host does not have; for everything else it just adds
files. Reach for it when you actually hit a version conflict in such a library, not before.

### Diagnosing

```powershell
Get-PSDataRepositoryExtension -Rejected              # refused, with the reason
Get-PSDataRepositoryExtension -VersionSkew           # built against X, module ships Y
Get-PSDataRepositoryExtension -MissingAfterUpgrade   # lost when the module was upgraded
```

The last one matters more than it looks: every module version installs into its **own** folder,
so upgrading the module leaves every extension behind. Nothing announces that — the module
works and the in-box providers are all present; only third-party ones are gone.

Rather than reinstalling each one, carry them over from the previous version in a single step:

```powershell
Install-PSDataRepositoryExtension -FromModule PSDataRepository -Version 0.7.1 -Trust
```

That takes the third-party extensions, their dependencies and their trust entries out of the
named older version and installs them here. Extensions signed with the module's own key are
in-box and skipped — they ship with every version. Restart PowerShell afterwards.

---

## 8. Distribution checklist

Before shipping a 3rd-party extension to production:

- [ ] Class library targets the same TFMs as the host module (`net8.0;net10.0`).
- [ ] `<SignAssembly>true</SignAssembly>` with a key kept secret to your team.
- [ ] `<ExtensionSubfolder>` matches the contract you implement.
- [ ] Public-key token shared with the receiving administrator
      (`Get-PSDataRepositoryExtensionToken`).
- [ ] CHANGELOG / release notes for your extension reference the trust list
      requirement so admins don't get a silent "not loaded" experience.
- [ ] No private dependencies overlap with PSDataRepository's runtime
      assemblies (check `bin/{TFM}/` after deploy — do not duplicate
      `PSDataRepository.*` DLLs).
