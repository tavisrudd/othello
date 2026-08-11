#!/usr/bin/env sage
"""Exact C907 certificate generator for cubic quantum monodromy.

This reconstructs Cai's rank-two indicial polynomial over Q(sqrt(3))(u),
where q = u^2, checks the projective-space grading contribution exactly for
P^m with 0 <= m <= the requested bound, and audits the coarse blow-up atom
multiplicity model for stabilization dimensions 1 <= m <= the bound.
"""

import argparse
import json
from functools import reduce
from math import gcd, lcm
from pathlib import Path

import sage.version


SCHEMA = "c907-quantum-monodromy-stabilization-v7"


def matrix_strings(M):
    return [[str(M[i, j]) for j in range(M.ncols())] for i in range(M.nrows())]


def cai_certificate():
    number_field = QuadraticField(3, "r")
    r = number_field.gen()
    function_field = FunctionField(number_field, "u")
    u = function_field.gen()
    q = u**2

    K = 2 * matrix(
        function_field,
        [
            [0, 6 * q, 0, 36 * q**2],
            [1, 0, 15 * q, 0],
            [0, 1, 0, 6 * q],
            [0, 0, 1, 0],
        ],
    )
    G = diagonal_matrix(
        function_field,
        [function_field(3) / 2, function_field(1) / 2,
         -function_field(1) / 2, -function_field(3) / 2],
    )

    J, P = K.jordan_form(transformation=True)
    assert K == P * J * P.inverse()
    transformed_G = P.inverse() * G * P

    block_label = [0, 1, 2, 2]
    positions = [
        (i, j)
        for i in range(4)
        for j in range(4)
        if block_label[i] != block_label[j]
    ]
    off_block_basis = []
    for i, j in positions:
        elementary = matrix(function_field, 4, 4)
        elementary[i, j] = 1
        off_block_basis.append(elementary)

    sylvester = matrix(
        function_field,
        [
            [(J * E - E * J)[i, j] for E in off_block_basis]
            for i, j in positions
        ],
    )
    target = vector(function_field, [-transformed_G[i, j] for i, j in positions])
    coefficients = sylvester.solve_right(target)
    A1 = sum(
        (coefficients[k] * off_block_basis[k] for k in range(len(off_block_basis))),
        matrix(function_field, 4, 4),
    )

    M1 = J * A1 - A1 * J + transformed_G
    assert all(
        M1[i, j] == 0
        for i, j in positions
    )
    R2 = A1 * (A1 * J - J * A1) + (transformed_G * A1 - A1 * transformed_G) - A1

    polynomial_ring = PolynomialRing(function_field, "rho")
    rho = polynomial_ring.gen()
    d11 = M1[2, 2]
    d22 = M1[3, 3]
    jordan_link = J[2, 3]
    return_link = R2[3, 2]
    indicial = (rho - d11) * (rho + 1 - d22) - jordan_link * return_link
    expected = rho**2 + rho + polynomial_ring(5) / 36
    assert indicial == expected
    assert sorted(root for root, multiplicity in indicial.roots() for _ in range(multiplicity)) == [
        function_field(-5) / 6,
        function_field(-1) / 6,
    ]

    return {
        "coefficient_field": "Q(sqrt(3))(u), q=u^2",
        "source_K": matrix_strings(K),
        "source_G": matrix_strings(G),
        "jordan_K": matrix_strings(J),
        "basis_change_verified": True,
        "rank_two_M1": matrix_strings(M1[2:4, 2:4]),
        "rank_two_R2": matrix_strings(R2[2:4, 2:4]),
        "rank_two_data": {
            "d11": str(d11),
            "d22": str(d22),
            "jordan_link": str(jordan_link),
            "return_link": str(return_link),
        },
        "indicial_polynomial": str(indicial),
        "roots": ["-5/6", "-1/6"],
        "fractional_residues_mod_Z": ["-1/6", "1/6"],
    }


