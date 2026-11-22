# SPDX-License-Identifier: LicenseRef-RAQM-Research-Only-No-Commercial-Production-1.0
import unittest
import random
from raqm_vector_reference import (
    VectorReference, STATUS_OK, STATUS_BAD_BRANCH,
    STATUS_BAD_MERGE, STATUS_NO_FEEDBACK, STATUS_BAD_TKEEP,
)


class TestRAQMVectorReference(unittest.TestCase):
    def test_all_four_symbols_preserved_across_lanes(self):
        core = VectorReference(lanes=4)
        symbols = [0, 1, 2, 3]
        status, output = core.execute(symbols, branch_mode=3, merge_sel=0,
                                      feedback_en=False, mask_b=0, mask_c=3)
        self.assertEqual(status, STATUS_OK)
        self.assertEqual(output, symbols)

    def test_parallel_fork_join_selects_b(self):
        core = VectorReference(lanes=4)
        status, output = core.execute([0, 1, 2, 3], 3, 0, False, 1, 2)
        self.assertEqual(status, STATUS_OK)
        self.assertEqual(output, [1, 0, 3, 2])

    def test_parallel_fork_join_selects_c(self):
        core = VectorReference(lanes=4)
        status, output = core.execute([0, 1, 2, 3], 3, 1, False, 1, 2)
        self.assertEqual(status, STATUS_OK)
        self.assertEqual(output, [2, 3, 0, 1])

    def test_b_only(self):
        core = VectorReference(lanes=4)
        status, output = core.execute([0, 1, 2, 3], 1, 0, False, 3, 0)
        self.assertEqual(status, STATUS_OK)
        self.assertEqual(output, [3, 2, 1, 0])

    def test_c_only(self):
        core = VectorReference(lanes=4)
        status, output = core.execute([0, 1, 2, 3], 2, 1, False, 0, 1)
        self.assertEqual(status, STATUS_OK)
        self.assertEqual(output, [1, 0, 3, 2])

    def test_feedback_uses_previous_vector(self):
        core = VectorReference(lanes=4)
        status, first = core.execute([0, 1, 2, 3], 3, 0, False, 1, 2)
        self.assertEqual(status, STATUS_OK)
        status, second = core.execute([3, 3, 3, 3], 3, 1, True, 0, 3)
        self.assertEqual(status, STATUS_OK)
        self.assertEqual(second, [x ^ 3 for x in first])

    def test_no_feedback_before_first_valid_vector(self):
        core = VectorReference(lanes=4)
        status, output = core.execute([0, 1, 2, 3], 3, 0, True, 0, 0)
        self.assertEqual(status, STATUS_NO_FEEDBACK)
        self.assertEqual(output, [0] * 4)

    def test_invalid_branch_and_merge(self):
        core = VectorReference(lanes=4)
        self.assertEqual(core.execute([0]*4, 0, 0, False, 0, 0)[0], STATUS_BAD_BRANCH)
        self.assertEqual(core.execute([0]*4, 1, 1, False, 0, 0)[0], STATUS_BAD_MERGE)

    def test_width_is_checked(self):
        core = VectorReference(lanes=4)
        with self.assertRaises(ValueError):
            core.execute([0, 1], 3, 0, False, 0, 0)


    def test_bad_tkeep_does_not_seed_feedback(self):
        core = VectorReference(lanes=8)
        status, output = core.execute([0, 1, 2, 3, 0, 1, 2, 3], 3, 0,
                                      False, 0, 0, keep_valid=False)
        self.assertEqual(status, STATUS_BAD_TKEEP)
        self.assertEqual(output, [0] * 8)
        self.assertFalse(core.feedback_valid)
        status, _ = core.execute([0] * 8, 3, 0, True, 0, 0)
        self.assertEqual(status, STATUS_NO_FEEDBACK)

    def test_deterministic_randomized_128_lane_property(self):
        rng = random.Random(0x5241514D)
        core = VectorReference(lanes=128)
        for _ in range(2000):
            data = [rng.randrange(4) for _ in range(128)]
            mode = rng.choice((1, 2, 3))
            merge = 0 if mode == 1 else (1 if mode == 2 else rng.randrange(2))
            mask_b, mask_c = rng.randrange(4), rng.randrange(4)
            feedback = core.feedback_valid and (rng.randrange(4) == 0)
            if feedback:
                source = list(core.feedback)
            else:
                source = data
            expected_source = source
            chosen_mask = mask_c if merge else mask_b
            expected = [symbol ^ chosen_mask for symbol in expected_source]
            status, actual = core.execute(data, mode, merge, feedback, mask_b, mask_c)
            self.assertEqual(status, STATUS_OK)
            self.assertEqual(actual, expected)
            self.assertEqual(len(actual), 128)
            self.assertTrue(all(0 <= v <= 3 for v in actual))


if __name__ == "__main__":
    unittest.main()
