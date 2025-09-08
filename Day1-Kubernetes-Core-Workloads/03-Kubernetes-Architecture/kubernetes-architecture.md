# Kubernetes Architecture

## Overview
Kubernetes follows a master-worker architecture pattern. The master node (control plane) manages the worker nodes and the workloads running on them.

## 1. High-Level Architecture
```
                                   ┌──────────────────────────────────────┐
                                   │            Control Plane             │
                                   │  ┌────────────┐    ┌────────────┐   │
┌──────────────┐                   │  │            │    │            │   │
│              │    API Request    │  │ API Server ├────┤   etcd    │   │
│   Client     ├──────────────────►│  │            │    │            │   │
│  (kubectl)   │                   │  └─────┬──────┘    └────────────┘   │
│              │                   │        │                             │
└──────────────┘                   │  ┌─────┴──────┐    ┌────────────┐   │
                                   │  │            │    │ Controller  │   │
                                   │  │ Scheduler  ├────┤  Manager   │   │
                                   │  │            │    │            │   │
                                   │  └────────────┘    └────────────┘   │
                                   └──────────────┬───────────────────────┘
                                                 │
                                                 │
                     ┌───────────────────────────┼───────────────────────────┐
                     │                           │                           │
             ┌───────▼───────┐           ┌───────▼───────┐           ┌───────▼───────┐
             │  Worker Node  │           │  Worker Node  │           │  Worker Node  │
             │  ┌─────────┐ │           │  ┌─────────┐ │           │  ┌─────────┐ │
             │  │ Kubelet │ │           │  │ Kubelet │ │           │  │ Kubelet │ │
             │  └─────────┘ │           │  └─────────┘ │           │  └─────────┘ │
             │  ┌─────────┐ │           │  ┌─────────┐ │           │  ┌─────────┐ │
             │  │  Proxy  │ │           │  │  Proxy  │ │           │  │  Proxy  │ │
             │  └─────────┘ │           │  └─────────┘ │           │  └─────────┘ │
             │  ┌─────────┐ │           │  ┌─────────┐ │           │  ┌─────────┐ │
             │  │Container│ │           │  │Container│ │           │  │Container│ │
             │  │ Runtime │ │           │  │ Runtime │ │           │  │ Runtime │ │
             │  └─────────┘ │           │  └─────────┘ │           │  └─────────┘ │
             └─────────────┘           └─────────────┘           └─────────────┘
```

## 2. Control Plane Components

### 2.1 API Server
```
┌─────────────────────────────────────────┐
│              API Server                  │
│                                         │
│  ┌─────────────┐      ┌─────────────┐  │
│  │   Auth &    │      │   Request   │  │
│  │ Validation  ├──────► Processing  │  │
│  └─────────────┘      └─────────────┘  │
│         │                    │         │
│  ┌─────────────┐      ┌─────────────┐  │
│  │   RBAC &    │      │    REST     │  │
│  │  Admission  │      │  Endpoints  │  │
│  └─────────────┘      └─────────────┘  │
└─────────────────────────────────────────┘
```
- **Purpose**: Central communication hub
- **Functions**:
  - Authentication & Authorization
  - API request validation
  - Resource validation
  - REST endpoint exposure

### 2.2 etcd
```
┌─────────────────────────────────────┐
│               etcd                  │
│  ┌───────────┐     ┌───────────┐   │
│  │  Key 1    │     │ Value 1   │   │
│  └───────────┘     └───────────┘   │
│  ┌───────────┐     ┌───────────┐   │
│  │  Key 2    │     │ Value 2   │   │
│  └───────────┘     └───────────┘   │
│         Distributed Storage         │
└─────────────────────────────────────┘
```
- **Purpose**: Distributed key-value store
- **Functions**:
  - Cluster state storage
  - Configuration storage
  - Service discovery

### 2.3 Scheduler
```
┌────────────────────────────────────┐
│            Scheduler               │
│                                   │
│  ┌───────────┐    ┌───────────┐   │
│  │  Filter   │    │   Score   │   │
│  │  Nodes    ├────► Filtered  │   │
│  └───────────┘    │   Nodes   │   │
│                   └───────────┘   │
│  ┌───────────────────────────┐    │
│  │      Node Selection       │    │
│  └───────────────────────────┘    │
└────────────────────────────────────┘
```
- **Purpose**: Pod placement decision maker
- **Functions**:
  - Resource requirement checks
  - Constraint validation
  - Node ranking

