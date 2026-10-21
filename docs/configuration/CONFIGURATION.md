# Configuration walkthrough — 20 modules

All listed server operations are **DOCUMENTED ONLY** until performed on an isolated lab. Offline scripts are **IMPLEMENTED** where named.

| # | Module | Action and validation |
|---|---|---|
| 1 | Windows Server | Install supported edition, patch, set hostname/IP/time; capture `Get-ComputerInfo` and update status. |
| 2 | AD DS | Install AD-Domain-Services with management tools; inspect event logs and role state. |
| 3 | Primary DC | Promote DC01 to `corp.example.test`; verify SYSVOL, NETLOGON, DNS and `dcdiag`. |
| 4 | Additional DC | Promote DC02; verify writable GC, DNS and `repadmin /replsummary`. |
| 5 | DNS | AD-integrated zone, secure dynamic updates, SRV lookups, approved forwarders; test both DCs. |
| 6 | DHCP | Authorize isolated DHCP server, workstation scope and DNS options; inspect a CLIENT01 lease. |
| 7 | OU design | Run `New-AtlasOrganizationalUnits -WhatIf`, inspect, then create protected OUs. |
| 8 | RBAC groups | Run `New-AtlasSecurityGroups`; create domain local resource groups manually, apply AGDLP. |
| 9 | Provisioning | Generate/validate `users-200.csv`, supply `SecureString`, use `Import-AtlasUsers -WhatIf`, then inspect accounts/group memberships. The 200 rows are not provisioned yet. |
| 10 | GPO | Define baseline and workstation GPOs, link to proper OUs; inspect `gpresult /h`. |
| 11 | Account policy | Set domain password/lockout and fine-grained policies only after risk review; test with lab users. |
| 12 | File ACL | On FS01 apply department domain local groups to shares and NTFS; verify effective access. |
| 13 | FSMO | Run `Get-AtlasFSMORoles` and compare `netdom query fsmo`; document holder placement. |
| 14 | Replication | Run `Get-AtlasReplicationHealth`, `repadmin /showrepl`, inspect failure counts. |
| 15 | Delegation | Delegate narrowly scoped OU tasks, verify denied privileged operations from delegated identity. |
| 16 | Auditing | Enable relevant advanced audit subcategories and centralize event logs; validate test events. |
| 17 | Backup | Schedule protected System State and file backups, inspect job result and restore media. |
| 18 | DR | Rehearse an isolated nonauthoritative restore and separately plan authoritative object recovery. |
| 19 | Hardening | Review LDAP signing/channel binding, SMB, NTLM, LAPS, admin tiering and patch state. |
| 20 | Reporting | Export inventory, privileged membership, inactivity, DNS, GPO and ACL reports. |

This is an implementation checklist. A command appearing here is not evidence it ran.
