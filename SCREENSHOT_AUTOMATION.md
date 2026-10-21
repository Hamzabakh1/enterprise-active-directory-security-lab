# Authentic screenshot workflow

A VirtualBox manager capture documents the DC01 VM shell before installation. Guest-only VirtualBox captures now document Windows Server installation and first boot. No authenticated AD service screenshot exists yet. The repository screenshot manifest keeps live AD evidence pending. Architecture diagrams are reference designs, not operational evidence.

## Capture tool evaluation

| Tool | Observed availability | Decision |
|---|---|---|
| PowerShell + Windows screen APIs | PowerShell 7 available; capture script parsed and `-WhatIf` produced no file | Primary method for a visible, approved lab console; real capture untested |
| Playwright | Python and Node packages not found | Install only if an approved browser test requires it |
| Hypervisor screenshot | VirtualBox 7.2.22 captured the booted DC01 guest framebuffer directly | Used for installation and first-boot evidence; use again for authenticated validation after guest setup |
| Python Pillow | Importable in bundled Python | Available for size/legibility checks, never to fabricate operational content |
| ImageMagick | `magick` command absent | Optional, not required |

## Reproducible procedure

1. Record the VM/server/tenant ID, UTC time, build and step in the project manifest before operating.
2. Capture prerequisite state and the exact command or UI action in an isolated lab.
3. Verify the expected change using a second check, such as DNS SRV lookup, `repadmin`, Exchange tracking, or Entra sign-in/export log.
4. Review the entire screen for real names, notifications, tokens, passwords and unrelated windows. Hide them before capture. Do not alter result text afterward.
5. Run `scripts/Capture-LabScreenshot.ps1 -ApprovedCapture -OutputPath <project>/docs/screenshots/<category>/<number-name>.png -Step <step> -SourceEnvironment <vm>` on the approved visible lab screen. The script records a sidecar JSON with SHA-256 and UTC time.
6. Open the PNG, verify readable framing and redact only sensitive material in an auditable way. If redaction would change the operational conclusion, discard the screenshot and recapture safely.
7. Add caption and verification command to the manifest and link the screenshot from the related procedure. Keep architecture diagrams in `assets/diagrams/`.

Suggested capture methods: VirtualBox guest framebuffer capture for the local VM; PowerShell screen API for a visible approved lab console; Playwright only for owned browser UIs with a logged-in, approved test account. The guest is installed, but operational AD and tenant UIs have not been validated.
