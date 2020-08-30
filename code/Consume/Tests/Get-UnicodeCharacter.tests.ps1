describe "Get-UnicodeCharacter"{
    $testcases = @(
        @{
            param = @{
                InputItem = "B"
            }
            name = "capital B"
            return = "0042"
        }
        @{
            param = @{
                InputItem = "`t"
            }
            name = "tab"
            return = "0009"
        }
        @{
            param = @{
                InputItem = "0x1f"
            }
            name = "Info character - string '0x' byte reference"
            return = "001F"
        }
        @{
            param = @{
                InputItem = "u+1f"
            }
            name = "Info character - string 'u+' byte reference"
            return = "001F"
        }
        @{
            param = @{
                InputItem = 31
            }
            name = "Info character - byte int"
            return = "001F"
        }
        @{
            param = @{
                InputItem = "hei på deg"
                Literal = $true
            }
            name = "String literal"
            return = @('0068', '0065', '0069', '0020', '0070', '00E5', '0064', '0067')
        }
        @{
            param = @{
                InputItem = 12345
                Literal = $true
            }
            name = "Int literal"
            return = @('0031', '0032', '0033', '0034', '0035')
        }
        @{
            param = @{
                InputItem = "h","k","?",1,2
            }
            name = "Array"
            return = @('0068', '006B', '003F', '0001', '0002')
        }
        @{
            param = @{
                InputItem = "h","k","?",1,2
                literal = $true
            }
            name = "Array literal"
            return = @('0068', '006B', '003F', '0031', '0032')
        }
    )
    it "'<name>' does not throw" -TestCases $testcases{
        param(
            $param,
            $name,
            $return
        )
        {Get-UnicodeCharacter @param}|should -not -Throw
    }

    it "can get the correct data for '<name>'" -TestCases $testcases{
        param(
            $param,
            $name,
            $return
        )
        
        $data = Get-UnicodeCharacter @param
        $data.code |should -be $return
        # $return.keys|%{
        #     $data.$_ |should -be $return.$_ 
        # }
    }

    InModuleScope "unicode"{
        it "can get the last item in unicode list"{
            {Get-UnicodeCharacter ($global:Unicode.data.count-1)}|should -Not -Throw
        }
    }
}