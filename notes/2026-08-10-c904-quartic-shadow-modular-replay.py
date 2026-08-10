#!/usr/bin/env python3
"""Independent exact replay of the C904 quartic modular-shadow certificate.

Unlike the primary checker, this uses pointwise rational interpolation for the
map identity and primitive cyclic direct summands of (Z/6)^2 for the gluing
orbit.  It shares no code with the primary checker.
"""

from fractions import Fraction as F
from itertools import combinations, permutations, product
from math import gcd


def cr(z):
    a, b, c, d = z
    if d is None:
        return (a - c) / (b - c)
    if c is None:
        return (b - d) / (a - d)
    if b is None:
        return (a - c) / (a - d)
    if a is None:
        return (b - d) / (b - c)
    return (a - c) * (b - d) / ((a - d) * (b - c))


def y(t):
    return 3 * (5 - 14 * t) / (8 * (4 * t - 1))


def via_y(t):
    u = y(t)
    return -(4 * u + 3) * (u + 3) ** 2 / (u + 1) ** 2


def direct(t):
    return F(6561, 100) * (t - F(1, 2)) * (t - F(1, 6)) ** 2 / (
        (t - F(1, 4)) * (t - F(7, 10)) ** 2
    )


def matrix_sum(vectors):
    return [[sum(F(v[i] * v[j]) for v in vectors) for j in range(6)]
            for i in range(6)]


def frame_ok(vectors, constant):
    matrix = matrix_sum(vectors)
    return all(matrix[i][j] == F(5 * constant, 6) if i == j
               else matrix[i][j] == F(-constant, 6)
               for i in range(6) for j in range(6))


def canonical_cyclic(v):
    other = ((5 * v[0]) % 6, (5 * v[1]) % 6)
    return min(v, other)


def act(g, v):
    a, b, c, d = g
    return canonical_cyclic(((a * v[0] + b * v[1]) % 6,
                             (c * v[0] + d * v[1]) % 6))


def main():
    quartic = [F(1, 2), F(1, 4), F(1, 6), F(7, 10)]
    cusps = [F(0), F(1), F(9), None]
    expected = {F(-8), F(-1, 8), F(1, 9), F(8, 9), F(9, 8), F(9)}
    assert {cr(z) for z in permutations(quartic)} == expected
    assert {cr(z) for z in permutations(cusps)} == expected

    # The cleared difference has degree at most six; seven regular values
    # suffice.  We check ten, independently evaluating the two formulas.
    tests = [F(k) for k in range(-4, 7)
             if F(k) not in {F(1, 4), F(7, 10)}]
    assert len(tests) >= 7 and all(via_y(t) == direct(t) for t in tests)
    assert y(F(1, 2)) == F(-3, 4)
    assert y(F(1, 6)) == F(-3)
    assert y(F(7, 10)) == F(-1)

    roots = []
    for i, j in combinations(range(6), 2):
        v = [0] * 6
        v[i], v[j] = 1, -1
        roots.append(v)
    triples = [[1 if i in S else -1 for i in range(6)]
               for S in combinations(range(6), 3) if 0 in S]
    simplex = [[5 if i == j else -1 for i in range(6)] for j in range(6)]
    assert frame_ok(roots, 6)
    assert frame_ok(triples, 12)
    assert frame_ok(simplex, 36)

    primitive = {(a, b) for a, b in product(range(6), repeat=2)
                 if gcd(gcd(a, b), 6) == 1}
    cyclic = {canonical_cyclic(v) for v in primitive}
    group = [(a, b, c, d) for a, b, c, d in product(range(6), repeat=4)
             if (a * d - b * c) % 6 == 1]
    orbit = {act(g, (1, 0)) for g in group}
    stabilizer = [g for g in group if act(g, (1, 0)) == (1, 0)]
    assert len(cyclic) == 12 and orbit == cyclic
    assert len(group) == 144 and len(stabilizer) == 12

    print("INDEPENDENT REPLAY PASS")
    print("cross-ratio orbit, rational map, three frames, and 12-gluing orbit agree")


if __name__ == "__main__":
    main()
