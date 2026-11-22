/* SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0 */
#ifndef RAQM_MMIO_H
#define RAQM_MMIO_H

#include <stdint.h>

/*
 * RAQM Rev 4 AXI4-Lite register offsets.
 * Set RAQM_BASE_ADDR to the address assigned in the Vivado address editor.
 * Do not use this placeholder as a real board address.
 */
#ifndef RAQM_BASE_ADDR
#error "Define RAQM_BASE_ADDR from the Vivado Address Editor / exported XSA before building."
#endif

#define RAQM_REG_CTRL          0x00u
#define RAQM_REG_CFG           0x04u
#define RAQM_REG_STATUS        0x08u
#define RAQM_REG_ACCEPTED      0x0Cu
#define RAQM_REG_COMPLETED     0x10u
#define RAQM_REG_ERRORS        0x14u
#define RAQM_REG_LAST_STATUS   0x18u
#define RAQM_REG_COUNT_CLEAR   0x1Cu

#define RAQM_CTRL_ENABLE       (1u << 0)
#define RAQM_CTRL_CLEAR_FB     (1u << 1) /* self-clearing write-one pulse */
#define RAQM_CTRL_CFG_OVERRIDE (1u << 2)

#define RAQM_BRANCH_INVALID 0u
#define RAQM_BRANCH_B       1u
#define RAQM_BRANCH_C       2u
#define RAQM_BRANCH_FORK    3u

#define RAQM_CFG(branch, merge, feedback, mask_b, mask_c) \
    ((((uint32_t)(branch) & 0x3u)      ) | \
     (((uint32_t)(merge) & 0x1u)    << 2) | \
     (((uint32_t)(feedback) & 0x1u) << 3) | \
     (((uint32_t)(mask_b) & 0x3u)   << 4) | \
     (((uint32_t)(mask_c) & 0x3u)   << 6))

static inline volatile uint32_t *raqm_reg_ptr(uint32_t offset)
{
    return (volatile uint32_t *)(uintptr_t)(RAQM_BASE_ADDR + offset);
}

static inline void raqm_write(uint32_t offset, uint32_t value)
{
    *raqm_reg_ptr(offset) = value;
}

static inline uint32_t raqm_read(uint32_t offset)
{
    return *raqm_reg_ptr(offset);
}

/* Call only when the stream is quiescent, or while its producer is stopped. */
static inline void raqm_configure(uint32_t cfg)
{
    raqm_write(RAQM_REG_CTRL, 0u); /* stop accepting new data */
    raqm_write(RAQM_REG_CFG, cfg);
    raqm_write(RAQM_REG_CTRL, RAQM_CTRL_CLEAR_FB);
    raqm_write(RAQM_REG_CTRL, RAQM_CTRL_ENABLE | RAQM_CTRL_CFG_OVERRIDE);
}

static inline void raqm_disable(void)
{
    raqm_write(RAQM_REG_CTRL, 0u);
}

static inline void raqm_enable_stream_cfg(void)
{
    raqm_write(RAQM_REG_CTRL, RAQM_CTRL_ENABLE);
}

static inline void raqm_clear_counters(void)
{
    raqm_write(RAQM_REG_COUNT_CLEAR, 1u);
}

#endif /* RAQM_MMIO_H */
