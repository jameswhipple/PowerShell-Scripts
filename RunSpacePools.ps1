<#
    .Description
        As an exercise for learning runspaces/runspace pools this script will conduct a ping sweep against all osrs servers
        by breaking out each server ping task into a separate runspace(thread) which will be managed by a runspace pool

    .Notes
        Runspaces attach a new thread to the existing shell process. 
        This differs from jobs where jobs spawn new processes per job 
        which is resource intensive

        Runspaces don't start with the bloat that entirely new shell 
        processes would. Meaning only barebones(default) modules/functions/variables/etc
        You have to construct what you need basically
        
        runspace pools are runspaces aggregated into a "pool" which is automagically managed by .NET behind the scenes.



    .Notes
        Need to implement processing for runspaces that have completed their "job" instead of waiting till the end to collect that info
        Need to play around with MAX_THREADS value for the runspace pool that gets constructed
#>

#region functions
function ping-osrs {
    param (
        [string]$server
    )
    $erroractionpreference = "silentlycontinue" #suppress the null exception on worlds 330/572
    $ms = @()
    $osrs = "oldschool$($world).runescape.com"
    [int16]$ms = (ping $osrs -n 1 | findstr "Min").Split(',')[0].Split('=')[1].Split('m')[0].trim()

    if($ms -le 25) {
        $actualWorld = $world + 300
        write-host "world: $($actualworld) | MS: $($ms)" -foregroundcolor "Green"
    }
}
#endregion

#region constants
$ListOfServers = for ($world = 1; $world -le 281; $world++) {
    $osrs = "oldschool$($world).runescape.com"
    $osrs
}
#endregion


## Local Runspaces
#construct an empty or default InitialSessionState
#The InitialSessionState specifies characteristics of the runspace, such as which commands, 
#variables, and modules are available for that runspace
$InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()

#add function to InitialSessionState var
$pingosrs_Def = (Get-command ping-osrs).Definition #get the function definition i.e. function contents/scriptblock
$pingosrs_Name = (Get-command ping-osrs).Name
$InitialSessionState.commands.add((
    New-Object -TypeName System.Management.Automation.Runspaces.SessionStateFunctionEntry -argumentList $pingosrs_Name,$pingosrs_Def
))

$min = 1
$Throttle = 100 # this is the max num of threads to be ran at any given time

$RunspacePool = [runspacefactory]::CreateRunspacePool($min, $Throttle, $InitialSessionState, $host)
$RunspacePool.Open()
$runspaces = @()

[scriptblock]$scriptblock = {
    param (
        [string]$server
    )
    ping-osrs -server $server
}

Foreach ($server in $ListOfServers) {
    $runspace = [powershell]::Create()
    [void]$runspace.AddScript($scriptblock)
    [void]$runspace.AddParameter('Server',$server)
    $runspace.Runspacepool = $runspacepool #add to pool
    $runspaces += New-Object PSObject -Property @{
        Pipe = $runspace
        Result = $runspace.BeginInvoke()
    }
}

$ping_results = @()
$runspaces.Foreach{
    $ping_results += $_.Pipe.Streams.Information
}

$ping_results




