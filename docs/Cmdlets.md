# Cmdlet Reference (20 cmdlets)

Full module reference: [`PSDataRepository.md`](PSDataRepository.md)

## Session management

| Cmdlet | Description |
|--------|-------------|
| [`Connect-PSDataRepository`](Connect-PSDataRepository.md) | Establishes a session to a data repository provider with dynamic parameters per provider |
| [`Disconnect-PSDataRepository`](Disconnect-PSDataRepository.md) | Closes the active repository session and releases resources |
| [`Get-PSDataRepositorySession`](Get-PSDataRepositorySession.md) | Displays current session information (provider, auth mode, endpoint) |
| [`Get-PSDataRepositoryProvider`](Get-PSDataRepositoryProvider.md) | Lists all supported providers and their capabilities |
| [`Test-PSDataRepositoryConnection`](Test-PSDataRepositoryConnection.md) | Tests connectivity to the current provider |

## Storage operations

| Cmdlet | Description |
|--------|-------------|
| [`Get-PSDataRepositoryItem`](Get-PSDataRepositoryItem.md) | Retrieves and deserializes items from storage (wildcards, raw, binary) |
| [`Set-PSDataRepositoryItem`](Set-PSDataRepositoryItem.md) | Serializes and saves items (pipeline accumulate, property-based naming) |
| [`Copy-PSDataRepositoryItem`](Copy-PSDataRepositoryItem.md) | Copies local files or intra-repository items (recurse, flatten, filter) |
| [`Remove-PSDataRepositoryItem`](Remove-PSDataRepositoryItem.md) | Deletes items from storage with ShouldProcess support |
| [`Test-PSDataRepositoryItem`](Test-PSDataRepositoryItem.md) | Tests if an item exists in the repository |
| [`Get-PSDataRepositoryChildItem`](Get-PSDataRepositoryChildItem.md) | Lists child items with rich metadata (Name, Size, LastModified, ContentType) |
| [`Compress-PSDataRepositoryItem`](Compress-PSDataRepositoryItem.md) | Compresses items with optional AES-256-GCM encryption |
| [`Expand-PSDataRepositoryItem`](Expand-PSDataRepositoryItem.md) | Decompresses and optionally decrypts items |

## Messaging operations

| Cmdlet | Description |
|--------|-------------|
| [`Send-PSDataRepositoryMessage`](Send-PSDataRepositoryMessage.md) | Sends serialized objects to a queue with batching support |
| [`Receive-PSDataRepositoryMessage`](Receive-PSDataRepositoryMessage.md) | Receives and deserializes messages (peek, continuous, batch) |
| [`Remove-PSDataRepositoryMessage`](Remove-PSDataRepositoryMessage.md) | Deletes processed messages from the queue |
| [`ConvertFrom-PSDataRepositoryMessage`](ConvertFrom-PSDataRepositoryMessage.md) | Deserializes a raw message string (e.g. from Azure Function trigger) |

## Secret management

| Cmdlet | Description |
|--------|-------------|
| [`Get-PSDataRepositorySecret`](Get-PSDataRepositorySecret.md) | Retrieves a secret value from the connected repository |
| [`Set-PSDataRepositorySecret`](Set-PSDataRepositorySecret.md) | Creates or updates a secret |
| [`Remove-PSDataRepositorySecret`](Remove-PSDataRepositorySecret.md) | Deletes a secret from the connected repository |

## Extension tooling

| Cmdlet | Description |
|--------|-------------|
| [`Get-PSDataRepositoryExtensionToken`](Get-PSDataRepositoryExtensionToken.md) | Reads the strong‑name public‑key token of an extension DLL (for `extensions.trust.json`) |
