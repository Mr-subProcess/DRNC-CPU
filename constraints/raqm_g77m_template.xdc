# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
# Timing TEMPLATE for the RAQM RTL IP wrapper, not a board pin file.
# aclk must be driven by the CIPS PL clock / approved Clocking Wizard output.
# This file intentionally contains no PACKAGE_PIN, IOSTANDARD or GTYP constraints.
create_clock -name raqm_aclk -period 10.000 [get_ports aclk]
set_clock_uncertainty 0.100 [get_clocks raqm_aclk]

# Asynchronous reset is asserted asynchronously and deasserted in the aclk domain.
set_false_path -from [get_ports aresetn_async]

# AXI-Lite/AXI-Stream are IP-boundary ports. When integrated into a block design,
# constrain the source/sink interfaces at the platform level; do not copy external
# I/O delays or pin constraints from an unrelated carrier board.
