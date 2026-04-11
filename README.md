# PSDataRepository

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](#) [![PowerShell 7.4+](https://img.shields.io/badge/PowerShell-7.4%2B-blue)](#) [![.NET 8 / .NET 10](https://img.shields.io/badge/.NET-8%20%7C%2010-purple)](#) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](#)

**PSDataRepository** is a PowerShell binary module written in C# that provides a **unified, provider-agnostic abstraction** over multiple storage, messaging, and secret management backends. Write your automation scripts once and run them against any supported backend — the only thing that changes is the `Connect-PSDataRepository` call.

---

## Why PSDataRepository?

### The Problem

Modern automation and DevOps workflows frequently need to store configuration, exchange data between systems, and manage secrets. Each backend (Azure Blob Storage, Azure Queue, SCP/SFTP servers, local disk, Key Vault…) comes with its own API, authentication model, and client library. This leads to:

- **Vendor lock-in** — scripts are tightly coupled to a specific storage technology.
- **Duplicated boilerplate** — every script repeats connection setup, serialization, error handling, and retry logic.
- **Inconsistent patterns** — different parameter names, output types, and error models across backends.
- **Difficult testing** — mocking Azure services in CI/CD is hard when your script directly calls Azure SDK classes.

### The Solution

PSDataRepository introduces a single set of cmdlets that work identically regardless of the underlying provider:

```powershell
# Development — local disk, zero dependencies
Connect-PSDataRepository -Provider Disk -Path "C:\Data"
$data | Set-PSDataRepositoryItem -Name "servers.json"

# Production — Azure Blob via Managed Identity, same cmdlet interface
Connect-PSDataRepository -Provider AzureBlob -ManagedIdentity -AccountName "stprod" -ContainerName "data"
$data | Set-PSDataRepositoryItem -Name "servers.json"

# Remote server — SCP/SFTP, same cmdlet interface
Connect-PSDataRepository -Provider Scp -Host "backup.corp.local" -Username "deploy" -PrivateKeyPath "~/.ssh/id_rsa" -RemotePath "/archive"
$data | Set-PSDataRepositoryItem -Name "servers.json"
```

### Key Advantages

| Advantage | Description |
|-----------|-------------|
| **Write once, deploy anywhere** | The same script runs against Disk, Azure Blob, SCP, FTP — zero code changes. |
| **Session-based model** | `Connect-PSDataRepository` establishes a session; all subsequent cmdlets operate within it, eliminating repetitive connection parameters. |
| **12 authentication methods** | ConnectionString, SAS, Managed Identity, Service Principal (Secret + Certificate), Interactive, DeviceCode, DefaultAzureCredential, WorkloadIdentity, SharedTokenCache, plus SSH key and FTP credentials. |
| **Automatic serialization** | Objects serialize/deserialize as JSON, XML, CSV, or YAML with format auto-detection from file extension or content. |
| **AES-256 encryption at rest** | Built-in GZip compression + AES-256-GCM encryption (PBKDF2 600k iterations, SHA-256) to protect sensitive data. |
| **Enterprise-grade resilience** | Configurable retry policies with exponential backoff, proxy support, connection timeouts, and connection validation. |
| **CancellationToken propagation** | Every async provider operation accepts `CancellationToken` for cooperative cancellation, enabling graceful shutdowns. |
| **Structured logging** | Providers accept `ILogger<T>` for structured log output; defaults to `NullLogger` when used stand-alone. |
| **Health checks** | Built-in `IHealthCheck` implementations (`StorageRepositoryHealthCheck`, `SecretRepositoryHealthCheck`) for ASP.NET Core integration. |
| **OpenTelemetry instrumentation** | `ActivitySource` for distributed tracing and `Meter` with counters/histograms for reads, writes, deletes, queue ops, errors, duration, and payload size. |
| **Multi-target** | Runs on .NET 8 (PowerShell 7.4+) and .NET 10 (PowerShell 7.6+), cross-platform (Windows, Linux, macOS). |
| **Pipeline-native** | Full PowerShell pipeline support — pipe from `Get-ChildItem`, `ForEach-Object`, or any cmdlet. |

---

## Supported Providers

| Provider | Capability | Azure Required | Typical Authentication |
|---|---|---|---|
| **AzureBlob** | Storage | Yes | ConnectionString, SAS, MI, SP, Interactive, DeviceCode, DAC, WI, STC |
| **AzureQueue** | Queue | Yes | ConnectionString, SAS, MI, SP, Interactive, DeviceCode, DAC, WI, STC |
| **AzureServiceBus** | Queue | Yes | ConnectionString, MI, SP, DAC |
| **AzureKeyVault** | Secrets | Yes | MI, SP, Interactive, DeviceCode, DAC, WI, STC |
| **Disk** | Storage, Queue, Secrets | No | None (local filesystem); optional `Passphrase` for encrypted secrets |
| **InMemory** | Queue | No | None (volatile, ideal for tests) |
| **Scp** | Storage | No | SSH Username + Password / PrivateKey |
| **Ftp** | Storage | No | FTP Username + Password; optional FTPS (TLS) |

> **MI** = Managed Identity, **SP** = Service Principal (ClientSecret / Certificate), **DAC** = DefaultAzureCredential, **WI** = Workload Identity, **STC** = Shared Token Cache

---

## Cmdlet Reference (20 cmdlets)

### Session Management

| Cmdlet | Description |
|--------|-------------|
| [`Connect-PSDataRepository`](docs/Connect-PSDataRepository.md) | Establishes a session to a data repository provider with dynamic parameters per provider |
| [`Disconnect-PSDataRepository`](docs/Disconnect-PSDataRepository.md) | Closes the active repository session and releases resources |
| [`Get-PSDataRepositorySession`](docs/Get-PSDataRepositorySession.md) | Displays current session information (provider, auth mode, endpoint) |
| [`Get-PSDataRepositoryProvider`](docs/Get-PSDataRepositoryProvider.md) | Lists all supported providers and their capabilities |
| [`Test-PSDataRepositoryConnection`](docs/Test-PSDataRepositoryConnection.md) | Tests connectivity to the current provider |

### Storage Operations

| Cmdlet | Description |
|--------|-------------|
| [`Get-PSDataRepositoryItem`](docs/Get-PSDataRepositoryItem.md) | Retrieves and deserializes items from storage (wildcards, raw, binary) |
| [`Set-PSDataRepositoryItem`](docs/Set-PSDataRepositoryItem.md) | Serializes and saves items (pipeline accumulate, property-based naming) |
| [`Copy-PSDataRepositoryItem`](docs/Copy-PSDataRepositoryItem.md) | Copies local files or intra-repository items (recurse, flatten, filter) |
| [`Remove-PSDataRepositoryItem`](docs/Remove-PSDataRepositoryItem.md) | Deletes items from storage with ShouldProcess support |
| [`Test-PSDataRepositoryItem`](docs/Test-PSDataRepositoryItem.md) | Tests if an item exists in the repository |
| [`Get-PSDataRepositoryChildItem`](docs/Get-PSDataRepositoryChildItem.md) | Lists child items with rich metadata (Name, Size, LastModified, ContentType) |
| [`Compress-PSDataRepositoryItem`](docs/Compress-PSDataRepositoryItem.md) | Compresses items with optional AES-256-GCM encryption |
| [`Expand-PSDataRepositoryItem`](docs/Expand-PSDataRepositoryItem.md) | Decompresses and optionally decrypts items |

### Messaging Operations

| Cmdlet | Description |
|--------|-------------|
| [`Send-PSDataRepositoryMessage`](docs/Send-PSDataRepositoryMessage.md) | Sends serialized objects to a queue with batching support |
| [`Receive-PSDataRepositoryMessage`](docs/Receive-PSDataRepositoryMessage.md) | Receives and deserializes messages (peek, continuous, batch) |
| [`Remove-PSDataRepositoryMessage`](docs/Remove-PSDataRepositoryMessage.md) | Deletes processed messages from the queue |
| [`ConvertFrom-PSDataRepositoryMessage`](docs/ConvertFrom-PSDataRepositoryMessage.md) | Deserializes a raw message string (e.g. from Azure Function trigger) |

### Secret Management

| Cmdlet | Description |
|--------|-------------|
| [`Get-PSDataRepositorySecret`](docs/Get-PSDataRepositorySecret.md) | Retrieves a secret value from the connected repository |
| [`Set-PSDataRepositorySecret`](docs/Set-PSDataRepositorySecret.md) | Creates or updates a secret |
| [`Remove-PSDataRepositorySecret`](docs/Remove-PSDataRepositorySecret.md) | Deletes a secret from the connected repository |

> Full module documentation: [PSDataRepository Module](docs/PSDataRepository.md)

---

## Quick Start

### Installation

```powershell
# From PowerShell Gallery
Install-Module -Name PSDataRepository -Scope CurrentUser

# From Azure Artifacts feed
Register-PSRepository -Name 'PSDataRepositoryFeed' -SourceLocation '<your-feed-url>'
Install-Module -Name PSDataRepository -Repository 'PSDataRepositoryFeed'
```

### Local Development (Disk)

```powershell
Connect-PSDataRepository -Provider Disk -Path "C:\AutomationData"

# Save structured data
$servers = @(
    [PSCustomObject]@{ Id = 1; Name = "Server01"; Status = "Running" }
    [PSCustomObject]@{ Id = 2; Name = "Server02"; Status = "Stopped" }
)
$servers | Set-PSDataRepositoryItem -Name "servers.json"

# Read it back
$data = Get-PSDataRepositoryItem -Name "servers.json"

# List items with metadata
Get-PSDataRepositoryChildItem -Filter "*.json" | Format-Table Name, Size, LastModified

Disconnect-PSDataRepository
```

### Azure Blob Storage (Managed Identity)

```powershell
Connect-PSDataRepository -Provider AzureBlob -ManagedIdentity -AccountName "stprod" -ContainerName "data"

# Identical cmdlets — different backend
$servers | Set-PSDataRepositoryItem -Name "servers.json"
$data = Get-PSDataRepositoryItem -Name "servers.json"

Disconnect-PSDataRepository
```

### SCP/SFTP (SSH Key)

```powershell
Connect-PSDataRepository -Provider Scp -Host "backup.corp.local" -Username "deploy" -PrivateKeyPath "~/.ssh/id_rsa" -RemotePath "/archive"

# Upload files from local disk
Get-ChildItem C:\Reports -Filter "*.csv" | Copy-PSDataRepositoryItem -Destination "reports/"

Disconnect-PSDataRepository
```

### FTP/FTPS

```powershell
Connect-PSDataRepository -Provider Ftp -Host "ftp.vendor.com" -Username "upload" -Password $ftpPwd -UseSsl

Set-PSDataRepositoryItem -InputObject $export -Name "daily-export.json"

Disconnect-PSDataRepository
```

### Queue Messaging

```powershell
Connect-PSDataRepository -Provider AzureQueue -DefaultAzureCredential -AccountName "stprod" -QueueName "tasks"

# Send objects with batching
1..10000 | ForEach-Object { [PSCustomObject]@{Id=$_; Task="Item$_"} } | Send-PSDataRepositoryMessage -BatchSize 500

# Receive and process
$messages = Receive-PSDataRepositoryMessage -MaxMessages 50
$messages | ForEach-Object { Process-Task $_ }

Disconnect-PSDataRepository
```

### Azure Key Vault — Secret Management

```powershell
Connect-PSDataRepository -Provider AzureKeyVault -ManagedIdentity -VaultName "mykeyvault"

Set-PSDataRepositorySecret -Name "ApiKey" -Value "super-secret-value"
$secret = Get-PSDataRepositorySecret -Name "ApiKey"
Remove-PSDataRepositorySecret -Name "ApiKey"

Disconnect-PSDataRepository
```

### Compression & Encryption

```powershell
Connect-PSDataRepository -Provider Disk -Path "C:\SecureData"

$pwd = Read-Host -AsSecureString "Encryption password"

# Compress + encrypt (AES-256-GCM, PBKDF2 600k iterations)
Compress-PSDataRepositoryItem -Name "sensitive.json" -Password $pwd

# Decrypt + decompress
Expand-PSDataRepositoryItem -Name "sensitive.json.gz.enc" -Password $pwd

Disconnect-PSDataRepository
```

### Copy Files to Repository

```powershell
Connect-PSDataRepository -Provider AzureBlob -DefaultAzureCredential -AccountName "stprod" -ContainerName "uploads"

# Upload a directory recursively
Copy-PSDataRepositoryItem -Path "C:\Export\" -Recurse -Destination "export/"

# Upload filtered files, flatten structure
Get-ChildItem C:\Logs -Recurse -File -Filter "*.log" | Copy-PSDataRepositoryItem -Destination "logs/" -Flatten

# Intra-repository copy
Get-PSDataRepositoryChildItem -Path "staging/" | Copy-PSDataRepositoryItem -Destination "production/"

Disconnect-PSDataRepository
```

---

## Enterprise Features

| Feature | Parameter | Description |
|---------|-----------|-------------|
| **Proxy Support** | `-ProxyUri "http://proxy.corp:8080"` | Route all traffic through a corporate HTTP proxy |
| **Retry with Backoff** | `-MaxRetries 5 -RetryDelaySeconds 2 -MaxRetryDelaySeconds 60` | Automatic retry with exponential backoff on transient failures |
| **Connection Timeout** | `-TimeoutSeconds 30` | Timeout for connection and individual operations |
| **Connection Validation** | `-TestConnection` | Validates connectivity immediately after `Connect-PSDataRepository` |
| **CancellationToken** | (internal) | All async operations propagate `CancellationToken` for cooperative cancellation |
| **Structured Logging** | (internal) | `ILogger<T>` injected into providers; works with any `Microsoft.Extensions.Logging` sink |
| **Health Checks** | `StorageRepositoryHealthCheck` / `SecretRepositoryHealthCheck` | `IHealthCheck` implementations for ASP.NET Core health endpoints |
| **OpenTelemetry** | `PSDataRepository` ActivitySource + Meter | Distributed tracing spans, counters (reads/writes/deletes/errors), histograms (duration/payload size) |

---

## Serialization Formats

| Format | Parameter | Auto-Detection |
|--------|-----------|----------------|
| JSON | `-Format Json` | `.json` extension, or content starting with `{` / `[` |
| XML | `-Format Xml` | `.xml` extension, or content starting with `<` |
| CSV | `-Format Csv` | `.csv` extension, or header row heuristic |
| YAML | `-Format Yml` | `.yml` / `.yaml` extension, or `---` / `key: value` content pattern |

When no format is specified, the module auto-detects from the file extension or content. You can always override with `-Format`.

---

## Encryption

PSDataRepository supports three encryption versions for backward compatibility:

| Version | Algorithm | Key Derivation | Iterations | Status |
|---------|-----------|----------------|------------|--------|
| V3 (current) | AES-256-GCM | PBKDF2-SHA256 | 600,000 | **Default for new data** |
| V2 | AES-256-GCM | PBKDF2-SHA256 | 100,000 | Read-only (backward compat) |
| V1 | AES-256-CBC | PBKDF2-SHA256 | 100,000 | Read-only (backward compat) |

All versions are auto-detected when reading, so older encrypted files remain accessible.

---

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                   PowerShell Cmdlets (20)                │
│  Connect / Get / Set / Copy / Remove / Test / Compress   │
│  Send / Receive / Secret / ChildItem / Provider / ...    │
└──────────────────────┬───────────────────────────────────┘
                       │ SessionManager (ThreadStatic)
┌──────────────────────▼───────────────────────────────────┐
│                Provider Interfaces                       │
│  IStorageRepository · IFilesystemStorageRepository       │
│  IMetadataStorageRepository · IQueueRepository           │
│  ISecretRepository                                       │
└──────────────────────┬───────────────────────────────────┘
                       │
┌──────────────────────▼───────────────────────────────────┐
│               Provider Implementations                   │
│  AzureBlob │ AzureQueue │ AzureServiceBus │ AzureKeyVault│
│  Disk      │ InMemory   │ Scp (SSH.NET)   │ Ftp (Fluent) │
└──────────────────────────────────────────────────────────┘
```

---

## Requirements

| Requirement | Minimum |
|---|---|
| **PowerShell** | 7.4+ (Core edition) |
| **.NET Runtime** | .NET 8 or .NET 10 |
| **OS** | Windows, Linux, macOS |
| **Dependencies** | All bundled in module (Azure SDK, SSH.NET, FluentFTP, FluentStorage) |

---

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Author

**Ondrej Kracmar** — [i-System](https://www.i-system.cz)
