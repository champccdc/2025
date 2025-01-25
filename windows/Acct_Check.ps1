# Script used to check settings for AD User Accounts
# Should be run as admin
Import-Module ActiveDirectory

# Flags All users that are not user ker per-auth
$flagUsers = (Get-ADUser -Filter 'useraccountcontrol -band 4194304' -Properties useraccountcontrol).SamAccountName
ForEach ($entry in $flagUsers) {
  Write-Host "Check Kerb perms on user $entry"
}

# Gets all AD User Accounts
$userSearch = Get-ADUser -Filter *

# Verify Account Settings
ForEach ($user in $userSearch.SamAccountName) {
  Set-ADAccountControl -Identity "$user" -AllowReversiblePasswordEncryption $false
  Set-ADAccountControl -Identity "$user" -DoesNotRequirePreAuth $false
}
