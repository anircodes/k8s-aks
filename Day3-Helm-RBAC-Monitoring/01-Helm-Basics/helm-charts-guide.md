# Creating Custom Helm Charts for Workloads

## 1. Basic Chart Structure
```
mychart/
  Chart.yaml          # Chart metadata
  values.yaml         # Default values
  templates/          # Template files
    deployment.yaml   # Kubernetes manifests
    service.yaml
    ingress.yaml
  charts/            # Dependencies
  .helmignore        # Ignore patterns
```

## 2. Creating a New Chart

```batch
@REM Create new chart
helm create mychart

@REM Package chart
helm package mychart

@REM Install chart
helm install release-name ./mychart
```

## 3. Chart Components

### Chart.yaml
```yaml
apiVersion: v2
name: my-application
description: A Helm chart for my application
type: application
version: 0.1.0
appVersion: "1.0.0"
dependencies:
  - name: mongodb
    version: 12.1.16
    repository: https://charts.bitnami.com/bitnami
```

### values.yaml
```yaml
# Application configuration
image:
  repository: myregistry.azurecr.io/myapp
  tag: latest
  pullPolicy: IfNotPresent

replicaCount: 3

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

# Environment variables
env:
  - name: DATABASE_URL
    valueFrom:
      secretKeyRef:
        name: app-secrets
        key: database-url
```

## 4. Template Files

### deployment.yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "mychart.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "mychart.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.service.port }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
          env:
            {{- toYaml .Values.env | nindent 12 }}
```

### service.yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "mychart.selectorLabels" . | nindent 4 }}
```

## 5. Helper Functions (_helpers.tpl)
```yaml
{{/*
Expand the name of the chart.
*/}}
{{- define "mychart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mychart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mychart.labels" -}}
helm.sh/chart: {{ include "mychart.chart" . }}
{{ include "mychart.selectorLabels" . }}
{{- end }}
```

## 6. Testing Your Chart

```batch
@REM Lint the chart
helm lint mychart

@REM Test template rendering
helm template mychart

@REM Dry run
helm install --dry-run --debug myrelease ./mychart

@REM Run tests
helm test myrelease
```

## 7. Version Management

```batch
@REM Update dependencies
helm dependency update mychart

@REM Package chart
helm package mychart --version 1.0.0

@REM Push to registry
helm push mychart-1.0.0.tgz oci://myregistry.azurecr.io/helm
```

## 8. Best Practices

### Chart Design
1. Use clear naming conventions
2. Implement proper validation
3. Document all values
4. Use helper functions

### Configuration
1. Set appropriate defaults
2. Use conditional logic
3. Implement proper validation
4. Handle dependencies

### Security
1. Use RBAC
2. Implement network policies
3. Handle secrets properly
4. Set resource limits

### Testing
1. Write test cases
2. Use CI/CD pipeline
3. Implement validation hooks
4. Document test procedures

## 9. Example: Complete Application Chart

### Project Structure
```
myapp/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── configmap.yaml
│   ├── secrets.yaml
│   ├── serviceaccount.yaml
│   └── tests/
│       └── test-connection.yaml
└── charts/
    └── mongodb/
```

### Installation Commands
```batch
@REM Add dependencies
helm repo add bitnami https://charts.bitnami.com/bitnami

@REM Update dependencies
helm dependency update myapp

@REM Install with custom values
helm install myrelease myapp ^
    --set image.tag=v1.0.0 ^
    --set replicaCount=3 ^
    --values production-values.yaml
```