## 3. Worker Node Components

### 3.1 Kubelet
```
┌────────────────────────────────────┐
│             Kubelet               │
│  ┌──────────────┐  ┌──────────┐   │
│  │ Pod          │  │ Node     │   │
│  │ Management   │  │ Health   │   │
│  └──────────────┘  └──────────┘   │
│  ┌──────────────┐  ┌──────────┐   │
│  │ Container    │  │ Volume   │   │
│  │ Runtime      │  │ Mounts   │   │
│  └──────────────┘  └──────────┘   │
└────────────────────────────────────┘
```
- **Purpose**: Node agent
- **Functions**:
  - Pod lifecycle management
  - Container health checks
  - Volume management

### 3.2 Container Runtime
```
┌────────────────────────────────────┐
│        Container Runtime           │
│  ┌──────────────┐  ┌──────────┐   │
│  │ Container    │  │ Image    │   │
│  │ Lifecycle    │  │ Mgmt     │   │
│  └──────────────┘  └──────────┘   │
│  ┌──────────────────────────┐     │
│  │   Resource Isolation     │     │
│  └──────────────────────────┘     │
└────────────────────────────────────┘
```
- **Purpose**: Container operations
- **Functions**:
  - Container lifecycle management
  - Image management
  - Resource isolation

## 4. Networking Architecture
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Pod IP    │     │  Service IP │     │  External   │
│  Networking ├─────► Networking  ├─────►    IP       │
└─────────────┘     └─────────────┘     └─────────────┘
      │                   │                   │
      ▼                   ▼                   ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Container │     │    Kube     │     │  Ingress/   │
│  Network    │     │    Proxy    │     │  Load       │
│  Interface  │     │             │     │  Balancer   │
└─────────────┘     └─────────────┘     └─────────────┘
```

## Node Operations

### 1. Node Scheduling
```
┌──────────────────┐     ┌──────────────────┐
│   Scheduler      │     │    Node Pool     │
│  ┌────────────┐  │     │  ┌────────────┐  │
│  │ Predicates │──┼────►│  │ Available  │  │
│  └────────────┘  │     │  │   Nodes    │  │
│  ┌────────────┐  │     │  └────────────┘  │
│  │ Priorities │  │     │  ┌────────────┐  │
│  └────────────┘  │     │  │ Scheduled  │  │
└──────────────────┘     │  │   Nodes    │  │
                        │  └────────────┘  │
                        └──────────────────┘
```

#### Scheduling Process:
1. **Node Selection**:
   - Resource requirements check
   - Node constraints evaluation
   - Affinity/anti-affinity rules
   - Taints and tolerations

2. **Resource Allocation**:
   - CPU requests and limits
   - Memory requests and limits
   - Storage requirements
   - Network resources

3. **Scheduling Policies**:
   - Pod priority
   - Node selector
   - Node affinity
   - Inter-pod affinity/anti-affinity

### 2. Node Maintenance Operations

#### Draining Nodes
```
┌─────────────────┐    ┌─────────────────┐
│   Active Node   │    │  Drained Node   │
│  ┌───────────┐  │    │                 │
│  │ Pod 1     │  │    │     Empty       │
│  └───────────┘  │    │                 │
│  ┌───────────┐  │ ═► │   Cordoned      │
│  │ Pod 2     │  │    │                 │
│  └───────────┘  │    │  Maintenance    │
└─────────────────┘    └─────────────────┘
```

**Drain Process**:
```bash
# Mark node as unschedulable
kubectl cordon node-name

# Drain the node
kubectl drain node-name --ignore-daemonsets --delete-emptydir-data

# After maintenance, make node schedulable
kubectl uncordon node-name
```

**Effects**:
- Pods are evicted gracefully
- New pods aren't scheduled
- DaemonSets are handled specially
- PodDisruptionBudget is respected

#### Node Cordon
- Marks node as unschedulable
- Existing pods continue running
- No new pods are scheduled
- Used for maintenance

## Practice Tasks and Solutions

### Task 1: Explore Control Plane
```bash
# Check control plane components
kubectl get pods -n kube-system

Sample Output:
NAME                                    READY   STATUS    RESTARTS   AGE
coredns-869cb84759-f2kt6               1/1     Running   0          5d
coredns-869cb84759-mczkg               1/1     Running   0          5d
etcd-master                            1/1     Running   0          5d
kube-apiserver-master                   1/1     Running   0          5d
kube-controller-manager-master          1/1     Running   0          5d
kube-scheduler-master                   1/1     Running   0          5d

