#!/usr/bin/env python3
"""Exact certificate for the C682 transvectant inverse theorem."""

from __future__ import annotations

import argparse
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c682-transvectant-inverse.json"


def falling(n: int, r: int) -> int:
    if n < r:
        return 0
    return math.factorial(n) // math.factorial(n - r)


def primitive(vector: list[Fraction]) -> list[int]:
    denominator = math.lcm(*(entry.denominator for entry in vector))
    values = [int(entry * denominator) for entry in vector]
    divisor = math.gcd(*values)
    values = [entry // divisor for entry in values]
    first = next(entry for entry in values if entry)
    return values if first > 0 else [-entry for entry in values]


def rref(
    matrix: list[list[int | Fraction]],
) -> tuple[int, list[int], list[list[int]]]:
    work = [[Fraction(entry) for entry in row] for row in matrix]
    row = 0
    pivots: list[int] = []
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = work[row][column]
        work[row] = [entry / scale for entry in work[row]]
        for index in range(len(work)):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                work[index][j] - scale * work[row][j]
                for j in range(len(work[index]))
            ]
        pivots.append(column)
        row += 1

    free = [column for column in range(len(work[0])) if column not in pivots]
    kernel: list[list[int]] = []
    for column in free:
        vector = [Fraction(0) for _ in range(len(work[0]))]
        vector[column] = 1
        for index, pivot in enumerate(pivots):
            vector[pivot] = -work[index][column]
        kernel.append(primitive(vector))
    return row, pivots, kernel


def third_matrix(dodecic: list[int]) -> list[list[int]]:
    matrix = [[0] * 7 for _ in range(13)]
    for output_y in range(13):
        for input_y in range(7):
            total = 0
            for index in range(4):
                left = (
                    (-1) ** index
                    * math.comb(3, index)
                    * falling(6 - input_y, 3 - index)
                    * falling(input_y, index)
                )
                right = (
                    dodecic[output_y - input_y + 3]
                    * falling(
                        12 - (output_y - input_y + 3),
                        index,
                    )
                    * falling(output_y - input_y + 3, 3 - index)
                    if 0 <= output_y - input_y + 3 <= 12
                    else 0
                )
                total += left * right
            matrix[output_y][input_y] = total
    return matrix


def fifth_pair(left: list[Fraction], right: list[Fraction]) -> list[Fraction]:
    output = [Fraction(0), Fraction(0), Fraction(0)]
    for left_y, left_coefficient in enumerate(left):
        for right_y, right_coefficient in enumerate(right):
            for index in range(6):
                output_y = left_y - index + right_y - (5 - index)
                if not 0 <= output_y <= 2:
                    continue
                output[output_y] += (
                    (-1) ** index
                    * math.comb(5, index)
                    * left_coefficient
                    * falling(6 - left_y, 5 - index)
                    * falling(left_y, index)
                    * right_coefficient
                    * falling(6 - right_y, index)
                    * falling(right_y, 5 - index)
                )
    return output


def transpose(matrix: list[list[int | Fraction]]) -> list[list[int | Fraction]]:
    return [list(column) for column in zip(*matrix)]


def rank_modulo(matrix: list[list[int]], prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [(entry * inverse) % prime for entry in work[row]]
        for index in range(row + 1, len(work)):
            scale = work[index][column]
            work[index] = [
                (work[index][j] - scale * work[row][j]) % prime
                for j in range(len(work[index]))
            ]
        row += 1
    return row


def mat_vec(
    matrix: list[list[int | Fraction]],
    vector: list[int | Fraction],
) -> list[Fraction]:
    return [
        sum((Fraction(entry) * Fraction(value) for entry, value in zip(row, vector)), Fraction(0))
        for row in matrix
    ]


def annihilator_data(
    plane: list[list[int]],
    direction_matrices: list[list[list[int]]],
) -> tuple[int, list[list[int]]]:
    equations = []
    for vector in plane:
        for output in range(13):
            equations.append(
                [
                    sum(
                        direction_matrices[index][output][column] * vector[column]
                        for column in range(7)
                    )
                    for index in range(13)
                ]
            )
    rank, _, kernel = rref(equations)
    return rank, kernel


def determinant3(matrix: list[list[int | Fraction]]) -> Fraction:
    return (
        matrix[0][0]
        * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1]
        * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2]
        * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    )


def inverse3(matrix: list[list[int | Fraction]]) -> list[list[Fraction]]:
    work = [
        [Fraction(entry) for entry in row]
        + [Fraction(int(row_index == column)) for column in range(3)]
        for row_index, row in enumerate(matrix)
    ]
    for column in range(3):
        pivot = next(index for index in range(column, 3) if work[index][column])
        work[column], work[pivot] = work[pivot], work[column]
        scale = work[column][column]
        work[column] = [entry / scale for entry in work[column]]
        for index in range(3):
            if index == column:
                continue
            scale = work[index][column]
            work[index] = [
                work[index][j] - scale * work[column][j] for j in range(6)
            ]
    return [row[3:] for row in work]


