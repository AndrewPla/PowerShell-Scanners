Describe "Check results file is present" {
    It "Check results file is present" {
        Test-Path Tests\resultsfile.log | should -be $true
    }
}