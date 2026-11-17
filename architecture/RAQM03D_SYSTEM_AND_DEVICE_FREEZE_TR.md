# RAQM-03D Sistem ve Cihaz Dondurma Notu

## 1. Cihaz kimliği

- FPGA aile/cihaz: AMD Artix-7 XC7A100T.
- Paket: FGG484.
- Tam sipariş kodu: açık — hız sınıfı ve sıcaklık eki kullanıcı tarafından verilmedi; satın alma öncesi stok ve sipariş kodu doğrulanmalı.
- PCIe hard block: PG054'te XC7A100T FGG484 kombinasyonu listeleniyor.
- PCIe ilk hedef: Gen1 x1 bring-up; uygun SI/termal/timing ölçümleri sonrası Gen2 hedefi.

## 2. PCIe transceiver eşlemesi

PG054 önerilen GT Lane 0 site: `X0Y7`; integrated PCIe block konumu `X0Y0`. Sağlanan pinout'ta GT channel 3 şu pinlere karşılık geliyor:

| PCIe net | FPGA signal | FGG484 ball | Site/use |
|---|---|---|---|
| TX0_P | MGTPTXP3_216 | D7 | GTPE2_CHANNEL_X0Y7 |
| TX0_N | MGTPTXN3_216 | C7 | GTPE2_CHANNEL_X0Y7 |
| RX0_P | MGTPRXP3_216 | D9 | GTPE2_CHANNEL_X0Y7 |
| RX0_N | MGTPRXN3_216 | C9 | GTPE2_CHANNEL_X0Y7 |
| REFCLK0_P | MGTREFCLK0P_216 | F6 | GTP REFCLK0 |
| REFCLK0_N | MGTREFCLK0N_216 | E6 | GTP REFCLK0 |
| RREF | MGTRREF_216 | F8 | 100Ω 1% to MGTAVTT |

PCIe TX AC coupling components are on the card transmitter path. PCIe RX input path should not receive unnecessary extra capacitors. Exact cap placement and value are finalised against the applicable PCIe CEM / AMD GTP board guide and link measurements.

## 3. RAQM I/O

Bank 13 is the chosen HR I/O bank for the first tile interface. `VCCO_13=3.3V` is a design target; all selected signals are LVCMOS33 candidates. The FPGA-side signals are single-ended CMOS logic into/out of level-adaptation blocks, not CML differential pins. Write-driver circuits create the differential CML base drive; receiver comparators convert cell outputs to FPGA-compatible 3.3V logic.

Assigned nets: `RAQM_B0_DATA`, `RAQM_B0_WE`, `RAQM_B1_DATA`, `RAQM_B1_WE`, `RAQM_B0_Q`, `RAQM_B1_Q`, `RAQM_REQ`, `RAQM_RESET_N`, `RAQM_ACK`, `RAQM_PAIR_VALID`, `RAQM_FAULT`, plus `PCIE_PERST_N`.

## 4. Power and GTP RREF

The pin map gives `MGTAVCC` balls D6, D10, F7, F9, E8 and `MGTAVTT` balls B5, B7, B9, B11, C4, C8. DS181 nominal values are 1.0V and 1.2V, respectively. `MGTRREF` F8 uses a 100Ω precision resistor to MGTAVTT as described in the 7-series GTP board guidance. Do not invent an RCAL pin: none is present in the supplied FGG484 pinout.

AMD advisory 51017 (2026-11-03) states the recommended GTP power-on orders are `VCCINT -> MGTAVCC -> MGTAVTT` or `MGTAVCC -> VCCINT -> MGTAVTT`; power-off is reverse. MGTAVTT must not precede the other two rails.

## 5. Configuration and flash

The design target is 3.3V Master SPI x4 using W25Q128JVSSM:
- `M[2:0]=001` (M2=0 at U9, M1=0 at U10, M0=1 at U11).
- `CFGBVS` U8 tied to `VCCO_0` when VCCO_0=3.3V.
- VCCO_0 (F12/T12)=3.3V, VCCO_14 (M14/P18/R15/T22/U19/Y20)=3.3V, flash VCC=3.3V.
- CCLK_0 L12; FCS_B T19; D00/MOSI P22; D01/DIN R22; D02 P21; D03 R21.
- DONE G11, INIT_B U12, PROGRAM_B N12.

External pull-ups, series resistors, PROGRAM_B reset network, flash timing and Vivado configuration settings must be closed in the electrical schematic review.

## 6. No false release

Pin assignment is substantially advanced but not final implementation. Vivado package database, PCIe IP generated XDC, DRC, timing, bitstream and KiCad ERC/DRC must confirm the result. No routed PCB/gerber or bench-tested PCIe endpoint is included.
