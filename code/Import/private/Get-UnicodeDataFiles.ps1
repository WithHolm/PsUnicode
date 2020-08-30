<#
.SYNOPSIS
returns local unicode data files

.DESCRIPTION
returns local unicode data files. will return the latest version of each file, unless -all is applied

.PARAMETER All
returns all files

.PARAMETER Filetype
returns the files stored as this specific type. defaults to txt
#>
function Get-UnicodeDataFiles
{
    [CmdletBinding()]
    [outputtype([system.io.fileinfo])]
    param (
        [Switch]$All,
        [ValidateSet('Json', 'Txt')]
        [string[]]$Filetype
    )
    
    begin
    {
        if (!$Filetype)
        {
            $Filetype = $PSCmdlet.MyInvocation.MyCommand.Parameters['filetype'].Attributes.validvalues
        }
    }
    
    process
    {
        $Output = @()
        Get-UnicodeSourcePath -All | ForEach-Object {
            $Output += (Get-ChildItem $_ -File)
        }
        
        Foreach($FileT in $Filetype)
        {
            Get-UnicodeDataTypes | % {
                $Typename = $_
                $out = $Output | ? { $_.BaseName -like "$Typename`_*" }
                $out = $out | ? { $_.Extension -eq ".$FileT" }
                $out = $out | sort BaseName -Descending
                if ($All)
                {
                    return $out
                }
                return ($out | Select-Object -First 1)
            }
        }
    }
    
    end {}
}

# Get-UnicodeDataFiles