---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04.12.2026
PlatyPS schema version: 2024-05-01
title: Disconnect-PSDataRepository
---

# Disconnect-PSDataRepository

## SYNOPSIS

Disconnects from the current data repository session.

## SYNTAX

### __AllParameterSets

```
Disconnect-PSDataRepository [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Closes the active repository connection established by `Connect-PSDataRepository`.
Disposes all underlying resources (storage clients, queue clients, cached connections) and clears the session state.
Returns `$true` on success, `$false` if an error occurred during cleanup.
Safe to call even when no session is active.

## EXAMPLES

### Simple disconnect



### Connect-work-disconnect workflow



## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

## OUTPUTS

### System.Boolean

Returns `$true` on successful disconnect, `$false` if cleanup encountered an error.

## NOTES

Safe to call multiple times or when no session is active.


## RELATED LINKS

- [Online Version]()
- [Connect-PSDataRepository]()
- [Get-PSDataRepositorySession]()
