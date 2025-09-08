# Pod Lifecycle and Health Management in AKS

## Overview
This module covers Pod lifecycle management, health monitoring, and initialization in Azure Kubernetes Service (AKS), including detailed explanations of pod phases, container states, and health probes.

## Pod Lifecycle

### 1. Pod Phases
```
┌──────────────────────────────────────────────────────┐
│                     Pod Lifecycle                    │
│                                                      │
│  ┌─────────┐    ┌─────────┐    ┌──────────┐        │
│  │ Pending │───►│ Running │───►│Succeeded │        │
│  └─────────┘    └─────────┘    └──────────┘        │
│       │              │              ▲               │
│       │              │              │               │
│       │              ▼              │               │
│       └────────►┌─────────┐        │               │
│                 │ Failed  │◄────────┘               │
│                 └─────────┘                         │
│                     ▲                               │
│                     │                               │
│                 ┌─────────┐                         │
│                 │Unknown  │                         │
│                 └─────────┘                         │
└──────────────────────────────────────────────────────┘
```

**Phase Transitions:**
1. **Pending → Running**
   ```
   ┌─────────────┐
   │  Pending    │
   │ ┌─────────┐ │
   │ │Schedule │ │    ┌─────────────┐
   │ └────┬────┘ │    │  Running    │
   │      │      │    │ ┌─────────┐ │
   │ ┌────┴────┐ │    │ │Container│ │
   │ │Pull IMG │ ├───►│ │Starting │ │
   │ └─────────┘ │    │ └─────────┘ │
   └─────────────┘    └─────────────┘
   ```

2. **Running → Succeeded/Failed**
   - **Succeeded:** All containers completed successfully
   - **Failed:** At least one container terminated with error
   - **Unknown:** Node communication lost

**Detailed Phase Descriptions:**

1. **Pending Phase**
   - Pod accepted by Kubernetes system
   - Awaiting scheduling decision
   - Resource allocation in progress
   - Image downloads in progress
   - Volume mounting preparation

2. **Running Phase**
   - Pod bound to specific node
   - All containers created
   - At least one container active
   - Services can route traffic
   - Ready for workload

3. **Succeeded Phase**
   - All containers completed successfully
   - Typically for jobs/batch processes
   - No container restarts needed
   - Resources can be reclaimed

4. **Failed Phase**
   - All containers terminated
   - At least one failed with error
   - May trigger restart based on policy
   - Logs available for debugging

5. **Unknown Phase**
   - Node communication lost
   - Control plane can't determine state
   - Requires investigation
   - May need manual intervention

### 2. Container States
```
┌──────────────────────────────────────────────────┐
│               Container States                    │
│                                                  │
│    ┌─────────┐      ┌─────────┐                 │
│    │ Waiting │─────►│Running  │                 │
│    └─────────┘      └─────────┘                 │
│         │                │                       │
│         │                │                       │
│         ▼                ▼                       │
│    ┌──────────────────────┐                     │
│    │     Terminated       │                     │
│    └──────────────────────┘                     │
└──────────────────────────────────────────────────┘
```

**State Details:**

1. **Waiting State**
   ```
   ┌─────────────────┐
   │    Waiting      │
   │  ┌──────────┐   │
   │  │Pull Image│   │
   │  └──────────┘   │
   │  ┌──────────┐   │
   │  │Init Deps │   │
   │  └──────────┘   │
   └─────────────────┘
   ```
   - Container creation in progress
   - Resource allocation
   - Image pulling
   - Volume mounting
   - Dependency resolution

2. **Running State**
   ```
   ┌─────────────────┐
   │    Running      │
   │  ┌──────────┐   │
   │  │Process   │   │
   │  │ Active   │   │
   │  └──────────┘   │
   │  ┌──────────┐   │
   │  │Resources │   │
   │  │Allocated │   │
   │  └──────────┘   │
   └─────────────────┘
   ```
   - Process executing
   - Resources allocated
   - Network ready
   - Volumes mounted
   - Logs available

3. **Terminated State**
   ```
   ┌─────────────────┐
   │   Terminated    │
   │  ┌──────────┐   │
   │  │Exit Code │   │
   │  └──────────┘   │
   │  ┌──────────┐   │
   │  │Reason    │   │
   │  └──────────┘   │
   └─────────────────┘
   ```
   - Process completed
   - Resources released
   - Exit code available
   - Restart policy applies

## Health Monitoring

### Container Probes Overview
```
┌───────────────────────────────────────────────────────┐
│                   Container Probes                     │
│                                                       │
│  ┌────────────┐   ┌─────────────┐   ┌─────────────┐  │
│  │  Startup   │   │  Liveness   │   │ Readiness   │  │
│  │   Probe    │──►│   Probe     │──►│   Probe     │  │
│  └────────────┘   └─────────────┘   └─────────────┘  │
│        │                │                  │          │
│    Container      Application         Service         │
│     Started         Health            Traffic         │
└───────────────────────────────────────────────────────┘
```

### 1. Liveness Probe
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: liveness-demo
spec:
  containers:
  - name: app
    image: myapp:1.0
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
      initialDelaySeconds: 15  # Wait before first probe
      periodSeconds: 10        # Frequency of probe
      timeoutSeconds: 5        # Probe timeout
      failureThreshold: 3      # Failures before restart
```

**Liveness Probe Flow:**
```
┌─────────────┐    ┌──────────┐    ┌──────────┐
│  HTTP GET   │    │ Success  │    │Container │
│  /health   ├───►│ 200-399  ├───►│ Continues│
└─────────────┘    └──────────┘    └──────────┘
      │                                  ▲
      │           ┌──────────┐    ┌──────────┐
      └──────────►│  Fail    │    │Container │
                 │ 3 times   ├───►│ Restarts │
                 └──────────┘    └──────────┘
