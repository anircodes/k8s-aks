# Monitoring and Logging

## Overview
This module covers monitoring and logging solutions for Kubernetes clusters, focusing on Azure Monitor and OpenTelemetry integration.

## Key Components

### Azure Monitor
- Container Insights
- Log Analytics
- Metrics
- Alerts

### OpenTelemetry
- Distributed tracing
- Metrics collection
- Log aggregation
- Correlation

## Practical Exercises

### 1. Azure Monitor Setup

See [azure-monitor-config.yaml](azure-monitor-config.yaml) for implementation.

```bash
# Enable container insights
az aks enable-addons -a monitoring -n myAKSCluster -g myResourceGroup

# View monitoring data
az aks show -n myAKSCluster -g myResourceGroup --query addonProfiles.omsagent
```

### 2. OpenTelemetry Configuration

See [opentelemetry-config.yaml](opentelemetry-config.yaml) for details.

```bash
# Deploy OpenTelemetry Operator
kubectl apply -f opentelemetry-operator.yaml

# Create OpenTelemetry Collector
kubectl apply -f otel-collector.yaml
```

### 3. Log Collection Setup

See [log-collection.yaml](log-collection.yaml) for implementation.

```bash
# Deploy log collection
kubectl apply -f log-collection.yaml

# Verify log flow
kubectl logs -n logging -l app=otel-collector
```

## Practice Tasks

1. Set up Azure Monitor
2. Configure OpenTelemetry collector
3. Implement distributed tracing
4. Create custom dashboards

All configuration files are available in this directory.
