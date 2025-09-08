## Windows-Specific Troubleshooting

### Command Prompt Administration
If you need to run commands as administrator:
1. Right-click on Command Prompt
2. Select "Run as administrator"

### Path Issues
If kubectl or az commands aren't found:
```batch
@REM Add Azure CLI to PATH (run in administrator command prompt)
setx path "%path%;C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin"

@REM Add kubectl to PATH
setx path "%path%;%USERPROFILE%\.azure-kubectl"

@REM Verify the path was added
echo %path%
```

### Proxy Settings
If behind corporate proxy:
```batch
@REM Set proxy for Azure CLI
set HTTPS_PROXY=http://your-proxy:port
set HTTP_PROXY=http://your-proxy:port

@REM Set proxy for kubectl
set NO_PROXY=localhost,127.0.0.1,*.azure.com
```

### Docker Desktop (Optional)
If you want to run containers locally:
1. Enable Windows Subsystem for Linux (WSL2):
```batch
@REM Install WSL (run as Administrator)
wsl --install

@REM Restart your computer after installation
shutdown /r /t 0
```

2. Install Docker Desktop:
   - Download from https://www.docker.com/products/docker-desktop
   - Enable WSL2 backend in Docker settings
   - Configure resources (CPU, Memory) as needed

### Common Issues

1. Certificate Issues
```batch
@REM If you see certificate errors with kubectl
set CURL_CA_BUNDLE=
```

2. Azure CLI Login Issues
```batch
@REM Clear Azure CLI cache (run as administrator)
rmdir /s /q "%USERPROFILE%\.azure"
az login
```

3. VS Code Integration
```batch
@REM Install Kubernetes extension
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

@REM Configure kubeconfig
set KUBECONFIG=%USERPROFILE%\.kube\config
```

### Environment Setup Script
Save this as `setup-k8s.bat`:
```batch
@echo off
@REM Add required paths
setx path "%path%;C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;%USERPROFILE%\.azure-kubectl"

@REM Set development environment variables
set KUBECONFIG=%USERPROFILE%\.kube\config

@REM Install required VS Code extensions
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
code --install-extension ms-azuretools.vscode-azurerm-tools

@REM Verify installations
az --version
kubectl version --client

echo Setup completed. Please restart your terminal.
```
