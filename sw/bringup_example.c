/* SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0 */
#include "raqm_mmio.h"

/*
 * Bare-metal bring-up example for a Vitis standalone application.
 * The DMA setup is deliberately not fabricated here: configure AXI DMA in
 * the Vivado platform, then use the matching generated xaxidma device ID and
 * address map from that hardware handoff (XSA).
 */
int main(void)
{
    uint32_t status;

    /* Fork B+C, select B, no feedback, no XOR masks. */
    raqm_configure(RAQM_CFG(RAQM_BRANCH_FORK, 0u, 0u, 0u, 0u));

    /* A real data beat is submitted through AXI DMA / AXI4-Stream, not MMIO. */
    status = raqm_read(RAQM_REG_STATUS);
    (void)status;

    /* After the DMA path has transferred test vectors, inspect counters. */
    status = raqm_read(RAQM_REG_ACCEPTED);
    (void)status;
    status = raqm_read(RAQM_REG_COMPLETED);
    (void)status;
    status = raqm_read(RAQM_REG_ERRORS);
    (void)status;

    /* Leave enabled for debugger inspection; production app owns lifecycle. */
    for (;;) {
        __asm__ volatile ("wfe");
    }
}
