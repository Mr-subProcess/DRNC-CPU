# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
import unittest
from raqm_reference import ReferenceCore, crc8, request_frame

class TestRAQMReference(unittest.TestCase):
    def test_all_four_symbols_are_data(self):
        for symbol in range(4):
            core = ReferenceCore()
            status, out = core.execute(symbol, 3, 0, 0, 0)
            self.assertEqual(status, 0)
            self.assertEqual(out, symbol)

    def test_fork_and_merge_select_b(self):
        core = ReferenceCore()
        self.assertEqual(core.execute(1, 3, 0, 1, 2), (0, 0))

    def test_fork_and_merge_select_c(self):
        core = ReferenceCore()
        self.assertEqual(core.execute(1, 3, 1, 1, 2), (0, 3))

    def test_single_branch_b(self):
        core = ReferenceCore()
        self.assertEqual(core.execute(2, 1, 0, 3, 0), (0, 1))

    def test_single_branch_c(self):
        core = ReferenceCore()
        self.assertEqual(core.execute(2, 2, 1, 0, 3), (0, 1))

    def test_feedback(self):
        core = ReferenceCore()
        self.assertEqual(core.execute(1, 3, 1, 0, 2), (0, 3))
        self.assertEqual(core.execute(0, 2, 1, 0, 1, True), (0, 2))

    def test_bad_branch_and_bad_merge(self):
        core = ReferenceCore()
        self.assertEqual(core.execute(0, 0, 0, 0, 0), (1, 0))
        self.assertEqual(core.execute(0, 1, 1, 0, 0), (2, 0))

    def test_feedback_without_history(self):
        core = ReferenceCore()
        self.assertEqual(core.execute(0, 2, 1, 0, 0, True), (3, 0))

    def test_crc8_check_vector(self):
        # CRC-8/ATM (poly 0x07, init 0) known check for ASCII "123456789".
        self.assertEqual(crc8(b"123456789"), 0xF4)

    def test_request_packet_shape(self):
        frame = request_frame(0x37, 0b11, 0b00001111, 0b00001001)
        self.assertEqual(len(frame), 6)
        self.assertEqual(frame[0], 0xA5)
        self.assertEqual(frame[-1], crc8(frame[1:5]))

if __name__ == "__main__":
    unittest.main()
