Set-StrictMode -Version Latest

function Assert-LabDomain {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$DomainName)
    if ($DomainName -ne 'corp.example.test') { throw 'This module is restricted to the corp.example.test isolated lab.' }
    if (-not (Get-Module -ListAvailable ActiveDirectory)) { throw 'ActiveDirectory module is unavailable. Run on an approved Windows Server lab or RSAT host.' }
    Import-Module ActiveDirectory -ErrorAction Stop
    $actual = (Get-ADDomain -ErrorAction Stop).DNSRoot
    if ($actual -ne $DomainName) { throw "Connected domain $actual does not match $DomainName." }
}

function New-AtlasOrganizationalUnits {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param([string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    $base = (Get-ADDomain).DistinguishedName
    foreach ($name in @('IT','Human Resources','Finance','Operations','Engineering','Management','Service Accounts','Workstations','Servers','Groups')) {
        $existing = Get-ADOrganizationalUnit -LDAPFilter "(ou=$name)" -SearchBase $base -SearchScope OneLevel -ErrorAction Stop
        if (-not $existing -and $PSCmdlet.ShouldProcess("OU=$name,$base", 'Create organizational unit')) {
            New-ADOrganizationalUnit -Name $name -Path $base -ProtectedFromAccidentalDeletion $true -ErrorAction Stop
        }
    }
}

function New-AtlasSecurityGroups {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param([string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    $base = (Get-ADDomain).DistinguishedName
    $path = "OU=Groups,$base"
    if (-not (Get-ADOrganizationalUnit -Identity $path -ErrorAction SilentlyContinue)) { throw 'Create the Groups OU first.' }
    foreach ($department in @('IT','HumanResources','Finance','Operations','Engineering','Management')) {
        $name = "GG-$department-Users"
        if (-not (Get-ADGroup -Identity $name -ErrorAction SilentlyContinue) -and $PSCmdlet.ShouldProcess($name, 'Create global security group')) {
            New-ADGroup -Name $name -SamAccountName $name -GroupScope Global -GroupCategory Security -Path $path -ErrorAction Stop
        }
    }
}

function Import-AtlasUsers {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory)][ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })][string]$CsvPath,
        [Parameter(Mandatory)][securestring]$InitialPassword,
        [string]$DomainName = 'corp.example.test'
    )
    Assert-LabDomain -DomainName $DomainName
    $base = (Get-ADDomain).DistinguishedName
    $allowed = @('IT','Human Resources','Finance','Operations','Engineering','Management')
    foreach ($row in (Import-Csv -LiteralPath $CsvPath -ErrorAction Stop)) {
        if ([string]::IsNullOrWhiteSpace($row.SamAccountName) -or $row.SamAccountName -notmatch '^[a-z][a-z0-9.]{1,19}$') { throw "Invalid SamAccountName: $($row.SamAccountName)" }
        if ($row.Department -notin $allowed) { throw "Invalid department for $($row.SamAccountName)" }
        if ([string]::IsNullOrWhiteSpace($row.GivenName) -or [string]::IsNullOrWhiteSpace($row.Surname)) { throw "Missing name for $($row.SamAccountName)" }
        $sam = $row.SamAccountName
        $ou = "OU=$($row.Department),$base"
        $group = 'GG-' + ($row.Department -replace ' ', '') + '-Users'
        if (-not (Get-ADOrganizationalUnit -Identity $ou -ErrorAction SilentlyContinue)) { throw "Missing OU $ou" }
        if (-not (Get-ADGroup -Identity $group -ErrorAction SilentlyContinue)) { throw "Missing group $group" }
        $existing = Get-ADUser -Identity $sam -ErrorAction SilentlyContinue
        if (-not $existing -and $PSCmdlet.ShouldProcess($sam, 'Create synthetic user and assign department group')) {
            New-ADUser -Name "$($row.GivenName) $($row.Surname)" -GivenName $row.GivenName -Surname $row.Surname -SamAccountName $sam -UserPrincipalName "$sam@$DomainName" -Department $row.Department -Path $ou -AccountPassword $InitialPassword -ChangePasswordAtLogon $true -Enabled $true -ErrorAction Stop
            Add-ADGroupMember -Identity $group -Members $sam -ErrorAction Stop
        }
    }
}

