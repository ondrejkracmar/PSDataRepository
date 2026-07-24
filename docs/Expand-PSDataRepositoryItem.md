---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04.12.2026
PlatyPS schema version: 2024-05-01
title: Expand-PSDataRepositoryItem
---

# Expand-PSDataRepositoryItem

## SYNOPSIS

Decompresses and optionally decrypts items in persistent storage.

## SYNTAX

### Default (Default)

```
Expand-PSDataRepositoryItem [-Name] <string> [[-DestinationName] <string>]
 [-Password <securestring>] [-KeepOriginal] [-Force] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Decompresses GZip-compressed items stored in the repository.
Automatically decrypts items encrypted with `Compress-PSDataRepositoryItem` if password is provided.
Automatically detects `.gz` and `.gz.enc` extensions and removes them from decompressed item name.
Supports in-place decompression or creating a new decompressed copy.
Ideal for restoring archived datasets or processing compressed/encrypted data.

## EXAMPLES

### Simple decompression



### Decrypt and decompress



### Keep compressed original



### Custom destination



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

### -DestinationName

Destination name for decompressed item.
If not specified, removes `.gz` or `.gz.enc` extension from original name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Force

If specified, overwrites existing decompressed item without confirmation.

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

### -KeepOriginal

If specified, keeps the compressed item after decompression.

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

### -Name

The name/key of the compressed item to expand.

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

### -PassThru

If specified, returns decompression statistics (SourceName, DestinationName, OriginalSize, CompressedSize, DecompressedSize, ExpansionRatio, WasEncrypted).

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

### -Password

Password for AES-256 decryption.
Required if item was encrypted with `Compress-PSDataRepositoryItem`.
Use `Read-Host -AsSecureString` to securely prompt for password.

```yaml
Type: System.Security.SecureString
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Compressed item name to expand.

## OUTPUTS

### System.Management.Automation.PSObject

When `-PassThru` is specified, returns an object with decompression statistics.

## NOTES

Automatically detects encryption by checking for the magic header written by `Compress-PSDataRepositoryItem`.
If the file is encrypted but no `-Password` is provided, the cmdlet writes an error.
If `-Password` is provided but the file is not encrypted, a warning is shown.


## RELATED LINKS

- [Online Version]()
- [Compress-PSDataRepositoryItem]()
- [Get-PSDataRepositoryItem]()
