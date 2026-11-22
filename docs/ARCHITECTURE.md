# RAQM Industrial Rev 4 — architecture

## 1. Scope

Rev 4 is a vector datapath/accelerator prototype, not a general-purpose CPU: it has no instruction-set architecture, program counter, instruction fetch/decode pipeline or general-purpose register file. It is a synchronous FPGA datapath prototype targeted at an iWave G77M SOM carrying an AMD Versal AI Edge Gen 2 device. It is not a custom ASIC, not a clockless/QDI implementation, and not a production-qualified system. The scalar four-phase REQ/ACK RTL is retained as a separate reference/test component and is not instantiated in the product vector top.

## 2. Processing organization

- 128 lanes, each lane is one 2-bit symbol.
- A complete input/output beat is 256 bits.
- `00`, `01`, `10`, `11` are all ordinary valid data symbols.
- Beat validity is signaled exclusively by AXI4-Stream TVALID/TREADY.
- B and C branch transformations are evaluated in parallel:
  - `B[i] = source[i] XOR mask_b`
  - `C[i] = source[i] XOR mask_c`
- `merge_sel=0` commits B; `merge_sel=1` commits C.
- Branch modes: `01` B only, `10` C only, `11` fork B+C, `00` invalid.
- `feedback_en=1` chooses the previous successfully accepted result vector as the current beat's source. Feedback can be cleared by AXI-Lite CTRL bit 1.

## 3. Datapath flow

```text
AXI4-Stream S_AXIS
        |
        v
Input / command validation
        |
        v
       A source mux <---- previous successful output (feedback)
        |
        +--------------------------+
        |                          |
        v                          v
     B branch                   C branch
   XOR mask_b                 XOR mask_c
        |                          |
        +------------+-------------+
                     |
                merge select
                     |
              output elastic reg
                     |
             AXI4-Stream M_AXIS
```

Fork and join are synchronous combinational branch evaluations under the same PL clock, not independent asynchronous channels. The output register is a one-entry elastic buffer. When output is stalled (`M_AXIS_TVALID=1`, `M_AXIS_TREADY=0`), input is backpressured and output payload plus sidebands are held stable.

## 4. Stream contract

Input `TKEEP` must be all ones for the full 32-byte/256-bit vector. Partial byte lanes are not implemented; a beat with non-full TKEEP is accepted as a request but returns zero data and status `0x04`. The output always uses full TKEEP. `TLAST` is passed through. Input TUSER contains the operation controls; output TUSER contains the status byte.

## 5. Control plane

A 32-bit AXI4-Lite register bank controls engine enable, optional static configuration override, feedback clear, and performance/error counters. `AW` and `W` may arrive independently. One read and one write transaction can be outstanding. Invalid/unmapped/unaligned register accesses and invalid access direction return `SLVERR`.

## 6. Clocks and reset

AXI-Lite and AXI-Stream share one `aclk` domain. Aresetn assertion is asynchronous; reset release is synchronized by a two-stage synchronizer. If platform interfaces use another clock, insert the appropriate AXI/AXI-Stream clock converter and verify CDC/reset behavior.

## 7. Product integration boundary

The product top is an RTL IP boundary. In the Versal platform design, connect:

- CIPS PL clock/reset to `aclk` / `aresetn_async`.
- CIPS `M_AXI_FPD` through AXI SmartConnect to RAQM `S_AXI`.
- AXI DMA `M_AXIS_MM2S` to RAQM `S_AXIS`.
- RAQM `M_AXIS` to AXI DMA `S_AXIS_S2MM` (or another AXI-Stream sink).
- DMA memory masters to the platform NoC/DDR memory path.

The package does not include the CIPS/NoC/AXI DMA block design, a finished GTYP/MAC/PCS subsystem, the full carrier-board pinout, a PCB layout or bitstream. See `VERSAL_PLATFORM_INTEGRATION.md`.
