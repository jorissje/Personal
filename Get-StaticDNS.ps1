$Result_Adapters = @()
$VLDservers = Get-ADComputer -Filter {name -like 'nl*'}
foreach ($server in $VLDservers)
{
$adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName $Server.DNSHostName

$Result_Adapters += [PSCustomObject]@{
    ServerName = $server.Name
    IpAddress = [string]$adapters.IPAddress
    DnsServers = [string]$adapters.dnsserversearchorder
    }
}
