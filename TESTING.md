# Test strategy

**Offline:** parse every PowerShell script; run Pester 3 unit checks (module exports, domain guard, no password column, mocked WhatIf with zero OU creation); test deterministic generation and department distribution of 200 synthetic users; validate CSV uniqueness and department membership. These tests do not prove AD behavior.

**Integration in future isolated lab:** deploy DC01/DC02, compare `dcdiag` and replication metadata, create then verify synthetic identities, test GPO and ACLs from CLIENT01, induce each runbook fault, restore and capture timestamps. Require separate operator approval for DC promotion, fault injection and restore. Use Pester 5 and PSScriptAnalyzer once installed or in CI; record exact versions.

**Security review:** inspect for plaintext secrets, domain guard bypasses, overprivileged accounts and logging of secure values. **Documentation check:** validate relative links and statuses. See [validation report](VALIDATION_REPORT.md) for actual execution.
