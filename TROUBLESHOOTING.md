# Failure runbooks

All scenarios below are **DOCUMENTED ONLY**. Induce faults solely in snapshots of an isolated lab. Record pre-state, change, timestamps, output, rollback and screenshot after execution.

## 1. DNS misconfiguration blocks login
**Impact:** DC locator and Kerberos fail; users may see no logon server. **Diagnosis:** compare `ipconfig /all`, `Resolve-DnsName _ldap._tcp.dc._msdcs.corp.example.test -Type SRV`, `nltest /dsgetdc:corp.example.test`, and DNS event logs. **Root cause to test:** CLIENT01 points to external DNS. **Correction:** restore DC01/DC02 DNS addresses in DHCP/adapter, renew lease, flush DNS and retest secure channel. **Validation:** SRV targets and `nltest` resolve; synthetic account logs in. **Prevention:** DHCP option audit and DNS health alert.

## 2. GPO missing from workstation
**Impact:** baseline controls absent. **Diagnosis:** `gpresult /h result.html`, `gpupdate /force`, `Get-GPInheritance`, OU placement, WMI/security filter and SYSVOL access. **Root cause to test:** workstation in an unlinked OU. **Correction:** move synthetic machine to correct OU or repair link/filter. **Validation:** resulting set shows expected GPO and setting; capture `gpresult`. **Prevention:** OU placement checks in join process.

## 3. DC replication fails
**Impact:** inconsistent credentials, groups and DNS. **Diagnosis:** `repadmin /replsummary`, `repadmin /showrepl`, `Get-ADReplicationPartnerMetadata`, DNS/time/firewall checks. **Root cause to test:** isolated lab firewall blocks replication RPC. **Correction:** restore approved port policy, confirm DNS/time, retry replication. **Validation:** zero consecutive failures and replicated test object visible on both DCs. **Prevention:** replication alerts and configuration review.

## 4. Shared folder access lost
**Impact:** department cannot use files. **Diagnosis:** `whoami /groups`, `Get-SmbShareAccess`, `Get-Acl`, `Test-AtlasFileAccess`, access-based enumeration and Kerberos ticket. **Root cause to test:** domain local resource group removed from NTFS ACL. **Correction:** restore approved group ACL from baseline. **Validation:** affected synthetic user reads designated file and unauthorized user is denied. **Prevention:** ACL change audit and periodic effective-access tests.

## 5. DC unavailable
**Impact:** login resilience reduced; services may target failed DC. **Diagnosis:** `Get-AtlasDomainHealth`, client DNS list, `dcdiag /e`, `repadmin /replsummary`, FSMO holders. **Root cause to test:** DC01 VM powered off after a known-good backup. **Correction:** fail clients to DC02, restore DC01 if appropriate, verify replication before rejoining service. Do not seize FSMO unless DC01 is permanently lost. **Validation:** logon and DNS through DC02; both DCs healthy after recovery. **Prevention:** two DCs, backups and tested failover.
