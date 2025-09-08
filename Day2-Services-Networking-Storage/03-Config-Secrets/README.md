# Azure Key Vault Integration with AKS

## Overview
This module covers Azure-native configuration and secrets management in AKS using Azure Key Vault, ConfigMaps, and Secrets.

## Azure Security Components

### 1. Azure Key Vault Integration
- **Features**
  - Centralized secrets management
  - Hardware Security Module (HSM)
  - Access control with Azure AD
  - Audit logging
  - Automatic rotation
  - Managed identities

### 2. ConfigMaps in AKS
- Environment-specific configuration
- Application settings
- Feature flags
- Resource configurations

### 3. Kubernetes Secrets with Azure
- Integration with Key Vault
- Pod identity support
- CSI driver integration
- Dynamic secret injection

## Implementation Guide

### 1. Azure Key Vault Setup

```batch
@REM Create Key Vault
az keyvault create ^
    --name myAKSKeyVault ^
    --resource-group myResourceGroup ^
    --location eastus ^
    --enable-rbac-authorization true

@REM Add secret to Key Vault
az keyvault secret set ^
    --vault-name myAKSKeyVault ^
    --name mySecret ^
    --value "MySecretValue"
```

### 2. CSI Driver Installation

```batch
@REM Install CSI driver using Helm
az aks enable-addons ^
    --addons azure-keyvault-secrets-provider ^
    --name myAKSCluster ^
    --resource-group myResourceGroup

@REM Verify installation
kubectl get pods -n kube-system -l app=secrets-store-csi-driver
```

### 3. SecretProviderClass Configuration
```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kvname
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: <client-id>
    keyvaultName: myAKSKeyVault
    objects: |
      array:
        - |
          objectName: mySecret
          objectType: secret
          objectVersion: ""
    tenantId: <tenant-id>
```

## Advanced Features

### 1. Managed Identity Setup
```batch
@REM Create managed identity
az identity create ^
    --name myAKSIdentity ^
    --resource-group myResourceGroup

@REM Assign to AKS
az aks update ^
    --name myAKSCluster ^
    --resource-group myResourceGroup ^
    --enable-managed-identity ^
    --assign-identity <identity-id>
```

### 2. Pod Identity Configuration
```yaml
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentity
metadata:
  name: pod-identity
spec:
  type: 0
  resourceID: <identity-resource-id>
  clientID: <identity-client-id>
---
apiVersion: aadpodidentity.k8s.io/v1
kind: AzureIdentityBinding
metadata:
  name: pod-identity-binding
spec:
  azureIdentity: pod-identity
  selector: pod-identity
```

### 3. Certificate Management
```batch
@REM Create certificate in Key Vault
az keyvault certificate create ^
    --vault-name myAKSKeyVault ^
    --name myCert ^
    --policy "@cert-policy.json"
```

## Configuration Management

### 1. ConfigMap Creation and Updates
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  settings.json: |
    {
      "environment": "production",
      "logLevel": "info",
      "apiEndpoint": "https://api.example.com"
    }
```

### 2. Dynamic Configuration Updates
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-deployment
spec:
  template:
    spec:
      containers:
      - name: app
        image: myapp:1.0
        envFrom:
        - configMapRef:
            name: app-config
```

## Monitoring and Audit

### 1. Key Vault Logging
```batch
@REM Enable Key Vault logging
az monitor diagnostic-settings create ^
    --name myDiagnostics ^
    --resource <key-vault-id> ^
    --logs "[{category:AuditEvent,enabled:true}]" ^
    --workspace <log-analytics-workspace-id>
```

### 2. Access Auditing
```batch
@REM View Key Vault access logs
az keyvault list-deleted ^
    --resource-group myResourceGroup

@REM Monitor secret access
az keyvault secret list-versions ^
    --vault-name myAKSKeyVault ^
    --name mySecret
```

## Best Practices

1. **Security**
   - Use managed identities
   - Implement least privilege access
   - Enable soft-delete and purge protection
   - Regular access review
   - Implement secret rotation

2. **Configuration Management**
   - Use namespaces for isolation
   - Version control configurations
   - Implement change tracking
   - Use environment-specific configs
   - Document all configurations

3. **Operational**
   - Monitor secret expiration
   - Regular backup of configurations
   - Test secret rotation procedures
   - Maintain access audit logs
   - Regular compliance checks

## Practical Exercises

1. **Key Vault Integration**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secrets-demo
spec:
  containers:
  - name: secrets-demo
    image: nginx
    volumeMounts:
    - name: secrets-store
      mountPath: "/mnt/secrets-store"
      readOnly: true
  volumes:
  - name: secrets-store
    csi:
      driver: secrets-store.csi.k8s.io
      readOnly: true
      volumeAttributes:
        secretProviderClass: azure-kvname
```

2. **ConfigMap Usage**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-demo
spec:
  containers:
  - name: config-demo
    image: nginx
    env:
    - name: APP_CONFIG
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: settings.json
```

## Additional Resources
- [Azure Key Vault Documentation](https://docs.microsoft.com/azure/key-vault/)
- [AKS Security Concepts](https://docs.microsoft.com/azure/aks/concepts-security)
- [CSI Driver Documentation](https://secrets-store-csi-driver.sigs.k8s.io/)
