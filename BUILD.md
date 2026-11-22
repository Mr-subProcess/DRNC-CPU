# Build, Test, and Tool Setup

## 1. Requirements

- Python 3.10 or later
- GNU Make
- GCC or a compatible C compiler
- Icarus Verilog for the SystemVerilog regression
- Verilator for optional RTL lint
- AMD Vivado 2026.1 or a later release that supports the exact selected XC2VE3858 device grade
- KiCad and SKiDL/Schematizer only for the optional maintenance-interface sheet

## 2. Python and source checks

Debian/Kali example:

```bash
sudo apt update
sudo apt install -y python3 python3-venv make gcc
python3 -m venv .venv
. .venv/bin/activate
python -m pip install --upgrade pip
make check
```

`make check` runs Python bytecode compilation, C syntax checks, shell syntax checks, static source-contract checks, release/license checks, and the Python reference regression.

## 3. SystemVerilog simulation

```bash
sudo apt install -y iverilog
make rtl-test
```

The Icarus runner tests the vector datapath, AXI4-Lite control, scalar REQ/ACK reference, reset synchronizer, and product-top elaboration.

## 4. Optional Verilator lint

```bash
sudo apt install -y verilator
make rtl-lint
```

Lint output is a review artifact, not proof of equivalence or timing closure. Resolve all warnings relevant to the selected tool version or document justified waivers.

## 5. Optional KiCad maintenance-interface sheet

This is an isolated maintenance-interface sub-sheet and not the carrier-board schematic or compute datapath.

```bash
python -m pip install -r requirements.txt
export KICAD_SYMBOL_DIR=/usr/share/kicad/symbols
make schematic
```

## 6. Vivado RTL synthesis

First inspect the installed device catalog inside Vivado Tcl:

```tcl
get_parts *xc2ve3858*ssva2112*
```

Set only the exact part string confirmed by iWave for the actual SOM SKU, speed grade, and temperature grade:

```bash
export RAQM_VERSAL_PART='EXACT_VENDOR_CONFIRMED_PART_STRING'
vivado -mode batch -source vivado/create_project.tcl
```

The Tcl creates an RTL-only project and launches synthesis. It does not build the CIPS/NoC platform, connect AXI DMA, assign physical B2B connector pins, configure GTYP, generate an XSA/PDI/bitstream, perform place-and-route, or certify timing closure.

## 7. Archive test evidence

For any release candidate, archive:

- exact source commit and SHA-256 manifest;
- simulator, lint, synthesis, and implementation tool versions;
- full logs and exit codes;
- synthesis utilization and post-route timing reports;
- CDC/reset analysis;
- power and thermal reports;
- board revision, SOM order code, connector pinout revision, and hardware test records.
