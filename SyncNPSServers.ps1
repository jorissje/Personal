# Define date format
$date = get-date -Format yyyy_MM_dd

# Delete files older than 10 days
$limit = (Get-Date).AddDays(-10)
$backup_dir = "C:\NPS-Backup"

# Define all NPS slaves computers here,
$Computers = @('dc1.bidhankhatri.com.np','dc2.bidhankhatri.com.np')


# Export NPS Config
Export-NpsConfiguration -Path $backup_dir\archive\NPS_config_$date.xml
Export-NpsConfiguration -Path $backup_dir\NPS_config.xml


# Copy config to destination server
$Computers | Foreach-Object { Copy-Item -Path $backup_dir\NPS_config.xml -Destination \\$_\C$\NPS-Backup\NPS_config.xml }


# Import new config in destination server
$Computers | Foreach-Object { Invoke-Command -ComputerName $_ -ScriptBlock {Import-NPSConfiguration -Path C:\NPS-Backup\NPS_config.xml}}


# Delete files older than the $limit.
Get-ChildItem -Path $backup_dir\archive -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

Start-Sleep -Seconds 4
