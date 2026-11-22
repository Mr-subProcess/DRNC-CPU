#!/usr/bin/env python3
# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
"""Static source-contract checks for RAQM Rev 4 release packaging."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
ERRORS: list[str] = []


def require(condition: bool, message: str) -> None:
    if not condition:
        ERRORS.append(message)


def read(rel: str) -> str:
    path = ROOT / rel
    require(path.is_file(), f"Missing required file: {rel}")
    return path.read_text(encoding="utf-8") if path.is_file() else ""


rtl_top = read("rtl/raqm_versal_g77m_top.sv")
rtl_core = read("rtl/raqm_vector_core.sv")
rtl_axil = read("rtl/raqm_axil_ctrl.sv")
tcl = read("vivado/create_project.tcl")
protocol = read("docs/PROTOCOL.md")
constraints = read("constraints/raqm_g77m_template.xdc")
active_xdc = "\n".join(line.split("#", 1)[0] for line in constraints.splitlines())

# The product top must expose standard full-beat AXI4-Stream sidebands.
for token in ("s_axis_tdata", "s_axis_tkeep", "s_axis_tuser", "s_axis_tlast",
              "m_axis_tdata", "m_axis_tkeep", "m_axis_tuser", "m_axis_tlast"):
    require(token in rtl_top, f"Top-level stream contract missing {token}")
require("m_axis_tstatus" not in rtl_top, "Legacy non-standard m_axis_tstatus remains in product top")
require("m_axis_tkeep" in rtl_core and "s_axis_tkeep" in rtl_core,
        "Vector core is missing TKEEP handling")
require("STATUS_BAD_TKEEP" in rtl_core, "TKEEP rejection status is missing")

# Product top is intentionally the vector datapath only. Legacy scalar UART is not
# instantiated by the product RTL wrapper.
for legacy in ("raqm_packet_engine", "uart_rx", "uart_tx", "raqm_core"):
    require(legacy not in rtl_top, f"Legacy/reference module {legacy} unexpectedly instantiated in product top")

# AXI-Lite safety/quality checks.
for token in ("write_addr_valid", "read_addr_valid", "2'b10", "s_axi_bresp", "s_axi_rresp"):
    require(token in rtl_axil, f"AXI-Lite response validation missing {token}")
require("aresetn && !aw_captured" in rtl_axil,
        "AXI-Lite AWREADY must be low during reset")
require("aresetn && !w_captured" in rtl_axil,
        "AXI-Lite WREADY must be low during reset")
require("aresetn && !s_axi_rvalid" in rtl_axil,
        "AXI-Lite ARREADY must be low during reset")

# Device/project configuration must be narrowed to the package in G77M module docs.
require("xc2ve3858*ssva2112" in tcl.lower(),
        "Vivado part query must be narrowed to XC2VE3858/SSVA2112")
require("RAQM_VERSAL_PART" in tcl,
        "Vivado script must require explicit exact SoC part string")
require("PACKAGE_PIN" not in active_xdc and "IOSTANDARD" not in active_xdc,
        "Do not ship unverified board package-pin or I/O-bank constraints")
require((ROOT / "kicad/G77M_B2B_PINMAP_TEMPLATE.csv").is_file(),
        "Blank vendor-controlled G77M B2B pin-map template is missing")
require(not (ROOT / "kicad/G77M_B2B2_GTYP205_PINMAP.csv").exists(),
        "Unverified example GTYP pin-map file must not be shipped")
require("aresetn_async" in rtl_top, "Product wrapper must expose the documented active-low reset port")
require("tkeep" in protocol.lower() and "0x04" in protocol.lower(),
        "Protocol documentation must describe fixed-width TKEEP error handling")

# Minimum release/documentation files for a reviewable handoff.
for rel in ("README.md", "LICENSE", "LICENSE-STATUS.md", "CHANGELOG.md",
            "sim/tb_raqm_reset_sync.sv", "docs/ARCHITECTURE.md", "docs/AXIL_REGISTER_MAP.md",
            "docs/PROTOCOL.md", "docs/REQUIREMENTS_TRACEABILITY.md",
            "docs/VERSAL_PLATFORM_INTEGRATION.md", "docs/VERIFICATION_STATUS.md",
            "docs/RELEASE_CHECKLIST.md", ".github/workflows/ci.yml"):
    read(rel)

for forbidden in ("README_TR.md", "RUN_KALI.md", "RELEASE_SUMMARY_TR.md",
                  "vivado/README_TR.md", "docs/REV3_CHANGELOG_TR.md"):
    require(not (ROOT / forbidden).exists(), f"Non-English legacy file remains: {forbidden}")

if ERRORS:
    print("RAQM preflight FAILED:")
    for err in ERRORS:
        print(f" - {err}")
    sys.exit(1)

print("RAQM Rev 4.1 source-contract preflight: PASS")
print("Note: this is a static source check, not RTL simulation, synthesis or hardware qualification.")
