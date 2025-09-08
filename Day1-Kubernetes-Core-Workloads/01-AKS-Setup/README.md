# AKS Setup and Prerequisites

## Overview
This guide covers the setup and configuration of Azure Kubernetes Service (AKS), including resource group creation and required permissions setup.

## Prerequisites
- Active Azure subscription
- Azure CLI installed
- kubectl installed
- PowerShell/Command Prompt
- Owner/Contributor access to create Azure resources

## 1. Azure Account Setup and Tools Installation

### Install Azure CLI
```batch
@REM Download and install Azure CLI silently
curl -o AzureCLI.msi https://aka.ms/installazurecliwindows
start /wait msiexec.exe /i AzureCLI.msi /quiet

@REM Verify installation
az --version
```

### Login and Configure Azure
```batch
@REM Login to Azure CLI
az login

@REM List and select subscription
az account list --output table
az account set --subscription "Your-Subscription-Name-or-ID"

@REM Verify selected subscription
az account show
```

## 2. Resource Group and Permissions Setup

### Create Resource Group
```batch
@REM Create new resource group
az group create ^
    --name myAKSResourceGroup ^
    --location eastus

@REM Verify creation
az group show --name myAKSResourceGroup
```

### Create Service Principal
```batch
@REM Create Service Principal for AKS
az ad sp create-for-rbac ^
    --name myAKSServicePrincipal ^
    --role Contributor ^
    --scopes /subscriptions/{subscription-id}/resourceGroups/myAKSResourceGroup

@REM Important: Save the output containing appId and password
```

### Assign Required Roles
```batch
@REM Get your user Object ID
az ad signed-in-user show --query objectId -o tsv

@REM Assign AKS Cluster Admin Role
az role assignment create ^
    --assignee-object-id "<your-object-id>" ^
    --role "Azure Kubernetes Service Cluster Admin Role" ^
    --scope /subscriptions/{subscription-id}/resourceGroups/myAKSResourceGroup

@REM Assign Virtual Machine Contributor Role
az role assignment create ^
    --assignee-object-id "<your-object-id>" ^
    --role "Virtual Machine Contributor" ^
    --scope /subscriptions/{subscription-id}/resourceGroups/myAKSResourceGroup

@REM Assign Network Contributor Role (if using advanced networking)
az role assignment create ^
    --assignee-object-id "<service-principal-object-id>" ^
    --role "Network Contributor" ^
    --scope /subscriptions/{subscription-id}/resourceGroups/myAKSResourceGroup
```

## 3. Required Resource Providers

```batch
@REM Register necessary Azure resource providers
az provider register --namespace Microsoft.OperationsManagement
az provider register --namespace Microsoft.OperationalInsights
az provider register --namespace Microsoft.ContainerService
az provider register --namespace Microsoft.ContainerRegistry

@REM Monitor registration status
az provider show -n Microsoft.ContainerService -o table
```

## 4. Network Configuration (Recommended)

```batch
@REM Create Virtual Network
az network vnet create ^
    --resource-group myAKSResourceGroup ^
    --name myAKSVnet ^
    --address-prefixes 10.0.0.0/16 ^
    --subnet-name myAKSSubnet ^
    --subnet-prefix 10.0.0.0/24

@REM Create subnet for Application Gateway (if using AGIC)
az network vnet subnet create ^
    --resource-group myAKSResourceGroup ^
    --vnet-name myAKSVnet ^
    --name myAppGWSubnet ^
    --address-prefix 10.0.1.0/24
```

## 5. Security Best Practices

### 1. Role-Based Access Control
- Use the principle of least privilege
- Regularly audit role assignments
- Implement proper RBAC structure
- Use Azure AD integration

### 2. Network Security
- Use private clusters when possible
- Implement network policies
- Configure proper NSG rules
- Use Azure Firewall for egress

### 3. Authentication and Authorization
- Enable Azure AD integration
- Use managed identities
- Implement proper RBAC
- Regular credential rotation

## 6. Verification Checklist

