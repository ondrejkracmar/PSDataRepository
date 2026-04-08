# PSDataRepository module loader
# Selects the correct binary for the running .NET runtime version.
# PowerShell 7.4 runs on .NET 8, PowerShell 7.6+ runs on .NET 10.

$dotnetMajor = [System.Environment]::Version.Major
$framework = if ($dotnetMajor -ge 10) { 'net10.0' } else { 'net8.0' }

$binaryPath = [System.IO.Path]::Combine($PSScriptRoot, 'bin', $framework, 'PSDataRepository.dll')

if (-not (Test-Path -LiteralPath $binaryPath)) {
    throw "Could not find PSDataRepository.dll at '$binaryPath'. The module installation may be corrupted."
}

$null = Import-Module -Name $binaryPath -PassThru
