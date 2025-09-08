# Mini-Project: Azure-Native Three-Tier Application

## Overview
This project implements a production-ready three-tier microservice application on AKS, leveraging Azure-native services for enhanced security, scalability, and monitoring.

## Architecture

### Components
1. **Frontend**
   - React application
   - Azure CDN integration
   - Azure Application Gateway
   - SSL/TLS termination

2. **Backend**
   - Node.js API service
   - Horizontal pod autoscaling
   - Azure Monitor integration
   - Application Insights

3. **Database**
   - MongoDB on AKS
   - Azure Disk Storage
   - Backup integration
   - High availability

### Azure Services
- Azure Container Registry
- Azure Key Vault
- Azure Monitor
- Azure Log Analytics
- Application Gateway
- Azure CDN
- Azure Storage

## Implementation Files

### Core Components
- [frontend.yaml](frontend.yaml) - Frontend deployment with Application Gateway
- [backend.yaml](backend.yaml) - Backend deployment with autoscaling
- [mongodb.yaml](mongodb.yaml) - MongoDB StatefulSet with Azure Disk

### Configuration
- [config.yaml](config.yaml) - ConfigMaps for application settings
- [secrets.yaml](secrets.yaml) - Key Vault integration for secrets

### Infrastructure
- [storage.yaml](storage.yaml) - Azure Storage configuration
- [network.yaml](network.yaml) - Network policies and ingress

### Monitoring
- [monitoring.yaml](monitoring.yaml) - Azure Monitor setup
- [logging.yaml](logging.yaml) - Log Analytics configuration

## Deployment Guide

### 1. Prerequisites
```batch
@REM Login to Azure
az login

@REM Create resource group
az group create --name myAKSGroup --location eastus

@REM Create AKS cluster
az aks create ^
    --resource-group myAKSGroup ^
    --name myAKSCluster ^
    --node-count 3 ^
    --enable-addons monitoring ^
    --network-plugin azure

@REM Get credentials
az aks get-credentials --resource-group myAKSGroup --name myAKSCluster
```

### 2. Setup Azure Services
```batch
@REM Create Azure Container Registry
az acr create ^
    --resource-group myAKSGroup ^
    --name myAKSRegistry ^
    --sku Standard

@REM Create Key Vault
az keyvault create ^
    --name myAKSVault ^
    --resource-group myAKSGroup ^
    --location eastus

@REM Create Log Analytics workspace
az monitor log-analytics workspace create ^
    --resource-group myAKSGroup ^
    --workspace-name myAKSLogs
```

### 3. Deploy Infrastructure
```batch
@REM Create namespace
kubectl create namespace three-tier-app

@REM Deploy storage configuration
kubectl apply -f storage.yaml

@REM Setup network policies
kubectl apply -f network.yaml

@REM Configure monitoring
kubectl apply -f monitoring.yaml
```

### 4. Deploy Application Components
```batch
@REM Deploy MongoDB with persistent storage
kubectl apply -f mongodb.yaml

@REM Deploy backend services
kubectl apply -f backend.yaml

@REM Deploy frontend application
kubectl apply -f frontend.yaml

@REM Configure ingress
kubectl apply -f ingress.yaml
```

## Monitoring and Management

### 1. Application Monitoring
```batch
@REM View application metrics
az monitor metrics list ^
    --resource-group myAKSGroup ^
    --resource myAKSCluster

@REM Check pod metrics
kubectl top pods -n three-tier-app
```

### 2. Log Analysis
```batch
@REM View application logs
kubectl logs -n three-tier-app -l app=backend
kubectl logs -n three-tier-app -l app=frontend

@REM Query Log Analytics
az monitor log-analytics query ^
    --workspace myAKSLogs ^
    --query "ContainerLog | where TimeGenerated > ago(1h)"
```

### 3. Health Monitoring
```batch
@REM Check service health
kubectl get pods,svc,deployment -n three-tier-app

@REM View autoscaling status
kubectl get hpa -n three-tier-app
```

## Scaling and Management

### 1. Manual Scaling
```batch
@REM Scale backend deployment
kubectl scale deployment backend -n three-tier-app --replicas=5

@REM Scale frontend deployment
kubectl scale deployment frontend -n three-tier-app --replicas=3
```

### 2. Storage Management
```batch
@REM View PVC status
kubectl get pvc -n three-tier-app

@REM Check storage classes
kubectl get sc
```

### 3. Network Management
```batch
@REM View network policies
kubectl get networkpolicies -n three-tier-app

@REM Check ingress status
kubectl get ingress -n three-tier-app
```

## Cleanup

```batch
@REM Delete application resources
kubectl delete namespace three-tier-app

@REM Delete Azure resources
az group delete --name myAKSGroup --yes --no-wait
```

## Best Practices

1. **Security**
   - Use Azure Key Vault for secrets
   - Implement network policies
   - Enable Azure AD integration
   - Regular security updates

2. **Monitoring**
   - Configure Azure Monitor
   - Set up alerts
   - Enable diagnostic logging
   - Monitor performance metrics

3. **Scaling**
   - Implement HPA
   - Configure node auto-scaling
   - Monitor resource usage
   - Set appropriate limits

4. **Backup**
   - Regular database backups
   - Configuration backups
   - Disaster recovery plan
   - Testing restore procedures

## Troubleshooting Guide

### 1. Application Issues
```batch
@REM Check pod status
kubectl get pods -n three-tier-app
kubectl describe pod <pod-name> -n three-tier-app

@REM View application logs
kubectl logs <pod-name> -n three-tier-app
```

### 2. Infrastructure Issues
```batch
@REM Check node status
kubectl get nodes
kubectl describe node <node-name>

@REM View system pods
kubectl get pods -n kube-system
```

### 3. Network Issues
```batch
@REM Check service endpoints
kubectl get endpoints -n three-tier-app

@REM Test network connectivity
kubectl run test-net --image=busybox -it --rm -- wget -O- http://backend-service
```

## Additional Resources
- [AKS Documentation](https://docs.microsoft.com/azure/aks/)
- [Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/)
- [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/)

# Deploy Frontend
kubectl apply -f frontend.yaml
```

4. Deploy Monitoring & Logging
```bash
# Deploy monitoring stack
kubectl apply -f monitoring.yaml

# Deploy logging stack
kubectl apply -f logging.yaml
```

## Verification Steps

1. Check Deployments
```bash
kubectl get deployments -n three-tier-app
```

2. Verify Services
```bash
kubectl get services -n three-tier-app
```

3. Access Application
```bash
# Get frontend service URL
kubectl get svc frontend-service -n three-tier-app
```

4. Monitor Logs
```bash
# View application logs
kubectl logs -f deployment/backend -n three-tier-app
```

## Project Extensions

1. Add authentication
2. Implement caching layer
3. Add CI/CD pipeline
4. Implement auto-scaling

All configuration files are available in this directory.
