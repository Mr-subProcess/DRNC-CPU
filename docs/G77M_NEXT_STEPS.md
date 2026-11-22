# RAQM G77M development sequence after Rev 4

1. **RTL regression:** Icarus regression, randomized software-vs-RTL comparison, Verilator lint, reset and backpressure checks.
2. **IP boundary review:** confirm AXI4-Stream width/sidebands and AXI4-Lite register behavior in the chosen Vivado release.
3. **Versal platform:** create CIPS/clock/reset, NoC path and AXI DMA; connect SmartConnect to RAQM control.
4. **Memory/software:** implement DMA buffers, cache maintenance, descriptors/interrupts and a Vitis/Linux user-space or kernel driver.
5. **Timing/resource:** synthesize, pipeline only based on timing reports, implement/place-route, timing/power/congestion reports.
6. **G77M carrier:** freeze exact SOM SKU, controlled connector pinouts, bank voltages, power sequence, thermal path and mating connectors.
7. **Physical validation:** board bring-up, JTAG, DMA loopback, random data comparison, long-duration traffic, thermal and interface signal-integrity tests.
8. **Release:** tag source commit, store tool versions/XSA/bitstream hashes, test reports, BOM and manufacturing files; close every applicable release checklist item.
