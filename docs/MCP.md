# PSDataRepository.MCP

Model Context Protocol (MCP) server that exposes the PSDataRepository
provider / auth / formatter ecosystem to LLM‑driven agents and tools.

The server hosts the **same registries** used by the PowerShell module —
`ProviderRegistry`, `AuthenticationRegistry`, `FormatterRegistry` — so any
extension installed for the module is automatically available over MCP without
code changes.

---

## What it exposes

`RepositoryManagementTools` is split into partial files by concern:

| File | Tools |
|---|---|
| `RepositoryManagementTools.cs` | Connection lifecycle, provider/auth discovery |
| `RepositoryManagementTools.Storage.cs` | Get/Set/Remove/List items, Copy |
| `RepositoryManagementTools.Queue.cs` | Send/Receive/Peek messages |
| `RepositoryManagementTools.Secrets.cs` | Set/Get/Remove/List secrets, rotate passphrase |
| `RepositoryManagementTools.Scaffolding.cs` | Generate extension scaffolds |

`RepositoryDocumentationResources.cs` exposes the cmdlet docs as MCP
**resources** so the agent can read them on demand.

Tool input/output schemas are generated **at runtime** from the same
`GetConnectParameters()` / `GetAuthParameters()` definitions that drive
`Connect-PSDataRepository`'s dynamic parameters — so a newly installed
provider extension shows up in the MCP tool list automatically.

---

## Run

```powershell
dotnet run --project src\PSDataRepository.MCP
```

Configuration: `appsettings.json` (binding, JWT, rate limits, HSTS).

---

## Security

- **JWT bearer authentication** — configurable issuer / audience.
- **Per‑client rate limiting**.
- **HSTS** enforced over HTTPS.
- All user‑facing strings localized via `.resx`.

---

## Architecture

See the [Architecture](Architecture.md) doc — the MCP server box at the
bottom of the component graph shares the registries with the in‑process
PowerShell host, which is why extensions installed for the module are
exposed over MCP without code changes.

---

## Related

- [Architecture](Architecture.md)
- [Extensions SDK](Extensions.md)
- [Cmdlets](Cmdlets.md)
