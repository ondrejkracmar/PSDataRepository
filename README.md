# PSDataRepository

A PowerShell module for working with data repositories (FileSystem, Azure Blob Storage, Azure Queue Storage, Azure Service Bus, Azure Key Vault, and InMemory) using a unified, session-based approach.

## Features

- **Unified API** — single set of cmdlets for all supported providers
- **Session-based** — `Connect-PSDataRepository` establishes a session, all subsequent cmdlets operate within it
- **12 authentication methods** — connection strings, SAS tokens, Managed Identity, client secrets/certificates, interactive browser, device code, DefaultAzureCredential, workload identity, shared token cache, and local (Disk/InMemory) providers that require no authentication
- **Automatic serialization** — objects are serialized/deserialized as JSON, XML, or CSV with auto-detection
- **Compression & encryption** — GZip compression with optional AES-256 encryption for stored items
- **Queue messaging** — send, receive, peek, and delete messages with batching support
- **Secret management** — get, set, and remove secrets in Azure Key Vault or filesystem
- **Enterprise-ready** — proxy support, configurable retry policies, connection timeouts
- **Multi-target** — runs on .NET 8 (PowerShell 7.4+) and .NET 10 (PowerShell 7.6+)

## Installation

### From PowerShell Gallery

```powershell
Install-Module -Name PSDataRepository -Scope CurrentUser
```

### From NuGet (Azure Artifacts)

```powershell
Register-PSRepository -Name 'PSDataRepositoryFeed' -SourceLocation '<your-feed-url>'
Install-Module -Name PSDataRepository -Repository 'PSDataRepositoryFeed'
```

## Quick Start

### Local disk storage

```powershell
# Connect to a local disk repository
Connect-PSDataRepository -Disk -Path "C:\Data\MyRepo"

# Save data
$servers = @(
    [PSCustomObject]@{ Id = 1; Name = "Server01"; Status = "Running" }
    [PSCustomObject]@{ Id = 2; Name = "Server02"; Status = "Stopped" }
)
$servers | Set-PSDataRepositoryItem -Name "servers.json"

# Read data back
$data = Get-PSDataRepositoryItem -Name "servers.json"

# Disconnect
Disconnect-PSDataRepository
```

### Azure Blob Storage

```powershell
# Connect using DefaultAzureCredential
Connect-PSDataRepository -DefaultAzureCredential -AccountName "mystorageaccount" -ContainerName "mydata"

# Save and retrieve items
@{ Version = "1.0"; Environment = "Production" } | Set-PSDataRepositoryItem -Name "config.json"
$config = Get-PSDataRepositoryItem -Name "config.json"

Disconnect-PSDataRepository
```

### Azure Queue Storage

```powershell
# Connect to a queue
Connect-PSDataRepository -ConnectionString $connStr -QueueName "tasks"

# Send messages
$tasks | Send-PSDataRepositoryMessage -Format Json -BatchSize 500

# Receive and process
$messages = Receive-PSDataRepositoryMessage -MaxMessages 10
$messages | ForEach-Object { Process-Task $_ }

Disconnect-PSDataRepository
```

### Azure Key Vault

```powershell
# Connect to Key Vault
Connect-PSDataRepository -ManagedIdentity -VaultName "mykeyvault"

# Manage secrets
Set-PSDataRepositorySecret -Name "ApiKey" -Value "secret-value-here"
$secret = Get-PSDataRepositorySecret -Name "ApiKey"
Remove-PSDataRepositorySecret -Name "ApiKey"

Disconnect-PSDataRepository
```

### Compression & encryption

```powershell
# Compress a large file
Compress-PSDataRepositoryItem -Name "largefile.json"

# Compress and encrypt with password
$pwd = Read-Host -AsSecureString "Password"
Compress-PSDataRepositoryItem -Name "sensitive.json" -Password $pwd

# Decompress (and decrypt)
Expand-PSDataRepositoryItem -Name "sensitive.json.gz.enc" -Password $pwd
```

## Supported Providers

| Provider | Capabilities | Authentication |
|---|---|---|
| **Disk** | Storage | None (local filesystem) |
| **InMemory** | Queue | None (volatile, for testing) |
| **AzureBlob** | Storage | ConnectionString, SAS, Managed Identity, Client Secret/Certificate, Interactive, DeviceCode, DefaultAzureCredential, Workload Identity, Shared Token Cache |
| **AzureQueue** | Queue | ConnectionString, SAS, Managed Identity, Client Secret/Certificate, Interactive, DeviceCode, DefaultAzureCredential, Workload Identity, Shared Token Cache |
| **AzureServiceBus** | Queue | ConnectionString, Managed Identity, Client Secret/Certificate, DefaultAzureCredential |
| **AzureKeyVault** | Secrets | Managed Identity, Client Secret/Certificate, Interactive, DeviceCode, DefaultAzureCredential, Workload Identity, Shared Token Cache |

