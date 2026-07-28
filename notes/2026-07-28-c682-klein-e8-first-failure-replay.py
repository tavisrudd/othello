#!/usr/bin/env python3
"""Independent modular replay of the C682 Klein E8 first failure."""

from __future__ import annotations

import json
from functools import reduce
from math import comb, factorial, gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-28-c682-klein-e8-first-failure.json"
PRIMES = (1_000_000_007, 1_000_000_009)
KLEIN = {(11, 1): 1, (6, 6): 11, (1, 11): -1}


def derivative_z(polynomial, dx, dy):
    out = {}
    for (x_degree, y_degree), coefficient in polynomial.items():
        if x_degree < dx or y_degree < dy:
            continue
        multiplier = 1
        for offset in range(dx):
            multiplier *= x_degree - offset
        for offset in range(dy):
            multiplier *= y_degree - offset
        out[(x_degree - dx, y_degree - dy)] = coefficient * multiplier
    return out


def multiply_z(left, right):
    out = {}
    for (lx, ly), left_coefficient in left.items():
        for (rx, ry), right_coefficient in right.items():
            monomial = (lx + rx, ly + ry)
            out[monomial] = (
                out.get(monomial, 0) + left_coefficient * right_coefficient
            )
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def transvectant_z(left, right, order):
    out = {}
    for index in range(order + 1):
        term = multiply_z(
            derivative_z(left, order - index, index),
            derivative_z(right, index, order - index),
        )
        scale = (-1 if index % 2 else 1) * comb(order, index)
        for monomial, coefficient in term.items():
            out[monomial] = out.get(monomial, 0) + scale * coefficient
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def derivative(polynomial, dx, dy, prime):
    out = {}
    for (x_degree, y_degree), coefficient in polynomial.items():
        if x_degree < dx or y_degree < dy:
            continue
        multiplier = 1
        for offset in range(dx):
            multiplier = multiplier * (x_degree - offset) % prime
        for offset in range(dy):
            multiplier = multiplier * (y_degree - offset) % prime
        out[(x_degree - dx, y_degree - dy)] = coefficient * multiplier % prime
    return out


def multiply(left, right, prime):
    out = {}
    for (lx, ly), left_coefficient in left.items():
        for (rx, ry), right_coefficient in right.items():
            monomial = (lx + rx, ly + ry)
            out[monomial] = (
                out.get(monomial, 0) + left_coefficient * right_coefficient
            ) % prime
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def transvectant(left, right, order, prime):
    out = {}
    for index in range(order + 1):
        term = multiply(
            derivative(left, order - index, index, prime),
            derivative(right, index, order - index, prime),
            prime,
        )
        scale = (-1 if index % 2 else 1) * comb(order, index)
        for monomial, coefficient in term.items():
            out[monomial] = (out.get(monomial, 0) + scale * coefficient) % prime
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def delta_matrix(source_degree, prime):
    columns = [
        transvectant(
            {(source_degree - index, index): 1},
            KLEIN,
            3,
            prime,
        )
        for index in range(source_degree + 1)
    ]
    return [
        [
            column.get((source_degree + 6 - row, row), 0)
            for column in columns
        ]
        for row in range(source_degree + 7)
    ]


def coefficient_vector(polynomial, degree):
    return [
        polynomial.get((degree - index, index), 0)
        for index in range(degree + 1)
    ]


def identity(size):
    return [[int(row == column) for column in range(size)] for row in range(size)]


def matrix_multiply(left, right, prime):
    inner = len(right)
    columns = len(right[0])
    out = [[0] * columns for _ in range(len(left))]
    for row, left_row in enumerate(left):
        for middle in range(inner):
            coefficient = left_row[middle]
            if not coefficient:
                continue
            for column in range(columns):
                out[row][column] = (
                    out[row][column] + coefficient * right[middle][column]
                ) % prime
    return out


