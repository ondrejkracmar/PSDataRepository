---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: cs-CZ
Module Name: PSDataRepository
ms.date: 04.08.2026
PlatyPS schema version: 2024-05-01
title: Get-PSDataRepositoryItem
---

# Get-PSDataRepositoryItem

## SYNOPSIS

Retrieves items from persistent storage (Blob, Disk).

## SYNTAX

### ByName (Default)

```
Get-PSDataRepositoryItem [-Name] <string[]> [-Format <FormatType>] [-Encoding <Encoding>] [-Raw]
 [-AsByteArray] [-IncludeMetadata] [-ContinueOnError] [<CommonParameters>]
```

### ListAll

```
Get-PSDataRepositoryItem -ListAll [-Format <FormatType>] [-Encoding <Encoding>] [-Raw]
 [-AsByteArray] [-IncludeMetadata] [-ContinueOnError] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Loads and deserializes items from the connected repository (Azure Blob Storage, Disk).
Supports retrieving single items, multiple items by pattern, or listing all items.
Items are automatically deserialized based on format (JSON, XML, CSV) or content detection.
Ideal for loading configuration, datasets, or processing results.

## EXAMPLES

### Retrieve single item

Get-PSDataRepositoryItem -Name "config.json"

Retrieves and deserializes config.json.

### Pattern matching

Get-PSDataRepositoryItem -Name "data/*.json"

Retrieves all JSON files from the data folder.

### Explicit format

Get-PSDataRepositoryItem -Name "backup.xml" -Format Xml

Explicitly deserializes as XML.

### Raw content

Get-PSDataRepositoryItem -Name "export.csv" -Raw

Returns raw content without deserialization.

## PARAMETERS

### -AsByteArray

If specified, returns content as byte array (binary mode).

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

### -ContinueOnError

If specified, continues processing even if individual object retrieval fails.

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

### -Encoding

Text encoding for reading.
Default: UTF-8.

```yaml
Type: System.Text.Encoding
DefaultValue: UTF8
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

### -Format

Expected deserialization format.
If not specified, auto-detects from content or file extension.

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

If specified, includes metadata (Name, Path, Format) as properties on output objects (` _Name`, ` Path`, ` _Format`).

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

### -ListAll

If specified, lists all available objects in the repository.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ListAll
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name/key or pattern of the object(s) to retrieve.
Supports wildcards (* and ?) depending on provider.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases:
- Key
- Path
ParameterSets:
- Name: ByName
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Raw

If specified, returns raw content as string without deserialization.

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

### System.Management.Automation.PSObject

Deserialized object(s).
The output type depends on the stored content and format.

## NOTES

Format auto-detection uses file extension first, then content analysis (JSON: `{`/`[`, XML: `<`, CSV: header row).


## RELATED LINKS

- [Set-PSDataRepositoryItem]()
- [Remove-PSDataRepositoryItem]()
- [Test-PSDataRepositoryItem]()
