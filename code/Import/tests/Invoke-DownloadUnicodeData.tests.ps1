Describe Invoke-DownloadUnicodeData{
    BeforeEach{
        gci "TestDrive:\"|remove-item
    }

    InModuleScope unicode{
        mock 'Get-UnicodeSourcePath' -MockWith {return "TestDrive:\"}
        $Testcases = Get-UnicodeDataTypes|%{@{DataType=$_}}
        it "Will download data for datatype <datatype>" -TestCases $Testcases {
            param(
                $datatype
            )
            {Invoke-DownloadUnicodeData -Name $datatype}|should -not -Throw
            (gci "TestDrive:\" -Filter "$datatype*").count|should -BeGreaterThan 0
        }
        
        it "Will skip download if data for datatype <datatype> already exists" -TestCases $Testcases {
            param(
                $datatype
            )
            $Test1 = measure-command {Invoke-DownloadUnicodeData -Name $datatype}
            $Test2 = measure-command {Invoke-DownloadUnicodeData -Name $datatype}
            $test1.TotalMilliseconds|should -BeGreaterThan $Test2.TotalMilliseconds 
        }
    }
}