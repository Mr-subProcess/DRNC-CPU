SHELL := /bin/bash
.PHONY: test python-check sw-check shell-check rtl-test rtl-elab rtl-lint schematic preflight license-check check

test:
	python3 -m unittest discover -s tests -v

python-check:
	python3 -m compileall -q tests kicad scripts

sw-check:
	gcc -std=gnu11 -Wall -Wextra -Werror -DRAQM_BASE_ADDR=0xA0000000u -fsyntax-only sw/bringup_example.c

shell-check:
	bash -n scripts/setup_kali.sh sim/run_iverilog.sh

preflight:
	python3 scripts/preflight.py

license-check:
	python3 scripts/check_release.py

rtl-test:
	./sim/run_iverilog.sh

rtl-elab:
	mkdir -p sim/build
	iverilog -g2012 -Wall -s raqm_versal_g77m_top -o sim/build/top_elab \
	  rtl/raqm_reset_sync.sv rtl/raqm_axil_ctrl.sv \
	  rtl/raqm_vector_core.sv rtl/raqm_versal_g77m_top.sv

rtl-lint:
	verilator --lint-only --sv --Wall -Wno-fatal --top-module raqm_versal_g77m_top \
	  rtl/raqm_reset_sync.sv rtl/raqm_axil_ctrl.sv \
	  rtl/raqm_vector_core.sv rtl/raqm_versal_g77m_top.sv

schematic:
	python3 kicad/raqm_isow1432_skidl.py

check: python-check sw-check shell-check preflight license-check test
