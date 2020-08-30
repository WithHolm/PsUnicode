function Get-UnicodeDataTypes {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        return (Import-PowerShellDataFile -Path (join-path $PSScriptRoot "Datatypes.psd1")).dataTypes
    }
    
    end {
        
    }
}