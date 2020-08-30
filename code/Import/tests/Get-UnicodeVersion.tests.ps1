Describe "Get-UnicodeVersion"{
    InModuleScope "Unicode"{
        mock 'Get-UnicodeSourcePath' -MockWith {return "TestDrive:\"}

        it "Delivers back an correct objects"{
            $(Get-UnicodeVersion).gettype().basetype.name|Should -be "array"
            Get-UnicodeVersion|should -BeOfType [UnicodeDataTypeVersion]
        }


        $Testcases = Get-UnicodeDataTypes|%{
            @{
                DataType = $_ 
            }
        }
        it "Delivers back version for '<DataType>'" -TestCases $Testcases{
            param(
                $datatype
            )
            Get-UnicodeVersion|?{$_.DataType -eq $datatype}|should -not -BeNullOrEmpty
        }

        it "Delivers back minimumdate if no file is avalibe for <datatype> " -TestCases $Testcases {
            param(
                $datatype
            )
            (Get-UnicodeVersion|?{$_.DataType -eq $datatype}).Local|should -be $([datetime]::MinValue.ToString("yyyy-MM-dd")) 
        }

        it "Delivers back date of newest file if several files is availible for <datatype> " -TestCases $Testcases {
            param(
                $datatype
            )

            @([datetime]::Today,[datetime]::Today.AddDays(-1))|%{
                New-UnicodeDataFile -Filetype txt -Name $datatype
            }
            ([datetime](Get-UnicodeVersion|?{$_.DataType -eq $datatype}).Local)|should -be $([datetime]::Today)
        }
    }
}