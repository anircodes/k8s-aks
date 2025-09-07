# Custom Helm Charts

## Overview
This module covers creating custom Helm charts for packaging Kubernetes applications, including best practices and advanced features.

## Key Concepts

### Chart Components
- Templates with Go templating
- Value overrides
- Dependencies
- Hooks
- Tests

### Best Practices
- Chart versioning
- Documentation
- Dependencies management
- Testing

## Practical Exercises

### 1. Creating Custom Charts

See [example-webapp-chart](example-webapp-chart) for complete implementation.

```bash
# Create new chart
helm create example-webapp

# Test chart
helm lint example-webapp
helm template example-webapp

# Package chart
helm package example-webapp
```

### 2. Chart Dependencies

See dependencies section in [Chart.yaml](example-webapp-chart/Chart.yaml).

```bash
# Update dependencies
helm dependency update example-webapp

# List dependencies
helm dependency list example-webapp
```

### 3. Testing Charts

See [tests](example-webapp-chart/templates/tests) directory.

```bash
# Run chart tests
helm test my-release
```

## Practice Tasks

1. Create multi-tier application chart
2. Implement chart hooks
3. Write chart tests
4. Configure chart dependencies

All example files and charts are available in this directory.
