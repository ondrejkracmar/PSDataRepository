---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: cs-CZ
Module Name: PSDataRepository
ms.date: 04.08.2026
PlatyPS schema version: 2024-05-01
title: Remove-PSDataRepositoryItem
---

# Remove-PSDataRepositoryItem

## SYNOPSIS

Removes items from persistent storage (Blob, Disk).

## SYNTAX

### __AllParameterSets

```
Remove-PSDataRepositoryItem [-Name] <string[]> [-Force] [-ContinueOnError] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Deletes items from the connected repository (Azure Blob Storage, Disk).
Supports removing single or multiple items by name.
Prompts for confirmation before deleting unless `-Force` is specified.

## EXAMPLES

### Remove single item

Remove-PSDataRepositoryItem -Name "temp.json"

Removes temp.json from storage (with confirmation prompt).

### Force removal without confirmation

Remove-PSDataRepositoryItem -Name "backup/*.json" -Force

Removes all JSON files in backup folder without confirmation.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- cf
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

### -ContinueOnError

If specified, continues processing even if individual object deletion fails.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -Force

If specified, skips confirmation prompts.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

The name/key of the item(s) to remove.

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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- wi
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

## NOTES

Requires an active session to a storage provider.
Uses `ConfirmImpact = High`.


## RELATED LINKS

- [Get-PSDataRepositoryItem]()
- [Set-PSDataRepositoryItem]()
- [Test-PSDataRepositoryItem]()
