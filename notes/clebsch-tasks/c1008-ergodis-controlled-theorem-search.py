#!/usr/bin/env python3
"""Exact checks and bounded reconnaissance for C1008."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter
from fractions import Fraction
from pathlib import Path


MODULUS = 1_000_003


def rank_mod(rows: list[list[int]], width: int, modulus: int = MODULUS) -> int:
    work = [[entry % modulus for entry in row] for row in rows]
    rank = 0
    for column in range(width):
        pivot = next(
            (
                row
                for row in range(rank, len(work))
                if work[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, modulus)
        work[rank] = [entry * inverse % modulus for entry in work[rank]]
        for row in range(len(work)):
            if row == rank or not work[row][column]:
                continue
            factor = work[row][column]
            work[row] = [
                (entry - factor * pivot_entry) % modulus
                for entry, pivot_entry in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def solve_exact(matrix: list[list[int]], rhs: list[int]) -> list[Fraction]:
    size = len(matrix)
    work = [
        [Fraction(entry) for entry in row + [value]]
        for row, value in zip(matrix, rhs)
    ]
    for column in range(size):
        pivot = next(
            row for row in range(column, size) if work[row][column]
        )
        work[column], work[pivot] = work[pivot], work[column]
        scale = work[column][column]
        work[column] = [entry / scale for entry in work[column]]
        for row in range(size):
            if row == column or not work[row][column]:
                continue
            factor = work[row][column]
            work[row] = [
                entry - factor * pivot_entry
                for entry, pivot_entry in zip(work[row], work[column])
            ]
    return [work[index][-1] for index in range(size)]


def determinant_bareiss(matrix: list[list[int]]) -> int:
    work = [row[:] for row in matrix]
    sign = 1
    previous = 1
    for column in range(len(work) - 1):
        if not work[column][column]:
            pivot = next(
                row
                for row in range(column + 1, len(work))
                if work[row][column]
            )
            work[column], work[pivot] = work[pivot], work[column]
            sign = -sign
        diagonal = work[column][column]
        for row in range(column + 1, len(work)):
            for index in range(column + 1, len(work)):
                work[row][index] = (
                    work[row][index] * diagonal
                    - work[row][column] * work[column][index]
                ) // previous
        previous = diagonal
    return sign * work[-1][-1]


def graph_summary() -> dict[str, object]:
    edges = tuple(itertools.combinations(range(6), 2))
    admissible = 0
    cluster_count = 0
    for mask in range(1 << len(edges)):
        edge_set = {
            edge for index, edge in enumerate(edges) if mask >> index & 1
        }
        degrees = [
            sum(tuple(sorted((vertex, other))) in edge_set for other in range(6) if other != vertex)
            for vertex in range(6)
        ]
        triangles = sum(
            all(tuple(sorted(edge)) in edge_set for edge in itertools.combinations(triple, 2))
            for triple in itertools.combinations(range(6), 3)
        )
        cluster_defect = (
            sum(degree * degree for degree in degrees)
            - 2 * len(edge_set)
            - 6 * triangles
        )

        unseen = set(range(6))
        component_sizes = []
        all_components_complete = True
        while unseen:
            seed = min(unseen)
            stack = [seed]
            component = set()
            while stack:
                vertex = stack.pop()
                if vertex in component:
                    continue
                component.add(vertex)
                unseen.discard(vertex)
                stack.extend(
                    other
                    for other in range(6)
                    if other not in component
                    and tuple(sorted((vertex, other))) in edge_set
                )
            component_sizes.append(len(component))
            all_components_complete &= all(
                tuple(sorted(pair)) in edge_set
                for pair in itertools.combinations(component, 2)
            )

        direct = all_components_complete and any(
            size % 2 for size in component_sizes
        )
        scalar = cluster_defect == 0 and any(
            degree % 2 == 0 for degree in degrees
        )
        assert direct == scalar
        assert cluster_defect >= 0 and cluster_defect % 2 == 0
        cluster_count += int(all_components_complete)
        admissible += int(direct)

    return {
        "graphs_checked": 1 << len(edges),
        "cluster_graphs": cluster_count,
        "admissible_graphs": admissible,
        "identity": (
            "sum_v deg(v)^2-2|E|-6T = 2*(number of induced P3)"
        ),
        "criterion": (
            "cluster_defect=0 and at least one even-degree vertex"
        ),
        "controller_outcome_hash": (
            "9bc0e6bf4c01a773c96422744f5216a110764fc5ad1aafff398ba3e912ea90a2"
        ),
    }


def projective_points(q: int) -> list[tuple[int, int, int]]:
    return (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )


def internal_points(q: int) -> list[tuple[int, int, int]]:
    squares = {value * value % q for value in range(1, q)}

    def delta(point: tuple[int, int, int]) -> int:
        x, y, z = point
        return (y * y - x * z) % q

    return [
        point
        for point in projective_points(q)
        if delta(point) not in squares | {0}
    ]


def rho(
    q: int,
    first: tuple[int, int, int],
    second: tuple[int, int, int],
) -> int:
    x, y, z = first
    u, v, w = second
    delta_first = (y * y - x * z) % q
    delta_second = (v * v - u * w) % q
    beta = (2 * y * v - x * w - z * u) % q
    return beta * beta * pow(delta_first * delta_second, -1, q) % q


Matrix = list[list[int]]


def multiply(first: Matrix, second: Matrix) -> Matrix:
    columns = list(zip(*second))
    return [
        [sum(x * y for x, y in zip(row, column)) for column in columns]
        for row in first
    ]


def relation_certificate(label: int) -> dict[str, object]:
    points = internal_points(13)
    size = len(points)
    adjacency = [
        [
            int(
                first != second
                and rho(13, points[first], points[second]) == label
            )
            for second in range(size)
        ]
        for first in range(size)
    ]
    valencies = {sum(row) for row in adjacency}
    assert len(valencies) == 1

    powers = [
        [
            [int(first == second) for second in range(size)]
            for first in range(size)
        ]
    ]
    for _ in range(7):
        powers.append(multiply(powers[-1], adjacency))

    for degree in range(1, 8):
        selected: list[list[int]] = []
        coordinates: list[tuple[int, int]] = []
        for flat_index in range(size * size):
            first, second = divmod(flat_index, size)
            row = [
                powers[exponent][first][second]
                for exponent in range(degree)
            ]
            if rank_mod([*selected, row], degree) == len(selected):
                continue
            selected.append(row)
            coordinates.append((first, second))
            if len(selected) == degree:
                break
        assert len(selected) == degree
        coefficients = solve_exact(
            selected,
            [powers[degree][first][second] for first, second in coordinates],
        )
        if not all(
            Fraction(powers[degree][first][second])
            == sum(
                coefficients[exponent] * powers[exponent][first][second]
                for exponent in range(degree)
            )
            for first in range(size)
            for second in range(size)
        ):
            continue
        assert all(value.denominator == 1 for value in coefficients)
        integer_coefficients = [value.numerator for value in coefficients]
        return {
            "label": label,
            "valency": next(iter(valencies)),
            "minimal_polynomial_degree": degree,
            "power_identity_coefficients_c0_up": integer_coefficients,
            "minimal_polynomial_coefficients_high_to_low": [
                1,
                *[
                    -integer_coefficients[index]
                    for index in range(degree - 1, -1, -1)
                ],
            ],
            "canonical_pivot_entries": [list(pair) for pair in coordinates],
            "pivot_minor_determinant": determinant_bareiss(selected),
            "exact_entrywise_identity_checked": True,
        }
    raise AssertionError("no relation identity through degree seven")


def primes_through(limit: int) -> list[int]:
    return [
        value
        for value in range(5, limit + 1, 2)
        if all(
            value % divisor
            for divisor in range(3, int(value**0.5) + 1, 2)
        )
    ]


def rho_zero_degree_mod(q: int) -> tuple[int, int]:
    points = internal_points(q)

    def relation(
        first: tuple[int, int, int], second: tuple[int, int, int]
    ) -> int:
        return -1 if first == second else rho(q, first, second)

    base = points[0]
    labels = [-1] + sorted(
        {relation(base, point) for point in points[1:]}
    )
    representatives = {-1: base}
    for point in points[1:]:
        representatives.setdefault(relation(base, point), point)
    zero_neighbors = [
        point for point in points if relation(base, point) == 0
    ]
    multiplication_rows = []
    for label in labels:
        counts = Counter(
            relation(point, representatives[label])
            for point in zero_neighbors
        )
        multiplication_rows.append([counts[value] for value in labels])

    vector = [1] + [0] * (len(labels) - 1)
    rows = []
    while rank_mod([*rows, vector], len(labels)) > len(rows):
        rows.append(vector)
        vector = [
            sum(
                vector[index] * multiplication_rows[target][index]
                for index in range(len(labels))
            )
            % MODULUS
            for target in range(len(labels))
        ]
    return len(labels), len(rows)


def legendre(q: int, value: int) -> int:
    if q == value:
        return 0
    return 1 if pow(value % q, (q - 1) // 2, q) == 1 else -1


def modular_reconnaissance() -> dict[str, object]:
    rows = []
    for q in primes_through(199):
        rank, degree = rho_zero_degree_mod(q)
        rows.append(
            {
                "q": q,
                "scheme_rank": rank,
                "degree_mod_p": degree,
                "deficit_mod_p": rank - degree,
            }
        )
    nonfull = [row for row in rows if row["deficit_mod_p"]]
    features_13 = [
        13 % 12,
        *[legendre(13, value) for value in (2, 3, 5, 7)],
    ]
    features_157 = [
        157 % 12,
        *[legendre(157, value) for value in (2, 3, 5, 7)],
    ]
    assert features_13 == features_157
    row_13 = next(row for row in rows if row["q"] == 13)
    row_157 = next(row for row in rows if row["q"] == 157)
    assert not row_13["deficit_mod_p"] and row_157["deficit_mod_p"]
    return {
        "scope": "odd primes 5<=q<=199",
        "modulus": MODULUS,
        "rows": len(rows),
        "nonfull_rows": nonfull,
        "coarse_feature_collision": {
            "features": ["q_mod_12", "chi_2", "chi_3", "chi_5", "chi_7"],
            "values": features_13,
            "full_row": row_13,
            "nonfull_row": row_157,
            "controller_unavoidable_errors": 2,
        },
        "boundary": (
            "A full modular degree proves characteristic-zero generation; "
            "a modular deficit is reconnaissance, not a proof of "
            "characteristic-zero nongeneration."
        ),
    }


def compute() -> dict[str, object]:
    relation_certificates = {
        str(label): relation_certificate(label)
        for label in (0, 1, 3, 9, 10, 12)
    }
    assert relation_certificates["0"]["minimal_polynomial_degree"] == 7
    assert relation_certificates["9"]["minimal_polynomial_degree"] == 6
    return {
        "schema": "c1008-ergodis-controlled-theorem-search-v1",
        "six_local_scalar_criterion": graph_summary(),
        "q13_elliptic_relations": {
            "point_count": 78,
            "scheme_dimension": 7,
            "certificates": relation_certificates,
            "rho_zero_conclusion": (
                "Q[A_0] is the full elliptic Bose--Mesner algebra"
            ),
        },
        "rho_zero_modular_reconnaissance": modular_reconnaissance(),
        "controller_notes": {
            "synthesize_failure": (
                "predicate tree synthesis rejected with "
                "'plan result sort does not match its declared output'"
            ),
            "working_commands": ["ceiling", "try", "evolve", "shutdown"],
        },
    }


def render(result: dict[str, object]) -> str:
    return json.dumps(result, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    output = render(compute())
    if arguments.write:
        arguments.write.write_text(output, encoding="utf-8")
    elif arguments.check:
        assert arguments.check.read_text(encoding="utf-8") == output
        print("C1008 controlled theorem-search certificate: PASS")
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
