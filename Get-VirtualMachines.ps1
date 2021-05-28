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

write-host " Cluster [$($cluster)] contains the following nodes [$($clusternode)], they have been added to result table"
}

foreach ($node in $Result_ClusterNodes)
{
$vms = get-vm -computername $node.clusternode | Where-Object {$_.State -eq 'Running'}
$Result_VMs += [PSCustomObject]@{
        cluster = $node.cluster
        node = $node.clusternode
        VM   = $vms.name -join ","
                                }
Write-Host "Node [$($node.clusternode)] in cluster [$($node.cluster)] contains VM's [$($vms.name), they have been added to result table]"
}

foreach ($result in $Result_VMs){
$result_vms | Export-CSV -path "exportvms.csv" -NoTypeInformation
                                }
