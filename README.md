# Windows Admin Toolkit

A Windows-only administration and monitoring toolkit built with PowerShell.
Designed to automate common IT tasks such as user audits, system health checks,
and scheduled reporting.

## Features
- Local user account auditing with security risk flags
- System health monitoring (disk, uptime, memory, CPU)
- Automated report generation (CSV)
- Central runner script for one-command execution
- Scheduled automation via Windows Task Scheduler

## Project Structure
windows-admin-toolkit/
├── scripts/
│ ├── audit_users.ps1
│ ├── system_health.ps1
│ └── run_all.ps1
├── reports/
├── docs/
│ ├── run_all_output.png
│ ├── task_scheduler.png
│ └── report_example.png
└── README.md

## Usage

Run all checks manually:
```powershell
cd scripts
powershell -ExecutionPolicy Bypass -File .\run_all.ps1

Automation

The toolkit is designed to run automatically using Windows Task Scheduler.
A batch launcher (run_all.bat) executes all checks daily and stores the latest
output in the reports directory.

Skills Demonstrated

PowerShell scripting
Windows system administration
Security auditing
Task Scheduler automation
Structured reporting
Documentation for operational tools

Author
Stephen Fawcett Palma