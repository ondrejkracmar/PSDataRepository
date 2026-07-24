---
document type: cmdlet
external help file: PSDataRepository.Commands.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 07.24.2026
PlatyPS schema version: 2024-05-01
title: Uninstall-PSDataRepositoryExtension
---

# Uninstall-PSDataRepositoryExtension

## SYNOPSIS

Removes an extension, and the dependencies it introduced but nothing else needs.

## SYNTAX

### __AllParameterSets

```
Uninstall-PSDataRepositoryExtension [-Name] <string[]> [-ModuleRoot <string>] [-RemoveTrust]
 [-WhatIf] [-Confirm]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Deletes the extension's assembly, or its whole private folder when it was installed with
private dependencies.

The part that cannot be done by hand is the cleanup. Third-party libraries an extension
brought with it live in the module root alongside everything else, so deleting them blindly
breaks whatever else needs them. `Install-PSDataRepositoryExtension` records in
`extensions.deps.json` which files each extension contributed and whether they were already
present, and a file is removed only when this extension introduced it into a module that
lacked it **and** no other installed extension claims it.

Anything else is left in place and reported, so the outcome is visible rather than assumed.

`-Name` is the extension's assembly name, with or without the `.dll` suffix. It is the full
name — `PSDataRepository.Formatters.Xlsx`, not `Xlsx` — so the reliable way to get it right
is to read it from `Get-PSDataRepositoryExtension`, or to pipe that output straight in.

## EXAMPLES

### Example 1: Remove an extension

```powershell
Uninstall-PSDataRepositoryExtension -Name PSDataRepository.Formatters.Xlsx
```

### Example 2: Preview what would be deleted

```powershell
Uninstall-PSDataRepositoryExtension -Name PSDataRepository.Formatters.Xlsx -WhatIf
```

Lists the extension file and every dependency considered orphaned, without touching
anything. Worth doing first when the extension shipped libraries into the module root.

### Example 3: Remove everything from one publisher

```powershell
Get-PSDataRepositoryExtension |
    Where-Object PublicKeyToken -eq '1dbd56fdd9440135' |
    Uninstall-PSDataRepositoryExtension -WhatIf
```

`Name` binds by property, so the report pipes in unchanged. Drop `-WhatIf` once the list
looks right.

### Example 4: Remove the extension and revoke its signing key

```powershell
Uninstall-PSDataRepositoryExtension -Name Contoso.Provider -RemoveTrust
```

`-RemoveTrust` also drops the key from `extensions.trust.json`. Do this when retiring a
publisher rather than a single extension; if other installed extensions share that key,
they stop loading at the next restart.

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

### -ModuleRoot

Module root to remove from. Defaults to the running module.

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

### -Name

Extension assembly name, with or without .dll.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RemoveTrust

Also revoke the signing key's trust. Affects every extension signed with it.

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

### System.String[]

Extension names. Bound by value, and also by the `Name` property — so the output of
`Get-PSDataRepositoryExtension` pipes in directly, without projecting it first.

## OUTPUTS

### System.Management.Automation.PSObject

One object per removed extension, listing the files deleted and the dependencies removed as
orphans. Dependencies that were kept, and the reason they were kept, are reported as well.

## NOTES

The extension keeps working until PowerShell is restarted. Its assembly is already loaded
and cannot be unloaded from a live session, so the files disappear from disk while the
capability remains available in the current process.

## RELATED LINKS

- [Install-PSDataRepositoryExtension](Install-PSDataRepositoryExtension.md)
- [Get-PSDataRepositoryExtension](Get-PSDataRepositoryExtension.md)
- [Extensions SDK guide](Extensions.md)

