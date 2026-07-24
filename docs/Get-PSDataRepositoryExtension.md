---
document type: cmdlet
external help file: PSDataRepository.Commands.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 07.24.2026
PlatyPS schema version: 2024-05-01
title: Get-PSDataRepositoryExtension
---

# Get-PSDataRepositoryExtension

## SYNOPSIS

Lists every extension the loader considered — including the ones it refused, and why.

## SYNTAX

### __AllParameterSets

```
Get-PSDataRepositoryExtension [-Rejected] [-Subfolder <string>] [-VersionSkew]
 [-MissingAfterUpgrade] [-ModuleRoot <string>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Extensions are loaded at import time, and a rejected one is otherwise invisible: nothing
fails, no error is written, the capability simply is not there. A missing provider looks
exactly like a provider that was never installed.

This cmdlet reports what the loader actually saw. Every candidate assembly appears, loaded
or not, with the reason it was refused — an untrusted strong-name key, an incompatible
contract major, or a type that failed to materialise.

Note that it describes the running process, not the disk. An extension added or removed
since `Import-Module` is not reflected until PowerShell restarts, because assemblies cannot
be unloaded from a live session.

## EXAMPLES

### Example 1: Find out why a provider is missing

```powershell
Get-PSDataRepositoryExtension -Rejected
```

The first thing to run when a provider or formatter is not there. Each row carries the
public key token and the reason, which together say whether the fix is trusting a key or
rebuilding against a newer contract.

### Example 2: See everything the loader found

```powershell
Get-PSDataRepositoryExtension | Format-Table Name, Subfolder, Status, ContractVersion
```

### Example 3: Check for drift against the host

```powershell
Get-PSDataRepositoryExtension -VersionSkew
```

Reports assemblies whose version differs from the one an extension was compiled against.
Skew is not automatically a fault — the module deliberately shares its own copies — but it
explains behaviour that a version number alone does not.

### Example 4: Find extensions lost in a module upgrade

```powershell
Get-PSDataRepositoryExtension -MissingAfterUpgrade
```

A module upgrade installs into a new folder, so every extension is left behind in the old
one. This compares the two and names what needs reinstalling.

## PARAMETERS

### -MissingAfterUpgrade

Report extensions an earlier installed module version had that this one does not.

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

### -ModuleRoot

Module root to compare for -MissingAfterUpgrade. Defaults to the running module.

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

### -Rejected

Return only the extensions that were rejected, with the reason.

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

### -Subfolder

Limit the report to one plugin subfolder.

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

### -VersionSkew

Report assembly versions that differ from what each extension was built against.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject

One object per candidate assembly, with `Name`, `Subfolder`, `Status`, `ContractVersion`,
`Registered`, `Reason`, `PublicKeyToken` and `Path`. `Registered` lists the provider,
formatter or authentication names the extension contributed; `Reason` is populated only
when `Status` is not `Loaded`.

## NOTES

Extensions signed with the module's own key are trusted implicitly. Any other key must be
listed in `extensions.trust.json` next to `PSDataRepository.psd1` — which is what
`Install-PSDataRepositoryExtension -Trust` writes to.

## RELATED LINKS

- [Install-PSDataRepositoryExtension](Install-PSDataRepositoryExtension.md)
- [Uninstall-PSDataRepositoryExtension](Uninstall-PSDataRepositoryExtension.md)
- [Get-PSDataRepositoryExtensionToken](Get-PSDataRepositoryExtensionToken.md)
- [Extensions SDK guide](Extensions.md)

