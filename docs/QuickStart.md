# Quick Start

## Installation

```powershell
# From PowerShell Gallery
Install-Module -Name PSDataRepository -Scope CurrentUser

# From Azure Artifacts feed
Register-PSRepository -Name 'PSDataRepositoryFeed' -SourceLocation '<your-feed-url>'
Install-Module -Name PSDataRepository -Repository 'PSDataRepositoryFeed'
```

---

## Local development (Disk)

```powershell
Connect-PSDataRepository -Provider Disk -Path "C:\AutomationData"

$servers = @(
    [PSCustomObject]@{ Id = 1; Name = "Server01"; Status = "Running" }
    [PSCustomObject]@{ Id = 2; Name = "Server02"; Status = "Stopped" }
)
$servers | Set-PSDataRepositoryItem -Name "servers.json"

$data = Get-PSDataRepositoryItem -Name "servers.json"
Get-PSDataRepositoryChildItem -Filter "*.json" | Format-Table Name, Size, LastModified

Disconnect-PSDataRepository
```

## Azure Blob Storage (Managed Identity)

```powershell
Connect-PSDataRepository -Provider AzureBlob -ManagedIdentity -AccountName "stprod" -ContainerName "data"
$servers | Set-PSDataRepositoryItem -Name "servers.json"
$data = Get-PSDataRepositoryItem -Name "servers.json"
Disconnect-PSDataRepository
```

## SCP / SFTP (SSH key)

```powershell
Connect-PSDataRepository -Provider Scp -Host "backup.corp.local" -Username "deploy" -PrivateKeyPath "~/.ssh/id_rsa" -RemotePath "/archive"
Get-ChildItem C:\Reports -Filter "*.csv" | Copy-PSDataRepositoryItem -Destination "reports/"
Disconnect-PSDataRepository
```

## FTP / FTPS

```powershell
Connect-PSDataRepository -Provider Ftp -Host "ftp.vendor.com" -Username "upload" -Password $ftpPwd -UseSsl
Set-PSDataRepositoryItem -InputObject $export -Name "daily-export.json"
Disconnect-PSDataRepository
```

## Queue messaging

```powershell
Connect-PSDataRepository -Provider AzureQueue -DefaultAzureCredential -AccountName "stprod" -QueueName "tasks"

1..10000 | ForEach-Object { [PSCustomObject]@{Id=$_; Task="Item$_"} } |
    Send-PSDataRepositoryMessage -BatchSize 500

$messages = Receive-PSDataRepositoryMessage -MaxMessages 50
$messages | ForEach-Object { Process-Task $_ }

Disconnect-PSDataRepository
```

## Azure Key Vault — secret management

```powershell
Connect-PSDataRepository -Provider AzureKeyVault -ManagedIdentity -VaultName "mykeyvault"
Set-PSDataRepositorySecret -Name "ApiKey" -Value "super-secret-value"
$secret = Get-PSDataRepositorySecret -Name "ApiKey"
Remove-PSDataRepositorySecret -Name "ApiKey"
Disconnect-PSDataRepository
```

## Compression & encryption

```powershell
Connect-PSDataRepository -Provider Disk -Path "C:\SecureData"
$pwd = Read-Host -AsSecureString "Encryption password"

# AES-256-GCM, PBKDF2 600k iterations
Compress-PSDataRepositoryItem -Name "sensitive.json" -Password $pwd
Expand-PSDataRepositoryItem -Name "sensitive.json.gz.enc" -Password $pwd

Disconnect-PSDataRepository
```

## Copy files into a repository

```powershell
Connect-PSDataRepository -Provider AzureBlob -DefaultAzureCredential -AccountName "stprod" -ContainerName "uploads"

# Recursive directory upload
Copy-PSDataRepositoryItem -Path "C:\Export\" -Recurse -Destination "export/"

# Filtered + flattened
Get-ChildItem C:\Logs -Recurse -File -Filter "*.log" |
    Copy-PSDataRepositoryItem -Destination "logs/" -Flatten

# Intra-repository copy
Get-PSDataRepositoryChildItem -Path "staging/" |
    Copy-PSDataRepositoryItem -Destination "production/"

Disconnect-PSDataRepository
```

---

## Next

- [Cmdlet reference](Cmdlets.md)
- [Providers](Providers.md)
- [Architecture](Architecture.md)
