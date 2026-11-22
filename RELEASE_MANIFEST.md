# Release Manifest — RAQM Industrial G77M 4.1.0

- Repository release: `4.1.0`
- RTL baseline: `Rev 4.0`
- Release date: `2026-11-22`
- Author: `Oğuz Kağan Sayın`
- License: `LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0`
- Main RTL top: `raqm_versal_g77m_top`
- Main datapath: 128 lanes × 2 bits = 256-bit synchronous AXI4-Stream.
- Management: 32-bit AXI4-Lite control/status.
- FPGA status: RTL prototype; vendor platform integration and timing closure pending.
- Hardware status: no validated carrier-board pin map, physical PCB, bitstream, or hardware qualification included.

## Archive integrity

`SHA256SUMS` lists the SHA-256 digest for every tracked file in the release tree except the manifest itself. Regenerate it after any modification using:

```bash
find . -type f ! -path './.git/*' ! -name SHA256SUMS -print0 | sort -z | xargs -0 sha256sum > SHA256SUMS
```

The downloadable source archive should be validated with `unzip -t` and accompanied by its own `.sha256` sidecar.