def projective_space_check(m):
    n = m + 1
    if n == 1:
        field = QQ
        roots = [QQ(1)]
    else:
        field = CyclotomicField(n)
        zeta = field.gen()
        roots = [zeta**j for j in range(n)]

    H = matrix(field, n, n)
    for k in range(n - 1):
        H[k + 1, k] = 1
    H[0, n - 1] = 1
    K = n * H
    G = diagonal_matrix(field, [field(m) / 2 - k for k in range(n)])
    eigenbasis = matrix(
        field,
        n,
        n,
        lambda row, col: roots[col] ** (-row),
    )
    assert eigenbasis.is_invertible()
    diagonal_K = eigenbasis.inverse() * K * eigenbasis
    transformed_G = eigenbasis.inverse() * G * eigenbasis
    assert diagonal_K.is_diagonal()
    assert all(transformed_G[j, j] == 0 for j in range(n))
    assert K**n == (n**n) * identity_matrix(field, n)

    return {
        "m": m,
        "rank": n,
        "cyclic_power_identity": True,
        "semisimple_eigenbasis_verified": True,
        "formal_power_exponents": ["0"] * n,
        "novikov_loop_branch_permutation": list(range(1, n)) + [0],
        "novikov_loop_cycle_length": n,
        "has_monodromy_fixed_branch": n == 1,
        "cubic_rank_two_copies_after_product": n,
        "cubic_fractional_residues_after_product": ["-1/6", "1/6"],
    }


def coarse_cancellation_check(m):
    target = m + 1
    weights = [t * (m - t) for t in range(1, m)]
    common_divisor = reduce(gcd, weights) if weights else 0

    if m == 1:
        relation = None
        target_in_integer_span = False
    elif m == 2:
        relation = {"1": 3}
        target_in_integer_span = 3 * weights[0] == target
    elif m % 2 == 0:
        relation = {"1": 3, "2": -1}
        target_in_integer_span = 3 * weights[0] - weights[1] == target
    else:
        factor = (m + 1) // 2
        relation = {"1": 2 * factor, "2": -factor}
        target_in_integer_span = 2 * factor * weights[0] - factor * weights[1] == target

    predicted_gcd = 0 if m == 1 else (1 if m % 2 == 0 else 2)
    assert common_divisor == predicted_gcd
    if m >= 2:
        assert target_in_integer_span
        assert target % common_divisor == 0

    return {
        "stabilizing_projective_dimension_m": m,
        "endpoint_cubic_atom_multiplicity": target,
        "center_weights_t_times_m_minus_t": weights,
        "weight_gcd": common_divisor,
        "predicted_gcd": predicted_gcd,
        "endpoint_multiplicity_in_integer_span": target_in_integer_span,
        "explicit_signed_relation_by_t": relation,
    }


def convolution(left, right):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return result


def polynomial_sum(*polynomials):
    length = max(len(polynomial) for polynomial in polynomials)
    return [
        sum(polynomial[i] if i < len(polynomial) else 0 for polynomial in polynomials)
        for i in range(length)
    ]


def blowup_tate_coefficients(codimension):
    """Coefficients of T+...+T^(codimension-1), including the zero codim-1 case."""
    assert codimension >= 1
    return [0] + [1] * (codimension - 1)


def nested_blowup_coherence_check(r, c):
    """Tate ledger for a flag A subset Z subset X.

    Here codim_X(Z)=r and codim_Z(A)=c.  Compare blowing up A and then
    Bl_A(Z) with blowing up Z and then P(N_{Z/X}|_A).
    """
    assert r >= 2 and c >= 1
    p_r = blowup_tate_coefficients(r)
    p_c = blowup_tate_coefficients(c)
    p_r_plus_c = blowup_tate_coefficients(r + c)
    p_c_plus_one = blowup_tate_coefficients(c + 1)
    projective_r_minus_one = [1] * r

    left_direct_a = p_r_plus_c
    left_a_via_strict_transform_z = convolution(p_r, p_c)
    left = polynomial_sum(left_direct_a, left_a_via_strict_transform_z)
    right = convolution(p_c_plus_one, projective_r_minus_one)
    assert left == right

    return {
        "codimension_Z_in_X_r": r,
        "codimension_A_in_Z_c": c,
        "left_A_coefficient": left,
        "right_A_coefficient": right,
        "identity_verified": True,
    }


def transverse_blowup_coherence_check(r, s):
    """Tate ledger for transverse centers of codimensions r and s."""
    assert r >= 2 and s >= 2
    first_a_then_b = convolution(
        blowup_tate_coefficients(s), blowup_tate_coefficients(r)
    )
    first_b_then_a = convolution(
        blowup_tate_coefficients(r), blowup_tate_coefficients(s)
    )
    assert first_a_then_b == first_b_then_a
    return {
        "codimension_A_r": r,
        "codimension_B_s": s,
        "intersection_coefficient_both_orders": first_a_then_b,
        "identity_verified": True,
    }


