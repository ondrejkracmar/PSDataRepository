---
document type: cmdlet
external help file: PSDataRepository.dll-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PSDataRepository
ms.date: 04.12.2026
PlatyPS schema version: 2024-05-01
title: Connect-PSDataRepository
---

# Connect-PSDataRepository

## SYNOPSIS

Connects to a data repository provider (Azure Blob, Queue, Service Bus, Key Vault, Disk, InMemory, SCP, or FTP).

## SYNTAX

### AzureBlob

```
Connect-PSDataRepository [-Provider] <string> [-AccountName <string>] -ContainerName <string>
 [-ConnectionString <securestring>] [-SasToken <securestring>]
 [-ManagedIdentity] [-WorkloadIdentity] [-Interactive] [-DeviceCode]
 [-DefaultAzureCredential] [-SharedTokenCache]
 [-TenantId <string>] [-ClientId <string>] [-ClientSecret <securestring>]
 [-CertificatePath <string>] [-CertificatePassword <securestring>]
 [-TokenFilePath <string>] [-Username <string>]
 [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>]
 [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>]
 [-TestConnection] [<CommonParameters>]
```

### AzureQueue

```
Connect-PSDataRepository [-Provider] <string> [-AccountName <string>] -QueueName <string>
 [-ConnectionString <securestring>] [-SasToken <securestring>]
 [-ManagedIdentity] [-WorkloadIdentity] [-Interactive] [-DeviceCode]
 [-DefaultAzureCredential] [-SharedTokenCache]
 [-TenantId <string>] [-ClientId <string>] [-ClientSecret <securestring>]
 [-CertificatePath <string>] [-CertificatePassword <securestring>]
 [-TokenFilePath <string>] [-Username <string>]
 [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>]
 [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>]
 [-TestConnection] [<CommonParameters>]
```

### AzureServiceBus

```
Connect-PSDataRepository [-Provider] <string> [-AccountName <string>]
 [-QueueName <string>] [-TopicName <string>] [-SubscriptionName <string>]
 [-ConnectionString <securestring>]
 [-ManagedIdentity] [-WorkloadIdentity] [-Interactive] [-DeviceCode]
 [-DefaultAzureCredential] [-SharedTokenCache]
 [-TenantId <string>] [-ClientId <string>] [-ClientSecret <securestring>]
 [-CertificatePath <string>] [-CertificatePassword <securestring>]
 [-TokenFilePath <string>] [-Username <string>]
 [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>]
 [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>]
 [-TestConnection] [<CommonParameters>]
```

### AzureKeyVault

```
Connect-PSDataRepository [-Provider] <string> -VaultName <string>
 [-ManagedIdentity] [-WorkloadIdentity] [-Interactive] [-DeviceCode]
 [-DefaultAzureCredential] [-SharedTokenCache]
 [-TenantId <string>] [-ClientId <string>] [-ClientSecret <securestring>]
 [-CertificatePath <string>] [-CertificatePassword <securestring>]
 [-TokenFilePath <string>] [-Username <string>]
 [-ProxyUri <string>] [-MaxRetries <int>] [-RetryDelaySeconds <int>]
 [-MaxRetryDelaySeconds <int>] [-TimeoutSeconds <int>]
 [-TestConnection] [<CommonParameters>]
```

### Disk

```
Connect-PSDataRepository [-Provider] <string> [-Path <string>]
 [-Passphrase <securestring>] [-TestConnection] [<CommonParameters>]
```

### InMemory

```
Connect-PSDataRepository [-Provider] <string> [-TestConnection] [<CommonParameters>]
```

### Scp

```
Connect-PSDataRepository [-Provider] <string> -Host <string> [-RemotePath <string>]
 -Username <string> [-Password <securestring>]
 [-PrivateKeyPath <string>] [-KeyPassphrase <securestring>]
 [-Port <int>] [-TestConnection] [<CommonParameters>]
```

### Ftp

```
Connect-PSDataRepository [-Provider] <string> -Host <string> [-RemotePath <string>]
 [-Username <string>] [-Password <securestring>]
 [-UseSsl] [-SkipCertificateCheck]
 [-Port <int>] [-TestConnection] [<CommonParameters>]
```

## ALIASES

This cmdlet has no aliases.

## DESCRIPTION

Establishes a session to a data repository provider. The first mandatory parameter is `-Provider`,
which determines the type of repository. Once the provider is selected, only the relevant
parameters for that provider are available (dynamic parameters).

Supports 10 authentication methods for Azure providers including connection strings, SAS tokens,
Managed Identity, Workload Identity, client secrets/certificates, interactive browser, device code,
SharedTokenCache, and DefaultAzureCredential.

For local development, use Provider `Disk` or `InMemory` which require no authentication.
For remote file access, use Provider `Scp` (SFTP) or `Ftp`.

## EXAMPLES

### Example 1: Local disk storage

