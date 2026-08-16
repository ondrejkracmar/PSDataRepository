# PSDataRepository Extensions SDK (0.7.3)

> This package set is versioned with the module build it came from (module `0.7.3`).
> Whether an extension you already built still loads is NOT decided by this version — the
> SDK stamps a separate contract version into your assembly and the module's loader checks
> that. See the extension authoring guide in `docs/`.

This folder contains a **self-contained, restorable NuGet package set** for building
your own PSDataRepository extensions (providers, authentication resolvers, formatters).
The SDK meta-package depends on the other packages here, so they ship together and
restore offline from this single folder — no extra feed required.

## Packages

- `PSDataRepository.Abstractions.0.7.3.nupkg`
- `PSDataRepository.Authentications.0.7.3.nupkg`
- `PSDataRepository.Authentications.AzAuth.0.7.3.nupkg`
- `PSDataRepository.Extensions.Sdk.0.7.3.nupkg`
- `PSDataRepository.Formatters.0.7.3.nupkg`
- `PSDataRepository.Providers.0.7.3.nupkg`

## Use it in your extension project

1. Download (or clone) this repository so you have a local copy of the `sdk/` folder.

2. Add a `nuget.config` next to your extension's `.csproj` (or solution) that
   points NuGet at this folder:

   ```xml
   <?xml version="1.0" encoding="utf-8"?>
   <configuration>
     <packageSources>
       <add key="PSDataRepository-SDK" value="path/to/sdk" />
     </packageSources>
   </configuration>
   ```

3. Reference the SDK from your extension project:

   ```sh
   dotnet add package PSDataRepository.Extensions.Sdk --version 0.7.3
   ```

The SDK brings in the contract assemblies and the MSBuild targets that validate and
deploy your extension automatically. See the `docs/` folder and the project
`README.md` for the extension authoring guide.
