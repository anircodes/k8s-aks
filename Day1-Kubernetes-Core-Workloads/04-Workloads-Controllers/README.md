# Workloads and Controllers

## Overview
This module covers Kubernetes workload resources and controllers including ReplicaSets, Deployments, and DaemonSets, with detailed explanations and practical implementations.

## Key Concepts

### ReplicaSets
```
┌─────────────────────┐
│    ReplicaSet      │
│   ┌───────────┐    │    ┌─────┐    ┌─────┐
│   │ Template  │────┼───►│Pod 1│    │Pod 2│
│   └───────────┘    │    └─────┘    └─────┘
│   ┌───────────┐    │         ▲        ▲
│   │  Replica  │    │         │        │
│   │  Count: 3 │────┼─────────┘        │
│   └───────────┘    │                  │
└─────────────────────┘                  │
            │                            │
            └───────────────────────────►│
```

**Key Features:**
1. **Pod Management:**
   - Maintains desired number of identical pods
   - Automatically replaces failed/deleted pods
   - Uses pod template for creating new pods

2. **Scaling:**
   - Horizontal scaling (add/remove pods)
   - Automatic pod distribution across nodes
   - Load balancing support

3. **Selection:**
   - Label selectors for pod matching
   - Supports set-based selectors
   - Template must match selector

### Deployments
```
┌───────────────────┐
│    Deployment     │
│  ┌────────────┐   │
│  │ ReplicaSet │◄──┼──── Rolling Updates
│  │    V1      │   │
│  └────────────┘   │
│  ┌────────────┐   │
│  │ ReplicaSet │◄──┼──── Rollback
│  │    V2      │   │
│  └────────────┘   │
└───────────────────┘
```

**Advanced Features:**
1. **Update Strategies:**
   - RollingUpdate (default)
     - MaxSurge: Extra pods during update
     - MaxUnavailable: Max pods down during update
   - Recreate
     - Terminates all pods before creating new ones

2. **Rollout Management:**
   - Automatic version tracking
   - Rollback to previous versions
   - Pause/resume capabilities
   - Deployment history

3. **Health Checks:**
   - Readiness probes
   - Liveness probes
   - Progress deadline monitoring

### DaemonSets
```
┌─────────────────┐
│   DaemonSet    │
│  ┌──────────┐  │
│  │Template  │  │
│  └──────────┘  │
└───────┬─────────┘
        │
        ▼
┌─────────────────┐    ┌─────────────────┐
│    Node 1       │    │    Node 2       │
│  ┌──────────┐  │    │  ┌──────────┐  │
│  │  Pod     │  │    │  │  Pod     │  │
│  └──────────┘  │    │  └──────────┘  │
└─────────────────┘    └─────────────────┘
```

**Special Characteristics:**
1. **Node Coverage:**
   - One pod per node (by default)
   - Respects node selectors and taints
   - Automatic pod creation on new nodes

2. **Use Cases:**
   - Monitoring agents
   - Log collectors
   - Network plugins
   - Storage daemons

3. **Update Strategy:**
   - RollingUpdate (default)
   - OnDelete (manual pod deletion)

## Practical Exercises

### 1. Working with Deployments

```bash
# Create a deployment
kubectl apply -f nginx-deployment.yaml

# Scale deployment
kubectl scale deployment nginx-deployment --replicas=5

# Perform rolling update
kubectl set image deployment/nginx-deployment nginx=nginx:1.21

# Rollback deployment
kubectl rollout undo deployment/nginx-deployment
```

### 2. Managing ReplicaSets

```bash
# Create a ReplicaSet
kubectl apply -f nginx-replicaset.yaml

# Scale ReplicaSet
kubectl scale rs nginx-replicaset --replicas=3

# Delete ReplicaSet (keeping pods)
kubectl delete rs nginx-replicaset --cascade=false
```

### 3. DaemonSet Operations

```bash
# Create DaemonSet
kubectl apply -f monitoring-daemonset.yaml

# View DaemonSet status
kubectl get ds
kubectl describe ds monitoring-daemonset

# Update DaemonSet
kubectl set image ds/monitoring-daemonset container=new-image:tag
```

## Practice Tasks and Solutions

### Task 1: Create a Multi-Container Deployment

**Solution:**
```yaml
apiVersion: apps/v1
kind: Deployment
name: web-app
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
      - name: log-aggregator
        image: fluentd:v1.14
        volumeMounts:
        - name: log-volume
          mountPath: /var/log
      volumes:
      - name: log-volume
        emptyDir: {}
```

