# File to download autoruns to the desktop
$downloadLocation = "$env:USERPROFILE\Downloads\Autoruns.zip"
$finalLocation = "$env:USERPROFILE\Desktop\Autoruns"
# Download autoruns to downloads folder
(New-Object System.Net.WebClient).DownloadFile('https://download.sysinternals.com/files/Autoruns.zip',$downloadLocation)
# Fast extract it
Add-Type -Assembly "System.IO.Compression.Filesystem"
[System.IO.Compression.ZipFile]::ExtractToDirectory($downloadLocation,$finalLocation)