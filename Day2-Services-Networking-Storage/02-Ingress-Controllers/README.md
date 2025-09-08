# Azure Kubernetes Service (AKS) Networking and Ingress

## Overview
This module covers Azure-native networking solutions for AKS, focusing on Azure Application Gateway Ingress Controller (AGIC), Azure CNI, and advanced networking features.

## Azure Networking Components

### 1. Azure CNI (Container Networking Interface)
- **Advanced Networking Mode**
  - Direct integration with Azure VNet
  - Pod IPs from subnet range
  - Network Security Groups (NSGs) support
  - Network Policies enforcement
  - Azure Route Tables integration

### 2. Application Gateway Ingress Controller (AGIC)
- **Features**
  - Native Azure L7 load balancing
  - Web Application Firewall (WAF)
  - End-to-end SSL/TLS
  - Cookie-based session affinity
  - URL-based routing
  - Multiple site hosting

### 3. Azure Front Door Integration
- Global load balancing
- WAF at edge
- CDN capabilities
- SSL/TLS termination

## Implementation Guide

### 1. Azure CNI Setup
```batch
@REM Create AKS with Azure CNI
az aks create ^
    --resource-group myResourceGroup ^
    --name myAKSCluster ^
    --network-plugin azure ^
    --vnet-subnet-id <subnet-id> ^
    --docker-bridge-address 172.17.0.1/16 ^
    --dns-service-ip 10.2.0.10 ^
    --service-cidr 10.2.0.0/24 ^
    --network-policy azure

@REM Enable network policy
az aks update ^
    --resource-group myResourceGroup ^
    --name myAKSCluster ^
    --network-policy azure
```

### 2. AGIC Installation

#### Prerequisites
```batch
@REM Create Application Gateway
az network application-gateway create ^
    --name myAppGateway ^
    --resource-group myResourceGroup ^
    --vnet-name myVnet ^
    --subnet mySubnet ^
    --sku WAF_v2

@REM Enable AGIC add-on
az aks enable-addons ^
    --resource-group myResourceGroup ^
    --name myAKSCluster ^
    --addons ingress-appgw ^
    --appgw-id <gateway-id>
```

#### Basic Configuration (agic-setup.yaml)
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
    appgw.ingress.kubernetes.io/ssl-redirect: "true"
    appgw.ingress.kubernetes.io/use-private-ip: "false"
    appgw.ingress.kubernetes.io/connection-draining: "true"
    appgw.ingress.kubernetes.io/cookie-based-affinity: "true"
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```

### 3. Azure Front Door Setup
```batch
@REM Create Front Door profile
az afd profile create ^
    --resource-group myResourceGroup ^
    --profile-name myFrontDoor ^
    --sku Premium_AzureFrontDoor

@REM Add endpoint
az afd endpoint create ^
    --resource-group myResourceGroup ^
    --endpoint-name myEndpoint ^
    --profile-name myFrontDoor

@REM Configure origin group
az afd origin-group create ^
    --resource-group myResourceGroup ^
    --origin-group-name myOriginGroup ^
    --profile-name myFrontDoor ^
    --probe-path / ^
    --probe-protocol Http
```

## Advanced Features

### 1. Azure Private Link Service
```batch
@REM Enable Private Link Service
az aks update ^
    --resource-group myResourceGroup ^
    --name myAKSCluster ^
    --enable-private-cluster
```

### 2. Azure DNS Integration
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns-custom
  namespace: kube-system
data:
  azure.server: |
    azure.local {
        forward . 168.63.129.16
    }
```

### 3. WAF Policies
```batch
@REM Create WAF policy
az network application-gateway waf-policy create ^
    --name myWafPolicy ^
    --resource-group myResourceGroup ^
    --mode Prevention ^
    --state Enabled

@REM Configure WAF rules
az network application-gateway waf-policy rule create ^
    --name myWafRule ^
    --policy-name myWafPolicy ^
    --resource-group myResourceGroup ^
    --rule-type MatchRule ^
    --priority 100
```

## Monitoring and Troubleshooting

### 1. Network Watcher Integration
```batch
@REM Enable Network Watcher
az network watcher configure ^
    --resource-group myResourceGroup ^
    --locations eastus --enabled

@REM Capture network traces
az network watcher packet-capture create ^
    --resource-group myResourceGroup ^
    --name myCapture ^
    --target <vmss-resource-id>
```

### 2. Network Insights
```batch
@REM Enable Network Insights
az aks update ^
    --resource-group myResourceGroup ^
    --name myAKSCluster ^
    --enable-azure-monitor-metrics
```

## Best Practices

1. **Network Security**
   - Implement NSGs at subnet level
   - Use Azure Network Policies
   - Enable WAF in prevention mode
   - Regular security audit

2. **Performance Optimization**
   - Use Azure CNI for production
   - Enable acceleration for required workloads
   - Configure proper health probes
   - Implement proper scaling rules

3. **High Availability**
   - Deploy across availability zones
   - Use multiple replicas
   - Implement proper health checks
   - Configure proper timeouts

4. **Cost Optimization**
   - Right-size Application Gateway
   - Use appropriate SKU
   - Monitor bandwidth usage
   - Implement auto-scaling

## Practical Exercises

1. **Basic Network Setup**
```batch
@REM Create virtual network
az network vnet create ^
    --resource-group myResourceGroup ^
    --name myVnet ^
    --address-prefix 10.0.0.0/16

@REM Create subnets
az network vnet subnet create ^
    --resource-group myResourceGroup ^
    --vnet-name myVnet ^
    --name aks-subnet ^
    --address-prefix 10.0.1.0/24

az network vnet subnet create ^
    --resource-group myResourceGroup ^
    --vnet-name myVnet ^
    --name agw-subnet ^
    --address-prefix 10.0.2.0/24
```

2. **Advanced Network Policies**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: azure-network-policy
spec:
  podSelector:
    matchLabels:
      app: myapp
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          purpose: production
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/16
```

## Additional Resources
- [Azure Application Gateway Documentation](https://docs.microsoft.com/azure/application-gateway/)
- [AKS Networking Concepts](https://docs.microsoft.com/azure/aks/concepts-network)
- [Azure CNI Documentation](https://docs.microsoft.com/azure/aks/azure-cni-overview)
