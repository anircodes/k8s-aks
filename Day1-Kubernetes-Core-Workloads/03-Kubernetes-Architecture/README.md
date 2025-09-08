# AKS Architecture

## Overview
This module covers the Azure Kubernetes Service (AKS) architecture, including Azure-managed components, nodes, pods, and integration points.

## Core Components

### Azure-Managed Control Plane
- **kube-apiserver**: Azure-managed API server with high availability
- **etcd**: Fully managed and backed up by Azure
- **kube-scheduler**: Azure-managed Pod scheduling
- **kube-controller-manager**: Azure-managed controller operations
- **cloud-controller-manager**: Handles Azure-specific integrations

### AKS Node Components
- **kubelet**: Azure-managed agent on each node
- **kube-proxy**: Azure CNI-integrated network proxy
- **containerd**: Azure-supported container runtime
- **Azure CNI**: Advanced networking for Azure integration
- **monitoring agent**: Azure Monitor for containers integration

## Practical Exercises

### 1. Inspect Cluster Components

```bash
# View all nodes in the cluster
kubectl get nodes -o wide

# Get detailed information about a specific node
kubectl describe node <node-name>

# View system pods in kube-system namespace
kubectl get pods -n kube-system

# Check control plane components status
kubectl get componentstatuses
```

### 2. Node Management

```bash
# Drain a node for maintenance
kubectl drain <node-name> --ignore-daemonsets

# Mark a node as unschedulable
kubectl cordon <node-name>

# Mark a node as schedulable
kubectl uncordon <node-name>
```

### 3. Component Health Check

```bash
# Check API server health
curl -k https://localhost:6443/healthz

# View kubelet status
systemctl status kubelet

# Check logs of control plane components
kubectl logs -n kube-system <pod-name>
```

## Practice Tasks

1. Create an AKS cluster and inspect its components
2. Identify and list all system pods running in your cluster
3. Practice node maintenance operations
4. Monitor cluster health status

All the commands used in this section are available in the [commands.sh](commands.sh) file.
