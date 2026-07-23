#!/usr/bin/env python3
"""Exact GF(9) calibration for the C510 one-twist geometry pilot."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path

P = 3
Q = 9
R = 6
THETA = 1


def add(x: int, y: int) -> int:
    return ((x % P + y % P) % P) + P * ((x // P + y // P) % P)


def neg(x: int) -> int:
    return ((-x % P) % P) + P * ((-(x // P) % P) % P)


def mul(x: int, y: int) -> int:
    """Multiply a+b*u with c+d*u in GF(3)[u]/(u^2+1)."""
    a, b = x % P, x // P
    c, d = y % P, y // P
    return ((a * c + 2 * b * d) % P) + P * ((a * d + b * c) % P)


def inv(x: int) -> int:
    if x == 0:
        raise ZeroDivisionError
    for y in range(1, Q):
        if mul(x, y) == 1:
            return y
    raise AssertionError("nonzero GF(9) element has no inverse")


def power(x: int, n: int) -> int:
    out = 1
    while n:
        if n & 1:
            out = mul(out, x)
        x = mul(x, x)
        n >>= 1
    return out


def dot(x: tuple[int, ...], y: tuple[int, ...]) -> int:
    out = 0
    for a, b in zip(x, y):
        out = add(out, mul(a, b))
    return out


def column(t: int) -> tuple[int, ...]:
    powers = [power(t, i) for i in range(R + 1)]
    return tuple(powers[: R - 1] + [add(powers[R - 1], neg(mul(THETA, powers[R])))])


def rref(matrix: list[list[int]]) -> tuple[list[list[int]], list[int]]:
    a = [row[:] for row in matrix]
    pivots: list[int] = []
    row = 0
    for col in range(len(a[0])):
        pivot = next((i for i in range(row, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        scale = inv(a[row][col])
        a[row] = [mul(scale, x) for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][col]:
                scale = a[i][col]
                a[i] = [add(x, neg(mul(scale, y))) for x, y in zip(a[i], a[row])]
        pivots.append(col)
        row += 1
        if row == len(a):
            break
    return a, pivots


def rank(matrix: list[list[int]]) -> int:
    return len(rref(matrix)[1])


def hyperplane_normal(columns: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    reduced, pivots = rref([list(c) for c in columns])
    assert len(pivots) == R - 1
    free = next(i for i in range(R) if i not in pivots)
    out = [0] * R
    out[free] = 1
    for row, pivot in enumerate(pivots):
        out[pivot] = neg(reduced[row][free])
    normal = tuple(out)
    assert all(dot(normal, c) == 0 for c in columns)
    return normal


def projective_points():
    for first in range(R):
        for tail in itertools.product(range(Q), repeat=R - first - 1):
            yield (0,) * first + (1,) + tail


def normalize(v: tuple[int, ...]) -> tuple[int, ...]:
    first = next(x for x in v if x)
    scale = inv(first)
    return tuple(mul(scale, x) for x in v)


def matrix_inverse(matrix: list[list[int]]) -> list[list[int]]:
    n = len(matrix)
    augmented = [row[:] + [1 if i == j else 0 for j in range(n)] for i, row in enumerate(matrix)]
    reduced, pivots = rref(augmented)
    assert pivots[:n] == list(range(n))
    return [row[n:] for row in reduced]


def matrix_mul(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [dot(tuple(row), tuple(b[k][j] for k in range(len(b)))) for j in range(len(b[0]))]
        for row in a
    ]


def matrix_vector(a: list[list[int]], v: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(dot(tuple(row), v) for row in a)


def columns_to_matrix(columns: tuple[tuple[int, ...], ...]) -> list[list[int]]:
    return [[columns[j][i] for j in range(len(columns))] for i in range(R)]


def translation_matrix(b: int, columns: tuple[tuple[int, ...], ...]) -> list[list[int]]:
    basis_indices = next(
        inds
        for inds in itertools.combinations(range(Q), R)
        if rank(columns_to_matrix(tuple(columns[i] for i in inds))) == R
    )
    source = columns_to_matrix(tuple(columns[i] for i in basis_indices))
    target = columns_to_matrix(tuple(column(add(i, b)) for i in basis_indices))
    transform = matrix_mul(target, matrix_inverse(source))
    assert all(matrix_vector(transform, column(t)) == column(add(t, b)) for t in range(Q))
    return transform


def canonical_bytes(points: list[tuple[int, ...]]) -> bytes:
    return ("\n".join(",".join(map(str, point)) for point in points) + "\n").encode()


def generate() -> dict:
    columns = tuple(column(t) for t in range(Q))
    assert all(rank([list(c) for c in subset]) == R - 1 for subset in itertools.combinations(columns, R - 1))
    normals = tuple(hyperplane_normal(subset) for subset in itertools.combinations(columns, R - 1))
    deep = sorted(point for point in projective_points() if all(dot(point, normal) for normal in normals))
    assert (0, 0, 0, 0, 0, 1) in deep

    translations = tuple(translation_matrix(b, columns) for b in range(Q))
    deep_set = set(deep)
    assert all(normalize(matrix_vector(a, point)) in deep_set for a in translations for point in deep)
    fixed_equations = [
        [add(entry, neg(1 if i == j else 0)) for j, entry in enumerate(row)]
        for a in translations
        for i, row in enumerate(a)
    ]
    common_fixed_dimension = R - rank(fixed_equations)
    assert common_fixed_dimension == 1

    unseen = set(deep)
    orbits: list[list[tuple[int, ...]]] = []
    while unseen:
        point = min(unseen)
        orbit = sorted({normalize(matrix_vector(a, point)) for a in translations})
        assert set(orbit) <= unseen
        unseen.difference_update(orbit)
        orbits.append(orbit)

    standard = (0, 0, 0, 0, 0, 1)
    standard_orbit = next(orbit for orbit in orbits if standard in orbit)
    return {
        "schema": "c510-trs-deep-hole-pilot-v1",
        "field": {"model": "GF(3)[u]/(u^2+1)", "order": Q},
        "parameters": {"q": Q, "k": 3, "redundancy": R, "theta": THETA},
        "projective_syndrome_points": (Q**R - 1) // (Q - 1),
        "support_hyperplanes": len(normals),
        "deep_point_count": len(deep),
        "deep_points_sha256": hashlib.sha256(canonical_bytes(deep)).hexdigest(),
        "translation_orbit_count": len(orbits),
        "translation_orbit_size_histogram": {
            str(size): count for size, count in sorted(Counter(map(len, orbits)).items())
        },
        "common_translation_fixed_vector_space_dimension": common_fixed_dimension,
        "standard_orbit_size": len(standard_orbit),
        "standard_orbit": [list(point) for point in standard_orbit],
        "checks": {
            "all_five_column_supports_independent": True,
            "all_translation_matrices_preserve_columns": True,
            "all_translation_matrices_preserve_deep_set": True,
            "common_translation_fixed_space_is_standard_line": True,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    result = generate()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        if args.check.read_text() != encoded:
            raise SystemExit(f"mismatch: {args.check}")
        print(f"PASS {args.check}")
    elif args.output:
        args.output.write_text(encoded)
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
