<#
.SYNOPSIS
returns true false if you should update dataset
#>
function Test-UnicodeDataUpToDate {
    [CmdletBinding()]
    [outputtype([bool])]
    param (
        # [switch]$Passthru
    )
    
    begin {}
    process {
        #return true if dataset is up to date
        return !((Get-UnicodeVersion).ShouldUpdate -contains $true)
    }
    end {}
}