def mutation_flag_ambiguity_check():
    """The P^1 Euler/Serre data do not select its exceptional flag."""
    euler = matrix(QQ, [[1, 2], [0, 1]])
    mutation = matrix(QQ, [[2, 1], [-1, 0]])
    assert mutation.det() == 1
    assert mutation.transpose() * euler * mutation == euler
    original_first_line = vector(QQ, [1, 0])
    mutated_first_line = vector(QQ, [2, -1])
    assert matrix(QQ, [original_first_line, mutated_first_line]).det() != 0

    serre = euler.inverse() * euler.transpose()
    normalized_unipotent = -serre
    nilpotent = normalized_unipotent - identity_matrix(QQ, 2)
    weight_line = nilpotent.right_kernel().basis()[0]
    assert nilpotent.rank() == 1
    assert mutation * weight_line in span(QQ, [weight_line])
    assert original_first_line not in span(QQ, [weight_line])
    assert mutated_first_line not in span(QQ, [weight_line])

    return {
        "category": "D^b(P^1)",
        "original_exceptional_pair": ["O", "O(1)"],
        "mutated_exceptional_pair": ["O(-1)", "O"],
        "euler_matrix": matrix_strings(euler),
        "mutation_basis_matrix": matrix_strings(mutation),
        "euler_matrix_unchanged": True,
        "original_first_flag_line": [1, 0],
        "mutated_first_flag_line": [2, -1],
        "flag_lines_distinct": True,
        "normalized_serre_nilpotent": matrix_strings(nilpotent),
        "canonical_monodromy_weight_line": [str(value) for value in weight_line],
        "weight_line_differs_from_both_exceptional_lines": True,
    }


def two_step_tate_composition_certificate(bound):
    nested = [
        nested_blowup_coherence_check(r, c)
        for r in range(2, bound + 2)
        for c in range(1, bound + 3 - r)
    ]
    transverse = [
        transverse_blowup_coherence_check(r, s)
        for r in range(2, bound + 1)
        for s in range(2, bound + 3 - r)
    ]
    nested_samples = [
        check
        for check in nested
        if (check["codimension_Z_in_X_r"], check["codimension_A_in_Z_c"])
        in {(2, 1), (2, bound), (bound + 1, 1)}
    ]
    transverse_samples = [
        check
        for check in transverse
        if (check["codimension_A_r"], check["codimension_B_s"])
        in {(2, 2), (2, bound), (bound, 2)}
    ]
    return {
        "status": (
            "Positive coherence for the classically normalized candidate associated graded. "
            "Its Tate polynomials agree under the standard transverse and nested two-step "
            "blow-up exchanges. This removes blow-up order as an obstruction at the polynomial "
            "level, but does not compare the multivariable Novikov lattices or identify the "
            "Stokes extension data or a presentation-independent filtration."
        ),
        "polynomial_convention": "P_r(T)=T+...+T^(r-1)",
        "nested_general_identity": (
            "P_(r+c)+P_r*P_c=P_(c+1)*(1+P_r), for r>=2 and c>=1"
        ),
        "transverse_general_identity": "P_s*P_r=P_r*P_s, for r,s>=2",
        "maximum_total_codimension_checked": bound + 2,
        "nested_checked_domain": "2<=r, 1<=c, r+c<=bound+2",
        "nested_checked_count": len(nested),
        "nested_boundary_samples": nested_samples,
        "transverse_checked_domain": "2<=r,s, r+s<=bound+2",
        "transverse_checked_count": len(transverse),
        "transverse_boundary_samples": transverse_samples,
        "mutation_flag_ambiguity": mutation_flag_ambiguity_check(),
        "interpretation": (
            "The associated graded passes the elementary order-exchange tests. However, "
            "the P^1 mutation calculation shows that identical Euler and Serre data admit "
            "different exceptional flags; the canonical monodromy weight line is neither "
            "exceptional first line. A Stokes chamber or a new intrinsic strict filtration "
            "is therefore additional data."
        ),
    }


