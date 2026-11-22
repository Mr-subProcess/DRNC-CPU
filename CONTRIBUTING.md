# Contributing

Contributions are accepted for non-commercial research and evaluation only. This project does not accept changes intended for commercial manufacture, commercial deployment, or integration into commercial products or services.

## Before opening a pull request

1. Open an issue describing the problem, proposed change, and architectural impact.
2. Preserve all four two-bit payload symbols: `00`, `01`, `10`, and `11`.
3. Do not change AXI interface widths, `TUSER` layout, status values, or register semantics without updating the protocol, register map, software header, tests, and traceability matrix.
4. Add directed and randomized regression coverage for functional changes.
5. Run `make check`, `make rtl-test`, and `make rtl-lint` where the required tools are available. Include exact tool versions and complete logs.
6. Do not claim synthesis, timing closure, hardware reliability, or qualification without archived vendor-tool reports and physical test evidence.
7. Mark all modified source files and explain the reason for each change.

## Contribution terms

By submitting a pull request, you represent that you have the right to submit the contribution and agree that, if accepted, your contribution will be governed by the repository's `LICENSE` (RAQM Research-Only, Non-Commercial, No-Production License 1.0). Do not submit employer-owned, customer-owned, confidential, export-controlled, or third-party material without documented permission. The maintainers may request a separate signed contributor agreement before accepting substantial contributions.

Contributions do not grant or imply permission for commercial use or commercial production.
