@echo off
REM Kubernetes Workloads Hands-on Lab

REM 1. Basic Pod Operations
echo "1. Creating and Managing Pods"
kubectl apply -f nginx-pod.yaml
kubectl get pods
kubectl describe pod nginx-pod
kubectl port-forward pod/nginx-pod 8080:80

REM 2. ReplicaSet Operations
echo "2. Working with ReplicaSets"
kubectl apply -f nginx-replicaset.yaml
kubectl get rs
kubectl scale rs nginx-replicaset --replicas=5
kubectl describe rs nginx-replicaset

REM 3. Deployment Operations
echo "3. Deployment Management"
kubectl apply -f nginx-deployment.yaml
kubectl get deployments
kubectl rollout status deployment/nginx-deployment
kubectl set image deployment/nginx-deployment nginx=nginx:1.19
kubectl rollout history deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment

REM 4. DaemonSet Operations
echo "4. DaemonSet Management"
kubectl apply -f monitoring-daemonset.yaml
kubectl get ds
kubectl describe ds monitoring-daemon

REM 5. Job and CronJob Operations
echo "5. Jobs and CronJobs"
kubectl apply -f batch-job.yaml
kubectl get jobs
kubectl apply -f scheduled-backup.yaml
kubectl get cronjobs

REM 6. StatefulSet Operations
echo "6. StatefulSet Management"
kubectl apply -f mongodb-statefulset.yaml
kubectl get sts
kubectl describe sts mongodb

REM 7. Resource Quotas
echo "7. Resource Management"
kubectl apply -f resource-quota.yaml
kubectl describe quota compute-resources

REM 8. Configuration and Secrets
echo "8. Config and Secrets"
kubectl create configmap app-config --from-file=config.properties
kubectl create secret generic db-creds --from-literal=username=admin --from-literal=password=secret

REM 9. Cleanup
echo "9. Cleanup"
kubectl delete -f nginx-pod.yaml
kubectl delete -f nginx-replicaset.yaml
kubectl delete -f nginx-deployment.yaml
kubectl delete -f monitoring-daemonset.yaml
kubectl delete -f batch-job.yaml
kubectl delete -f scheduled-backup.yaml
kubectl delete -f mongodb-statefulset.yaml
kubectl delete -f resource-quota.yaml
kubectl delete configmap app-config
kubectl delete secret db-creds

echo "Kubernetes Workloads Lab Complete!"
