# WordPress with MySQL on AKS

## Overview
This project demonstrates deploying a production-ready WordPress installation with MySQL on AKS, including persistent storage, secrets management, and ingress configuration.

## Components

1. MySQL StatefulSet with persistent storage
2. WordPress deployment with Azure Files
3. Secrets for database credentials
4. Application Gateway Ingress
5. Azure Storage integration

## Implementation Steps

### 1. Create Namespaces and Secrets
```bash
# Create namespace
kubectl create namespace wordpress

# Create secrets
kubectl apply -f secrets.yaml -n wordpress
```

### 2. Deploy MySQL
```bash
# Create MySQL StatefulSet and Service
kubectl apply -f mysql.yaml -n wordpress
```

### 3. Deploy WordPress
```bash
# Create WordPress Deployment and Service
kubectl apply -f wordpress.yaml -n wordpress
```

### 4. Configure Ingress
```bash
# Create Ingress rules
kubectl apply -f wordpress-ingress.yaml -n wordpress
```

## Configuration Files

1. [secrets.yaml](secrets.yaml) - Database credentials and WordPress secrets
2. [mysql.yaml](mysql.yaml) - MySQL StatefulSet configuration
3. [wordpress.yaml](wordpress.yaml) - WordPress deployment configuration
4. [wordpress-ingress.yaml](wordpress-ingress.yaml) - Ingress configuration

## Verification Steps

1. Check Deployments
```bash
kubectl get all -n wordpress
```

2. Verify Storage
```bash
kubectl get pvc -n wordpress
```

3. Access WordPress
```bash
# Get WordPress URL
kubectl get ingress -n wordpress
```

## Project Extensions

1. Add backup solution
2. Implement caching
3. Configure SSL/TLS
4. Add monitoring

All configuration files are available in this directory.
