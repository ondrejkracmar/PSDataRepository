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

# Providers — yours should be listed
Get-PSDataRepositoryProvider

# Connect via your provider
Connect-PSDataRepository -Provider Contoso -ContosoConnectionString '...'
```

If the provider does not appear, run with debug tracing:

```pwsh
# Capture the loader diagnostics (they go through Debug.WriteLine).
# Use DebugView (Sysinternals) or attach a debugger to pwsh.
```

Common reasons an extension is silently skipped (visible in the diagnostics):

| Diagnostic                                       | Fix                                                                  |
| ------------------------------------------------ | -------------------------------------------------------------------- |
| `Skipping unsigned assembly '...'`               | Set `<SignAssembly>true</SignAssembly>` and supply an SNK key.       |
| `Skipping assembly '...' — public key token not trusted` | Add the token to `extensions.trust.json` and restart pwsh.   |
| `Plugin directory not found: ...`                | Wrong `<ExtensionSubfolder>` or missing local-deploy.                |
| `Failed to load '...': ...FileNotFoundException` | A runtime dependency was filtered out — verify `bin/{TFM}/` content. |

---

## 6. Distribution checklist

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
