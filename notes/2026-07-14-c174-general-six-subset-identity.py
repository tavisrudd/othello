#!/usr/bin/env python3
"""Exact multi-field verifier for C174's six-subset chord identity.

For every six-subset H of the standard conic XZ=Y^2 in PG(2,q), let m_H(P)
be the number of its 15 chord lines through P, let

    t(H) = sum_P binom(m_H(P), 3),

and let U(H) be the projective points outside H on no chord.  This script
checks, exhaustively for q = 5, 7, 11, 13, that

    t(H) + |U(H)| = q^2 - 14q + 115.

It also checks the three incidence identities used by the proof and freezes
the complete (t, |U|) tables.  The implementation uses only the Python
standard library and prime fields; the mathematical proof is field-uniform.
"""

from collections import Counter
from itertools import combinations
from math import comb


FIELDS = (5, 7, 11, 13)


def norm(v, q):
    """Canonical representative of a projective point or line over F_q."""
    v = tuple(x % q for x in v)
    for x in v:
        if x:
            inv = pow(x, q - 2, q)
            return tuple(y * inv % q for y in v)
    raise ValueError("zero vector has no projective normalization")


def cross(a, b, q):
    return norm(
        (
            a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0],
        ),
        q,
    )


def incident(point, line, q):
    return sum(x * y for x, y in zip(point, line)) % q == 0


def projective_points(q):
    points = [(1, y, z) for y in range(q) for z in range(q)]
    points += [(0, 1, z) for z in range(q)]
    points += [(0, 0, 1)]
    assert len(points) == q * q + q + 1
    return tuple(points)


def conic_points(q):
    points = [(1, t, t * t % q) for t in range(q)] + [(0, 0, 1)]
    assert len(points) == q + 1
    assert len(set(points)) == q + 1
    assert all((x * z - y * y) % q == 0 for x, y, z in points)
    return tuple(points)


def invariants(H, points, q):
    chords = tuple(cross(a, b, q) for a, b in combinations(H, 2))
    assert len(chords) == 15
    assert len(set(chords)) == 15

    multiplicities = {P: sum(incident(P, L, q) for L in chords) for P in points}
    Hset = set(H)
    assert all(multiplicities[P] == 5 for P in H)
    assert max((m for P, m in multiplicities.items() if P not in Hset), default=0) <= 3

    off = [multiplicities[P] for P in points if P not in Hset]
    first = sum(off)
    second = sum(comb(m, 2) for m in off)
    third = sum(comb(m, 3) for m in off)
    t = sum(comb(m, 3) for m in multiplicities.values())
    uncovered = sum(1 for P, m in multiplicities.items() if P not in Hset and m == 0)

    assert first == 15 * (q - 1)
    assert second == 45
    assert t == 60 + third
    assert uncovered == q * q - 14 * q + 55 - third
    assert t + uncovered == q * q - 14 * q + 115
    return t, uncovered


def table(q):
    points = projective_points(q)
    conic = conic_points(q)
    pairs = Counter(invariants(H, points, q) for H in combinations(conic, 6))
    assert sum(pairs.values()) == comb(q + 1, 6)
    assert {t + u for t, u in pairs} == {q * q - 14 * q + 115}
    return dict(sorted(pairs.items()))


EXPECTED = {
    # Filled from the first exhaustive run, then frozen as regression data.
    5: {(70, 0): 1},
    7: {(64, 2): 28},
    11: {(60, 22): 264, (62, 20): 330, (63, 19): 220, (64, 18): 110},
    13: {(61, 41): 2184, (62, 40): 546, (64, 38): 182, (66, 36): 91},
}


for q in FIELDS:
    observed = table(q)
    print(
        f"q={q}: constant={q*q - 14*q + 115}, "
        f"subsets={comb(q + 1, 6)}, table={observed}"
    )
    assert observed == EXPECTED[q], (q, observed, EXPECTED[q])

print("all structural identities and frozen tables passed")
