# XC7A100T-FGG484 — Master SPI x4 Konfigürasyon Planı

## Mod ve veri genişliği birbirinden ayrı ayarlanır

- 7-series configuration mode strap: `M[2:0]=001` = Master SPI.
- SPI x4 veri genişliği ayrıca bitstream/Vivado ayarıdır: `BITSTREAM.CONFIG.SPI_BUSWIDTH 4`.
- Bu nedenle M[2:0]=001 tek başına x4 seçimi olarak yorumlanmamalıdır; x1/x2/x4 bus-width ayarı bitstream konfigürasyonunda yapılır.
- Flash W25Q128JVSSM kapasitesi 128 Mbit olduğundan 128-Mbit/16-MB sınıfı için 24-bit adres yeterli hedef olarak planlanmıştır; `SPI_32BIT_ADDR` kapalı kalır. Exact flash datasheet ve Vivado config akışıyla doğrulanmalı.

## Mode straps

| Pin | Ball | Value | Candidate resistor |
|---|---|---:|---|
| M2 | U9 | 0 | 4.7k to GND |
| M1 | U10 | 0 | 4.7k to GND |
| M0 | U11 | 1 | 4.7k to VCCO_0 |
| CFGBVS | U8 | VCCO | Direct to VCCO_0, when VCCO_0=3.3V |
| PUDC_B | U22 | 1 | 1.0k to VCCO_14; never float |

UG470 identifies PUDC_B as active-low pull-up-during-configuration. Low enables internal pull-ups on SelectIO pins; high disables them. The pin must be tied directly or through a resistor no greater than 1k to VCCO_14 or GND. This board's default proposal is 1k to VCCO_14 (pull-ups disabled), paired with external default resistors on RAQM control signals so no spurious WRITE/REQ occurs while FPGA I/Os are high-Z.

## 3.3V configuration voltage domain

- `VCCO_0=3.3V`; `CFGBVS=VCCO`.
- `VCCO_14=3.3V`.
- Flash VCC candidate: 3.3V-compatible `W25Q128JVSSM`.
- Vivado properties to set/check: `CFGBVS=VCCO`, `CONFIG_VOLTAGE=3.3`, `BITSTREAM.CONFIG.SPI_BUSWIDTH=4`, `BITSTREAM.CONFIG.SPI_32BIT_ADDR=No`.

## Pin map

| Function | FPGA ball | Flash / board |
|---|---|---|
| CCLK | L12 | Flash CLK |
| FCS_B | T19 | Flash /CS, external 4.7k pull-up to VCCO_14 candidate |
| D00/MOSI | P22 | Flash SI / IO0 |
| D01/DIN | R22 | Flash SO / IO1 |
| D02 | P21 | Flash IO2 / WP# multiplex |
| D03 | R21 | Flash IO3 / HOLD# multiplex |
| DONE | G11 | 4.7k pull-up to VCCO_0 candidate |
| INIT_B | U12 | 4.7k pull-up to VCCO_0 candidate; retain status visibility |
| PROGRAM_B | N12 | 4.7k pull-up; reset pushbutton/test pad to GND |
| PUDC_B | U22 | 1.0k to VCCO_14 default; option to GND only after startup policy review |

`VCCO_0`, `VCCO_14`, CFGBVS and flash VCC must be mutually compatible. Series damping resistors on CCLK/DQ are footprints/options to be tuned after edge/ringing measurement, not fixed production values.

## Power-up fail-safe defaults

- `PUDC_B` U22 must be tied to VCCO_14 or GND through no more than 1k; default assembly proposes 1k to VCCO_14 to disable internal pull-ups.
- External pulldowns on RAQM WE0/WE1, RESET_N and REQ prevent an unintended action while FPGA pins are tri-stated.
- `PCIE_PERST_N` input has only a weak 100k pulldown candidate; final loading and host pull-up behavior must be checked against PCIe CEM.
- FCS_B, INIT_B, DONE and PROGRAM_B pull-up values are candidates and must be checked against UG470 and the exact flash input thresholds.
- PUDC_B is not allowed to float at any time before or during configuration.

## VCCBATT

E12 is VCCBATT_0. If battery-backed AES key retention is not used, UG470 permits connecting VCCBATT to GND or VCCAUX. This revision's default proposal is a 0-ohm option link to GND. If encrypted bitstream key retention is later required, the board power design must be intentionally revised for a backup source; do not populate a battery by default.

The flash exact ordering suffix, QE bit behavior, ID support, boot timings and configuration-rate margin require final W25Q128JVSSM datasheet review and a real power-up boot test before release.
