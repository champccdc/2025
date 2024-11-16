# Script used to Download sysinternals, Firewall rules, and nmap

# How To Use - Run the commands below on a Win System:
# Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/champccdc/2025/refs/heads/main/windows/Install_Tools.ps1' -OutFile .\Install_Tools.ps1
# .\Install_Tools.ps1

# Downloading Sysinternals Suite
Invoke-WebRequest 'https://download.sysinternals.com/files/SysinternalsSuite.zip' -OutFile .\

# Downloading Firewall Script
Invoke-WebRequest 'https://raw.githubusercontent.com/champccdc/2025/refs/heads/main/windows/hehe.ps1' -OutFile .\hehe.ps1

# Downloading + Installing Nmap
Invoke-WebRequest 'https://nmap.org/dist/nmap-7.95-setup.exe' -OutFile .\'nmap-7.95-setup.exe'
