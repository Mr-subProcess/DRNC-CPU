# Vivado RTL Synthesis Flow — RAQM G77M

The product top contains the 256-bit AXI4-Stream vector datapath and AXI4-Lite control IP. Scalar REQ/ACK and UART reference modules are intentionally excluded from the product synthesis source list.

## Device selection

The preliminary iWave G77M REL0.1 documentation identifies XC2VE3858 / SSVA2112 compatibility. The orderable product details and exact speed/temperature grade must be confirmed against a controlled current iWave document and the actual SOM label. Never guess a full Vivado part string.

Inspect the installed device catalog:

```tcl
get_parts *xc2ve3858*ssva2112*
```

Export the exact vendor-confirmed device part and run:

```bash
export RAQM_VERSAL_PART='EXACT_VENDOR_CONFIRMED_PART_STRING'
vivado -mode batch -source vivado/create_project.tcl
```

The script creates an RTL-only project and runs synthesis/report generation. It does not create CIPS/NoC, connect AXI DMA, configure GTYP/MAC/PCS, assign carrier I/O pins, implement/place-route, write an XSA/PDI/bitstream, or establish timing closure.

See [`../docs/VERSAL_PLATFORM_INTEGRATION.md`](../docs/VERSAL_PLATFORM_INTEGRATION.md) and [`../docs/PLATFORM_BLOCK_DESIGN_CHECKLIST.md`](../docs/PLATFORM_BLOCK_DESIGN_CHECKLIST.md).
