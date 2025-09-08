# Setting up Azure Kubernetes Service (AKS)

## Overview
This module covers the setup and configuration of Azure Kubernetes Service (AKS), including best practices for production environments.

## Prerequisites

1. Azure CLI installed
2. Azure subscription
3. Resource Group created
4. Required permissions (Contributor role)

## Practical Exercises

### 1. Installing Required Tools

```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLI | bash

# Login to Azure
az login

# Install kubectl
az aks install-cli

# Set subscription
az account set --subscription <subscription-id>
```

### 2. Creating AKS Cluster

See [aks-cluster.yaml](aks-cluster.yaml) for complete configuration.

```bash
# Create basic AKS cluster
az aks create \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --node-count 3 \
    --enable-addons monitoring \
    --generate-ssh-keys

# Get credentials
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
```

### 3. Advanced AKS Configuration

See [advanced-aks-config.yaml](advanced-aks-config.yaml) for production setup.

```bash
# Create AKS with advanced features
az aks create \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --node-count 3 \
    --enable-addons monitoring,http_application_routing \
    --enable-managed-identity \
    --enable-cluster-autoscaler \
    --min-count 3 \
    --max-count 6 \
    --network-plugin azure \
    --network-policy azure \
    --kubernetes-version 1.26.6 \
    --generate-ssh-keys
```

## AKS Components

1. **Control Plane**
   - Managed by Azure (free)
   - Highly available
   - Automatic upgrades
   - Azure-managed certificates

2. **Node Pools**
   - System node pool
   - User node pools
   - Virtual Machine Scale Sets
   - Availability Zones support

3. **Networking**
   - Azure CNI (Advanced)
   - Kubenet (Basic)
   - Network Policies
   - Service Mesh options

4. **Security**
   - Azure AD integration
   - RBAC
   - Network Policies
   - Pod Security Policies

## Practice Tasks

1. Create development AKS cluster
2. Set up production-grade AKS cluster
3. Configure auto-scaling
4. Implement networking policies

All configuration files are available in this directory.
