# Pester 3 compatible offline tests; no AD connection.
$modulePath = Join-Path $PSScriptRoot '..\scripts\automation\AtlasAD.psm1'
Describe 'AtlasAD module offline contract' {
    It 'imports and exposes the expected commands' {
        Import-Module $modulePath -Force
        (Get-Command -Module AtlasAD).Count | Should Be 14
    }
    It 'rejects a non-lab target before making an AD call' {
        $rejected = $false
        try { New-AtlasOrganizationalUnits -DomainName 'example.com' -WhatIf -ErrorAction Stop } catch { $rejected = $true }
        $rejected | Should Be $true
    }
    It 'has no default plaintext password in the synthetic CSV' {
        $header = Get-Content (Join-Path $PSScriptRoot '..\examples\synthetic-data\users.csv') -TotalCount 1
        $header | Should Not Match 'password'
    }
    It 'does not create an OU during WhatIf with mocked AD commands' {
        InModuleScope AtlasAD {
            function Get-ADDomain {}
            function Get-ADOrganizationalUnit {}
            function New-ADOrganizationalUnit {}
            Mock Assert-LabDomain {}
            Mock Get-ADDomain { [pscustomobject]@{ DistinguishedName = 'DC=corp,DC=example,DC=test' } }
            Mock Get-ADOrganizationalUnit { $null }
            Mock New-ADOrganizationalUnit {}
            New-AtlasOrganizationalUnits -WhatIf
            Assert-MockCalled New-ADOrganizationalUnit -Times 0
        }
    }
}