function Set-AtlasAccountStatus {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param([Parameter(Mandatory)][string]$SamAccountName, [Parameter(Mandatory)][bool]$Enabled, [string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    $user = Get-ADUser -Identity $SamAccountName -ErrorAction Stop
    if ($user.SamAccountName -notmatch '^lab\.') { throw 'Account status changes are limited to lab.* identities.' }
    if ($PSCmdlet.ShouldProcess($user.DistinguishedName, "Set Enabled=$Enabled")) {
        if ($Enabled) { Enable-ADAccount -Identity $user -ErrorAction Stop } else { Disable-ADAccount -Identity $user -ErrorAction Stop }
    }
}

function Reset-AtlasTestPassword {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    param([Parameter(Mandatory)][string]$SamAccountName, [Parameter(Mandatory)][securestring]$NewPassword, [string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    $user = Get-ADUser -Identity $SamAccountName -ErrorAction Stop
    if ($user.SamAccountName -notmatch '^lab\.') { throw 'Password resets are limited to lab.* identities.' }
    if ($PSCmdlet.ShouldProcess($user.DistinguishedName, 'Reset password and require change at next logon')) {
        Set-ADAccountPassword -Identity $user -Reset -NewPassword $NewPassword -ErrorAction Stop
        Set-ADUser -Identity $user -ChangePasswordAtLogon $true -ErrorAction Stop
    }
}

function Get-AtlasADInventory {
    [CmdletBinding()]
    param([string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    [pscustomobject]@{
        TimestampUtc = [DateTime]::UtcNow.ToString('o')
        Domain = $DomainName
        Users = @(Get-ADUser -Filter *).Count
        Groups = @(Get-ADGroup -Filter *).Count
        Computers = @(Get-ADComputer -Filter *).Count
        DomainControllers = @(Get-ADDomainController -Filter * | Select-Object HostName,IPv4Address,Site,IsGlobalCatalog)
    }
}

function Get-AtlasInactiveAccounts {
    [CmdletBinding()]
    param([int]$Days = 90, [string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    $cutoff = (Get-Date).AddDays(-$Days)
    Get-ADUser -Filter { Enabled -eq $true } -Properties LastLogonDate,PasswordLastSet |
        Where-Object { -not $_.LastLogonDate -or $_.LastLogonDate -lt $cutoff } |
        Select-Object SamAccountName,LastLogonDate,PasswordLastSet
}

function Get-AtlasPrivilegedMembership {
    [CmdletBinding()]
    param([string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    foreach ($sid in @('S-1-5-21-*-512','S-1-5-21-*-518','S-1-5-21-*-519')) {
        $group = Get-ADGroup -Filter * | Where-Object { $_.SID.Value -like $sid } | Select-Object -First 1
        if ($group) { Get-ADGroupMember -Identity $group -Recursive | Select-Object @{n='Group';e={$group.Name}},Name,SamAccountName,ObjectClass }
    }
}

function Get-AtlasDomainHealth {
    [CmdletBinding()]
    param([string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    $dcs = @(Get-ADDomainController -Filter *)
    foreach ($dc in $dcs) {
        [pscustomobject]@{ HostName=$dc.HostName; DnsResolvable=[bool](Resolve-DnsName $dc.HostName -ErrorAction SilentlyContinue); LDAPReachable=(Test-NetConnection $dc.HostName -Port 389 -InformationLevel Quiet); SYSVOL=Test-Path "\\$($dc.HostName)\SYSVOL" }
    }
}

function Get-AtlasReplicationHealth {
    [CmdletBinding()]
    param([string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    Get-ADReplicationPartnerMetadata -Target $DomainName -Scope Domain -ErrorAction Stop |
        Select-Object Server,Partner,LastReplicationSuccess,LastReplicationResult,ConsecutiveReplicationFailures
}

function Get-AtlasFSMORoles {
    [CmdletBinding()]
    param([string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    $forest = Get-ADForest
    $domain = Get-ADDomain
    [pscustomobject]@{ SchemaMaster=$forest.SchemaMaster; DomainNamingMaster=$forest.DomainNamingMaster; PDCEmulator=$domain.PDCEmulator; RIDMaster=$domain.RIDMaster; InfrastructureMaster=$domain.InfrastructureMaster }
}

function Test-AtlasDNS {
    [CmdletBinding()]
    param([string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    foreach ($record in @("_ldap._tcp.dc._msdcs.$DomainName","_kerberos._tcp.$DomainName")) {
        $result = Resolve-DnsName -Name $record -Type SRV -ErrorAction SilentlyContinue
        [pscustomobject]@{ Record=$record; Resolved=[bool]$result; Targets=@($result | Select-Object -ExpandProperty NameTarget -ErrorAction SilentlyContinue) }
    }
}

function Export-AtlasGPOReport {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$OutputDirectory, [string]$DomainName = 'corp.example.test')
    Assert-LabDomain -DomainName $DomainName
    Import-Module GroupPolicy -ErrorAction Stop
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    foreach ($gpo in (Get-GPO -All -Domain $DomainName)) {
        $path = Join-Path $OutputDirectory "$($gpo.Id).xml"
        Get-GPOReport -Guid $gpo.Id -ReportType Xml -Path $path -Domain $DomainName -ErrorAction Stop
    }
}

function Test-AtlasFileAccess {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Path, [Parameter(Mandatory)][string]$IdentityReference)
    if (-not (Test-Path -LiteralPath $Path)) { throw "Path unavailable: $Path" }
    $acl = Get-Acl -LiteralPath $Path -ErrorAction Stop
    $acl.Access | Where-Object { $_.IdentityReference.Value -eq $IdentityReference } |
        Select-Object IdentityReference,FileSystemRights,AccessControlType,IsInherited
}

Export-ModuleMember -Function New-AtlasOrganizationalUnits,New-AtlasSecurityGroups,Import-AtlasUsers,Set-AtlasAccountStatus,Reset-AtlasTestPassword,Get-AtlasADInventory,Get-AtlasInactiveAccounts,Get-AtlasPrivilegedMembership,Get-AtlasDomainHealth,Get-AtlasReplicationHealth,Get-AtlasFSMORoles,Test-AtlasDNS,Export-AtlasGPOReport,Test-AtlasFileAccess
