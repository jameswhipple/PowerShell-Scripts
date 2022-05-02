#Requires -RunAsAdministrator
<#
    .Synopsis
        Installs all tools in the RSAT collection

    .Description
        Loops through entire RSAT collection and installs each tool using Add-WindowsCapability.
    
    .Notes
      Author: Jwhipp
      TODO:
        build framework for allowing user to target and install specific tool(s) from collection
          ex. Install-RSAT -AD -RDP -ServerManager
        
        Next natural step after the above addition would be to add a switch to just grab the entire collection 
          ex. Install-RSAT -EntireCollection
#>
function Install-RSAT {
    Try{        
        $RsatCollection = ( (Get-WindowsCapability -Online).Where{$_.Name -Like "RSAT*"} ).Name
        Write-Output "Found $($RsatCollection.count) tools in the collection"
        ForEach($tool in $RsatCollection){
            Get-WindowsCapability -Online -Name $tool | Add-WindowsCapability -Online -Verbose
        }
        Write-Output "Done installing..."
    }
    catch{
        Write-Error $_.Exception.Message
    }
}


try{
    Install-RSAT
}
catch{
    write-error $_.Exception.Message
}