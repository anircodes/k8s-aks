## Windows-Specific Troubleshooting

### PowerShell Execution Policy
If you encounter script execution issues:
```powershell
# Check current execution policy
Get-ExecutionPolicy

# Set execution policy to allow scripts (run as Administrator)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Path Issues
If kubectl or az commands aren't found:
```powershell
# Add Azure CLI to PATH
$env:Path += ";C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin"

# Add kubectl to PATH
$env:Path += ";$env:USERPROFILE\.azure-kubectl"

# Make PATH changes permanent (run as Administrator)
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::User)
```

### Proxy Settings
If behind corporate proxy:
```powershell
# Set proxy for Azure CLI
$env:HTTPS_PROXY = "http://your-proxy:port"
$env:HTTP_PROXY = "http://your-proxy:port"

# Set proxy for kubectl
$env:NO_PROXY = "localhost,127.0.0.1,*.azure.com"
```

### Docker Desktop (Optional)
If you want to run containers locally:
1. Enable Windows Subsystem for Linux (WSL2):
```powershell
# Install WSL (run as Administrator)
wsl --install

# Restart your computer after installation
```

2. Install Docker Desktop:
   - Download from https://www.docker.com/products/docker-desktop
   - Enable WSL2 backend in Docker settings
   - Configure resources (CPU, Memory) as needed

### Common Issues

1. Certificate Issues
```powershell
# If you see certificate errors with kubectl
$env:CURL_CA_BUNDLE = ""
# or
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
```

2. Azure CLI Login Issues
```powershell
# Clear Azure CLI cache
rmdir /s /q "%USERPROFILE%\.azure"
az login
```

3. Windows Terminal Profile
```powershell
# Create custom profile for Kubernetes work
# Add to Windows Terminal settings.json:
{
    "guid": "{custom-guid}",
    "name": "Kubernetes Shell",
    "commandline": "pwsh.exe -NoExit -Command & {Import-Module Az.Aks}",
    "icon": "ms-appx:///ProfileIcons/{9acb9455-ca41-5af7-950f-6bca1bc9722f}.png"
}
```

4. VS Code Integration
```powershell
# Install Kubernetes extension
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

# Configure kubeconfig
$env:KUBECONFIG = "$HOME\.kube\config"
```