```powershell
Connect-PSDataRepository -Provider Disk -Path "C:\Data\MyRepo"
```

Connects to a local disk-based repository at the specified path.

### Example 2: In-memory (testing)

```powershell
Connect-PSDataRepository -Provider InMemory
```

Connects to a volatile in-memory repository (useful for unit testing).

### Example 3: Azure Blob Storage (connection string)

```powershell
Connect-PSDataRepository -Provider AzureBlob -ConnectionString $connStr -ContainerName "mydata"
```

Connects to Azure Blob Storage using a connection string.

### Example 4: Azure Queue (DefaultAzureCredential)

```powershell
Connect-PSDataRepository -Provider AzureQueue -DefaultAzureCredential -AccountName "mystorageaccount" -QueueName "tasks"
```

Connects to Azure Queue Storage using DefaultAzureCredential.

### Example 5: Azure Key Vault (Managed Identity)

```powershell
Connect-PSDataRepository -Provider AzureKeyVault -ManagedIdentity -VaultName "mykeyvault"
```

Connects to Azure Key Vault using Managed Identity.

### Example 6: Azure Service Bus topic

```powershell
Connect-PSDataRepository -Provider AzureServiceBus -ConnectionString $sbConnStr -TopicName "events" -SubscriptionName "processor"
```

Connects to an Azure Service Bus topic with a subscription.

### Example 7: SCP/SFTP with private key

```powershell
Connect-PSDataRepository -Provider Scp -Host "sftp.example.com" -Username "deploy" -PrivateKeyPath "~/.ssh/id_rsa" -RemotePath "/uploads"
```

Connects to an SFTP server using SSH private key authentication.

### Example 8: FTP with TLS

```powershell
Connect-PSDataRepository -Provider Ftp -Host "ftp.example.com" -Username "user" -Password $secPwd -UseSsl
```

Connects to an FTP server over TLS (FTPS).

### Example 9: Azure Blob with client certificate and enterprise options

```powershell
Connect-PSDataRepository -Provider AzureBlob -AccountName "mystorageaccount" -ContainerName "data" `
  -TenantId "00000000-0000-0000-0000-000000000000" -ClientId "app-id" `
  -CertificatePath "C:\certs\app.pfx" -CertificatePassword $certPwd `
  -ProxyUri "http://proxy.corp.local:8080" -MaxRetries 5 -TimeoutSeconds 60 `
  -TestConnection
```

Connects using client certificate authentication through a corporate proxy with custom retry settings, and validates connectivity.

### Example 10: Disk with encryption

```powershell
Connect-PSDataRepository -Provider Disk -Path "C:\SecureData" -Passphrase (Read-Host -AsSecureString "Enter passphrase")
```

Connects to an encrypted disk-based secret storage (AES-256-GCM).

## PARAMETERS

### -Provider

Data repository provider type to connect to. Once selected, only parameters relevant to the
chosen provider will be available.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues:
- AzureBlob
- AzureQueue
- AzureServiceBus
- AzureKeyVault
- Disk
- InMemory
- Scp
- Ftp
HelpMessage: Data repository provider type to connect to.
```

### -AccountName

Storage account name (AzureBlob, AzureQueue) or Service Bus namespace name (AzureServiceBus).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Storage account name.
```

### -ContainerName

Blob container name. Required for AzureBlob provider.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Blob container name.
```

### -QueueName

Queue name. Required for AzureQueue provider. Optional for AzureServiceBus (mutually exclusive with TopicName).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureQueue
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Queue name.
```

### -VaultName

Key Vault name or URI. Required for AzureKeyVault provider.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureKeyVault
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Key Vault name or URI.
```

### -TopicName

Service Bus topic name. When specified, `-SubscriptionName` is also required.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Service Bus topic name.
```

### -SubscriptionName

Subscription name. Required when `-TopicName` is specified (AzureServiceBus).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Subscription name (required when TopicName is specified).
```

### -Path

File path for disk provider storage.

```yaml
Type: System.String
DefaultValue: ''
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
HelpMessage: File path for disk provider storage.
```

### -Passphrase

Encryption passphrase for disk-based secret storage (AES-256-GCM).

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Disk
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Encryption passphrase for disk-based secret storage (AES-256-GCM).
```

### -Host

Server hostname. Required for Scp and Ftp providers.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scp
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Ftp
  Position: 1
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Server hostname.
```

### -RemotePath

Remote base directory path. Defaults to `/`.

```yaml
Type: System.String
DefaultValue: /
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scp
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Ftp
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Remote base directory path (default '/').
```

### -Username

Username for authentication. Required for Scp. Optional for Ftp (default 'anonymous') and Azure shared token cache.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scp
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Ftp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Username for authentication.
```

### -Password

Password for Scp or Ftp authentication.

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Ftp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Password.
```

### -PrivateKeyPath

Path to SSH private key file (Scp provider).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Path to SSH private key file.
```

