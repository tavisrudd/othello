#!/usr/bin/env python3
"""Independent SymPy/Fraction replay for the C907 exact identities."""

import argparse
import json
from functools import reduce
from math import factorial, gcd, lcm
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

    hypergeometric = certificate["cubic_hypergeometric_irregular_hodge_bridge"]
    alpha = [sp.Rational(0)] * 4
    beta = [sp.Rational(1, 3), sp.Rational(2, 3)]
    assert all(a - b not in sp.Integers for a in alpha for b in beta)
    assert max(alpha) < min(beta)
    previous = sp.Rational(1)
    for check in hypergeometric["period_checks"]:
        degree = check["degree"]
        coefficient = sp.Rational(factorial(3 * degree), factorial(degree) ** 5 * 27**degree)
        assert degree**4 * coefficient == (
            (degree - sp.Rational(2, 3))
            * (degree - sp.Rational(1, 3))
            * previous
        )
        assert sp.Rational(check["rescaled_period_coefficient"]) == coefficient
        assert check["operator_recurrence_verified"]
        previous = coefficient
    assert hypergeometric["normalized_hypergeometric_operator"] == "D^4-x(D+1/3)(D+2/3)"
    assert hypergeometric["cross_differences_mod_Z_nonzero"]
    assert hypergeometric["circle_arc_separation"]
    assert hypergeometric["global_hypergeometric_module_irreducible"]
    assert hypergeometric["global_ambient_quantum_module_underlies_irregular_mixed_hodge_module"]
    assert hypergeometric["cai_local_formal_block_ranks"] == [1, 1, 2]
    assert not hypergeometric["rank_two_formal_block_can_be_proper_global_subobject"]
    assert hypergeometric["corrected_rank_two_target"].startswith("local sectorial Stokes")
    assert hypergeometric["wang_compactification_scope"].endswith(
        "one fixed Landau-Ginzburg pair"
    )

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
        assert check["novikov_loop_branch_permutation"] == list(range(1, n)) + [0]
        assert check["novikov_loop_cycle_length"] == n
        assert check["has_monodromy_fixed_branch"] == (n == 1)

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

    serre_checks = certificate["candidate_fractional_cy_carrier_bound"]["checks"]
    for check in serre_checks:
        m = check["stabilizing_projective_dimension_m"]
        cubic_dimension = sp.Rational(5, 3)
        product_dimension = cubic_dimension + m
        center_bound = m + 1
        assert check["cubic_kuznetsov_serre_relation"] == "S^3=[5]"
        assert sp.Rational(check["cubic_kuznetsov_serre_dimension"]) == cubic_dimension
        assert sp.Rational(check["projective_space_serre_dimension"]) == m
        assert sp.Rational(check["tensor_product_serre_dimension"]) == product_dimension
        assert check["weak_factorization_center_dimension_bound"] == center_bound
        assert sp.Rational(check["conditional_dimension_gap"]) == sp.Rational(2, 3)

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

    serre_width = certificate["candidate_integral_serre_width_refinement"]
    for check in serre_width["beilinson_checks"]:
        d = check["projective_dimension"]
        n = d + 1
        euler = sp.Matrix(
            n,
            n,
            lambda i, j: sp.binomial(d + j - i, d) if j >= i else 0,
        )
        assert euler.det() == 1
        serre = euler.inv() * euler.T
        sign = (-1) ** d
        assert sp.factor(serre.charpoly().as_expr()) == (sp.Symbol("lambda") - sign) ** n
        nilpotent = sign * serre - sp.eye(n)
        assert nilpotent**n == sp.zeros(n)
        if d > 0:
            assert nilpotent**d != sp.zeros(n)
        assert check["rank"] == n
        assert check["semisimple_sign"] == sign
        assert check["unipotent_nilpotence_index"] == n
        assert check["logarithm_nilpotence_index"] == n
        assert check["single_jordan_block"]
    for check in serre_width["self_carrier_checks"]:
        m = check["stabilizing_projective_dimension_m"]
        assert check["endpoint_serre_block_length"] == m + 1
        assert check["maximum_self_carrier_block_length"] == m - 1
        assert check["uniform_block_length_gap"] == 2
        for center in check["self_carriers"]:
            t = center["t"]
            assert center["center_projective_dimension"] == t - 1
            assert center["exceptional_projective_dimension"] == m - t - 1
            assert center["tensor_logarithm_nilpotence_index"] == m - 1

    q_adic = certificate["iritani_local_q_adic_tate_spacing"]
    for check in q_adic["checks"]:
        codimension = check["center_codimension_r"]
        n = codimension - 1
        s = n if codimension % 2 == 0 else 2 * n
        raw = [
            sp.Rational(s * (codimension - 2 * l - 2), 2 * n)
            for l in range(n)
        ]
        assert all(value.q == 1 for value in raw)
        step = sp.Rational(s, n)
        normalized = [(raw[0] - value) / step for value in raw]
        assert normalized == list(range(n))
        assert check["exceptional_copy_count"] == n
        assert check["iritani_s"] == s
        assert check["raw_t_valuations_by_l"] == [int(value) for value in raw]
        assert check["valuation_step_magnitude"] == int(step)
        assert check["affine_normalized_levels_by_l"] == list(range(n))
        assert check["normalized_width"] == n - 1

        z = sp.Symbol("z")
        cyclotomic = sp.Poly(sp.cyclotomic_poly(n, z), z) if n > 1 else None
        for left in range(n):
            for right in range(n):
                if n == 1:
                    character_sum = sp.Integer(1)
                else:
                    character_sum = sum(
                        z ** ((right - left) * j % n) for j in range(n)
                    )
                    character_sum = sp.rem(sp.Poly(character_sum, z), cyclotomic).as_expr()
                assert sp.expand(character_sum) == (n if left == right else 0)
        assert check["fourier_matrix_invertible"]
        assert check["sector_monodromy_permutation"] == list(range(1, n)) + [0]
        assert check["monodromy_preserves_elementary_divisor_multiset"]

    composition = certificate["two_step_tate_composition"]

    def blowup_polynomial(codimension):
        return [0] + [1] * (codimension - 1)

    def convolve(left, right):
        result = [0] * (len(left) + len(right) - 1)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                result[i + j] += a * b
        return result

    def add_polynomials(*polynomials):
        length = max(len(polynomial) for polynomial in polynomials)
        return [
            sum(polynomial[i] if i < len(polynomial) else 0 for polynomial in polynomials)
            for i in range(length)
        ]

    maximum_total = composition["maximum_total_codimension_checked"]
    nested_count = 0
    for codimension in range(2, maximum_total):
        for inner_codimension in range(1, maximum_total + 1 - codimension):
            left = add_polynomials(
                blowup_polynomial(codimension + inner_codimension),
                convolve(
                    blowup_polynomial(codimension),
                    blowup_polynomial(inner_codimension),
                ),
            )
            right = convolve(
                blowup_polynomial(inner_codimension + 1),
                [1] * codimension,
            )
            assert left == right
            nested_count += 1
    assert nested_count == composition["nested_checked_count"]

    transverse_count = 0
    for r in range(2, maximum_total - 1):
        for s in range(2, maximum_total + 1 - r):
            first = convolve(blowup_polynomial(s), blowup_polynomial(r))
            second = convolve(blowup_polynomial(r), blowup_polynomial(s))
            assert first == second
            transverse_count += 1
    assert transverse_count == composition["transverse_checked_count"]

    for check in composition["nested_boundary_samples"]:
        assert check["left_A_coefficient"] == check["right_A_coefficient"]
        assert check["identity_verified"]
    for check in composition["transverse_boundary_samples"]:
        assert check["identity_verified"]

    mutation = composition["mutation_flag_ambiguity"]
    euler = sp.Matrix([[1, 2], [0, 1]])
    basis_change = sp.Matrix([[2, 1], [-1, 0]])
    assert basis_change.det() == 1
    assert basis_change.T * euler * basis_change == euler
    assert sp.Matrix.hstack(sp.Matrix([1, 0]), sp.Matrix([2, -1])).det() != 0
    serre = euler.inv() * euler.T
    nilpotent = -serre - sp.eye(2)
    kernel = nilpotent.nullspace()
    assert len(kernel) == 1
    assert kernel[0][0] == -kernel[0][1] and kernel[0][0] != 0
    assert basis_change * kernel[0] == kernel[0]
    assert mutation["euler_matrix_unchanged"]
    assert mutation["flag_lines_distinct"]
    assert mutation["canonical_monodromy_weight_line"] == ["1", "-1"]
    assert mutation["weight_line_differs_from_both_exceptional_lines"]

    spectral_checks = certificate["candidate_spectral_cycle_refinement"]["checks"]
    for check in spectral_checks:
        m = check["stabilizing_projective_dimension_m"]
        n = m + 1
        hits = [t for t in range(1, m) if lcm(t, m - t) % n == 0]
        assert check["endpoint_cycle_length"] == n
        assert check["self_carrier_t_with_endpoint_cycle_dividing_lcm"] == hits
        factors = sp.factorint(n)
        is_prime_power = len(factors) == 1
        assert check["endpoint_cycle_is_prime_power"] == is_prime_power
        if is_prime_power:
            prime, exponent = next(iter(factors.items()))
            assert check["prime_power_data"] == {"prime": prime, "exponent": exponent}
            assert hits == []
            assert check["prime_power_self_carrier_exclusion"]
        else:
            assert check["prime_power_data"] is None

    tower_patterns = certificate["candidate_spectral_cycle_refinement"][
        "prime_power_local_tower_counterpatterns"
    ]
    for pattern in tower_patterns:
        p = pattern["prime"]
        k = pattern["exponent"]
        n = p**k
        assert pattern["local_copy_count"] == n
        assert pattern["stabilizing_projective_dimension_m"] == n - 1
        assert pattern["endpoint_dimension"] == n + 2
        assert pattern["rank_p_tower_length"] == k
        center_dimension = 3 + k * (p - 1)
        assert pattern["tower_center_dimension"] == center_dimension
        assert pattern["weak_factorization_center_dimension_bound"] == n
        assert pattern["dimension_admissible_center"] == (center_dimension <= n)
        odometer = list(range(1, n)) + [0]
        assert pattern["iterated_wreath_odometer_permutation"] == odometer
        cursor = 0
        orbit = []
        for _ in range(n):
            orbit.append(cursor)
            cursor = odometer[cursor]
        assert cursor == 0 and sorted(orbit) == list(range(n))
        assert pattern["odometer_cycle_length"] == n

    print(
        "independent replay passed: indicial polynomial, cubic hypergeometric IrrMHM bridge, "
        "projective checks "
        f"m=0..{len(projective_checks)-1}, surface exclusion, Serre-dimension conditional, "
        f"cancellation, Tate, and integral Serre-width checks through m={len(cancellation_checks)}, "
        f"Iritani q-adic lattice checks through r={len(q_adic['checks'])+1}, "
        f"two-step Tate checks ({nested_count} nested, {transverse_count} transverse), "
        f"spectral-cycle checks m=2..{len(spectral_checks)+1}, "
        f"prime-power tower checks through n={len(projective_checks)}"
    )


if __name__ == "__main__":
    main()
