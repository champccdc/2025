# Basic Initialization Script to run on a Windows AD box at the beginning of the competition
# - Enables Windows Defender, Windows Firewall, and Installes MalwareBytes AV 

## How to use:
# On a windows system run the following command in Admin PS to retrive files --> Then run the script
#
# Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/aidan01smith/Hivestorm-Repo/refs/heads/main/Windows/basic-init.ps1' -OutFile .\basic-init.ps1

# Ensures Windows Defender is installed
Set-MpPreference -DisableRealtimeMonitoring $false
Set-MpPreference -DisableIOAVProtection $false
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "Real-Time Protection" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Value 0 -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 0 -PropertyType DWORD -Force
start-service WinDefend
start-service WdNisSvc

# Run a Win Defender Scan
#Start-MpScan

# Installs Malware Bytes
Invoke-WebRequest -Uri 'https://downloads.malwarebytes.com/file/mb-windows?_gl=1*1uvwrxs*_gcl_au*MTQ2NTMwMjMzMi4xNzI5MDk1MDk4*_ga*MTg2MTY2MTg2OC4xNzI5MDk1MDk4*_ga_K8KCHE3KSC*MTcyOTA5NTA5OC4xLjEuMTcyOTA5NTEwOS40OS4wLjA.&_ga=2.231879703.96926975.1729095099-1861661868.1729095098' -OutFile C:\mbytes.exe
C:\mbytes.exe /VERYSILENT /NORESTART

## ^^ Install should now be availabe to use, remove trial subscription --> then run scan
