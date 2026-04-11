# PSDataRepository — Source

This is the source code directory for the PSDataRepository module. For the full project documentation, see the [main README](../README.md).

## Build

```powershell
dotnet build PSDataRepository.sln
```

## Test

```powershell
dotnet test PSDataRepository.sln --configuration Release
```

## Project Structure

| Path | Description |
|------|-------------|
| `PSDataRepository/` | Main module project (C# binary module) |
| `PSDataRepository.Tests/` | Unit + integration tests (xUnit, FluentAssertions, Moq) |
| `azure-pipelines.yml` | Multi-stage Azure DevOps pipeline (Build & Test + Publish) |
| `Directory.Build.props` | Shared build properties |
| `GitVersion.yml` | Semantic versioning configuration |

## Requirements

- .NET 8 SDK or .NET 10 SDK
- PowerShell 7.4+ (Core edition)

## Author

**Ondrej Kracmar** — [i-System](https://www.i-system.cz)
