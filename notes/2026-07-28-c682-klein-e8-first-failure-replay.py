#!/usr/bin/env python3
"""Independent modular replay of the C682 Klein E8 first failure."""

from __future__ import annotations

import json
from math import comb, factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-28-c682-klein-e8-first-failure.json"
PRIMES = (1_000_000_007, 1_000_000_009)
KLEIN = {(11, 1): 1, (6, 6): 11, (1, 11): -1}


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
        summaries.append(
            {
                "prime": prime,
                "degrees_checked": "0..22",
                "first_failure": 22,
                "dimension_at_failure": "8<10",
                "commutator_rank": commutator_rank,
            }
        )
    print(json.dumps({"independent_replay": "PASS", "runs": summaries}, sort_keys=True))


if __name__ == "__main__":
    main()
