#!/usr/bin/env python3
"""Independent replay of the C414 Stage-T0 twisted projective Fourier identities."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CERTIFICATE = json.loads((ROOT / "2026-07-20-c414-tautological-fourier-preflight.json").read_text())


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def primitive_generator(prime: int) -> int:
    for candidate in range(2, prime):
        powers = {pow(candidate, exponent, prime) for exponent in range(prime - 1)}
        if len(powers) == prime - 1:
            return candidate
    raise AssertionError


def points_with_last_pivot(prime: int) -> list[tuple[int, int, int]]:
    answer = []
    for x in range(prime):
        for y in range(prime):
            answer.append((x, y, 1))
    for x in range(prime):
        answer.append((x, 1, 0))
    answer.append((1, 0, 0))
    return answer


def root_power_bases(order: int, polynomial: list[int]) -> list[tuple[int, ...]]:
    degree = len(polynomial) - 1
    powers = []
    for exponent in range(order):
        vector = [0] * degree
        if exponent < degree:
            vector[exponent] = 1
        else:
            previous = powers[-1]
            shifted = [0] + list(previous)
            leading = shifted.pop()
            vector = [shifted[index] - leading * polynomial[index] for index in range(degree)]
        powers.append(tuple(vector))
    return powers


def pairing(left: tuple[int, int, int], right: tuple[int, int, int], prime: int) -> int:
    return (left[0] * right[0] + left[1] * right[1] + left[2] * right[2]) % prime


def build_kernel(points, prime, weight, log_table):
    order = prime - 1
    return [
        [None if (value := pairing(target, source, prime)) == 0 else (-weight * log_table[value]) % order
         for source in points]
        for target in points
    ]


def verify_product(left, right, root_bases, scalar):
    size = len(left)
    degree = len(root_bases[0])
    digest = hashlib.sha256()
    for row in range(size):
        for column in range(size):
            result = [0] * degree
            for middle in range(size):
                a = left[row][middle]
                b = right[middle][column]
                if a is None or b is None:
                    continue
                basis = root_bases[(a + b) % len(root_bases)]
                result = [x + y for x, y in zip(result, basis)]
            expected = [0] * degree
            if row == column:
                expected[0] = scalar
            assert result == expected
            digest.update(json.dumps(result, separators=(",", ":")).encode())
            digest.update(b"\n")
    return digest.hexdigest()


def encoded_hash(kernel):
    encoded = [[-1 if exponent is None else exponent for exponent in row] for row in kernel]
    return hashlib.sha256(canonical_bytes(encoded)).hexdigest()


def main() -> None:
    assert CERTIFICATE["schema"] == "c414-tautological-fourier-preflight-v1"
    for record in CERTIFICATE["cases"]:
        prime = record["field_order"]
        order = prime - 1
        generator = primitive_generator(prime)
        assert generator == record["primitive_generator"]
        logs = {pow(generator, exponent, prime): exponent for exponent in range(order)}
        points = points_with_last_pivot(prime)
        assert len(points) == record["projective_line_count"]
        forward = build_kernel(points, prime, -1, logs)
        reverse = build_kernel(points, prime, 1, logs)
        roots = root_power_bases(order, record["cyclotomic_polynomial_low_to_high"])

        assert all(sum(value is None for value in row) == prime + 1 for row in forward)
        assert verify_product(reverse, forward, roots, prime * prime) == record[
            "reverse_after_forward_reduced_matrix_sha256"
        ]
        assert verify_product(forward, reverse, roots, prime * prime) == record[
            "forward_after_reverse_reduced_matrix_sha256"
        ]

        # The alternative projective section changes the literal kernel matrices by diagonal gauge.
        # Rebuild the primary first-pivot gauge only for the tracked hash comparison.
        primary_points = sorted(
            {
                tuple(entry * pow(next(item for item in vector if item), -1, prime) % prime for entry in vector)
                for vector in ((x, y, z) for x in range(prime) for y in range(prime) for z in range(prime))
                if vector != (0, 0, 0)
            }
        )
        primary_forward = build_kernel(primary_points, prime, -1, logs)
        primary_reverse = build_kernel(primary_points, prime, 1, logs)
        assert encoded_hash(primary_forward) == record["forward_kernel_sha256"]
        assert encoded_hash(primary_reverse) == record["reverse_kernel_sha256"]

        half = order // 2
        assert (record["quotient_degree"] + half) % order == order - 1
        assert (record["product_degree"] + half) % order == 1

    print("C414 independent tautological Fourier Stage-T0 replay OK")


if __name__ == "__main__":
    main()
