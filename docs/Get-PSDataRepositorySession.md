---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04/12/2026
PlatyPS schema version: 2024-05-01
title: Get-PSDataRepositorySession
---

# Get-PSDataRepositorySession

## SYNOPSIS

Retrieves information about the current repository session.

## SYNTAX

### __AllParameterSets

```
Get-PSDataRepositorySession [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Displays details about the active PSDataRepository session including:

- Connection status

- Provider type (AzureBlob, AzureQueue, Disk, InMemory, etc.)

- Authentication mode

- Repository identity/endpoint

- Capabilities (Storage, Queue, Secrets, Filesystem)

Useful for debugging connectivity issues or verifying session configuration.

## EXAMPLES

### Display session info



### Detailed session info



## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject

A custom object with the following properties:

| Property | Type | Description | |---|---|---| | IsConnected | Boolean | Whether a session is active | | Provider | String | Provider name (AzureBlob, Disk, etc.) | | RepositoryType | String | Internal repository class name | | ConnectionType | String | Cloud, FileSystem, Memory, or FluentStorage | | AuthenticationMode | String | Authentication method used | | RepositoryIdentity | String | Account name, path, or sanitized endpoint | | Namespace | String | Container/queue/topic name (if applicable) | | TopicName | String | Service Bus topic (if applicable) | | SubscriptionName | String | Service Bus subscription (if applicable) | | Capabilities | String | Comma-separated list: Storage, Queue, Secrets, Filesystem |

## NOTES

Connection strings, account keys, and SAS tokens are automatically sanitized in the output.


## RELATED LINKS

- [Online Version]()
- [Connect-PSDataRepository]()
- [Disconnect-PSDataRepository]()
- [Get-PSDataRepositoryProvider]()
