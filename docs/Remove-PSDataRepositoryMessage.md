---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04/12/2026
PlatyPS schema version: 2024-05-01
title: Remove-PSDataRepositoryMessage
---

# Remove-PSDataRepositoryMessage

## SYNOPSIS

Removes/deletes messages from the queue.

## SYNTAX

### ByMessage

```
Remove-PSDataRepositoryMessage [-Message] <QueueMessage[]> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ByPipelineObject

```
Remove-PSDataRepositoryMessage -InputObject <psobject> [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Deletes messages from the connected queue repository (InMemory, Disk, Azure Queue, Service Bus).
Typically used after successful message processing to prevent reprocessing.
Messages must have been received first (to obtain receipt handles).
For Azure providers, uses receipt handle for deletion.
For Disk/InMemory, uses message ID.

## EXAMPLES

### Receive and delete a message



### Pipeline deletion



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

### -Force

If specified, suppresses confirmation prompts.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -InputObject

Pipeline object from Receive-PSDataRepositoryMessage.

```yaml
Type: System.Management.Automation.PSObject
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByPipelineObject
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Message

The message object(s) to delete.
Typically obtained from `Receive-PSDataRepositoryMessage`.

```yaml
Type: PSDataRepository.Messaging.QueueMessage[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByMessage
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
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

### PSDataRepository.Messaging.QueueMessage

Message objects from `Receive-PSDataRepositoryMessage`.

### System.Management.Automation.PSObject

{{ Fill in the Description }}

### PSDataRepository.Messaging.QueueMessage[]

{{ Fill in the Description }}

## OUTPUTS

## NOTES

If using `Receive-PSDataRepositoryMessage` without `-NoAutoDelete`, messages are automatically deleted after successful processing.
This cmdlet is needed only when `-NoAutoDelete` is used.


## RELATED LINKS

- [Online Version]()
- [Receive-PSDataRepositoryMessage]()
- [Send-PSDataRepositoryMessage]()
