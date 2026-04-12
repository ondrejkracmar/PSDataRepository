---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04/12/2026
PlatyPS schema version: 2024-05-01
title: Set-PSDataRepositoryItem
---

# Set-PSDataRepositoryItem

## SYNOPSIS

Saves items to persistent storage (Blob, Disk).

## SYNTAX

### SingleObject (Default)

```
Set-PSDataRepositoryItem [-InputObject] <psobject> [-Name] <string> [-Format <FormatType>]
 [-Encoding <Encoding>] [-MaxDepth <int>] [-CsvDelimiter <char>] [-XmlRootName <string>] [-Force]
 [-PassThru] [-Accumulate] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### PropertyBased

```
Set-PSDataRepositoryItem [-InputObject] <psobject> -NameProperty <string> [-NamePrefix <string>]
 [-NameSuffix <string>] [-Format <FormatType>] [-Encoding <Encoding>] [-MaxDepth <int>]
 [-CsvDelimiter <char>] [-XmlRootName <string>] [-Force] [-PassThru] [-Accumulate] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Serializes and stores items in the connected repository (Azure Blob Storage, Disk).
Supports pipeline input for batch processing and multiple serialization formats.
Items are stored as individual files/blobs with specified names.
Ideal for saving configuration, datasets, or processing results.

When receiving pipeline input with a fixed name (no `{0}` placeholder), automatically accumulates all objects and saves them as a single collection (array).
Use `{0}` in `-Name` for per-object naming, or `-NameProperty` for property-based naming.

## EXAMPLES

### Save pipeline objects as collection



### Save hashtable



### Property-based naming



## PARAMETERS

### -Accumulate

If specified, accumulates all pipeline objects and saves them as a collection (array).
Useful for creating a single JSON/XML/CSV file from multiple pipeline objects.

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

### -CsvDelimiter

CSV delimiter character.
Only used when Format = Csv.
Default: comma (`,`).

```yaml
Type: System.Char
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

### -Encoding

Text encoding for writing.
Default: UTF-8.

```yaml
Type: System.Text.Encoding
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

### -Force

If specified, overwrites existing objects without confirmation.

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

### -Format

Serialization format: Json (default), Xml, or Csv.

```yaml
Type: PSDataRepository.Serialization.FormatType
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

The object to save.
Accepts pipeline input.

```yaml
Type: System.Management.Automation.PSObject
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

### -MaxDepth

Maximum serialization depth.
Default: 10.

```yaml
Type: System.Int32
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

The name/key for storing the object.
Can include `{0}` placeholder for pipeline index.
Examples: `"data.json"`, `"item-{0}.json"`, `"backup/{0}.xml"`

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SingleObject
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NamePrefix

Prefix to add before generated names (used with `-NameProperty`).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PropertyBased
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NameProperty

Property name to use for generating unique names from pipeline objects.
Example: `-NameProperty "Id"` uses each object's Id property as the name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PropertyBased
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NameSuffix

Suffix/extension to add after generated names (used with `-NameProperty`).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: PropertyBased
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

If specified, returns storage path/URI after saving.

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

### -XmlRootName

XML root element name.
Only used when Format = Xml.
If not specified, automatically inferred from object type.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Management.Automation.PSObject

Any PowerShell object.
Accepts pipeline input.

## OUTPUTS

### System.Management.Automation.PSObject

When `-PassThru` is specified, returns an object with Name, Path, Size, Format (and ObjectCount for accumulated saves).

## NOTES

Auto-accumulate mode is activated when Name does not contain `{0}` and `-NameProperty` is not used.
In this mode, all pipeline objects are collected and saved as a single array.


## RELATED LINKS

- [Online Version]()
- [Get-PSDataRepositoryItem]()
- [Remove-PSDataRepositoryItem]()
- [Test-PSDataRepositoryItem]()
