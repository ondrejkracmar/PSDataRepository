---
document type: cmdlet
external help file: PSDataRepository.Commands.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 07.24.2026
PlatyPS schema version: 2024-05-01
title: Install-PSDataRepositoryExtension
---

# Install-PSDataRepositoryExtension

## SYNOPSIS

Installs an extension into the module, checking first that it can actually load.

## SYNTAX

### Path (Default)

```
Install-PSDataRepositoryExtension [-Path] <string> [-ModuleRoot <string>] [-Subfolder <string>]
 [-Trust] [-Force] [-WhatIf] [-Confirm]
```

### Feed

```
Install-PSDataRepositoryExtension -Name <string> -Repository <string> [-Version <string>]
 [-ModuleRoot <string>] [-Subfolder <string>] [-Trust] [-Force] [-WhatIf] [-Confirm]
```

### InstalledModule

```
Install-PSDataRepositoryExtension -FromModule <string> [-Version <string>] [-ModuleRoot <string>]
 [-Subfolder <string>] [-Trust] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Accepts an extension as a `.zip`, a folder, a `.nupkg`, a package from a registered
repository, or an installed PowerShell module, and places its files in the plugin subfolder
the module scans at import.

The checks run **before** anything is copied. Strong name and contract compatibility are
verified up front, so an extension that could never load fails here — with a message —
instead of turning into a provider that is quietly missing after the next restart.

Installing over an existing extension is a normal operation, not an error. The versions are
compared and the outcome reported as `Installed`, `Upgraded`, `Reinstalled` or `Downgraded`;
moving to an older version requires `-Force`.

Shared dependencies are the delicate part, because everything in the module root has one
identity for the whole process and each decision there is process-wide:

- a newer version within the same major replaces the existing one
- a newer version across majors is **not** replaced; `-Force` names the host assemblies and
  extensions that would start binding to it
- an older version is never installed over a newer one

What each extension contributed is recorded in `extensions.deps.json`, which is what lets
`Uninstall-PSDataRepositoryExtension` clean up later without breaking anything else.

## EXAMPLES

### Example 1: Install from a release artifact

```powershell
Install-PSDataRepositoryExtension -Path .\PSDataRepository.Formatters.Xlsx-1.0.0.zip
```

Fails if the extension is signed with a key the module does not trust. That is the intended
outcome — see `-Trust`.

### Example 2: Install and trust a third-party key

```powershell
Install-PSDataRepositoryExtension -Path .\Contoso.Provider.zip -Trust
```

`-Trust` adds the signing key to `extensions.trust.json`, which lets **every** assembly
signed with that key execute inside the host. It is a separate, deliberate decision, not a
convenience switch.

### Example 3: Install from a feed

```powershell
Install-PSDataRepositoryExtension -Name PSDataRepository.Formatters.Xlsx -Repository MyFeed -Version 1.0.0
```

### Example 4: Install from a module fetched from the PowerShell Gallery

```powershell
Install-Module PSDataRepository.Formatters.Xlsx
Install-PSDataRepositoryExtension -FromModule PSDataRepository.Formatters.Xlsx
```

The gallery package is a wrapper: it carries the payload and declares the dependency on
`PSDataRepository`, but the files still have to be placed into the module. This is the step
that does it.

### Example 5: Carry extensions over to a newly installed module version

```powershell
Update-Module PSDataRepository
Install-PSDataRepositoryExtension -FromModule PSDataRepository -Version 0.7.1 -Trust
```

Extensions live inside the module folder, so a new module version starts with none of them.
This moves every third-party extension out of the named older version — assemblies, their
dependencies and their trust entries — in one command. In-box providers, formatters and auth
extensions are skipped: they ship with each version already.

Omit `-Trust` to install the files without trusting their signing keys; the extensions are
then visible to `Get-PSDataRepositoryExtension` but refused at load until their tokens are
added to `extensions.trust.json`. Restart PowerShell afterwards for the migrated extensions
to be loaded.

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

Overwrite an already installed extension.

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

### -FromModule

Name of an installed PowerShell module. Two shapes are recognised.

A thin payload module — how an extension published to the PowerShell Gallery arrives, since
the gallery only accepts modules — is scanned like any other payload directory.

An installed **PSDataRepository module itself** (typically an older version, selected with
`-Version`) is treated as a migration source instead: its third-party extensions are
discovered by strong-name token, their dependencies resolved from the source's dependency
record (or, failing that, a referenced-assembly closure), and everything is installed into
this module. In-box providers, formatters and auth extensions ship with every module version
and are never migrated.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: InstalledModule
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ModuleRoot

Module root to install into. Defaults to the running module.

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

Package id to install from a registered PSResource repository.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Feed
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

Path to a .zip artifact, .nupkg, folder, or a single extension .dll.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Path
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Repository

Name of a repository registered with Register-PSResourceRepository.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Feed
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Subfolder

Plugin subfolder. Only needed when the assembly carries no SDK metadata.

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

### -Trust

Also trust the extension's signing key by adding its token to extensions.trust.json.

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

### -Version

Version to fetch from the repository, or — with `-FromModule` — the installed module version
to use. Latest (feed) or highest installed (module) when omitted.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Feed
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: InstalledModule
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

## OUTPUTS

### System.Management.Automation.PSObject

One object describing the outcome, including the extension name, the resulting version, the
action taken (`Installed`, `Upgraded`, `Reinstalled` or `Downgraded`) and the files placed
in the module root on the extension's behalf.

## NOTES

The extension is not available until PowerShell is restarted. Assemblies cannot be unloaded
from a live session, so `Import-Module -Force` is not enough — and the previously loaded
copy keeps serving requests until the process ends.

`-Trust` grants execution rights to a signing key, not to a single file. Treat it the way
you would treat installing a certificate.

## RELATED LINKS

- [Get-PSDataRepositoryExtension](Get-PSDataRepositoryExtension.md)
- [Uninstall-PSDataRepositoryExtension](Uninstall-PSDataRepositoryExtension.md)
- [Security model](Security.md)
- [Extensions SDK guide](Extensions.md)

