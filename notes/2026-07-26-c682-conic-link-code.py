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


def generator_over(
    field: int,
    exponents: tuple[int, ...] = EXPONENTS,
    degree: int = 6,
) -> list[list[int]]:
    """Homogeneous evaluation rows for a fixed-degree linear system."""
    return [
        [pow(t, exponent, field) for t in range(field)]
        + [int(exponent == degree)]
        for exponent in exponents
    ]


def generator() -> list[list[int]]:
    """Rows for 1,t,t^3,t^5,t^6 over F_11."""
    return generator_over(Q)


def rank_mod(matrix: list[list[int]], modulus: int = Q) -> int:
    if not matrix or not matrix[0]:
        return 0
    work = [[entry % modulus for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, modulus)
        work[row] = [(inverse * entry) % modulus for entry in work[row]]
        for other in range(len(work)):
            if other != row and work[other][column]:
                factor = work[other][column]
                work[other] = [
                    (left - factor * right) % modulus
                    for left, right in zip(work[other], work[row])
                ]
        row += 1
    return row


def nullspace_mod(
    matrix: list[list[int]], modulus: int = Q
) -> list[list[int]]:
    work = [[entry % modulus for entry in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, modulus)
        work[row] = [(inverse * entry) % modulus for entry in work[row]]
        for other in range(len(work)):
            if other != row and work[other][column]:
                factor = work[other][column]
                work[other] = [
                    (left - factor * right) % modulus
                    for left, right in zip(work[other], work[row])
                ]
        pivots.append(column)
        row += 1
    free = [column for column in range(len(work[0])) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * len(work[0])
        vector[free_column] = 1
        for pivot_row, pivot_column in enumerate(pivots):
            vector[pivot_column] = -work[pivot_row][free_column] % modulus
        basis.append(vector)
    return basis


def shortened_dimension(matrix: list[list[int]], support: set[int]) -> int:
    complement = [column for column in range(N) if column not in support]
    restricted = [[row[column] for column in complement] for row in matrix]
    return len(matrix) - rank_mod(restricted)


def relative_generalized_weights(
    larger: list[list[int]], smaller: list[list[int]]
) -> list[int]:
    quotient_dimension = len(larger) - len(smaller)
    answer = []
    for order in range(1, quotient_dimension + 1):
        found = None
        for size in range(N + 1):
            for support_tuple in itertools.combinations(range(N), size):
                support = set(support_tuple)
                relative_dimension = (
                    shortened_dimension(larger, support)
                    - shortened_dimension(smaller, support)
                )
                if relative_dimension >= order:
                    found = size
                    break
            if found is not None:
                break
        assert found is not None
        answer.append(found)
    return answer


def gram(matrix: list[list[int]], modulus: int) -> list[list[int]]:
    return [
        [sum(left * right for left, right in zip(row, other)) % modulus
         for other in matrix]
        for row in matrix
    ]


def polynomial_with_roots(roots: range, modulus: int) -> list[int]:
    """Low-to-high coefficients of the monic polynomial with given roots."""
    coefficients = [1]
    for root in roots:
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

    # Quantum consequences of the two exact sequences.  The R_4 check
    # matrix uses all exponents 0,...,4; it is orthogonal to the full R_6
    # matrix and hence to C_Gamma.
    r4_matrix = generator_over(Q, tuple(range(5)), degree=4)
    r6_matrix = generator_over(Q, tuple(range(7)))
    assert rank_mod(r4_matrix) == 5
    assert rank_mod(r6_matrix) == 7
    assert all(
        sum(left * right for left, right in zip(c_row, r_row)) % Q == 0
        for c_row in matrix
        for r_row in r4_matrix
    )
    dual_matrix = nullspace_mod(matrix)
    assert len(dual_matrix) == 7
    logical_x_relative_weights = relative_generalized_weights(r6_matrix, matrix)
    logical_z_relative_weights = relative_generalized_weights(
        dual_matrix, r4_matrix
    )
    assert logical_x_relative_weights == [6, 7]
    assert logical_z_relative_weights == [4, 5]

    code_gram = gram(matrix, Q)
    assert code_gram == [
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0],
        [0, 0, 0, 10, 0],
        [0, 0, 0, 0, 1],
    ]
    assert rank_mod(code_gram) == 2
    assert len(matrix) - rank_mod(code_gram) == 3

    q11_witness = polynomial_with_roots(range(6), Q)
    assert q11_witness == [0, 1, 10, 6, 8, 7, 1]
    assert q11_witness[2] and q11_witness[4]
    assert homogeneous_weight(q11_witness, Q) == 6

    # At q=13 the complete degree-six code is self-dual: the only possible
    # nonzero power sum is in degree 12, where the finite contribution -1
    # cancels the homogeneous coordinate at infinity.
    q13 = 13
    c13_matrix = generator_over(q13)
    r6_q13 = generator_over(q13, tuple(range(7)))
    assert rank_mod(c13_matrix, q13) == 5
    assert rank_mod(r6_q13, q13) == 7
    assert gram(r6_q13, q13) == [[0] * 7 for _ in range(7)]

    q13_points: tuple[int | str, ...] = tuple(range(q13)) + ("inf",)
    q13_columns = list(zip(*c13_matrix))
    assert all(
        rank_mod(
            [[q13_columns[column][row] for column in subset] for row in range(5)],
            q13,
        )
        == 3
        for subset in itertools.combinations(range(q13 + 1), 3)
    )
    q13_circuit = (0, 1, 12, 13)
    assert rank_mod(
        [
            [q13_columns[column][row] for column in q13_circuit]
            for row in range(5)
        ],
        q13,
    ) == 3
    q13_witness = polynomial_with_roots(range(6), q13)
    assert q13_witness == [0, 10, 1, 9, 7, 11, 1]
    assert q13_witness[2] and q13_witness[4]
    assert homogeneous_weight(q13_witness, q13) == 8

    return {
        "schema": "c682-conic-link-code-v2",
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
        "quantum": {
            "css_code": {
                "field": 11,
                "parameters": {
                    "physical_qudits": 12,
                    "logical_qudits": 2,
                    "logical_X_operator_distance": 6,
                    "logical_Z_operator_distance": 4,
                },
                "X_check_code": "C_Gamma",
                "Z_check_code": "R_4",
                "logical_X_space": "R_6 / C_Gamma = J_{0,infinity}^{(2)}",
                "logical_Z_space": (
                    "C_Gamma^perp / R_4 = (J_{0,infinity}^{(2)})^dual"
                ),
                "logical_X_relative_generalized_weights": (
                    logical_x_relative_weights
                ),
                "logical_Z_relative_generalized_weights": (
                    logical_z_relative_weights
                ),
                "asymmetric_quantum_singleton_defect": 2,
                "distance_six_witness_coefficients_low_to_high": q11_witness,
            },
            "css_stabilizer_state": {
                "uniformity": 3,
                "four_qudit_marginals": {
                    "maximally_mixed_count": comb(12, 4) - len(circuits),
                    "rank_11^3_count": len(circuits),
                    "exceptional_support_orbits": [5, 5, 5],
                },
                "constraint_support_thresholds": {
                    "X_type": hierarchy,
                    "Z_type": dual_hierarchy,
                },
            },
            "euclidean_hull": {
                "gram_matrix": code_gram,
                "gram_rank": 2,
                "dimension": 3,
                "basis_exponents": [0, 1, 3],
            },
            "entanglement_assisted_from_dual": {
                "parameters": {
                    "physical_qudits": 12,
                    "logical_qudits": 4,
                    "distance": 4,
                    "ebits": 2,
                }
            },
            "q13_resonance": {
                "full_R6_parameters": [14, 7, 8],
                "full_R6_is_self_dual": True,
                "sparse_code_parameters": [14, 5, 8],
                "sparse_dual_parameters": [14, 9, 4],
                "symmetric_css_parameters": [14, 4, 4],
                "asymmetric_css_parameters": {
                    "physical_qudits": 14,
                    "logical_qudits": 2,
                    "logical_X_operator_distance": 8,
                    "logical_Z_operator_distance": 4,
                },
                "four_circuit": [
                    q13_points[index] for index in q13_circuit
                ],
                "distance_eight_witness_coefficients_low_to_high": q13_witness,
            },
        },
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
