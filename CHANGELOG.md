# Changelog

All notable changes to the **PSDataRepository** module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Security

- **Fail-closed plugin loader.** `ExtensionLoader` now refuses to load any plugin assembly when
  `PSDataRepository.Core.dll` itself is not strong-named. Previously, an unsigned Core would
  silently bypass the public-key-token check and accept any DLL dropped into the plugin folders.
- **Pre-load metadata trust check.** Plugin DLLs are now inspected with `MetadataReader` /
  `PEReader` to verify their public key token *before* `LoadFromAssemblyPath`. This prevents
  static initializers in untrusted assemblies from running before the trust decision is made.
- **AssemblyLoadContext per plugin folder.** Each plugin subfolder (`Providers/`, `Auth/`,
  `Formatters/`) is loaded into its own `AssemblyLoadContext` (`ExtensionLoadContext`). Shared
  contracts (`PSDataRepository.*`) are delegated to the Default ALC so type identity is
  preserved across boundaries. Isolates plugin dependency versions from each other and from
  the host (DLL hell mitigation).
- **Pattern restriction is no longer a trust boundary.** The scanner now considers all `*.dll`
  files in plugin subfolders, not just `PSDataRepository.{Providers,Authentications,Formatters}.*.dll`.
  The SNK token check remains the sole authority for what gets loaded.
- **Force-with-lease for GitHub publish.** `vsts-publishToGitHub.ps1` now uses
  `git push --force-with-lease` instead of `--force`. Token prefix is no longer logged.

### Added

- **`Get-PSDataRepositoryExtensionToken` cmdlet.** Reads the strong-name public
  key token from a .NET assembly (without loading it for execution) and emits it
  in the lowercase-hex format used by `extensions.trust.json`. Pipeline-friendly
  (`Get-ChildItem *.dll | Get-PSDataRepositoryExtensionToken`). Designed for
  administrators who add 3rd-party extensions to the trust list — see
  `docs/Extensions.md`.
- **`docs/Extensions.md` author guide.** End-to-end walkthrough for 3rd-party
  extension authors: csproj template, contract examples (provider /
  authentication / formatter), strong-naming, local deploy via
  `<PSDataRepositoryModuleDir>`, trust-list onboarding, troubleshooting matrix,
  distribution checklist.
- **3rd-party extension SDK.** `PSDataRepository.Extensions.Sdk` NuGet meta-package
  now ships compile-time references to the four contract assemblies plus
  auto-imported MSBuild targets (`build/` + `buildMultiTargeting/`) that validate
  `<ExtensionSubfolder>` (Providers / Auth / Formatters), warn on unsigned output
  (PSDR1003), and optionally deploy the built DLL into an installed module via
  `<PSDataRepositoryModuleDir>`. External plugin authors can now build extensions
  without forking the repo.
- **Administrator-managed trust list.** New `extensions.trust.json` sidecar
  (next to `PSDataRepository.psd1`) lets an administrator extend the SNK trust
  set beyond Core's own token. `ExtensionLoader.LoadTrustedTokensFromFile` and
  `ExtensionLoader.AddTrustedToken` are public; `LoadAll` reads the file
  automatically before scanning. The Core token remains implicitly trusted —
  the file only **adds** trust. Documented in `SECURITY.md` § *Trusting 3rd-party
  extensions*.
- **CryptoHelper V4 format.** New AES-GCM encryption format using **PBKDF2-SHA512** with
  **210 000** iterations (OWASP 2023). All new encryption uses V4 by default. V3 (SHA-256, 600k),
  V2 (SHA-256, 100k) and V1 (AES-CBC, legacy) remain readable for backward compatibility.
- **`ConnectContext.From(IDictionary<string, object?>, IAuthenticationInfo, string)` factory.**
  Allows non-PowerShell callers (MCP host, unit tests) to construct a `ConnectContext` without
  `RuntimeDefinedParameterDictionary`. Keys matched case-insensitively. Implementation deliberately
  isolates `System.Management.Automation` types so the factory works in environments where SMA is
  not loaded.
