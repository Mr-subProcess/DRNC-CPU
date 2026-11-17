# RAQM-03D — XC7A100T-FGG484 user I/O constraints
# Generated from the pinout table supplied in this conversation.
# This file assigns only regular Bank 13 HR I/O; it does NOT constrain GTP serial pins.
# Verify these assignments in Vivado I/O Planning and run report_drc before hardware use.

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR No [current_design]

set_property PACKAGE_PIN Y16 [get_ports {RAQM_B0_DATA}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_B0_DATA}]
set_property PACKAGE_PIN AA16 [get_ports {RAQM_B0_WE}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_B0_WE}]
set_property PACKAGE_PIN AB16 [get_ports {RAQM_B1_DATA}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_B1_DATA}]
set_property PACKAGE_PIN AB17 [get_ports {RAQM_B1_WE}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_B1_WE}]
set_property PACKAGE_PIN AA13 [get_ports {RAQM_B0_Q}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_B0_Q}]
set_property PACKAGE_PIN AB13 [get_ports {RAQM_B1_Q}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_B1_Q}]
set_property PACKAGE_PIN AA15 [get_ports {RAQM_REQ}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_REQ}]
set_property PACKAGE_PIN AB15 [get_ports {RAQM_RESET_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_RESET_N}]
set_property PACKAGE_PIN Y13 [get_ports {RAQM_ACK}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_ACK}]
set_property PACKAGE_PIN AA14 [get_ports {RAQM_PAIR_VALID}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_PAIR_VALID}]
set_property PACKAGE_PIN W14 [get_ports {RAQM_FAULT}]
set_property IOSTANDARD LVCMOS33 [get_ports {RAQM_FAULT}]
set_property PACKAGE_PIN Y17 [get_ports {PCIE_PERST_N}]
set_property IOSTANDARD LVCMOS33 [get_ports {PCIE_PERST_N}]
set_property DRIVE 8 [get_ports {RAQM_B0_DATA}]
set_property SLEW SLOW [get_ports {RAQM_B0_DATA}]
set_property DRIVE 8 [get_ports {RAQM_B0_WE}]
set_property SLEW SLOW [get_ports {RAQM_B0_WE}]
set_property DRIVE 8 [get_ports {RAQM_B1_DATA}]
set_property SLEW SLOW [get_ports {RAQM_B1_DATA}]
set_property DRIVE 8 [get_ports {RAQM_B1_WE}]
set_property SLEW SLOW [get_ports {RAQM_B1_WE}]
set_property DRIVE 8 [get_ports {RAQM_REQ}]
set_property SLEW SLOW [get_ports {RAQM_REQ}]
set_property DRIVE 8 [get_ports {RAQM_RESET_N}]
set_property SLEW SLOW [get_ports {RAQM_RESET_N}]

# GTP/PCIe placement notes:
# PCIe hard block: PCIE_2_1_X0Y0 (verify against generated IP and Vivado device database).
# PCIe lane 0 recommended GT site for XC7A100T-FGG484: GTPE2_CHANNEL_X0Y7 (PG054).
# In the supplied FGG484 pinout, GT channel 3 is D7/C7 (TX), D9/C9 (RX), REFCLK0 F6/E6.
# Do not add PACKAGE_PIN constraints for GTP dedicated pins. Use the generated PCIe IP XDC and GT location constraints.
