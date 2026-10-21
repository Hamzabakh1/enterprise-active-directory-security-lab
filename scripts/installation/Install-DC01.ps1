# Run only on an isolated, approved Windows Server VM named DC01.
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param([Parameter(Mandatory)][switch]$ApprovedLab)
if (-not $ApprovedLab -or $env:COMPUTERNAME -ne 'DC01') { throw 'Requires -ApprovedLab on DC01.' }
if (-not $PSCmdlet.ShouldProcess('DC01', 'Install AD DS role and create corp.example.test forest')) { return }
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -ErrorAction Stop
$dsrm = Read-Host 'DSRM password' -AsSecureString
Install-ADDSForest -DomainName 'corp.example.test' -DomainNetbiosName 'CORP' -InstallDNS -SafeModeAdministratorPassword $dsrm -NoRebootOnCompletion -ErrorAction Stop
Write-Warning 'Review logs, then reboot DC01 manually and run validation.'
