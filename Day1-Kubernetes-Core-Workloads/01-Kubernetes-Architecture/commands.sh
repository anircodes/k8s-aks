# Create AKS Cluster
az aks create \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --node-count 3 \
    --enable-addons monitoring \
    --generate-ssh-keys

# Get AKS Credentials
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster

# View Cluster Components
kubectl get nodes -o wide
kubectl get pods -n kube-system
kubectl get componentstatuses

# Node Management
kubectl drain <node-name> --ignore-daemonsets
kubectl cordon <node-name>
kubectl uncordon <node-name>

# Health Checks
kubectl get events --all-namespaces
kubectl describe node <node-name>
kubectl logs -n kube-system <pod-name>

# View API Server Status
curl -k https://localhost:6443/healthz

# View System Pod Logs
kubectl logs -n kube-system <pod-name> --tail=100
