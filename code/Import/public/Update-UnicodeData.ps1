function Update-UnicodeData {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        
    }
    
    process {
        $Versions = Get-UnicodeVersion
        foreach($Version in $Versions)
        {
            if($Version.shouldupdate)
            {
                Write-host "Updating datasource '$($version.datatype)'"
                Invoke-DownloadUnicodeData -Name $version.datatype
                [scriptblock]::Create("invoke-process$($version.datatype)").Invoke()
            }
        }
    }
    
    end {
        
    }
}