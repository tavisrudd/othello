#!/usr/bin/env python3
"""Derive the external C210 branch-collision elimination system.

Fix a point of the universal ramification section and compare it with a second
seed--repair source above the same target.  Write

    u=r'+r,  v=d'+d.

Then ``D'=D+(v,0)`` and ``Y'=lambda*D+(u+v,0)``.  The two target-height
equations are quadratics ``C0=C1=0`` in ``v``; the second-source ramification
equation ``J'=0`` has degree five in ``v``.  All three are independent of the
repair constant ``k``, the seed colour, and the original repair root ``r``.

The common known source is ``u=v=0``.  The Sylvester resultant of ``C0,C1``
has exactly the factor ``u^2``; after saturation the external collision
polynomial ``R(u)`` has 111 terms and degree five.  A second ramified source
would make its external root multiple.  In characteristic two,

    R(u)=u*R'(u)+(r4*u^4+r2*u^2+r0),

so the multiple-root condition is the resultant of two quadratics in
``z=u^2``.  After the selected-open factors are removed and the universal
section equation is imposed, one coefficient of this condition is exactly
``e*a^4``.  Thus it cannot vanish identically at any repair-stratum
coefficient specialization.  This chart-free test also includes ``L1=0``.

The same calculation with the opposite seed-height shift gives a degree-seven
cross-seed collision resultant.  Its multiple-root core restricts to a section
polynomial with coefficient ``tau*e^2*a^4``.  Consequently a simple branch of
either seed cover can be chosen away from the branch divisor of the other.

The checker constructs every polynomial in the sparse GF(8)-coefficient ring,
verifies the quadratic resultant independently by a Sylvester determinant,
and records stable digests.
"""

from __future__ import annotations

import hashlib
import itertools
import json

from analyze_c210_coverage_branch_discriminants import NAMES, Ring
from analyze_c210_persistent_singletons import (
    coverage_equations,
    sylvester_resultant,
)


