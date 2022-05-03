
$size = @{
    Expression = { [math]::Round($_.Size/1gb) };
    Name = 'Size(GB)';
}

$free = @{
    Expression = { [math]::Round($_.Freespace/1gb) };
    Name = 'FreeSpace(GB)';
}

$percent_free = @{
    Expression = { [int]($_.Freespace*100 / $_.Size) };
    Name = 'Free(%)';    
}

$OS_drive = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID,$size,$free,$percent_free | Where-Object { $_.DeviceID -eq 'C:' }
$preSize = (Get-CimInstance -ClassName Win32_LogicalDisk -Property * | Where-Object { $_.DeviceID -eq 'C:' }).FreeSpace

$os_message = "{0} drive has {1}GB in totl available space, with {2}GB free. Free% is {3}%"`
    -f $OS_drive.DeviceID, $OS_drive.'Size(GB)', $OS_drive.'FreeSpace(GB)',$OS_drive.'Free(%)'




