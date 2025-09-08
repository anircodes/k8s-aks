@echo off
REM Create Production AKS Cluster
az aks create ^
    --resource-group myResourceGroup ^
    --name myAKSCluster ^
    --node-count 3 ^
    --enable-addons monitoring,http_application_routing ^
    --enable-managed-identity ^
    --enable-cluster-autoscaler ^
    --min-count 3 ^
    --max-count 6 ^
    --network-plugin azure ^
    --network-policy azure ^
    --zones 1 2 3 ^
    --generate-ssh-keys

REM Get AKS Credentials with admin access
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster --admin

REM View AKS-specific Components
az aks show -g myResourceGroup -n myAKSCluster
kubectl get nodes -o wide --show-labels
kubectl get pods -n kube-system
az aks nodepool list --resource-group myResourceGroup --cluster-name myAKSCluster

REM AKS Node Management
REM Cordon and drain node for maintenance
az aks nodepool update --resource-group myResourceGroup --cluster-name myAKSCluster --name systempool --enable-cluster-autoscaler --min-count 3 --max-count 5
kubectl drain %1 --ignore-daemonsets --delete-emptydir-data
kubectl cordon %1
kubectl uncordon %1

REM AKS Health Checks
az aks show -g myResourceGroup -n myAKSCluster --query "provisioningState"
kubectl get events --all-namespaces
kubectl describe node %1
az aks show -g myResourceGroup -n myAKSCluster --query "powerState"

REM Azure Monitor Logs
az monitor log-analytics workspace list --resource-group myResourceGroup
kubectl logs -n kube-system -l component=oms-agent
kubectl logs -n kube-system -l k8s-app=kube-proxy

REM Check Azure CNI and Network Policy
kubectl get networkpolicies --all-namespaces
az network vnet subnet show -g myResourceGroup --vnet-name myAKSVNet -n myAKSSubnet
