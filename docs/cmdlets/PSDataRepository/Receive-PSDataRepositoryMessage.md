---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: cs-CZ
Module Name: PSDataRepository
ms.date: 04.08.2026
PlatyPS schema version: 2024-05-01
title: Receive-PSDataRepositoryMessage
---

# Receive-PSDataRepositoryMessage

## SYNOPSIS

Receives and deserializes messages from the connected queue repository.

## SYNTAX

### Single (Default)

```
Receive-PSDataRepositoryMessage [-MaxMessages <int>] [-VisibilityTimeoutSeconds <int>]
 [-Format <FormatType>] [-Raw] [-NoAutoDelete] [-ContinueOnError] [-IncludeMetadata]
 [<CommonParameters>]
```

### Peek

```
Receive-PSDataRepositoryMessage [-MaxMessages <int>] [-VisibilityTimeoutSeconds <int>]
 [-Format <FormatType>] [-Peek] [-Raw] [-NoAutoDelete] [-ContinueOnError] [-IncludeMetadata]
 [<CommonParameters>]
```

### Continuous

```
Receive-PSDataRepositoryMessage [-MaxMessages <int>] [-VisibilityTimeoutSeconds <int>]
 [-Format <FormatType>] [-Raw] [-NoAutoDelete] [-Continuous] [-DelaySeconds <int>]
 [-MaxIterations <int>] [-ContinueOnError] [-IncludeMetadata] [<CommonParameters>]
```

### ById

```
Receive-PSDataRepositoryMessage -MessageId <string> [-MaxMessages <int>]
 [-VisibilityTimeoutSeconds <int>] [-Format <FormatType>] [-Raw] [-NoAutoDelete] [-ContinueOnError]
 [-IncludeMetadata] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Retrieves messages from the active queue repository and deserializes them back to objects.
Supports batching for efficient retrieval of large message volumes.
Can operate in single-message mode, batch mode, continuous polling mode, or by-ID peek mode.
Messages are automatically acknowledged/deleted after successful deserialization by default.

## EXAMPLES

### Receive batch

Receive-PSDataRepositoryMessage -MaxMessages 10

Receives up to 10 messages and returns them as deserialized objects.

### Continuous polling

Receive-PSDataRepositoryMessage -Continuous -MaxMessages 100 -DelaySeconds 5

Continuously polls for messages, retrieving up to 100 per batch with 5-second delay between polls.
Press Ctrl+C to stop.

### Peek without removing

Receive-PSDataRepositoryMessage -Peek

Peeks at messages without removing them from the queue.

## PARAMETERS

### -ContinueOnError

If specified, continues processing even if individual message deserialization fails.

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

### -Continuous

If specified, continues polling continuously until interrupted (Ctrl+C) or `-MaxIterations` is reached.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Continuous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DelaySeconds

Delay in seconds between continuous polling attempts.
Only used with `-Continuous`.

```yaml
Type: System.Int32
DefaultValue: 5
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Continuous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Format

Deserialization format.
If not specified, attempts auto-detection based on content.

```yaml
Type: System.Nullable`1[PSDataRepository.Serialization.FormatType]
DefaultValue: None (auto-detect)
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

### -IncludeMetadata

If specified, includes message metadata (Id, Receipt, DequeueCount, timestamps) as note properties on output objects: ` _MessageId`, ` MessageReceipt`, ` DequeueCount`, ` InsertedOn`, ` ExpiresOn`, ` _NextVisibleOn`.

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

### -MaxIterations

Maximum number of continuous polling iterations.
Only used with `-Continuous`.

```yaml
Type: System.Int32
DefaultValue: 2147483647 (unlimited)
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Continuous
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxMessages

Maximum number of messages to receive in one call.

```yaml
Type: System.Int32
DefaultValue: 1
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

### -MessageId

The ID of a specific message to retrieve.
When specified, only the message with the matching ID is returned (using peek, without removing from queue).

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ById
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAutoDelete

If specified, does not automatically delete/acknowledge messages after processing.
Useful for manual acknowledgement scenarios or debugging.

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

### -Peek

If specified, peeks messages without removing them from the queue (read-only).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Peek
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Raw

If specified, returns raw message content without deserialization.

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

### -VisibilityTimeoutSeconds

Visibility timeout for received messages (how long they remain invisible to other consumers).

```yaml
Type: System.Int32
DefaultValue: 30
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject

Deserialized message objects.
When `-IncludeMetadata` is used, additional note properties are added.

## NOTES

In the default (non-Peek) mode, messages are automatically deleted after successful processing.
Use `-NoAutoDelete` to disable this behavior and manually delete with `Remove-PSDataRepositoryMessage`.


## RELATED LINKS

- [Send-PSDataRepositoryMessage]()
- [Remove-PSDataRepositoryMessage]()
- [ConvertFrom-PSDataRepositoryMessage]()
