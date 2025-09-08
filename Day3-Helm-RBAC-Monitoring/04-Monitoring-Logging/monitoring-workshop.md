# Monitoring and Logging Workshop

## Exercise 1: Setting up Azure Monitor

```batch
@REM Enable monitoring addon
az aks enable-addons ^
    --resource-group myResourceGroup ^
    --name myAKSCluster ^
    --addons monitoring

@REM Verify monitoring pods
kubectl get pods -n kube-system | findstr omsagent
```

## Exercise 2: Prometheus and Grafana Setup

```batch
@REM Add Prometheus repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

@REM Install Prometheus stack
helm install monitoring prometheus-community/kube-prometheus-stack ^
    --namespace monitoring ^
    --create-namespace

@REM Verify installation
kubectl get pods -n monitoring
```

## Exercise 3: Custom Metrics Collection

### servicemonitor.yaml
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: app-metrics
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: myapp
  endpoints:
  - port: metrics
```

### prometheusrule.yaml
```yaml
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: app-alerts
  namespace: monitoring
spec:
  groups:
  - name: app.rules
    rules:
    - alert: HighErrorRate
      expr: sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) > 0.1
      for: 5m
      labels:
        severity: critical
      annotations:
        description: Error rate is high
```

## Exercise 4: FluentBit Setup

### fluent-bit-config.yaml
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluent-bit-config
  namespace: logging
data:
  fluent-bit.conf: |
    [SERVICE]
        Flush         1
        Log_Level    info
        Parsers_File parsers.conf

    [INPUT]
        Name             tail
        Path             /var/log/containers/*.log
        Parser           docker
        Tag              kube.*
        Refresh_Interval 5
        Mem_Buf_Limit    5MB
        Skip_Long_Lines  On

    [FILTER]
        Name                kubernetes
        Match               kube.*
        Kube_URL           https://kubernetes.default.svc:443
        Kube_CA_File       /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        Kube_Token_File    /var/run/secrets/kubernetes.io/serviceaccount/token
        Kube_Tag_Prefix    kube.var.log.containers.
        Merge_Log          On
        Merge_Log_Key      log_processed
        K8S-Logging.Parser On
        K8S-Logging.Exclude On

    [OUTPUT]
        Name            azure
        Match           *
        Customer_ID     ${CUSTOMER_ID}
        Shared_Key      ${SHARED_KEY}
        Log_Type        k8s_logs
```

## Exercise 5: OpenTelemetry Integration

### otel-collector.yaml
```yaml
apiVersion: opentelemetry.io/v1alpha1
kind: OpenTelemetryCollector
metadata:
  name: otel
spec:
  config: |
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
      
    processors:
      batch:
        timeout: 1s
        send_batch_size: 1024
      
    exporters:
      logging:
        loglevel: debug
      azuremonitor:
        instrumentation_key: ${APPINSIGHTS_KEY}
      
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [batch]
          exporters: [azuremonitor, logging]
        metrics:
          receivers: [otlp]
          processors: [batch]
          exporters: [azuremonitor, logging]
```

## Exercise 6: Dashboard Creation

### Grafana Dashboard Example
```json
{
  "dashboard": {
    "annotations": {
      "list": []
    },
    "editable": true,
    "panels": [
      {
        "datasource": "Prometheus",
        "fieldConfig": {
          "defaults": {
            "color": {
              "mode": "palette-classic"
            },
            "custom": {
              "axisLabel": "",
              "axisPlacement": "auto",
              "barAlignment": 0,
              "drawStyle": "line",
              "fillOpacity": 10,
              "gradientMode": "none",
              "lineInterpolation": "linear",
              "lineWidth": 1,
              "pointSize": 5,
              "showPoints": "never",
              "spanNulls": true,
              "stacking": {
                "group": "A",
                "mode": "none"
              }
            }
          }
        },
        "targets": [
          {
            "expr": "sum(rate(http_requests_total[5m])) by (status)",
            "legendFormat": "{{status}}",
            "refId": "A"
          }
        ],
        "title": "HTTP Request Rate by Status",
        "type": "timeseries"
      }
    ],
    "refresh": "10s",
    "schemaVersion": 33,
    "style": "dark",
    "tags": ["kubernetes"],
    "templating": {
      "list": []
    },
    "time": {
      "from": "now-1h",
      "to": "now"
    },
    "timepicker": {},
    "timezone": "browser",
    "title": "Application Overview",
    "version": 0
  }
}
```

## Exercise 7: Alert Configuration

### Alerting Rules
```yaml
groups:
- name: example
  rules:
  - alert: HighLatency
    expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
    for: 5m
    labels:
      severity: warning
    annotations:
      summary: High latency detected
      description: 95th percentile latency is above 500ms

  - alert: HighErrorRate
    expr: sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) > 0.1
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: High error rate detected
      description: Error rate is above 10%
```

## Exercise 8: Log Analysis

### Log Queries (Azure Log Analytics)
```kql
// Error rate by container
ContainerLog
| where TimeGenerated > ago(1h)
| where LogEntry contains "error"
| summarize ErrorCount=count() by ContainerName, bin(TimeGenerated, 5m)

// Pod restarts
KubePodInventory
| where TimeGenerated > ago(1d)
| where PodRestartCount > 0
| project TimeGenerated, Name, PodRestartCount, ContainerStatus
| order by TimeGenerated desc

// Resource usage
Perf
| where TimeGenerated > ago(1h)
| where ObjectName == "K8SContainer"
| where CounterName == "cpuUsageNanoCores" or CounterName == "memoryWorkingSetBytes"
| summarize avg(CounterValue) by bin(TimeGenerated, 5m), CounterName, InstanceName
```

## Exercise 9: End-to-End Monitoring

### Sample Application Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
spec:
  template:
    metadata:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
    spec:
      containers:
      - name: app
        image: sample-app:latest
        ports:
        - containerPort: 8080
        env:
        - name: OTEL_EXPORTER_OTLP_ENDPOINT
          value: "http://otel-collector:4318"
        - name: OTEL_SERVICE_NAME
          value: "sample-service"
```

## Exercise 10: Troubleshooting

### Common Issues and Solutions
```batch
@REM Check Prometheus status
kubectl get pods -n monitoring
kubectl logs -n monitoring prometheus-prometheus-0

@REM Check Grafana access
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80

@REM Verify FluentBit
kubectl get pods -n logging
kubectl logs -n logging -l app=fluent-bit

@REM Check OpenTelemetry
kubectl get pods -n default -l app=otel-collector
kubectl logs -l app=otel-collector
```

## Cleanup

```batch
@REM Remove monitoring stack
helm uninstall monitoring -n monitoring

@REM Remove logging components
kubectl delete namespace logging

@REM Remove custom resources
kubectl delete servicemonitor app-metrics -n monitoring
kubectl delete prometheusrule app-alerts -n monitoring
```