- [ ] Azure CLI installed and configured
- [ ] Resource group created
- [ ] Service Principal created and roles assigned
- [ ] Required resource providers registered
- [ ] Virtual network configured (if needed)
- [ ] Security best practices implemented
- [ ] Access control configured

## 7. Troubleshooting Tips

### Common Issues:
1. **Permission Errors**
   ```batch
   @REM Verify role assignments
   az role assignment list --assignee "<service-principal-id>"
   ```

2. **Network Issues**
   ```batch
   @REM Check NSG rules
   az network nsg list --resource-group myAKSResourceGroup
   ```

3. **Resource Provider Issues**
   ```batch
   @REM Check provider status
   az provider list --query "[].{Provider:namespace, Status:registrationState}" --out table
   ```

## AKS Components and Architecture

### 1. Control Plane Components
- **API Server**: Entry point for all REST commands
- **etcd**: Distributed key-value store for cluster data
- **Scheduler**: Determines pod placement
- **Controller Manager**: Manages various controllers
  - Node Controller
  - Replication Controller
  - Endpoints Controller
  - Service Account & Token Controllers

### 2. Node Components
- **Kubelet**: Node agent that runs on each node
- **Container Runtime**: Docker/containerd
- **Kube-proxy**: Network proxy and load balancer
- **Azure CNI**: Network plugin for Azure integration

### 3. Azure-Specific Components
- **Cloud Controller Manager**: Manages Azure-specific resources
- **Azure CNI**: Network plugin for Azure integration
- **Azure Disk/File CSI**: Storage drivers
- **Azure Load Balancer**: External load balancing
- **Application Gateway**: Ingress controller (optional)

### 4. Add-ons and Extensions
- **Azure Monitor**: Monitoring and logging
- **Azure Policy**: Governance and compliance
- **Azure Container Registry**: Container image storage
- **Azure Key Vault**: Secrets management
- **Virtual Node**: Serverless containers with ACI

## Practice Tasks and Solutions

### Task 1: Create Resource Group and Configure RBAC
```batch
@REM Create resource group
az group create --name aks-practice-rg --location eastus

@REM Create AAD group for AKS admins
az ad group create --display-name aks-admins --mail-nickname aks-admins

@REM Get the AAD group object ID
$GROUP_ID=$(az ad group show --group aks-admins --query objectId -o tsv)

@REM Assign RBAC role
az role assignment create ^
    --assignee-object-id $GROUP_ID ^
    --role "Azure Kubernetes Service Cluster Admin Role" ^
    --scope /subscriptions/{subscription-id}/resourceGroups/aks-practice-rg
```

### Task 2: Configure Networking
```batch
@REM Create VNET and Subnets
az network vnet create ^
    --name aks-vnet ^
    --resource-group aks-practice-rg ^
    --address-prefixes 10.0.0.0/16

@REM Create AKS subnet
az network vnet subnet create ^
    --name aks-subnet ^
    --resource-group aks-practice-rg ^
    --vnet-name aks-vnet ^
    --address-prefixes 10.0.1.0/24

@REM Create Application Gateway subnet
az network vnet subnet create ^
    --name appgw-subnet ^
    --resource-group aks-practice-rg ^
    --vnet-name aks-vnet ^
    --address-prefixes 10.0.2.0/24
```

### Task 3: Set Up Monitoring
```batch
@REM Create Log Analytics workspace
az monitor log-analytics workspace create ^
    --resource-group aks-practice-rg ^
    --workspace-name aks-logs ^
    --location eastus

@REM Get workspace ID
$WORKSPACE_ID=$(az monitor log-analytics workspace show ^
    --resource-group aks-practice-rg ^
    --workspace-name aks-logs ^
    --query id -o tsv)
```

