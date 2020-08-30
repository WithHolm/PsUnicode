Describe "Test-DevMode"{
    InModuleScope "Unicode"{
        $devlock = "dev.lock"
        $Script:ModulePath = "TestDrive:\"
        it "Will return true if dev.lock is present"{
            new-item (Join-Path $Script:ModulePath $devlock) -ItemType File -Force|Out-Null
            Test-DevMode|should -be $true
        }
        it "Will return false if dev.lock is not present"{
            Get-ChildItem (Join-Path $Script:ModulePath $devlock)|Remove-Item
            Test-DevMode|should -be $false
        }
    }
}