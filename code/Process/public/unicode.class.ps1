class UnicodeItem {
    [string]$Code
    [string]$Name
    [string]$Category
    [string]$CombineClass
    [string]$BidiClass
    [string]$Deomp
    [string]$Number
    [string]$Mirrored
    [string]$OldName
    [string]$Comment
    [string]$UpperCase
    [string]$LowerCase
    [string]$TitleCase

    UnicodeItem()
    {

    }

    UnicodeItem([string]$txtline)
    {
        # $return = [UnicodeItem]::new()
        $split = $txtline.split(";")
        $count = 0
        @('Code', 'Name', 'Category', 'CombineClass', 'BidiClass', 'Deomp', 'Number', 'Mirrored', 'OldName', 'Comment', 'UpperCase', 'LowerCase', 'TitleCase').foreach{   
            $property = $_
            $value = $split[$count].trim()
            switch($property)
            {
                "name"{
                    $value = $value.ToLower()
                    break
                }
                "Category"{
                    $NewValue = $Unicode.GeneralCategory|?{$_.long -eq $value}
                    if(![string]::IsNullOrEmpty($NewValue))
                    {
                        $value = $NewValue
                    }
                }
                default{
                }
            }

            try{
                $this.$property = $value
            }
            catch{
                write-error "$property`: $_"
            }
            $count++
        }
    }

    [string] AsRegex()
    {
        return "\u$(this.code)"
    }

    [int] AsDecimal()
    {
        $sb = [scriptblock]::Create("0x$($this.Code)")
        return $sb.Invoke()
    }

    [string] ToString()
    {
        return $this.name
    }
}

# Update-TypeData -TypeName "UnicodeItem" -MemberName 'Category' -MemberType ScriptProperty -Value {$global:Unicode.GeneralCategory|? abbr -eq $this.cat} -Force
Update-TypeData -TypeName "UnicodeItem" -DefaultDisplayPropertySet code, name, category, UpperCase -Force
# Update-TypeData -MemberType ScriptProperty -MemberName Regex -Value {$this.AsRegex()} -TypeName "UnicodeItem" -Force