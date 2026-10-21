# Validation report — 2026-10-21

Execution environment: non-administrator Windows NT build 10.0.26200 x64 host; PowerShell 7.6.5, Pester 3.4.0. Evidence was generated locally on 2026-10-21; latest Pester run was at 06:09 UTC. No AD DS instance was connected.

| Test | Expected | Actual | Environment | Timestamp UTC | Evidence | Status |
|---|---|---|---|---|---|---|
| PowerShell parser (5 files) | Zero errors | Zero errors | Local PowerShell 7.6.5 | 2026-10-21 05:17 | [parser.txt](tests/evidence/parser.txt) | PASS |
| Pester offline contract and mocked WhatIf (4 tests) | 4 pass | 4 pass, 0 fail | Local Pester 3.4.0 | 2026-10-21 06:09 | [pester.txt](tests/evidence/pester.txt) | PASS |
| Synthetic CSV validation | 6 unique lab users, allowed departments | 6 valid users | Local PowerShell 7.6.5 | 2026-10-21 05:17 | [csv.json](tests/evidence/csv.json) | PASS |
| 200-person generator unit suite | 2 pass | 2 pass, exit 0 | Local Python 3.12.14 | 2026-10-21 05:52 | [unittest.txt](tests/evidence/unittest.txt) | PASS |
| 200-person CSV validation | 200 unique lab users, allowed departments | 200 valid users | Local PowerShell 7.6.5 | 2026-10-21 05:52 | [csv-200.json](tests/evidence/csv-200.json) | PASS |
| AD integration | DC health, replication, GPO and ACL results | Not executed; no isolated domain | VirtualBox DC01 VM shell exists, but no guest OS or complete ISO | N/A | [environment audit](ENVIRONMENT_AUDIT.md) | BLOCKED |
| Failure scenarios | Five faults corrected and verified | Not executed; no isolated domain | Windows Server lab unavailable | N/A | [runbooks](TROUBLESHOOTING.md) | BLOCKED |
| PSScriptAnalyzer lint | Zero blocking findings | Not executed; module absent | Local host | N/A | [environment audit](ENVIRONMENT_AUDIT.md) | BLOCKED |

These offline tests verify syntax, guard behavior and dataset shape. They do not establish that AD deployment, replication, GPO, permissions or recovery work.

## Gate review

Architecture, deployment instructions, automation, local test evidence, security review, README, interview material and limitations are present. Authentic AD screenshots and integration/DR evidence are blocked by unavailable lab infrastructure. A 90/100 technical score cannot be supported yet; no numeric score is assigned.
