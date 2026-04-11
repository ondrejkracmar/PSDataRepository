---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: cs-CZ
Module Name: PSDataRepository
ms.date: 04.08.2026
PlatyPS schema version: 2024-05-01
title: Connect-PSDataRepository
---

# Connect-PSDataRepository

## SYNOPSIS

Connects to a data repository (Azure Blob, Queue, Service Bus, Key Vault, Disk, or InMemory).

## SYNTAX

### Disk (Default)

```
Connect-PSDataRepository -Disk] [[-Path] <string>] [-AccountName <string>] [-ContainerName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>]
 [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>]
 [-TimeoutSeconds <int>] [-TestConnection] [<CommonParameters>]
```

### InMemory

```
Connect-PSDataRepository -InMemory] [-AccountName <string>] [-ContainerName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>]
 [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>]
 [-TimeoutSeconds <int>] [-TestConnection] [<CommonParameters>]
```

### ConnectionString

```
Connect-PSDataRepository [-ConnectionString] <string> [-AccountName <string>]
 [-ContainerName <string>] [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>]
 [-VaultName <string>] [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>]
 [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>] [-TestConnection] [<CommonParameters>]
```

### SasToken

```
Connect-PSDataRepository -SasToken <string> [-AccountName <string>] [-ContainerName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>]
 [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>]
 [-TimeoutSeconds <int>] [-TestConnection] [<CommonParameters>]
```

### ClientSecret

```
Connect-PSDataRepository -TenantId <string> -ClientId <string> -ClientSecret <securestring>
 [-AccountName <string>] [-ContainerName <string>] [-QueueName <string>] [-TopicName <string>]
 [-SubscriptionName <string>] [-VaultName <string>] [-ProxyUri <string>] [-MaxRetries <int>]
 [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>] [-TestConnection]
 [<CommonParameters>]
```

### ClientCertificate

```
Connect-PSDataRepository -TenantId <string> -ClientId <string> -CertificatePath <string>
 [-AccountName <string>] [-ContainerName <string>] [-QueueName <string>] [-TopicName <string>]
 [-SubscriptionName <string>] [-VaultName <string>] [-CertificatePassword <securestring>]
 [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>]
 [-TimeoutSeconds <int>] [-TestConnection] [<CommonParameters>]
```

### WorkloadIdentity

```
Connect-PSDataRepository -TenantId <string> -ClientId <string> -WorkloadIdentity
 -TokenFilePath <string> [-AccountName <string>] [-ContainerName <string>] [-QueueName <string>]
 [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>] [-ProxyUri <string>]
 [-MaxRetries <int>] [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>]
 [-TimeoutSeconds <int>] [-TestConnection] [<CommonParameters>]
```

### Interactive

```
Connect-PSDataRepository -Interactive [-AccountName <string>] [-ContainerName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>]
 [-TenantId <string>] [-ClientId <string>] [-ProxyUri <string>] [-MaxRetries <int>]
 [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>] [-TestConnection]
 [<CommonParameters>]
```

### DeviceCode

```
Connect-PSDataRepository -DeviceCode [-AccountName <string>] [-ContainerName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>]
 [-TenantId <string>] [-ClientId <string>] [-ProxyUri <string>] [-MaxRetries <int>]
 [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>] [-TestConnection]
 [<CommonParameters>]
```

### SharedTokenCache

```
Connect-PSDataRepository -SharedTokenCache [-AccountName <string>] [-ContainerName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>]
 [-TenantId <string>] [-Username <string>] [-ProxyUri <string>] [-MaxRetries <int>]
 [-RetryDelaySeconds <int>] [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>] [-TestConnection]
 [<CommonParameters>]
```

### DefaultAzureCredential

```
Connect-PSDataRepository -DefaultAzureCredential [-AccountName <string>] [-ContainerName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>]
 [-TenantId <string>] [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>]
 [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>] [-TestConnection] [<CommonParameters>]
```

### ManagedIdentity

