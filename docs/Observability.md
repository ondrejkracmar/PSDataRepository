# Observability, Serialization & Encryption

## Serialization formats

| Format | Parameter | Auto-Detection |
|--------|-----------|----------------|
| JSON | `-Format Json` | `.json` extension, or content starting with `{` / `[` |
| XML | `-Format Xml` | `.xml` extension, or content starting with `<` |
| CSV | `-Format Csv` | `.csv` extension, or header row heuristic |
| YAML | `-Format Yml` | `.yml` / `.yaml` extension, or `---` / `key: value` content pattern |

When no format is specified, the module auto‑detects from the file extension
or content. You can always override with `-Format`.

---

## Encryption

PSDataRepository supports three encryption versions for backward compatibility:

| Version | Algorithm | Key Derivation | Iterations | Status |
|---------|-----------|----------------|------------|--------|
| V3 (current) | AES-256-GCM | PBKDF2-SHA256 | 600,000 | **Default for new data** |
| V2 | AES-256-GCM | PBKDF2-SHA256 | 100,000 | Read-only (backward compat) |
| V1 | AES-256-CBC | PBKDF2-SHA256 | 100,000 | Read-only (backward compat) |

All versions are auto‑detected when reading, so older encrypted files remain
accessible.

---

## Enterprise features

| Feature | Parameter | Description |
|---------|-----------|-------------|
| **Proxy support** | `-ProxyUri "http://proxy.corp:8080"` | Route all traffic through a corporate HTTP proxy |
| **Retry with backoff** | `-MaxRetries 5 -RetryDelaySeconds 2 -MaxRetryDelaySeconds 60` | Automatic retry with exponential backoff on transient failures |
| **Connection timeout** | `-TimeoutSeconds 30` | Timeout for connection and individual operations |
| **Connection validation** | `-TestConnection` | Validates connectivity immediately after `Connect-PSDataRepository` |
| **CancellationToken** | (internal) | All async operations propagate `CancellationToken` for cooperative cancellation |
| **Structured logging** | (internal) | `ILogger<T>` injected into providers; works with any `Microsoft.Extensions.Logging` sink |
| **Health checks** | `StorageRepositoryHealthCheck` / `SecretRepositoryHealthCheck` | `IHealthCheck` implementations for ASP.NET Core health endpoints |
| **OpenTelemetry** | `PSDataRepository` ActivitySource + Meter | Distributed tracing spans + counters / histograms |

---

## OpenTelemetry instrumentation

PSDataRepository emits **distributed tracing spans** and **metrics** through
a single `ActivitySource` and `Meter`, both named **`PSDataRepository`**
(constant: `RepositoryDiagnostics.SourceName`).

### Instruments

| Kind | Name | Unit | Tags |
|---|---|---|---|
| Counter | `psdr.storage.reads` | operations | `psdr.provider`, `psdr.operation` |
| Counter | `psdr.storage.writes` | operations | `psdr.provider`, `psdr.operation` |
| Counter | `psdr.storage.deletes` | operations | `psdr.provider`, `psdr.operation` |
| Counter | `psdr.storage.lists` | operations | `psdr.provider`, `psdr.operation` |
| Counter | `psdr.storage.errors` | errors | `psdr.provider`, `psdr.operation` |
| Counter | `psdr.queue.sends` | operations | `psdr.provider`, `psdr.operation` |
| Counter | `psdr.queue.receives` | operations | `psdr.provider`, `psdr.operation` |
| Histogram | `psdr.storage.duration` | ms | `psdr.provider`, `psdr.operation` |
| Histogram | `psdr.storage.payload_size` | bytes | `psdr.provider`, `psdr.operation` |

Activity tags: `psdr.provider` (e.g. `AzureBlob`, `Disk`, `AzureQueue`,
`AzureServiceBus`, `AzureKeyVault`), `psdr.operation` (method name),
`psdr.item` (optional item key), and on failure `error=true` + `error.type`.

### Enabling in a host process

No listener is registered by default — instruments are no‑ops until you opt
in. Register once from C# (typical ASP.NET Core / worker host):

```csharp
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;

builder.Services.AddOpenTelemetry()
    .WithTracing(t => t
        .AddSource("PSDataRepository")
        .AddOtlpExporter())
    .WithMetrics(m => m
        .AddMeter("PSDataRepository")
        .AddOtlpExporter());
```

Or minimal, without OpenTelemetry SDK:

```csharp
using System.Diagnostics;
using System.Diagnostics.Metrics;

ActivitySource.AddActivityListener(new ActivityListener
{
    ShouldListenTo = src => src.Name == "PSDataRepository",
    Sample = (ref ActivityCreationOptions<ActivityContext> _) => ActivitySamplingResult.AllDataAndRecorded,
    ActivityStopped = a => Console.WriteLine($"{a.DisplayName} {a.Duration.TotalMilliseconds:F1}ms")
});

var listener = new MeterListener
{
    InstrumentPublished = (i, l) => { if (i.Meter.Name == "PSDataRepository") l.EnableMeasurementEvents(i); }
};
listener.SetMeasurementEventCallback<long>((i, v, _, _) => Console.WriteLine($"{i.Name}={v}"));
listener.SetMeasurementEventCallback<double>((i, v, _, _) => Console.WriteLine($"{i.Name}={v:F1}"));
listener.Start();
```
