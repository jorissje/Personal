$users = Get-ADUser -ldapfilter “(objectclass=user)” -searchbase “fill in distinguished names”
ForEach($user in $users)
{
    # Binding the users to DS
    $ou = [ADSI](“LDAP://” + $user)
    $sec = $ou.psbase.objectSecurity
 
    if ($sec.get_AreAccessRulesProtected())
    {
        $isProtected = $false ## allows inheritance
        $preserveInheritance = $true ## preserver inhreited rules
        $sec.SetAccessRuleProtection($isProtected, $preserveInheritance)
        $ou.psbase.commitchanges()
        Write-Host “$user is now inheriting permissions”;
    }
    else
    {
        Write-Host “$User Inheritable Permission already set”
    }
}
