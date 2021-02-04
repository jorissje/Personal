Import-Module ActiveDirectory
$csv = Import-Csv E:\Joris\SingaporeUsers.csv
foreach ($line in $csv) {
    $username = $line.VopakUsername
    $email = $line.EmailAddress
    Get-ADUser -Filter {samaccountname -eq $username} | 
        Set-ADUser -EmailAddress $line.EmailAddress
}