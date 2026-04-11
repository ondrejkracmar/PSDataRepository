---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04/11/2026
PlatyPS schema version: 2024-05-01
title: Get-PSDataRepositorySecret
---

# Get-PSDataRepositorySecret

## SYNOPSIS

Retrieves a secret value from the connected repository.

## SYNTAX

### __AllParameterSets

```
Get-PSDataRepositorySecret [-Name] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Gets the value of a secret from the connected repository (typically Azure Key Vault or FileSystem).
Fails if the repository type does not support secrets or is not connected.

## EXAMPLES

### Retrieve a secret



## PARAMETERS

### -Name

The name of the secret to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
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

### System.String

{{ Fill in the Description }}

## OUTPUTS

### System.String

The secret value as a plain text string.

### System.Management.Automation.PSObject

{{ Fill in the Description }}

## NOTES

Requires an active session to a provider that supports secrets (e.g., AzureKeyVault).


## RELATED LINKS

- [Online Version]()
- [Set-PSDataRepositorySecret]()
- [Remove-PSDataRepositorySecret]()
