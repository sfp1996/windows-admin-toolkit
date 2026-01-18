# system_health.ps1
# Collects basic system health metrics and exports to CSV
# Author: Stephen Fawcett Palma

$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$ReportDir = Join-Path $ProjectRoot "reports"
New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null

$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$OutCsv = Join-Path $ReportDir "system_health_$Timestamp.csv"

# Uptime
$os = Get-CimInstance Win32_OperatingSystem
$uptime = (Get-Date) - $os.LastBootUpTime

# Disk
$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    [PSCustomObject]@{
        Drive       = $_.DeviceID
        SizeGB      = [math]::Round($_.Size / 1GB, 2)
        FreeGB      = [math]::Round($_.FreeSpace / 1GB, 2)
        FreePercent = [math]::Round(($_.FreeSpace / $_.Size) * 100, 1)
        LowSpace    = $(if (($_.FreeSpace / $_.Size) * 100 -lt 15) { "YES" } else { "NO" })
    }
}

# Memory
$mem = Get-CimInstance Win32_OperatingSystem
$memUsedPct = [math]::Round((($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory) / $mem.TotalVisibleMemorySize) * 100, 1)

# CPU (simple snapshot)
$cpu = Get-CimInstance Win32_Processor | Measure-Object LoadPercentage -Average

$summary = [PSCustomObject]@{
    ComputerName = $env:COMPUTERNAME
    UptimeDays   = [math]::Round($uptime.TotalDays, 2)
    MemoryUsedPercent = $memUsedPct
    AvgCpuLoadPercent = $cpu.Average
}

# Export
$summary | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8

Write-Host "System health report exported to:"
Write-Host "  $OutCsv"
Write-Host ""
Write-Host "Disk summary:"
$disks | Format-Table -AutoSize
