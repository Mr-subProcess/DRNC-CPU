#!/usr/bin/env python3
# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
"""Generate the RAQM-G77M isolated RS-485 maintenance interface schematic with SKiDL 3.

This is the small carrier-side interface sheet only. It is NOT the complete
iWave G77M 2x240-pin + 1x160-pin SOM carrier card.
"""
from pathlib import Path
import os

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "kicad" / "generated"
LIB = ROOT / "kicad" / "custom_lib" / "RAQM_Industrial.lib"
OUT.mkdir(parents=True, exist_ok=True)

# Kali/Debian KiCad package location. Override if KiCad is installed elsewhere.
if not os.environ.get("KICAD_SYMBOL_DIR"):
    for candidate in (Path("/usr/share/kicad/symbols"),
                      Path("/usr/local/share/kicad/symbols")):
        if candidate.is_dir():
            os.environ["KICAD_SYMBOL_DIR"] = str(candidate)
            break

from skidl import Part, Net, ERC, generate_netlist, generate_schematic, generate_svg, set_default_tool, KICAD10

set_default_tool(KICAD10)

# Use the custom library for every symbol in this small interface design.
# This avoids depending on symbol names in different KiCad releases.
def part(name: str, ref: str, value: str, footprint: str = ""):
    p = Part(str(LIB), name, value=value, footprint=footprint)
    p.ref = ref
    return p

# Isolated transceiver and protection.
u1 = part("ISOW1432", "U1", "ISOW1432DFMR",
           "Package_SO:SOIC-20W_7.5x12.8mm_P1.27mm")
d1 = part("SM712", "D1", "SM712-02HTG", "Package_TO_SOT_SMD:SOT-23")

# Passives.
r_en = part("R", "R1", "10k", "Resistor_SMD:R_0805_2012Metric")
r_term = part("R", "R2", "120R 1%", "Resistor_SMD:R_0805_2012Metric")

caps = []
for ref, value in (("C1", "100nF"), ("C2", "100nF"),
                   ("C3", "1uF"), ("C4", "10uF"),
                   ("C5", "100nF"), ("C6", "1uF"), ("C7", "10uF")):
    caps.append(part("C", ref, value, "Capacitor_SMD:C_0805_2012Metric"))

j_logic = part("Conn_01x06", "J1", "G77M_PL_IO",
               "Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical")
j_bus = part("Conn_01x03", "J2", "RS485_BUS", "")  # choose field terminal-block footprint for enclosure
j_term = part("Conn_01x02", "J3", "TERM_ENABLE_SHUNT",
              "Connector_PinHeader_2.54mm:PinHeader_1x02_P2.54mm_Vertical")

pwr_3v3 = part("PWR_FLAG", "#FLG01", "PWR_FLAG")
pwr_gnd = part("PWR_FLAG", "#FLG02", "PWR_FLAG")
pwr_iso_gnd = part("PWR_FLAG", "#FLG03", "PWR_FLAG")

# Nets: these names are also the labels expected in the board-level interface.
VIO_3V3 = Net("VIO_3V3")
GND_LOGIC = Net("GND_LOGIC")
ISO_3V3 = Net("ISO_3V3")
ISO_GND = Net("ISO_GND")
TXD = Net("TXD_FROM_FPGA")
RXD = Net("RXD_TO_FPGA")
TX_EN = Net("RS485_TX_ENABLE")
AUX_OUT = Net("ISOLATED_AUX_OUT")
BUS_A = Net("RS485_A")
BUS_B = Net("RS485_B")
TERM_A = Net("TERM_A")

# J1 pinout: 1=3V3, 2=GND, 3=TXD, 4=RXD, 5=TX_ENABLE, 6=AUX_OUT (U1 pin 7).
VIO_3V3 += j_logic[1], u1[1], u1[9], r_en[1], pwr_3v3[1]
GND_LOGIC += j_logic[2], u1[6], u1[10], pwr_gnd[1]
TXD += j_logic[3], u1[2]
RXD += j_logic[4], u1[4]
TX_EN += j_logic[5], u1[3], u1[5]
AUX_OUT += j_logic[6], u1[7]

# The auxiliary isolated input is intentionally held low; the output is exposed
# on J1 pin 6 for diagnostics. U1 pin 14 is the isolated-side GPIO input.
ISO_GND += u1[11], u1[13], u1[14], u1[15], j_bus[3], d1[3], pwr_iso_gnd[1]

# Enable the isolated DC/DC converter. EN/FLT is configured as an INPUT here,
# not as a fault output; R1 pulls it high to the logic-side supply.
r_en[2] += u1[8]

# Isolated supply: TI requires VISOOUT to be joined to VSOIN, and GND2 to GISOIN.
ISO_3V3 += u1[12], u1[16]

# Half-duplex wiring: tie driver Y to receiver A, and driver Z to receiver B.
BUS_A += j_bus[1], u1[17], u1[20], d1[1], r_term[1]
BUS_B += j_bus[2], u1[18], u1[19], d1[2], j_term[2]
TERM_A += r_term[2], j_term[1]

# Bypass capacitors. C1 is the VIO bypass; C2-C4 cover VDD side;
# C5-C7 are the VISOOUT/GND2-side local decoupling bank.
# Every capacitor pin 1 is positive/upper net, pin 2 is return.
VIO_3V3 += caps[0][1]
GND_LOGIC += caps[0][2]
for cap in caps[1:4]:
    VIO_3V3 += cap[1]
    GND_LOGIC += cap[2]
for cap in caps[4:7]:
    ISO_3V3 += cap[1]
    ISO_GND += cap[2]

# No automatic 120-ohm bus termination unless J3 is bridged. Fit the shunt only
# if this board is at a physical end of the RS-485 trunk.

# Run electrical checks and emit KiCad netlist, routed schematic, and matching SVG.
ERC()
generate_netlist(file=str(OUT / "RAQM_G77M_RS485_Interface.net"), tool=KICAD10)
generate_schematic(
    filepath=str(OUT),
    top_name="RAQM_G77M_RS485_Interface",
    title="RAQM Industrial G77M - Isolated RS-485 Maintenance Interface",
    tool=KICAD10,
    retries=4,
    auto_stub=False,
)
generate_svg(
    filepath=str(OUT),
    top_name="RAQM_G77M_RS485_Interface",
    tool=KICAD10,
    flatness=1.0,
)
print(f"Generated KiCad schematic and SVG under: {OUT}")