def plane_chart(
    plane: list[list[int]],
) -> tuple[list[list[Fraction]], tuple[int, int, int], list[int]]:
    chart_columns = next(
        columns
        for columns in itertools.combinations(range(7), 3)
        if determinant3(
            [[plane[row][columns[column]] for column in range(3)] for row in range(3)]
        )
    )
    minor = [
        [plane[row][chart_columns[column]] for column in range(3)]
        for row in range(3)
    ]
    inverse = inverse3(minor)
    normalized = [
        [
            sum(
                inverse[row][middle] * plane[middle][column]
                for middle in range(3)
            )
            for column in range(7)
        ]
        for row in range(3)
    ]
    complement = [column for column in range(7) if column not in chart_columns]
    return normalized, chart_columns, complement


def rank_tangent_dimension(
    matrix: list[list[int]],
    direction_matrices: list[list[list[int]]],
) -> int:
    _, _, right_kernel = rref(matrix)
    _, _, left_kernel = rref(transpose(matrix))
    equations = []
    for left in left_kernel:
        for right in right_kernel:
            equations.append(
                [
                    sum(
                        left[output]
                        * sum(
                            direction_matrices[index][output][column] * right[column]
                            for column in range(7)
                        )
                        for output in range(13)
                    )
                    for index in range(13)
                ]
            )
    rank, _, _ = rref(equations)
    return 13 - rank


def incidence_tangent_data(
    dodecic: list[int],
    plane: list[list[int]],
    direction_matrices: list[list[list[int]]],
) -> dict[str, int | list[int]]:
    normalized, chart_columns, complement = plane_chart(plane)
    matrix = third_matrix(dodecic)
    equations: list[list[Fraction]] = []

    # Linearization of T_I(U)=0 in 13 dodecic and 12 Grassmann-chart variables.
    for plane_index, vector in enumerate(normalized):
        for output in range(13):
            row = [
                sum(
                    Fraction(direction_matrices[index][output][column]) * vector[column]
                    for column in range(7)
                )
                for index in range(13)
            ] + [Fraction(0)] * 12
            for local_column, column in enumerate(complement):
                row[13 + 4 * plane_index + local_column] = matrix[output][column]
            equations.append(row)

    # Linearization of the three pairwise fifth-transvectant isotropy equations.
    for left in range(3):
        for right in range(left + 1, 3):
            for output in range(3):
                row = [Fraction(0)] * 25
                for local_column, column in enumerate(complement):
                    direction = [Fraction(0)] * 7
                    direction[column] = 1
                    row[13 + 4 * left + local_column] += fifth_pair(
                        direction, normalized[right]
                    )[output]
                    row[13 + 4 * right + local_column] += fifth_pair(
                        normalized[left], direction
                    )[output]
                equations.append(row)

    constraint_rank, _, tangent_kernel = rref(equations)
    projected = [vector[:13] for vector in tangent_kernel]
    projected_rank, _, _ = rref(transpose(projected))
    return {
        "chart_columns": list(chart_columns),
        "constraint_rank": constraint_rank,
        "affine_tangent_dimension": 25 - constraint_rank,
        "dodecic_projection_dimension": projected_rank,
    }


