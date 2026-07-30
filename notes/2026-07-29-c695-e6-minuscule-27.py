#!/usr/bin/env python3
"""Recover the remaining fifteen Clebsch lines from the C682 operator double-six."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
BASE_PATH = ROOT / "2026-07-28-c682-operator-schlafli.py"
OUTPUT_PATH = ROOT / "2026-07-29-c695-e6-minuscule-27.json"

spec = importlib.util.spec_from_file_location("c682_operator_schlafli", BASE_PATH)
assert spec and spec.loader
c682 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(c682)

K = c682.Qzeta5
ZERO = c682.ZERO
ONE = c682.ONE


def monomials(variables: int, degree: int):
    if variables == 1:
        return [(degree,)]
    return [
        (first,) + rest
        for first in range(degree + 1)
        for rest in monomials(variables - 1, degree - first)
    ]


MONOMIALS_2 = monomials(2, 3)
MONOMIALS_3 = monomials(3, 3)
MONOMIALS_4 = monomials(4, 3)


def coordinates(vector, basis):
    """Coordinates of a row vector in an independent row basis."""
    augmented = [
        [basis[column][row] for column in range(len(basis))] + [vector[row]]
        for row in range(len(vector))
    ]
    reduced, pivots = c682.rref(augmented)
    assert pivots == list(range(len(basis)))
    answer = [ZERO] * len(basis)
    for row, pivot in enumerate(pivots):
        if pivot < len(basis):
            answer[pivot] = reduced[row][-1]
    reconstructed = [
        sum(answer[index] * basis[index][column] for index in range(len(basis)))
        for column in range(len(vector))
    ]
    assert reconstructed == vector
    return answer


def add_poly(left, right):
    result = dict(left)
    for exponent, coefficient in right.items():
        result[exponent] = result.get(exponent, ZERO) + coefficient
        if not result[exponent]:
            del result[exponent]
    return result


def mul_poly(left, right):
    result = {}
    for left_exp, left_coefficient in left.items():
        for right_exp, right_coefficient in right.items():
            exponent = tuple(a + b for a, b in zip(left_exp, right_exp, strict=True))
            result[exponent] = (
                result.get(exponent, ZERO) + left_coefficient * right_coefficient
            )
    return {exponent: value for exponent, value in result.items() if value}


def pow_poly(value, exponent):
    variables = len(next(iter(value)))
    result = {(0,) * variables: ONE}
    for _ in range(exponent):
        result = mul_poly(result, value)
    return result


def substitute_cubic(coefficients, linear_forms, target_monomials):
    result = {}
    variables = len(linear_forms[0])
    for coefficient, powers in zip(coefficients, MONOMIALS_4, strict=True):
        term = {(0,) * variables: coefficient}
        for linear_form, exponent in zip(linear_forms, powers, strict=True):
            if exponent:
                polynomial = {
                    tuple(1 if index == column else 0 for index in range(variables)): value
                    for column, value in enumerate(linear_form)
                    if value
                }
                if not polynomial:
                    term = {}
                    break
                term = mul_poly(term, pow_poly(polynomial, exponent))
        result = add_poly(result, term)
    return [result.get(monomial, ZERO) for monomial in target_monomials]


def cubic_through_lines(lines):
    equations = []
    for line in lines:
        linear_forms = [list(values) for values in zip(*line, strict=True)]
        for coefficient_index in range(4):
            equations.append(
                [
                    substitute_cubic(
                        [ONE if index == monomial_index else ZERO for index in range(20)],
                        linear_forms,
                        MONOMIALS_2,
                    )[coefficient_index]
                    for monomial_index in range(20)
                ]
            )
    kernel = c682.nullspace(equations)
    assert len(kernel) == 1
    return kernel[0], c682.rank(equations)


def line_in_plane(line, plane):
    return [coordinates(vector, plane) for vector in line]


def linear_equation(line_coordinates):
    kernel = c682.nullspace(line_coordinates)
    assert len(kernel) == 1
    return kernel[0]


def linear_polynomial(form):
    return {
        tuple(1 if index == column else 0 for index in range(len(form))): value
        for column, value in enumerate(form)
        if value
    }


def residual_line(cubic, first, second, ambient_basis):
    plane = c682.rref(first + second)[0]
    assert len(plane) == 3
    plane_in_ambient = [coordinates(vector, ambient_basis) for vector in plane]
    linear_forms = [list(values) for values in zip(*plane_in_ambient, strict=True)]
    restricted = substitute_cubic(cubic, linear_forms, MONOMIALS_3)
    first_equation = linear_equation(line_in_plane(first, plane))
    second_equation = linear_equation(line_in_plane(second, plane))
    product = mul_poly(
        linear_polynomial(first_equation), linear_polynomial(second_equation)
    )
    equations = []
    rhs = []
    for monomial, value in zip(MONOMIALS_3, restricted, strict=True):
        equations.append(
            [
                mul_poly(
                    product,
                    linear_polynomial(
                        [ONE if index == column else ZERO for index in range(3)]
                    ),
                ).get(monomial, ZERO)
                for column in range(3)
            ]
        )
        rhs.append(value)
    augmented = [row + [value] for row, value in zip(equations, rhs, strict=True)]
    reduced, pivots = c682.rref(augmented)
    assert pivots == [0, 1, 2]
    quotient = [reduced[index][-1] for index in range(3)]
    residual_plane_coordinates = c682.nullspace([quotient])
    assert len(residual_plane_coordinates) == 2
    return [
        [
            sum(vector[index] * plane[index][column] for index in range(3))
            for column in range(7)
        ]
        for vector in residual_plane_coordinates
    ]


def canonical(space):
    return c682.canonical_space(space)


def galois(value, exponent):
    return sum(
        coefficient * (c682.ZETA**exponent) ** power
        for power, coefficient in enumerate(value.coefficients)
    )


def galois_space(space, exponent):
    return [[galois(value, exponent) for value in vector] for vector in space]


def on_cubic(cubic, line, ambient_basis):
    line_coordinates = [coordinates(vector, ambient_basis) for vector in line]
    linear_forms = [list(values) for values in zip(*line_coordinates, strict=True)]
    return substitute_cubic(cubic, linear_forms, MONOMIALS_2) == [ZERO] * 4


def build_double_six():
    plus_form = [(ONE, 11, 1), (K(11), 6, 6), (K(-1), 1, 11)]
    plus_kernel = c682.nullspace(c682.third_transvectant_matrix(plus_form))
    ambient_basis = c682.rref(c682.apolar_annihilator(plus_kernel))[0]
    axes = [[ZERO, ONE, ZERO]]
    for exponent in range(5):
        value = c682.ZETA**exponent
        axes.append([ONE, value, -(value**2)])
    quadratic_basis = [
        [ONE, ZERO, ZERO],
        [ZERO, ONE, ZERO],
        [ZERO, ZERO, ONE],
    ]
    e_lines = []
    e_prime_lines = []
    for axis in axes:
        tangent = [
            c682.polynomial_product(c682.polynomial_power(axis, 2), vector)
            for vector in quadratic_basis
        ]
        e_lines.append(c682.intersection(ambient_basis, tangent))
        e_prime_lines.append(
            c682.intersection(ambient_basis, c682.apolar_annihilator(tangent))
        )
    return ambient_basis, e_lines, e_prime_lines


def expected_incidence(first, second):
    first_type, first_label = first
    second_type, second_label = second
    if first_type == second_type == "E":
        return False
    if first_type == second_type == "E_prime":
        return False
    if {first_type, second_type} == {"E", "E_prime"}:
        return first_label != second_label
    if first_type == "L" and second_type == "L":
        return set(first_label).isdisjoint(second_label)
    if first_type == "L":
        return second_label in first_label
    if second_type == "L":
        return first_label in second_label
    raise AssertionError((first, second))


def certificate():
    ambient_basis, e_lines, e_prime_lines = build_double_six()
    all_twelve_coordinates = [
        [coordinates(vector, ambient_basis) for vector in line]
        for line in e_lines + e_prime_lines
    ]
    cubic, constraint_rank = cubic_through_lines(all_twelve_coordinates)
    assert constraint_rank == 19
    assert all(on_cubic(cubic, line, ambient_basis) for line in e_lines + e_prime_lines)

    residuals = {}
    ordered_agreement = {}
    for left, right in itertools.combinations(range(6), 2):
        forward = residual_line(cubic, e_lines[left], e_prime_lines[right], ambient_basis)
        backward = residual_line(cubic, e_lines[right], e_prime_lines[left], ambient_basis)
        assert canonical(forward) == canonical(backward)
        assert on_cubic(cubic, forward, ambient_basis)
        residuals[(left, right)] = forward
        ordered_agreement[f"{left + 1}{right + 1}"] = True
    assert len({json.dumps(canonical(line), sort_keys=True) for line in residuals.values()}) == 15

    labelled = (
        [(("E", index), line) for index, line in enumerate(e_lines)]
        + [(("E_prime", index), line) for index, line in enumerate(e_prime_lines)]
        + [(("L", pair), line) for pair, line in residuals.items()]
    )
    degrees = {}
    incidence_edges = 0
    for left_index, (left_label, left_line) in enumerate(labelled):
        degree = 0
        for right_index, (right_label, right_line) in enumerate(labelled):
            if left_index == right_index:
                continue
            actual = c682.intersection_dimension(left_line, right_line) == 1
            assert actual == expected_incidence(left_label, right_label)
            degree += int(actual)
            if left_index < right_index:
                incidence_edges += int(actual)
        degrees[str(left_label)] = degree
    assert set(degrees.values()) == {10}
    assert incidence_edges == 135

    cross_tritangents = [
        (f"E_{left + 1}", f"E_prime_{right + 1}", f"L_{min(left, right) + 1}{max(left, right) + 1}")
        for left in range(6)
        for right in range(6)
        if left != right
    ]
    pfaffian_tritangents = []
    for pairing in itertools.combinations(itertools.combinations(range(6), 2), 3):
        if sorted(index for pair in pairing for index in pair) == list(range(6)):
            canonical_pairing = tuple(sorted(tuple(sorted(pair)) for pair in pairing))
            if canonical_pairing not in pfaffian_tritangents:
                pfaffian_tritangents.append(canonical_pairing)
    pfaffian_tritangents.sort()
    assert len(cross_tritangents) == 30
    assert len(pfaffian_tritangents) == 15

    galois_actions = {}
    for exponent in (2, 3, 4):
        permutation = [0] + [1 + (exponent * index) % 5 for index in range(5)]
        for source, target in enumerate(permutation):
            assert canonical(galois_space(e_lines[source], exponent)) == canonical(
                e_lines[target]
            )
            assert canonical(
                galois_space(e_prime_lines[source], exponent)
            ) == canonical(e_prime_lines[target])
        for pair, line in residuals.items():
            target_pair = tuple(sorted(permutation[index] for index in pair))
            assert canonical(galois_space(line, exponent)) == canonical(
                residuals[target_pair]
            )
        galois_actions[f"zeta_to_zeta^{exponent}"] = [
            target + 1 for target in permutation
        ]

    return {
        "schema": "c695-e6-minuscule-27-v1",
        "base_script_sha256": hashlib.sha256(BASE_PATH.read_bytes()).hexdigest(),
        "field": "Q(zeta_5), zeta_5^4+zeta_5^3+zeta_5^2+zeta_5+1=0",
        "ambient_basis": canonical(ambient_basis),
        "clebsch_cubic": {
            "coordinate_monomials": MONOMIALS_4,
            "coefficients": [entry.serialized() for entry in cubic],
            "twelve_line_constraint_rank": constraint_rank,
            "coefficient_space_dimension": 1,
        },
        "residual_lines": {
            f"L_{left + 1}{right + 1}": canonical(line)
            for (left, right), line in residuals.items()
        },
        "ordered_residual_agreement": ordered_agreement,
        "galois_actions_on_six_indices": galois_actions,
        "schlafli_graph": {
            "vertices": 27,
            "edges": incidence_edges,
            "degree_multiset": sorted(degrees.values()),
        },
        "tritangent_planes": {
            "cross_count": len(cross_tritangents),
            "pfaffian_count": len(pfaffian_tritangents),
            "total": len(cross_tritangents) + len(pfaffian_tritangents),
            "cross": cross_tritangents,
            "pfaffian": [
                [f"L_{left + 1}{right + 1}" for left, right in pairing]
                for pairing in pfaffian_tritangents
            ],
        },
        "minuscule_dictionary": {
            "E_i": "x_i in 2(first weight) tensor 6^dual",
            "E_prime_i": "y_i in 2(second weight) tensor 6^dual",
            "L_ij": "omega_ij in exterior^2 6",
            "cartan_cubic_support": "sum_(i<j)(x_i*y_j-x_j*y_i)omega_ij + Pf(omega)",
            "row_exchange": "A1 Weyl reflection: x_i <-> y_i; omega_ij fixed as weights",
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized()
    if args.check:
        assert OUTPUT_PATH.read_text() == payload
        print("C695 certificate matches")
    else:
        OUTPUT_PATH.write_text(payload)
        print(OUTPUT_PATH)


if __name__ == "__main__":
    main()
