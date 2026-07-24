---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04.20.2026
PlatyPS schema version: 2024-05-01
title: Get-PSDataRepositoryExtensionToken
---

# Get-PSDataRepositoryExtensionToken

## SYNOPSIS

Reads the strong-name public key token from a .NET assembly in the format used by `extensions.trust.json`.

## SYNTAX

### __AllParameterSets

```
Get-PSDataRepositoryExtensionToken [-Path] <string[]> [<CommonParameters>]
```

## DESCRIPTION

Helper for administrators who need to add a 3rd-party PSDataRepository extension to the trust list. Reads the assembly metadata without loading it for execution and returns the lowercase 16-character hex public key token, suitable for pasting into `extensions.trust.json` under `trustedPublicKeyTokens`.

Unsigned assemblies are reported with `IsSigned = $false` and a warning. PSDataRepository will silently reject them at `Import-Module` time regardless of the trust list.

## EXAMPLES

### Single file

```pwsh
Get-PSDataRepositoryExtensionToken -Path .\Contoso.PSDataRepository.MyProvider.dll
```

### Pipeline

```pwsh
Get-ChildItem .\Plugins\*.dll | Get-PSDataRepositoryExtensionToken | Format-Table Name,Token
```

## PARAMETERS

### -Path

Path to the .NET assembly to read the public key token from. Accepts pipeline input by value or by property name (`FullName`, `PSPath`).

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: [FullName, PSPath]
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: 'Path to the .NET assembly to read the public key token from.'
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Management.Automation.PSObject

One object per assembly with properties:

| Property | Type | Description |
|---|---|---|
| Path | String | Resolved absolute path to the assembly file |
| Name | String | File name only |
| Token | String | Lowercase 16-character hex public key token, or `$null` if unsigned |
| IsSigned | Boolean | Whether the assembly is strong-named |

## NOTES

- The assembly is inspected via `AssemblyName.GetAssemblyName()` — it is **not** loaded for execution. No module/static initializers run.
- See [Extensions.md](Extensions.md) for the full 3rd-party extension authoring & trust workflow.

## RELATED LINKS

- [Online Version]()
- [Extensions.md]()
