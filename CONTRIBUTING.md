# Contributing

This repository is an infrastructure lab blueprint with verified offline checks and documented live procedures. Keep every change reproducible and label its evidence precisely.

1. Use synthetic identities, documentation addresses, and isolated systems. Never add credentials, tokens, tenant IDs, production data, or private host telemetry.
2. Preserve guarded defaults and require explicit target selection and human confirmation for infrastructure changes. Keep the `corp.example.test` guard, `-ApprovedLab`, confirmation, and secure password handling in every live directory write. Preserve the distinction between offline tests and AD integration.
3. Run the repository's offline test suite and syntax checks before proposing changes. Record the exact command, timestamp, and result in the validation report.
4. Add only authentic screenshots from an approved lab. Record source, date, verification scope, and hash in `SCREENSHOT_MANIFEST.md`; do not substitute diagrams or rendered transcripts for live evidence.
5. Review documentation links, current Microsoft support requirements, and license compatibility before publication.
