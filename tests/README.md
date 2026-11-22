# Test instructions

Python reference tests:

```bash
python -m unittest discover -s tests -v
```

RTL self-checking testbench (requires Icarus Verilog):

```bash
iverilog -g2012 -s tb_raqm_core -o sim/raqm_core_tb \
  rtl/raqm_core.sv sim/tb_raqm_core.sv
vvp sim/raqm_core_tb
```

The local authoring environment used to assemble this ZIP did not have
Icarus Verilog or Vivado installed. Do not treat the testbench or synthesis
as executed until you run them on your machine.
