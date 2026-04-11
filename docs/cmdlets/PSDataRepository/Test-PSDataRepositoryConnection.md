---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: cs-CZ
Module Name: PSDataRepository
ms.date: 04.08.2026
PlatyPS schema version: 2024-05-01
title: Test-PSDataRepositoryConnection
---

# Test-PSDataRepositoryConnection

## SYNOPSIS

Tests the connectivity to the current PSDataRepository provider.

## SYNTAX

### __AllParameterSets

```
Test-PSDataRepositoryConnection [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Validates that the current session's connection to the underlying provider is healthy by performing a lightweight probe operation.
For storage providers (Azure Blob, Disk), attempts a list operation.
For queue providers (Azure Queue, Azure Service Bus, InMemory), queries the message count.
Returns $true if the connection is healthy, $false otherwise.

If no active session exists, returns $false without throwing an error.

This cmdlet is useful for detecting expired tokens, network failures, or stale sessions before executing data operations.

## EXAMPLES

### Basic connection test

Test-PSDataRepositoryConnection

Returns $true if the current connection is healthy, $false otherwise.

### Reconnect if unhealthy

if (-not (Test-PSDataRepositoryConnection)) {
    Connect-PSDataRepository -Provider AzureBlob -StorageAccountName "myaccount" -ContainerName "data" -Interactive
}

Checks the connection and reconnects if it has expired or failed.

### Health check in a script loop

while ($true) {
    if (-not (Test-PSDataRepositoryConnection)) {
        Write-Warning "Connection lost! Reconnecting..."
        Connect-PSDataRepository -Provider AzureBlob -StorageAccountName "myaccount" -ContainerName "data" -DefaultAzureCredential
    }
    # ... process data ...
    Start-Sleep -Seconds 60
}

Periodically validates the connection in a long-running script.

### Verbose diagnostics

Test-PSDataRepositoryConnection -Verbose

Shows detailed diagnostic output including the provider name and test result.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean

$true if the connection is healthy, $false if no session exists or the connectivity test fails.

## NOTES

Does not throw terminating errors.
Always returns a boolean value.
If the connection test fails, a warning message with the error detail is emitted.
For storage providers, the test performs a lightweight list operation.
For queue providers, the test queries the approximate message count.
Use -Verbose to see which provider is being tested and the result.


## RELATED LINKS

- [Connect-PSDataRepository]()
- [Disconnect-PSDataRepository]()
- [Get-PSDataRepositorySession]()
- [Test-PSDataRepositoryItem]()
