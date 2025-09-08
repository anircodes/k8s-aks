# Setting up A# Installing Required Tools on Windows

### 1. Install Azure CLI
```powershell
# Download the MSI installer
$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# Verify installation
az --version

# Login to Azure (will open browser window)
az login

# Set subscription
az account set --subscription <subscription-id>
```

### 2. Install kubectl
```powershell
# Install via Azure CLI
az aks install-cli

# Add kubectl to PATH if not already added
# The path should be similar to: C:\Users\<username>\.azure-kubectl

# Verify installation
kubectl version --client
```

### 3. Install Windows Terminal (Recommended)
- Open Microsoft Store
- Search for "Windows Terminal"
- Click Install

### 4. Install VSCode (Recommended)
```powershell
# Install using winget
winget install Microsoft.VisualStudioCode

# Install useful extensions
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-azuretools.vscode-azurerm-tools
code --install-extension ms-vscode.powershell
``` Service (AKS)

## Overview
This module covers the setup and configuration of Azure Kubernetes Service (AKS), including best practices for production environments.

## Prerequisites

### System Requirements
1. Windows 10/11 Pro or Enterprise
2. At least 8GB RAM
3. 4 CPU cores or more
4. 50GB free disk space

### Software Requirements
1. Windows Terminal
2. Azure CLI
3. Visual Studio Code with extensions:
   - Kubernetes
   - Azure Resource Manager Tools
   - PowerShell
4. PowerShell 7.x (recommended)

### Azure Requirements
1. Azure subscription
2. Resource Group created
3. Required permissions (Contributor role)

### Network Requirements
1. Ability to connect to Azure (check corporate proxy settings if needed)
2. PowerShell execution policy that allows running scripts
3. Administrative access for tool installation

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

### 2. Creating AKS Cluster Using YAML

AKS clusters can be created and managed using YAML configurations. This approach follows Infrastructure as Code (IaC) principles and provides better version control and reproducibility.

#### Basic AKS Cluster Configuration

Here's a breakdown of [aks-cluster.yaml](aks-cluster.yaml):

```yaml
apiVersion: v1
kind: Cluster                     # Defines this as a cluster resource
metadata:
  name: myAKSCluster             # Cluster name
  location: eastus2              # Azure region
spec:
  resourceGroup: myResourceGroup  # Azure resource group
  kubernetes:
    version: 1.26.6              # Kubernetes version
  
  # Default node pool configuration
  defaultNodePool:
    name: systempool             # Name of the system node pool
    count: 3                     # Number of nodes
    vmSize: Standard_DS3_v2      # VM size (SKU)
    type: VirtualMachineScaleSets
    availabilityZones:           # High availability configuration
    - 1
    - 2
    - 3
    
  # Identity and security configuration
  identity:
    type: SystemAssigned        # Use managed identity
    
  # Network configuration
  networkProfile:
    networkPlugin: azure        # Azure CNI networking
    networkPolicy: azure       # Azure network policy
```

#### Advanced Configuration Components

The [advanced-aks-config.yaml](advanced-aks-config.yaml) includes production-ready features:

1. **Node Pool Configuration**:
```yaml
defaultNodePool:
  name: systempool
  count: 3
  vmSize: Standard_DS4_v2
  type: VirtualMachineScaleSets
  availabilityZones: [1, 2, 3]
  enableAutoScaling: true
  minCount: 3
  maxCount: 5
  osDiskSizeGB: 128
  maxPods: 110
```
- `vmSize`: Determines CPU, memory, and IOPS capabilities
- `enableAutoScaling`: Allows automatic scaling based on demand
- `maxPods`: Maximum pods per node (important for CNI networking)

2. **Network Configuration**:
```yaml
networkProfile:
  networkPlugin: azure
  networkPolicy: azure
  serviceCidr: 10.0.0.0/16
  dnsServiceIP: 10.0.0.10
  dockerBridgeCidr: 172.17.0.1/16
  loadBalancerSku: standard
```
- `networkPlugin`: Azure CNI for advanced networking
- `serviceCidr`: IP range for Kubernetes services
- `loadBalancerSku`: Standard SKU for Azure Load Balancer

3. **Add-ons and Integrations**:
```yaml
addons:
  httpApplicationRouting:
    enabled: true
  omsagent:
    enabled: true
  azurePolicy:
    enabled: true
  ingressApplicationGateway:
    enabled: true
```
- `omsagent`: Azure Monitor integration
- `azurePolicy`: Azure Policy for Kubernetes
- `ingressApplicationGateway`: Application Gateway Ingress Controller

4. **Security Configuration**:
```yaml
aadProfile:
  managed: true
  enableAzureRBAC: true
  adminGroupObjectIDs:
  - "<admin-group-object-id>"
```
- Azure AD integration
- RBAC configuration
- Admin group assignments

### 3. Deploying Using YAML

```powershell
# Export the YAML configuration
az aks create `
    --resource-group myResourceGroup `
    --name myAKSCluster `
    --generate-yaml > cluster.yaml

# Review and edit the YAML as needed

# Create cluster using YAML (Preview feature)
az aks create -g myResourceGroup -n myAKSCluster --file cluster.yaml

# Get credentials
az aks get-credentials -g myResourceGroup -n myAKSCluster
```

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
