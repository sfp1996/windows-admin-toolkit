# audit_users.ps1
# Audits local user accounts and exports a report to CSV.
# Author: Stephen Fawcett Palma

$ErrorActionPreference = "Stop"

# Output location
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ReportDir = Join-Path $ProjectRoot "reports"
New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutCsv = Join-Path $ReportDir "local_user_audit_$Timestamp.csv"

# Collect local users (works on Windows 10/11)
$users = Get-LocalUser | ForEach-Object {
    [PSCustomObject]@{
        Name                = $_.Name
        Enabled             = $_.Enabled
        Description         = $_.Description
        LastLogon           = $_.LastLogon
        PasswordRequired    = $_.PasswordRequired
        PasswordExpires     = $_.PasswordExpires
        PasswordLastSet     = $_.PasswordLastSet
        UserMayChangePassword = $_.UserMayChangePassword
        SID                 = $_.SID.Value
        RiskFlag            = $(if ($_.Enabled -and -not $_.PasswordRequired) { "Enabled_NoPasswordRequired" }
                               elseif ($_.Enabled -and -not $_.PasswordExpires) { "Enabled_PasswordNeverExpires" }
                               else { "" })
    }
}

# Export
$users | Sort-Object Name | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

Write-Host "Local user audit exported to:"
Write-Host "  $OutCsv"
Write-Host ""
Write-Host "Top findings (RiskFlag):"
$users | Where-Object { $_.RiskFlag -ne "" } | Group-Object RiskFlag | Sort-Object Count -Descending | ForEach-Object {
    Write-Host ("  {0} : {1}" -f $_.Name, $_.Count)
}
