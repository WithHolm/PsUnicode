<#
.SYNOPSIS
Downloads file from the unicode site.

.DESCRIPTION
Downloads file from the unicode site. what name you can define is in datatypes.psd1

.EXAMPLE
#downloads data from the unicode site regarding PropertyValueAliases and saves it as PropertyValueAliases_{date}.txt in either temp or module folder (depending on if you are in dev more or not)
Invoke-DownloadUnicodeData -Name PropertyValueAliases

#>
function Invoke-DownloadUnicodeData {
    [CmdletBinding()]
    param (
    )
    
    DynamicParam
    {          
        $ParamAttrib  = New-Object System.Management.Automation.ParameterAttribute
        $ParamAttrib.Mandatory  = $false
        $ParamAttrib.ParameterSetName  = '__AllParameterSets'
        $AttribColl = New-Object  System.Collections.ObjectModel.Collection[System.Attribute]
        $AttribColl.Add($ParamAttrib)
        $AttribColl.Add((New-Object  System.Management.Automation.ValidateSetAttribute($(Get-UnicodeDataTypes))))
    
        $RuntimeParam  = New-Object System.Management.Automation.RuntimeDefinedParameter('Name',  [string[]], $AttribColl)
        $RuntimeParamDic  = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $RuntimeParamDic.Add('Name',  $RuntimeParam)
        return  $RuntimeParamDic
    }
    begin {
        $baseurl = 'https://www.unicode.org/Public/UCD/latest/ucd'
        $name = $PSBoundParameters.name
        if(!$name)
        {
            $name = Get-UnicodeDataTypes
        }
    }
    process {
        try{
            New-UnicodeDataFile -ThrowOnExists -Filetype txt -Name $name
            $content = Invoke-RestMethod -Uri "$baseurl/$name.txt"
            New-UnicodeDataFile -Filetype txt -content $content -Name $name
        }
        catch{}
    }
    end {
    }
}