# Verification Status — Repository Release 4.1.0 / RTL Baseline Rev 4.0

Last local preparation run: 2026-11-22.

## Executed and passed in the preparation environment

Command: `make check`

- Python bytecode compilation: PASS.
- C bring-up example syntax check (`gcc -std=gnu11 -Wall -Wextra -Werror -fsyntax-only`): PASS.
- Shell script syntax checks (`bash -n`): PASS.
- Static source-contract preflight: PASS.
- Custom license and release-file check: PASS.
- Python reference regression: 21/21 tests PASS.
- Deterministic randomized property test: 2,000 iterations over 128 two-bit lanes, included in the Python test suite.

The result above validates the software reference model and repository checks only.

## Not executed in the preparation environment

- Icarus Verilog/SystemVerilog simulation and elaboration: not run; `iverilog` was unavailable.
- Verilator lint: not run; `verilator` was unavailable.
- Formal verification, assertion-based proof, CDC analysis, and reset-domain analysis: not run.
- Vivado synthesis, implementation, place-and-route, timing closure, XSA/PDI/bitstream generation: not run; Vivado was unavailable.
- CIPS/NoC/AXI DMA platform integration: not completed.
- KiCad optional maintenance-interface generation/ERC: not run.
- Carrier-board schematic/layout, SI/PI, thermal, EMC/ESD, BER, environmental, and physical hardware tests: not performed.

## Required before performance or qualification claims

Follow [`VALIDATION_PLAN.md`](VALIDATION_PLAN.md). In particular, run `make rtl-test` and `make rtl-lint`, synthesize the exact iWave-confirmed part with the supported Vivado release, close timing after implementation, and perform documented physical tests.

No operating frequency, throughput, power, reliability, or industrial qualification result is claimed by this repository release.
