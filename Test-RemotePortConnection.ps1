#Script will check connectivity of the given ports
#prereqs
$credentials = get-credential

#Input list
$servers = Get-Content e:\Joris\serverlist.txt 
$target = "IEAWS1S167"
$ports = "1688"

#Foreach loop
foreach ($source in $servers)

{
#Checking port connectivity

$test = Invoke-Command -ComputerName $source -credential $credentials -scriptblock {Test-NetConnection -computername $using:target -port $using:ports -WarningAction SilentlyContinue}

if($test.TcpTestSucceeded -eq "True"){
Write-Host "[$($source)] : port [$($ports)] is OPEN towards [$($target)]"
}

else {
Write-Host "[$($source)] : port [$($ports)] is CLOSED towards [$($target)]"
}
}

