<#
add a way to catch when you are about to run 'restart-computer' in a local runspace and add warning y/n
inspired by accidental reboots of bastion hosts by myself and peers, when really attempting to restart-computer on a remote runspace(remote session)

TODO:
learn runspaces
 -local runspaces
 -remote runspaces
#>


#create local runspace using [runspacefactory]::CreateRunspace()
$rs = [runspacefactory]::CreateRunspace()
$Shell = [powershell]::Create()

#move $shell.runspace from its instantiated runspace over to the newly created runspace $rs
$shell.Runspace = $rs

#Until changed the runspace is in an BeforeOpen state, we need to Open it up
$rs.Open()


[void]$shell.AddScript({Get-Date;Start-Sleep 10}) #void suppresses output, formatting preference


$Shell.Invoke()
$AsycnObj = $Shell.BeginInvoke() #asyncobj allows monitoring, use this over .invoke()

#Check AsyncObj..if 'IsCompleted' propertly is false then command is still running
#once true command is considered finished and we can now grab output with .endinvoke()
$AsycnObj

$data = $Shell.endinvoke($AsycnObj)

#cleanup
$Shell.Dispose()