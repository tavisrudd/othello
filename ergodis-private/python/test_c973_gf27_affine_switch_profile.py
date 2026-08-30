from pathlib import Path
import unittest

from c973_gf27_affine_switch_profile import extract


class C973Gf27AffineSwitchProfileTest(unittest.TestCase):
    def test_frozen_witness_sample_has_radius_at_most_two(self) -> None:
        root = Path(__file__).resolve().parents[2]
        result = extract(
            root / "notes/reed-solomon-tasks/c973-gf27-switch-probe/out/certify-witness-sample.tsv"
        )
        self.assertEqual(result["affine_F3_planes"], 39)
        self.assertEqual(result["witnesses"], 200)
        self.assertEqual(result["maximum_plane_overlap_histogram"], {"7": 175, "8": 24, "9": 1})
        self.assertEqual(result["maximum_replacement_distance"], 2)

    def test_complete_e3_locator_set_has_radius_at_most_four(self) -> None:
        root = Path(__file__).resolve().parents[2]
        result = extract(
            root / "notes/reed-solomon-tasks/c973-gf27-switch-probe/out/e3-ninesets.tsv"
        )
        self.assertEqual(result["witnesses"], 266)
        self.assertEqual(result["weighted_witnesses"], 6890)
        self.assertEqual(result["maximum_plane_overlap_histogram"], {"5": 155, "6": 108, "7": 3})
        self.assertEqual(
            result["weighted_maximum_plane_overlap_histogram"],
            {"5": 4004, "6": 2808, "7": 78},
        )
        self.assertEqual(result["maximum_replacement_distance"], 4)


if __name__ == "__main__":
    unittest.main()
