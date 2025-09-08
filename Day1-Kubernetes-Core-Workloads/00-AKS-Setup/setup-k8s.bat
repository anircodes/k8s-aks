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
