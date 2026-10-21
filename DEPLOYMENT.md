# Isolated deployment procedure

**Status: WINDOWS SERVER INSTALLED; initial Administrator password and forest configuration pending.** `Atlas-DC01` runs Windows Server 2025 Standard Evaluation (Server Core) in VirtualBox with 2 GiB RAM, two vCPUs, BIOS firmware, a 64 GiB dynamic disk and an internal-only `atlas-lab` network. The official evaluation ISO was fully downloaded and verified before installation. EFI boot stopped before displaying the installer; BIOS boot worked and the guest reached its first-boot password prompt on 2026-10-21. Set the Administrator password directly in the VM; never put it in repository files or chat. The host has limited free memory, so run additional VMs only when resources permit. See the [prerequisite checklist](PREREQUISITES.md) and [screenshot manifest](SCREENSHOT_MANIFEST.md).

1. Create isolated VMs and segmented switches. Replace example `192.0.2.0/24` addresses with a real private lab range. Set DC01 static IP and DNS to itself, configure reliable time and take a pre-promotion checkpoint only for short-lived lab rollback.
2. On DC01, inspect `scripts/installation/Install-DC01.ps1`, run `-WhatIf`, then execute with `-ApprovedLab` and interactive confirmation. Supply DSRM password securely. Review logs and reboot manually.
3. Validate `Get-ADDomain`, `_ldap._tcp.dc._msdcs.corp.example.test` SRV response, `dcdiag /e /c`, SYSVOL and NETLOGON shares.
4. Join DC02 to the lab domain, set DNS to DC01, inspect `Install-DC02.ps1`, use `-WhatIf`, execute with `-ApprovedLab`, review logs and reboot.
5. Validate `repadmin /replsummary`, `Get-ADReplicationPartnerMetadata`, DNS zones on both DCs and client discovery. Configure DC DNS preferred/alternate values according to tested site behavior.
6. Configure OUs and groups through `AtlasAD.psm1`, dry-run provisioning, then provision synthetic accounts with a securely entered initial password.
7. Configure DHCP on an approved server, authorize it in AD, scope workstation addresses only, and set options 006 to DC DNS and 015 to `corp.example.test`. Validate lease and DNS from CLIENT01.
8. Configure GPOs, file groups, permissions, auditing and backups as described in configuration and security docs. Test from CLIENT01 and capture evidence.

Promotion is a privileged operation that restarts services and changes directory state; execute only after an operator confirms target and backup plan.
