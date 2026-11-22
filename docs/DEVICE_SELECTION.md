# G77M device and order-code selection record

## Identified module candidate

The current iWave product listing identifies the iG-G77M AI Edge Gen 2 SOM as compatible with XC2VE3858, XC2VE3804, XC2VE3558 and XC2VE3504 variants. Distributor catalogs list the manufacturer part number `iG77M-3858E2-4E008G-E032G-IAA`; Mouser describes it as an XC2VE3858, -2 speed module with PS/PL memory and industrial-grade marketing designation. DigiKey lists the same MPN as an active marketplace product. This is a credible procurement candidate, not a substitute for the controlled iWave order acknowledgement and hardware pack.

The preliminary iWave G77M Datasheet REL0.1 (17 September 2025) has an `Ordering Information` table marked `TBD`, so the PDF revision in the archive is not sufficient to freeze the BOM. The distributor records also disagree on the minimum operating temperature: DigiKey lists -40 °C while Mouser lists -20 °C, both with +85 °C maximum. Obtain the controlled iWave datasheet and written confirmation of the exact temperature grade, installed memory configuration, connector/board revision and order code before making an industrial-temperature claim.

## FPGA part and Vivado

The G77M compatibility matrix identifies the XC2VE3858 family and SSVA2112 package. AMD DS1021 Revision 1.5 (9 October 2026) gives minimum Vivado/speed-spec releases that depend on the XC2VE3858 speed grade and operating voltage: the table lists Vivado 2025.2 v2.00 for some production configurations and Vivado 2026.1 v2.02 for others. Rev 4's project script conservatively requires Vivado 2026.1 or later and filters the installed catalog to XC2VE3858/SSVA2112, but still requires the exact full part string to be selected from the local `get_parts` catalog and confirmed against the purchased SOM.

Do not substitute a VEK385 evaluation-board part string or invent the suffix. Use: `get_parts *xc2ve3858*ssva2112*`. Then set `RAQM_VERSAL_PART` only to the exact installed catalog entry that matches the delivered SOM.

## Evidence links

- iWave G77M AI Edge Gen 2 product page: https://iwave-global.com/all-products/amd/
- DigiKey listing for `iG77M-3858E2-4E008G-E032G-IAA`: https://www.digikey.com/en/products/detail/iwave-global/iG77M-3858E2-4E008G-E032G-IAA/29366194
- Mouser listing for the same MPN: https://www.mouser.com/en/ProductDetail/iWave-Global/iG77M-3858E2-4E008G-E032G-IAA
- AMD DS1021 production silicon/software status: https://docs.amd.com/r/en-US/ds1021-versal-ai-edge-gen2/Production-Silicon-and-Software-Status

The exact full part, temperature grade, power limits and SOM connector mapping remain procurement/vendor-controlled facts.
