# Helm Basics

## Overview
This module introduces Helm, the package manager for Kubernetes, covering basic concepts and usage patterns.

## Key Concepts

### Helm Components
- Charts
- Values
- Templates
- Releases

### Chart Structure
```
mychart/
  Chart.yaml
  values.yaml
  templates/
  charts/
  README.md
```

## Practical Exercises

### 1. Helm Installation and Setup

```bash
# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Add repositories
helm repo add stable https://charts.helm.sh/stable
helm repo update
```

### 2. Working with Helm Charts

See [basic-chart-example](basic-chart-example) for implementation.

```bash
# Create new chart
helm create my-first-chart

# Package chart
helm package my-first-chart

# Install chart
helm install my-release my-first-chart
```

### 3. Chart Management

```bash
# List releases
helm list

# Upgrade release
helm upgrade my-release my-first-chart --values new-values.yaml

# Rollback release
helm rollback my-release 1
```

## Practice Tasks

1. Create basic Helm chart
2. Customize chart values
3. Package and deploy chart
4. Manage chart lifecycle

All example files and charts are available in this directory.
