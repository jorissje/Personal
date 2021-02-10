#Script for STRY0036937
#Author: Joris van der Helm
#Version: 0.1
#Date: 04-02-2021

[CmdletBinding()]

#region variables
#$cred = Get-Credential
$InputDnsServer = Get-Content E:\Joris\DnsInvestigationDC.txt
$InputAllServers = Get-Content E:\Joris\DnsInvestigationAll.txt
$TargetDC = hostname

#Creating arrays
$Result_ConditionalForwarders = @()
$Result_DnsServerForwarder = @()
$Result_DnsStaticAddresses = @() 
#endregion

#Gather DNS conditional forwarder information
Write-Host Gathering DNS conditional forwarders...
$ConditionalForwarders = Get-WmiObject -Namespace root\MicrosoftDNS -Class MicrosoftDNS_Zone -Filter "ZoneType = 4" -ComputerName $TargetDC | Select Name,
ContainerName,DsIntegrated,MasterServers,AllowUpdate

#region conditional forwarders
foreach ($forwarder in $ConditionalForwarders)
{
    $Result_ConditionalForwarders += [PSCustomObject]@{
        DnsCF_name             = $forwarder.Name
        DnsCF_ipaddress        = $forwarder.MasterServers
        DnsCF_domainintegrated = $forwarder.DsIntegrated
    }
    Write-Host "Conditional Forwarder details of [$($forwarder.Name)] gathered"
}
#endregion

#region external DNS servers
foreach ($DnsServer in $InputDnsServer)
{
    $DnsServerForwarder = Get-DnsServerForwarder -ComputerName $DnsServer

    $Result_DnsServerForwarder += [PSCustomObject]@{
        DnsForward_name        = $DnsServer
        DnsForward_IPaddresses = $DnsServerForwarder.IPAddress.IpAddressToString
    }
    Write-Host "DNS server forwarder IPs of [$($DnsServer)] gathered"
}
#endregion

#region static DNS addresses
foreach ($Server in $InputAllServers)
{
    $DnsStaticAddresses = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Server

    $Result_DnsStaticAddresses += [PSCustomObject]@{
        DnsStatic_name         = $DnsStaticAddresses.PSComputerName
        DnsStatic_IPaddress    = $DnsStaticAddresses.IPAddress
        DnsStatic_DnsServers   = $DnsStaticAddresses.DnsServerSearchOrder
    }
    Write-Host "Gathered static IP addresses from [$($server)]"
}
#endregion


$Result_ConditionalForwarders | Select-Object DnsCF_name,@{Expression={$_.DnsCF_ipaddress};Label="ip address";},DnsCF_domainintegrated | export-csv e:\joris\cf.csv
$Result_DnsServerForwarder | Select-Object DnsForward_name,@{Expression={$_.DnsForward_IPaddresses};Label="ip address";} | export-csv e:\joris\forwarder.csv
$Result_DnsStaticAddresses | Select-Object DnsStatic_name,@{Expression={$_.DnsStatic_IPaddress};Label="DNS ip address";},@{Expression={$_.DnsStatic_DnsServers};Label="DNS server";} | export-csv e:\joris\staticaddresses.csv
