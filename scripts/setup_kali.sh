#!/usr/bin/env bash
# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for tool in python3 gcc make; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "ERROR: $tool not found. Install with: sudo apt install python3 build-essential make" >&2
    exit 1
  fi
done

make check

if command -v iverilog >/dev/null 2>&1 && command -v vvp >/dev/null 2>&1; then
  ./sim/run_iverilog.sh
else
  echo "NOTICE: Icarus Verilog not installed; RTL simulation skipped. Install with: sudo apt install iverilog"
fi

echo "RAQM repository release 4.1.0 preflight complete. Vivado synthesis and hardware qualification are separate steps."