```

### 2. Readiness Probe
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: readiness-demo
spec:
  containers:
  - name: app
    image: myapp:1.0
    readinessProbe:
      tcpSocket:
        port: 8080      # Check if port is open
      initialDelaySeconds: 5
      periodSeconds: 10  # Check every 10 seconds
```

**Readiness Probe Flow:**
```
┌─────────────┐    ┌──────────┐    ┌──────────┐
│   TCP       │    │ Port     │    │ Add to   │
│  Check     ├───►│  Open    ├───►│ Service  │
└─────────────┘    └──────────┘    └──────────┘
      │                                  ▲
      │           ┌──────────┐    ┌──────────┐
      └──────────►│  Port    │    │Remove from│
                 │  Closed   ├───►│ Service  │
                 └──────────┘    └──────────┘
```

### 3. Startup Probe
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: startup-demo
spec:
  containers:
  - name: app
    image: myapp:1.0
    startupProbe:
      httpGet:
        path: /startup
        port: 8080
      failureThreshold: 30    # Allow up to 5 minutes (30 * 10s)
      periodSeconds: 10       # Check every 10 seconds
```

**Startup Probe Flow:**
```
┌─────────────┐    ┌──────────┐    ┌──────────┐
│  HTTP GET   │    │ Success  │    │Enable    │
│  /startup  ├───►│ 200-399  ├───►│Other     │
└─────────────┘    └──────────┘    │Probes    │
      │                            └──────────┘
      │           ┌──────────┐    ┌──────────┐
      └──────────►│  Fail    │    │Container │
                 │ 30 times  ├───►│ Fails    │
                 └──────────┘    └──────────┘
```

## Init Containers

### 1. Basic Init Container
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: init-demo
spec:
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup myservice; do echo waiting for myservice; sleep 2; done;']
  containers:
  - name: app
    image: myapp:1.0
```

### 2. Multiple Init Containers
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-init-demo
spec:
  initContainers:
  - name: init-db
    image: busybox:1.28
    command: ['sh', '-c', 'until nslookup mydb; do echo waiting for mydb; sleep 2; done;']
  - name: init-config
    image: busybox:1.28
    command: ['sh', '-c', 'wget http://config-service/config.json -O /config/config.json']
    volumeMounts:
    - name: config-volume
      mountPath: /config
  containers:
  - name: app
    image: myapp:1.0
    volumeMounts:
    - name: config-volume
      mountPath: /config
  volumes:
  - name: config-volume
    emptyDir: {}
```

## Practical Exercises

### 1. Probe Implementation
```batch
@REM Create pod with probes
kubectl apply -f probe-example.yaml

@REM Monitor probe status
kubectl describe pod probe-demo

@REM View probe failures
kubectl get events --field-selector involvedObject.name=probe-demo
```

### 2. Init Container Management
```batch
@REM Create pod with init containers
kubectl apply -f init-container-example.yaml

@REM Monitor init progress
kubectl get pod init-demo --watch

@REM View init container logs
kubectl logs init-demo -c init-myservice
```

### 3. Lifecycle Hooks
```batch
@REM Create pod with lifecycle hooks
kubectl apply -f lifecycle-hooks.yaml

@REM Monitor pod phases
kubectl get pod lifecycle-demo --watch

@REM View hook execution logs
kubectl logs lifecycle-demo
```

## Advanced Features

### 1. Custom Health Checks
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: custom-probe
spec:
  containers:
  - name: app
    image: myapp:1.0
    livenessProbe:
      exec:
        command:
        - /bin/sh
        - -c
        - ps aux | grep myprocess
```

### 2. Graceful Shutdown
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: graceful-shutdown
spec:
  containers:
  - name: app
    image: myapp:1.0
    lifecycle:
      preStop:
        exec:
          command: ["/bin/sh","-c","sleep 10"]
    terminationGracePeriodSeconds: 60
```

## Best Practices

1. **Probe Configuration**
   - Set appropriate timeouts
   - Configure failure thresholds
   - Use appropriate probe types
   - Implement meaningful health checks

2. **Init Container Usage**
   - Keep init containers light
   - Handle failures gracefully
   - Use appropriate timeouts
   - Monitor completion status

3. **Lifecycle Management**
   - Implement graceful shutdown
   - Handle termination signals
   - Clean up resources properly
   - Monitor pod phases

## Troubleshooting

### 1. Probe Issues
```batch
@REM Check probe configuration
kubectl describe pod <pod-name>

@REM View probe events
kubectl get events --field-selector involvedObject.name=<pod-name>

@REM Check container logs
kubectl logs <pod-name> -c <container-name>
```

### 2. Init Container Problems
```batch
@REM Check init container status
kubectl describe pod <pod-name>

@REM View init container logs
kubectl logs <pod-name> -c <init-container-name>

@REM Monitor pod events
kubectl get events --field-selector involvedObject.name=<pod-name>
```

## Additional Resources
- [Pod Lifecycle Documentation](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/)
- [Container Probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes)
- [Init Containers Guide](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

```bash
# Create pod with probes
kubectl apply -f probe-example.yaml

# Monitor probe status
kubectl describe pod probe-demo
```

### 3. Debugging Pod Lifecycle

```bash
# View pod status
kubectl get pod <pod-name> -o wide

# Get pod lifecycle events
kubectl describe pod <pod-name>

# View pod logs including init containers
kubectl logs <pod-name> -c <init-container-name>
```

## Practice Tasks

1. Create a pod with multiple init containers
2. Implement all three types of probes
3. Debug failing probes
4. Monitor pod lifecycle events

All example files are available in this directory for reference.
