#!/usr/bin/env python3
"""Exact certificate for the C682 icosahedral transvectant bridge."""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c682-transvectant-bridge.json"


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


def rref(matrix: list[list[int]]) -> tuple[int, list[int], list[list[int]]]:
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


def transvectant(
    left: dict[tuple[int, int], int],
    right: dict[tuple[int, int], int],
    order: int,
) -> dict[tuple[int, int], int]:
    output: dict[tuple[int, int], int] = {}
    for index in range(order + 1):
        for (left_x, left_y), left_coefficient in left.items():
            left_derivative = (
                left_coefficient
                * falling(left_x, order - index)
                * falling(left_y, index)
            )
            if not left_derivative:
                continue
            for (right_x, right_y), right_coefficient in right.items():
                right_derivative = (
                    right_coefficient
                    * falling(right_x, index)
                    * falling(right_y, order - index)
                )
                if not right_derivative:
                    continue
                degree = (
                    left_x - (order - index) + right_x - index,
                    left_y - index + right_y - (order - index),
                )
                output[degree] = output.get(degree, 0) + (
                    (-1) ** index
                    * math.comb(order, index)
                    * left_derivative
                    * right_derivative
                )
    return {degree: coefficient for degree, coefficient in output.items() if coefficient}


def third_transvectant_matrix(
    dodecic: list[tuple[int, int, int]],
) -> list[list[int]]:
    matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        px, py = 6 - column, column
        for index in range(4):
            left = (
                (-1) ** index
                * math.comb(3, index)
                * falling(px, 3 - index)
                * falling(py, index)
            )
            if not left:
                continue
            for coefficient, fx, fy in dodecic:
                right = (
                    coefficient
                    * falling(fx, index)
                    * falling(fy, 3 - index)
                )
                if not right:
                    continue
                output_y_degree = py - index + fy - (3 - index)
                matrix[output_y_degree][column] += left * right
    return matrix


def certificate() -> dict[str, object]:
    # Klein's invariant binary dodecic:
    # Phi_12 = X Y (X^10 + 11 X^5 Y^5 - Y^10).
    phi = [(1, 11, 1), (11, 6, 6), (-1, 1, 11)]
    # Columns use the binary-sextic basis X^(6-k)Y^k.  Rows use
    # X^(12-j)Y^j.  The standard third transvectant is
    # sum_i (-1)^i binom(3,i) d_X^(3-i)d_Y^i(p)
    #                         d_X^i d_Y^(3-i)(Phi_12).
    matrix = third_transvectant_matrix(phi)

    divisor = math.gcd(*(entry for row in matrix for entry in row))
    normalized = [[entry // divisor for entry in row] for row in matrix]
    rank, pivots, kernel = rref(normalized)
    assert divisor == 2640
    assert rank == 4
    assert pivots == [0, 1, 2, 4]
    assert kernel == [
        [0, 0, 0, 1, 0, 0, 0],
        [1, 0, 0, 0, 0, 3, 0],
        [0, 3, 0, 0, 0, 0, -1],
    ]
    kernel_forms = [
        {
            (6 - index, index): coefficient
            for index, coefficient in enumerate(vector)
            if coefficient
        }
        for vector in kernel
    ]
    isotropy = [
        {
            "pair": [left, right],
            "fifth_transvectant": [
                {
                    "coefficient": coefficient,
                    "x_degree": degree[0],
                    "y_degree": degree[1],
                }
                for degree, coefficient in sorted(
                    transvectant(kernel_forms[left], kernel_forms[right], 5).items()
                )
            ],
        }
        for left in range(3)
        for right in range(left, 3)
    ]
    assert all(not row["fifth_transvectant"] for row in isotropy)

    # Linearize rank <= 4 at Phi_12.  A tangent direction delta satisfies
    # delta(M)(ker M) subset im(M), equivalently every left-kernel vector
    # annihilates delta(M) on every kernel vector.
    _, _, left_kernel = rref([list(row) for row in zip(*normalized)])
    direction_matrices = [
        third_transvectant_matrix([(1, 12 - index, index)])
        for index in range(13)
    ]
    tangent_constraints = [
        [
            sum(
                left_vector[row]
                * direction_matrices[direction][row][column]
                * kernel_vector[column]
                for row in range(13)
                for column in range(7)
            )
            for direction in range(13)
        ]
        for left_vector in left_kernel
        for kernel_vector in kernel
    ]
    tangent_constraint_rank, _, tangent_kernel = rref(tangent_constraints)
    assert len(left_kernel) == 9
    assert tangent_constraint_rank == 9
    assert len(tangent_kernel) == 4
    return {
        "schema": "c682-transvectant-bridge-v1",
        "ground_ring": "Z",
        "klein_dodecic_terms": [
            {"coefficient": coefficient, "x_degree": x_degree, "y_degree": y_degree}
            for coefficient, x_degree, y_degree in phi
        ],
        "transvectant_order": 3,
        "domain_basis": [f"x^{6-k} y^{k}" for k in range(7)],
        "codomain_basis": [f"x^{12-k} y^{k}" for k in range(13)],
        "common_matrix_divisor": divisor,
        "normalized_matrix_rows": normalized,
        "rank": rank,
        "pivot_columns_zero_based": pivots,
        "kernel_basis": kernel,
        "kernel_polynomials": [
            "x^3 y^3",
            "x^6 + 3 x y^5",
            "3 x^5 y - y^6",
        ],
        "kernel_fifth_transvectant_isotropy": isotropy,
        "rank_locus_tangent": {
            "ambient_affine_dimension": 13,
            "left_kernel_dimension": len(left_kernel),
            "linearized_constraint_count": len(tangent_constraints),
            "linearized_constraint_rank": tangent_constraint_rank,
            "affine_tangent_dimension": len(tangent_kernel),
            "projective_tangent_dimension": len(tangent_kernel) - 1,
        },
    }


def serialized() -> str:
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = serialized()
    if args.write:
        CERTIFICATE.write_text(expected, encoding="utf-8")
        print(f"wrote {CERTIFICATE.name}")
        return
    if not CERTIFICATE.exists() or CERTIFICATE.read_text(encoding="utf-8") != expected:
        raise SystemExit("transvectant certificate is missing or stale")
    print("C682 transvectant certificate: OK (rank 4, kernel dimension 3)")


if __name__ == "__main__":
    main()
