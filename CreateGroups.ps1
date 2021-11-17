clear-host

function CreateAdminGroups {
<#
.Synopsis
    Script for creating Admin & Remote Desktop groups
.DESCRIPTION
    This script will create "Local Admin Users" or "Remote Desktop Users" groups for a specific computer
.EXAMPLE
    .\
.NOTES
    Author: Peter van Welt
    Version history:
        20-02-2019: Initial version
        23-07-2019: Added the "user" parameter to directly add user(s) to the newly created group

.TODO
    - If the AD-Group exists; AND the user parameter is specified; Verify if the user(s) needs to be added

#>

#Requires –Modules ActiveDirectory,Vopak.Powershell.Utility 
[CmdletBinding(SupportsShouldProcess=$true, 
                  ConfirmImpact='Medium')]
    Param
    (
        # Param1 Computername where the groups should be created for
        [Parameter(Mandatory=$true, 
                   Position=0)]
        [ValidateNotNullOrEmpty()]
        $Computername,

        # Param2 Create local administrators group
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [switch] $Administrator,

        # Param2 Create remote desktop users group
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [switch] $Remote,

        # Param3 Add Users directly to the new created group
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]] $User,

        # Param4 Add groups directly to the new created group
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String[]] $Group
    )

begin {
#region variables

$adminOU = "OU=Local Admin Users,OU=Global,OU=Domain Groups,DC=VOPAK,DC=com"
$remoteOU = "OU=Remote Desktop Users,OU=Global,OU=Domain Groups,DC=VOPAK,DC=com"

$adminDesc = "Local Admin Users"
$remoteDesc = "Remote Desktop Users"

Connect-VopakLog -echo # Log initialization
#endregion

}

process
{



    if ($Administrator)
    {
        $NewGroup = $adminDesc + " $computername"
        $NewOu = $adminOU
    }

    if ($Remote)
    {
        $NewGroup = $remoteDesc + " $computername"
        $NewOu = $remoteOU
    }

    write-verbose "[$($computername)] [$($user)] [$($administrator)] [$($remote)] >> [$($newgroup)]"



    # Verify if the adgroup already exists
    try {
        $AdGroup = Get-ADGroup -Identity $NewGroup -ErrorAction stop 
        Write-VopakLog "[$($NewGroup)] already exists- skip creating"
    }
    catch
    {
        Write-VopakScriptLog -Echo "[$($NewGroup)] not yet exists"
    }

    if (!$AdGroup)
    {
        Write-Verbose "Create [$NewGroup] in [$NewOu]" 
        
        try {
            New-ADGroup -Name $NewGroup -SamAccountName $NewGroup -Description $NewGroup -GroupScope "Global" -GroupCategory "Security" -Path $NewOu
            Write-VopakLog -Logtype Info -Message "Created ADgroup [$NewGroup] in OU [$NewOu]" -Echo
        }
        catch
        {
            Write-VopakLog -Logtype Error -Message "Failed creating ADgroup [$NewGroup] in OU [$NewOu] , ERROR= $($error[0].Exception.Message)" -Echo
        }

    }

    foreach ($u in $user)
    {
        try {
            $Aduser = Get-ADUser -Identity $u -ErrorAction stop
        }
        catch
        {
            Write-VopakScriptLog -Logtype Warning -Message "Aduser [$($u)] not exists, cannot be added to [$($NewGroup)]"

            continue
        }

        try {
            Add-ADGroupMember -Identity $NewGroup -Members $u -ErrorAction stop
            Write-VopakLog "added [$($u)] to [$($NewGroup)]" 
        }
        catch
        {
            Write-VopakScriptLog -Logtype Warning -Message "Adding user [$($u)] to [$($NewGroup)] FAILED , $($error[0].exception)"
        }
    }

    foreach ($g in $group)
    {
        try {
            $Group = Get-ADUser -Identity $g -ErrorAction stop
        }
        catch
        {
            Write-VopakScriptLog -Logtype Warning -Message "AdGroup [$($g)] not exists, cannot be added to [$($NewGroup)]"

            continue
        }

        try {
            Add-ADGroupMember -Identity $NewGroup -Members $g -ErrorAction stop
            Write-VopakLog "added [$($g)] to [$($NewGroup)]" 
        }
        catch
        {
            Write-VopakScriptLog -Logtype Warning -Message "Adding group [$($g)] to [$($NewGroup)] FAILED , $($error[0].exception)"
        }
    }
}
end
{
    Disconnect-VopakLog # Close logging
}






}



$inputfile = import-csv -path "F:\peterw\input.csv" -Delimiter ";"

foreach ($entry in $inputfile)
{

    CreateAdminGroups -Computername $entry.Computer -Administrator -User $entry.User

}
