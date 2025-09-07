# Mini-Project: Three-Tier Microservice Application

## Overview
This mini-project implements a three-tier microservice application with frontend, backend, and database components, complete with logging and monitoring.

## Components

1. Frontend: React application
2. Backend: Node.js API service
3. Database: MongoDB
4. Logging: Fluentbit + OpenTelemetry
5. Monitoring: Prometheus + Grafana

## Implementation Files

### Core Components
- [frontend.yaml](frontend.yaml) - Frontend deployment and service
- [backend.yaml](backend.yaml) - Backend deployment and service
- [mongodb.yaml](mongodb.yaml) - MongoDB statefulset and service

### Configuration
- [config.yaml](config.yaml) - ConfigMaps for application configuration
- [secrets.yaml](secrets.yaml) - Secrets for sensitive data

### Monitoring & Logging
- [monitoring.yaml](monitoring.yaml) - Prometheus and Grafana setup
- [logging.yaml](logging.yaml) - Fluentbit and OpenTelemetry configuration

## Deployment Steps

1. Create Namespace
```bash
kubectl create namespace three-tier-app
```

2. Deploy Infrastructure
```bash
# Deploy MongoDB
kubectl apply -f mongodb.yaml

# Deploy ConfigMaps and Secrets
kubectl apply -f config.yaml
kubectl apply -f secrets.yaml
```

3. Deploy Applications
```bash
# Deploy Backend
kubectl apply -f backend.yaml

# Deploy Frontend
kubectl apply -f frontend.yaml
```

4. Deploy Monitoring & Logging
```bash
# Deploy monitoring stack
kubectl apply -f monitoring.yaml

# Deploy logging stack
kubectl apply -f logging.yaml
```

## Verification Steps

1. Check Deployments
```bash
kubectl get deployments -n three-tier-app
```

2. Verify Services
```bash
kubectl get services -n three-tier-app
```

3. Access Application
```bash
# Get frontend service URL
kubectl get svc frontend-service -n three-tier-app
```

4. Monitor Logs
```bash
# View application logs
kubectl logs -f deployment/backend -n three-tier-app
```

## Project Extensions

1. Add authentication
2. Implement caching layer
3. Add CI/CD pipeline
4. Implement auto-scaling

All configuration files are available in this directory.
