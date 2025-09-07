# Storage in Kubernetes

## Overview
This module covers Kubernetes storage concepts including Persistent Volumes (PV), Persistent Volume Claims (PVC), and Storage Classes.

## Key Concepts

### Persistent Volumes (PV)
- Cluster-wide storage resources
- Independent of pod lifecycle
- Multiple access modes
- Various storage backends

### Persistent Volume Claims (PVC)
- Storage requests by pods
- Storage specification
- Dynamic provisioning
- Storage selection

### Storage Classes
- Dynamic volume provisioning
- Storage type definition
- Default storage class
- Storage parameters

## Practical Exercises

### 1. Working with PersistentVolumes

See [persistent-volume.yaml](persistent-volume.yaml) for implementation.

```bash
# Create PV
kubectl apply -f persistent-volume.yaml

# View PV status
kubectl get pv
```

### 2. Creating PVCs

See [persistent-volume-claim.yaml](persistent-volume-claim.yaml) for details.

```bash
# Create PVC
kubectl apply -f persistent-volume-claim.yaml

# Check PVC status
kubectl get pvc
```

### 3. Storage Classes

See [storage-class.yaml](storage-class.yaml) for Azure examples.

```bash
# Create Storage Class
kubectl apply -f storage-class.yaml

# List Storage Classes
kubectl get sc
```

## Practice Tasks

1. Create and use Azure disk storage
2. Implement shared storage with Azure Files
3. Configure dynamic provisioning
4. Manage storage quotas

All configuration files are available in this directory.
