Get-ChildItem "$PSScriptRoot/code"-Recurse -Filter "*.ps1"|Where-Object{$($_.Directory.Name) -in "Public",'private'}|ForEach-Object{
    . $_.FullName
}

$script:ModulePath = $PSScriptRoot
$script:test = "testing"
$global:Unicode = @{}

# Update-UnicodeData
if((Test-UnicodeDataUpToDate) -eq $false)
{
    Write-warning "You should concider updating your unicode dataset. please type in 'update-unicodedata' to start this process, and reload module afterwards"
}

Invoke-ProcessUnicode
# Invoke-ProcessUnicode
# Start-UnicodeImportProcess
# Write-Host $script:ModulePath
# # $global:Unicode =  @{}
# []