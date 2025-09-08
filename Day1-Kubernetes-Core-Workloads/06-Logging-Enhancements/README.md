# Logging Enhancements

## Overview
This module covers advanced logging configurations in Kubernetes, including sidecar logging patterns and OpenTelemetry integration.

## Key Concepts

### Sidecar Logging Pattern
- Separate container for log processing
- Shares volume with main container
- Handles log shipping and processing

### OpenTelemetry Integration
- Distributed tracing
- Metrics collection
- Log correlation

## Practical Exercises

### 1. Implementing Logging Sidecar

See [logging-sidecar.yaml](logging-sidecar.yaml) for a complete example.

```bash
# Create pod with logging sidecar
kubectl apply -f logging-sidecar.yaml

# View sidecar logs
kubectl logs <pod-name> -c log-collector
```

### 2. OpenTelemetry Collector Setup

See [otel-collector.yaml](otel-collector.yaml) for the implementation.

```bash
# Deploy OpenTelemetry Collector
kubectl apply -f otel-collector.yaml

# Verify collector status
kubectl get pods -n observability
```

### 3. Fluentbit Integration

See [fluentbit-config.yaml](fluentbit-config.yaml) for configuration details.

```bash
# Deploy Fluentbit with OpenTelemetry
kubectl apply -f fluentbit-config.yaml

# Monitor log collection
kubectl logs -n logging -l app=fluentbit
```

## Practice Tasks

1. Set up a multi-container pod with logging sidecar
2. Configure OpenTelemetry collector
3. Integrate Fluentbit with OpenTelemetry
4. Monitor log collection and processing

All configuration files are available in this directory.
