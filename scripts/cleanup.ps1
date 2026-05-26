<#
.SYNOPSIS
  Removes everything the demo created.
#>

[CmdletBinding()]
param(
    [string]$Namespace = "kubetraffic"
)

$ErrorActionPreference = "Continue"
$root = Split-Path -Parent $PSScriptRoot

Write-Host "==> Deleting load-generator Job (if present)" -ForegroundColor Cyan
kubectl -n $Namespace delete job load-generator --ignore-not-found

Write-Host "==> Deleting all resources via kustomize" -ForegroundColor Cyan
kubectl delete -k $root --ignore-not-found

Write-Host "==> Done." -ForegroundColor Green
