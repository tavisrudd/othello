#!/usr/bin/env python3
"""Exact q=11 code audit for the conic-centered V22--Q3 Sarkisov link."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from math import comb
from pathlib import Path


Q = 11
N = 12
EXPONENTS = (0, 1, 3, 5, 6)
POINTS: tuple[int | str, ...] = tuple(range(Q)) + ("inf",)
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c682-conic-link-code.json"
SOURCE = {
    "key": "arXiv:1711.08504",
    "sha256": "94bf426f34dc90ca68ab1d581d7a37a2dbebf1a8e3f184188825a025524c664a",
    "formula": "(t0:t1) -> (t0^6:t0^5*t1:t0^3*t1^3:t0*t1^5:t1^6)",
}


def generator() -> list[list[int]]:
    """Rows for 1,t,t^3,t^5,t^6, with homogeneous evaluation at infinity."""
    return [
        [pow(t, exponent, Q) for t in range(Q)]
        + [int(exponent == max(EXPONENTS))]
        for exponent in EXPONENTS
    ]


def rank_mod(matrix: list[list[int]]) -> int:
    if not matrix or not matrix[0]:
        return 0
    work = [[entry % Q for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, Q)
        work[row] = [(inverse * entry) % Q for entry in work[row]]
        for other in range(len(work)):
            if other != row and work[other][column]:
                factor = work[other][column]
                work[other] = [
                    (left - factor * right) % Q
                    for left, right in zip(work[other], work[row])
                ]
        row += 1
    return row


def evaluate(coefficients: tuple[int, ...]) -> tuple[int, ...]:
    finite = tuple(
        sum(
            coefficient * pow(t, exponent, Q)
            for coefficient, exponent in zip(coefficients, EXPONENTS)
        )
        % Q
        for t in range(Q)
    )
    return finite + (coefficients[-1] % Q,)


def point_label(index: int) -> int | str:
    return POINTS[index]


def canonical_matrix(matrix: tuple[int, int, int, int]) -> bool:
    first = next((entry for entry in matrix if entry), None)
    return first == 1


def pgl2_matrices() -> list[tuple[int, int, int, int]]:
    result = []
    for matrix in itertools.product(range(Q), repeat=4):
        a, b, c, d = matrix
        if canonical_matrix(matrix) and (a * d - b * c) % Q:
            result.append(matrix)
    return result


def mobius(matrix: tuple[int, int, int, int], point: int | str) -> int | str:
    a, b, c, d = matrix
    if point == "inf":
        return "inf" if c == 0 else a * pow(c, -1, Q) % Q
    denominator = (c * point + d) % Q
    if denominator == 0:
        return "inf"
    return (a * point + b) * pow(denominator, -1, Q) % Q


def krawtchouk(degree: int, weight: int) -> int:
    total = 0
    for overlap in range(degree + 1):
        outside = degree - overlap
        if overlap <= weight and outside <= N - weight:
            total += (
                (-1) ** overlap
                * (Q - 1) ** outside
                * comb(weight, overlap)
                * comb(N - weight, outside)
            )
    return total


def generalized_weights(matrix: list[list[int]], dimension: int) -> list[int]:
    result = []
    for order in range(1, dimension + 1):
        maximum = 0
        rank_bound = dimension - order
        for size in range(N + 1):
            for subset in itertools.combinations(range(N), size):
                restricted = [[row[column] for column in subset] for row in matrix]
                if rank_mod(restricted) <= rank_bound:
                    maximum = max(maximum, size)
        result.append(N - maximum)
    return result


def certificate() -> dict[str, object]:
    matrix = generator()
    assert rank_mod(matrix) == 5

    weight_enumerator = {weight: 0 for weight in range(N + 1)}
    six_secants: set[tuple[int | str, ...]] = set()
    for coefficients in itertools.product(range(Q), repeat=len(EXPONENTS)):
        values = evaluate(coefficients)
        weight = sum(value != 0 for value in values)
        weight_enumerator[weight] += 1
        if coefficients != (0,) * len(EXPONENTS):
            first = next(entry for entry in coefficients if entry)
            if first == 1 and weight == 6:
                six_secants.add(
                    tuple(point_label(index) for index, value in enumerate(values) if not value)
                )
    weight_enumerator = {
        weight: count for weight, count in weight_enumerator.items() if count
    }
    assert weight_enumerator[0] == 1
    assert sum(weight_enumerator.values()) == Q**5
    assert min(weight for weight in weight_enumerator if weight) == 6
    assert len(six_secants) == 24

    circuits: list[tuple[int | str, ...]] = []
    for size in range(2, 5):
        dependent = []
        for subset in itertools.combinations(range(N), size):
            restricted = [[row[column] for column in subset] for row in matrix]
            if rank_mod(restricted) < size:
                dependent.append(tuple(point_label(index) for index in subset))
        if size < 4:
            assert dependent == []
        else:
            circuits = dependent
    assert len(circuits) == 15

    squares = frozenset(pow(value, 2, Q) for value in range(1, Q))
    nonsquares = frozenset(range(1, Q)) - squares
    pole_blocks = [
        circuit for circuit in circuits if 0 in circuit and "inf" in circuit
    ]
    square_blocks = [
        circuit for circuit in circuits if frozenset(circuit).issubset(squares)
    ]
    nonsquare_blocks = [
        circuit for circuit in circuits if frozenset(circuit).issubset(nonsquares)
    ]
    assert [len(pole_blocks), len(square_blocks), len(nonsquare_blocks)] == [5, 5, 5]

    dual_weight_enumerator = {}
    for dual_weight in range(N + 1):
        count = sum(
            primal_count * krawtchouk(dual_weight, primal_weight)
            for primal_weight, primal_count in weight_enumerator.items()
        ) // (Q**5)
        if count:
            dual_weight_enumerator[dual_weight] = count
    assert sum(dual_weight_enumerator.values()) == Q**7
    assert min(weight for weight in dual_weight_enumerator if weight) == 4
    assert dual_weight_enumerator[4] == (Q - 1) * len(circuits)

    circuit_sets = {frozenset(circuit) for circuit in circuits}
    stabilizer = []
    for matrix_element in pgl2_matrices():
        if all(
            frozenset(mobius(matrix_element, point) for point in circuit)
            in circuit_sets
            for circuit in circuits
        ):
            stabilizer.append(matrix_element)
    expected_stabilizer = {
        (1, 0, 0, scalar) for scalar in range(1, Q)
    } | {
        (0, 1, scalar, 0) for scalar in range(1, Q)
    }
    assert set(stabilizer) == expected_stabilizer

    hierarchy = generalized_weights(matrix, 5)
    dual_hierarchy = sorted(
        N + 1 - value for value in set(range(1, N + 1)) - set(hierarchy)
    )
    assert hierarchy == [6, 7, 10, 11, 12]
    assert dual_hierarchy == [4, 5, 8, 9, 10, 11, 12]

    return {
        "schema": "c682-conic-link-code-v1",
        "field": Q,
        "evaluation_points": list(POINTS),
        "source": SOURCE,
        "exponents": list(EXPONENTS),
        "generator_matrix": matrix,
        "code": {
            "parameters": [12, 5, 6],
            "singleton_defect": 2,
            "weight_enumerator": {
                str(weight): count for weight, count in weight_enumerator.items()
            },
            "generalized_hamming_weights": hierarchy,
            "projective_minimum_words": weight_enumerator[6] // (Q - 1),
            "rational_six_secant_hyperplanes": [
                list(block)
                for block in sorted(six_secants, key=lambda row: tuple(map(str, row)))
            ],
        },
        "dual": {
            "parameters": [12, 7, 4],
            "singleton_defect": 2,
            "weight_enumerator": {
                str(weight): count
                for weight, count in dual_weight_enumerator.items()
            },
            "generalized_hamming_weights": dual_hierarchy,
            "projective_minimum_words": dual_weight_enumerator[4] // (Q - 1),
            "four_point_circuits": [list(circuit) for circuit in circuits],
            "circuit_orbit_counts": {
                "pole_blocks": len(pole_blocks),
                "quadratic_residue_blocks": len(square_blocks),
                "quadratic_nonresidue_blocks": len(nonsquare_blocks),
            },
        },
        "projective_parameter_stabilizer": {
            "ambient_group": "PGL2(F_11)",
            "ambient_group_order": len(pgl2_matrices()),
            "order": len(stabilizer),
            "description": "t -> a*t and t -> a/t for a in F_11^*",
            "isomorphism_type": "F_11^* semidirect C2 (dihedral order 20)",
            "matrices": [list(matrix_element) for matrix_element in stabilizer],
        },
        "exact_sequences": [
            "0 -> C_Gamma -> R_6 -> F_11^2 -> 0",
            "0 -> R_4 -> C_Gamma^perp -> F_11^2 -> 0",
        ],
    }


def serialized() -> str:
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    output = serialized()
    if arguments.check:
        tracked = CERTIFICATE.read_text()
        assert output == tracked
        digest = hashlib.sha256(tracked.encode()).hexdigest()
        print(f"PASS: conic-link code certificate matches ({digest})")
    else:
        CERTIFICATE.write_text(output)
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
