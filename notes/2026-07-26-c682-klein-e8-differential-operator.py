#!/usr/bin/env python3
"""Exact certificate for the Klein transvectant on the E8 invariant ring.

The polynomial convention is

    (a,b)_r = sum_i (-1)^i binom(r,i)
              d_X^(r-i)d_Y^i(a) d_X^i d_Y^(r-i)(b).

Only the Python standard library is used.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from itertools import product
from math import comb, factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c682-klein-e8-differential-operator.json"

Polynomial = dict[tuple[int, int], int]


def derivative(p: Polynomial, dx: int, dy: int) -> Polynomial:
    out: Polynomial = {}
    for (x_degree, y_degree), coefficient in p.items():
        if x_degree < dx or y_degree < dy:
            continue
        multiplier = 1
        for offset in range(dx):
            multiplier *= x_degree - offset
        for offset in range(dy):
            multiplier *= y_degree - offset
        out[(x_degree - dx, y_degree - dy)] = coefficient * multiplier
    return out


def multiply(p: Polynomial, q: Polynomial) -> Polynomial:
    out: Polynomial = {}
    for (px, py), pc in p.items():
        for (qx, qy), qc in q.items():
            monomial = (px + qx, py + qy)
            out[monomial] = out.get(monomial, 0) + pc * qc
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def add_scaled(
    p: Polynomial,
    q: Polynomial,
    scale: int | Fraction,
) -> Polynomial:
    out = dict(p)
    for monomial, coefficient in q.items():
        out[monomial] = out.get(monomial, 0) + scale * coefficient
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def power(p: Polynomial, exponent: int) -> Polynomial:
    out: Polynomial = {(0, 0): 1}
    for _ in range(exponent):
        out = multiply(out, p)
    return out


def transvectant(p: Polynomial, q: Polynomial, order: int) -> Polynomial:
    out: Polynomial = {}
    for index in range(order + 1):
        term = multiply(
            derivative(p, order - index, index),
            derivative(q, index, order - index),
        )
        out = add_scaled(out, term, (-1) ** index * comb(order, index))
    return out


def proportionality(p: Polynomial, q: Polynomial) -> Fraction:
    if set(p) != set(q) or not q:
        raise AssertionError("polynomials have different nonzero supports")
    ratios = {Fraction(p[monomial], q[monomial]) for monomial in q}
    if len(ratios) != 1:
        raise AssertionError("polynomials are not proportional")
    return ratios.pop()


def matrix_rank(columns: list[Polynomial], target_degree: int) -> int:
    matrix = [
        [Fraction(column.get((target_degree - row, row), 0)) for column in columns]
        for row in range(target_degree + 1)
    ]
    rank = 0
    column_count = len(columns)
    for column in range(column_count):
        pivot = next(
            (row for row in range(rank, len(matrix)) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        pivot_value = matrix[rank][column]
        matrix[rank] = [entry / pivot_value for entry in matrix[rank]]
        for row in range(len(matrix)):
            if row == rank or not matrix[row][column]:
                continue
            multiplier = matrix[row][column]
            matrix[row] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(matrix[row], matrix[rank])
            ]
        rank += 1
    return rank


def monomial_string(monomial: tuple[int, int], coefficient: int) -> str:
    x_degree, y_degree = monomial
    return f"{coefficient:+d}*X^{x_degree}Y^{y_degree}"


def coordinate_product(
    coordinates: tuple[Polynomial, Polynomial, Polynomial],
    exponents: tuple[int, int, int],
) -> Polynomial:
    out: Polynomial = {(0, 0): 1}
    for coordinate, exponent in zip(coordinates, exponents):
        out = multiply(out, power(coordinate, exponent))
    return out


def solve_invariant_coordinates(
    target: Polynomial,
    degree: int,
    coordinates: tuple[Polynomial, Polynomial, Polynomial],
) -> list[tuple[tuple[int, int, int], Fraction]]:
    """Expand in f^a H^b T^c with c <= 1, using the E8 relation."""
    exponents = []
    for t_exponent in range(2):
        for h_exponent in range(degree // 20 + 1):
            remainder = degree - 30 * t_exponent - 20 * h_exponent
            if remainder >= 0 and remainder % 12 == 0:
                exponents.append((remainder // 12, h_exponent, t_exponent))
    basis = [
        coordinate_product(coordinates, exponent)
        for exponent in exponents
    ]
    monomials = sorted(set(target).union(*(set(polynomial) for polynomial in basis)))
    matrix = [
        [
            *[Fraction(polynomial.get(monomial, 0)) for polynomial in basis],
            Fraction(target.get(monomial, 0)),
        ]
        for monomial in monomials
    ]
    row = 0
    pivots: list[int] = []
    for column in range(len(basis)):
        pivot = next(
            (index for index in range(row, len(matrix)) if matrix[index][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        pivot_value = matrix[row][column]
        matrix[row] = [entry / pivot_value for entry in matrix[row]]
        for index in range(len(matrix)):
            if index == row or not matrix[index][column]:
                continue
            multiplier = matrix[index][column]
            matrix[index] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(matrix[index], matrix[row])
            ]
        pivots.append(column)
        row += 1
    for equation in matrix:
        if not any(equation[:-1]) and equation[-1]:
            raise AssertionError("target is outside the Klein invariant ring basis")
    solution = [Fraction(0)] * len(basis)
    for row, column in enumerate(pivots):
        solution[column] = matrix[row][-1]
    return [
        (exponent, coefficient)
        for exponent, coefficient in zip(exponents, solution)
        if coefficient
    ]


def normal_form_data(
    klein_f: Polynomial,
    klein_h: Polynomial,
    klein_t: Polynomial,
) -> dict[str, object]:
    """Compute the normal-ordered operator in standard Klein coordinates.

    Standard coordinates are f, h=-H/242, t=T/4840, and the operator is
    Delta=delta/87278400, so t^2=h^3+1728 f^5 and Delta(t)=f^3.
    """
    coordinates = (klein_f, klein_h, klein_t)
    weights = (12, 20, 30)
    standard_terms = []
    for total_order in range(1, 4):
        for alpha in product(range(total_order + 1), repeat=3):
            if sum(alpha) != total_order:
                continue
            commutator: Polynomial = {}
            beta_ranges = [range(exponent + 1) for exponent in alpha]
            for beta in product(*beta_ranges):
                complement = tuple(
                    alpha_exponent - beta_exponent
                    for alpha_exponent, beta_exponent in zip(alpha, beta)
                )
                beta_polynomial = coordinate_product(coordinates, beta)
                term = transvectant(beta_polynomial, klein_f, 3)
                term = multiply(
                    coordinate_product(coordinates, complement),
                    term,
                )
                multi_binomial = 1
                for alpha_exponent, beta_exponent in zip(alpha, beta):
                    multi_binomial *= comb(alpha_exponent, beta_exponent)
                commutator = add_scaled(
                    commutator,
                    term,
                    (-1) ** (total_order - sum(beta)) * multi_binomial,
                )
            denominator = 1
            for exponent in alpha:
                denominator *= factorial(exponent)
            coefficient_polynomial = {
                monomial: Fraction(coefficient, denominator)
                for monomial, coefficient in commutator.items()
            }
            if not coefficient_polynomial:
                continue
            coefficient_degree = 6 + sum(
                weight * exponent
                for weight, exponent in zip(weights, alpha)
            )
            raw_expansion = solve_invariant_coordinates(
                coefficient_polynomial,
                coefficient_degree,
                coordinates,
            )
            standard_expansion = []
            f_derivatives, h_derivatives, t_derivatives = alpha
            for (f_power, h_power, t_power), coefficient in raw_expansion:
                standard_coefficient = (
                    coefficient
                    * (-242) ** h_power
                    * 4840 ** t_power
                    / (
                        (-242) ** h_derivatives
                        * 4840 ** t_derivatives
                        * 87278400
                    )
                )
                standard_expansion.append(
                    {
                        "monomial": [f_power, h_power, t_power],
                        "coefficient": str(standard_coefficient),
                    }
                )
            standard_terms.append(
                {
                    "derivatives": list(alpha),
                    "coefficient": standard_expansion,
                }
            )

    expected = {
        (0, 0, 1): [((3, 0, 0), Fraction(1))],
        (0, 0, 2): [((3, 0, 1), Fraction(45, 19))],
        (0, 1, 1): [((3, 1, 0), Fraction(30, 19))],
        (1, 0, 1): [((4, 0, 0), Fraction(720, 551))],
        (2, 0, 0): [((0, 0, 1), Fraction(11, 132240))],
        (0, 0, 3): [
            ((8, 0, 0), Fraction(777600, 551)),
            ((3, 3, 0), Fraction(225, 551)),
        ],
        (0, 1, 2): [((3, 1, 1), Fraction(450, 551))],
        (0, 2, 1): [((3, 2, 0), Fraction(300, 551))],
        (0, 3, 0): [((3, 0, 1), Fraction(200, 1653))],
        (1, 0, 2): [((4, 0, 1), Fraction(540, 551))],
        (1, 1, 1): [((4, 1, 0), Fraction(360, 551))],
        (2, 0, 1): [
            ((5, 0, 0), Fraction(216, 551)),
            ((0, 3, 0), Fraction(1, 8816)),
        ],
        (2, 1, 0): [((0, 1, 1), Fraction(1, 13224))],
        (3, 0, 0): [((1, 0, 1), Fraction(1, 33060))],
    }
    observed = {
        tuple(term["derivatives"]): [
            (
                tuple(entry["monomial"]),
                Fraction(entry["coefficient"]),
            )
            for entry in term["coefficient"]
        ]
        for term in standard_terms
    }
    if observed != expected:
        raise AssertionError("wrong standard-coordinate differential operator")
    return {
        "coordinates": "h=-H/242, t=T/4840",
        "relation": "t^2 = h^3 + 1728 f^5",
        "operator_normalization": "Delta=delta/87278400, so Delta(t)=f^3",
        "derivative_multiindex_order": ["f", "h", "t"],
        "normal_ordered_terms": standard_terms,
    }


def mckay_data() -> dict[str, object]:
    nodes = ["1", "2", "3", "4s", "5", "6", "3p", "4", "2p"]
    edges = [
        ("1", "2"),
        ("2", "3"),
        ("3", "4s"),
        ("4s", "5"),
        ("5", "6"),
        ("6", "3p"),
        ("6", "4"),
        ("4", "2p"),
    ]
    adjacency = {node: [] for node in nodes}
    for left, right in edges:
        adjacency[left].append(right)
        adjacency[right].append(left)

    symmetric_powers = [
        {node: int(node == "1") for node in nodes},
        {node: int(node == "2") for node in nodes},
    ]
    for degree in range(1, 60):
        tensor = {node: 0 for node in nodes}
        for node, multiplicity in symmetric_powers[degree].items():
            for neighbor in adjacency[node]:
                tensor[neighbor] += multiplicity
        symmetric_powers.append(
            {
                node: tensor[node] - symmetric_powers[degree - 1][node]
                for node in nodes
            }
        )
    if any(value < 0 for row in symmetric_powers for value in row.values()):
        raise AssertionError("McKay recurrence produced a negative multiplicity")

    def decomposition(degree: int) -> list[str]:
        return [
            node
            for node in nodes
            for _ in range(symmetric_powers[degree][node])
        ]

    def numerator_degrees(node: str) -> list[int]:
        coefficients: list[int] = []
        for degree in range(60):
            value = symmetric_powers[degree][node]
            if degree >= 12:
                value -= symmetric_powers[degree - 12][node]
            if degree >= 20:
                value -= symmetric_powers[degree - 20][node]
            if degree >= 32:
                value += symmetric_powers[degree - 32][node]
            coefficients.append(value)
        if any(value not in (0, 1) for value in coefficients):
            raise AssertionError("unexpected covariant Hilbert numerator")
        return [degree for degree, value in enumerate(coefficients) if value]

    expected_3p = [6, 10, 14, 16, 20, 24]
    expected_4 = [6, 8, 12, 14, 16, 18, 22, 24]
    if numerator_degrees("3p") != expected_3p:
        raise AssertionError("wrong 3' covariant numerator")
    if numerator_degrees("4") != expected_4:
        raise AssertionError("wrong 4 covariant numerator")
    if decomposition(6) != ["3p", "4"]:
        raise AssertionError("wrong Sym^6 decomposition")
    if decomposition(12) != ["1", "3", "5", "4"]:
        raise AssertionError("wrong Sym^12 decomposition")

    return {
        "affine_E8_edges": edges,
        "natural_representation": "2",
        "symmetric_power_6": decomposition(6),
        "symmetric_power_12": decomposition(12),
        "covariant_numerator_3p": expected_3p,
        "covariant_numerator_4": expected_4,
        "common_vertex": "4",
        "common_vertex_dimension": 4,
    }


def build_certificate() -> dict[str, object]:
    klein_f: Polynomial = {
        (11, 1): 1,
        (6, 6): 11,
        (1, 11): -1,
    }
    klein_h = transvectant(klein_f, klein_f, 2)
    klein_t = transvectant(klein_f, klein_h, 1)

    delta = lambda polynomial: transvectant(polynomial, klein_f, 3)
    f_squared = power(klein_f, 2)
    f_cubed = power(klein_f, 3)
    f_fifth = power(klein_f, 5)
    h_cubed = power(klein_h, 3)
    t_squared = power(klein_t, 2)

    source_basis = [
        {(6 - y_degree, y_degree): 1}
        for y_degree in range(7)
    ]
    transvectant_columns = [delta(basis_vector) for basis_vector in source_basis]
    rank = matrix_rank(transvectant_columns, 12)
    if rank != 4:
        raise AssertionError("the sextic-to-dodecic transvectant does not have rank four")

    if delta(klein_f) or delta(klein_h):
        raise AssertionError("delta should annihilate f and H")
    delta_t_ratio = proportionality(delta(klein_t), f_cubed)
    delta_f2_ratio = proportionality(delta(f_squared), klein_t)
    delta_f3_ratio = proportionality(delta(f_cubed), multiply(klein_f, klein_t))
    third_commutator = add_scaled(
        delta(f_cubed),
        multiply(klein_f, delta(f_squared)),
        -3,
    )
    third_symbol_ratio = proportionality(
        third_commutator,
        multiply(klein_f, klein_t),
    )
    if not third_symbol_ratio:
        raise AssertionError("delta has order at most two on the invariant ring")

    linearity_witness = add_scaled(
        delta(multiply(klein_f, source_basis[0])),
        multiply(klein_f, delta(source_basis[0])),
        -1,
    )
    if not linearity_witness:
        raise AssertionError("delta unexpectedly appears R-linear")

    # Solve T^2 = a H^3 + b f^5 from two independent coefficients.
    monomials = sorted(set(t_squared) | set(h_cubed) | set(f_fifth))
    relation_a = relation_b = None
    for left_index, left in enumerate(monomials):
        for right in monomials[left_index + 1 :]:
            determinant = (
                h_cubed.get(left, 0) * f_fifth.get(right, 0)
                - h_cubed.get(right, 0) * f_fifth.get(left, 0)
            )
            if not determinant:
                continue
            relation_a = Fraction(
                t_squared.get(left, 0) * f_fifth.get(right, 0)
                - t_squared.get(right, 0) * f_fifth.get(left, 0),
                determinant,
            )
            relation_b = Fraction(
                h_cubed.get(left, 0) * t_squared.get(right, 0)
                - h_cubed.get(right, 0) * t_squared.get(left, 0),
                determinant,
            )
            break
        if relation_a is not None:
            break
    if relation_a is None or relation_b is None:
        raise AssertionError("could not solve the Klein relation")
    for monomial in monomials:
        if Fraction(t_squared.get(monomial, 0)) != (
            relation_a * h_cubed.get(monomial, 0)
            + relation_b * f_fifth.get(monomial, 0)
        ):
            raise AssertionError("Klein relation failed")

    base_degree_66 = multiply(f_cubed, klein_t)
    relation_deltas = {
        "delta_T2_over_f3T": str(proportionality(delta(t_squared), base_degree_66)),
        "delta_H3_over_f3T": str(proportionality(delta(h_cubed), base_degree_66)),
        "delta_f5_over_f3T": str(proportionality(delta(f_fifth), base_degree_66)),
    }
    if (
        proportionality(delta(t_squared), base_degree_66)
        != relation_a * proportionality(delta(h_cubed), base_degree_66)
        + relation_b * proportionality(delta(f_fifth), base_degree_66)
    ):
        raise AssertionError("delta does not respect the Klein relation")

    return {
        "schema": "c682-klein-e8-differential-operator-v1",
        "field": "Q",
        "transvectant_convention": (
            "sum_i (-1)^i binom(r,i) "
            "dX^(r-i)dY^i(a) dX^i dY^(r-i)(b)"
        ),
        "klein_generators": {
            "f_degree": 12,
            "H_definition": "(f,f)_2",
            "H_degree": 20,
            "T_definition": "(f,H)_1",
            "T_degree": 30,
            "relation": f"T^2 = {relation_a} H^3 + {relation_b} f^5",
        },
        "mckay": mckay_data(),
        "finite_transvectant": {
            "map": "Sym^6 -> Sym^12, p |-> (p,f)_3",
            "rank": rank,
            "kernel_dimension": 3,
            "image_dimension": 4,
        },
        "ordinary_mcm_lift": {
            "source": "M_3p direct_sum M_4",
            "target": "R direct_sum M_3 direct_sum M_5 direct_sum M_4",
            "map": "zero on M_3p and a scalar split identity on M_4",
        },
        "invariant_ring_operator": {
            "degree_shift": 6,
            "ambient_order_upper_bound": 3,
            "exact_order_on_invariant_ring": 3,
            "delta_f": "0",
            "delta_H": "0",
            "delta_T_over_f3": str(delta_t_ratio),
            "delta_f2_over_T": str(delta_f2_ratio),
            "delta_f3_over_fT": str(delta_f3_ratio),
            "third_commutator_f_f_f_over_fT": str(third_symbol_ratio),
            "not_R_linear_witness": [
                monomial_string(monomial, coefficient)
                for monomial, coefficient in sorted(
                    linearity_witness.items(),
                    reverse=True,
                )
            ],
            **relation_deltas,
        },
        "standard_coordinate_operator": normal_form_data(
            klein_f,
            klein_h,
            klein_t,
        ),
        "claim_boundary": [
            "The ordinary Auslander-McKay lift is split and carries no extension data.",
            "The internal transvectant is not R-linear, so it is not a morphism of MCM modules.",
            "It is an exact order-three graded differential operator on the E8 invariant ring.",
            "No novelty claim for invariant differential operators is certified.",
        ],
    }


def canonical_json(data: dict[str, object]) -> str:
    return json.dumps(data, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()

    rendered = canonical_json(build_certificate())
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(CERTIFICATE)
        return
    if not CERTIFICATE.exists():
        raise SystemExit(f"missing certificate: {CERTIFICATE}")
    if CERTIFICATE.read_text(encoding="utf-8") != rendered:
        raise SystemExit("certificate is stale")
    print("certificate ok")


if __name__ == "__main__":
    main()
