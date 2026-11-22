# Validation Plan and Release Gates

This plan defines evidence required before the prototype can be described as an implemented FPGA design. A passing software reference model is not an RTL or hardware qualification result.

## Gate 0 — Source integrity

- [x] Python reference model and deterministic randomized tests.
- [x] Static source-contract checks.
- [x] C MMIO syntax check.
- [ ] CI green on the public repository.

## Gate 1 — RTL simulation and lint

- [ ] Icarus Verilog regression for the vector core, AXI-Lite slave, scalar reference core, reset synchronizer, and product-top elaboration.
- [ ] Verilator lint with every warning resolved or documented.
- [ ] Add assertions for AXI output stability under backpressure.
- [ ] Verify no input beat is lost or duplicated during simultaneous output retirement and input acceptance.
- [ ] Verify feedback updates only after successful processing and is not changed by rejected beats.
- [ ] Verify reset assertion and synchronous release at clock boundaries.
- [ ] Compare RTL outputs against the Python reference model over directed and randomized vectors.

## Gate 2 — Vendor synthesis

- [ ] Confirm exact G77M SOM SKU, SoC part, speed grade, temperature grade, memory configuration, and connector revision in controlled iWave documentation.
- [ ] Build with the vendor-supported Vivado release for that exact part.
- [ ] Review synthesis warnings, inferred latches, CDC reports, utilization, timing constraints, and timing summary.
- [ ] Confirm every required clock and path is constrained; no unintended unconstrained path remains.

## Gate 3 — Platform integration

- [ ] Add Versal CIPS and configure PS/APU/RPU as required.
- [ ] Add clocks/resets and define their ownership and domain relationships.
- [ ] Add NoC and DDR path.
- [ ] Integrate AXI DMA MM2S/S2MM and SmartConnect.
- [ ] Map AXI-Lite register bank into the processor address space.
- [ ] Define interrupt behavior or explicitly document polling-only operation.
- [ ] Export XSA and record Vivado/Vitis versions and platform hashes.

## Gate 4 — Implementation and timing

- [ ] Run place-and-route for the exact target.
- [ ] Close setup/hold timing at the selected PL clock.
- [ ] Review congestion, clock utilization, routing, and critical paths.
- [ ] Measure or estimate power using the vendor flow and realistic switching activity.
- [ ] Archive post-route timing and utilization reports.

## Gate 5 — Physical board validation

- [ ] Obtain controlled G77M connector pinouts and approved reference-carrier documents.
- [ ] Complete power-tree, sequencing, inrush, thermal, and mechanical design.
- [ ] Complete schematic ERC and PCB DRC.
- [ ] Validate JTAG, reset, UART/maintenance, and DMA loopback.
- [ ] Test all four two-bit symbols in every lane.
- [ ] Run long-duration randomized traffic with stalls/backpressure.
- [ ] Record throughput, latency, error counts, power, temperature, and interface integrity.
- [ ] Complete required EMC/ESD/environmental testing before any industrial qualification claim.

## Gate 6 — Release

- [ ] Freeze source commit, exact SOM SKU, carrier revision, and BOM.
- [ ] Archive source SHA-256, XSA/bitstream hashes, tool versions, logs, and test reports.
- [ ] Close every applicable gate above or clearly mark the release as experimental and incomplete.
- [ ] Confirm the custom non-commercial/no-production license is included in the release archive.
