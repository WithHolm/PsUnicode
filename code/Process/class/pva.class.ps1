class PvaGeneralCategory{
    [string]$Abbr
    [string]$Long
    [string]$Description

    PvaGeneralCategory(){}

    PvaGeneralCategory([String]$Line){
        $ret = $line.split(";")
        $this.Abbr = $ret[0].Trim()
        $this.Long = $ret[1].Trim()
        $this.Description = $ret[2].Trim().split("_") -join " "
    }

    [string] ToString()
    {
        return $this.description
    }
}