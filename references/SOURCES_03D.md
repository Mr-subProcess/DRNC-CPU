# Sources and Provenance — RAQM-03D

1. AMD PG054, Artix-7 Devices / recommended GT locations: https://docs.amd.com/r/en-US/pg054-7series-pcie/Artix-7-Devices  
   Used for XC7A100T FGG484 support and recommended GT Lane 0 location (X0Y7). The exact IP constraints must still be checked against generated Vivado output.
2. AMD PG054, Available Integrated Blocks: https://docs.amd.com/r/en-US/pg054-7series-pcie/Available-Integrated-Blocks-for-PCIe  
   Used for PCIe hard-block availability/package-bonding caution and Gen2 capability limits.
3. AMD UG475 v1.20, 7 Series Packaging and Pinout: https://docs.amd.com/api/khub/documents/kHyYQ6XzXnQwR2O~gaV~MQ/content  
   Package pinout conventions and FGG484 device diagram. The actual signal-to-ball extraction in this package is based on the user-pasted pinout table.
4. AMD DS181, Artix-7 DC/AC characteristics: https://docs.amd.com/api/khub/documents/iAkxxTOk96ANLJqYf2hgrQ/content  
   Nominal 1.0V MGTAVCC and 1.2V MGTAVTT, plus standard Artix-7 rail characteristics.
5. AMD Advisory 51017, Artix-7 GTP power sequencing (released 2026-11-03): https://docs.amd.com/r/en-US/51017/Solution  
   GTP recommended sequence VCCINT/MGTAVCC before MGTAVTT and reverse power-off.
6. AMD UG912 CFGBVS property: https://docs.amd.com/r/2022.1-English/ug912-vivado-properties/CFGBVS  
   CFGBVS=VCCO for 3.3V/2.5V bank-0 configuration support; CFGBVS=GND for 1.8V/1.5V.
7. AMD XAPP586 SPI Flash configuration interface: https://docs.amd.com/r/en-US/xapp586-spi-flash/SPI-Flash-Configuration-Interface  
   VCCO_0, VCCO_14, CFGBVS and flash supply voltage alignment; pull-up/series resistor notes.
8. AMD AC701 UG952 configuration example: https://docs.amd.com/api/khub/documents/9uY8E5K7FZWRB1nL_I4sRg/content  
   7-series Master SPI mode example uses M[2:0]=001; used as a reference, not as a pinout authority for this package.
9. Winbond 2025 Code Storage Flash Product Selection Guide: https://www.winbond.com.tw/export/sites/winbond/product-selection-guide/file/2025-Product-Selection-Guide-Winbond-Code-Storage-Flash-Memory.pdf  
   W25Q128JVSSM listed as 128-Mbit, 2.7–3.6V, SOP-8 208mil, SPI/Dual/Quad, mass production P.
10. AMD UG470 PUDC_B configuration pin definition: https://docs.amd.com/api/khub/documents/FOs3lXmlcWxBhTIFxVKyGA/content
    PUDC_B is active-low; it must be tied via <=1k to VCCO_14 or GND, never left floating.
11. AMD UG908 7-Series Bitstream Settings: https://docs.amd.com/r/en-US/ug908-vivado-programming-debugging/7-Series-Bitstream-Settings
    Master SPI x4 is set by BITSTREAM.CONFIG.SPI_BUSWIDTH=4; M[2:0]=001 selects the Master SPI mode.
12. Xilinx/AMD 7-Series GTP Transceivers UG482; accessible rehosted guide: https://www.digikey.co.uk/Site/Global/Layouts/DownloadPdf.ashx?pdfUrl=2C325503ECB648C09FAF80B257E06828  
    Used as GTP RREF guidance; 100Ω precision resistor to MGTAVTT is also represented on established 7-series transceiver designs. Recheck against current official UG482 revision before fabrication.

The user supplied the `XC7A100T FGG484` pinout output in the conversation. All listed ball assignments in the relevant-pinout CSV are copied from that user-provided table, not inferred from a generic package or a different device.