### Task 4: Create AKS Cluster
```batch
@REM Create AKS cluster with monitoring
az aks create ^
    --resource-group aks-practice-rg ^
    --name practice-cluster ^
    --node-count 3 ^
    --enable-addons monitoring ^
    --enable-managed-identity ^
    --network-plugin azure ^
    --vnet-subnet-id $SUBNET_ID ^
    --workspace-resource-id $WORKSPACE_ID ^
    --enable-aad ^
    --aad-admin-group-object-ids $GROUP_ID ^
    --generate-ssh-keys

@REM Get credentials
az aks get-credentials ^
    --resource-group aks-practice-rg ^
    --name practice-cluster ^
    --admin
```

### Task 5: Verify Setup
```batch
@REM Check node status
kubectl get nodes -o wide

@REM Verify pods in kube-system
kubectl get pods -n kube-system

@REM Check monitoring
kubectl get pods -n azure-monitor

@REM Test deployment
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

### Common Practice Task Issues and Solutions

1. **Issue: RBAC Permission Errors**
   ```batch
   @REM Verify role assignments
   az role assignment list --assignee-object-id $GROUP_ID -o table
   
   @REM Add missing roles if needed
   az role assignment create --assignee-object-id $GROUP_ID --role "Contributor"
   ```

2. **Issue: Network Connectivity**
   ```batch
   @REM Check NSG rules
   az network nsg list -g aks-practice-rg -o table
   
   @REM Verify subnet configuration
   az network vnet subnet show ^
       --resource-group aks-practice-rg ^
       --vnet-name aks-vnet ^
       --name aks-subnet
   ```

3. **Issue: Monitoring Not Working**
   ```batch
   @REM Check Log Analytics agent
   kubectl get ds omsagent --namespace=kube-system
   
   @REM View agent logs
   kubectl logs -n kube-system -l component=oms-agent
   ```

### Advanced Practice Scenarios

1. **Multi-node Pool Setup**
```batch
@REM Add new node pool
az aks nodepool add ^
    --resource-group aks-practice-rg ^
    --cluster-name practice-cluster ^
    --name gpupool ^
    --node-count 3 ^
    --node-vm-size Standard_DS3_v2
```

2. **Auto-scaling Configuration**
```batch
@REM Enable cluster autoscaler
az aks update ^
    --resource-group aks-practice-rg ^
    --name practice-cluster ^
    --enable-cluster-autoscaler ^
    --min-count 1 ^
    --max-count 5
```

3. **Private Cluster Setup**
```batch
@REM Create private cluster
az aks create ^
    --resource-group aks-practice-rg ^
    --name private-cluster ^
    --enable-private-cluster ^
    --enable-managed-identity ^
    --network-plugin azure ^
    --vnet-subnet-id $SUBNET_ID
```

## Next Steps
- Proceed to Container Basics
- Set up CI/CD pipelines
- Implement backup solutions
- Practice advanced scenarios

## Additional Resources
- [Azure RBAC Documentation](https://docs.microsoft.com/azure/role-based-access-control/overview)
- [AKS Best Practices](https://docs.microsoft.com/azure/aks/best-practices)
- [AKS Networking](https://docs.microsoft.com/azure/aks/concepts-network)

@REM Login to Azure (will open browser window)
az login

@REM Set subscription
az account set --subscription <subscription-id>
```

### 2. Install kubectl
```batch
@REM Install via Azure CLI
az aks install-cli

@REM Add kubectl to PATH if not already added
@REM Example of adding to PATH (run in administrator command prompt)
setx path "%path%;C:\Users\%USERNAME%\.azure-kubectl"

@REM Verify installation
kubectl version --client
```

### 3. Install Windows Terminal (Recommended)
- Open Microsoft Store
- Search for "Windows Terminal"
- Click Install

### 4. Install VSCode (Recommended)
```batch
@REM Install using winget
winget install Microsoft.VisualStudioCode

@REM Install useful extensions
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-azuretools.vscode-azurerm-tools
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
4. Command Prompt (cmd.exe)

### Azure Requirements
1. Azure subscription
2. Resource Group created
3. Required permissions (Contributor role)

### Network Requirements
1. Ability to connect to Azure (check corporate proxy settings if needed)
2. Administrative access for tool installation

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