**Deployment Steps:**
```bash
# Create the deployment
kubectl apply -f web-app-deployment.yaml

# Verify deployment
kubectl get deployments
kubectl get pods
kubectl describe deployment web-app

Sample Output:
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
web-app   3/3     3            3           2m

# Check logs from both containers
kubectl logs <pod-name> -c nginx
kubectl logs <pod-name> -c log-aggregator
```

### Task 2: Implement Rolling Updates and Rollbacks

**Solution:**
```bash
# 1. Check current deployment status
kubectl get deployment web-app -o wide
Sample Output:
NAME      READY   UP-TO-DATE   AVAILABLE   AGE   CONTAINERS   IMAGES
web-app   3/3     3            3           10m   nginx        nginx:1.21

# 2. Perform rolling update
kubectl set image deployment/web-app nginx=nginx:1.22 --record
Sample Output:
deployment.apps/web-app image updated

# 3. Monitor rollout status
kubectl rollout status deployment/web-app
Sample Output:
Waiting for rollout to finish: 1 old replicas are pending termination...
deployment "web-app" successfully rolled out

# 4. View rollout history
kubectl rollout history deployment/web-app
Sample Output:
REVISION  CHANGE-CAUSE
1         <none>
2         kubectl set image deployment/web-app nginx=nginx:1.22 --record=true

# 5. Rollback to previous version
kubectl rollout undo deployment/web-app
Sample Output:
deployment.apps/web-app rolled back
```

### Task 3: Deploy a Monitoring Solution Using DaemonSet

**Solution:**
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: monitoring-agent
spec:
  selector:
    matchLabels:
      name: monitoring-agent
  template:
    metadata:
      labels:
        name: monitoring-agent
    spec:
      containers:
      - name: prometheus-node-exporter
        image: prom/node-exporter:latest
        ports:
        - containerPort: 9100
        volumeMounts:
        - name: proc
          mountPath: /host/proc
          readOnly: true
        - name: sys
          mountPath: /host/sys
          readOnly: true
      volumes:
      - name: proc
        hostPath:
          path: /proc
      - name: sys
        hostPath:
          path: /sys
```

**Deployment and Verification:**
```bash
# 1. Deploy the DaemonSet
kubectl apply -f monitoring-daemonset.yaml

# 2. Verify DaemonSet deployment
kubectl get daemonset
Sample Output:
NAME               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE
monitoring-agent   3         3         3       3            3

# 3. Check pods on each node
kubectl get pods -o wide
Sample Output:
NAME                     READY   STATUS    NODE
monitoring-agent-abc12   1/1     Running   node1
monitoring-agent-def34   1/1     Running   node2
monitoring-agent-ghi56   1/1     Running   node3

# 4. Verify metrics endpoint
kubectl port-forward <pod-name> 9100:9100
curl localhost:9100/metrics
```

### Task 4: Scale Applications Up and Down

**Solution:**
```bash
# 1. Check current scale
kubectl get deployment web-app
Sample Output:
NAME      READY   UP-TO-DATE   AVAILABLE   AGE
web-app   3/3     3            3           1h

# 2. Scale up to 5 replicas
kubectl scale deployment web-app --replicas=5
Sample Output:
deployment.apps/web-app scaled

# 3. Monitor scaling progress
kubectl get pods -l app=web-app -w
Sample Output:
NAME                       READY   STATUS    RESTARTS   AGE
web-app-xyz-1             1/1     Running   0          1h
web-app-xyz-2             1/1     Running   0          1h
web-app-xyz-3             1/1     Running   0          1h
web-app-xyz-4             0/1     Pending   0          0s
web-app-xyz-4             0/1     ContainerCreating   0          0s
web-app-xyz-5             0/1     Pending   0          0s
web-app-xyz-4             1/1     Running   0          2s
web-app-xyz-5             0/1     ContainerCreating   0          1s
web-app-xyz-5             1/1     Running   0          3s

# 4. Test autoscaling (HPA)
kubectl autoscale deployment web-app --min=3 --max=10 --cpu-percent=80
Sample Output:
horizontalpodautoscaler.autoscaling/web-app autoscaled

# 5. Verify HPA
kubectl get hpa
Sample Output:
NAME      REFERENCE            TARGETS   MINPODS   MAXPODS   REPLICAS
web-app   Deployment/web-app   0%/80%    3         10        5
```

### Additional Tips:
1. Always use resource requests and limits in production deployments
2. Implement proper health checks using readiness and liveness probes
3. Use namespaces to organize workloads
4. Label resources properly for better management
5. Keep deployment history for quick rollbacks

Check the example YAML files in this directory for reference implementations.
