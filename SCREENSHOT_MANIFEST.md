# Screenshot manifest

A local VirtualBox manager screenshot documents the VM before installation. Guest-only VirtualBox captures document installation progress and first boot. The initial Administrator password has not been set, and no domain or authenticated management console has been validated. Planned operational entries become verified only after actual lab execution.

| Filename | Lab step | Capture method | Source environment | Date | Verification | Related document |
|---|---|---|---|---|---|---|
| `assets/screenshots/virtualbox-dc01-configuration.jpg` | DC01 VM shell, powered off, optical drive empty | Local VirtualBox manager | Host workstation | 2026-10-21 | VERIFIED — setup only; no guest OS | PREREQUISITES.md |
| `docs/screenshots/installation/01-windows-server-installation.png` | Windows Server 2025 Standard Evaluation installation at 45% | VirtualBox guest framebuffer (`screenshotpng`) | Isolated Atlas-DC01 VM | 2026-10-21 | VERIFIED — installation progress; SHA-256 `879213D55EE49DDAF18924BFAA8527030A0DAB95C8CAF6C19E03CE26723D9E6E` | DEPLOYMENT.md |
| `docs/screenshots/installation/02-windows-server-first-boot.png` | First-boot Administrator password prompt | VirtualBox guest framebuffer (`screenshotpng`) | Isolated Atlas-DC01 VM | 2026-10-21 | VERIFIED — guest booted; no password shown; SHA-256 `473A300B50A788F347379BFD55F8287793959C32E10A76806A189076A7F1073F` | DEPLOYMENT.md |
| `01-domain-controller-installation.png` | DC01 role and promotion | Pending | Isolated DC01 VM | Pending | BLOCKED | DEPLOYMENT.md |
| `02-active-directory-domain-creation.png` | Domain check | Pending | Isolated DC01 VM | Pending | BLOCKED | DEPLOYMENT.md |
| `03-dns-zone-configuration.png` | DNS SRV validation | Pending | Isolated DC01/DC02 VM | Pending | BLOCKED | TROUBLESHOOTING.md |
| `04-organizational-units.png` | OU provisioning | Pending | Isolated MGMT01 VM | Pending | BLOCKED | docs/configuration/CONFIGURATION.md |
| `05-group-policy-validation.png` | gpresult proof | Pending | Isolated CLIENT01 VM | Pending | BLOCKED | TROUBLESHOOTING.md |

Folders under `docs/screenshots/` are reserved for installation, configuration, validation, troubleshooting, security and recovery. Do not place conceptual images there.

The verified setup capture is 770 × 750 pixels. Its SHA-256 is `E378AE4686BF6BDB3556DFCF0359E039FB7DBAE7068A8EEE65A1206C3CA23712`. It was captured directly from the VirtualBox manager without compositing or content edits.