def tate_graded_candidate_check(m):
    endpoint = [1] * (m + 1)
    center_polynomials = []
    for t in range(1, m):
        center_projective_factor = [1] * t
        exceptional_factor = [0] + [1] * (m - t)
        coefficients = convolution(center_projective_factor, exceptional_factor)
        coefficients += [0] * ((m + 1) - len(coefficients))
        assert len(coefficients) == m + 1
        assert coefficients[0] == 0
        assert coefficients[m] == 0
        center_polynomials.append({"t": t, "coefficients_low_to_high": coefficients})
    return {
        "stabilizing_projective_dimension_m": m,
        "endpoint_coefficients_low_to_high": endpoint,
        "center_polynomials": center_polynomials,
        "endpoint_outside_center_integer_span_by_extreme_degrees": True,
    }


def surface_carrier_exclusion():
    dimension = 2
    grading_table = []
    for cohomological_degree in range(2 * dimension + 1):
        grading = QQ(cohomological_degree - dimension) / 2
        parity_projector = int((cohomological_degree - dimension) % 2 != 0)
        integral_gauge_weight = grading + QQ(parity_projector) / 2
        assert integral_gauge_weight in ZZ
        grading_table.append(
            {
                "cohomological_degree": cohomological_degree,
                "grading_operator": str(grading),
                "parity_projector": parity_projector,
                "integral_gauge_weight": str(integral_gauge_weight),
                "fractional_exponent_after_undoing_half_parity_shift": (
                    "1/2" if parity_projector else "0"
                ),
            }
        )
    allowed = {"0", "1/2"}
    cubic = {"-1/6", "1/6"}
    assert allowed.isdisjoint(cubic)
    return {
        "nef_canonical_surface_grading_table": grading_table,
        "nef_surface_argument": (
            "KKPYY Claim 6.15 gauges the connection plus one-half the parity projector "
            "by the integral weights in this table to a nilpotent-residue regular singular connection."
        ),
        "negative_kodaira_dimension_reduction": (
            "Minimal surfaces are P^2 or ruled over a curve; projective-bundle and blow-up "
            "decompositions reduce their fractional exponents to points and curves."
        ),
        "all_surface_fractional_residues": sorted(allowed),
        "cubic_fractional_residues": sorted(cubic),
        "residue_sets_disjoint": True,
        "fourfold_weak_factorization_center_dimension_bound": 2,
        "one_step_conclusion": "For every smooth cubic threefold X, X x P^1 is irrational.",
    }


def serre_dimension_candidate_check(m):
    cubic_serre_dimension = QQ(5) / 3
    projective_serre_dimension = QQ(m)
    product_serre_dimension = cubic_serre_dimension + projective_serre_dimension
    center_dimension_bound = m + 1
    gap = product_serre_dimension - center_dimension_bound
    assert gap == QQ(2) / 3
    return {
        "stabilizing_projective_dimension_m": m,
        "cubic_kuznetsov_serre_relation": "S^3=[5]",
        "cubic_kuznetsov_serre_dimension": str(cubic_serre_dimension),
        "projective_space_serre_dimension": str(projective_serre_dimension),
        "tensor_product_serre_dimension": str(product_serre_dimension),
        "weak_factorization_center_dimension_bound": center_dimension_bound,
        "conditional_dimension_gap": str(gap),
    }


def beilinson_serre_width_check(d):
    """Exact Euler/Coxeter calculation for the Beilinson lattice of P^d."""
    n = d + 1
    euler = matrix(
        QQ,
        n,
        n,
        lambda i, j: binomial(d + j - i, d) if j >= i else 0,
    )
    assert euler.det() == 1
    serre = euler.inverse() * euler.transpose()
    sign = (-1) ** d
    polynomial_ring = PolynomialRing(QQ, "lambda")
    lam = polynomial_ring.gen()
    assert serre.charpoly(lam) == (lam - sign) ** n
    unipotent = sign * serre
    nilpotent = unipotent - identity_matrix(QQ, n)
    assert nilpotent ** n == 0
    if d > 0:
        assert nilpotent ** d != 0
    logarithm = sum(
        (((-1) ** (j + 1)) * nilpotent**j / QQ(j) for j in range(1, n)),
        matrix(QQ, n, n),
    )
    assert logarithm ** n == 0
    if d > 0:
        assert logarithm ** d != 0
    return {
        "projective_dimension": d,
        "rank": n,
        "euler_matrix_formula": "E[i,j]=binomial(d+j-i,d) for j>=i, else 0",
        "euler_determinant": 1,
        "serre_matrix_formula": "C=E^(-1)E^T",
        "serre_characteristic_polynomial": str((lam - sign) ** n),
        "semisimple_sign": sign,
        "unipotent_nilpotence_index": n,
        "logarithm_nilpotence_index": n,
        "single_jordan_block": True,
    }