def certificate() -> dict[str, object]:
    directions = [
        third_matrix([int(index == basis) for index in range(13)])
        for basis in range(13)
    ]
    representatives = [
        {
            "name": "open_icosahedral_orbit",
            "dodecic": [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0],
            "expected_plane": [
                [0, 0, 0, 1, 0, 0, 0],
                [1, 0, 0, 0, 0, 3, 0],
                [0, 3, 0, 0, 0, 0, -1],
            ],
        },
        {
            "name": "two_dimensional_boundary_orbit",
            "dodecic": [0, 1] + [0] * 11,
            "expected_plane": [
                [1, 0, 0, 0, 0, 0, 0],
                [0, 1, 0, 0, 0, 0, 0],
                [0, 0, 0, 1, 0, 0, 0],
            ],
        },
        {
            "name": "one_dimensional_closed_orbit",
            "dodecic": [1] + [0] * 12,
            "expected_plane": [
                [1, 0, 0, 0, 0, 0, 0],
                [0, 1, 0, 0, 0, 0, 0],
                [0, 0, 1, 0, 0, 0, 0],
            ],
        },
    ]

    rows = []
    for representative in representatives:
        dodecic = representative["dodecic"]
        expected_plane = representative["expected_plane"]
        matrix = third_matrix(dodecic)
        transvectant_rank, _, plane = rref(matrix)
        assert transvectant_rank == 4
        assert plane == expected_plane
        assert all(
            not any(fifth_pair(plane[left], plane[right]))
            for left in range(3)
            for right in range(left + 1, 3)
        )

        annihilator_rank, annihilator_kernel = annihilator_data(plane, directions)
        assert annihilator_rank == 12
        assert annihilator_kernel == [primitive([Fraction(value) for value in dodecic])]

        tangent = incidence_tangent_data(dodecic, plane, directions)
        assert tangent["constraint_rank"] == 21
        assert tangent["affine_tangent_dimension"] == 4
        assert tangent["dodecic_projection_dimension"] == 4

        rows.append(
            {
                "name": representative["name"],
                "dodecic": dodecic,
                "transvectant_rank": transvectant_rank,
                "kernel_basis": plane,
                "fifth_transvectant_isotropic": True,
                "annihilator_equation_rank": annihilator_rank,
                "annihilator_kernel": annihilator_kernel,
                "rank_locus_affine_tangent_dimension": rank_tangent_dimension(
                    matrix, directions
                ),
                "rank_plus_isotropy_incidence_tangent": tangent,
            }
        )

    assert [
        row["rank_locus_affine_tangent_dimension"] for row in rows
    ] == [4, 4, 5]
    tensor_content = math.gcd(
        *(
            abs(entry)
            for matrix in directions
            for row in matrix
            for entry in row
        )
    )
    assert tensor_content == 240
    primitive_directions = [
        [[entry // tensor_content for entry in row] for row in matrix]
        for matrix in directions
    ]
    prime_audit = {}
    for prime in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]:
        prime_rows = []
        for representative in representatives:
            form = representative["dodecic"]
            plane = representative["expected_plane"]
            matrix = [
                [
                    sum(
                        form[index] * primitive_directions[index][output][column]
                        for index in range(13)
                    )
                    for column in range(7)
                ]
                for output in range(13)
            ]
            equations = [
                [
                    sum(
                        primitive_directions[index][output][column] * vector[column]
                        for column in range(7)
                    )
                    for index in range(13)
                ]
                for vector in plane
                for output in range(13)
            ]
            prime_rows.append(
                {
                    "transvectant_rank": rank_modulo(matrix, prime),
                    "annihilator_equation_rank": rank_modulo(equations, prime),
                }
            )
        prime_audit[str(prime)] = prime_rows
    assert [
        [
            (row["transvectant_rank"], row["annihilator_equation_rank"])
            for row in prime_audit[str(prime)]
        ]
        for prime in [2, 3, 5, 7, 11, 13]
    ] == [
        [(4, 12), (2, 10), (1, 9)],
        [(4, 0), (2, 4), (0, 8)],
        [(2, 10), (2, 10), (2, 10)],
        [(4, 12), (4, 11), (4, 11)],
        [(0, 9), (0, 9), (0, 9)],
        [(4, 12), (4, 12), (4, 12)],
    ]
    assert all(
        all(
            row["transvectant_rank"] == 4
            and row["annihilator_equation_rank"] == 12
            for row in prime_audit[str(prime)]
        )
        for prime in [13, 17, 19, 23, 29, 31]
    )
    return {
        "schema": "c682-transvectant-inverse-v1",
        "field": "Q",
        "binary_form_basis": {
            "Sym6": ["X^(6-i)Y^i", "0<=i<=6"],
            "Sym12": ["X^(12-i)Y^i", "0<=i<=12"],
        },
        "transvectant_order": 3,
        "kernel_isotropy_transvectant_order": 5,
        "orbit_representatives": rows,
        "proved_by_orbit_reduction": {
            "mukai_umemura_orbit_dimensions": [3, 2, 1],
            "annihilator_kernel_dimension_on_each_orbit": [1, 1, 1],
            "rank_plus_isotropy_projective_tangent_dimensions": [3, 3, 3],
        },
        "primitive_universal_tensor": {
            "ordinary_derivative_content": tensor_content,
            "bounded_prime_audit": prime_audit,
        },
        "trust_boundary": [
            "Exact rational arithmetic certifies the three orbit representatives.",
            "Hitchin's orbit decomposition is a human primary-source input.",
            "The bundle-theoretic global inverse is a human argument, not a finite enumeration.",
            "The certificate does not establish novelty or an integral/positive-characteristic model.",
            "The bounded prime table tests characteristic-zero representatives, not modular orbit classifications.",
        ],
    }


def serialized_certificate() -> bytes:
    return (json.dumps(certificate(), indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized_certificate()
    if args.check:
        if CERTIFICATE.read_bytes() != payload:
            raise SystemExit("certificate mismatch")
        print("PASS: exact transvectant inverse certificate matches")
    else:
        CERTIFICATE.write_bytes(payload)
        print(f"wrote {CERTIFICATE}")


if __name__ == "__main__":
    main()
