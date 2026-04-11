---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: cs-CZ
Module Name: PSDataRepository
ms.date: 04.08.2026
PlatyPS schema version: 2024-05-01
title: Test-PSDataRepositoryItem
---

# Test-PSDataRepositoryItem

## SYNOPSIS

Tests if an object exists in the repository.

## SYNTAX

### __AllParameterSets

```
Test-PSDataRepositoryItem [-Name] <string[]> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Checks whether one or more objects exist in the connected repository (Azure Blob Storage, Disk).
Returns `$true` if the item exists, `$false` otherwise.
Requires an active session established by `Connect-PSDataRepository`.

## EXAMPLES

### Test single item

Test-PSDataRepositoryItem -Name "config.json"

Returns `$true` if config.json exists, `$false` otherwise.

### Conditional execution

if (Test-PSDataRepositoryItem -Name "backup.json") { "File exists!" }

Conditional execution based on item existence.

## PARAMETERS

### -Name

The name/key of the object(s) to test for existence.

```yaml
Type: System.String[]
DefaultValue: None
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

Item names can be piped to this cmdlet.

### System.String[]

{{ Fill in the Description }}

## OUTPUTS

### System.Boolean

`$true` if the item exists, `$false` otherwise.
One boolean per input name.

## NOTES

Requires an active session.
Use `Connect-PSDataRepository` first.


## RELATED LINKS

- [Get-PSDataRepositoryItem]()
- [Set-PSDataRepositoryItem]()
- [Remove-PSDataRepositoryItem]()