def self_carrier_serre_width_check(m):
    assert m >= 2
    endpoint_block_length = m + 1
    centers = []
    for t in range(1, m):
        center_projective_dimension = t - 1
        exceptional_projective_dimension = m - t - 1
        product_logarithm_index = (
            center_projective_dimension + exceptional_projective_dimension + 1
        )
        assert product_logarithm_index == m - 1
        centers.append(
            {
                "t": t,
                "center_projective_dimension": center_projective_dimension,
                "exceptional_projective_dimension": exceptional_projective_dimension,
                "tensor_logarithm_nilpotence_index": product_logarithm_index,
            }
        )
    return {
        "stabilizing_projective_dimension_m": m,
        "endpoint_serre_block_length": endpoint_block_length,
        "self_carriers": centers,
        "maximum_self_carrier_block_length": m - 1,
        "uniform_block_length_gap": 2,
    }


def iritani_q_adic_lattice_check(r):
    """Elementary divisors of Iritani's leading exceptional Fourier block.

    Here r is the codimension of the blow-up center and t=q^(-1/s) is the
    uniformizer used in Iritani (5.11).  Formulae (5.19) and (5.27) give the
    l-th exceptional column, up to units and lower q-order terms, as
    q_Z q^((l+1)/(r-1)) times a Fourier character.
    """
    assert r >= 2
    n = r - 1
    s = n if r % 2 == 0 else 2 * n
    if n == 1:
        field = QQ
        zeta = field(1)
    else:
        field = CyclotomicField(n)
        zeta = field.gen()
    fourier = matrix(
        field,
        n,
        n,
        lambda j, l: zeta ** (-j * (l + 1)),
    )
    assert fourier.is_invertible()

    raw_valuations = [
        QQ(s * (r - 2 * l - 2)) / (2 * (r - 1))
        for l in range(n)
    ]
    assert all(value in ZZ for value in raw_valuations)
    step = QQ(s) / (r - 1)
    normalized = [(raw_valuations[0] - value) / step for value in raw_valuations]
    assert normalized == list(range(n))

    return {
        "center_codimension_r": r,
        "exceptional_copy_count": n,
        "uniformizer": f"t=q^(-1/{s})",
        "iritani_s": s,
        "q_Z_exponent_in_q": f"-{r}/(2*{r - 1})",
        "leading_exceptional_column_formula": (
            "unit_l * q_Z * q^((l+1)/(r-1)) * "
            "(zeta^(-j(l+1)))_j, modulo lower q-order terms"
        ),
        "fourier_matrix_invertible": True,
        "raw_t_valuations_by_l": [int(value) for value in raw_valuations],
        "valuation_step_magnitude": int(step),
        "affine_normalized_levels_by_l": [int(value) for value in normalized],
        "normalized_width": n - 1,
        "sector_monodromy_permutation": list(range(1, n)) + [0],
        "monodromy_preserves_elementary_divisor_multiset": True,
    }


def spectral_cycle_self_carrier_check(m):
    endpoint_cycle = m + 1
    reproducing_t = [
        t for t in range(1, m) if lcm(t, m - t) % endpoint_cycle == 0
    ]
    prime_divisors = ZZ(endpoint_cycle).prime_divisors()
    is_prime_power = len(prime_divisors) == 1
    if is_prime_power:
        prime = int(prime_divisors[0])
        exponent = 0
        remainder = endpoint_cycle
        while remainder % prime == 0:
            exponent += 1
            remainder //= prime
        assert remainder == 1
        assert reproducing_t == []
        prime_power_data = {"prime": prime, "exponent": exponent}
    else:
        prime_power_data = None
    return {
        "stabilizing_projective_dimension_m": m,
        "endpoint_cycle_length": endpoint_cycle,
        "self_carrier_t_with_endpoint_cycle_dividing_lcm": reproducing_t,
        "endpoint_cycle_is_prime_power": is_prime_power,
        "prime_power_data": prime_power_data,
        "prime_power_self_carrier_exclusion": is_prime_power and not reproducing_t,
    }


