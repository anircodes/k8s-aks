# Kubernetes Architecture

## Overview
This module covers the fundamental components of Kubernetes architecture, including nodes, pods, kubelet, and control plane components.

## Core Components

### Control Plane Components
- **kube-apiserver**: The API server that serves as the front end for the Kubernetes control plane
- **etcd**: Consistent and highly-available key value store for cluster data
- **kube-scheduler**: Component that watches for newly created Pods and assigns them to nodes
- **kube-controller-manager**: Runs controller processes
- **cloud-controller-manager**: Integrates with underlying cloud providers

### Node Components
- **kubelet**: Agent that runs on each node
- **kube-proxy**: Network proxy that maintains network rules
- **Container runtime**: Software responsible for running containers

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
