# RAQM-03D — Shareable Technical Review Brief

**Project:** Recurrent Asynchronous Qudit Mesh (RAQM) PCIe Accelerator  
**Revision:** 03D — XC7A100T-FGG484 pinout integration  
**Date:** 18 November 2026  
**Status:** Engineering review candidate — NOT RELEASED FOR FABRICATION

## Purpose

Integrate the reported two-cell RAQM core into a desktop PCIe add-in accelerator. The mechanical target is a PCIe x1 edge connector suitable for a compatible x16-length slot; electrically, the first endpoint is x1. PCIe endpoint logic is clocked in the FPGA/PCIe domain, while the RAQM cell fabric remains asynchronous and uses REQ/ACK. The PCIe reference clock is not distributed into the RAQM core.

## Device and PCIe lane

- FPGA target: AMD Artix-7 XC7A100T, FGG484 package. Exact speed/temperature ordering suffix remains open.
- AMD PG054 lists PCIe integrated-block location X0Y0 and recommended x1 Lane 0 GT site X0Y7 for XC7A100T FGG484.
- The user-provided pinout maps the selected GT channel 3 as TX D7/C7, RX D9/C9, REFCLK0 F6/E6, and MGTRREF F8.
- 100Ω, 1% MGTRREF resistor to MGTAVTT is a design candidate subject to final AMD UG482 layout review.
- Gen1 x1 is the initial bring-up target. Gen2 must remain gated on SI, timing and host enumeration evidence.

## RAQM interface and power

Twelve Bank 13 HR I/O assignments are planned as LVCMOS33 with VCCO_13=3.3V. External differential write drivers and comparator/level adaptation are mandatory between FPGA I/O and CML cells. No FPGA pin may connect directly to a 5V CML node or transistor base without a verified interface circuit. External pull resistors maintain safe WRITE/REQ/reset states while FPGA I/Os are high impedance.

Nominal rail targets: VCCINT/VCCBRAM 1.0V, VCCAUX 1.8V, MGTAVCC 1.0V, MGTAVTT 1.2V, selected VCCO banks 3.3V. Final regulator sizing requires AMD Power Design Manager. Follow AMD Advisory 51017: MGTAVTT must not precede VCCINT and MGTAVCC.

Master SPI mode uses M[2:0]=001. Quad width is separately selected with `BITSTREAM.CONFIG.SPI_BUSWIDTH=4`. PUDC_B at U22 must never float; the proposed default is a 1kΩ connection to VCCO_14. If battery-backed AES key retention is not used, UG470 permits VCCBATT to be tied to GND or VCCAUX; this revision proposes a 0Ω option to GND.

## Package contents

The package includes the full RAQM-03C ZIP as baseline, extracted relevant pin assignments, a 484-position coordinate grid, GT lane mapping, Bank 13 XDC, SPI/configuration map, power matrices, candidate BOM, KiCad page/annotation files, diagrams, validation gates, checksums and source notes.

## Release limitations

The pinout extract contains 106 relevant pin rows from the supplied pinout, not a reconstructed full 484-ball vendor CSV. Unfilled grid positions are `UNASSIGNED`, not NC. The KiCad files are system-level/annotation drafts, not a fully wired electrical schematic. Vivado and KiCad CLI checks were not run. There is no completed PCB routing, Gerber/ODB++, bitstream, power report, physical PCIe enumeration or independent prototype test record in this package.

**Disposition:** Share for architecture and pinout review only. Do not fabricate or plug into a host PC until the open release gates are closed.