def matrix_subtract(left, right, prime):
    return [
        [(a - b) % prime for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def adjoint(matrix, source_degree, prime):
    return [
        [
            matrix[target_index][source_index]
            * factorial(source_degree + 6 - target_index)
            * factorial(target_index)
            * pow(
                factorial(source_degree - source_index)
                * factorial(source_index),
                -1,
                prime,
            )
            % prime
            for target_index in range(source_degree + 7)
        ]
        for source_index in range(source_degree + 1)
    ]


class RowBasis:
    def __init__(self, prime):
        self.prime = prime
        self.rows = {}

    def add(self, vector):
        work = [entry % self.prime for entry in vector]
        for pivot in sorted(self.rows):
            if not work[pivot]:
                continue
            multiplier = work[pivot]
            row = self.rows[pivot]
            work = [
                (entry - multiplier * basis_entry) % self.prime
                for entry, basis_entry in zip(work, row)
            ]
        pivot = next((index for index, entry in enumerate(work) if entry), None)
        if pivot is None:
            return False
        inverse = pow(work[pivot], -1, self.prime)
        work = [entry * inverse % self.prime for entry in work]
        for old_pivot, row in list(self.rows.items()):
            if row[pivot]:
                multiplier = row[pivot]
                self.rows[old_pivot] = [
                    (entry - multiplier * new_entry) % self.prime
                    for entry, new_entry in zip(row, work)
                ]
        self.rows[pivot] = work
        return True

    def __len__(self):
        return len(self.rows)


def flatten(matrix):
    return [entry for row in matrix for entry in row]


def matrix_rank(matrix, prime):
    basis = RowBasis(prime)
    for row in matrix:
        basis.add(row)
    return len(basis)


def generated_algebra_dimension(generators, prime):
    size = len(generators[0])
    unit = identity(size)
    basis = RowBasis(prime)
    basis.add(flatten(unit))
    matrices = [unit]
    frontier = [unit]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            for candidate in (
                matrix_multiply(current, generator, prime),
                matrix_multiply(generator, current, prime),
            ):
                if basis.add(flatten(candidate)):
                    matrices.append(candidate)
                    frontier.append(candidate)
    return len(basis)


def round_trip_operator(source_degree, steps, prime):
    raising = identity(source_degree + 1)
    edge_matrices = []
    current_degree = source_degree
    for _ in range(steps):
        edge = delta_matrix(current_degree, prime)
        edge_matrices.append((current_degree, edge))
        raising = matrix_multiply(edge, raising, prime)
        current_degree += 6
    lowering = identity(current_degree + 1)
    for edge_degree, edge in reversed(edge_matrices):
        lowering = matrix_multiply(
            adjoint(edge, edge_degree, prime),
            lowering,
            prime,
        )
    return matrix_multiply(lowering, raising, prime)


def mckay_decomposition(degree):
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
    previous = {node: int(node == "1") for node in nodes}
    if degree == 0:
        current = previous
    else:
        current = {node: int(node == "2") for node in nodes}
    for _ in range(1, degree):
        tensor = {node: 0 for node in nodes}
        for node, multiplicity in current.items():
            for neighbor in adjacency[node]:
                tensor[neighbor] += multiplicity
        following = {
            node: tensor[node] - previous[node]
            for node in nodes
        }
        previous, current = current, following
    return {
        node: multiplicity
        for node, multiplicity in current.items()
        if multiplicity
    }


def replay(prime):
    dimensions = []
    for degree in range(23):
        decomposition = mckay_decomposition(degree)
        commutant_dimension = sum(
            multiplicity * multiplicity
            for multiplicity in decomposition.values()
        )
        first = round_trip_operator(degree, 1, prime)
        second = round_trip_operator(degree, 2, prime)
        dimensions.append(
            (
                commutant_dimension,
                generated_algebra_dimension([first, second], prime),
            )
        )
    first = round_trip_operator(22, 1, prime)
    second = round_trip_operator(22, 2, prime)
    commutator_rank = matrix_rank(
        matrix_subtract(
            matrix_multiply(first, second, prime),
            matrix_multiply(second, first, prime),
            prime,
        ),
        prime,
    )
    return dimensions, commutator_rank


def covariant_replay(prime):
    hessian_z = transvectant_z(KLEIN, KLEIN, 2)
    jacobian_z = transvectant_z(KLEIN, hessian_z, 1)
    contents = (
        reduce(gcd, (abs(value) for value in hessian_z.values())),
        reduce(gcd, (abs(value) for value in jacobian_z.values())),
    )
    primitive_hessian_z = {
        monomial: coefficient // contents[0]
        for monomial, coefficient in hessian_z.items()
    }
    ordinary_polars_z = [
        derivative_z(KLEIN, 2, 0),
        derivative_z(KLEIN, 1, 1),
        derivative_z(KLEIN, 0, 2),
    ]
    if (
        contents != (242, 4840)
        or any(
            coefficient % 11
            for polar in ordinary_polars_z
            for coefficient in polar.values()
        )
        or not any(coefficient % 11 for coefficient in primitive_hessian_z.values())
    ):
        raise SystemExit("integral normalization replay failed")
    hessian = transvectant(KLEIN, KLEIN, 2, prime)
    jacobian = transvectant(KLEIN, hessian, 1, prime)
    quadratics = [
        {(2, 0): 1},
        {(1, 1): 1},
        {(0, 2): 1},
    ]
    polars = [
        derivative(KLEIN, 2, 0, prime),
        derivative(KLEIN, 1, 1, prime),
        derivative(KLEIN, 0, 2, prime),
    ]
    domain = [
        multiply(hessian, quadratic, prime)
        for quadratic in quadratics
    ] + [
        multiply(KLEIN, polar, prime)
        for polar in polars
    ]
    image_vectors = [
        coefficient_vector(transvectant(polynomial, KLEIN, 3, prime), 28)
        for polynomial in domain
    ]
    target_vectors = [
        coefficient_vector(derivative(jacobian, 2, 0, prime), 28),
        coefficient_vector(derivative(jacobian, 1, 1, prime), 28),
        coefficient_vector(derivative(jacobian, 0, 2, prime), 28),
    ]
    if (
        matrix_rank(image_vectors, prime) != 3
        or matrix_rank(target_vectors, prime) != 3
        or matrix_rank(image_vectors + target_vectors, prime) != 3
    ):
        raise SystemExit(f"covariant image replay failed modulo {prime}")
    five_elevenths = 5 * pow(11, -1, prime) % prime
    relations = [
        [0, 0, five_elevenths, 1, 0, 0],
        [0, -five_elevenths % prime, 0, 0, 1, 0],
        [five_elevenths, 0, 0, 0, 0, 1],
    ]
    for relation in relations:
        combined = [
            sum(
                relation[column] * image_vectors[column][row]
                for column in range(6)
            )
            % prime
            for row in range(29)
        ]
        if any(combined):
            raise SystemExit(f"dark-line replay failed modulo {prime}")

    nodes = ["1", "2", "3", "4s", "5", "6", "3p", "4", "2p"]
    decompositions = [mckay_decomposition(degree) for degree in range(121)]
    numerators = {}
    for module in nodes:
        numerator = []
        for degree in range(121):
            coefficient = decompositions[degree].get(module, 0)
            if degree >= 12:
                coefficient -= decompositions[degree - 12].get(module, 0)
            if degree >= 20:
                coefficient -= decompositions[degree - 20].get(module, 0)
            if degree >= 32:
                coefficient += decompositions[degree - 32].get(module, 0)
            if coefficient:
                numerator.append([degree, coefficient])
        numerators[module] = numerator
    forced = []
    for degree in range(68):
        current = mckay_decomposition(degree)
        lower = mckay_decomposition(degree - 6) if degree >= 6 else {}
        upper = mckay_decomposition(degree + 6)
        for module, multiplicity in current.items():
            if (
                multiplicity >= 2
                and lower.get(module, 0) == 0
                and upper.get(module, 0) == 1
            ):
                forced.append([degree, module, multiplicity])
    return numerators, forced


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    expected_dimensions = [
        (row["commutant_dimension"], row["two_return_dimension"])
        for row in certificate["rows"]
    ]
    summaries = []
    for prime in PRIMES:
        dimensions, commutator_rank = replay(prime)
        if dimensions != expected_dimensions or commutator_rank != 10:
            raise SystemExit(f"independent replay failed modulo {prime}")
        numerators, forced = covariant_replay(prime)
        classification = certificate["standard_covariant_identification"][
            "all_weight_bottleneck_classification"
        ]
        if (
            numerators != classification["Molien_numerators_over_Q_Phi12_H20"]
            or forced != [[22, "3", 2]]
        ):
            raise SystemExit(f"Molien replay failed modulo {prime}")
        summaries.append(
            {
                "prime": prime,
                "degrees_checked": "0..22",
                "first_failure": 22,
                "dimension_at_failure": "8<10",
                "commutator_rank": commutator_rank,
                "dark_line": "three exact relations",
                "forced_bottlenecks_all_weights": forced,
            }
        )
    print(json.dumps({"independent_replay": "PASS", "runs": summaries}, sort_keys=True))


if __name__ == "__main__":
    main()
