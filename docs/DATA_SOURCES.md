# External design references (reviewed 22 November 2026)

1. AMD, Versal AI Edge Series Gen 2 DS1021, Production Silicon and Software Status, Revision 1.5, released 9 October 2026: https://docs.amd.com/r/en-US/ds1021-versal-ai-edge-gen2/Production-Silicon-and-Software-Status
   - XC2VE3858 production speed-grade support depends on grade/voltage and minimum Vivado/speed-spec version. Current DS1021 lists 2026.1 v2.02 for some XC2VE3858 production configurations; refer to the exact current table before timing sign-off.
2. AMD, Versal Embedded Design Tutorial UG1305, 2026.1: https://docs.amd.com/r/en-US/ug1305-versal-embedded-tutorial/Configuring-CIPS-PS-PL-interface
   - CIPS PS-PL AXI, PL clock and reset configuration; use the matching tutorial for the installed Vivado release.
3. AMD, Versal Embedded Design Tutorial UG1305, 2026.1, Configuring PL Hardware: https://docs.amd.com/r/en-US/ug1305-versal-embedded-tutorial/Configuring-PL-Hardware
   - SmartConnect, processor system reset, PS-PL clocking and AXI peripheral automation examples.
4. iWave, iG-RainboW-G77M Versal AI Edge Gen2 SOM Datasheet, REL0.1, 17 September 2025, 84 pages: https://mm.digikey.com/Volume0/opasdata/d220001/medias/docus/8914/iG-RainboW-G77M-Datasheet.pdf
   - Page 15: device comparison and 2VE3858/SSVA2112 compatibility.
   - Page 81: Ordering Information table presently shows `TBD`; confirm full orderable SKU directly with iWave.
   - The available PDF is a preliminary REL0.1 datasheet and carries a proprietary notice. Treat it as engineering reference only; obtain the current controlled iWave documentation for hardware release.
5. AMD, VEK385 Board User Guide UG1712: https://docs.amd.com/ (reference only; do not substitute VEK385 board pinout for G77M carrier pinout).

No web reference replaces the controlled datasheet, hardware manual, full connector tables or written BOM confirmation for the specific G77M SOM delivered to the project.

6. iWave Global, iG-G77M AI Edge Gen 2 SOM product page: https://iwave-global.com/all-products/amd/
   - Current product listing identifies the iG-G77M AI Edge Gen2 variant as compatible with 2VE3858 / 2VE3804 / 2VE3558 / 2VE3504 devices. Confirm the purchased SKU and controlled hardware-document revision directly with iWave.
7. AMD, Versal Embedded Design Tutorial UG1305, 2026.1 — Configuring NoC and CIPS: https://docs.amd.com/r/en-US/ug1305-versal-embedded-tutorial/Configuring-NoC-and-CIPS
   - Official reference for CIPS and NoC/DDR block-design configuration. The RAQM package does not provide a generated XSA.

8. DigiKey Marketplace, iWave MPN `iG77M-3858E2-4E008G-E032G-IAA`: https://www.digikey.com/en/products/detail/iwave-global/iG77M-3858E2-4E008G-E032G-IAA/29366194
   - Current catalog entry lists the manufacturer MPN and gives a -40 °C to +85 °C operating-temperature range. Confirm against iWave's controlled datasheet because another distributor's catalog currently differs.
9. Mouser, iWave MPN `iG77M-3858E2-4E008G-E032G-IAA`: https://www.mouser.com/en/ProductDetail/iWave-Global/iG77M-3858E2-4E008G-E032G-IAA
   - Lists the same MPN and describes it as XC2VE3858, -2 speed, industrial grade; its listed minimum temperature differs from DigiKey's. Treat distributor attributes as a prompt for vendor confirmation, not as a controlled specification.
