# Ingress Controllers

## Overview
This module covers Ingress Controllers in Kubernetes, with a focus on Application Gateway Ingress Controller (AGIC) and NGINX Ingress Controller.

## Key Concepts

### Application Gateway Ingress Controller (AGIC)
- Native Azure integration
- SSL/TLS termination
- URL-based routing
- WAF capabilities

### NGINX Ingress Controller
- Open-source solution
- Flexible configuration
- Multiple ingress classes
- Advanced traffic control

## Practical Exercises

### 1. AGIC Setup

See [agic-setup.yaml](agic-setup.yaml) for complete setup.

```bash
# Install AGIC
helm repo add application-gateway-kubernetes-ingress https://appgwingress.blob.core.windows.net/ingress-azure-helm-package/
helm install agic application-gateway-kubernetes-ingress/ingress-azure \
     --namespace default \
     --set appgw.name=myAppGateway \
     --set appgw.resourceGroup=myResourceGroup \
     --set appgw.subscriptionId=mySubscriptionId \
     --set appgw.usePrivateIP=false \
     --set armAuth.type=servicePrincipal \
     --set armAuth.secretJSON=<Base64-encoded-service-principal-json>
```

### 2. NGINX Ingress Setup

See [nginx-ingress.yaml](nginx-ingress.yaml) for implementation.

```bash
# Install NGINX Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx
```

### 3. Configure Routing Rules

See [routing-rules.yaml](routing-rules.yaml) for examples.

```bash
# Apply routing rules
kubectl apply -f routing-rules.yaml

# Verify ingress
kubectl get ingress
```

## Practice Tasks

1. Set up AGIC in AKS
2. Configure SSL/TLS termination
3. Implement path-based routing
4. Set up multiple backend services

All configuration files are available in this directory.
