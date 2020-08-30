Describe "Test-UnicodeDataUpToDate"{
    BeforeEach{
        gci "TestDrive:\"|remove-item
    }
    InModuleScope unicode{
        mock 'Get-UnicodeSourcePath' -MockWith {return "TestDrive:\"}
    
        $Testcases = Get-UnicodeDataTypes|%{@{DataType=$_}}

        it "returns true if all file are up to date"{
            Get-UnicodeDataTypes|%{
                New-UnicodeDataFile -Filetype txt -Name $_
            }
            Test-UnicodeDataUpToDate|should -be $true
        }
    
        it "Returns false if files are not present or up to date for <DataType>" -TestCases $Testcases{
            param(
                [string]$DataType
            )
            Get-UnicodeDataTypes|?{$_ -ne $DataType}|%{
                New-UnicodeDataFile -Filetype txt -Name $_
            }

            Test-UnicodeDataUpToDate|should -be $false
        }
    }
}