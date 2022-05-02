#ffmpeg -i video.webm -crf 0  video.mp4
#-crf 0 = lossless video quality = more cpu intensive
$dateStamp = Get-Date -f "dd-MMM-yyyy"
$logFile = "C:\users\James\Desktop\PowerShell\webmconversions_$($dateStamp).log"
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


