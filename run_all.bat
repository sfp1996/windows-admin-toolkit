@echo off
cd /d C:\projects\windows-admin-toolkit\scripts
powershell -ExecutionPolicy Bypass -File .\run_all.ps1 > ..\reports\latest_run.txt 2>&1