```
Connect-PSDataRepository -ManagedIdentity [-AccountName <string>] [-ContainerName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>] [-VaultName <string>]
 [-ClientId <string>] [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>]
 [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>] [-TestConnection] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Establishes a session to a data repository provider.
The provider type is automatically detected from the supplied parameters (connection string, account name, vault name, etc.).

Supports 12 authentication methods including connection strings, SAS tokens, Managed Identity, client secrets/certificates, interactive browser, device code, and DefaultAzureCredential.

For local development, use `-Disk` or `-InMemory` switches which require no authentication.

The provider is auto-detected based on supplied parameters:

- `-VaultName` → AzureKeyVault

- `-TopicName` / `-SubscriptionName` → AzureServiceBus

- `-QueueName` → AzureQueue

- `-ContainerName` → AzureBlob

- `-Disk` → Disk

- `-InMemory` → InMemory

## EXAMPLES

### Local disk storage

Connect-PSDataRepository -Disk -Path "C:\Data\MyRepo"

Connects to a local disk-based repository at the specified path.

### In-memory (testing)

Connect-PSDataRepository -InMemory

Connects to a volatile in-memory repository (useful for testing).

### Azure Blob Storage (connection string)

Connect-PSDataRepository -ConnectionString $connStr -ContainerName "mydata"

Connects to Azure Blob Storage using a connection string.

### Azure Queue (DefaultAzureCredential)

Connect-PSDataRepository -DefaultAzureCredential -AccountName "mystorageaccount" -QueueName "tasks"

Connects to Azure Queue Storage using DefaultAzureCredential.

### Azure Key Vault (Managed Identity)

Connect-PSDataRepository -ManagedIdentity -VaultName "mykeyvault"

Connects to Azure Key Vault using Managed Identity.

### Azure Service Bus topic

Connect-PSDataRepository -ConnectionString $sbConnStr -TopicName "events" -SubscriptionName "processor"

Connects to an Azure Service Bus topic with a subscription.

### With connection test and proxy

Connect-PSDataRepository -ManagedIdentity -AccountName "stprod" -ContainerName "data" -TestConnection -ProxyUri "http://proxy.corp:8080"

Connects via proxy and validates the connection after establishing it.

## PARAMETERS

### -AccountName

Storage account name, namespace, or path.

```yaml
Type: System.String
DefaultValue: None
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

### -CertificatePassword

Certificate password.

```yaml
Type: System.Security.SecureString
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ClientCertificate
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CertificatePath

Path to certificate file (.pfx).

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ClientCertificate
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ClientId

Azure AD Application (Client) ID.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ClientSecret
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ClientCertificate
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WorkloadIdentity
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ManagedIdentity
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Interactive
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DeviceCode
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ClientSecret

Azure AD Application Client Secret.

```yaml
Type: System.Security.SecureString
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ClientSecret
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ConnectionString

Connection string with AccountKey or SharedAccessKey.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ConnectionString
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ContainerName

Container, queue, or topic name.

```yaml
Type: System.String
DefaultValue: None
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

### -DefaultAzureCredential

Use DefaultAzureCredential (tries multiple authentication methods automatically).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DefaultAzureCredential
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DeviceCode

Use device code authentication.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: DeviceCode
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Disk

Use Disk provider with file-based storage (no authentication required).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Disk
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -InMemory

Use InMemory provider for volatile storage (no authentication required).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: InMemory
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Interactive

Use interactive browser authentication.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Interactive
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ManagedIdentity

Use Managed Identity for authentication.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ManagedIdentity
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxRetries

Maximum number of retry attempts for failed operations.

```yaml
Type: System.Int32
DefaultValue: 3
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

### -MaxRetryDelaySeconds

Maximum delay in seconds between retry attempts (exponential backoff cap).

```yaml
Type: System.Int32
DefaultValue: 30
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

### -Path

File path for Disk provider storage.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases:
- FilePath
ParameterSets:
- Name: Disk
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProxyUri

Proxy URI for corporate proxy (e.g., `http://proxy.corp.local:8080`).

```yaml
Type: System.String
DefaultValue: None
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

### -QueueName

Queue name (for queue providers).

```yaml
Type: System.String
DefaultValue: None
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

### -RetryDelaySeconds

Delay in seconds between retry attempts.

```yaml
Type: System.Int32
DefaultValue: 2
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

### -SasToken

SAS (Shared Access Signature) token or full SAS URI.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SasToken
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SharedTokenCache

Use shared token cache authentication.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SharedTokenCache
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SubscriptionName

Subscription name (for Service Bus topics).

```yaml
Type: System.String
DefaultValue: None
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

### -TenantId

Azure AD Tenant ID.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ClientSecret
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ClientCertificate
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: WorkloadIdentity
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Interactive
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DeviceCode
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: SharedTokenCache
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: DefaultAzureCredential
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TestConnection

Test connection after establishing it to validate connectivity.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -TimeoutSeconds

Connection timeout in seconds.

```yaml
Type: System.Int32
DefaultValue: 30
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

### -TokenFilePath

Token file path for Workload Identity.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WorkloadIdentity
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TopicName

Topic name (for Service Bus topics).

```yaml
Type: System.String
DefaultValue: None
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

### -Username

Username for shared token cache.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: SharedTokenCache
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -VaultName

Key Vault name (for Azure Key Vault provider).

```yaml
Type: System.String
DefaultValue: None
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

### -WorkloadIdentity

Use Workload Identity (Kubernetes) for authentication.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: WorkloadIdentity
  Position: Named
  IsRequired: true
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

### System.String

Connection confirmation message.

## NOTES

The provider type is auto-detected from supplied parameters.
Connection strings and sensitive values are sanitized in verbose output.

When `-TestConnection` is specified and the test fails, the session is automatically cleared.

Enterprise features (proxy, retries, timeout) are only applied to Azure providers, not Disk/InMemory.


## RELATED LINKS

- [Disconnect-PSDataRepository]()
- [Get-PSDataRepositorySession]()
- [Get-PSDataRepositoryProvider]()