Use `Get-PSDataRepositoryProvider` to list all providers and filter by capability:

```powershell
Get-PSDataRepositoryProvider
Get-PSDataRepositoryProvider -Capability Queue
Get-PSDataRepositoryProvider -Name AzureBlob
```

## Cmdlet Reference

### Connection

| Cmdlet | Description |
|---|---|
| [Connect-PSDataRepository](docs/cmdlets/PSDataRepository/Connect-PSDataRepository.md) | Establishes a session to a data repository provider |
| [Disconnect-PSDataRepository](docs/cmdlets/PSDataRepository/Disconnect-PSDataRepository.md) | Closes the active repository session and releases resources |
| [Get-PSDataRepositorySession](docs/cmdlets/PSDataRepository/Get-PSDataRepositorySession.md) | Displays current session information (provider, auth mode, endpoint) |
| [Get-PSDataRepositoryProvider](docs/cmdlets/PSDataRepository/Get-PSDataRepositoryProvider.md) | Lists supported providers and their capabilities |
| [Test-PSDataRepositoryConnection](docs/cmdlets/PSDataRepository/Test-PSDataRepositoryConnection.md) | Tests connectivity to the current provider |

### Storage (Blob, Disk)

| Cmdlet | Description |
|---|---|
| [Get-PSDataRepositoryItem](docs/cmdlets/PSDataRepository/Get-PSDataRepositoryItem.md) | Retrieves and deserializes items from storage |
| [Set-PSDataRepositoryItem](docs/cmdlets/PSDataRepository/Set-PSDataRepositoryItem.md) | Serializes and saves items to storage |
| [Remove-PSDataRepositoryItem](docs/cmdlets/PSDataRepository/Remove-PSDataRepositoryItem.md) | Deletes items from storage |
| [Test-PSDataRepositoryItem](docs/cmdlets/PSDataRepository/Test-PSDataRepositoryItem.md) | Tests if an item exists in the repository |
| [Compress-PSDataRepositoryItem](docs/cmdlets/PSDataRepository/Compress-PSDataRepositoryItem.md) | Compresses items with optional AES-256 encryption |
| [Expand-PSDataRepositoryItem](docs/cmdlets/PSDataRepository/Expand-PSDataRepositoryItem.md) | Decompresses items with optional decryption |

### Messaging (Queue, Service Bus, InMemory)

| Cmdlet | Description |
|---|---|
| [Send-PSDataRepositoryMessage](docs/cmdlets/PSDataRepository/Send-PSDataRepositoryMessage.md) | Sends serialized objects to a queue with batching |
| [Receive-PSDataRepositoryMessage](docs/cmdlets/PSDataRepository/Receive-PSDataRepositoryMessage.md) | Receives and deserializes messages from a queue |
| [Remove-PSDataRepositoryMessage](docs/cmdlets/PSDataRepository/Remove-PSDataRepositoryMessage.md) | Deletes processed messages from the queue |
| [ConvertFrom-PSDataRepositoryMessage](docs/cmdlets/PSDataRepository/ConvertFrom-PSDataRepositoryMessage.md) | Deserializes a raw message string (e.g. from Azure Function trigger) |

### Secrets (Key Vault, FileSystem)

| Cmdlet | Description |
|---|---|
| [Get-PSDataRepositorySecret](docs/cmdlets/PSDataRepository/Get-PSDataRepositorySecret.md) | Retrieves a secret value from the connected repository |
| [Set-PSDataRepositorySecret](docs/cmdlets/PSDataRepository/Set-PSDataRepositorySecret.md) | Creates or updates a secret |
| [Remove-PSDataRepositorySecret](docs/cmdlets/PSDataRepository/Remove-PSDataRepositorySecret.md) | Deletes a secret from the connected repository |

## Requirements

- **PowerShell** 7.4 or later (Core edition)
- **Operating System**: Windows, Linux, macOS
- **.NET Runtime**: .NET 8 or .NET 10

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Author

**Ondrej Kracmar** — [i-System](https://www.i-system.cz)
