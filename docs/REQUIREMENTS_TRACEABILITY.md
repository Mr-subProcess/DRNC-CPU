# RAQM Rev 4 — requirements and verification traceability

This table maps the prototype's declared requirements to their implementation and available evidence. A Python reference-model pass is not equivalent to RTL simulation or board validation.

| ID | Requirement | Implementation | Evidence currently available | Remaining qualification |
|---|---|---|---|---|
| RAQM-DATA-001 | `00`, `01`, `10`, `11` are all valid 2-bit payload symbols | `rtl/raqm_vector_core.sv` | Python unit test; SV testbench source | Run SV simulator and hardware vectors |
| RAQM-DATA-002 | Exactly 128 lanes × 2 bits per beat | `LANES=128`, `DATA_W=256` defaults | Source preflight; Python 128-lane randomized test | RTL simulation and synthesis |
| RAQM-DATA-003 | B and C apply independent 2-bit XOR masks | Vector core combinational branch logic | Python model + deterministic 2,000-case test; SV testbench source | RTL simulation |
| RAQM-FLOW-001 | Branch mode selects B, C or both | `TUSER[1:0]` | Python unit tests; SV testbench source | RTL simulation |
| RAQM-FLOW-002 | Merge select chooses one branch result | `TUSER[2]` | Python unit tests; SV testbench source | RTL simulation; verify intended system semantics |
| RAQM-FEEDBACK-001 | Feedback uses previous successful result only | Feedback register/valid flag | Python tests; SV testbench source | RTL simulation, reset and stress tests |
| RAQM-AXIS-001 | Output payload/sidebands stable during backpressure | One-entry elastic stage | SV testbench source | Run RTL simulation and AXI protocol checker |
| RAQM-AXIS-004 | One beat per clock when source and sink are continuously ready | Elastic output stage | SV back-to-back testbench source | Run RTL simulation; measure after synthesis |
| RAQM-AXIS-002 | Full-width `TKEEP` required | Core fixed-beat validation | Python test; SV testbench source | Run RTL simulation |
| RAQM-AXIS-003 | `TLAST` preserved | Vector core output register | SV testbench source | Run RTL simulation and DMA integration |
| RAQM-AXIL-001 | Independent AW/W capture, stable B/R responses | AXI-Lite control slave | SV testbench source | Run RTL simulation and AXI VIP/protocol checker |
| RAQM-AXIL-002 | Invalid/unaligned/access-type-invalid accesses return `SLVERR` | AXI-Lite decode functions | SV testbench source + static source check | Run RTL simulation |
| RAQM-RESET-001 | Asynchronous assertion, synchronous deassertion | Two-stage reset synchronizer | Reset SV testbench source + static source inspection | Run RTL simulation and CDC/reset analysis in Vivado |
| RAQM-PLAT-001 | CIPS/NoC/AXI DMA integration | Integration guide only | Document review | Create Vivado block design and export XSA |
| RAQM-PERF-001 | Meet stated PL clock and throughput target | Not established yet | No timing result | Synthesis, implementation, timing closure and hardware measurement |

## Semantics that must not be overstated

- The B/C forks are combinational parallel transforms within one synchronous clock cycle.
- The merge stage selects one branch result. It does not concatenate, sum, or otherwise combine both branch results.
- The `dbg_join_valid` signal is a diagnostic marker for fork mode; it is not a separate four-phase asynchronous completion handshake.
- The scalar four-phase REQ/ACK reference module is not connected to the vector datapath in the product top.
- There is no external 256-bit connector implied by the internal AXI4-Stream bus.
