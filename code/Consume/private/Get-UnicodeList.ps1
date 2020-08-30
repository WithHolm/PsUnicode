function Get-UnicodeList {
    [CmdletBinding()]
    # [outputtype([])]
    param (
        
    )
    
    begin {
        Start-UnicodeImportProcess
        # $script:modulepath
        # join-path $script:module
        # Import-UnicodeData
    }
    
    process {
        return $global:Unicode.list
    }
    
    end {
        
    }
}