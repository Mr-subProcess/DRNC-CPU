# Changelog

## 4.1.0 — 2026-11-22

- Prepared a GitHub-oriented, English-only repository distribution.
- Added the custom RAQM Research-Only, Non-Commercial, No-Production License 1.0.
- Explicitly prohibited commercial use, commercial manufacturing, commercial pilot production, commercial product integration, sale, and commercial deployment.
- Added publication guidance, third-party notices, issue templates, contribution terms, and release governance.
- Added a release/license preflight target and Verilator lint command.
- Clarified that the RTL architecture remains Rev 4.0; this is a repository/release hardening update, not a claim of new silicon or a hardware-qualified revision.

# Changelog

## Rev 4 — 2026-11-22

- Standardized product stream interface with TKEEP and output TUSER status.
- Added rejection of partial/invalid TKEEP on fixed-width vector beats.
- Isolated legacy scalar REQ/ACK and UART maintenance modules from the product vector top.
- Added AXI4-Lite SLVERR for unmapped, unaligned and access-type-invalid register accesses.
- Gated AXI-Lite READY signals during reset and made responses stable under backpressure.
- Restricted Vivado part query to XC2VE3858/SSVA2112 and required exact part selection.
- Added deterministic 2,000-case Python vector property regression, source preflight, and GitHub Actions workflows.
- Added platform handoff and release-readiness documentation.

## Rev 3 — 2026-11-22

- Added AXI4-Lite management registers, vector datapath, feedback control, counters and top-level integration candidate.
