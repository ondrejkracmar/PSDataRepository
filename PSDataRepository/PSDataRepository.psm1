# PSDataRepository module loader
# Selects the correct binary for the running .NET runtime version.
# PowerShell 7.4 runs on .NET 8, PowerShell 7.6+ runs on .NET 10.

$dotnetMajor = [System.Environment]::Version.Major
$framework = if ($dotnetMajor -ge 10) { 'net10.0' } else { 'net8.0' }

$binRoot = [System.IO.Path]::Combine($PSScriptRoot, 'bin', $framework)
if (-not (Test-Path -LiteralPath $binRoot)) {
    throw "PSDataRepository: build output for runtime '$framework' not found at '$binRoot'. " +
          "Detected .NET $($dotnetMajor).x; supported targets are net8.0 (PowerShell 7.4/7.5) " +
          "and net10.0 (PowerShell 7.6+). The module installation may be corrupted."
}

$binaryPath = [System.IO.Path]::Combine($binRoot, 'PSDataRepository.Commands.dll')
if (-not (Test-Path -LiteralPath $binaryPath)) {
    throw "PSDataRepository: could not find PSDataRepository.Commands.dll at '$binaryPath'. " +
          "The module installation may be corrupted."
}

Import-Module -Name $binaryPath

# Cleanup hook: when the module is removed (Remove-Module / session exit), tear down
# the AsyncLocal session, deregister the assembly resolver and reset the plugin loader
# so a subsequent Import-Module starts from a clean state.
$ExecutionContext.SessionState.Module.OnRemove = {
    try { [PSDataRepository.Core.Session.RepositorySession]::Clear() } catch { }
    try { [PSDataRepository.Core.Extensions.ExtensionLoader]::Reload() } catch { }
}