- **Centralized `ErrorIds` constants.** New `PSDataRepository.Commands.Common.ErrorIds` exposes
  34 named error IDs. All cmdlets refactored to reference these constants. The
  `FullyQualifiedErrorId` surface is unchanged.
- **`ProviderNameCompleter`.** Argument completer for `-Provider` on `Connect-PSDataRepository`.
- **`IModuleAssemblyCleanup`.** `ModuleInitializer` now also implements cleanup, mirroring the
  `OnRemove` handler in `PSDataRepository.psm1` so the module is also tidy when imported directly.
- **`SECURITY.md`, `CONTRIBUTING.md`, `.github/CODEOWNERS`, `.github/dependabot.yml`** for governance.
- **Test coverage.** New tests for `CryptoHelper` (V3-read-after-V4-write, tamper detection,
  null/empty validation), `ConnectContext.From()`, and an integration suite for `ExtensionLoader`
  (genuine plugin acceptance, foreign DLL rejection, all-DLL scanning, idempotency). Test count
  grew from 42 → 88 across `net8.0` + `net10.0`.

### Changed

- **Unified solution versioning (psd1 + assemblies).** `Directory.Build.props`
  now centrally controls `Version`, `AssemblyVersion`, `FileVersion`, and
  `InformationalVersion` for all 17 csproj projects (Core, Abstractions,
  Commands, Authentications, Formatters, Providers, plugins, and Sdk).
  Local builds use the placeholder values `0.0.0`, `0.0.0.0`, and
  `0.0.0+local`, aligned with `ModuleVersion` in `PSDataRepository.psd1`.
  In Azure DevOps, the GitVersion step computes the final values and
  `azure-pipelines.yml` passes `MajorMinorPatch`, `AssemblySemVer`,
  `AssemblySemFileVer`, and `InformationalVersion` to
  `vsts-build-library.ps1`, which forwards them to `dotnet build` through
  `/p:Version`, `/p:AssemblyVersion`, `/p:FileVersion`, and
  `/p:InformationalVersion`. `vsts-build.ps1` stamps the psd1 manifest with
  the same scheme. Ad-hoc local release-like builds remain possible via
  `dotnet build -p:Version=1.2.3 -p:AssemblyVersion=1.2.3.0`.
- **`AsyncHelper.RunSync` simplified.** Removed `Task.Run` thread-hop; calls
  `ConfigureAwait(false).GetAwaiter().GetResult()` directly. PowerShell hosts have no
  `SynchronizationContext` so behavior is unchanged.
- **`RetryHelper` cancellation handling.** Added cancellation filter so `OperationCanceledException`
  no longer triggers retries.
- **`Connect-PSDataRepository`** validates parameter ambiguity and warns when both `-Auth*`
  parameters and `-AuthMode Auto` are supplied.
- **`Set-PSDataRepositorySecret`** now declares `ConfirmImpact = High`.
- **PowerShell module hygiene.** `ProjectUri`, `IconUri`, `ReleaseNotes`, cleaner `Tags`;
  rewritten `psm1` with framework-aware bin selection and `OnRemove` handler.
- **Pipeline.** Added `pr:` trigger; collected `XPlat Code Coverage` on `dotnet test`;
  removed redundant Linux-only condition.
- **Documentation.** Added XML doc on `CryptoHelper.Encrypt()` clarifying caller's
  responsibility to wipe the plaintext buffer (`CryptographicOperations.ZeroMemory`).
- **Module build pipeline.** `PSDataRepository.csproj` no longer post-processes `OutputPath`
  with a hardcoded 26-entry delete list. The SDK's own copy-local step is filtered upstream
  via `BeforeTargets="_CopyFilesMarkedCopyLocal"`, removing PowerShell host / VS / CIM / Roslyn
  transitive DLLs *before* they are copied. Single source of truth shared in spirit with
  `Directory.Build.targets / CopyPluginToModuleOutput`. `bin/{TFM}/` layout is unchanged.

