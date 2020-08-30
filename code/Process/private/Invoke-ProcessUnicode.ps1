function Invoke-ProcessUnicode {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        Invoke-ProcessUnicodeData
        invoke-ProcessPropertyValueAliases
    }
    
    end {
        
    }
}