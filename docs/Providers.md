# Providers

| Provider | Capability | Azure Required | Typical Authentication |
|---|---|---|---|
| **AzureBlob** | Storage | Yes | ConnectionString, SAS, MI, SP, Interactive, DeviceCode, DAC, WI, STC |
| **AzureQueue** | Queue | Yes | ConnectionString, SAS, MI, SP, Interactive, DeviceCode, DAC, WI, STC |
| **AzureServiceBus** | Queue | Yes | ConnectionString, MI, SP, DAC |
| **AzureKeyVault** | Secrets | Yes | MI, SP, Interactive, DeviceCode, DAC, WI, STC |
| **Disk** | Storage, Queue, Secrets | No | None (local filesystem); optional `Passphrase` for encrypted secrets |
| **InMemory** | Queue | No | None (volatile, ideal for tests) |
| **Scp** | Storage | No | SSH Username + Password / PrivateKey |
| **Ftp** | Storage | No | FTP Username + Password; optional FTPS (TLS) |

> **MI** = Managed Identity, **SP** = Service Principal (ClientSecret / Certificate),
> **DAC** = DefaultAzureCredential, **WI** = Workload Identity, **STC** = Shared Token Cache

---

## Authentication backend

Azure providers funnel every credential through
[`PSDataRepository.Authentications.AzAuth`](../src/PSDataRepository.Authentications.AzAuth) →
`AzureAuthResolver` (3‑way dispatch: ConnectionString / SAS / TokenCredential)
→ `Isystem.AzAuth.Core` + `Azure.Identity`.

See [Architecture](Architecture.md) for the full picture and
[Extensions.md](Extensions.md) for adding a new authentication backend
(AWS, GCP, SharePoint Online, …) the same way.
