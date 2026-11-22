#!/usr/bin/env bash
# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
set -euo pipefail
cd "$(dirname "$0")/.."
command -v iverilog >/dev/null || { echo "iverilog not found. Kali: sudo apt install iverilog" >&2; exit 127; }
command -v vvp >/dev/null || { echo "vvp not found (install iverilog package)." >&2; exit 127; }
mkdir -p sim/build

iverilog -g2012 -Wall -s tb_raqm_vector_core -o sim/build/tb_vector \
  rtl/raqm_vector_core.sv sim/tb_raqm_vector_core.sv
vvp sim/build/tb_vector

iverilog -g2012 -Wall -s tb_raqm_axil_ctrl -o sim/build/tb_axil \
  rtl/raqm_axil_ctrl.sv sim/tb_raqm_axil_ctrl.sv
vvp sim/build/tb_axil

iverilog -g2012 -Wall -s tb_raqm_core -o sim/build/tb_scalar \
  rtl/raqm_core.sv sim/tb_raqm_core.sv
vvp sim/build/tb_scalar

iverilog -g2012 -Wall -s tb_raqm_reset_sync -o sim/build/tb_reset \
  rtl/raqm_reset_sync.sv sim/tb_raqm_reset_sync.sv
vvp sim/build/tb_reset

iverilog -g2012 -Wall -s raqm_versal_g77m_top -o sim/build/top_elab \
  rtl/raqm_reset_sync.sv rtl/raqm_axil_ctrl.sv \
  rtl/raqm_vector_core.sv rtl/raqm_versal_g77m_top.sv
printf 'All Icarus testbenches and product-top elaboration passed.\n'
