# AD architecture

**Status: DOCUMENTED ONLY.** The shared [address plan](ARCHITECTURE_OVERVIEW.md) defines four segments. DC01 (192.0.2.10) and DC02 (.11) are DNS and Global Catalog peers. Clients receive only DC addresses as DNS servers. External names use approved DNS forwarders; the `.test` namespace never leaves the lab. FS01 (.40) hosts data, MGMT01 (.70) is the admin path, and CLIENT01 (.100) validates policy.

## Object model

One top-level OU per department plus Groups, Workstations, Servers and Service Accounts. Global department groups are `GG-<Department>-Users`. Resource permissions follow AGDLP: accounts → global groups → domain local resource groups → permissions. The automation currently provisions global groups; resource-specific domain local groups and ACLs are configuration steps, not implemented code. Privileged tiers should isolate DC administration from workstation administration.

## Authentication and trust

Client DHCP points to AD DNS; DNS SRV records locate a DC; Kerberos obtains a TGT then service ticket; LDAP queries obtain directory attributes; SMB to FS01 evaluates share and NTFS ACLs. No external forest trust is configured. Entra is a separate trust boundary planned by project 3.

## Availability

Two writable DCs host DNS and GC. Replication health and SYSVOL are checked before considering a DC healthy. Backups include System State, protected off-host storage and restore rehearsal. FSMO roles are identified before transfer or seizure; seize only after a permanently failed holder is confirmed.

## Network policy

Allow only documented AD ports between members and DCs, replication between DCs, SMB to FS01, and privileged management from MGMT01. Exact firewall rules must be derived from the deployment's Microsoft port matrix and then tested. Never open all east/west traffic to make a lab test pass.

See [Mermaid source](assets/diagrams/ad-topology.mmd).
