$moduleRoot = (Resolve-Path "$PSScriptroot\..\")

Describe "Running tests" {
    It "Check results file is present" {
        Test-Path Tests\resultsfile.log | should -be $true
    }
    Context "Validating ps1 files" {
        $allFiles = Get-ChildItem -Path $moduleroot -Recurse -Filter "*.ps1" | Where-Object Fullname -NotLike "$moduleroot\tests\*"
        foreach ($file in $allFiles) {
            $name = $file.FullName.Replace("$moduleroot\", '')

            It "[$name] Should have no trailing space" {
                ($file | Select-String "\s$" | Where-Object { $_.Line.Trim().Length -gt 0 } | Measure-Object).Count | Should Be 0
            }

            $tokens = $null
            $parseErrors = $null
            $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)

            It "[$name] Should have no syntax errors" {
                $parseErrors | Should Be $Null
            }



            It "[$name] Should not contain aliases" {
                $tokens | Where-Object TokenFlags -eq CommandName | Where-Object { Test-Path "alias:\$($_.Text)" } | Measure-Object | Select-Object -ExpandProperty Count | Should Be 0
            }
            
        }
    }
}