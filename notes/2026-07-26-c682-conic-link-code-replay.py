#!/usr/bin/env python3
"""Independent replay of the C682 conic-link code certificate."""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path


Q = 11
POINTS: tuple[int | str, ...] = tuple(range(Q)) + ("inf",)
EXPONENTS = (0, 1, 3, 5, 6)
CERTIFICATE = (
    Path(__file__).resolve().parent / "2026-07-26-c682-conic-link-code.json"
)


def normalize(vector: tuple[int, ...]) -> tuple[int, ...]:
    pivot = next(value for value in vector if value)
    inverse = pow(pivot, -1, Q)
    return tuple(inverse * value % Q for value in vector)


def values(coefficients: tuple[int, ...]) -> tuple[int, ...]:
    answer = []
    for parameter in range(Q):
        answer.append(
            sum(
                coefficient * pow(parameter, exponent, Q)
                for coefficient, exponent in zip(coefficients, EXPONENTS)
            )
            % Q
        )
    answer.append(coefficients[-1] % Q)
    return tuple(answer)


def determinant(matrix: list[list[int]]) -> int:
    size = len(matrix)
    if size == 0:
        return 1
    total = 0
    for column in range(size):
        minor = [
            [entry for index, entry in enumerate(row) if index != column]
            for row in matrix[1:]
        ]
        total += (-1) ** column * matrix[0][column] * determinant(minor)
    return total % Q


def column(point: int | str) -> list[int]:
    if point == "inf":
        return [0, 0, 0, 0, 1]
    return [pow(point, exponent, Q) for exponent in EXPONENTS]


def dependent(block: tuple[int | str, ...]) -> bool:
    size = len(block)
    columns = [column(point) for point in block]
    for row_indices in itertools.combinations(range(5), size):
        square = [
            [columns[column_index][row_index] for column_index in range(size)]
            for row_index in row_indices
        ]
        if determinant(square):
            return False
    return True


def fractional_linear(
    matrix: tuple[int, int, int, int], point: int | str
) -> int | str:
    a, b, c, d = matrix
    if point == "inf":
        return "inf" if c == 0 else a * pow(c, -1, Q) % Q
    denominator = (c * point + d) % Q
    if denominator == 0:
        return "inf"
    return (a * point + b) * pow(denominator, -1, Q) % Q


def normalized_pgl2() -> list[tuple[int, int, int, int]]:
    answer = []
    for matrix in itertools.product(range(Q), repeat=4):
        a, b, c, d = matrix
        first = next((value for value in matrix if value), None)
        if first == 1 and (a * d - b * c) % Q:
            answer.append(matrix)
    return answer


def main() -> None:
    expected = json.loads(CERTIFICATE.read_text())

    representatives = set()
    projective_weights: Counter[int] = Counter()
    six_secants = set()
    for raw in itertools.product(range(Q), repeat=5):
        if not any(raw):
            continue
        coefficients = normalize(raw)
        if coefficients in representatives:
            continue
        representatives.add(coefficients)
        evaluated = values(coefficients)
        weight = sum(value != 0 for value in evaluated)
        projective_weights[weight] += 1
        if weight == 6:
            six_secants.add(
                tuple(point for point, value in zip(POINTS, evaluated) if value == 0)
            )
    weight_enumerator = {0: 1} | {
        weight: count * (Q - 1)
        for weight, count in sorted(projective_weights.items())
    }
    assert weight_enumerator == {
        int(weight): count
        for weight, count in expected["code"]["weight_enumerator"].items()
    }
    assert len(representatives) == (Q**5 - 1) // (Q - 1)
    assert len(six_secants) == 24

    circuits = []
    for size in range(2, 5):
        found = [
            block
            for block in itertools.combinations(POINTS, size)
            if dependent(block)
        ]
        if size < 4:
            assert found == []
        else:
            circuits = found
    expected_circuits = {
        frozenset(block) for block in expected["dual"]["four_point_circuits"]
    }
    assert {frozenset(block) for block in circuits} == expected_circuits
    assert len(circuits) == 15

    stabilizer = []
    for matrix in normalized_pgl2():
        if all(
            frozenset(fractional_linear(matrix, point) for point in block)
            in expected_circuits
            for block in circuits
        ):
            stabilizer.append(matrix)
    assert len(normalized_pgl2()) == 1320
    assert len(stabilizer) == 20
    assert {
        tuple(matrix) for matrix in expected["projective_parameter_stabilizer"]["matrices"]
    } == set(stabilizer)

    # The deleted-coordinate description independently proves the two exact
    # sequences: the full degree-six evaluation has rows for exponents
    # 0,...,6, and C_Gamma deletes precisely rows 2 and 4. Orthogonal
    # complements reverse the inclusion; R_6^perp=R_4 on all q+1 points.
    assert set(range(7)) - set(EXPONENTS) == {2, 4}
    for left in range(5):
        for right in range(7):
            exponent = left + right
            finite_sum = sum(pow(t, exponent, Q) for t in range(Q)) % Q
            infinity = int(left == 4 and right == 6)
            assert (finite_sum + infinity) % Q == 0

    print("PASS: independent projective-word, determinant, and PGL2 replay")
    print("PASS: deleted weights {2,4} give the dual codimension-two sequences")


if __name__ == "__main__":
    main()
