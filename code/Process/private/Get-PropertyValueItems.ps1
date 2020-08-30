function Get-PropertyValueItems
{
    [CmdletBinding()]
    param (
        [String]$Title,
        [System.IO.FileInfo]$Dataset
    )
    
    begin
    {
        $Data = [System.IO.File]::ReadAllLines($Dataset.FullName)
    }
    
    process
    {   
        $currtitle = ""
        $out=@{}
        for ($i = 0; $i -lt $Data.Count; $i++)
        {
            $line = $data[$i]
            if ([string]::IsNullOrEmpty($line))
            {
                continue
            }
            elseif ($line -match '#\s[a-zA-Z_]{2,}\s\([a-zA-Z_]{1,}\)')
            {
                $currtitle = ($line.substring(2) -replace "\([a-zA-Z]{1,}\)").trim()
            }
            elseif ($line -match '([a-zA-Z0-9_ ]{1,};)' -and $line -notlike "#*")
            {
                if (!$out.$currtitle)
                {
                    Write-Verbose "Creating new pva title '$currtitle'"
                    $out.$currtitle = @()
                }
                $out.$currtitle += $line
            }
        }
    }
    end
    {
        if(!$out.ContainsKey($Title))
        {
            Throw "Could not find key $title"
        }
        $out.$title
    }
}
