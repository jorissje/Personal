$allgpo = (get-gpo -all -domain "domainname")
$gpo = ($allgpo | Where-Object displayname -match "xxxxx - ")

foreach ($gponame in $gpo)
{
Set-GPPermission -name $agenciesgponame.DisplayName -TargetName "xxxxxxxxxx" -TargetType Group -PermissionLevel GpoEditDeleteModifySecurity
}
