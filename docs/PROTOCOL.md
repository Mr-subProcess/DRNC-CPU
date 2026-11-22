# RAQM Rev 4 data and control protocol

## AXI4-Stream input

- `TDATA[255:0]`: 128 lanes, 2 bits per lane.
- `TKEEP[31:0]`: all ones required (`32'hFFFF_FFFF`). Partial-byte beats are rejected with status `0x04`; the datapath does not implement sparse/partial lane semantics.
- `TUSER[7:0]` when CFG override is disabled:
  - `[1:0]` branch mode: `01` B, `10` C, `11` fork B+C, `00` invalid.
  - `[2]` merge select: 0 B, 1 C. In B-only mode select 0; in C-only mode select 1.
  - `[3]` feedback enable.
  - `[5:4]` B XOR mask.
  - `[7:6]` C XOR mask.
- `TLAST`: passed through the elastic output stage.
- Transfer occurs only when TVALID and TREADY are both high on the active clock edge.

## AXI4-Stream output

- `TDATA[255:0]`: processed vector. The two-bit symbol values `00`, `01`, `10`, and `11` are all valid.
- `TKEEP[31:0]`: all ones for every emitted result beat.
- `TUSER[7:0]`: status byte: `00` success, `01` invalid branch mode, `02` merge selection incompatible with a single-branch operation, `03` feedback requested before valid history, `04` invalid input TKEEP.
- `TLAST`: exact input TLAST value for the accepted beat.
- Output data and all sidebands remain stable while TVALID=1 and TREADY=0.

## Processing equations

Let `S` be `TDATA` or the previous successful result vector when feedback is selected. For each 2-bit lane `i`:

`B[i] = S[i] XOR mask_b`

`C[i] = S[i] XOR mask_c`

The branches are evaluated combinationally in parallel. `branch_mode` marks B, C, or both as participating; `merge_sel` selects exactly one branch result for the output register. In fork mode the debug signals show both computations participating. This is a synchronous parallel-compute/select-merge model, not an asynchronous rendezvous between independently timed branch pipelines; the join marker is a debug indication rather than a separately timed completion protocol.

## Clock/handshake classification

Rev 4 is a synchronous FPGA datapath. AXI valid/ready is synchronous backpressure. It is not a QDI asynchronous circuit and does not remove the PL clock. The scalar four-phase REQ/ACK design is retained only as a separately tested reference model, not instantiated in the production vector top.
