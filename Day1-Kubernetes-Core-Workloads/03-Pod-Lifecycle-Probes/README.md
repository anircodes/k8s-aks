# Pod Lifecycle and Probes

## Overview
This module covers Pod lifecycle management, init containers, and the implementation of health checks using liveness and readiness probes.

## Key Concepts

### Pod Lifecycle Phases
- Pending
- Running
- Succeeded
- Failed
- Unknown

### Types of Probes
1. **Liveness Probe**
   - Determines if a container is running
   - Restarts container on failure

2. **Readiness Probe**
   - Determines if a container can serve traffic
   - Removes pod from service endpoints on failure

3. **Startup Probe**
   - Determines if application has started
   - Disables other probes until success

### Init Containers
- Run before app containers
- Must complete successfully
- Run sequentially

## Practical Exercises

### 1. Working with Init Containers

See [init-container-example.yaml](init-container-example.yaml) for a complete example.

```bash
# Create pod with init container
kubectl apply -f init-container-example.yaml

# Monitor init container progress
kubectl get pod init-demo
kubectl describe pod init-demo
```

### 2. Implementing Health Checks

See [probe-example.yaml](probe-example.yaml) for implementation details.

```bash
# Create pod with probes
kubectl apply -f probe-example.yaml

# Monitor probe status
kubectl describe pod probe-demo
```

### 3. Debugging Pod Lifecycle

```bash
# View pod status
kubectl get pod <pod-name> -o wide

# Get pod lifecycle events
kubectl describe pod <pod-name>

# View pod logs including init containers
kubectl logs <pod-name> -c <init-container-name>
```

## Practice Tasks

1. Create a pod with multiple init containers
2. Implement all three types of probes
3. Debug failing probes
4. Monitor pod lifecycle events

All example files are available in this directory for reference.
