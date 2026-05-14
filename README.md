# PSDataRepository

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](#)
[![PowerShell 7.4+](https://img.shields.io/badge/PowerShell-7.4%2B-blue)](#)
[![.NET 8 / .NET 10](https://img.shields.io/badge/.NET-8%20%7C%2010-purple)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](#)

A unified PowerShell module for **storage, queues, and secrets** across many
backends — **Azure Blob, Azure Queue, Azure Service Bus, Azure Key Vault,
Disk, In‑Memory, SCP/SFTP, FTP/FTPS** — behind a single set of cmdlets.
Pluggable via `PSDataRepository.Extensions.Sdk`, observable via
OpenTelemetry, and exposed to LLM agents via an MCP server.

> **Write your automation scripts once and run them against any supported
> backend — the only thing that changes is the `Connect-PSDataRepository`
> call.**

```powershell
# Development — local disk
Connect-PSDataRepository -Provider Disk -Path "C:\Data"
$data | Set-PSDataRepositoryItem -Name "servers.json"

# Production — Azure Blob via Managed Identity, same cmdlets
Connect-PSDataRepository -Provider AzureBlob -ManagedIdentity -AccountName "stprod" -ContainerName "data"
$data | Set-PSDataRepositoryItem -Name "servers.json"
```

---

## 📚 Documentation

Detailed docs live under [`docs/`](docs/).

| Topic | Doc |
|---|---|
| 🚀 **Quick start** (install + per‑provider examples) | [`docs/QuickStart.md`](docs/QuickStart.md) |
| 🧩 **Architecture** (component graph, ALCs, AzAuth, MCP) | [`docs/Architecture.md`](docs/Architecture.md) |
| 🔌 **Providers** (capabilities & supported auth modes) | [`docs/Providers.md`](docs/Providers.md) |
| 📜 **Cmdlet reference** (20 cmdlets) | [`docs/Cmdlets.md`](docs/Cmdlets.md) |
| 📦 **Extensions SDK** (build your own provider/auth/formatter) | [`docs/Extensions.md`](docs/Extensions.md) |
| 🤖 **MCP server** (LLM agent integration) | [`docs/MCP.md`](docs/MCP.md) |
| 📈 **Observability, formats & encryption** | [`docs/Observability.md`](docs/Observability.md) |

---

## 🗺️ Architecture at a glance

```
┌────────────────────────────────────────────────────────────────┐
│  PowerShell host  (.NET 8 / .NET 10)                           │
│                                                                │
│   Cmdlets ──▶ Shared Registries ──▶ Per‑subfolder ALCs        │
│                (Provider / Auth / Formatter)                   │
│                          │                                     │
│                          ▼                                     │
│                AzureAuthResolver ──> Isystem.AzAuth.Core       │
│                                      + Azure.Identity          │
│                          │                                     │
│                          ▼                                     │
│                 Cloud SDK clients · SSH · FTP                  │
└──────────────────────────────┬─────────────────────────────────┘
                               │ (same registries)
                  ┌────────────┴────────────────┐
                  │ PSDataRepository.MCP server │
                  └─────────────────────────────┘
```

Full graph + extension loading flow + trust model:
**[`docs/Architecture.md`](docs/Architecture.md)**.

---

## ✨ Highlights

- **Write once, deploy anywhere** — the same script runs against Disk, Azure
  Blob, SCP, FTP — zero code changes.
- **Session‑based model** — `Connect-PSDataRepository` once, all subsequent
  cmdlets operate within that session.
- **12 authentication methods** — ConnectionString, SAS, Managed Identity,
  Service Principal (Secret + Certificate), Interactive, DeviceCode,
  DefaultAzureCredential, WorkloadIdentity, SharedTokenCache, plus SSH key
  and FTP credentials.
- **Automatic serialization** — JSON, XML, CSV, YAML with format
  auto‑detection.
- **AES‑256‑GCM encryption at rest** — GZip + AES‑256‑GCM, PBKDF2‑SHA256
  with 600 000 iterations.
- **Enterprise‑grade resilience** — retries with exponential backoff, proxy
  support, timeouts, connection validation, `CancellationToken` propagation.
- **Health checks** — `IHealthCheck` implementations for ASP.NET Core.
- **OpenTelemetry instrumentation** — `ActivitySource` + `Meter` named
  `PSDataRepository`.
- **Extension architecture** — drop a signed DLL into `Providers\`, `Auth\`,
  or `Formatters\`; the module composes parameters, authentication, and
  serialization automatically.
- **MCP server** — same registries exposed to LLM agents; new extensions are
  picked up without code changes.
- **Multi‑target** — .NET 8 (PowerShell 7.4+) and .NET 10 (PowerShell 7.6+),
  Windows / Linux / macOS.

---

## 📋 Requirements

| Requirement | Version |
|---|---|
| PowerShell | 7.4+ (uses .NET 8 binaries) or 7.6+ (uses .NET 10 binaries) |
| .NET runtime | .NET 8 or .NET 10 |
| OS | Windows, Linux, macOS |

---

## 📄 License

MIT — see [`LICENSE`](LICENSE).

## 👤 Author

Ondrej Kracmar — i‑System
