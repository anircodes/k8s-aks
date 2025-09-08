# Helm Hands-on Workshop

## Exercise 1: Creating Your First Chart

```batch
@REM Initialize new chart
helm create first-app

@REM Explore chart structure
dir first-app /s

@REM Modify values.yaml
@REM Update image, service type, and add custom values
```

## Exercise 2: Chart Dependencies

```batch
@REM Add dependency to Chart.yaml
echo dependencies: >> first-app/Chart.yaml
echo   - name: mongodb >> first-app/Chart.yaml
echo     version: 12.1.16 >> first-app/Chart.yaml
echo     repository: https://charts.bitnami.com/bitnami >> first-app/Chart.yaml

@REM Update dependencies
helm dependency update first-app

@REM Verify dependencies
helm dependency list first-app
```

## Exercise 3: Custom Templates

Create these files in the templates directory:

### configmap.yaml
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-config
data:
  database_url: {{ .Values.config.databaseUrl }}
  api_key: {{ .Values.config.apiKey }}
```

### secret.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Release.Name }}-secret
type: Opaque
data:
  username: {{ .Values.secrets.username | b64enc }}
  password: {{ .Values.secrets.password | b64enc }}
```

## Exercise 4: Template Functions and Pipelines

### helpers.tpl
```yaml
{{- define "first-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
```

## Exercise 5: Chart Installation and Testing

```batch
@REM Lint the chart
helm lint first-app

@REM Perform dry run
helm install --dry-run --debug my-release first-app

@REM Install chart
helm install my-release first-app --values production-values.yaml

@REM Verify installation
helm list
kubectl get all -l app.kubernetes.io/instance=my-release
```

## Exercise 6: Creating a Production-Ready Chart

### Production values (production-values.yaml)
```yaml
replicaCount: 3

image:
  repository: myregistry.azurecr.io/myapp
  tag: v1.0.0
  pullPolicy: IfNotPresent

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

ingress:
  enabled: true
  className: nginx
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: myapp-tls
      hosts:
        - myapp.example.com

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

## Exercise 7: Chart Upgrades and Rollbacks

```batch
@REM Upgrade release
helm upgrade my-release first-app --values new-values.yaml

@REM View history
helm history my-release

@REM Rollback to previous version
helm rollback my-release 1

@REM Verify rollback
helm status my-release
```

## Exercise 8: Package and Repository Management

```batch
@REM Package chart
helm package first-app

@REM Create chart repository
mkdir my-repo
mv first-app-0.1.0.tgz my-repo/

@REM Generate repository index
helm repo index my-repo/

@REM Add repository
helm repo add my-repo https://my-chart-repo.example.com

@REM Update repositories
helm repo update
```

## Exercise 9: Advanced Features

### Subcharts
```batch
@REM Create subchart
helm create first-app/charts/subchart

@REM Modify subchart values
echo subchart: >> first-app/values.yaml
echo   enabled: true >> first-app/values.yaml
```

### Chart Hooks
Create pre-install and post-install hooks:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-pre-install-job
  annotations:
    "helm.sh/hook": pre-install
spec:
  template:
    spec:
      containers:
        - name: pre-install-job
          image: busybox
          command: ['sh', '-c', 'echo Pre-install job']
      restartPolicy: Never
```

## Exercise 10: Real-world Application

Create a complete application with:
- Frontend deployment
- Backend API
- Database
- Redis cache
- Ingress configuration
- Monitoring
- Logging

### Directory Structure
```
complete-app/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── frontend/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── ingress.yaml
│   ├── backend/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── configmap.yaml
│   ├── database/
│   │   ├── statefulset.yaml
│   │   ├── service.yaml
│   │   └── pvc.yaml
│   └── monitoring/
│       ├── servicemonitor.yaml
│       └── prometheusrule.yaml
└── charts/
    ├── redis/
    └── prometheus/
```

## Best Practices Exercise

1. **Security**
   - Implement RBAC
   - Set resource limits
   - Use network policies
   - Secure secrets

2. **Maintainability**
   - Use labels consistently
   - Document all values
   - Create meaningful tests
   - Use CI/CD pipelines

3. **Scalability**
   - Implement HPA
   - Use PDBs
   - Configure readiness/liveness probes
   - Set up monitoring

## Cleanup

```batch
@REM Uninstall release
helm uninstall my-release

@REM Remove repositories
helm repo remove my-repo

@REM Clean up local files
rd /s /q first-app
rd /s /q my-repo
```
