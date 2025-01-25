# Script used to Download sysinternals, Firewall rules, and nmap

# How To Use - Run the commands below on a Win System:
# Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/champccdc/2025/refs/heads/main/windows/Install_Tools.ps1' -OutFile .\Install_Tools.ps1
# .\Install_Tools.ps1

# Downloading Firewall Script
Invoke-WebRequest 'https://raw.githubusercontent.com/champccdc/2025/refs/heads/main/windows/hehe.ps1' -OutFile .\hehe.ps1

# Downloading + Installing Nmap
Invoke-WebRequest 'https://nmap.org/dist/nmap-7.95-setup.exe' -OutFile .\'nmap-7.95-setup.exe'

# Download Browser
Invoke-WebRequest 'https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US&attribution_code=c291cmNlPXd3dy5nb29nbGUuY29tJm1lZGl1bT1yZWZlcnJhbCZjYW1wYWlnbj0obm90IHNldCkmY29udGVudD0obm90IHNldCkmZXhwZXJpbWVudD0obm90IHNldCkmdmFyaWF0aW9uPShub3Qgc2V0KSZ1YT1jaHJvbWUmY2xpZW50X2lkX2dhND0obm90IHNldCkmc2Vzc2lvbl9pZD0obm90IHNldCkmZGxzb3VyY2U9bW96b3Jn&attribution_sig=c629f49b91d2fa3e54e7b9ae8d92a74866b3980356bf1a5b70c0bca69812620b' -OutFile .\'Firefox Install.exe'

# Acct Stuff
Invoke-WebRequest 'https://raw.githubusercontent.com/champccdc/2025/refs/heads/main/windows/Acct_Check.ps1' -OutFile .\Acct_Check.ps1

# Downloading Sysinternals Suite
Invoke-WebRequest 'https://download.sysinternals.com/files/SysinternalsSuite.zip' -OutFile .\SysSuite.zip
