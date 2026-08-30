import importlib.util
from pathlib import Path
import sys
import unittest


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
SPEC = importlib.util.spec_from_file_location(
    "c973_gf27_orbit_core", HERE / "c973_gf27_orbit_core.py"
)
assert SPEC is not None and SPEC.loader is not None
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


class C973Gf27OrbitCoreTest(unittest.TestCase):
    def test_frozen_extremal_certificate_compresses_to_three_orbits(self) -> None:
        source = (
            HERE.parent.parent
            / "notes/reed-solomon-tasks/c973-gf27-switch-probe/out/e3-good78.tsv"
        )
        extremes = (
            HERE.parent.parent
            / "notes/reed-solomon-tasks/c973-gf27-switch-probe/out/extremes.tsv"
        )
        result = MODULE.extract(source, extremes)
        self.assertEqual(result["input_witnesses"], 78)
        self.assertEqual(result["torus_orbits"], 3)
        self.assertEqual(result["compression_ratio"], 26.0)
        self.assertEqual(result["semilinear_orbits"], 1)
        self.assertEqual(result["semilinear_compression_ratio"], 78.0)
        self.assertEqual(
            {orbit["lambda_label"] for orbit in result["orbits"]},
            {"l1", "l2", "l3"},
        )
        self.assertTrue(all(orbit["orbit_size"] == 26 for orbit in result["orbits"]))
        self.assertEqual(result["semilinear_orbit_cores"][0]["orbit_size"], 78)
        self.assertEqual(result["semilinear_seed_switch"]["removed"], [24, 26])
        self.assertEqual(result["semilinear_seed_switch"]["added"], [3, 19])
        self.assertEqual(
            result["semilinear_seed_switch"]["plane_locator_coefficients_low_to_high"],
            [0, 16, 0, 22, 0, 0, 0, 0, 0, 1],
        )
        self.assertEqual(result["semilinear_seed_switch"]["closing_coefficients"], {"g_2": 0, "g_3": 0})
        self.assertEqual(
            result["extremal_curve_core"]["formula"],
            "(z2,...,z8)=(0,1,t,t^2,-t^3,-t^4,-t^5)",
        )
        self.assertTrue(result["extremal_curve_core"]["exact_set_equality"])
        self.assertEqual(
            result["extremal_curve_core"]["divided_power_coefficients_mod_3"],
            [1, 1, 1, 2, 2, 2],
        )


if __name__ == "__main__":
    unittest.main()