def prime_power_tower_counterpatterns(bound):
    """Dimension audit for the local-copy/wreath loophole.

    A k-stage tower of rank-p projective bundles over the cubic has dimension
    3+k(p-1) and p^k local copies of the cubic atom.  The published local
    projective-bundle theorem does not retain global monodromy.  If one adds
    arbitrary continuation, the compatible iterated wreath group contains
    the p^k-cycle given by the p-adic odometer.
    """
    patterns = []
    for n in range(2, bound + 2):
        prime_divisors = ZZ(n).prime_divisors()
        if len(prime_divisors) != 1:
            continue
        prime = int(prime_divisors[0])
        exponent = 0
        remainder = n
        while remainder % prime == 0:
            exponent += 1
            remainder //= prime
        assert remainder == 1
        center_dimension = 3 + exponent * (prime - 1)
        endpoint_dimension = n + 2
        center_dimension_bound = endpoint_dimension - 2
        odometer = list(range(1, n)) + [0]
        assert sorted(odometer) == list(range(n))
        cursor = 0
        orbit = []
        for _ in range(n):
            orbit.append(cursor)
            cursor = odometer[cursor]
        assert cursor == 0
        assert sorted(orbit) == list(range(n))
        patterns.append(
            {
                "prime": prime,
                "exponent": exponent,
                "local_copy_count": n,
                "stabilizing_projective_dimension_m": n - 1,
                "endpoint_dimension": endpoint_dimension,
                "rank_p_tower_length": exponent,
                "tower_center_dimension": center_dimension,
                "weak_factorization_center_dimension_bound": center_dimension_bound,
                "dimension_admissible_center": center_dimension <= center_dimension_bound,
                "iterated_wreath_odometer_permutation": odometer,
                "odometer_cycle_length": n,
            }
        )
    return patterns