### -KeyPassphrase

Passphrase for the SSH private key (Scp provider).

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Passphrase for the private key.
```

### -Port

Port number. Default: 22 for Scp, 21 for Ftp. Valid range: 1-65535.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Ftp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Port number.
```

### -UseSsl

Use FTPS (FTP over TLS). Ftp provider only.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Ftp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Use FTPS (FTP over TLS).
```

### -SkipCertificateCheck

Skip TLS certificate validation. NOT recommended for production. Ftp provider only.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Ftp
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Skip TLS certificate validation (NOT recommended for production).
```

### -ConnectionString

Connection string with AccountKey or SharedAccessKey. Available for AzureBlob, AzureQueue, and AzureServiceBus providers.

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Connection string with AccountKey or SharedAccessKey.
```

### -SasToken

SAS (Shared Access Signature) token or full SAS URI. Available for AzureBlob and AzureQueue providers.

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: SAS (Shared Access Signature) token or full SAS URI.
```

### -ManagedIdentity

Use Managed Identity for authentication. Azure providers only.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Use Managed Identity for authentication.
```

### -WorkloadIdentity

Use Workload Identity (Kubernetes) for authentication. Azure providers only.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Use Workload Identity (Kubernetes) for authentication.
```

### -Interactive

Use interactive browser authentication. Azure providers only.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Use interactive browser authentication.
```

### -DeviceCode

Use device code authentication. Azure providers only.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Use device code authentication.
```

### -DefaultAzureCredential

Use DefaultAzureCredential (tries multiple authentication methods automatically). Azure providers only.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Use DefaultAzureCredential (tries multiple authentication methods automatically).
```

### -SharedTokenCache

Use shared token cache authentication. Azure providers only.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Use shared token cache authentication.
```

### -TenantId

Azure AD Tenant ID. Azure providers only.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Azure AD Tenant ID.
```

### -ClientId

Azure AD Application (Client) ID. Azure providers only.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Azure AD Application (Client) ID.
```

### -ClientSecret

Azure AD Application Client Secret. Azure providers only.

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Azure AD Application Client Secret.
```

### -CertificatePath

Path to certificate file (.pfx). Azure providers only.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Path to certificate file (.pfx).
```

### -CertificatePassword

Certificate password. Azure providers only.

```yaml
Type: System.Security.SecureString
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Certificate password.
```

### -TokenFilePath

Token file path for Workload Identity. Azure providers only.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Token file path for Workload Identity.
```

### -ProxyUri

Proxy URI for corporate proxy (e.g., `http://proxy.corp.local:8080`). Azure providers only.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Proxy URI for corporate proxy.
```

### -MaxRetries

Maximum number of retry attempts for failed operations. Default: 3. Valid range: 1-10. Azure providers only.

```yaml
Type: System.Int32
DefaultValue: '3'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Maximum number of retry attempts for failed operations. Default 3.
```

### -RetryDelaySeconds

Delay in seconds between retry attempts. Default: 2. Valid range: 1-60. Azure providers only.

```yaml
Type: System.Int32
DefaultValue: '2'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Delay in seconds between retry attempts. Default 2.
```

### -MaxRetryDelaySeconds

Maximum delay in seconds between retry attempts (exponential backoff cap). Default: 30. Valid range: 5-300. Azure providers only.

```yaml
Type: System.Int32
DefaultValue: '30'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Maximum delay in seconds between retry attempts (exponential backoff cap). Default 30.
```

### -TimeoutSeconds

Connection timeout in seconds. Default: 30. Valid range: 5-300. Azure providers only.

```yaml
Type: System.Int32
DefaultValue: '30'
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: AzureBlob
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureQueue
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureServiceBus
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: AzureKeyVault
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: Connection timeout in seconds. Default 30.
```

### -TestConnection

Test connection after establishing it to validate connectivity. Available for all providers.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: 'false'
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
HelpMessage: Test connection after establishing it to validate connectivity.
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.String

Connection confirmation message.

## NOTES

The provider type determines which dynamic parameters are available. Only parameters
relevant to the chosen provider are exposed.

Connection strings and sensitive values are sanitized in verbose output.

When `-TestConnection` is specified and the test fails, the session is automatically cleared.

Enterprise features (proxy, retries, timeout) are available only for Azure providers,
not for Disk, InMemory, Scp, or Ftp.

For Scp, either `-Password` or `-PrivateKeyPath` (or both) must be provided.

## RELATED LINKS

- [Disconnect-PSDataRepository](Disconnect-PSDataRepository.md)
- [Get-PSDataRepositorySession](Get-PSDataRepositorySession.md)
- [Get-PSDataRepositoryProvider](Get-PSDataRepositoryProvider.md)
- [Test-PSDataRepositoryConnection](Test-PSDataRepositoryConnection.md)
