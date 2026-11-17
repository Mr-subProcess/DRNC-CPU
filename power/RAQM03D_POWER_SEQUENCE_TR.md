# RAQM-03D Güç Ağı ve Açılış Sırası

## Nominal rail hedefleri

| Rail | Nominal hedef | Açıklama |
|---|---:|---|
| VCCINT | 1.00V | Core |
| VCCBRAM | 1.00V | Block RAM |
| VCCAUX | 1.80V | FPGA auxiliary |
| MGTAVCC | 1.00V | GTP analog |
| MGTAVTT | 1.20V | GTP termination |
| VCCO_0 | 3.30V | Configuration/JTAG |
| VCCO_13 | 3.30V | RAQM LVCMOS33 bank |
| VCCO_14 | 3.30V | Master SPI x4 multifunction bank |
| Flash VCC | 3.30V | Winbond W25Q128JVSSM |

Current budgets are **not assigned** by this table. They must come from AMD Power Design Manager using the actual clocking, utilization, transceiver configuration, I/O loading, temperature and speed-grade parameters.

## GTP order

AMD Advisory 51017 (2026-11-03):
- Valid recommended power-on sequence A: VCCINT, then MGTAVCC, then MGTAVTT.
- Valid recommended power-on sequence B: MGTAVCC, then VCCINT, then MGTAVTT.
- VCCINT and MGTAVCC may ramp simultaneously.
- Power-off sequence is the reverse of the selected power-on sequence.
- Do not turn on MGTAVTT ahead of VCCINT/MGTAVCC. The advisory quantifies potentially large transient extra MGTAVTT current if the required order is violated.

Use PG/supervisor gating, verify monotonic ramps, and capture rail waveforms at the FPGA pins during first power-up. Exact current limit, decoupling values, regulator compensation and thermal calculations remain open.

## RREF

FGG484 MGTRREF ball F8; use 100Ω, 1% precision resistor to MGTAVTT as indicated by UG482 GTP guidance. Keep the node local and follow the vendor analog layout/decoupling recommendation. The exact resistor TCR, wattage and placement must be included in the final schematic/layout review.
