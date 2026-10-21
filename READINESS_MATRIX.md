# Implementation readiness matrix

| Capability | Classification | Evidence / next requirement |
|---|---|---|
| Architecture, synthetic datasets, offline validation, documentation, diagrams | READY | Local toolchain works |
| Local Git repositories and version history | READY | Git installed |
| Pester 3 smoke tests | READY | Pester 3.4.0 installed |
| Pester 5 and PSScriptAnalyzer CI parity | REQUIRES_CONFIGURATION | Install approved versions or use hosted CI after publication |
| VirtualBox Windows Server lab | PARTIALLY_READY | VirtualBox 7.2.22 installed; `Atlas-DC01` configured as a 2 GiB Server Core pilot on an isolated internal network; no installed guest or complete ISO |
| Full reference topology on this host | BLOCKED_BY_HARDWARE | Current host memory insufficient for simultaneous servers, especially Exchange |
| AD DS deployment and screenshots | REQUIRES_USER_ACCESS | Complete official Windows Server media, guest installation, guest credentials and sufficient free host RAM |
| Exchange SE deployment and DAG | BLOCKED_BY_HARDWARE | Dedicated supported server capacity, media and licenses |
| Exchange Online / hybrid operations | REQUIRES_USER_ACCESS | Tenant, roles, verified domain and licensed services |
| Conditional Access and PIM | REQUIRES_LICENSE | Verify Entra P1/P2 entitlements before operations |
| Real mail delivery, synchronization and sign-in evidence | REQUIRES_USER_ACCESS | Isolated tenant and network connection |
| GitHub publishing | REQUIRES_USER_ACCESS | Explicit owner authorization after final review |
| Docker engine tests | REQUIRES_CONFIGURATION | Start/configure daemon; no need for current offline checks |
| Third-party skill installation | UNSUPPORTED in current scope | No blind installation; repository review required first |
