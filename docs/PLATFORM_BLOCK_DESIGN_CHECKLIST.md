# Versal CIPS / NoC / AXI DMA block-design checklist

This is a guided platform-integration checklist, not a board-validated Vivado Tcl script. The G77M carrier board, exact module order code and complete connector pinout must be obtained from iWave before physical I/O or power planning.

## A. Establish the exact target

- Obtain the purchased iG-G77M variant, full SoC order code, speed grade, temperature grade and datasheet revision in writing.
- In the matching Vivado release, run `get_parts *xc2ve3858*ssva2112*`.
- Set `RAQM_VERSAL_PART` to the exact catalog string confirmed against the delivered module.
- Do not use a VEK385 evaluation-board part string or guessed speed grade.

## B. Create the Versal platform shell

1. Create a new Versal project for the confirmed `PART`.
2. Add CIPS and configure the intended APU/RPU boot and management interfaces according to the G77M BSP and current AMD UG1305.
3. Enable a PL fabric clock; begin functional bring-up at 100 MHz only as a conservative starting target, not as a guaranteed maximum.
4. Expose one common PL clock for RAQM AXI4-Lite and AXI4-Stream.
5. Use the CIPS/Processor System Reset chain to generate the active-low reset. Connect it to `aresetn_async`; RAQM synchronizes deassertion internally.
6. Add `raqm_versal_g77m_top` as a module reference or package it as a custom IP.

## C. Connect the control plane

- CIPS `M_AXI_FPD` → AXI SmartConnect → RAQM `S_AXI`.
- Keep the RAQM register bank and stream core in the same `aclk` domain.
- Assign the RAQM register range in Address Editor and copy the actual assigned base address into the software build as `RAQM_BASE_ADDR`.
- Do not copy the illustrative `0xA0000000` syntax-check address into a real design unless Vivado assigns that address.

## D. Connect the data plane

- Configure AXI DMA MM2S/S2MM for 256-bit AXI4-Stream where supported by the selected IP/device configuration.
- DMA `M_AXIS_MM2S` → RAQM `S_AXIS`.
- RAQM `M_AXIS` → DMA `S_AXIS_S2MM`.
- Confirm TKEEP is all ones for the prototype's fixed 32-byte beats. A partial TKEEP beat is returned as an error beat with zero TDATA and status `0x04`.
- Ensure TLAST is generated and consumed consistently with the packet length programmed in DMA.
- For first bring-up, use `CTRL.CFG_OVERRIDE=1` and configure a fixed operation through `CFG`; do not assume the DMA generates RAQM command TUSER values.
- Check whether the selected DMA configuration preserves output TUSER. If it does not, collect status through AXI-Lite counters/last-status or add an explicit metadata path.

## E. Connect memory through NoC

- Configure AXI NoC/DDR using the current iWave platform design or a matching vendor reference design.
- Connect DMA memory-mapped masters to the intended NoC slave interfaces and DDR controller through the generated platform topology.
- Do not hard-code NoC connectivity properties copied from a different Versal board.
- Establish cache maintenance/coherency rules for DMA buffers in the APU software.

## F. Validate before hardware use

- Run block-design validation and resolve all critical warnings.
- Generate output products and the platform XSA.
- Run synthesis, implementation and timing analysis with the exact speed specification supported by the selected part.
- Check all unconstrained paths; add interface timing constraints only from the actual platform clocks and interface timing requirements.
- Run AXI protocol checking or AMD AXI VIP where available.
- Test reset assertion/release, stream backpressure, packet boundaries, DMA alignment, cache coherency, counters and error reporting.
- Archive the XSA, Vivado version, exact part string, XDC, implementation reports and software image hash.

## G. Not included in this prototype package

No complete CIPS/NoC block design, XSA, DMA configuration, carrier-board schematic, physical B2B pin mapping, GTYP/PCIe/MAC/PCS design, final package-pin XDC, bitstream/PDI or board-level SI/PI/thermal/EMC result is provided.
