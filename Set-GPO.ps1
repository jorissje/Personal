$allgpo = (get-gpo -all -domain "vopak.com")
$agenciesgpo = ($allgpo | Where-Object displayname -match "ASPAC VN - ")

foreach ($agenciesgponame in $agenciesgpo)
{
Set-GPPermission -name $agenciesgponame.DisplayName -TargetName "VNDNA LCC GPO Admins" -TargetType Group -PermissionLevel GpoEditDeleteModifySecurity
}
