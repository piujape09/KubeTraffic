<#
.SYNOPSIS
  One-shot deploy of the KubeTraffic demo.

.DESCRIPTION
  Applies all manifests via kustomize, waits for the Deployment to be ready,
  and prints handy follow-up commands for the live demo.
#>

[CmdletBinding()]
param(
    [string]$Namespace = "kubetraffic"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "==> Applying manifests with kustomize" -ForegroundColor Cyan
kubectl apply -k $root

Write-Host "==> Waiting for nginx-deployment to be available" -ForegroundColor Cyan
kubectl -n $Namespace rollout status deployment/nginx-deployment --timeout=120s

Write-Host ""
Write-Host "Cluster state:" -ForegroundColor Green
kubectl -n $Namespace get deploy,svc,hpa,ingress,netpol,sa

Write-Host ""
Write-Host "Next steps for the demo:" -ForegroundColor Yellow
Write-Host "  # 1. Generate load to trigger the HPA"
Write-Host "  kubectl apply -f $root\manifests\load-generator.yml"
Write-Host "  kubectl -n $Namespace get hpa nginx-hpa -w"
Write-Host ""
Write-Host "  # 2. Watch pods scale out"
Write-Host "  kubectl -n $Namespace get pods -w"
Write-Host ""
Write-Host "  # 3. Demonstrate self-healing"
Write-Host "  kubectl -n $Namespace delete pod -l app=nginx --wait=false"
Write-Host ""
Write-Host "  # 4. Tear everything down"
Write-Host "  pwsh $PSScriptRoot\cleanup.ps1"
