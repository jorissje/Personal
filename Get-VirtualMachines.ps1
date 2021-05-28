$Clusters = get-content "E:\Joris\allclusters.txt"
$Result_ClusterNodes = @()
$Result_VMs = @()

foreach ($cluster in $clusters)
{
$clusternode = get-clusternode -cluster $cluster

$Result_ClusterNodes += [PSCustomObject]@{
        cluster = $cluster
        clusternode = $clusternode
}

write-host " [$($cluster)] contains [$($clusternode)], added to result table"
}

foreach ($node in $Result_ClusterNodes.clusternode.name)
{
$vms = get-vm -computername $node | Where-Object {$_.State -eq 'Running'}
$Result_VMs += [PSCustomOBject]@{
        node = $node
        VM   = $vms.name
                                }
Write-Host "[$($node)] contains [$($vms.name), added to result table]
}
