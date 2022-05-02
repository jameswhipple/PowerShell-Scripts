#If you often leave admin sessions on remote servers, here's a good way to clean them up
#Be sure to modify $servers so it contains a list of YOUR server fleet
$ErrorActionPreference = $stop
<#
    .Synopsis
        This script will query a given collection of servers for non-active sessions under a given username and then log them off
    
    .Description
        Using quser and logoff commands we target remote servers for non-aactive sessions under the provided username. If found, they are logged off
    
    .Notes
        TODO: 
          Add logging
          Add console output tracing so you can follow along i guess?
          More descriptive errors
#>

$servers = @( 'localhost' )
$username = 'yeet'
[int]$counter = 0

$servers | ForEach-Object {
    $counter ++
    [int32]$percentComplete  = [math]::floor( ($counter / $servers.count) * 100 )
    [string]$hostname = $($_)

    write-process -Activity "Nuking active sessions" -status "Checking.." -CurrentOperation $hostname -percentcomplete $percentComplete
    try{
        [string[]]$quserResp = quser $username /server:$hostname
    }
    catch{
        if($_.Exception -imatch "No User exists for ") {
            continue
        }
        write-error $_.Exception.Message
        continue
    }
 
    #Done checking now time for dukenukem
    foreach ( $session in $($quserResp | Select-Object -skip 1) ) {
        [string[]]$SessionSplitString = $session.Insert(22,",").Insert(42,",").Insert(56,",").Insert(68,",") -split ","
        [string]$sessionIDstring = $SessionSplitString[2].Trim()
        [string]$sessionState = $sessionIDstring[3].Trim()

        #ignore active sessions
        if($sessionState -ieq "Active") {
            continue
        }

        try{
            logoff /server:$hostname $sessionIDstring
        }
        catch{
            Write-Error $_.Exception.Message
            continue
        }
    }
}

Write-Progress -Activity "Duke Nukem" -Completed