#!/usr/bin/env python3
"""Independent SymPy/Fraction replay for the C907 exact identities."""

import argparse
import json
from functools import reduce
from math import gcd
from pathlib import Path

import sympy as sp


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())

    u = sp.symbols("u", nonzero=True)
    rho = sp.symbols("rho")
    r = sp.sqrt(3)
    q = u**2
    K = 2 * sp.Matrix(
        [
            [0, 6 * q, 0, 36 * q**2],
            [1, 0, 15 * q, 0],
            [0, 1, 0, 6 * q],
            [0, 0, 1, 0],
        ]
    )
    G = sp.diag(sp.Rational(3, 2), sp.Rational(1, 2), -sp.Rational(1, 2), -sp.Rational(3, 2))
    P = sp.Matrix(
        [
            [1, 1, 0, 1],
            [sp.Rational(7, 18) * r / u, -sp.Rational(7, 18) * r / u, sp.Rational(4, 7), 0],
            [sp.Rational(1, 6) / u**2, sp.Rational(1, 6) / u**2, 0, -sp.Rational(1, 21) / u**2],
            [sp.Rational(1, 54) * r / u**3, -sp.Rational(1, 54) * r / u**3,
             -sp.Rational(2, 21) / u**2, 0],
        ]
    )
    J = sp.diag(6 * r * u, -6 * r * u, 0, 0)
    J[2, 3] = 1
    assert sp.simplify(K - P * J * P.inv()) == sp.zeros(4)

    transformed_G = sp.simplify(P.inv() * G * P)
    A1 = sp.Matrix(
        [
            [0, r / (648 * u), -sp.Rational(4, 63), -r / (63 * u)],
            [-r / (648 * u), 0, -sp.Rational(4, 63), r / (63 * u)],
            [sp.Rational(7, 108) / u**2, sp.Rational(7, 108) / u**2, 0, 0],
            [sp.Rational(7, 81) * r / u, -sp.Rational(7, 81) * r / u, 0, 0],
        ]
    )
    M1 = sp.simplify(J * A1 - A1 * J + transformed_G)
    expected_M1 = sp.diag(0, 0, -sp.Rational(19, 18), sp.Rational(19, 18))
    assert sp.simplify(M1 - expected_M1) == sp.zeros(4)
    R2 = sp.simplify(A1 * (A1 * J - J * A1) + transformed_G * A1 - A1 * transformed_G - A1)
    indicial = sp.expand(
        (rho - M1[2, 2]) * (rho + 1 - M1[3, 3]) - J[2, 3] * R2[3, 2]
    )
    assert sp.simplify(indicial - (rho**2 + rho + sp.Rational(5, 36))) == 0
    assert sp.solve(indicial, rho) == [sp.Rational(-5, 6), sp.Rational(-1, 6)]

    projective_checks = certificate["projective_stabilization"]["checks"]
    for check in projective_checks:
        m = check["m"]
        n = m + 1
        grading_trace = sum(sp.Rational(m, 2) - k for k in range(n))
        assert grading_trace == 0
        H = sp.zeros(n)
        for k in range(n - 1):
            H[k + 1, k] = 1
        H[0, n - 1] = 1
        assert H**n == sp.eye(n)
        assert check["formal_power_exponents"] == ["0"] * n

    surface = certificate["surface_carrier_exclusion_and_one_step_irrationality"]
    table = surface["nef_canonical_surface_grading_table"]
    assert len(table) == 5
    for row in table:
        degree = row["cohomological_degree"]
        grading = sp.Rational(degree - 2, 2)
        parity = int((degree - 2) % 2 != 0)
        integral_weight = grading + sp.Rational(parity, 2)
        assert integral_weight.q == 1
        assert row["grading_operator"] == str(grading)
        assert row["parity_projector"] == parity
        assert row["integral_gauge_weight"] == str(integral_weight)
    assert set(surface["all_surface_fractional_residues"]) == {"0", "1/2"}
    assert set(surface["cubic_fractional_residues"]) == {"-1/6", "1/6"}
    assert surface["residue_sets_disjoint"]
    assert surface["fourfold_weak_factorization_center_dimension_bound"] == 2

    cancellation_checks = certificate["coarse_blowup_cancellation_model"]["checks"]
    for check in cancellation_checks:
        m = check["stabilizing_projective_dimension_m"]
        weights = [t * (m - t) for t in range(1, m)]
        common_divisor = reduce(gcd, weights) if weights else 0
        predicted = 0 if m == 1 else (1 if m % 2 == 0 else 2)
        assert weights == check["center_weights_t_times_m_minus_t"]
        assert common_divisor == predicted == check["weight_gcd"]
        relation = check["explicit_signed_relation_by_t"]
        if relation is None:
            assert m == 1
            assert not check["endpoint_multiplicity_in_integer_span"]
        else:
            total = sum(int(coefficient) * weights[int(t) - 1] for t, coefficient in relation.items())
            assert total == m + 1
            assert check["endpoint_multiplicity_in_integer_span"]

    tate_checks = certificate["candidate_tate_graded_refinement"]["checks"]
    for check in tate_checks:
        m = check["stabilizing_projective_dimension_m"]
        assert check["endpoint_coefficients_low_to_high"] == [1] * (m + 1)
        for center in check["center_polynomials"]:
            t = center["t"]
            left = [1] * t
            right = [0] + [1] * (m - t)
            coefficients = [0] * (len(left) + len(right) - 1)
            for i, a in enumerate(left):
                for j, b in enumerate(right):
                    coefficients[i + j] += a * b
            coefficients += [0] * ((m + 1) - len(coefficients))
            assert center["coefficients_low_to_high"] == coefficients
            assert coefficients[0] == coefficients[-1] == 0
        assert check["endpoint_outside_center_integer_span_by_extreme_degrees"]

    print(
        "independent replay passed: indicial polynomial, projective checks "
        f"m=0..{len(projective_checks)-1}, surface exclusion, "
        f"cancellation and Tate checks m=1..{len(cancellation_checks)}"
    )


if __name__ == "__main__":
    main()
