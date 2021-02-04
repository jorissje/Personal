#Script will reset the password expiry date and remove the 'Password never expire" option

#Input list
$usernames = Get-Content E:\Joris\users-passwordneverexpire.txt 

#Foreach loop
foreach ($user in $usernames)
{
$ADuser = Get-ADUser -Identity $user 

#Resetting the password expiry date
try {
Set-ADUser -identity $aduser -replace @{pwdlastset="0"} -ErrorAction stop
Set-ADUser -identity $aduser -replace @{pwdlastset="-1"} -ErrorAction stop


#Disabling the password never expire option
Set-ADUser -identity $aduser -PasswordNeverExpires:$FALSE
Write-Host "Resetted password expiry date and disabled 'never expire' for [$($ADuser.samaccountname)]"
    }
catch
{
Write-Host "FAILED to execute changes"
}
}