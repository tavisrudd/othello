#!/usr/bin/env python3
"""Independent finite-linear-algebra replay for the C412 obstruction."""

from __future__ import annotations

import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes/2026-07-20-c412-relative-cubic-depth-plane.json"


def rank_two(entries, prime):
    a, b, c, d, e, f = entries
    return any(value % prime for value in (a * e - b * d, a * f - c * d, b * f - c * e))


def poly_mul(left, right, prime):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] = (result[i + j] + a * b) % prime
    return result


def normalize(vector, prime):
    first = next(value % prime for value in vector if value % prime)
    inverse = pow(first, -1, prime)
    return tuple(value * inverse % prime for value in vector)


def kernel_line(entries, prime):
    a, b, c, d, e, f = entries
    minors = (b * f - c * e, c * d - a * f, a * e - b * d)
    return normalize(minors, prime)


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    prime = certificate["field"]
    target = certificate["target"]
    factors = target["factorization_linear_factors"]
    cubic = poly_mul(poly_mul(factors[0], factors[1], prime), factors[2], prime)
    assert cubic == target["compressed_binary_cubic_coefficients"]
    a, b, c, d = cubic
    f_xx, f_xy, f_yy = [6 * a % prime, 2 * b % prime], [2 * b % prime, 2 * c % prime], [2 * c % prime, 6 * d % prime]
    hessian = [(x - y) % prime for x, y in zip(poly_mul(f_xx, f_yy, prime), poly_mul(f_xy, f_xy, prime))]
    assert hessian == target["hessian_coefficients"]

    rank_two_count = 0
    kernel_counts = {}
    for entries in itertools.product(range(prime), repeat=6):
        if rank_two(entries, prime):
            rank_two_count += 1
            line = kernel_line(entries, prime)
            kernel_counts[line] = kernel_counts.get(line, 0) + 1
    common = certificate["common_symmetry_category"]
    assert rank_two_count == common["rank_two_map_count"]
    assert len(kernel_counts) == common["possible_kernel_lines"]
    assert set(kernel_counts.values()) == {common["rank_two_maps_with_any_fixed_kernel_line"]}

    witness = certificate["full_group_obstruction"]["witness"]
    assert witness["same_profile_matching_indices"][0] != witness["same_profile_matching_indices"][1]
    assert witness["distinct_image_fibres"][0] != witness["distinct_image_fibres"][1]
    print("C412 independent replay OK: binary flag, 1,755,600 rank-two maps, 133 kernel lines")


if __name__ == "__main__":
    main()
