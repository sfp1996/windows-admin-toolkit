# run_all.ps1
# Runs all Windows Admin Toolkit checks
# Author: Stephen Fawcett Palma

$ErrorActionPreference = "Stop"

Write-Host "=== Windows Admin Toolkit ==="
Write-Host "Run started at $(Get-Date)"
Write-Host ""

$ScriptRoot = $PSScriptRoot

$scripts = @(
    "audit_users.ps1",
    "system_health.ps1"
)

foreach ($script in $scripts) {
    $path = Join-Path $ScriptRoot $script
    if (Test-Path $path) {
        Write-Host "Running $script..."
        powershell -ExecutionPolicy Bypass -File $path
        Write-Host ""
    } else {
        Write-Warning "Missing script: $script"
    }
}

Write-Host "All checks completed."
