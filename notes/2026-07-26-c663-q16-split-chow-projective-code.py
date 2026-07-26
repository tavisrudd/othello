#!/usr/bin/env python3
"""Exact GF(16) projective-code obstruction certificate for C663."""

from __future__ import annotations

import argparse
import itertools
import json
import pathlib
import tempfile

Q = 16
MODULUS = 0x13  # x^4 + x + 1


def mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        b >>= 1
        a <<= 1
        if a & Q:
            a ^= MODULUS
    return out


def inv(a: int) -> int:
    if not a:
        raise ZeroDivisionError
    return next(b for b in range(1, Q) if mul(a, b) == 1)


def power(a: int, exponent: int) -> int:
    out = 1
    while exponent:
        if exponent & 1:
            out = mul(out, a)
        a = mul(a, a)
        exponent >>= 1
    return out


def dot(a: tuple[int, ...], b: tuple[int, ...]) -> int:
    out = 0
    for x, y in zip(a, b):
        out ^= mul(x, y)
    return out


def normalize(point: tuple[int, int, int]) -> tuple[int, int, int]:
    lead = next(coordinate for coordinate in point if coordinate)
    scalar = inv(lead)
    return tuple(mul(scalar, coordinate) for coordinate in point)


def rref(rows: list[tuple[int, ...]]) -> tuple[list[list[int]], list[int]]:
    matrix = [list(row) for row in rows]
    pivots: list[int] = []
    row = 0
    for column in range(len(matrix[0]) if matrix else 0):
        pivot = next((i for i in range(row, len(matrix)) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        scalar = inv(matrix[row][column])
        matrix[row] = [mul(scalar, x) for x in matrix[row]]
        for i in range(len(matrix)):
            if i != row and matrix[i][column]:
                scalar = matrix[i][column]
                matrix[i] = [
                    x ^ mul(scalar, y)
                    for x, y in zip(matrix[i], matrix[row])
                ]
        pivots.append(column)
        row += 1
        if row == len(matrix):
            break
    return matrix, pivots


def rank(rows: list[tuple[int, ...]]) -> int:
    return len(rref(rows)[1])


def kernel_vector(rows: list[tuple[int, ...]]) -> tuple[int, ...]:
    matrix, pivots = rref(rows)
    width = len(rows[0])
    free = [column for column in range(width) if column not in pivots]
    assert len(free) == 1
    vector = [0] * width
    vector[free[0]] = 1
    for i, pivot in enumerate(pivots):
        vector[pivot] = matrix[i][free[0]]
    return tuple(vector)


POINTS = tuple(
    [(0, 0, 1)]
    + [(0, 1, z) for z in range(Q)]
    + [(1, y, z) for y in range(Q) for z in range(Q)]
)
POINT_INDEX = {point: i for i, point in enumerate(POINTS)}


def exponents(degree: int) -> tuple[tuple[int, int, int], ...]:
    return tuple(
        (a, b, degree - a - b)
        for a in range(degree + 1)
        for b in range(degree - a + 1)
    )


def monomial(point: tuple[int, int, int], exponent: tuple[int, int, int]) -> int:
    return mul(
        mul(power(point[0], exponent[0]), power(point[1], exponent[1])),
        power(point[2], exponent[2]),
    )


def evaluation_rows(degree: int) -> list[tuple[int, ...]]:
    return [
        tuple(monomial(point, exponent) for point in POINTS)
        for exponent in exponents(degree)
    ]


def on_conic(point: tuple[int, int, int]) -> bool:
    x, y, z = point
    return mul(x, z) ^ mul(y, y) == 0


def build_certificate() -> dict:
    degree_two = evaluation_rows(2)
    degree_twenty_eight = evaluation_rows(28)
    conic = tuple(point for point in POINTS if on_conic(point))
    chosen = tuple(normalize((mul(t, t), t, 1)) for t in range(6))
    chosen_indices = tuple(POINT_INDEX[point] for point in chosen)
    chosen_quadrics = [
        tuple(row[index] for index in chosen_indices)
        for row in degree_two
    ]
    weights = kernel_vector(chosen_quadrics)
    word = tuple(
        weights[chosen_indices.index(i)] if i in chosen_indices else 0
        for i in range(len(POINTS))
    )
    quadratic_rank = rank(degree_two)
    high_rank = rank(degree_twenty_eight)
    cross_orthogonal = all(
        dot(low, high) == 0
        for low in degree_two
        for high in degree_twenty_eight
    )
    conic_columns = [
        tuple(row[POINT_INDEX[point]] for row in degree_two)
        for point in conic
    ]
    conic_restriction_rank = rank(conic_columns)
    answer = {
        "chosen_conic_points": [list(point) for point in chosen],
        "chosen_five_point_ranks": sorted(
            {
                rank(
                    [
                        tuple(row[chosen_indices[i]] for i in subset)
                        for row in degree_two
                    ]
                )
                for subset in itertools.combinations(range(6), 5)
            }
        ),
        "chosen_six_point_quadratic_rank": rank(chosen_quadrics),
        "chosen_support_weights": list(weights),
        "conic_point_count": len(conic),
        "conic_supported_subcode_dimension": len(conic) - conic_restriction_rank,
        "conic_quadratic_restriction_rank": conic_restriction_rank,
        "cross_orthogonal": cross_orthogonal,
        "degree_2_code_rank": quadratic_rank,
        "degree_28_code_rank": high_rank,
        "field": "GF(16), polynomial basis modulo x^4+x+1",
        "full_support_on_chosen_six": all(weights),
        "length": len(POINTS),
        "rank_sum": quadratic_rank + high_rank,
        "schema": "c663-projective-code-obstruction-v1",
        "weight_six_word_orthogonal_to_degree_2": all(
            dot(word, row) == 0 for row in degree_two
        ),
    }
    assert answer["chosen_five_point_ranks"] == [5]
    assert answer["chosen_six_point_quadratic_rank"] == 5
    assert answer["full_support_on_chosen_six"]
    assert answer["conic_supported_subcode_dimension"] == 12
    assert answer["cross_orthogonal"]
    assert answer["rank_sum"] == len(POINTS)
    assert answer["weight_six_word_orthogonal_to_degree_2"]
    return answer


def canonical_bytes(answer: dict) -> bytes:
    return (json.dumps(answer, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    default_output = pathlib.Path(__file__).with_suffix(".json")
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=pathlib.Path, default=default_output)
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    content = canonical_bytes(build_certificate())
    if args.write:
        args.output.write_bytes(content)
        return
    with tempfile.TemporaryDirectory() as directory:
        regenerated = pathlib.Path(directory) / args.output.name
        regenerated.write_bytes(content)
        if not args.output.exists() or args.output.read_bytes() != regenerated.read_bytes():
            raise SystemExit(f"certificate mismatch: {args.output}")
    print("PASS")


if __name__ == "__main__":
    main()
