#Bulk password generator for AD users
#Run as admin --> Syntax: ./bulkpass.ps1 "AD_Group_Name_Here" "Filepath_to_CSV_Output" "Length"
param($Group, $Csv, $length)
Import-Module ActiveDirectory

#Formats Group Users into CSV
Get-ADGroupMember $Group -recursive | Select-Object SamAccountName | Export-Csv -Path $Csv -NoTypeInformation;
$accts = Import-Csv -Path $Csv -Delimiter ',' -Encoding Default 
foreach($user in $accts) {
    $Pass=-join ("!@#$%^&*0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz".tochararray() | ForEach-Object {[char]$_} | Get-Random -Count $length)

    Add-Member -InputObject $user -MemberType NoteProperty -Name "Password" -Value $Pass
}
$accts | Export-Csv -Path $Csv -Delimiter ',' -NoTypeInformation;

#Passwords are changed based on CSV file
$bulkpass = Import-Csv $Csv
foreach($Users in $bulkpass) {
    Set-ADAccountPassword -Identity $Users.SamAccountName -Reset -NewPassword (ConvertTo-SecureString $Users.Password -AsPlainText -Force)
}

$ChangedPS = ($bulkpass).count
Write-Host $ChangedPS "passwords successfully changed"
