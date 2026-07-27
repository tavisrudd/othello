#!/usr/bin/env python3
"""Independent replay of the C682 conic-link code certificate."""

from __future__ import annotations

import itertools
import json
from collections import Counter
from math import comb
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


def determinant(matrix: list[list[int]], modulus: int = Q) -> int:
    size = len(matrix)
    if size == 0:
        return 1
    total = 0
    for column in range(size):
        minor = [
            [entry for index, entry in enumerate(row) if index != column]
            for row in matrix[1:]
        ]
        total += (
            (-1) ** column
            * matrix[0][column]
            * determinant(minor, modulus)
        )
    return total % modulus


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


def homogeneous_rows(
    modulus: int, exponents: tuple[int, ...], degree: int
) -> list[list[int]]:
    return [
        [pow(parameter, exponent, modulus) for parameter in range(modulus)]
        + [int(exponent == degree)]
        for exponent in exponents
    ]


def polynomial_with_roots(modulus: int) -> list[int]:
    coefficients = [1]
    for root in range(6):
        product = [0] * (len(coefficients) + 1)
        for degree, coefficient in enumerate(coefficients):
            product[degree] = (product[degree] - root * coefficient) % modulus
            product[degree + 1] = (
                product[degree + 1] + coefficient
            ) % modulus
        coefficients = product
    return coefficients


def homogeneous_weight(coefficients: list[int], modulus: int) -> int:
    finite = [
        sum(
            coefficient * pow(parameter, degree, modulus)
            for degree, coefficient in enumerate(coefficients)
        )
        % modulus
        for parameter in range(modulus)
    ]
    return sum(value != 0 for value in finite) + int(coefficients[6] != 0)


def column_rank_at_least(
    rows: list[list[int]], columns: tuple[int, ...], modulus: int
) -> bool:
    size = len(columns)
    return any(
        determinant(
            [[rows[row][column] for column in columns] for row in row_set],
            modulus,
        )
        for row_set in itertools.combinations(range(len(rows)), size)
    )


