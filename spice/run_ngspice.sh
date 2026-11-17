#!/usr/bin/env sh
set -eu
cd "$(dirname "$0")"
ngspice -b RAQM02G_DC_OP.cir
ngspice -b RAQM02G_WRITE_HOLD_TRAN.cir
