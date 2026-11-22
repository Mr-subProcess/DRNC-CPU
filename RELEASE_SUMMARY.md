# RAQM Industrial G77M — Release 4.1.0 Summary

## Release identity

- Repository release: 4.1.0
- RTL architecture baseline: Rev 4.0
- Date: 2026-11-22
- Author: Oğuz Kağan Sayın
- License: RAQM Research-Only, Non-Commercial, No-Production License 1.0

## What is delivered

- SystemVerilog vector datapath, AXI4-Lite control/status slave, reset synchronizer, and separate scalar four-phase REQ/ACK reference modules.
- 256-bit AXI4-Stream interface carrying 128 two-bit lanes; `00`, `01`, `10`, and `11` are all valid payload values.
- Parallel B/C XOR transforms, selectable merge, optional previous-successful-vector feedback, output elastic register, and status reporting.
- AXI4-Lite MMIO register map and C bring-up example.
- Python reference model with directed and deterministic randomized tests.
- SystemVerilog testbenches and Icarus Verilog runner.
- Vivado RTL-only project script and Versal CIPS/NoC/AXI DMA integration guidance.
- Optional isolated KiCad maintenance-interface source and a blank vendor-controlled B2B pin-map template.
- Public-repository governance files, issue templates, CI workflow, custom restrictive license, and SHA-256 manifests.

## What is not delivered

- No general-purpose CPU instruction set or software toolchain.
- No clockless/QDI vector implementation; the vector datapath uses a PL clock and AXI valid/ready.
- No complete CIPS/NoC platform block design or AXI DMA integration.
- No validated G77M carrier-board schematic, physical pin assignment, PCB layout, or manufacturing package.
- No Vivado place-and-route, timing closure, power, thermal, EMC, or physical-hardware qualification report.
- No bitstream/PDI/XSA.

## Verification

`make check` was executed in the current preparation environment. Python tests: 21/21 passed. Python compile checks, C syntax checks, shell syntax checks, and static source-contract checks passed. Icarus Verilog, Verilator, and Vivado were unavailable in that environment; no RTL simulation, lint, FPGA synthesis, timing closure, or hardware qualification is claimed.

## Publication and use restriction

The repository is source-available for non-commercial research, education, peer review, and technical evaluation only. Commercial use and commercial production are expressly prohibited by `LICENSE`. This is not an OSI-approved open-source license.
