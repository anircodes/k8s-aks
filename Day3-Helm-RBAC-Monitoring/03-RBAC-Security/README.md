# RBAC and Security in Kubernetes

## Overview
This module covers Role-Based Access Control (RBAC) and security configurations in Kubernetes.

## Key Concepts

### RBAC Components
- Roles and ClusterRoles
- RoleBindings and ClusterRoleBindings
- ServiceAccounts
- Security Contexts

### Namespace Management
- Resource quotas
- Limit ranges
- Network policies

## Practical Exercises

### 1. Creating Roles and Bindings

See [rbac-examples.yaml](rbac-examples.yaml) for implementation.

```bash
# Create role and binding
kubectl apply -f rbac-examples.yaml

# Verify permissions
kubectl auth can-i list pods --as=system:serviceaccount:default:app-viewer
```

### 2. Service Accounts

See [service-accounts.yaml](service-accounts.yaml) for examples.

```bash
# Create service account
kubectl apply -f service-accounts.yaml

# List service accounts
kubectl get serviceaccounts
```

### 3. Network Policies

See [network-policies.yaml](network-policies.yaml) for implementation.

```bash
# Apply network policies
kubectl apply -f network-policies.yaml

# Verify policies
kubectl describe networkpolicies
```

## Practice Tasks

1. Set up role-based access
2. Configure service accounts
3. Implement network policies
4. Manage security contexts

All configuration files are available in this directory.
