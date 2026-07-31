#!/usr/bin/env python3
"""Generate the C730 arithmetic--harmonic orientation-source certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / "2026-07-31-c730-orientation-source.json"
HARMONIC = (
    ROOT
    / "papers"
    / "clebsch-passages"
    / "verification"
    / "evidence"
    / "harmonic_clebsch.json"
)
EXPECTED_HARMONIC_SHA256 = (
    "ecdff5d58327b07e0a26f4bfdf83fd403c47bf5b34cdf856bfc3c9d053b9fa17"
)


@dataclass(frozen=True, order=True)
class Golden:
    """An element a + b*t of Q[t]/(t^2-t-1)."""

    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)

    def __add__(self, other: object) -> Golden:
        rhs = coerce(other)
        return Golden(self.a + rhs.a, self.b + rhs.b)

    __radd__ = __add__

    def __neg__(self) -> Golden:
        return Golden(-self.a, -self.b)

    def __sub__(self, other: object) -> Golden:
        return self + (-coerce(other))

    def __rsub__(self, other: object) -> Golden:
        return coerce(other) - self

    def __mul__(self, other: object) -> Golden:
        rhs = coerce(other)
        return Golden(
            self.a * rhs.a + self.b * rhs.b,
            self.a * rhs.b + self.b * rhs.a + self.b * rhs.b,
        )

    __rmul__ = __mul__

    def conjugate(self) -> Golden:
        return Golden(self.a + self.b, -self.b)

    def text(self) -> str:
        return f"[{self.a},{self.b}]"


def coerce(value: object) -> Golden:
    if isinstance(value, Golden):
        return value
    return Golden(Fraction(value))


ZERO = Golden()
ONE = Golden(Fraction(1))
T = Golden(Fraction(0), Fraction(1))
SQRT5 = 2 * T - 1


def dot(left: tuple[Golden, ...], right: tuple[Golden, ...]) -> Golden:
    return sum((x * y for x, y in zip(left, right)), ZERO)


def mat_vec(
    matrix: tuple[tuple[int, ...], ...], vector: tuple[Golden, ...]
) -> tuple[Golden, ...]:
    return tuple(
        sum((Golden(Fraction(entry)) * value for entry, value in zip(row, vector)), ZERO)
        for row in matrix
    )


def scale(scalar: Golden, vector: tuple[Golden, ...]) -> tuple[Golden, ...]:
    return tuple(scalar * value for value in vector)


def matrix_product(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def certificate() -> dict[str, object]:
    axes = (
        (ZERO, T, ONE),
        (ZERO, T, -ONE),
        (ONE, ZERO, T),
        (-ONE, ZERO, T),
        (T, -ONE, ZERO),
        (-T, -ONE, ZERO),
    )
    conjugate_axes = tuple(
        tuple(value.conjugate() for value in axis) for axis in axes
    )
    exchanger = ((1, 0, 0), (0, 0, -1), (0, 1, 0))
    permutation = (0, 1, 5, 4, 2, 3)
    switches = (1, -1, 1, 1, 1, 1)
    for index, axis in enumerate(axes):
        assert mat_vec(exchanger, axis) == scale(
            T * switches[index], conjugate_axes[permutation[index]]
        )

    conference = [
        [0, 1, 1, 1, -1, -1],
        [1, 0, -1, -1, -1, -1],
        [1, -1, 0, 1, 1, -1],
        [1, -1, 1, 0, -1, 1],
        [-1, -1, 1, -1, 0, -1],
        [-1, -1, -1, 1, -1, 0],
    ]
    gram = [[dot(left, right) for right in axes] for left in axes]
    for i in range(6):
        for j in range(6):
            expected = (T + 2 if i == j else T * conference[i][j])
            assert gram[i][j] == expected
    assert matrix_product(conference, conference) == [
        [5 if i == j else 0 for j in range(6)] for i in range(6)
    ]

    transported = [
        [
            switches[i]
            * switches[j]
            * conference[permutation[i]][permutation[j]]
            for j in range(6)
        ]
        for i in range(6)
    ]
    assert transported == [[-entry for entry in row] for row in conference]

    triples = tuple(itertools.combinations(range(6), 3))
    triangle = {
        "".join(map(str, triple)): conference[triple[0]][triple[1]]
        * conference[triple[1]][triple[2]]
        * conference[triple[2]][triple[0]]
        for triple in triples
    }
    transported_triangle = {
        "".join(map(str, triple)): transported[triple[0]][triple[1]]
        * transported[triple[1]][triple[2]]
        * transported[triple[2]][triple[0]]
        for triple in triples
    }
    assert transported_triangle == {key: -value for key, value in triangle.items()}

    labels = tuple(itertools.combinations(range(5), 2))
    adjacency = [
        [int(set(left).isdisjoint(right)) for right in labels] for left in labels
    ]
    petersen_checks = []
    for basis_index in range(4):
        y = [0] * 5
        y[basis_index] = 1
        y[4] = -1
        pair_sum = [y[i] + y[j] for i, j in labels]
        assert [
            sum(adjacency[row][column] * pair_sum[column] for column in range(10))
            for row in range(10)
        ] == [-2 * value for value in pair_sum]
        assert sum(value * value for value in pair_sum) == 3 * sum(
            value * value for value in y
        )
        recovered = [
            sum(pair_sum[column] for column, pair in enumerate(labels) if i in pair)
            for i in range(5)
        ]
        assert recovered == [3 * value for value in y]
        petersen_checks.append(pair_sum)

    harmonic_hash = sha256(HARMONIC)
    assert harmonic_hash == EXPECTED_HARMONIC_SHA256
    harmonic = json.loads(HARMONIC.read_text())
    assert harmonic["gaunt_scalar"] == "-784000/1247103"
    assert harmonic["sphere_average_F2"] == "2800/351"
    assert harmonic["sphere_average_F3"] == "-15680000/1247103"
    assert harmonic["sigma3_witness"] == "20"

    # With J_0|_V = 16*sigma_3^2 and s^2 = 5, the pulled-back
    # quadratic equation factors as shown.  The script records the scalar
    # identity; normalization of the reducible cover is a human proof.
    assert SQRT5 * SQRT5 == Golden(Fraction(5))
    cover_coefficient = 5 * 16
    sheet_coefficient = 4
    assert cover_coefficient == sheet_coefficient**2 * 5

    return {
        "schema": "c730-orientation-source-v1",
        "golden_field": {
            "polynomial": "t^2-t-1",
            "sqrt5": "2t-1",
            "conjugation": "t -> 1-t",
        },
        "incidence_pullback": {
            "equation": "z^2=80*sigma3^2",
            "factorization": "(z-4*sqrt5*sigma3)(z+4*sqrt5*sigma3)",
            "normalization_claim_checked_only_at_scalar_level": True,
        },
        "golden_exchanger": {
            "matrix": exchanger,
            "old_axis_to_conjugate_axis": list(permutation),
            "representative_switches": list(switches),
            "representative_scalars": ["t", "-t", "t", "t", "t", "t"],
            "odd_switch_count": 1,
            "transported_conference": "-C",
            "transported_triangle_cubic": "-Z_C",
        },
        "conference": conference,
        "triangle_coefficients": triangle,
        "petersen_comparison": {
            "labels": [list(label) for label in labels],
            "basis_pair_sum_vectors": petersen_checks,
            "adjacency_eigenvalue": -2,
            "quadratic_similarity": "sum_pairs(y_i+y_j)^2=3*sum_i(y_i)^2",
            "inverse": "y_i=(1/3)*sum_{j!=i}a_ij",
        },
        "harmonic_input": {
            "path": str(HARMONIC.relative_to(ROOT)),
            "sha256": harmonic_hash,
            "gaunt_scalar": harmonic["gaunt_scalar"],
            "quadratic_scalar": "140/351",
            "witness": {
                "y": [4, -1, -1, -1, -1],
                "sigma3": harmonic["sigma3_witness"],
                "sphere_average_F2": harmonic["sphere_average_F2"],
                "sphere_average_F3": harmonic["sphere_average_F3"],
            },
        },
        "integral_boundaries": {
            "conference_and_triangle": "Z",
            "orientation_distinction": "fails in characteristic 2",
            "golden_algebra": "ramified in characteristic 5",
            "petersen_inverse": "requires 3 invertible",
            "gaunt_scalar_denominator_primes": [3, 11, 13, 17, 19],
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(payload)
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_text() != payload:
            raise SystemExit("tracked C730 certificate is stale")
    if not args.write and not args.check:
        print(payload, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
