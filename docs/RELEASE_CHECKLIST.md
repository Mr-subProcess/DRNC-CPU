# Release Checklist

## Repository and licensing

- [ ] Confirm all files intended for publication are authored by the project owner or have compatible redistribution permission.
- [ ] Confirm no secrets, credentials, private keys, customer data, employer-owned files, or confidential vendor material are present.
- [ ] Include the root `LICENSE` file: RAQM Research-Only, Non-Commercial, No-Production License 1.0.
- [ ] Make the commercial-use and commercial-production prohibition visible in the README and repository description.
- [ ] Do not describe this project as OSI-approved open source.
- [ ] Confirm contribution terms and third-party notices.
- [ ] Review `GITHUB_PUBLISHING.md` and repository visibility settings.

## Software and RTL

- [ ] `make check` passes.
- [ ] `make rtl-test` passes with archived Icarus Verilog version and logs.
- [ ] `make rtl-lint` passes or all warnings are documented.
- [ ] Protocol, register map, software header, requirements traceability, and tests are updated together after interface changes.
- [ ] No latches or unintended combinational loops are reported.
- [ ] Output stability under backpressure and reset behavior are verified.

## FPGA platform

- [ ] Exact iWave SOM order code, SoC part, speed grade, temperature grade, RAM configuration, and connector revision are confirmed from controlled documents.
- [ ] Vendor-supported Vivado version is used.
- [ ] CIPS/NoC/AXI DMA platform is integrated and reviewed.
- [ ] Synthesis and implementation reports are archived.
- [ ] Timing constraints cover all intended paths; timing closure is demonstrated.
- [ ] Power and thermal budgets are validated.

## Physical prototype

- [ ] Carrier schematic ERC and PCB DRC pass.
- [ ] Controlled B2B connector pinout is used; no placeholder pin map is treated as real hardware data.
- [ ] Power sequencing, inrush, reset, JTAG, and maintenance interfaces are tested.
- [ ] Four-symbol lane tests, randomized traffic, backpressure, and long-duration tests pass.
- [ ] EMC/ESD/environmental evidence is archived if qualification is claimed.

## Evidence and release archive

- [ ] Source commit and SHA-256 manifest are recorded.
- [ ] Tool versions and complete logs are archived.
- [ ] XSA/PDI/bitstream hashes are recorded if generated.
- [ ] The release summary accurately distinguishes completed, pending, and untested work.
