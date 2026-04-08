---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04/08/2026
PlatyPS schema version: 2024-05-01
title: Get-PSDataRepositoryProvider
---

# Get-PSDataRepositoryProvider

## SYNOPSIS

Lists all supported PSDataRepository providers and their capabilities.

## SYNTAX

### __AllParameterSets

```
Get-PSDataRepositoryProvider [[-Name] <string>] [-Capability <string>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Displays information about each data repository provider the module can work with, including provider type, supported capabilities (Storage, Queue, Secrets), authentication methods, and connection examples.
Does not require an active session.

## EXAMPLES

### List all providers



### Filter by name



### Filter by capability



## PARAMETERS

### -Capability

Filter providers by capability.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Filter by provider name.
If not specified, all providers are listed.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
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

### System.Management.Automation.PSObject

One object per provider with properties:

| Property | Type | Description | |---|---|---| | Name | String | Provider name | | Description | String | Human-readable description | | Capabilities | String[] | Storage, Queue, and/or Secrets | | AuthMethods | String[] | Supported authentication methods | | RequiresAzure | Boolean | Whether Azure subscription is needed | | Example | String | Example connection command |

## NOTES

This cmdlet does not require an active session.


## RELATED LINKS

- [Online Version]()
- [Connect-PSDataRepository]()
- [Get-PSDataRepositorySession]()
