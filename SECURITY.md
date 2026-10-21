# Security model and review

The automation refuses any domain other than `corp.example.test`; user status and password resets additionally require a `lab.*` identity. Mutating commands support `-WhatIf` and confirmation. No password is stored in CSV or Git. Passwords enter as `SecureString`, and new users must change them at first logon. Every live action requires an isolated target review.

Production adaptations require replacing the hard-coded lab guard with an approved inventory, least-privilege service identities, secure secret storage and access review. Group membership is audited, but actual alerting and privileged access controls are pending a live deployment. `Get-AtlasInactiveAccounts` is a candidate report only; `LastLogonDate` can be delayed and must not be used alone for automatic disablement.

Threats reviewed: credential exposure in command lines or screenshots, accidental target mismatch, excessive group privilege, stale identities, broad SMB access, unaudited delegation and untested backup. Review result: local scripts have safety gates; live controls are **BLOCKED**. No security sign-off for production use is implied.
