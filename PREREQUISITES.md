# Prerequisites

**Status: HOST HYPERVISOR INSTALLED; guest media and OS pending.** Use licensed Windows Server 2025 or 2022 media and isolated, non-routable lab networking. Reserve separate disks and adequate RAM for each VM; recheck sizing against current Microsoft guidance and host overhead. At the owner's request, DC01 is set to the Microsoft-listed 2 GiB minimum for Windows Server 2025 Server Core; the full topology still needs more memory. Free host memory was insufficient at the last check, so even this smaller VM should not start until more memory is available. Prepare DC01, DC02, FS01, MGMT01 and CLIENT01 with time synchronization, static DC IPs and DNS pointing at the lab DCs. Obtain local Administrator and lab domain administrator credentials. Do not reuse production credentials.

PowerShell 5.1, ADDSDeployment, ActiveDirectory, GroupPolicy, DNS tools, `dcdiag` and `repadmin` are needed on relevant server roles or RSAT. Pester 5 and PSScriptAnalyzer are recommended for CI parity; Pester 3.4 is currently installed locally. Confirm `corp.example.test` is isolated before calling installation scripts.

[Microsoft AD DS deployment requirements](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-).
