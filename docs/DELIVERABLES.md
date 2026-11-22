# RAQM G77M Rev 4 package contents

- `rtl/raqm_versal_g77m_top.sv`: product IP boundary with AXI4-Lite and standard AXI4-Stream TKEEP/TUSER/TLAST ports.
- `rtl/raqm_vector_core.sv`: 128-lane, 256-bit vector fork/join, selectable B/C XOR transforms, feedback and elastic output stage.
- `rtl/raqm_axil_ctrl.sv`: control/status slave, independent AW/W capture, byte strobes, response stability, SLVERR on invalid access, counters.
- `rtl/raqm_reset_sync.sv`: asynchronous reset assertion / synchronous deassertion.
- `rtl/raqm_core.sv`: separate scalar four-phase REQ/ACK reference core; not instantiated in the product vector top.
- `rtl/uart_rx.sv`, `uart_tx.sv`, `raqm_packet_engine.sv`: optional standalone scalar maintenance reference modules; not in product top or synthesis file list.
- `tests/`: Python bit-accurate reference models, 21 unittest regression including deterministic randomized 128-lane coverage.
- `sim/`: SystemVerilog vector, AXI-Lite, scalar reference and reset synchronizer testbenches and Icarus runner.
- `.github/workflows/ci.yml`: Python preflight/regression and Icarus simulation CI.
- `docs/REQUIREMENTS_TRACEABILITY.md`: requirement-to-implementation/evidence matrix.
- `docs/BUILD_ENVIRONMENT.txt`: exact local tool inventory and executed validation commands.
- `sw/`: MMIO register header and initial bare-metal example; DMA driver/address map must come from the generated platform/XSA.
- `vivado/create_project.tcl`: synthesizes the RTL IP boundary for the exact XC2VE3858/SSVA2112 Vivado part selected by environment variable.
- `constraints/`: timing template only; no board pin assignments or bank I/O standards.
- `docs/VERSAL_PLATFORM_INTEGRATION.md` and `docs/PLATFORM_BLOCK_DESIGN_CHECKLIST.md`: CIPS, SmartConnect, AXI DMA and NoC integration plan/checklist.
- `kicad/`: optional isolated ISOW1432 RS-485 maintenance interface sub-sheet generator and a blank G77M B2B pin-map template; no unverified SOM connector pin assignments are provided.

Not included: written iWave confirmation of the candidate SOM MPN/speed/temperature grade, full controlled carrier pinout, complete CIPS/NoC platform BD, AXI DMA configured platform, GTYP/MAC/PCS/PCIe, final XDC, full G77M carrier schematic/PCB, SI/PI, place-route timing closure, bitstream/PDI, thermal/EMC qualification or physical test evidence.

- `RELEASE_SUMMARY.md`, `RELEASE_MANIFEST.md`, `VERSION`, `SHA256SUMS`: review handoff and release integrity records.