def main() -> None:
    ring = Ring()
    add = ring.add
    mul = ring.mul
    square = ring.square
    variables = ring.variables
    e, a, b, s, lam, d, u, v = (variables[name] for name in NAMES)

    def pair_add(left, right):
        return add(left[0], right[0]), add(left[1], right[1])

    def pair_mul(left, right):
        cross = mul(left[1], right[1])
        return (
            add(mul(left[0], right[0]), cross),
            add(mul(left[0], right[1]), mul(left[1], right[0]), cross),
        )

    def pair_scale(scalar, value):
        return mul(scalar, value[0]), mul(scalar, value[1])

    def determinant(left, right):
        return add(mul(left[0], right[1]), mul(left[1], right[0]))

    D = (d, e)
    E = (e, add(d, e))
    W = pair_scale(s, E)
    Y = pair_scale(lam, D)

    D_prime = (add(d, v), e)
    E_prime = (e, add(d, v, e))
    Y_prime = (add(mul(lam, d), u, v), mul(lam, e))
    W_prime = pair_add(
        W,
        (square(v), add(mul(a, square(u)), mul(b, u))),
    )

    # Height above the seed is Y^2+Y*(W/D).  On the section W/D=s*omega.
    height = pair_add(pair_mul(Y, Y), pair_mul(Y, (ring.zero, s)))
    collision = pair_add(
        pair_mul(D_prime, pair_add(pair_mul(Y_prime, Y_prime), height)),
        pair_mul(Y_prime, W_prime),
    )
    seed_shift = (ring.zero, ring.constant(ring.context.tau))
    cross_W_prime = pair_add(W_prime, seed_shift)
    cross_collision = pair_add(
        pair_mul(
            D_prime,
            pair_add(
                pair_add(pair_mul(Y_prime, Y_prime), height), seed_shift
            ),
        ),
        pair_mul(Y_prime, cross_W_prime),
    )
    R_prime = pair_add(W_prime, pair_scale(b, E_prime))
    T_prime = pair_mul(pair_add(D_prime, Y_prime), W_prime)
    ramification = determinant(pair_mul(Y_prime, R_prime), T_prime)

    v_index = NAMES.index("h1")
    u_index = NAMES.index("h0")

    def coefficients(poly):
        degree = max((monomial[v_index] for monomial in poly), default=-1)
        out = []
        for exponent in range(degree + 1):
            coefficient = {}
            for monomial, scalar in poly.items():
                if monomial[v_index] != exponent:
                    continue
                reduced = list(monomial)
                reduced[v_index] = 0
                coefficient[tuple(reduced)] = scalar
            out.append(coefficient)
        return out

    C0 = coefficients(collision[0])
    C1 = coefficients(collision[1])
    cross_C0 = coefficients(cross_collision[0])
    cross_C1 = coefficients(cross_collision[1])
    JR = coefficients(ramification)
    assert len(C0) == len(C1) == 3
    assert len(cross_C0) == len(cross_C1) == 3
    assert len(JR) == 6

    zero = ring.zero
    matrix = (
        (C0[0], C0[1], C0[2], zero),
        (zero, C0[0], C0[1], C0[2]),
        (C1[0], C1[1], C1[2], zero),
        (zero, C1[0], C1[1], C1[2]),
    )
    resultant = ring.zero
    for permutation in itertools.permutations(range(4)):
        term = ring.one
        for row, column in enumerate(permutation):
            term = mul(term, matrix[row][column])
        resultant = add(resultant, term)

    minimum_u = min(monomial[u_index] for monomial in resultant)
    assert minimum_u == 2
    saturated_resultant = {}
    for monomial, scalar in resultant.items():
        reduced = list(monomial)
        reduced[u_index] -= minimum_u
        saturated_resultant[tuple(reduced)] = scalar
    assert len(saturated_resultant) == 111

    cross_matrix = (
        (cross_C0[0], cross_C0[1], cross_C0[2], zero),
        (zero, cross_C0[0], cross_C0[1], cross_C0[2]),
        (cross_C1[0], cross_C1[1], cross_C1[2], zero),
        (zero, cross_C1[0], cross_C1[1], cross_C1[2]),
    )
    cross_resultant = ring.zero
    for permutation in itertools.permutations(range(4)):
        term = ring.one
        for row, column in enumerate(permutation):
            term = mul(term, cross_matrix[row][column])
        cross_resultant = add(cross_resultant, term)
    assert len(cross_resultant) == 216

    # The linear subresultant is L1*v+L0.  Verify the standard quadratic
    # identity A2*Res=A2*L0^2+A1*L0*L1+A0*L1^2 exactly.
    L1 = add(mul(C0[2], C1[1]), mul(C1[2], C0[1]))
    L0 = add(mul(C0[2], C1[0]), mul(C1[2], C0[0]))
    assert min(monomial[u_index] for monomial in L0) == 1
    norm_D = add(square(d), mul(d, e), square(e))
    L1_at_known_source = {
        monomial: scalar
        for monomial, scalar in L1.items()
        if monomial[u_index] == 0
    }
    expected_L1_at_known_source = mul(
        mul(s, square(add(lam, ring.one))), norm_D
    )
    assert L1_at_known_source == expected_L1_at_known_source
    quadratic_identity = add(
        mul(C0[2], resultant),
        mul(C0[2], square(L0)),
        mul(mul(C0[1], L0), L1),
        mul(C0[0], square(L1)),
    )
    assert not quadratic_identity

    def power(value, exponent):
        out = ring.one
        while exponent:
            if exponent & 1:
                out = mul(out, value)
            value = square(value)
            exponent >>= 1
        return out

    def coefficient_in(poly, index, exponent):
        out = {}
        for monomial, scalar in poly.items():
            if monomial[index] != exponent:
                continue
            reduced = list(monomial)
            reduced[index] = 0
            out[tuple(reduced)] = scalar
        return out

    def variable_degree(poly, index):
        return max((monomial[index] for monomial in poly), default=-1)

    def shift_variable(poly, index, shift):
        out = {}
        for monomial, scalar in poly.items():
            shifted = list(monomial)
            shifted[index] += shift
            out[tuple(shifted)] = scalar
        return out

    def divide_by_monomial(poly, exponents):
        if any(
            monomial[index] < exponent
            for monomial in poly
            for index, exponent in exponents.items()
        ):
            return None
        out = {}
        for monomial, scalar in poly.items():
            reduced = list(monomial)
            for index, exponent in exponents.items():
                reduced[index] -= exponent
            out[tuple(reduced)] = scalar
        return out

    def divide_by_monic_in(poly, factor, index):
        """Divide exactly by a polynomial monic in one variable."""
        factor_degree = variable_degree(factor, index)
        if coefficient_in(factor, index, factor_degree) != ring.one:
            raise ValueError("factor is not monic in the selected variable")
        quotient = ring.zero
        remainder = poly
        while variable_degree(remainder, index) >= factor_degree:
            remainder_degree = variable_degree(remainder, index)
            leading = coefficient_in(remainder, index, remainder_degree)
            term = shift_variable(
                leading, index, remainder_degree - factor_degree
            )
            quotient = add(quotient, term)
            remainder = add(remainder, mul(term, factor))
        return quotient if not remainder else None

    # On L1!=0 the common collision root is v=L0/L1.  Clear L1^5 from J'.
    external_ramification = ring.zero
    degree = len(JR) - 1
    for exponent, coefficient in enumerate(JR):
        external_ramification = add(
            external_ramification,
            mul(
                mul(coefficient, power(L0, exponent)),
                power(L1, degree - exponent),
            ),
        )
    assert len(external_ramification) == 8866
    assert min(monomial[u_index] for monomial in external_ramification) == 2

    def coefficient_after_u_saturation(poly, valuation):
        out = {}
        for monomial, scalar in poly.items():
            if monomial[u_index] != valuation:
                continue
            reduced = list(monomial)
            reduced[u_index] = 0
            out[tuple(reduced)] = scalar
        return out

    collision_at_known_source = coefficient_after_u_saturation(resultant, 2)
    expected_collision_at_known_source = mul(
        mul(mul(lam, square(add(lam, ring.one))), norm_D),
        add(
            mul(square(s), norm_D),
            mul(mul(mul(s, e), b), add(s, b)),
            mul(mul(lam, square(b)), norm_D),
        ),
    )
    assert collision_at_known_source == expected_collision_at_known_source
    ramification_at_known_source = coefficient_after_u_saturation(
        external_ramification, 2
    )

    # The u=0 chart has no external affine collision on the selected section.
    # After removing the common (lambda+1)*v, its two equations imply
    # s*Norm(D)=0, contrary to the open conditions.
    collision_u_zero = [
        coefficient_in(value, u_index, 0) for value in collision
    ]
    collision_u_zero_brackets = (
        add(mul(d, v), mul(e, s)),
        add(mul(e, v), mul(s, add(d, e))),
    )
    common_u_zero_factor = mul(add(lam, ring.one), v)
    assert collision_u_zero == [
        mul(common_u_zero_factor, bracket)
        for bracket in collision_u_zero_brackets
    ]
    assert add(
        mul(e, collision_u_zero_brackets[0]),
        mul(d, collision_u_zero_brackets[1]),
    ) == mul(s, norm_D)

    # If R=sum r_i*u^i is the saturated collision quintic, then
    # R'=r5*u^4+r3*u^2+r1 and R+u*R'=r4*u^4+r2*u^2+r0.  In z=u^2 these are
    # quadratics.  Their resultant is the chart-free multiple-root condition.
    collision_u_coefficients = [
        coefficient_in(saturated_resultant, u_index, exponent)
        for exponent in range(6)
    ]
    derivative_quadratic = (
        collision_u_coefficients[1],
        collision_u_coefficients[3],
        collision_u_coefficients[5],
    )
    even_quadratic = (
        collision_u_coefficients[0],
        collision_u_coefficients[2],
        collision_u_coefficients[4],
    )
    multiple_root_resultant = add(
        square(add(
            mul(derivative_quadratic[2], even_quadratic[0]),
            mul(even_quadratic[2], derivative_quadratic[0]),
        )),
        mul(
            add(
                mul(derivative_quadratic[2], even_quadratic[1]),
                mul(even_quadratic[2], derivative_quadratic[1]),
            ),
            add(
                mul(derivative_quadratic[1], even_quadratic[0]),
                mul(even_quadratic[1], derivative_quadratic[0]),
            ),
        ),
    )
    quadratic_matrix = (
        (*derivative_quadratic, ring.zero),
        (ring.zero, *derivative_quadratic),
        (*even_quadratic, ring.zero),
        (ring.zero, *even_quadratic),
    )
    quadratic_sylvester = ring.zero
    for permutation in itertools.permutations(range(4)):
        term = ring.one
        for row, column in enumerate(permutation):
            term = mul(term, quadratic_matrix[row][column])
        quadratic_sylvester = add(quadratic_sylvester, term)
    assert quadratic_sylvester == multiple_root_resultant
    assert len(multiple_root_resultant) == 3352

    cross_u_coefficients = [
        coefficient_in(cross_resultant, u_index, exponent)
        for exponent in range(8)
    ]

    def evaluate(poly, values):
        out = 0
        for monomial, scalar in poly.items():
            term = scalar
            for name, exponent in zip(NAMES, monomial):
                term = ring.field.mul(
                    term, ring.field.power(values[name], exponent)
                )
            out = ring.field.add(out, term)
        return out

    def field_sum(*values):
        out = 0
        for value in values:
            out = ring.field.add(out, value)
        return out

    def normalized_numeric(poly):
        poly = list(poly)
        while poly and not poly[-1]:
            poly.pop()
        inverse = ring.field.inv(poly[-1])
        return tuple(ring.field.mul(value, inverse) for value in poly)

    # Compare one specialization with the independent incidence-resultant
    # implementation.  Use an A-section point and the opposite B seed.
    context = ring.context
    section_s = context.tau
    section_d = 1
    section_r = 1
    section_lambda = context.tau
    section_e = context.eta1
    section_a = context.a1
    section_b = context.b1
    assert field_sum(
        ring.field.mul(section_d, section_d),
        ring.field.mul(section_e, section_e),
        ring.field.mul(section_s, section_e),
        1,
    ) == 0
    assert field_sum(
        ring.field.mul(section_e, section_e),
        ring.field.mul(section_a, ring.field.mul(section_r, section_r)),
        ring.field.mul(section_b, section_r),
        ring.field.mul(section_s, field_sum(section_d, section_e)),
    ) == 0
    omega = ring.field.div(
        ring.field.add(context.beta, context.alpha), context.tau
    )
    section_D = field_sum(
        section_d, ring.field.mul(section_e, omega)
    )
    section_Y = ring.field.mul(section_lambda, section_D)
    section_t = field_sum(section_d, 1, section_r)
    section_y = field_sum(section_Y, section_t)
    section_W = ring.field.mul(
        section_s, ring.field.mul(omega, section_D)
    )
    section_h = field_sum(
        context.alpha,
        ring.field.mul(section_Y, section_Y),
        ring.field.mul(section_lambda, section_W),
    )
    cross_target = (
        *context.coordinates(section_y),
        *context.coordinates(section_h),
    )
    direct_cross_equations = coverage_equations(
        ring.field,
        context.coordinates,
        context.eta0,
        section_e,
        section_a,
        section_b,
        context.c0,
        0,
        context.beta,
        *cross_target,
    )
    direct_cross_resultant = sylvester_resultant(
        ring.field, *direct_cross_equations
    )
    shifted_direct_cross_resultant = [0] * len(direct_cross_resultant)
    for exponent, scalar in enumerate(direct_cross_resultant):
        for shifted_exponent in range(exponent + 1):
            if exponent & shifted_exponent != shifted_exponent:
                continue
            shifted_direct_cross_resultant[shifted_exponent] = ring.field.add(
                shifted_direct_cross_resultant[shifted_exponent],
                ring.field.mul(
                    scalar,
                    ring.field.power(
                        section_r, exponent - shifted_exponent
                    ),
                ),
            )
    symbolic_values = {
        "e": section_e,
        "a": section_a,
        "b": section_b,
        "k": section_s,
        "y0": section_lambda,
        "y1": section_d,
        "h0": 0,
        "h1": 0,
    }
    specialized_cross_resultant = tuple(
        evaluate(coefficient, symbolic_values)
        for coefficient in cross_u_coefficients
    )
    assert normalized_numeric(specialized_cross_resultant) == normalized_numeric(
        shifted_direct_cross_resultant
    )
    cross_derivative_cubic = tuple(
        cross_u_coefficients[exponent] for exponent in (1, 3, 5, 7)
    )
    cross_even_cubic = tuple(
        cross_u_coefficients[exponent] for exponent in (0, 2, 4, 6)
    )
    cross_cubic_matrix = []
    for coefficients_z in (cross_derivative_cubic, cross_even_cubic):
        for shift in range(3):
            cross_cubic_matrix.append(
                (ring.zero,) * shift
                + coefficients_z
                + (ring.zero,) * (2 - shift)
            )
    cross_multiple_root_resultant = ring.zero
    for permutation in itertools.permutations(range(6)):
        term = ring.one
        for row, column in enumerate(permutation):
            term = mul(term, cross_cubic_matrix[row][column])
        cross_multiple_root_resultant = add(
            cross_multiple_root_resultant, term
        )
    assert len(cross_multiple_root_resultant) == 100056

    def exact_factor_valuation(poly, divider):
        valuation = 0
        while True:
            quotient = divider(poly)
            if quotient is None:
                return valuation
            poly = quotient
            valuation += 1

    e_index = NAMES.index("e")
    a_index = NAMES.index("a")
    b_index = NAMES.index("b")
    s_index = NAMES.index("k")
    lam_index = NAMES.index("y0")
    d_index = NAMES.index("y1")
    cross_factor_valuations = {
        name: min(monomial[index] for monomial in cross_multiple_root_resultant)
        for name, index in (
            ("e", e_index),
            ("a", a_index),
            ("b", b_index),
            ("s", s_index),
            ("lambda", lam_index),
        )
    }
    for name, factor, index in (
        ("a^2+a+1", add(square(a), a, ring.one), a_index),
        ("lambda+1", add(lam, ring.one), lam_index),
        ("Norm(D)", norm_D, d_index),
        ("s+b", add(s, b), s_index),
    ):
        cross_factor_valuations[name] = exact_factor_valuation(
            cross_multiple_root_resultant,
            lambda poly, factor=factor, index=index: divide_by_monic_in(
                poly, factor, index
            ),
        )
    assert cross_factor_valuations == {
        "e": 1,
        "a": 0,
        "b": 0,
        "s": 0,
        "lambda": 0,
        "a^2+a+1": 0,
        "lambda+1": 6,
        "Norm(D)": 1,
        "s+b": 0,
    }
    cross_multiple_root_core = divide_by_monomial(
        cross_multiple_root_resultant, {e_index: 1}
    )
    assert cross_multiple_root_core is not None
    cross_multiple_root_core = divide_by_monic_in(
        cross_multiple_root_core, norm_D, d_index
    )
    assert cross_multiple_root_core is not None
    for _ in range(6):
        cross_multiple_root_core = divide_by_monic_in(
            cross_multiple_root_core, add(lam, ring.one), lam_index
        )
        assert cross_multiple_root_core is not None
    assert divide_by_monic_in(
        cross_multiple_root_core, add(lam, ring.one), lam_index
    ) is None
    assert len(cross_multiple_root_core) == 46266

    cross_section_relation_degree = variable_degree(
        cross_multiple_root_core, s_index
    )
    assert cross_section_relation_degree == 10
    cross_section_numerator = add(square(d), square(e), u)
    cross_section_powers = [
        power(cross_section_numerator, exponent)
        for exponent in range(cross_section_relation_degree + 1)
    ]
    cross_section_restricted_core = {}
    for monomial, scalar in cross_multiple_root_core.items():
        s_exponent = monomial[s_index]
        transformed = list(monomial)
        transformed[s_index] = 0
        transformed[e_index] += (
            cross_section_relation_degree - s_exponent
        )
        contribution = mul(
            {tuple(transformed): scalar},
            cross_section_powers[s_exponent],
        )
        for key, value in contribution.items():
            new = ring.field.add(
                cross_section_restricted_core.get(key, 0), value
            )
            if new:
                cross_section_restricted_core[key] = new
            else:
                cross_section_restricted_core.pop(key, None)
    cross_critical_section_coefficient = {}
    for monomial, scalar in cross_section_restricted_core.items():
        if monomial[lam_index] != 8 or monomial[d_index] != 30:
            continue
        reduced = list(monomial)
        reduced[lam_index] = 0
        reduced[d_index] = 0
        cross_critical_section_coefficient[tuple(reduced)] = scalar
    expected_cross_critical_coefficient = mul(
        ring.constant(ring.context.tau),
        mul(square(e), power(a, 4)),
    )
    assert (
        cross_critical_section_coefficient
        == expected_cross_critical_coefficient
    )
    cross_section_coefficient_count = len({
        (monomial[lam_index], monomial[d_index])
        for monomial in cross_section_restricted_core
    })
    assert len(cross_section_restricted_core) == 96574
    assert cross_section_coefficient_count == 371

    multiple_root_core = divide_by_monomial(
        multiple_root_resultant, {e_index: 1, lam_index: 4}
    )
    assert multiple_root_core is not None
    multiple_root_core = divide_by_monic_in(
        multiple_root_core, add(lam, ring.one), lam_index
    )
    assert multiple_root_core is not None
    assert len(multiple_root_core) == 2746
    assert multiple_root_resultant == mul(
        mul(e, power(lam, 4)),
        mul(add(lam, ring.one), multiple_root_core),
    )
    assert divide_by_monomial(multiple_root_core, {e_index: 1}) is None
    assert divide_by_monomial(multiple_root_core, {lam_index: 1}) is None
    assert divide_by_monic_in(
        multiple_root_core, add(lam, ring.one), lam_index
    ) is None

    # On the universal section, z0=1 for both seed colours, hence
    # s*e=d^2+e^2+k.  Reuse the now-free u slot for the coefficient k and
    # clear the largest possible denominator e^6.
    section_relation_degree = variable_degree(multiple_root_core, s_index)
    assert section_relation_degree == 6
    coefficient_k = u
    section_numerator = add(square(d), square(e), coefficient_k)
    section_powers = [
        power(section_numerator, exponent)
        for exponent in range(section_relation_degree + 1)
    ]
    section_restricted_core = ring.zero
    for monomial, scalar in multiple_root_core.items():
        s_exponent = monomial[s_index]
        transformed = list(monomial)
        transformed[s_index] = 0
        transformed[e_index] += section_relation_degree - s_exponent
        section_restricted_core = add(
            section_restricted_core,
            mul({tuple(transformed): scalar}, section_powers[s_exponent]),
        )
    critical_section_coefficient = {}
    for monomial, scalar in section_restricted_core.items():
        if monomial[lam_index] != 3 or monomial[d_index] != 18:
            continue
        reduced = list(monomial)
        reduced[lam_index] = 0
        reduced[d_index] = 0
        critical_section_coefficient[tuple(reduced)] = scalar
    assert critical_section_coefficient == mul(e, power(a, 4))
    assert len(section_restricted_core) == 5580
    restricted_section_coefficient_count = len({
        (monomial[lam_index], monomial[d_index])
        for monomial in section_restricted_core
    })

    def degree_vector(poly):
        return {
            name: max((monomial[index] for monomial in poly), default=-1)
            for index, name in enumerate(
                ("e", "a", "b", "s", "lambda", "d", "u", "v")
            )
        }

    def digest(poly):
        rows = sorted((list(monomial), scalar) for monomial, scalar in poly.items())
        return hashlib.sha256(
            json.dumps(rows, separators=(",", ":")).encode()
        ).hexdigest()

    print(json.dumps({
        "difference_variables": {"u": "r'+r", "v": "d'+d"},
        "second_source": {
            "D_prime": "D+(v,0)",
            "Y_prime": "lambda*D+(u+v,0)",
            "W_prime": "W+(v^2,a*u^2+b*u)",
        },
        "independence": ["k", "seed colour", "original repair root r"],
        "collision_equations": {
            "term_counts": [len(collision[0]), len(collision[1])],
            "degree_vectors": [degree_vector(collision[0]), degree_vector(collision[1])],
            "degrees_in_v": [2, 2],
        },
        "second_ramification_equation": {
            "term_count": len(ramification),
            "degree_vector": degree_vector(ramification),
            "degree_in_v": 5,
        },
        "collision_resultant": {
            "known_source_factor": "u^2",
            "saturated_term_count": len(saturated_resultant),
            "saturated_degree_vector": degree_vector(saturated_resultant),
            "saturated_sha256": digest(saturated_resultant),
        },
        "cross_seed_collision_resultant": {
            "seed_height_shift": "tau*omega",
            "term_count": len(cross_resultant),
            "degree_vector": degree_vector(cross_resultant),
            "sha256": digest(cross_resultant),
            "direct_incidence_specialization": {
                "target_coordinates": list(cross_target),
                "resultant_degree":
                    len(normalized_numeric(direct_cross_resultant)) - 1,
                "symbolic_resultant_matches_after_r_to_u_shift": True,
            },
            "multiple_root_resultant": {
                "quadratic_variable": "z=u^2",
                "derivative_cubic_term_counts": [
                    len(value) for value in cross_derivative_cubic
                ],
                "even_cubic_term_counts": [
                    len(value) for value in cross_even_cubic
                ],
                "term_count": len(cross_multiple_root_resultant),
                "degree_vector": degree_vector(
                    cross_multiple_root_resultant
                ),
                "sha256": digest(cross_multiple_root_resultant),
                "candidate_factor_valuations": cross_factor_valuations,
                "selected_open_factor": "e*Norm(D)*(lambda+1)^6",
                "core_term_count": len(cross_multiple_root_core),
                "core_degree_vector": degree_vector(
                    cross_multiple_root_core
                ),
                "core_sha256": digest(cross_multiple_root_core),
                "section_relation": "s*e=d^2+e^2+k",
                "section_relation_denominator_power":
                    cross_section_relation_degree,
                "section_restricted_term_count": len(
                    cross_section_restricted_core
                ),
                "section_restricted_degree_vector": degree_vector(
                    cross_section_restricted_core
                ),
                "section_restricted_sha256": digest(
                    cross_section_restricted_core
                ),
                "restricted_section_coefficient_count":
                    cross_section_coefficient_count,
                "decisive_section_coefficient": {
                    "section_monomial": "lambda^8*d^30",
                    "coefficient": "tau*e^2*a^4",
                },
                "consequence":
                    "each seed cover has a simple branch away from the other seed cover at every repair-stratum coefficient point",
            },
        },
        "generic_linear_subresultant": {
            "L0_term_count": len(L0),
            "L1_term_count": len(L1),
            "common_root": "v=L0/L1",
            "L0_known_source_factor": "u",
            "L1_at_u_zero": "s*(lambda+1)^2*Norm(D)",
        },
        "known_source_boundary": {
            "saturated_collision_at_u_zero":
                "lambda*(lambda+1)^2*Norm(D)*(s^2*Norm(D)+s*e*b*(s+b)+lambda*b^2*Norm(D))",
            "saturated_external_ramification_term_count_at_u_zero":
                len(ramification_at_known_source),
            "saturated_external_ramification_sha256_at_u_zero":
                digest(ramification_at_known_source),
            "consequence":
                "L1=0 cannot meet the known source on the selected open set; its boundary chart is purely external",
        },
        "external_ramification_after_substitution": {
            "term_count_before_u_saturation": len(external_ramification),
            "known_source_u_valuation": 2,
            "degree_vector": degree_vector(external_ramification),
            "sha256": digest(external_ramification),
        },
        "external_u_zero_boundary": {
            "collision_equations_after_common_factor": [
                "d*v+e*s", "e*v+s*(d+e)"
            ],
            "elimination_identity":
                "e*(d*v+e*s)+d*(e*v+s*(d+e))=s*Norm(D)",
            "consequence":
                "u=0 has no external v!=0 collision on s*Norm(D)!=0",
        },
        "collision_quintic_multiple_root_core": {
            "identity":
                "R(u)=u*R'(u)+(r4*u^4+r2*u^2+r0)",
            "quadratic_variable": "z=u^2",
            "quadratic_coefficient_term_counts": {
                "derivative": [len(value) for value in derivative_quadratic],
                "even_part": [len(value) for value in even_quadratic],
            },
            "resultant_term_count": len(multiple_root_resultant),
            "resultant_degree_vector": degree_vector(multiple_root_resultant),
            "resultant_sha256": digest(multiple_root_resultant),
            "selected_open_factor": "e*lambda^4*(lambda+1)",
            "core_term_count": len(multiple_root_core),
            "core_degree_vector": degree_vector(multiple_root_core),
            "core_sha256": digest(multiple_root_core),
            "section_relation": "s*e=d^2+e^2+k",
            "section_relation_denominator_power": section_relation_degree,
            "section_restricted_term_count": len(section_restricted_core),
            "section_restricted_degree_vector": degree_vector(
                section_restricted_core
            ),
            "section_restricted_sha256": digest(section_restricted_core),
            "restricted_section_coefficient_count":
                restricted_section_coefficient_count,
            "decisive_section_coefficient": {
                "section_monomial": "lambda^3*d^18",
                "coefficient": "e*a^4",
            },
            "boundary_coverage":
                "direct Sylvester/discriminant calculation includes L1=0",
            "consequence":
                "no repair-stratum coefficient specialization makes every reduced section image collide with a second ramification source",
        },
        "remaining_gate":
            "test the known lower mixed-collision drop strata and their intersections for arc-legal affine-complete infinite families",
        "status":
            "self and cross-seed branch collisions excluded uniformly; odd-tower top monodromy is S7 x S7",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
