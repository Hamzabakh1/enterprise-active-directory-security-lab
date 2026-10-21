# Run only on an isolated, approved, domain-joined Windows Server VM named DC02.
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param([Parameter(Mandatory)][switch]$ApprovedLab)
if (-not $ApprovedLab -or $env:COMPUTERNAME -ne 'DC02') { throw 'Requires -ApprovedLab on DC02.' }
if (-not $PSCmdlet.ShouldProcess('DC02', 'Install AD DS role and promote replica DC')) { return }
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -ErrorAction Stop
$dsrm = Read-Host 'DSRM password' -AsSecureString
$credential = Get-Credential -Message 'Lab domain administrator'
Install-ADDSDomainController -DomainName 'corp.example.test' -Credential $credential -InstallDns -SafeModeAdministratorPassword $dsrm -NoRebootOnCompletion -ErrorAction Stop
Write-Warning 'Review logs, then reboot DC02 manually and validate replication.'
