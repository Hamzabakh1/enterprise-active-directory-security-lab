# Prerequisites

**Status: DC01 GUEST INSTALLED; initial Administrator password pending.** Windows Server 2025 Standard Evaluation (Server Core) is installed on the isolated `Atlas-DC01` VM. Its 2 GiB RAM allocation matches Microsoft's listed minimum; the full topology still needs more memory. The host has limited free memory, so run additional VMs only when resources permit. Before domain promotion, set the guest's Administrator password, rename the guest to `DC01`, configure a static private lab IP and DNS, and verify time synchronization. Prepare DC02, FS01, MGMT01 and CLIENT01 separately as capacity allows. Never reuse production credentials.

PowerShell 5.1, ADDSDeployment, ActiveDirectory, GroupPolicy, DNS tools, `dcdiag` and `repadmin` are needed on relevant server roles or RSAT. Pester 5 and PSScriptAnalyzer are recommended for CI parity; Pester 3.4 is currently installed locally. Confirm `corp.example.test` is isolated before calling installation scripts.

[Microsoft AD DS deployment requirements](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-).
