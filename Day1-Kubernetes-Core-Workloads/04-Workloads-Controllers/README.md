# Workloads and Controllers

## Overview
This module covers Kubernetes workload resources and controllers including ReplicaSets, Deployments, and DaemonSets.

## Key Concepts

### ReplicaSets
- Ensures a specified number of pod replicas are running
- Provides high availability
- Automatically handles pod failures

### Deployments
- Provides declarative updates for Pods and ReplicaSets
- Supports rolling updates and rollbacks
- Manages application lifecycle

### DaemonSets
- Ensures all nodes run a copy of a pod
- Perfect for cluster-wide operations
- Common use cases: monitoring, logging

## Practical Exercises

### 1. Working with Deployments

```bash
# Create a deployment
kubectl apply -f nginx-deployment.yaml

# Scale deployment
kubectl scale deployment nginx-deployment --replicas=5

# Perform rolling update
kubectl set image deployment/nginx-deployment nginx=nginx:1.21

# Rollback deployment
kubectl rollout undo deployment/nginx-deployment
```

### 2. Managing ReplicaSets

```bash
# Create a ReplicaSet
kubectl apply -f nginx-replicaset.yaml

# Scale ReplicaSet
kubectl scale rs nginx-replicaset --replicas=3

# Delete ReplicaSet (keeping pods)
kubectl delete rs nginx-replicaset --cascade=false
```

### 3. DaemonSet Operations

```bash
# Create DaemonSet
kubectl apply -f monitoring-daemonset.yaml

# View DaemonSet status
kubectl get ds
kubectl describe ds monitoring-daemonset

# Update DaemonSet
kubectl set image ds/monitoring-daemonset container=new-image:tag
```

## Practice Tasks

1. Create a multi-container deployment
2. Implement rolling updates and rollbacks
3. Deploy a monitoring solution using DaemonSet
4. Scale applications up and down

Check the example YAML files in this directory for practical implementations.
