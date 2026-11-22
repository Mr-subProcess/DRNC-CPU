# RAQM Rev 4 vector interface

## Input AXI4-Stream

| Port | Width | Meaning |
|---|---:|---|
| `s_axis_tvalid` | 1 | Input beat present |
| `s_axis_tready` | 1 | Core can accept input beat |
| `s_axis_tdata` | 256 | 128 × 2-bit symbols |
| `s_axis_tkeep` | 32 | Must equal `32'hFFFF_FFFF` |
| `s_axis_tuser` | 8 | Branch/merge/feedback/mask command |
| `s_axis_tlast` | 1 | End-of-packet marker |

## Output AXI4-Stream

| Port | Width | Meaning |
|---|---:|---|
| `m_axis_tvalid` | 1 | Result beat present |
| `m_axis_tready` | 1 | Downstream can accept result |
| `m_axis_tdata` | 256 | Result vector |
| `m_axis_tkeep` | 32 | Always all ones for emitted beats |
| `m_axis_tuser` | 8 | Result status byte |
| `m_axis_tlast` | 1 | Passed-through TLAST |

## TUSER command encoding

- `[1:0]`: `01` B only, `10` C only, `11` B+C fork, `00` invalid.
- `[2]`: merge select, `0` B result, `1` C result. B-only requires 0; C-only requires 1.
- `[3]`: feedback enable.
- `[5:4]`: B XOR mask.
- `[7:6]`: C XOR mask.

When AXI-Lite `CTRL.CFG_OVERRIDE=1`, the global 8-bit CFG register replaces input TUSER for every beat.

## Output TUSER status encoding

- `0x00`: success.
- `0x01`: invalid branch control (`branch_mode=00`).
- `0x02`: merge selection inconsistent with B-only/C-only mode.
- `0x03`: feedback requested before a valid history exists.
- `0x04`: TKEEP not all ones (partial/invalid fixed-width beat).

Output TDATA is zero on an error beat. Error beats are still valid AXI-Stream beats and carry the input TLAST. Invalid input does not update feedback state.

The product wrapper is a synchronous PL IP boundary. The 256-bit bus is not an externally routed 256-wire connector; it remains internal to the FPGA platform design.
