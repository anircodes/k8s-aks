# Services and DNS in Kubernetes

## Overview
This module covers Kubernetes Services types, DNS resolution, and networking concepts.

## Service Types

### 1. ClusterIP
- Default service type
- Internal cluster communication
- Load balancing within cluster

### 2. NodePort
- Exposes service on static port
- Accessible from outside cluster
- Port range: 30000-32767

### 3. LoadBalancer
- External load balancer
- Cloud provider integration
- Public IP address

### 4. ExternalName
- DNS CNAME record
- Service aliasing
- External service mapping

## DNS in Kubernetes

### Service Discovery
- Automatic DNS records
- Namespace-scoped names
- Cross-namespace resolution

## Practical Exercises

### 1. ClusterIP Service

See [clusterip-service.yaml](clusterip-service.yaml) for implementation.

```bash
# Create deployment and service
kubectl apply -f clusterip-service.yaml

# Test service
kubectl run test-pod --image=busybox -it --rm -- wget -qO- http://myapp-service
```

### 2. NodePort Service

See [nodeport-service.yaml](nodeport-service.yaml) for implementation.

```bash
# Create NodePort service
kubectl apply -f nodeport-service.yaml

# Get service URL
kubectl get svc myapp-nodeport
```

### 3. LoadBalancer Service

See [loadbalancer-service.yaml](loadbalancer-service.yaml) for details.

```bash
# Create LoadBalancer service
kubectl apply -f loadbalancer-service.yaml

# Get external IP
kubectl get svc myapp-lb
```

## Practice Tasks

1. Deploy multiple services of different types
2. Test cross-namespace service discovery
3. Implement service for a stateful application
4. Configure external service access

All configuration files are available in this directory.
