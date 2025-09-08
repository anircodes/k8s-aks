# Kubernetes Core Concepts

## Overview
This module provides a comprehensive introduction to Kubernetes architecture, core components, and fundamental concepts.

## Core Components

### Control Plane Components
1. **API Server**
   - Central management point
   - RESTful API interface
   - Authentication and authorization
   - Resource validation

2. **etcd**
   - Distributed key-value store
   - Cluster state storage
   - Consistency and high availability
   - Backup and recovery

3. **Scheduler**
   - Pod placement decisions
   - Resource requirements
   - Affinity/anti-affinity rules
   - Node selection

4. **Controller Manager**
   - Node controller
   - Replication controller
   - Endpoint controller
   - Service account controller

### Node Components
1. **Kubelet**
   - Node agent
   - Pod lifecycle management
   - Container health checks
   - Resource reporting

2. **Container Runtime**
   - containerd
   - Image management
   - Container execution
   - Resource isolation

3. **Kube Proxy**
   - Network proxy
   - Service load balancing
   - IP tables management
   - Service discovery

## Core Objects

### 1. Pods
- Smallest deployable unit
- One or more containers
- Shared storage and network
- Pod lifecycle phases

### 2. Nodes
- Physical or virtual machines
- Resource capacity
- Node conditions
- Node maintenance

### 3. Namespaces
- Resource isolation
- Access control
- Resource quotas
- Default namespaces

## Practical Exercises

### 1. Basic Pod Operations
```batch
@REM Create a simple pod
kubectl run nginx --image=nginx

@REM View pod details
kubectl get pod nginx -o wide
kubectl describe pod nginx

@REM Access pod logs
kubectl logs nginx

@REM Execute command in pod
kubectl exec -it nginx -- /bin/bash

@REM Delete pod
kubectl delete pod nginx
```

### 2. Cluster Inspection
```batch
@REM View cluster info
kubectl cluster-info

@REM List all nodes
kubectl get nodes -o wide

@REM Check component status
kubectl get componentstatuses

@REM View system pods
kubectl get pods -n kube-system
```

### 3. Namespace Management
```batch
@REM Create namespace
kubectl create namespace dev-team1

@REM List namespaces
kubectl get namespaces

@REM Set context to namespace
kubectl config set-context --current --namespace=dev-team1

@REM View resources in namespace
kubectl get all -n dev-team1
```

### 4. Resource Management
```batch
@REM View resource usage
kubectl top nodes
kubectl top pods --all-namespaces

@REM Check node capacity
kubectl describe node <node-name> | findstr Capacity -A 5

@REM View resource quotas
kubectl get resourcequota --all-namespaces
```

## Advanced Topics

### 1. Pod Scheduling
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-scheduling
spec:
  containers:
  - name: nginx
    image: nginx
  nodeSelector:
    disktype: ssd
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: kubernetes.io/e2e-az-name
            operator: In
            values:
            - e2e-az1
            - e2e-az2
```

### 2. Resource Requests and Limits
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
  - name: nginx
    image: nginx
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```

### 3. Pod Security Context
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  containers:
  - name: nginx
    image: nginx
```

## Best Practices

1. **Pod Design**
   - Use appropriate labels
   - Set resource limits
   - Configure health checks
   - Implement security contexts

2. **Namespace Usage**
   - Isolate environments
   - Apply resource quotas
   - Use network policies
   - Regular cleanup

3. **Resource Management**
   - Monitor resource usage
   - Implement autoscaling
   - Set appropriate requests/limits
   - Regular capacity planning

## Troubleshooting Guide

### 1. Pod Issues
```batch
@REM Check pod status
kubectl get pod <pod-name> -o wide
kubectl describe pod <pod-name>
kubectl logs <pod-name>

@REM Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### 2. Node Issues
```batch
@REM Check node status
kubectl describe node <node-name>
kubectl get node <node-name> -o yaml

@REM View node logs
kubectl logs -n kube-system <node-problem-detector>
```

### 3. Cluster Issues
```batch
@REM Check cluster health
kubectl get componentstatuses
kubectl get nodes
kubectl top nodes

@REM View system logs
kubectl logs -n kube-system <component-pod>
```

## Additional Resources
- [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)
- [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
