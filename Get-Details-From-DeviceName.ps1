#Author: Joris van der Helm
#Date: 11-05-2022
#Description: This script can be used to generate an array of user, displayname and email address by quering on devicename
#Version: 1.0

#Changelog
#1.0 - Initial script

#PREREQS: Must be run from the SCCM primary site due to SCCM module dependencies

CD CWP:
#CSV input file location
$csvlocation = "C:\Users\cimanhelmj\Desktop\PendingReboot.csv"
$csv = Import-Csv $csvlocation

#Creating empty array
$results = @()

foreach ($device in $csv)
{
$computerdetails = get-CMUserDeviceAffinity -devicename $device.devices
$username = $computerdetails.UniqueUserName.ToLower().Replace('cicwp\','')
$userdetails = get-aduser -Identity $username -properties DisplayName
Write-Host "'$($device.devices)', met username '$($userdetails.SamAccountName)', heeft de volledige naam '$($userdetails.DisplayName)' en het emailadres '$($userdetails.UserPrincipalName)', adding results to table"
$results += New-Object psobject -Property @{
            Device = $device.Devices
            Username = $username
            DisplayName = $userdetails.DisplayName
            EmailAddress = $userdetails.UserPrincipalName
            }
}
