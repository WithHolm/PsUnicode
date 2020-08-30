. (join-path $script:ModulePath 'code\import\class\UnicodeDataTypeVersion.ps1')

<#
.SYNOPSIS
Get versions of all downloaded datafiles

.EXAMPLE
Get-UnicodeVersion

.NOTES
General notes
#>
function Get-UnicodeVersion {
    [CmdletBinding()]
    [outputtype([UnicodeDataTypeVersion])]
    param (
        [switch]$OnlyLocal
    )
    
    begin {
        $Files = Get-UnicodeDataFiles -Filetype Txt
        $Uri = 'https://www.unicode.org/Public/UCD/latest/ReadMe.txt'
    }
    
    process {
        #Get online Version. used for all types
        if(!$OnlyLocal)
        {
            try{
                $readme = Invoke-RestMethod -Uri $Uri -TimeoutSec 4
            }
            catch{
                throw "Could not contact unicode.org within the given timeframe"
            }
            $OnlineDate = $readme.split("`n")|?{$_ -match "# Date: (?'date'[0-9]{4}-[0-9]{2}-[0-9]{2})"}|%{$Matches['date']}
        }
        else
        {
            $OnlineDate = [datetime]::MinValue.AddSeconds(1).ToString("yyyy-MM-dd")
        }
        if([string]::IsNullOrEmpty($OnlineDate))
        {
            throw "Had trouble getting versionData from Unicode.org. aborting"
        }

        foreach($datatype in Get-UnicodeDataTypes)
        {
            $LocalDate = $Files|?{$_.BaseName -like "$datatype*"}|%{$_.basename.split("_")[-1]}
            if(!$LocalDate)
            {
                $LocalDate = [datetime]::MinValue.ToString("yyyy-MM-dd")
            }
            $return = [UnicodeDataTypeVersion]@{
                DataType = $datatype
                Local = $LocalDate
                Online = $OnlineDate
                ShouldUpdate = $LocalDate -lt $OnlineDate
            }
            Write-Output $return
        }
    }
    
    end {
        
    }
}
# Get-UnicodeVersion