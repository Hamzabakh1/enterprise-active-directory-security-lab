# Build environment and verification scope

This repository was developed and tested on a Windows workstation in October 2026. The public report omits personal device identifiers and local resource telemetry. The verification scope and source references are recorded below.

| Capability | Verified status |
|---|---|
| PowerShell | Windows PowerShell 5.1 and PowerShell 7 available; scripts parsed without errors |
| Python | Bundled Python 3.12 used for offline tests |
| Git | Local version history and clean commits |
| Virtualization | Oracle VirtualBox 7.2.22 installed; an isolated `Atlas-DC01` VM shell exists without a guest OS |
| Windows Server media | Official evaluation ISO download incomplete; no OS installation performed |
| Active Directory | No forest, DC health, replication or GPO integration test performed |
| Exchange Server SE | No supported Exchange server or mail delivery test available |
| Entra / Microsoft 365 | Test tenant access, roles and licenses not verified |
| Screenshots | A real DC01 VM setup capture is included; no operational service screenshot exists |

The reference topology requires more memory and licensed services than this workstation can provide concurrently. All current PASS results in this repository are offline tests. Live integration and recovery checks remain pending. Never connect the fictional `corp.example.test` namespace or synthetic identities to a production environment.

## Sources

- [Windows Server 2025 hardware requirements](https://learn.microsoft.com/en-us/windows-server/get-started/hardware-requirements?pivots=windows-server-2025)
- [AD DS deployment](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
- [Exchange supportability matrix](https://learn.microsoft.com/en-us/exchange/plan-and-deploy/supportability-matrix)
- [Entra Connect prerequisites](https://learn.microsoft.com/en-us/entra/identity/hybrid/connect/how-to-connect-install-prerequisites)
