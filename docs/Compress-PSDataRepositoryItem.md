---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04/12/2026
PlatyPS schema version: 2024-05-01
title: Compress-PSDataRepositoryItem
---

# Compress-PSDataRepositoryItem

## SYNOPSIS

Compresses and optionally encrypts items in persistent storage.

## SYNTAX

### Default (Default)

```
Compress-PSDataRepositoryItem [-Name] <string> [[-DestinationName] <string>]
 [-Password <securestring>] [-CompressionLevel <CompressionLevel>] [-KeepOriginal] [-Force]
 [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Compresses stored items using GZip compression to reduce storage size.
Optionally encrypts compressed data using AES-256 encryption with PBKDF2 key derivation (100,000 iterations, SHA-256).
The compressed item is saved with `.gz` extension (or `.gz.enc` if encrypted).
Supports in-place compression or creating a new compressed copy.
Ideal for archiving large datasets or reducing storage costs with security.

## EXAMPLES

### Simple compression



### Compress and encrypt



### Keep original



### Custom destination



## PARAMETERS

### -CompressionLevel

Compression level: Optimal (default), Fastest, or NoCompression.

```yaml
Type: System.IO.Compression.CompressionLevel
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

### -DestinationName

Destination name for compressed item.
If not specified, adds `.gz` extension (or `.gz.enc` if encrypted).

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

If specified, overwrites existing compressed item without confirmation.

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

If specified, keeps the original item after compression.

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

The name/key of the item to compress.

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

If specified, returns compression statistics (SourceName, DestinationName, OriginalSize, CompressedSize, FinalSize, CompressionRatio, IsEncrypted).

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

Password for AES-256 encryption.
If specified, compressed data will be encrypted.
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

Item name to compress.

## OUTPUTS

### System.Management.Automation.PSObject

When `-PassThru` is specified, returns an object with compression statistics.

## NOTES

Encryption uses AES-256-CBC with PBKDF2 key derivation (100,000 iterations, SHA-256, 32-byte salt).
Binary format: `[Magic Header 11B][Salt 32B][IV 16B][Encrypted Data]`.
Use `Expand-PSDataRepositoryItem` with the same password to decrypt.


## RELATED LINKS

- [Online Version]()
- [Expand-PSDataRepositoryItem]()
- [Get-PSDataRepositoryItem]()
