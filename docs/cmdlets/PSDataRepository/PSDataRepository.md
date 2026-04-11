---
document type: module
Help Version: 1.0.0.0
HelpInfoUri: 
Locale: cs-CZ
Module Guid: d2e7fbb1-9f84-4e12-9cb7-bf604e12b8b4
Module Name: PSDataRepository
ms.date: 04.08.2026
PlatyPS schema version: 2024-05-01
title: PSDataRepository Module
---

# PSDataRepository Module

## Description

A PowerShell module for working with data repositories (FileSystem, AzureBlob, AzureQueue, AzureKeyVault, etc.) in a session-based approach.

## PSDataRepository

### [Compress-PSDataRepositoryItem](Compress-PSDataRepositoryItem.md)

Compresses and optionally encrypts items in persistent storage.

### [Connect-PSDataRepository](Connect-PSDataRepository.md)

Connects to a data repository (Azure Blob, Queue, Service Bus, Key Vault, Disk, or InMemory).

### [ConvertFrom-PSDataRepositoryMessage](ConvertFrom-PSDataRepositoryMessage.md)

Deserializes a raw message string into a PowerShell object.

### [Disconnect-PSDataRepository](Disconnect-PSDataRepository.md)

Disconnects from the current data repository session.

### [Expand-PSDataRepositoryItem](Expand-PSDataRepositoryItem.md)

Decompresses and optionally decrypts items in persistent storage.

### [Get-PSDataRepositoryItem](Get-PSDataRepositoryItem.md)

Retrieves items from persistent storage (Blob, Disk).

### [Get-PSDataRepositoryProvider](Get-PSDataRepositoryProvider.md)

Lists all supported PSDataRepository providers and their capabilities.

### [Get-PSDataRepositorySecret](Get-PSDataRepositorySecret.md)

Retrieves a secret value from the connected repository.

### [Get-PSDataRepositorySession](Get-PSDataRepositorySession.md)

Retrieves information about the current repository session.

### [Receive-PSDataRepositoryMessage](Receive-PSDataRepositoryMessage.md)

Receives and deserializes messages from the connected queue repository.

### [Remove-PSDataRepositoryItem](Remove-PSDataRepositoryItem.md)

Removes items from persistent storage (Blob, Disk).

### [Remove-PSDataRepositoryMessage](Remove-PSDataRepositoryMessage.md)

Removes/deletes messages from the queue.

### [Remove-PSDataRepositorySecret](Remove-PSDataRepositorySecret.md)

Deletes a secret from the connected repository.

### [Send-PSDataRepositoryMessage](Send-PSDataRepositoryMessage.md)

Sends objects to the connected queue repository.

### [Set-PSDataRepositoryItem](Set-PSDataRepositoryItem.md)

Saves items to persistent storage (Blob, Disk).

### [Set-PSDataRepositorySecret](Set-PSDataRepositorySecret.md)

Creates or updates a secret in the connected repository (Key Vault, FileSystem).

### [Test-PSDataRepositoryConnection](Test-PSDataRepositoryConnection.md)

Tests the connectivity to the current PSDataRepository provider.

### [Test-PSDataRepositoryItem](Test-PSDataRepositoryItem.md)

Tests if an object exists in the repository.