### Removed

- **Pinned `System.Diagnostics.DiagnosticSource`** in central package management. It forced one
  version into every plugin's bin folder, conflicting with what PowerShell 7.4 / 7.6 ship.
  Azure.Core brings in a compatible version transitively.
- **Dead `try/catch` in `Get-PSDataRepositoryItem.ProcessRecord`** that swallowed nothing
  meaningful (inner code already handled its own errors).
- **Dead OOM/SOE catch filter** in `RetryHelper`.
- **Hardcoded plugin filename pattern**. Replaced by all-`*.dll` scanning + token-based trust check.
- **`AppDomain.AssemblyResolve` handler** in `ExtensionLoader`. Replaced by `ExtensionLoadContext`
  (one per plugin subfolder).

### Deferred

- Migrate from PBKDF2-SHA512 to **Argon2id** (would add `Konscious.Security.Cryptography.Argon2`).
- Move the SNK private key out of the repository to a Key Vault sign-on-build flow.
- Downgrade `global.json` to a stable .NET SDK once .NET 10 GA is widely available in CI.

## [Initial draft]

### Added
- Extension-based architecture for providers, authentication, and formatters
- `PSDataRepository.Extensions.Sdk` for building and deploying custom extensions into an installed module
- `IProviderDefinition`, `BaseProviderSession`, `IAuthenticationInfo`, and `IFormatterDefinition`-based extension model
- Multi-target build for .NET 8 (PowerShell 7.4+) and .NET 10 (PowerShell 7.6+)
- TFM-aware module loader (`PSDataRepository.psm1`) — automatically selects the correct assembly
- `Compress-PSDataRepositoryItem` — GZip compression with optional AES-256 encryption
- `Expand-PSDataRepositoryItem` — decompression with optional AES-256 decryption
- `Connect-PSDataRepository` — 12 authentication methods including Managed Identity, Workload Identity, DefaultAzureCredential, Client Certificate, Interactive Browser, Device Code, Shared Token Cache, SAS Token, and Connection String
- `Disconnect-PSDataRepository` — session cleanup with resource disposal
- `Get-PSDataRepositoryItem` — retrieval with wildcard support and auto-deserialization (JSON, XML, CSV)
- `Set-PSDataRepositoryItem` — pipeline-aware storage with configurable serialization
- `Remove-PSDataRepositoryItem` — item deletion with confirmation support
- `Test-PSDataRepositoryItem` — existence check for stored items
- `Test-PSDataRepositoryConnection` — lightweight connectivity probe
- `Get-PSDataRepositorySession` — session introspection (provider, auth mode, endpoint)
- `Get-PSDataRepositoryProvider` — provider enumeration with capability filtering
- `Send-PSDataRepositoryMessage` — queue messaging with batching (up to 1000 per batch)
- `Receive-PSDataRepositoryMessage` — message retrieval with peek, continuous polling, and auto-delete modes
- `Remove-PSDataRepositoryMessage` — explicit message deletion/acknowledgement
- `ConvertFrom-PSDataRepositoryMessage` — standalone message deserialization (e.g. for Azure Function triggers)
- `Get-PSDataRepositorySecret` — secret retrieval from Key Vault or filesystem
- `Set-PSDataRepositorySecret` — secret creation/update with SecureString support
- `Remove-PSDataRepositorySecret` — secret deletion with confirmation
- Enterprise features: proxy support, configurable retry policies, connection timeouts
- Six providers: Disk, InMemory, AzureBlob, AzureQueue, AzureServiceBus, AzureKeyVault
- CI/CD pipeline with Azure DevOps: build, test, NuGet packaging, Azure Artifacts, PlatyPS documentation generation, PSGallery publishing, GitHub compiled module publishing
- PlatyPS-generated markdown and MAML help for all cmdlets
