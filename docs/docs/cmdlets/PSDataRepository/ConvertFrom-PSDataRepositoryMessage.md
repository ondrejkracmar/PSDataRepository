---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04/11/2026
PlatyPS schema version: 2024-05-01
title: ConvertFrom-PSDataRepositoryMessage
---

# ConvertFrom-PSDataRepositoryMessage

## SYNOPSIS

Deserializes a raw message string into a PowerShell object.

## SYNTAX

### __AllParameterSets

```
ConvertFrom-PSDataRepositoryMessage [-InputObject] <string> [-Format <FormatType>]
 [-IncludeMetadata] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Converts a raw message string (e.g.
received from an Azure Function Queue trigger) into a deserialized object using the module's Formatter.
Does not require an active session or queue connection.
Automatically detects the serialization format (JSON, XML, CSV) unless `-Format` is specified.
If the message was sent with `-IncludeMetadata`, the metadata envelope is automatically unwrapped and the inner content is deserialized.
Use `-IncludeMetadata` to attach the envelope metadata as note properties on the output object.

## EXAMPLES

### Azure Function Queue trigger



### Explicit format from pipeline



### With envelope metadata



## PARAMETERS

### -Format

Deserialization format.
If not specified, attempts auto-detection based on content.

```yaml
Type: System.Nullable`1[PSDataRepository.Serialization.FormatType]
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

### -IncludeMetadata

If specified, includes metadata properties from the envelope (TypeName, Timestamp, MachineName, UserName, SerializationFormat) as note properties on the deserialized object.
Only applies when the message contains a metadata envelope (sent with `-IncludeMetadata` on `Send-PSDataRepositoryMessage`).

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

The raw message string to deserialize.
Accepts pipeline input.

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

Raw message string (from Azure Function trigger, Service Bus, etc.).

## OUTPUTS

### System.Management.Automation.PSObject

Deserialized object.
When `-IncludeMetadata` is used, additional note properties are added: ` _TypeName`, ` SerializationFormat`, ` Timestamp`, ` MachineName`, ` _UserName`.

## NOTES

This cmdlet does not require an active session.
It is designed for use in Azure Functions, Logic Apps, or any scenario where raw message strings need to be deserialized outside of a PSDataRepository session.


## RELATED LINKS

- [Online Version]()
- [Send-PSDataRepositoryMessage]()
- [Receive-PSDataRepositoryMessage]()
