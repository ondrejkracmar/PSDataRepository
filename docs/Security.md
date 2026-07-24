# Security Model

This document describes the security architecture of PSDataRepository: what is protected,
by which mechanism, and — equally important — what each mechanism does **not** protect against.

## 1. Plugin trust (extension loading)

Plugins (providers, authentication handlers, formatters) are loaded from the `Providers/`,
`Auth/` and `Formatters/` subfolders next to the module. Loading is **fail-closed**:

| Check | Rule | Failure behavior |
|-------|------|------------------|
| S-1 Strong-name token | The candidate DLL's public key token must match the Core SNK token or an admin-trusted token. Verified with `MetadataReader` **before** any code from the DLL can execute. | DLL skipped |
| S-1a Host integrity | If `PSDataRepository.Core.dll` itself is not strong-named, plugin loading is disabled entirely. | All plugins refused |
| S-2 Path containment | The DLL must physically reside inside the module directory tree. | DLL skipped |
| Trust extension | Additional third-party tokens can be trusted via the `extensions.trust.json` sidecar (admin-controlled, malformed file = no extra trust). | No extra trust |

Each plugin folder gets its own `AssemblyLoadContext`; contract assemblies (`PSDataRepository.*`)
are delegated to the default context to preserve type identity.

## 2. Strong-name key (SNK) threat model — read this before relying on S-1

`src/PSDataRepository/PSDataRepository.snk` (the **private** key) is checked into this
repository so that any developer can build and run the module locally.

**Consequence:** anyone with *read access to this repository* can sign an arbitrary assembly
with the project identity and have it pass the S-1 trust check. Within this threat model,
strong-naming provides:

- ✅ Protection against **opportunistic DLL drops** by actors *without* repo access
  (malware writing into the module folder, supply-chain tampering of the published package).
- ✅ Tamper evidence — a modified signed assembly fails signature validation at load.
- ❌ **No** protection against a malicious or compromised insider with repo read access.

### Hardening options (in increasing order of assurance)

1. **CI key injection (supported now).** `AssemblyOriginatorKeyFile` in
   `src/Directory.Build.props` is conditional — the release pipeline can inject a
   production SNK from Azure DevOps Secure Files / Key Vault:
   `dotnet build /p:AssemblyOriginatorKeyFile=$(DownloadSecureFile.secureFilePath)`.
   ⚠️ Rotating the key changes the public key token: existing `extensions.trust.json`
   entries and third-party plugins signed against the old identity must be re-trusted/re-built.
2. **Authenticode signing** of the published module (`Set-AuthenticodeSignature`, a code-signing
   certificate). Orthogonal to strong-naming; verified by PowerShell execution policies and
   PSGallery, and the private key never needs to live in the repo.
3. **Both** — strong-name for load-time plugin identity, Authenticode for distribution trust.

## 3. Data-at-rest encryption

| Format | Algorithm | KDF | Status |
|--------|-----------|-----|--------|
| V5 | AES-256-GCM (authenticated) | **Argon2id** (m=19 MiB, t=2, p=1 — OWASP baseline) | **Current write format** |
| V4 | AES-256-GCM (authenticated) | PBKDF2-SHA512, 210k iterations | Read-only |
| V3 | AES-256-GCM | PBKDF2-SHA256, 600k iterations | Read-only |
| V2 | AES-256-GCM | PBKDF2-SHA256, 100k iterations | Read-only |
| V1 | AES-256-CBC (**no integrity protection**) | PBKDF2 | Read-only, **deprecated** — emits a runtime warning; scheduled for removal in the next major version. Re-encrypt with `Compress-PSDataRepositoryItem`. |

Argon2id (V5) is memory-hard: each password guess costs ~19 MiB of working memory, which
defeats the GPU/ASIC parallelism that makes PBKDF2 brute-forceable at scale. Implementation:
`Konscious.Security.Cryptography.Argon2` (MIT).

Secrets stored by the Disk provider use AES-256-GCM with a master key derived via
PBKDF2-SHA256 (600k iterations) from a user passphrase; per-secret random nonces;
passphrase rotation via `Update-PSDataRepositoryMasterPassphrase`.

Key material handling: passphrases travel as `SecureString`, are converted to bytes without
intermediate managed strings (`SecureStringHelper.ToPlainBytes`), and buffers are zeroed
(`CryptographicOperations.ZeroMemory`) after use.

## 4. MCP host (HTTP surface)

The MCP server exposes full CRUD on storage, queues and secrets and is therefore secured
fail-closed:

- JWT Bearer authentication; unconfigured = tokens cannot validate (no anonymous fallback).
- Authorization policy requiring the `psdr.mcp` scope/role (configurable via `Mcp:RequiredScope`).
- HSTS + permanent HTTPS redirect, per-user sliding-window rate limiting.

## 5. Dependency security

- **NuGet Audit gate:** `NuGetAuditMode=all` with NU1901–NU1904 elevated to errors in
  `src/Directory.Build.props`. Every restore (local and CI) fails if any direct or
  transitive package has a known advisory on the configured sources.
- Central Package Management with transitive pinning; single `nuget.org` source with
  `<clear />` to prevent source-confusion attacks.
- License note: `FluentAssertions` is pinned to the 7.x line (Apache-2.0). 8.x+ requires a
  commercial Xceed license — do not bump without a licensing decision.

## 6. Reporting

Report suspected vulnerabilities through the repository owners (see `.github/CODEOWNERS`);
do not open public work items containing exploit details.
