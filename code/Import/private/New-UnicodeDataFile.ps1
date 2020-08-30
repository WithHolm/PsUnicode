<#
.SYNOPSIS
Create a new datafile for unicode

.DESCRIPTION
Creates a new datafile to store data. this function handles storage location, filetype and date setting for the specific file, so one only need to define the name of the data, and possibly the content.

.PARAMETER Filetype
txt file or json file?

.PARAMETER content
if you have any content, use this parameter to define it

.PARAMETER Date
if you want to push a specific date (default is today)

.PARAMETER ThrowOnExists
if you want to test if file already exist, you can have the function throw if the file already exists

.EXAMPLE
New-UnicodeDataFile -Filetype txt -Name PropertyValueAliases
# Creates a new file called 'PropertyValueAliases_2020-08-15.txt' under $env:temp/UnicodeDataFiles if done on 15/08/2020 and not in devmode

#>
function New-UnicodeDataFile {
    [CmdletBinding()]
    param (
        [ValidateSet("txt","json")]
        [string]$Filetype = "txt",
        [string[]]$content,
        [datetime]$Date = ([datetime]::UtcNow),
        [switch]$ThrowOnExists
    )
    DynamicParam
    {          
        $ParamAttrib  = New-Object System.Management.Automation.ParameterAttribute
        $ParamAttrib.Mandatory  = $true
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
        $name = $PSBoundParameters.name
        $source = Get-UnicodeSourcePath
    }
    
    process {
        $Filename = "$($name)_$($date.ToString("yyyy-MM-dd")).$filetype"
        $param = @{
            Path = (join-path $source $Filename)
            ItemType = 'File'
            Force = !$ThrowOnExists.IsPresent
        }

        Write-Verbose "Creating file $($param.path)"
        $file = New-Item @param -ErrorAction Stop

        # write-host $param.Path
        if($content.Count -gt 0)
        {
            $file|Remove-Item
            $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
            [System.IO.File]::WriteAllLines($file.fullname, $content, $Utf8NoBomEncoding)
        }
    }
    
    end {
        
    }
}