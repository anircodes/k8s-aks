# ConfigMaps and Secrets

## Overview
This module covers configuration management and sensitive data handling in Kubernetes using ConfigMaps and Secrets.

## Key Concepts

### ConfigMaps
- Store non-sensitive configuration
- Key-value pairs
- Environment variables
- Configuration files

### Secrets
- Store sensitive information
- Base64 encoded
- Multiple types (Generic, TLS, Docker)
- Integration with key vaults

## Practical Exercises

### 1. Working with ConfigMaps

See [configmap-examples.yaml](configmap-examples.yaml) for implementation.

```bash
# Create ConfigMap
kubectl apply -f configmap-examples.yaml

# View ConfigMap
kubectl get configmap app-config -o yaml
```

### 2. Managing Secrets

See [secret-examples.yaml](secret-examples.yaml) for implementation.

```bash
# Create secret
kubectl apply -f secret-examples.yaml

# View secret (encoded)
kubectl get secret app-secrets -o yaml
```

### 3. Using Azure Key Vault

See [key-vault-example.yaml](key-vault-example.yaml) for implementation.

```bash
# Install CSI driver
helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts
helm install csi csi-secrets-store-provider-azure/csi-secrets-store-provider-azure
```

## Practice Tasks

1. Create and use ConfigMaps
2. Implement Secrets
3. Mount configuration as files
4. Integrate with Azure Key Vault

All configuration files are available in this directory.
