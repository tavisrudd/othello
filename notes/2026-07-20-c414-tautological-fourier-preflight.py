#!/usr/bin/env python3
"""Exact Stage-T0 certificate for complementary tautological Fourier sectors."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-20-c414-tautological-fourier-preflight.json"
CASES = (("A3", 5), ("B3", 7), ("H3", 11))
CYCLOTOMIC = {
    4: [1, 0, 1],
    6: [1, -1, 1],
    10: [1, -1, 1, -1, 1],
}


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def primitive_root(prime: int) -> int:
    order = prime - 1
    prime_divisors = {d for d in range(2, order + 1) if order % d == 0 and all(d % e for e in range(2, d))}
    for candidate in range(2, prime):
        if all(pow(candidate, order // divisor, prime) != 1 for divisor in prime_divisors):
            return candidate
    raise AssertionError("primitive root not found")


def normalize(vector: tuple[int, int, int], prime: int) -> tuple[int, int, int]:
    pivot = next(entry for entry in vector if entry)
    inverse = pow(pivot, -1, prime)
    return tuple(entry * inverse % prime for entry in vector)


def projective_points(prime: int) -> list[tuple[int, int, int]]:
    points = {
        normalize((x, y, z), prime)
        for x in range(prime)
        for y in range(prime)
        for z in range(prime)
        if (x, y, z) != (0, 0, 0)
    }
    return sorted(points)


def dot(left: tuple[int, int, int], right: tuple[int, int, int], prime: int) -> int:
    return sum(x * y for x, y in zip(left, right)) % prime


def discrete_logs(prime: int, generator: int) -> dict[int, int]:
    return {pow(generator, exponent, prime): exponent for exponent in range(prime - 1)}


def kernel(
    points: list[tuple[int, int, int]], prime: int, weight: int, logs: dict[int, int]
) -> list[list[int]]:
    order = prime - 1
    return [
        [
            -1 if (pairing := dot(target, source, prime)) == 0 else (-weight * logs[pairing]) % order
            for source in points
        ]
        for target in points
    ]


def reduce_cyclotomic(counts: list[int], polynomial: list[int]) -> tuple[int, ...]:
    coefficients = counts[:]
    degree = len(polynomial) - 1
    for current in range(len(coefficients) - 1, degree - 1, -1):
        leading = coefficients[current]
        if not leading:
            continue
        offset = current - degree
        for index, coefficient in enumerate(polynomial):
            coefficients[offset + index] -= leading * coefficient
    return tuple(coefficients[:degree])


def verify_composition(
    left: list[list[int]], right: list[list[int]], order: int, polynomial: list[int], scalar: int
) -> str:
    size = len(left)
    digest = hashlib.sha256()
    zero = (0,) * (len(polynomial) - 1)
    for row in range(size):
        for column in range(size):
            counts = [0] * order
            for middle in range(size):
                left_exponent = left[row][middle]
                right_exponent = right[middle][column]
                if left_exponent >= 0 and right_exponent >= 0:
                    counts[(left_exponent + right_exponent) % order] += 1
            reduced = reduce_cyclotomic(counts, polynomial)
            expected = (scalar,) + zero[1:] if row == column else zero
            assert reduced == expected
            digest.update(json.dumps(reduced, separators=(",", ":")).encode())
            digest.update(b"\n")
    return digest.hexdigest()


def matrix_hash(matrix: list[list[int]]) -> str:
    return hashlib.sha256(canonical_bytes(matrix)).hexdigest()


def case_certificate(name: str, prime: int) -> dict[str, object]:
    order = prime - 1
    polynomial = CYCLOTOMIC[order]
    generator = primitive_root(prime)
    logs = discrete_logs(prime, generator)
    points = projective_points(prime)
    forward = kernel(points, prime, -1, logs)
    reverse = kernel(points, prime, 1, logs)

    expected_points = prime * prime + prime + 1
    assert len(points) == expected_points
    orthogonal_counts = [sum(exponent < 0 for exponent in row) for row in forward]
    nonzero_counts = [sum(exponent >= 0 for exponent in row) for row in forward]
    assert set(orthogonal_counts) == {prime + 1}
    assert set(nonzero_counts) == {prime * prime}

    forward_reverse_hash = verify_composition(reverse, forward, order, polynomial, prime * prime)
    reverse_forward_hash = verify_composition(forward, reverse, order, polynomial, prime * prime)

    half = order // 2
    quotient_degree = half - 1
    product_degree = half + 1
    assert (quotient_degree + product_degree) % order == 0
    assert (quotient_degree + half) % order == order - 1
    assert (product_degree + half) % order == 1

    return {
        "type": name,
        "field_order": prime,
        "multiplicative_group_order": order,
        "primitive_generator": generator,
        "cyclotomic_polynomial_low_to_high": polynomial,
        "projective_line_count": len(points),
        "orthogonal_lines_per_kernel_row": orthogonal_counts[0],
        "nonzero_entries_per_kernel_row": nonzero_counts[0],
        "quotient_degree": quotient_degree,
        "product_degree": product_degree,
        "quadratic_orientation_exponent": half,
        "oriented_quotient_weight_mod_q_minus_1": (quotient_degree + half) % order,
        "oriented_product_weight_mod_q_minus_1": (product_degree + half) % order,
        "forward_source_weight": -1,
        "forward_target_weight": 1,
        "forward_kernel_sha256": matrix_hash(forward),
        "reverse_kernel_sha256": matrix_hash(reverse),
        "reverse_after_forward_equals_q_squared_identity": True,
        "forward_after_reverse_equals_q_squared_identity": True,
        "reverse_after_forward_reduced_matrix_sha256": forward_reverse_hash,
        "forward_after_reverse_reduced_matrix_sha256": reverse_forward_hash,
        "gauss_factored_composition_scalar": prime * prime,
        "full_fourier_square_scalar_before_projectivizing": prime**3,
    }


def build() -> dict[str, object]:
    cases = [case_certificate(name, prime) for name, prime in CASES]
    return {
        "schema": "c414-tautological-fourier-preflight-v1",
        "ambient_space": "three-dimensional prime-field vector space with nondegenerate dot pairing",
        "character_sector_rule": "Fourier sends H_r to H_-r",
        "cases": cases,
        "verdict": (
            "THEOREM; ORIENTATION-TWISTED FACTORIZATION DEGREES ARE TAUTOLOGICAL +/-1 WEIGHTS, "
            "AND BOTH ORDERS OF THEIR EXACT PROJECTIVE FOURIER KERNELS COMPOSE TO q^2 I"
        ),
        "boundary": (
            "No exceptional A4 restriction, matching-section identity, depth shadow, modular extension, "
            "existence of an A3 sheet orientation, or novelty claim is certified."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    assert args.write ^ args.check, "choose exactly one of --write or --check"

    payload = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(payload)
    else:
        assert OUTPUT.read_bytes() == payload
    print("C414 tautological Fourier Stage-T0 certificate OK")


if __name__ == "__main__":
    main()
