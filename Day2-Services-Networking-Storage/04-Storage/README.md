# Azure Storage Integration with AKS

## Overview
This module covers Azure-native storage solutions for AKS, including Azure Disk CSI, Azure Files, and Azure Blob storage integration.

## Azure Storage Components

### 1. Azure Disk CSI Driver
- **Features**
  - Dynamic provisioning
  - Snapshot support
  - Volume expansion
  - Zone redundancy
  - Performance tiers
  - Encryption at rest

### 2. Azure Files CSI Driver
- **Capabilities**
  - ReadWriteMany support
  - SMB protocol
  - Cross-zone access
  - Backup integration
  - AD integration

### 3. Azure Storage Account Integration
- Premium and Standard tiers
- Managed identity support
- Firewall rules
- Private endpoints
- Lifecycle management

## Implementation Guide

### 1. Azure Disk Storage Setup

#### Storage Class Configuration
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-premium-retain
provisioner: disk.csi.azure.com
parameters:
  skuName: Premium_LRS
  kind: Managed
  cachingMode: ReadOnly
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
```

#### PVC Example
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: azure-disk-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: managed-premium-retain
  resources:
    requests:
      storage: 100Gi
```

### 2. Azure Files Integration

#### Storage Class Setup
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: azurefile-premium
provisioner: file.csi.azure.com
parameters:
  skuName: Premium_LRS
mountOptions:
  - dir_mode=0777
  - file_mode=0777
```

#### Azure Files PVC
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: azurefile-pvc
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: azurefile-premium
  resources:
    requests:
      storage: 100Gi
```

### 3. Backup and Snapshot Configuration

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: disk-snapshot
spec:
  volumeSnapshotClassName: azurefile-premium
  source:
    persistentVolumeClaimName: azure-disk-pvc
```

## Advanced Features

### 1. Encryption Configuration
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: encrypted-premium
provisioner: disk.csi.azure.com
parameters:
  skuName: Premium_LRS
  encryption: "true"
  keyVaultURL: https://mykeyvault.vault.azure.net/
  keyName: diskkey
  keyVersion: "<version>"
```

### 2. Private Endpoint Setup
```batch
@REM Create private endpoint
az network private-endpoint create ^
    --resource-group myResourceGroup ^
    --name myPrivateEndpoint ^
    --vnet-name myVnet ^
    --subnet mySubnet ^
    --private-connection-resource-id <storage-account-id> ^
    --group-id blob ^
    --connection-name myConnection
```

### 3. Backup Policy
```batch
@REM Configure backup
az backup vault create ^
    --resource-group myResourceGroup ^
    --name myVault ^
    --location eastus

@REM Create backup policy
az backup policy create ^
    --resource-group myResourceGroup ^
    --vault-name myVault ^
    --name myPolicy ^
    --backup-management-type AzureWorkload ^
    --workload-type SAPHanaDatabase
```

## Performance Optimization

### 1. Storage Account Configuration
```batch
@REM Create premium storage account
az storage account create ^
    --name mystorageaccount ^
    --resource-group myResourceGroup ^
    --sku Premium_LRS ^
    --kind FileStorage ^
    --enable-large-file-share

@REM Enable soft delete
az storage blob-service-properties update ^
    --account-name mystorageaccount ^
    --enable-delete-retention true ^
    --delete-retention-days 7
```

### 2. Performance Tiers
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ultra-disk
provisioner: disk.csi.azure.com
parameters:
  skuName: UltraSSD_LRS
  cachingMode: None
  diskIops: "5000"
  diskMbps: "200"
```

## Monitoring and Troubleshooting

### 1. Storage Insights
```batch
@REM Enable storage metrics
az monitor metrics alert create ^
    --resource-group myResourceGroup ^
    --name storage-alert ^
    --scopes <storage-account-id> ^
    --condition "avg StorageLatency >= 100"
```

### 2. Diagnostics Settings
```batch
@REM Enable diagnostics
az monitor diagnostic-settings create ^
    --resource <storage-account-id> ^
    --name myDiagnostics ^
    --logs "[{category:StorageRead,enabled:true}]" ^
    --workspace <log-analytics-workspace-id>
```

## Best Practices

1. **Performance**
   - Use Premium storage for production
   - Enable caching appropriately
   - Choose correct disk size for IOPS
   - Use Ultra disks for high-performance needs

2. **Security**
   - Enable encryption at rest
   - Use managed identities
   - Implement network isolation
   - Regular access audits

3. **Backup and Recovery**
   - Regular snapshot schedule
   - Cross-region backup
   - Test restore procedures
   - Document recovery steps

4. **Cost Optimization**
   - Right-size storage accounts
   - Use appropriate SKUs
   - Implement lifecycle management
   - Monitor usage patterns

## Practical Exercises

1. **Basic Storage Setup**
```batch
@REM Create storage account
az storage account create ^
    --name myaksstore ^
    --resource-group myResourceGroup ^
    --sku Premium_LRS ^
    --kind StorageV2

@REM Create file share
az storage share create ^
    --name myshare ^
    --account-name myaksstore
```

2. **Managed Identity Configuration**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: storage-pod
spec:
  containers:
  - name: storage-pod
    image: mcr.microsoft.com/azure-storage/azcopy:latest
    volumeMounts:
    - name: azure-storage
      mountPath: /mnt/azure
  volumes:
  - name: azure-storage
    csi:
      driver: file.csi.azure.com
      volumeAttributes:
        secretName: storage-secret
        shareName: myshare
```

## Additional Resources
- [Azure Storage Documentation](https://docs.microsoft.com/azure/storage/)
- [AKS Storage Concepts](https://docs.microsoft.com/azure/aks/concepts-storage)
- [CSI Driver Documentation](https://github.com/kubernetes-sigs/azure-csi-drivers)
