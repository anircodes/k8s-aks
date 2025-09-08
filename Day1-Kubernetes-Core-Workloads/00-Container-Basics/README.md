# Container Basics

## Introduction to Containers
This module covers the fundamentals of containers, their architecture, and basic operations. Understanding containers is crucial before diving into Kubernetes.

## Prerequisites
- Docker Desktop installed on Windows
- WSL2 enabled
- Command Prompt or Windows Terminal

## What are Containers?
Containers are lightweight, standalone packages that include everything needed to run a piece of software:
- Application code
- Runtime environment
- System tools
- System libraries
- Settings

### Key Concepts
1. Container vs Virtual Machine
   - Containers share the host OS kernel
   - VMs include a full copy of an OS
   - Containers start in seconds, VMs take minutes
   - Containers use less resources

2. Container Images
   - Read-only templates
   - Contains application code and dependencies
   - Basis for containers
   - Layered architecture

3. Container Registry
   - Stores container images
   - Public (Docker Hub) or Private (Azure Container Registry)
   - Version control for images

## Practical Exercises

### 1. Basic Docker Commands
```batch
@REM Check Docker installation
docker --version

@REM List running containers
docker ps

@REM List all containers (including stopped)
docker ps -a

@REM List downloaded images
docker images
```

### 2. Running Your First Container
```batch
@REM Run a basic nginx web server
docker run -d -p 8080:80 --name my-nginx nginx

@REM Check if it's running
docker ps

@REM View container logs
docker logs my-nginx

@REM Stop the container
docker stop my-nginx

@REM Remove the container
docker rm my-nginx
```

### 3. Building a Custom Container
Create a file named `Dockerfile`:
```dockerfile
FROM nginx:latest
COPY ./index.html /usr/share/nginx/html/
EXPOSE 80
```

Create a simple `index.html`:
```html
<!DOCTYPE html>
<html>
<head>
    <title>My Container</title>
</head>
<body>
    <h1>Hello from my custom container!</h1>
</body>
</html>
```

Build and run:
```batch
@REM Build the image
docker build -t my-custom-nginx .

@REM Run the container
docker run -d -p 8080:80 my-custom-nginx

@REM Test in browser: http://localhost:8080
```

### 4. Container Networking
```batch
@REM Create a network
docker network create my-network

@REM Run containers in the network
docker run -d --name container1 --network my-network nginx
docker run -d --name container2 --network my-network nginx

@REM Inspect network
docker network inspect my-network
```

### 5. Data Persistence
```batch
@REM Create a volume
docker volume create my-data

@REM Run container with volume
docker run -d -v my-data:/data --name data-container nginx

@REM Inspect volume
docker volume inspect my-data
```

## Best Practices
1. Image Management
   - Use specific tags instead of `latest`
   - Keep base images updated
   - Use multi-stage builds
   - Minimize layer size

2. Security
   - Don't run as root
   - Scan images for vulnerabilities
   - Use minimal base images
   - Keep images up to date

3. Resource Management
   - Set memory limits
   - Monitor container health
   - Clean up unused containers/images
   - Use resource quotas

## Common Issues and Troubleshooting

### 1. Container Won't Start
```batch
@REM Check container logs
docker logs <container-id>

@REM Inspect container
docker inspect <container-id>
```

### 2. Disk Space Issues
```batch
@REM Clean up unused resources
docker system prune -a

@REM Check disk usage
docker system df
```

### 3. Network Connectivity
```batch
@REM Check network list
docker network ls

@REM Inspect network
docker network inspect bridge
```

## Next Steps
- Learn about container orchestration (Kubernetes)
- Explore container registries
- Study container security
- Practice building multi-container applications
