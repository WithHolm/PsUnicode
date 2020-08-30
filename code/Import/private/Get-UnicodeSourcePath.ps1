<#
.SYNOPSIS
Returns Sourcepath to either save or load data from

.PARAMETER All
returns both dev path and user path

.PARAMETER Dev
automatically applied, please ignore
#>
function Get-UnicodeSourcePath
{
    [CmdletBinding()]
    [Outputtype('string')]
    param (
        [Switch]$All,
        [Switch]$Dev = (Test-DevMode)
    )
    
    begin{}
    process
    {
        # $Dev
        if ($dev -or $All)
        {
            Write-Output (join-path $Script:ModulePath "Source")
        }
        
        if(!$dev -or $All)
        {
            $Temp = (join-path $env:temp 'UnicodeDataFiles')
            new-item -ItemType Directory -Path $Temp -Force | Out-Null
            Write-Output $Temp
        }
    }
    end{}
}