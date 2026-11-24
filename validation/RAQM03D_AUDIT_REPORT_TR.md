# RAQM-03D Pin/Net Denetim Raporu

## Kontroller

- Device/package identity in supplied pinout: `XC7A100T / FGG484`.
- Extracted relevant pin-ball rows: 106.
- Duplicate ball numbers in extracted relevant set: 0.
- Bank13 user I/O assignments: 12; all are unique and share bank 13.
- PCIe Lane 0 GT pins: TX D7/C7, RX D9/C9; REFCLK0 F6/E6; RREF F8.
- PCIe x1 recommended site according to PG054: X0Y7; integrated PCIe hard block X0Y0.
- GTP supply balls: MGTAVCC 5; MGTAVTT 6.
- Core/BRAM/aux power balls extracted from supplied table: VCCINT 14, VCCBRAM 3, VCCAUX 5.
- QSPI/strap mapping extracted: CCLK, FCS_B, D00..D03, M[2:0], CFGBVS.
- Bank13 XDC includes PACKAGE_PIN and LVCMOS33 assignments for 12 ports.

## Limits

- This report audits only the relevant extraction, not all original 484 signal/NC records.
- Unfilled coordinates in the 484-row template are not asserted to be NC or unused.
- No Vivado DRC, timing, synthesis or bitstream run.
- No KiCad ERC/DRC run; current KiCad project sheets remain engineering diagrams/annotations rather than a pin-connected electrical schematic.
- No PCB routing, Gerber, CAM approval or physical PCIe link test.

**Result:** pinout-integrated engineering candidate; not fabrication release.
