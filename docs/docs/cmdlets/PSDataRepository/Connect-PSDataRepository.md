---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04/11/2026
PlatyPS schema version: 2024-05-01
title: Connect-PSDataRepository
---

# Connect-PSDataRepository

## SYNOPSIS

Connects to a data repository (Azure Blob, Queue, Service Bus, Key Vault, Disk, or InMemory).

## SYNTAX

### __AllParameterSets

```
Connect-PSDataRepository [-Provider] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Establishes a session to a data repository provider.
The provider type is automatically detected from the supplied parameters (connection string, account name, vault name, etc.).

Supports 12 authentication methods including connection strings, SAS tokens, Managed Identity, client secrets/certificates, interactive browser, device code, and DefaultAzureCredential.

For local development, use `-Disk` or `-InMemory` switches which require no authentication.

The provider is auto-detected based on supplied parameters:

- `-VaultName` → AzureKeyVault

- `-TopicName` / `-SubscriptionName` → AzureServiceBus

- `-QueueName` → AzureQueue

- `-ContainerName` → AzureBlob

- `-Disk` → Disk

- `-InMemory` → InMemory

## EXAMPLES

### Local disk storage



### In-memory (testing)



### Azure Blob Storage (connection string)



### Azure Queue (DefaultAzureCredential)



### Azure Key Vault (Managed Identity)



### Azure Service Bus topic



### With connection test and proxy



## PARAMETERS

### -Provider

Data repository provider type to connect to.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String

Connection confirmation message.

## NOTES

The provider type is auto-detected from supplied parameters.
Connection strings and sensitive values are sanitized in verbose output.

When `-TestConnection` is specified and the test fails, the session is automatically cleared.

Enterprise features (proxy, retries, timeout) are only applied to Azure providers, not Disk/InMemory.


## RELATED LINKS

- [Online Version]()
- [Disconnect-PSDataRepository]()
- [Get-PSDataRepositorySession]()
- [Get-PSDataRepositoryProvider]()
