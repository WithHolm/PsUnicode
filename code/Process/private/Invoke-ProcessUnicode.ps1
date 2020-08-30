function Invoke-ProcessUnicode {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        # $version = Get-UnicodeVersion
        # Write-host "1"
        Invoke-ProcessUnicodeData
        # Write-host 2
        invoke-ProcessPropertyValueAliases
        # invoke-process
    }
    
    end {
        
    }
}