# View API server logs
kubectl logs -n kube-system kube-apiserver-master
Sample Output:
I0908 10:00:00.000000       1 server.go:632] external host was not specified
I0908 10:00:00.000000       1 server.go:182] Version: v1.25.0

# Monitor scheduler decisions
kubectl logs -n kube-system kube-scheduler-master
Sample Output:
I0908 10:00:00.000000       1 scheduler.go:87] Starting Kubernetes Scheduler
```

### Task 2: Worker Node Analysis
```bash
# List nodes with details
kubectl get nodes -o wide
Sample Output:
NAME     STATUS   ROLES    AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE
node1    Ready    master   5d    v1.25.0   10.0.0.10     <none>        Ubuntu 20.04
node2    Ready    worker   5d    v1.25.0   10.0.0.11     <none>        Ubuntu 20.04

# Get detailed node information
kubectl describe node node1
Sample Output:
Name:               node1
Roles:              master
Labels:             beta.kubernetes.io/arch=amd64
                   beta.kubernetes.io/os=linux
Annotations:        node.alpha.kubernetes.io/ttl: 0
Capacity:
  cpu:                4
  memory:             8Gi
  pods:               110

# Check node resource usage
kubectl top node
Sample Output:
NAME    CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%
node1   250m         6%     1.5Gi           20%
node2   150m         3%     1.0Gi           12%
```

### Task 3: Node Maintenance Practice
```bash
# 1. Mark node for maintenance
kubectl cordon node2
Sample Output:
node/node2 cordoned

# 2. Check node status
kubectl get nodes
Sample Output:
NAME    STATUS                     ROLES    AGE   VERSION
node1   Ready                      master   5d    v1.25.0
node2   Ready,SchedulingDisabled   worker   5d    v1.25.0

# 3. Drain node for maintenance
kubectl drain node2 --ignore-daemonsets
Sample Output:
node/node2 already cordoned
evicting pod default/nginx-66b6c48dd5-abc12
pod/nginx-66b6c48dd5-abc12 evicted

# 4. Perform maintenance tasks
# ... maintenance operations ...

# 5. Make node schedulable again
kubectl uncordon node2
Sample Output:
node/node2 uncordoned
```

### Task 4: Network Verification
```bash
# Create test pods
kubectl run pod1 --image=nginx
kubectl run pod2 --image=busybox -- sleep 3600

# Get pod IPs
kubectl get pods -o wide
Sample Output:
NAME   READY   STATUS    RESTARTS   AGE   IP           NODE
pod1   1/1     Running   0          1m    10.244.1.2   node2
pod2   1/1     Running   0          1m    10.244.1.3   node2

# Test pod communication
kubectl exec -it pod2 -- ping -c 4 10.244.1.2
Sample Output:
PING 10.244.1.2 (10.244.1.2): 56 data bytes
64 bytes from 10.244.1.2: seq=0 ttl=64 time=0.069 ms
64 bytes from 10.244.1.2: seq=1 ttl=64 time=0.074 ms
64 bytes from 10.244.1.2: seq=2 ttl=64 time=0.076 ms
64 bytes from 10.244.1.2: seq=3 ttl=64 time=0.074 ms

# Check service connectivity
kubectl expose pod pod1 --port=80 --type=ClusterIP
kubectl get svc
Sample Output:
NAME   TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
pod1   ClusterIP   10.96.123.45   <none>        80/TCP    1m
```

## Common Issues and Solutions

1. **Control Plane Issues**
   - API Server unavailable: Check certificates and process status
   - etcd data corruption: Restore from backup
   - Controller failures: Check logs and restart components

2. **Worker Node Issues**
   - Kubelet not running: Check systemd service
   - Runtime errors: Verify container runtime status
   - Network issues: Check CNI configuration

## Best Practices

1. **High Availability**
   - Deploy multiple master nodes
   - Regular etcd backups
   - Use node anti-affinity

2. **Security**
   - Implement RBAC
   - Use network policies
   - Regular security audits

3. **Monitoring**
   - Monitor component health
   - Track resource usage
   - Set up alerting

## Additional Resources
- [Kubernetes Documentation](https://kubernetes.io/docs/concepts/overview/components/)
- [Architecture Guide](https://kubernetes.io/docs/concepts/architecture/)
