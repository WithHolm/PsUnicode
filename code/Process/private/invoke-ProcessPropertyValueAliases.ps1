function invoke-ProcessPropertyValueAliases {
    [CmdletBinding()]
    param (
    )
    
    begin {
        
    }
    
    process {
        $Source = Get-UnicodeDataFiles -Filetype Txt|?{$_.name -like "PropertyValueAliases*"}

        # #region General Category
        $GC = Get-PropertyValueItems -Dataset $Source -Title "General_Category"
        $gc = $gc|%{$_.split("#")[0]}
        $global:unicode.GeneralCategory = $GC|%{[PvaGeneralCategory]::new($_)} #|ConvertFrom-Csv -Delimiter ";" -Header "abbr","long","Description"
        # #endregion
    }
    
    end {
        
    }
}