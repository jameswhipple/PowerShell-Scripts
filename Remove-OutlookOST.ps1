#Requires -RunAsAdministrator
<#
    .Synopsis
        Removes all Offline Outlook data files (.ost) from the C:\ drive

    .Description
        This script will query the entire c:\ drive to locate any .ost files and then delete them after prompting for confirmation
        Useful for quickly removing those pesky corrupted .ost files, especially if you don't remember the directory they could be in ;)
    
    .Notes
      Author: Jwhipp
      TODO:
        Re-factor to run against either local OR remote host. Right now it's local only
#>
function Remove-OutlookOST {
    [CmdletBinding(SupportsShouldProcess)] # Allows -Confirm and -WhatIf parameters
    param ()

    try{
        Write-Host "Searching for ost files on the C:\ drive" -ForegroundColor 'Cyan'
        [string[]]$ostPath = (Get-CimInstance -Query "SELECT * from CIM_DataFile WHERE Drive = 'C:' AND Extension = 'ost'").Name #also searches recycle bin which is nice
        write-host "Found $($ostPath.count) ost file(s)" -ForegroundColor 'Cyan'
        $ostPath
        Write-Host "Deleting now..." -ForegroundColor 'DarkYellow'
        ForEach($ost in $ostPath){
            Remove-Item -Path $ost -verbose
        }
        Write-Host "Done deleting ost file(s)..." -ForegroundColor 'Green'
    }
    catch{
        Write-Error -Message $_.Exception.Message
        Exit
    }
}

try{
    Remove-OutlookOST -Confirm
}
catch{
    Write-error $_.Exception.Message
}