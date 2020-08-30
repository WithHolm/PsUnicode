function Test-DevMode {
    [CmdletBinding()]
    param (
    )
    
    begin {}
    
    process {
        # Write-Host "modulepath: $Script:ModulePath"
        # Write-Host "test: $Script:testing"
        return (test-path (Join-Path $Script:ModulePath "dev.lock"))
    }
    
    end {}
}