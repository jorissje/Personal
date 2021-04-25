$serverinput = get-content "E:\Joris\svcserverinput.txt"
$servicename = "okta-radius"


foreach ($server in $serverinput) 

{

try {
get-service -name $servicename -computername $server -ErrorAction stop | start-service -ErrorAction stop
write-host Service [$($servicename)] started on [$($server)]
}  
catch
{
write-host Service [$($servicename)] failed to start on [$($server)]
}

}
