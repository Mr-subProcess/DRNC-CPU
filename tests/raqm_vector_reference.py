# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
"""Bit-accurate Python reference model for the wide RAQM vector datapath."""
from dataclasses import dataclass
from typing import Iterable, List, Tuple

STATUS_OK = 0x00
STATUS_BAD_BRANCH = 0x01
STATUS_BAD_MERGE = 0x02
STATUS_NO_FEEDBACK = 0x03
STATUS_BAD_TKEEP = 0x04


@dataclass
class VectorReference:
    lanes: int = 128
    feedback: List[int] | None = None

    def __post_init__(self):
        if self.feedback is None:
            self.feedback = [0] * self.lanes
        if len(self.feedback) != self.lanes:
            raise ValueError("feedback vector length must equal lanes")

    @property
    def feedback_valid(self) -> bool:
        return self.feedback is not None and getattr(self, "_feedback_valid", False)

    def execute(self, symbols: Iterable[int], branch_mode: int, merge_sel: int,
                feedback_en: bool, mask_b: int, mask_c: int,
                keep_valid: bool = True) -> Tuple[int, List[int]]:
        data = list(symbols)
        if len(data) != self.lanes:
            raise ValueError(f"expected {self.lanes} symbols, got {len(data)}")
        if any(v not in (0, 1, 2, 3) for v in data):
            raise ValueError("each lane must be a 2-bit symbol 0..3")
        if not keep_valid:
            return STATUS_BAD_TKEEP, [0] * self.lanes
        if branch_mode not in (0, 1, 2, 3):
            raise ValueError("branch_mode must be 0..3")
        if branch_mode == 0:
            return STATUS_BAD_BRANCH, [0] * self.lanes
        if (branch_mode == 1 and merge_sel != 0) or (branch_mode == 2 and merge_sel != 1):
            return STATUS_BAD_MERGE, [0] * self.lanes
        if feedback_en and not self.feedback_valid:
            return STATUS_NO_FEEDBACK, [0] * self.lanes

        source = list(self.feedback) if feedback_en else data
        b_result = [x ^ (mask_b & 0x3) for x in source]
        c_result = [x ^ (mask_c & 0x3) for x in source]
        result = c_result if merge_sel else b_result
        self.feedback = list(result)
        self._feedback_valid = True
        return STATUS_OK, result
