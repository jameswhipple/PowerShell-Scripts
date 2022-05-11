# Collection of random scripts I've made. One day I'll get around to organizing them further...

## Initial comments on my scripting preferences..
 - I use try/catch blocks a LOT, perhaps slightly more than necessary but I prefer gracefully handling errors where possible and occasionally creating my own errorrecords i.e. custom exceptions
 - I Use a mix of OTBS and Stroustrup indentation style for formatting https://en.wikipedia.org/wiki/Indentation_style
 - Log everything...checkout https://github.com/jameswhipple/PowerShell-Modules/blob/master/Write-Log/Write-Log.psm1


The below function uses OTBS, but also because else/catch are placed on new lines it's considered a Stroustrup variation
```
function test {
    try {
        if (test-netconnection)  {
            #some code
        }
        else {
            exit
        }
    }
    catch {
        write-error $_.Exception.Message
    }
}
```
