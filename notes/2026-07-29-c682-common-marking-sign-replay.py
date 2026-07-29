#!/usr/bin/env python3
"""Independent compact replay of the C682 common-marking sign certificate."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
CERTIFICATE = NOTES / "2026-07-29-c682-common-marking-sign.json"
GOLD = NOTES / "2026-07-29-c682-d5-s3-kernel-incidence.json"
MATES = NOTES / "2026-07-28-c682-maximal-subgroup-mates.json"
PRIME = 11


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_pgl(entries):
    entries = tuple(value % PRIME for value in entries)
    pivot = next(value for value in entries if value)
    inverse = pow(pivot, -1, PRIME)
    return tuple(value * inverse % PRIME for value in entries)


def multiply(left, right):
    a, b, c, d = left
    e, f, g, h = right
    return canonical_pgl(
        (
            a * e + b * g,
            a * f + b * h,
            c * e + d * g,
            c * f + d * h,
        )
    )


def matrix_order(matrix):
    identity = (1, 0, 0, 1)
    power = identity
    for order in range(1, 61):
        power = multiply(power, matrix)
        if power == identity:
            return order
    raise AssertionError("matrix order exceeds 60")


def generate_matrix_group(generators):
    identity = (1, 0, 0, 1)
    seen = {identity}
    queue = [identity]
    for current in queue:
        for generator in generators:
            product = multiply(current, generator)
            if product not in seen:
                seen.add(product)
                queue.append(product)
    return seen


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    gold = json.loads(GOLD.read_text())
    mates = json.loads(MATES.read_text())

    for relative, metadata in certificate["inputs"].items():
        path = REPOSITORY / relative
        assert path.stat().st_size == metadata["bytes"]
        assert sha256(path) == metadata["sha256"]

    finite = certificate["frozen_marking"]["finite"]
    a_matrix = tuple(finite["a_11_pgl_matrix"])
    b_matrix = tuple(finite["b_11_pgl_matrix"])
    assert matrix_order(a_matrix) == 5
    assert matrix_order(b_matrix) == 2
    assert matrix_order(multiply(a_matrix, b_matrix)) == 3
    assert len(generate_matrix_group((a_matrix, b_matrix))) == 60

    trace = (a_matrix[0] + a_matrix[3]) % PRIME
    determinant = (
        a_matrix[0] * a_matrix[3] - a_matrix[1] * a_matrix[2]
    ) % PRIME
    ratio_plus_inverse = (
        trace * trace * pow(determinant, -1, PRIME) - 2
    ) % PRIME
    sqrt_five = (-2 * ratio_plus_inverse - 1) % PRIME
    assert sqrt_five == certificate["frozen_marking"]["sqrt5_mod_11"] == 4
    assert sqrt_five * sqrt_five % PRIME == 5

    matching = certificate["stabilizer_matching"]
    d5_map = matching["D5_golden_index_to_stored_point_index"]
    s3_map = matching["S3_golden_index_to_stored_point_index"]
    d5_order = matching["stored_D5_point_order"]
    s3_order = matching["stored_S3_point_order"]
    assert sorted(d5_map) == sorted(d5_order)
    assert sorted(s3_map) == sorted(s3_order)

    plus = gold["incidence"]["lambda_plus_incidence"]
    reordered = [
        [
            plus[d5_map.index(d5_point)][s3_map.index(s3_point)]
            for s3_point in s3_order
        ]
        for d5_point in d5_order
    ]
    stored = mates["intrinsic_D5_S3_incidence"][
        "kernel_intersection_dimension_matrix"
    ]
    assert reordered == stored == matching["stored_kernel_incidence_matrix"]
    assert [sum(row) for row in stored] == [5] * 6
    assert [
        sum(stored[row][column] for row in range(6))
        for column in range(10)
    ] == [3] * 10
    assert [[1 - value for value in row] for row in reordered] != stored

    divided_scale = 2208 * pow(820125 % PRIME, -1, PRIME) % PRIME
    assert divided_scale * sqrt_five % PRIME == 6
    assert -divided_scale * sqrt_five % PRIME == 5
    assert certificate["sign_conclusion"]["stored_matrix_fibre"] == "lambda_plus"
    print("C682 common-marking sign replay: ok (stored = lambda_plus)")


if __name__ == "__main__":
    main()
