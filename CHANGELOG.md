# Changelog

All notable changes to the **PSDataRepository** module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
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