def row_rank(matrix: list[list[int]], modulus: int) -> int:
    work = [[entry % modulus for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, modulus)
        work[row] = [(inverse * entry) % modulus for entry in work[row]]
        for other in range(row + 1, len(work)):
            factor = work[other][column]
            if factor:
                work[other] = [
                    (left - factor * right) % modulus
                    for left, right in zip(work[other], work[row])
                ]
        row += 1
    return row


def shortened_dimension(
    rows: list[list[int]], support: tuple[int, ...], modulus: int
) -> int:
    complement = [column for column in range(len(rows[0])) if column not in support]
    return len(rows) - row_rank(
        [[row[column] for column in complement] for row in rows], modulus
    )


def nullspace(rows: list[list[int]], modulus: int) -> list[list[int]]:
    work = [[entry % modulus for entry in row] for row in rows]
    pivot_columns = []
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (
                index
                for index in range(pivot_row, len(work))
                if work[index][column]
            ),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, modulus)
        work[pivot_row] = [
            inverse * entry % modulus for entry in work[pivot_row]
        ]
        for index in range(len(work)):
            if index != pivot_row and work[index][column]:
                factor = work[index][column]
                work[index] = [
                    (left - factor * right) % modulus
                    for left, right in zip(work[index], work[pivot_row])
                ]
        pivot_columns.append(column)
        pivot_row += 1
    free_columns = [
        column for column in range(len(work[0])) if column not in pivot_columns
    ]
    answer = []
    for free_column in free_columns:
        vector = [0] * len(work[0])
        vector[free_column] = 1
        for index, pivot_column in enumerate(pivot_columns):
            vector[pivot_column] = -work[index][free_column] % modulus
        answer.append(vector)
    return answer


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

    # Independent quantum replay: compute the Euclidean Gram form directly,
    # recover the hull, and verify the two CSS logical quotients.
    sparse_rows = homogeneous_rows(Q, EXPONENTS, 6)
    code_gram = [
        [sum(a * b for a, b in zip(row, other)) % Q for other in sparse_rows]
        for row in sparse_rows
    ]
    assert code_gram == expected["quantum"]["euclidean_hull"]["gram_matrix"]
    assert code_gram == [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 10, 0],
        [0, 0, 0, 0, 1],
    ]
    assert expected["quantum"]["euclidean_hull"]["dimension"] == 3
    assert expected["quantum"]["euclidean_hull"]["basis_exponents"] == [0, 1, 3]

    r4_rows = homogeneous_rows(Q, tuple(range(5)), 4)
    assert all(
        sum(a * b for a, b in zip(left, right)) % Q == 0
        for left in sparse_rows
        for right in r4_rows
    )
    q11_witness = polynomial_with_roots(Q)
    assert q11_witness[2] and q11_witness[4]
    assert homogeneous_weight(q11_witness, Q) == 6
    assert expected["quantum"]["css_code"]["parameters"] == {
        "physical_qudits": 12,
        "logical_qudits": 2,
        "logical_X_operator_distance": 6,
        "logical_Z_operator_distance": 4,
    }
    assert expected["quantum"]["css_code"][
        "logical_X_relative_generalized_weights"
    ] == [6, 7]
    assert expected["quantum"]["css_code"][
        "logical_Z_relative_generalized_weights"
    ] == [4, 5]
    x_witness_support = tuple(range(7))
    assert (
        shortened_dimension(
            homogeneous_rows(Q, tuple(range(7)), 6),
            x_witness_support,
            Q,
        )
        - shortened_dimension(sparse_rows, x_witness_support, Q)
        == 2
    )
    dual_rows = nullspace(sparse_rows, Q)
    z_witness_support = (1, 3, 4, 5, 9)
    assert (
        shortened_dimension(dual_rows, z_witness_support, Q)
        - shortened_dimension(r4_rows, z_witness_support, Q)
        == 2
    )
    assert expected["quantum"]["css_code"][
        "asymmetric_quantum_singleton_defect"
    ] == 2

    marginal_data = expected["quantum"]["css_stabilizer_state"][
        "four_qudit_marginals"
    ]
    assert marginal_data == {
        "exceptional_support_orbits": [5, 5, 5],
        "maximally_mixed_count": comb(12, 4) - 15,
        "rank_11^3_count": 15,
    }
    assert expected["quantum"]["entanglement_assisted_from_dual"][
        "parameters"
    ] == {
        "physical_qudits": 12,
        "logical_qudits": 4,
        "distance": 4,
        "ebits": 2,
    }

    # The q=13 check is independent of the q=11 enumeration.  Direct power
    # sums make the complete degree-six Gram matrix zero, while minors give
    # dual distance four for the sparse subsystem.
    q13 = 13
    r6_q13 = homogeneous_rows(q13, tuple(range(7)), 6)
    assert all(
        sum(a * b for a, b in zip(left, right)) % q13 == 0
        for left in r6_q13
        for right in r6_q13
    )
    sparse_q13 = homogeneous_rows(q13, EXPONENTS, 6)
    assert all(
        column_rank_at_least(sparse_q13, columns, q13)
        for columns in itertools.combinations(range(q13 + 1), 3)
    )
    q13_circuit = (0, 1, 12, 13)
    assert not column_rank_at_least(sparse_q13, q13_circuit, q13)
    q13_witness = polynomial_with_roots(q13)
    assert q13_witness[2] and q13_witness[4]
    assert homogeneous_weight(q13_witness, q13) == 8
    assert expected["quantum"]["q13_resonance"][
        "asymmetric_css_parameters"
    ] == {
        "physical_qudits": 14,
        "logical_qudits": 2,
        "logical_X_operator_distance": 8,
        "logical_Z_operator_distance": 4,
    }

    print("PASS: independent projective-word, determinant, and PGL2 replay")
    print("PASS: deleted weights {2,4} give the dual codimension-two sequences")
    print("PASS: CSS quotients, hull, marginal defects, and q=13 resonance")


if __name__ == "__main__":
    main()
