# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
"""Bit-accurate functional reference model for RAQM-Industrial Rev 1."""
from dataclasses import dataclass

STATUS_OK = 0x00
STATUS_BAD_BRANCH = 0x01
STATUS_BAD_MERGE = 0x02
STATUS_NO_FEEDBACK = 0x03

@dataclass
class ReferenceCore:
    feedback_data: int = 0
    feedback_valid: bool = False

    def execute(self, data: int, branch_mode: int, merge_sel: int,
                mask_b: int, mask_c: int, feedback_en: bool = False):
        for name, val in (("data", data), ("mask_b", mask_b), ("mask_c", mask_c)):
            if not 0 <= val <= 3:
                raise ValueError(f"{name} must be 0..3")
        if branch_mode == 0:
            return STATUS_BAD_BRANCH, 0
        if (branch_mode == 1 and merge_sel == 1) or (branch_mode == 2 and merge_sel == 0):
            return STATUS_BAD_MERGE, 0
        if feedback_en and not self.feedback_valid:
            return STATUS_NO_FEEDBACK, 0

        token = self.feedback_data if feedback_en else data
        b_active = bool(branch_mode & 0b01)
        c_active = bool(branch_mode & 0b10)
        b_result = token ^ mask_b if b_active else None
        c_result = token ^ mask_c if c_active else None
        result = c_result if merge_sel else b_result
        assert result is not None
        self.feedback_data = result
        self.feedback_valid = True
        return STATUS_OK, result


def crc8(data: bytes) -> int:
    crc = 0
    for byte in data:
        crc ^= byte
        for _ in range(8):
            crc = ((crc << 1) ^ 0x07) & 0xFF if crc & 0x80 else (crc << 1) & 0xFF
    return crc


def request_frame(seq: int, data: int, cfg: int, masks: int) -> bytes:
    payload = bytes((seq & 0xFF, data & 0xFF, cfg & 0xFF, masks & 0xFF))
    return bytes((0xA5,)) + payload + bytes((crc8(payload),))
