function Invoke-ProcessUnicodeData {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        # if(!$Global:Unicode.list)
        # {
        #     $Global:Unicode.List = [System.Collections.Generic.List[unicodeitem]]::new()
        # }        
        
    }
    
    process {
        $datatype = "UnicodeData"
        # # write-verbose $script:modulepath
        # $Version = Get-UnicodeVersion -OnlyLocal|? datatype -eq $datatype

        $txtSource = Get-UnicodeDataFiles -Filetype Txt|? BaseName -like "$datatype*"
        $global:Unicode.data = [System.IO.File]::ReadAllLines($txtSource.FullName).Where{$_}
        # $JsonSource = Get-UnicodeDataFiles -Filetype Json|? BaseName -like "$datatype_*"

        # if($JsonSource)
        # {
        #     $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
        #     $Global:Unicode.List = [System.Collections.Generic.List[unicodeitem]]::new()
        #     $Global:Unicode.List += ([system.io.file]::ReadAllText($JsonSource.FullName,$Utf8NoBomEncoding)|ConvertFrom-Json|%{[unicodeitem]$_})
        #     return 
        # }
        # else {
        #     Write-Verbose "json file $($JsonSource), Data version $($version.local)"
        # }

        # Write-Warning "Processing Newest version of unicode data. this might take some time."
        # $Global:Unicode.List = [System.Collections.Generic.List[unicodeitem]]::new()
        # $txtSource = Get-UnicodeDataFiles -Filetype Txt|?{$_.name -like "unicodedata*"}
        # try{
        #     $Global:Unicode.List += ([System.IO.File]::ReadAllLines($txtSource.FullName).Where{$_}).foreach{
        #         [unicodeitem]::new($psitem)
        #     }
        #     New-UnicodeDataFile -Filetype json -content ($Global:Unicode.List|convertto-json -Depth 99 -Compress) -Name UnicodeData -Date $Version.local
        #     # new-uni
        # }
        # catch{
        #     # write-host ($item.gettype()|convertto-json -Depth 1)
        #     throw $_
        # }
    }
    
    end {
        
    }
}