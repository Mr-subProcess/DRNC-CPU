# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
# RAQM Industrial G77M Rev 4 — RTL synthesis project.
# This script deliberately creates a synthesizable RTL project only. It does NOT
# manufacture a CIPS/NoC platform, assign B2B pins, build GTYP, or write a bitstream.

set script_dir [file dirname [file normalize [info script]]]
set root_dir [file normalize [file join $script_dir ..]]
set proj_dir [file join $root_dir vivado_build_rev4]

set vivado_ver [version -short]
if {[package vcompare $vivado_ver 2026.1] < 0} {
    error "Use Vivado 2026.1 or later for the current XC2VE3858 production speed-spec baseline; verify the exact speed grade in AMD DS1021."
}

# iWave G77M REL0.1 identifies 2VE3858 with SSVA2112 package, but the available
# orderable-product table is TBD. Filter to that package and require the user to
# select the exact part string confirmed by iWave (speed/temperature grade matters).
set candidates [get_parts -quiet *xc2ve3858*ssva2112*]
if {[llength $candidates] == 0} {
    error "No XC2VE3858/SSVA2112 part found. Install the matching Versal AI Edge Gen 2 device files in Vivado 2026.1+."
}
if {![info exists ::env(RAQM_VERSAL_PART)] || $::env(RAQM_VERSAL_PART) eq ""} {
    error "Set RAQM_VERSAL_PART to the exact XC2VE3858-SSVA2112 part confirmed by iWave. Candidates: $candidates"
}
set part $::env(RAQM_VERSAL_PART)
if {[lsearch -exact $candidates $part] < 0} {
    error "RAQM_VERSAL_PART='$part' is not in the installed XC2VE3858-SSVA2112 catalog. Candidates: $candidates"
}

puts "Creating RAQM Rev 4 RTL synthesis project for $part using Vivado $vivado_ver"
create_project RAQM_Industrial_G77M_Rev4 $proj_dir -part $part -force
set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]

set rtl_dir [file join $root_dir rtl]
add_files -norecurse [list \
    "$rtl_dir/raqm_reset_sync.sv" \
    "$rtl_dir/raqm_axil_ctrl.sv" \
    "$rtl_dir/raqm_vector_core.sv" \
    "$rtl_dir/raqm_versal_g77m_top.sv"]
set_property top raqm_versal_g77m_top [current_fileset]
read_xdc [file join $root_dir constraints raqm_g77m_template.xdc]
update_compile_order -fileset sources_1

launch_runs synth_1 -jobs 4
wait_on_run synth_1
open_run synth_1
report_utilization -file [file join $proj_dir raqm_utilization_post_synth.rpt]
report_timing_summary -file [file join $proj_dir raqm_timing_post_synth.rpt]
puts "RAQM Rev 4 synthesis run completed. Review all warnings, unconstrained paths and timing; this is not place-and-route/timing closure."
