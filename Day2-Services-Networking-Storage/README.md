# Day 2: Services, Networking, and Storage

## Overview
Day 2 focuses on Kubernetes networking concepts, service types, ingress controllers, and storage solutions with Azure integration.

## Modules

### 1. Services & DNS (01-Services-DNS)
- Service types
  - ClusterIP
  - NodePort
  - LoadBalancer
- DNS in Kubernetes
- Service discovery
- Endpoints
- External service integration
- Azure Load Balancer integration

### 2. Ingress Controllers (02-Ingress-Controllers)
- Application Gateway Ingress Controller (AGIC)
- NGINX Ingress Controller
- URL routing
- SSL/TLS termination
- Path-based routing
- Host-based routing
- Azure WAF integration

### 3. Config & Secrets (03-Config-Secrets)
- ConfigMaps
- Secrets management
- Azure Key Vault integration
- Environment variables
- Configuration management
- Secret rotation
- Best practices

### 4. Storage (04-Storage)
- Storage concepts
- Persistent Volumes
- Persistent Volume Claims
- Storage Classes
- Azure Disk integration
- Azure Files integration
- Dynamic provisioning

### 5. WordPress Project (05-WordPress-Project)
- Complete WordPress deployment
- MySQL with persistence
- Ingress configuration
- SSL/TLS setup
- Backup configuration
- High availability setup

## Hands-on Labs

1. **Services Lab**
   - Service type implementations
   - Load balancer configuration
   - Service discovery testing
   - DNS resolution testing

2. **Ingress Lab**
   - AGIC setup
   - NGINX Ingress setup
   - Route configuration
   - SSL/TLS implementation

3. **Storage Lab**
   - PV/PVC creation
   - Azure storage integration
   - Dynamic provisioning
   - Backup configuration

4. **WordPress Deployment Lab**
   - Application setup
   - Database configuration
   - Ingress setup
   - SSL configuration

## Prerequisites
- Completion of Day 1
- Azure subscription
- AKS cluster running
- Azure CLI configured
- kubectl configured

## Key Concepts
1. **Networking**
   - Kubernetes networking model
   - Service networking
   - Ingress networking
   - Network policies

2. **Services**
   - Service discovery
   - Load balancing
   - External access
   - Internal communication

3. **Storage**
   - Storage hierarchy
   - Volume types
   - Storage provisioning
   - Backup strategies

4. **Security**
   - TLS termination
   - Secret management
   - Access control
   - Network policies

## Azure Integration Points
- Azure Load Balancer
- Application Gateway
- Azure Key Vault
- Azure Disk Storage
- Azure File Storage
- Azure Backup

## Best Practices
1. **Networking**
   - Network segmentation
   - Security groups
   - Load balancer configuration
   - Ingress patterns

2. **Storage**
   - Storage planning
   - Backup strategies
   - Performance optimization
   - Cost management

3. **Security**
   - Secret management
   - Access control
   - Network policies
   - SSL/TLS configuration

## Resources
- [AKS Networking](https://docs.microsoft.com/azure/aks/concepts-network)
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [AGIC Documentation](https://docs.microsoft.com/azure/application-gateway/ingress-controller-overview)
- [Azure Storage](https://docs.microsoft.com/azure/aks/concepts-storage)
