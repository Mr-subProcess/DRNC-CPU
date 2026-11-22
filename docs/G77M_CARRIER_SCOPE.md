# G77M carrier-board scope — not yet released for PCB design

The Rev 4 design deliberately does not contain package-pin assignments. The compute datapath is internal to the SOM FPGA fabric. The first carrier should expose only confirmed management/data interfaces that are present in the selected G77M module and required by the application.

Before schematic capture, obtain from iWave:
- the exact orderable SOM part number and the exact SoC speed/temperature grade;
- controlled current revision of the G77M hardware manual and all three B2B connector pin tables;
- reference carrier/development kit schematic, power tree and sequencing;
- I/O bank rail configuration and permitted VCCO/I/O standards;
- thermal/mechanical integration guidance and mating connector drawings.

The preliminary G77M REL0.1 PDF has an ordering table marked TBD. Current distributor catalogs list the candidate MPN `iG77M-3858E2-4E008G-E032G-IAA`, but distributor temperature specifications differ (-40…+85 °C vs. -20…+85 °C). Obtain the controlled current iWave datasheet and written confirmation before BOM freeze. A blank connector pin-map template is supplied; no guessed B2B pin map is included.

No carrier XDC, connector net assignment, power regulator selection, GTYP lane map or PCB layout is released in Rev 4.
