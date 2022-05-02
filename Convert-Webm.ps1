#ffmpeg -i video.webm -crf 0  video.mp4
#-crf 0 = lossless video quality = more cpu intensive

<#
    .Description
        Very much still a work in progress, but here's the beginnings of a script that will
        convert webm files to mp4 files using ffmpeg and then log the results of the conversion process. 

        Inspired by my constant converting of webms to mp4s using VLC just so the Apple users in the squad group chat
        could have a giggle too. Wanted something that could quickly be called and isn't as daunting as the ffmpeg cli

    .Notes
      TODO:
        Everything
        Check for existence of ffmpeg prior to command executing
        maybe implement ps jobs or some other multi-threading mechanism to handle LOTS of webms at once
#>


$dateStamp = Get-Date -Format FileDateTime
$logFile = "C:\logs\webmconversions_$($dateStamp).log"
function Write-Log {
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [string] $LogMessage,

        [Parameter(Mandatory = $false)]
        [ValidateSet ("DEBUG","INFO","WARN","ERROR""FATAL")]
        [string] $LogLevel = "INFO"
    )
    $TimeStamp = (Get-Date).ToUniversalTime().ToString("yyyy/MM/dd HH:mm:ss")

    try{
        $ScriptName = Split-Path $PSCommandPath -Leaf
    }
    catch{
        $ScriptName = 'LocalRun'
    }
    $NewLogLine = '{0},{1},{2},{3}' -f $TimeStamp, $ScriptName, $LogLevel, $LogMessage
    Write-Verbose $NewLogLine -Verbose

    if (Test-Path -path $logFile){
        Add-Content -path $logFile -value $NewLogLine
    } else {
        New-Item -Path $logFile -ItemType:File -Force -Confirm:$false
        Add-Content -path $logFile -Value $NewLogLine
    }
}

Function Convert-WebmToMp4 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string[]]
        $FileName
    )

    $PathToFFMPEGexe = $env:ffmpeg
    $FileNameTrimmed = $FileName.TrimEnd("webm")

    $processArgs = @{
        FilePath     = "$PathToFFMPEGexe"
        ArgumentList = "-i $FileName $FileNameTrimmed.mp4"
    }
    Start-Process @ProcessArgs
}

$FileName = "C:\Users\James\Downloads\1643917894170.webm"

Try{
    Convert-WebmToMp4 -FileName $FileName
    Write-Log -LogMessage "Conversion success for $($FileName)" -LogLevel:INFO
} Catch {
    Write-Log -LogMessage "Webm Conversion failed for $($FileName)" -LogLevel:ERROR
}


