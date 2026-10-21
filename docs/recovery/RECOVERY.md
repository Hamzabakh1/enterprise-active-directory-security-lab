# Backup and disaster recovery design

**Status: DOCUMENTED ONLY.** Schedule System State backups on both DCs to protected off-host storage and file-level/application-aware backups for FS01. Encrypt backup media, restrict restore rights, and verify restore points. A VM snapshot alone is not a backup strategy.

For an isolated nonauthoritative restore, document failed DC identity and last healthy replication, restore supported System State, start directory services and let partners replicate. For an accidentally deleted object, evaluate AD Recycle Bin first; if unavailable, plan an authoritative restore with `ntdsutil` in DSRM. Never perform an authoritative restore in the same exercise as an unverified replication fault. If all DCs are lost, follow Microsoft forest recovery guidance, reset affected secrets and reconstruct trust in order. Record RPO/RTO targets only after tests measure them.

[Microsoft AD forest recovery guidance](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/forest-recovery-guide/ad-forest-recovery-guide).
