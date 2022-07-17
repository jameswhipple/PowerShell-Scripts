<#
TODO:
 -Add param for targeted server ping

#>

#worlds start at 300, but the dnsname starts at oldschool1.runescape.com 
function ping-osrs {
    for ($world = 1; $world -le 282; $world++) {
        $ms = @()
        $osrs = "oldschool$($world).runescape.com"
        $ms = (ping $osrs -n 1 | findstr "Min").Split(',')[0].Split('=')[1].Split('m')[0].trim()
        $actualWorld = $world + 300
        write-host "world: $($actualworld) | MS: $($ms)" -foregroundcolor "Green"
    }
}

ping-osrs