def build_certificate(bound):
    assert bound >= 3
    return {
        "schema": SCHEMA,
        "sage_version": sage.version.version,
        "source": {
            "paper": "Jiaji Cai, The cubic threefold is symplectically irrational",
            "arxiv": "2608.01577v1",
            "cached_pdf_sha256": "06bfccf9b67ed8cf224f5e7cc6ba2088271577787e2f8e0dd895c0ef3b404a9e",
            "equation_convention": "z^2 dS/dz = (K + zG)S",
        },
        "blowup_source": {
            "paper": "Hiroshi Iritani, Quantum cohomology of blowups",
            "arxiv": "2307.13555",
            "cached_pdf_sha256": "c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b",
            "formulae": ["(5.11)", "(5.19)", "(5.27)", "Theorem 5.18", "Remark 1.5"],
        },
        "composition_source": {
            "paper": (
                "Franziska Bittner, The universal Euler characteristic for varieties "
                "of characteristic zero"
            ),
            "arxiv": "math/0111062",
            "cached_pdf_sha256": "484d2c3586977503dc6f1b43fca158af059cd0f9c5322731d0ebae6d643e160c",
            "result": "Theorem 3.1, blow-up presentation of K_0(Var_k)",
        },
        "filtration_sources": [
            {
                "paper": "Claude Sabbah, Irregular Hodge theory",
                "arxiv": "1511.00176v5",
                "cached_pdf_sha256": "8221dd998d7b6459c525255c92755b2a60229088eb851a182be961528540b3ba",
                "results": ["Theorem 0.3", "Theorem 0.7", "Theorem 3.39"],
            },
            {
                "paper": (
                    "Claude Sabbah and Jeng-Daw Yu, On the irregular Hodge filtration "
                    "of exponentially twisted mixed Hodge modules"
                ),
                "arxiv": "1406.1339",
                "cached_pdf_sha256": "d034597e2f31a3cf400130b2a9124733438062014a603c82c0a54ea7a2cec22d",
                "results": ["strict projective pushforward", "Kontsevich-bundle comparison"],
            },
            {
                "paper": "Yichen Qin and Dingxin Zhang, Classical and irregular Hodge numbers",
                "arxiv": "2603.06040",
                "cached_pdf_sha256": "95b699eb50c830dea8b5b6241bcc4450e1be8c72b50f20350741101b9efed6f5",
                "results": ["Theorem 1.1.1", "Theorem 1.3.1"],
            },
        ],
        "cai_rank_two_certificate": cai_certificate(),
        "projective_stabilization": {
            "general_statement": (
                "The P^m factor has m+1 semisimple formal solutions with power exponent 0; "
                "tensoring therefore gives m+1 copies of the cubic rank-two block with unchanged residues."
            ),
            "checked_m_range": [0, bound],
            "checks": [projective_space_check(m) for m in range(bound + 1)],
        },
        "surface_carrier_exclusion_and_one_step_irrationality": surface_carrier_exclusion(),
        "candidate_fractional_cy_carrier_bound": {
            "status": (
                "Conditional numerical gap, not yet a reduction. Serre dimension is additive under "
                "tensor products, but the ordinary projective-bundle semiorthogonal decomposition "
                "splits the tensor category into m+1 copies, and Serre dimension is not monotone for "
                "general admissible subcategories."
            ),
            "checked_m_range": [0, bound],
            "checks": [serre_dimension_candidate_check(m) for m in range(bound + 1)],
            "conditional_argument": (
                "Ku(X) has S^3=[5], hence Serre dimension 5/3. Tensoring with D(P^m) gives "
                "m+5/3, whereas every weak-factorization center has dimension at most m+1. "
                "If a gluing-sensitive enhanced atom forced this whole tensor category, rather than "
                "its m+1 separate Ku(X) summands, into one center, then a fractional-Calabi-Yau carrier "
                "inequality would prove stable irrationality with a uniform gap 2/3."
            ),
            "additive_ledger_seam": (
                "The standard exceptional collection of P^m gives a semiorthogonal decomposition of "
                "Ku(X) tensor D(P^m) into m+1 copies of Ku(X). Ordinary blowup/atomic ledgers may "
                "distribute those copies among different centers, so the carrier inequality alone is "
                "insufficient."
            ),
            "known_failure_of_general_monotonicity": (
                "Elagin-Lunts exhibit an admissible subcategory of D^b(F_3) with upper Serre "
                "dimension 3, larger than the surface dimension 2. Their example does not settle "
                "the restricted fractional-Calabi-Yau/equal-Serre-dimensions carrier inequality."
            ),
        },
        "coarse_blowup_cancellation_model": {
            "model": (
                "In endpoint dimension 3+m, a center X x P^(s-3), with t=s-2, "
                "contributes t(m-t) copies of the cubic atom under the ungraded blow-up formula."
            ),
            "checked_m_range": [1, bound],
            "checks": [coarse_cancellation_check(m) for m in range(1, bound + 1)],
            "interpretation": (
                "For every m>=2 the endpoint multiplicity m+1 lies in the signed integer span of "
                "the admissible coarse center weights. This refutes a multiplicity-only stable obstruction; "
                "it does not construct geometrically realizable weak-factorization centers."
            ),
        },
        "candidate_tate_graded_refinement": {
            "status": (
                "Exact polynomial separation, but not an invariant in the present formal category: "
                "integer powers of z are removable by allowed gauge transformations, and a Novikov "
                "loop cyclically permutes all projective-space eigenbranches."
            ),
            "model": (
                "The endpoint coefficient is 1+L+...+L^m. A self-carrier center indexed by t "
                "contributes (1+...+L^(t-1))(L+...+L^(m-t)), whose constant and L^m terms vanish."
            ),
            "checked_m_range": [1, bound],
            "checks": [tate_graded_candidate_check(m) for m in range(1, bound + 1)],
            "missing_theorem": (
                "Construct a birationally functorial filtered or integral-exponent enhancement of "
                "the quantum atom that retains these Tate degrees through the cyclic branch monodromy, "
                "or prove that no such enhancement exists."
            ),
        },
        "candidate_integral_serre_width_refinement": {
            "status": (
                "Exact rational/integral-lattice avatar of the Tate extreme-term gap, but not yet a "
                "birational invariant. The missing theorem is a strict alpha-isotypic Stokes/Rees "
                "filtration whose associated graded obeys the blowup formula. Preserving only the Euler "
                "pairing or Serre operator is insufficient because semiorthogonal extensions can join "
                "shorter Jordan blocks."
            ),
            "beilinson_checks_range": [0, bound],
            "beilinson_checks": [beilinson_serre_width_check(d) for d in range(bound + 1)],
            "self_carrier_checks_range": [2, bound],
            "self_carrier_checks": [self_carrier_serre_width_check(m) for m in range(2, bound + 1)],
            "general_formula": (
                "The Beilinson Euler lattice of P^m has one unipotent Serre block of length m+1. "
                "For Z_t=X x P^(t-1), the exceptional cubic carrier is tensored with P^(m-t-1), "
                "so the logarithmic Serre index is (t-1)+(m-t-1)+1=m-1: a uniform gap of two."
            ),
            "conditional_arbitrary_center_bound": (
                "If an alpha-carrier on an s-fold has Tate width at most s-3, then in ambient dimension "
                "D=m+3 its exceptional contribution has width at most (s-3)+(D-s-2)=m-2, hence Serre "
                "block length at most m-1, versus endpoint length m+1."
            ),
            "strictness_requirement": (
                "The sufficient enhancement must identify a canonical filtered alpha-isotypic object and "
                "make the blowup map strict, with associated-graded identity [Bl_Z Y]_alpha=[Y]_alpha+"
                "(T+...+T^(r-1))[Z]_alpha. Block length is a basis-independent diagnostic of this "
                "filtration, not a substitute for filtered additivity."
            ),
        },
        "iritani_local_q_adic_tate_spacing": {
            "status": (
                "Exact local positive result, not a stable-birational invariant. At the chosen "
                "large-radius blow-up boundary, the leading exceptional Fourier block has consecutive "
                "q-adic elementary divisors, up to affine normalization. Root monodromy changes Fourier "
                "units and permutes sectors, so it preserves the elementary-divisor multiset and its width."
            ),
            "checked_center_codimension_range": [2, bound + 1],
            "checks": [iritani_q_adic_lattice_check(r) for r in range(2, bound + 2)],
            "source_derivation": (
                "Iritani (5.19) gives q_Z=unit*q^(-r/(2(r-1))). Equation (5.27) says that after "
                "multiplying the l-th exceptional column by unit*q^(-(l+1)/(r-1)), its leading "
                "exceptional-sector matrix is Fourier. For t=q^(-1/s), the unscaled column valuations "
                "are s(r-2l-2)/(2(r-1)); their consecutive spacing is s/(r-1)."
            ),
            "surviving_gate": (
                "The q-adic lattice is relative to a selected blow-up Novikov coordinate and boundary. "
                "Iritani proves an isomorphism only after Laurent base change and does not construct a "
                "presentation-independent Rees lattice compatible with composition in weak factorization. "
                "Remark 1.5 separately leaves the general analytic Stokes/Gamma compatibility conjectural."
            ),
        },
        "two_step_tate_composition": two_step_tate_composition_certificate(bound),
        "candidate_spectral_cycle_refinement": {
            "status": (
                "Negative audit. Prime-power endpoint cycles exclude every projective self-carrier in "
                "the diagonal-loop model, but KKPYY's blowup and projective-bundle identifications are "
                "local analytic-germ decompositions and do not retain global loop monodromy."
            ),
            "checked_m_range": [2, bound],
            "checks": [spectral_cycle_self_carrier_check(m) for m in range(2, bound + 1)],
            "prime_power_local_tower_counterpatterns": prime_power_tower_counterpatterns(bound),
            "cofinal_reduction": (
                "If X x P^m is rational for one m, then it is rational for every larger m. "
                "Therefore an obstruction for all m=p^k-1 would prove stable irrationality."
            ),
            "counterpattern_interpretation": (
                "A k-stage rank-p projective-bundle tower over X has p^k local cubic-atom copies in "
                "dimension 3+k(p-1). Whenever this is at most p^k it is dimension-admissible as a center "
                "for endpoint stabilization m=p^k-1. The local theorem forgets global monodromy; the "
                "largest compatible continuation group is an iterated wreath group containing the p^k "
                "odometer cycle. This is not a geometric weak-factorization construction, but it refutes "
                "any descent based only on local-copy count, dimension, and unrestricted wreath mixing."
            ),
            "source_boundary": (
                "KKPYY Theorems 4.5 and 4.11 identify analytic germs with the F-bundle of a disjoint "
                "union of local copies. Their atomic composition retains the cover degree as multiplicity, "
                "not a chosen global Novikov loop or its permutation."
            ),
        },
    }


def canonical_bytes(certificate):
    return (json.dumps(certificate, indent=2, sort_keys=True, default=int) + "\n").encode("utf-8")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--bound", type=int, default=24)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--output", type=Path)
    group.add_argument("--check", type=Path)
    args = parser.parse_args()

    payload = canonical_bytes(build_certificate(args.bound))
    if args.output is not None:
        args.output.write_bytes(payload)
        print(f"wrote {args.output} ({len(payload)} bytes)")
    else:
        tracked = args.check.read_bytes()
        if tracked != payload:
            raise SystemExit(f"certificate mismatch: {args.check}")
        print(f"verified {args.check} ({len(payload)} bytes)")


if __name__ == "__main__":
    main()
