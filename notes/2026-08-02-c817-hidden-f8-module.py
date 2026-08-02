#!/usr/bin/env python3
"""Exact hidden-F8 diagnostic for the q=13 passant association scheme."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


Q = 13
RELATIONS = (0, 1, 3, 9, 10, 12)


def internal_points() -> list[tuple[int, int, int]]:
    squares = {x * x % Q for x in range(1, Q)}
    projective = (
        [(1, y, z) for y in range(Q) for z in range(Q)]
        + [(0, 1, z) for z in range(Q)]
        + [(0, 0, 1)]
    )
    return [point for point in projective if delta(point) not in squares | {0}]


def delta(point: tuple[int, int, int]) -> int:
    x, y, z = point
    return (y * y - x * z) % Q


def rho(first: tuple[int, int, int], second: tuple[int, int, int]) -> int:
    x, y, z = first
    u, v, w = second
    beta = (2 * y * v - x * w - z * u) % Q
    return beta * beta * pow(delta(first) * delta(second), -1, Q) % Q


def relation_matrix(
    points: list[tuple[int, int, int]], value: int
) -> list[int]:
    return [
        sum(
            1 << j
            for j, second in enumerate(points)
            if i != j and rho(first, second) == value
        )
        for i, first in enumerate(points)
    ]


def identity(size: int) -> list[int]:
    return [1 << i for i in range(size)]


def add(*matrices: list[int]) -> list[int]:
    return [
        rows[0] ^ rows[1] if len(rows) == 2 else xor_all(rows)
        for rows in zip(*matrices)
    ]


def xor_all(values: tuple[int, ...]) -> int:
    result = 0
    for value in values:
        result ^= value
    return result


def multiply(first: list[int], second: list[int]) -> list[int]:
    product = []
    for support in first:
        row = 0
        while support:
            bit = support & -support
            row ^= second[bit.bit_length() - 1]
            support ^= bit
        product.append(row)
    return product


def rank_bitset(rows: list[int]) -> int:
    pivots: dict[int, int] = {}
    for original in rows:
        row = original
        while row:
            pivot = row.bit_length() - 1
            if pivot in pivots:
                row ^= pivots[pivot]
            else:
                pivots[pivot] = row
                break
    return len(pivots)


def rank_dense(rows: list[int], width: int) -> int:
    matrix = [[(row >> column) & 1 for column in range(width)] for row in rows]
    pivot_row = 0
    for column in range(width):
        pivot = next(
            (row for row in range(pivot_row, len(matrix)) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        for row in range(len(matrix)):
            if row != pivot_row and matrix[row][column]:
                matrix[row] = [a ^ b for a, b in zip(matrix[row], matrix[pivot_row])]
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return pivot_row


def checked_rank(rows: list[int], width: int) -> int:
    first = rank_bitset(rows)
    second = rank_dense(rows, width)
    assert first == second
    return first


def compute() -> dict[str, object]:
    points = internal_points()
    size = len(points)
    assert size == 78
    matrices = {value: relation_matrix(points, value) for value in RELATIONS}
    assert all(matrix == list_transpose(matrix, size) for matrix in matrices.values())

    one = identity(size)
    a0 = matrices[0]
    b = matrices[9]
    b2 = multiply(b, b)
    b3 = multiply(b2, b)
    b4 = multiply(b2, b2)
    b_plus_one = add(b, one)
    a0_squared = multiply(a0, a0)
    projection_to_k = add(one, a0_squared)

    assert b2 == matrices[10]
    assert b4 == matrices[12]
    assert multiply(a0, b) == [0] * size
    assert a0_squared == add(one, b, b2, b4)
    cubic = add(b3, b2, one)
    assert multiply(b_plus_one, cubic) == a0_squared
    assert cubic == a0_squared
    assert multiply(projection_to_k, projection_to_k) == projection_to_k
    assert multiply(projection_to_k, b) == b
    assert multiply(b, projection_to_k) == b

    powers = {0: projection_to_k, 1: b}
    for exponent in range(2, 8):
        powers[exponent] = multiply(powers[exponent - 1], b)
    assert powers[7] == projection_to_k
    assert add(b, b2, b4) == projection_to_k
    assert add(
        multiply(b, b2), multiply(b, b4), multiply(b2, b4)
    ) == [0] * size
    assert multiply(multiply(b, b2), b4) == projection_to_k
    assert all(
        powers[exponent] == list_transpose(powers[exponent], size)
        for exponent in range(7)
    )
    assert all(row.bit_count() % 2 == 0 for row in projection_to_k)
    assert all(
        add(*[matrix for bit, matrix in zip((1, 2, 4), (projection_to_k, b, b2)) if mask & bit])
        != [0] * size
        for mask in range(1, 8)
    )

    zero = [0] * size
    restrictions = {
        "I": multiply(one, projection_to_k),
        **{
            f"A{value}": multiply(matrices[value], projection_to_k)
            for value in RELATIONS
        },
    }
    assert restrictions == {
        "I": projection_to_k,
        "A0": zero,
        "A1": zero,
        "A3": zero,
        "A9": b,
        "A10": b2,
        "A12": b4,
    }

    ranks = {
        "A0": checked_rank(a0, size),
        "A9": checked_rank(b, size),
        "A10": checked_rank(b2, size),
        "A12": checked_rank(b4, size),
        "B_plus_I": checked_rank(b_plus_one, size),
        "stack_A0_B_plus_I": checked_rank(a0 + b_plus_one, size),
    }
    kernel_dimension = size - ranks["A0"]
    fixed_dimension = size - ranks["stack_A0_B_plus_I"]
    assert ranks == {
        "A0": 42,
        "A9": 36,
        "A10": 36,
        "A12": 36,
        "B_plus_I": 78,
        "stack_A0_B_plus_I": 78,
    }
    assert kernel_dimension == 36
    assert fixed_dimension == 0

    return {
        "schema": "c817-hidden-f8-v1",
        "field": 13,
        "point_count": size,
        "relation_valencies": {
            str(value): matrices[value][0].bit_count() for value in RELATIONS
        },
        "ranks_over_F2": ranks,
        "kernel_A0_dimension_over_F2": kernel_dimension,
        "kernel_A0_intersect_kernel_B_plus_I_dimension": fixed_dimension,
        "kernel_A0_dimension_over_F8": kernel_dimension // 3,
        "modular_Bose_Mesner_action_on_kernel_A0": {
            "I": "1",
            "A0": "0",
            "A1": "0",
            "A3": "0",
            "A9": "alpha",
            "A10": "alpha^2",
            "A12": "alpha^4=1+alpha+alpha^2",
            "alpha_relation": "alpha^3+alpha^2+1=0",
        },
        "verified_projector_identities": [
            "A0^2=I+A9^2+A9^3",
            "e_K=I+A0^2",
            "e_K^2=e_K",
            "A9^7=e_K",
        ],
        "verified_Frobenius_packet_identities": [
            "A9+A10+A12=e_K",
            "A9*A10+A9*A12+A10*A12=0",
            "A9*A10*A12=e_K",
        ],
        "verified_binary_form_properties": [
            "e_K is symmetric of rank 36",
            "every vector in image(e_K)=K has even weight",
            "all F8 scalar operators are self-adjoint",
        ],
        "verified_matrix_identities": [
            "A0^2=I+A9+A10+A12",
            "A0*A9=0",
            "A9^2=A10",
            "A10^2=A12",
            "A12^2=A9",
            "(A9+I)*(A9^3+A9^2+I)=A0^2",
        ],
        "independent_rank_implementations": ["bitset_echelon", "dense_rref"],
    }


def list_transpose(matrix: list[int], size: int) -> list[int]:
    return [
        sum(1 << row for row in range(size) if matrix[row] >> column & 1)
        for column in range(size)
    ]


def canonical_json(result: dict[str, object]) -> str:
    return json.dumps(result, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    rendered = canonical_json(compute())
    if args.write:
        args.write.write_text(rendered, encoding="utf-8")
    elif args.check:
        assert args.check.read_text(encoding="utf-8") == rendered
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
