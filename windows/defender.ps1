# File to check defender exclusions and run a scan
#Requires -RunAsAdministrator
Write-Host "Excluded paths:" $(Get-MpPreference | Select-Object -expand ExclusionPath)
Write-Host ""
Write-Host "Excluded extensions:" $(Get-MpPreference | Select-Object -expand ExclusionExtension)
Write-Host ""
Write-Host "Excluded IPs:" $(Get-MpPreference | Select-Object -expand ExclusionIpAddress)
Write-Host ""
Write-Host "Excluded processes:" $(Get-MpPreference | Select-Object -expand ExclusionProcess)

$userResponse = Read-Host -Prompt "Do you want to start a quick scan? [y/N]"

if($userResponse.ToLower() -eq "y"){
    Start-MpScan -ScanType QuickScan -AsJob
}
else {
    Write-Host "No scan started"
}