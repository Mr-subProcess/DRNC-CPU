# RAQM Rev 4 — AXI4-Lite register map

All addresses are 32-bit byte addresses. The slave allows one outstanding write and one outstanding read. AW and W channels are captured independently. Responses are held stable until BREADY/RREADY. `OKAY=2'b00`; `SLVERR=2'b10`.

| Address | Name | Access | Reset | Description |
|---:|---|---|---:|---|
| `0x00` | CTRL | RW | `0x00000000` | bit 0 engine enable; bit 1 write-one pulse clears feedback history; bit 2 enables CFG override. Other bits reserved/read zero. |
| `0x04` | CFG | RW | `0x00000003` | `[1:0]` branch mode; bit 2 merge select; bit 3 feedback enable; `[5:4]` B XOR mask; `[7:6]` C XOR mask. |
| `0x08` | STATUS | RO | 0 | bit 7 last status nonzero; bit 6 input ready; bit 5 output valid; bit 4 feedback valid; bit 3 CFG override; bit 2 engine enabled. |
| `0x0C` | ACCEPTED_COUNT | RO | 0 | Number of accepted input beats. |
| `0x10` | COMPLETED_COUNT | RO | 0 | Number of output beats consumed. |
| `0x14` | ERROR_COUNT | RO | 0 | Number of consumed output beats with nonzero status. |
| `0x18` | LAST_STATUS | RO | 0 | Status byte on the most recently consumed output beat. |
| `0x1C` | COUNT_CLEAR | WO | 0 | Write bit 0 = 1 to clear all three counters. |

## CFG encoding

- `branch_mode=00`: invalid control; output status `0x01`.
- `branch_mode=01`: B only; `merge_sel` must be 0.
- `branch_mode=10`: C only; `merge_sel` must be 1.
- `branch_mode=11`: parallel B+C fork; `merge_sel` chooses which branch's result is emitted.
- `feedback_en=1`: previous successfully processed output vector is the next input source. Before history exists (or after clear), status is `0x03`.
- B mask is XORed into each 2-bit lane on B; C mask is XORed into each lane on C.

## AXI response behavior

- `SLVERR` is returned for unaligned addresses, unmapped addresses, writes to RO registers and reads of the WO counter-clear register.
- Invalid accesses have no side effects; invalid reads return zero RDATA.
- `WSTRB` is honored for CTRL/CFG/COUNT_CLEAR byte lanes.
- `AWPROT` and `ARPROT` are captured at the interface boundary but are not used for access control. Enforce privilege/security at the system interconnect/PS software layer.
- The register bank is in the same `aclk` domain as the data stream. Add clock converters if the platform uses a different clock domain.
