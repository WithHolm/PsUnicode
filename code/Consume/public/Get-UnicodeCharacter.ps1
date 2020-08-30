function Get-UnicodeCharacter
{
    [CmdletBinding(DefaultParameterSetName = "string")]
    param (
        [parameter(HelpMessage = "item")]
        $InputItem,
        [String]$Search,
        [parameter(HelpMessage = "When input is literal. will take string and int at face value")]
        [switch]$Literal
    )
    
    begin
    {
        
    }
    process
    {
        $ProcessList = @()
        Write-Debug "Input:'$inputitem', Type:$($inputitem.gettype()), Literal is $($Literal.IsPresent)"
        if ($inputitem -is [byte])
        {
            # write-host $InputItem
            $ProcessList += [System.Convert]::ToInt64($InputItem.tostring())
            #  $inputitem
        }
        elseif ($inputitem -is [String])
        {
            if ($inputitem.tolower() -match "0x[a-f0-9]{2,5}" -and !$Literal)
            {
                Write-debug "Processing 0x string reference"
                $convert = [scriptblock]::create($inputitem).invoke()
                # Write-debug "$inputitem = $convert; $($convert.gettype()); $($convert|ConvertTo-Json -Compress)"
                $ProcessList += [System.Convert]::ToInt64("$convert")
            }
            elseif ($inputitem.tolower() -match "[u][+][a-f0-9]{2,5}" -and !$Literal)
            {
                Write-debug "Processing u+ string reference"
                $convert = $InputItem.tolower().replace("u+","0x")
                $convert = [scriptblock]::create($convert).invoke()
                $ProcessList += [System.Convert]::ToInt64("$convert")
            }
            else 
            {
                $i = 0
                $ProcessList += [System.Text.ASCIIEncoding]::Unicode.GetBytes($inputitem) | Where-Object { $i % 2 -eq 0; $i++ }
            }
        }
        elseif ($inputitem -is [int] -or $inputitem -is [long])
        {
            if ($Literal)
            {
                $ProcessList +=  [System.Text.ASCIIEncoding]::Unicode.GetBytes($inputitem) | Where-Object { $i % 2 -eq 0; $i++ }
            }
            else
            {
                $ProcessList += $inputitem
            }
        }
        elseif($InputItem -is [array])
        {
            $InputItem|%{
                $param = @{
                    inputitem = $_
                    literal = $Literal.IsPresent
                    # details = $Details.IsPresent
                }
                write-output (Get-UnicodeCharacter @param)
            }
        }
        else {
            throw "Could not parse input of type $($inputitem.gettype())"
        }

        # $ProcessList
        # $FormattedSearch = @($ProcessList|select -Unique|%{('{0:x}' -f $_).PadLeft(4,"0")})
        $ProcessList|select -Unique|%{
            $Line = $global:Unicode.data[$_] #(Get-UnicodeDataFiles -Filetype txt|?{$_.BaseName -like "UnicodeData"})
            if(!$line)
            {
                Throw "Could not find info on character '$_'"
            }
            Write-Output ([unicodeitem]::new($line)) #(Get-UnicodeList)[$_]
        }
    }
    
    end
    {
        
    }
}