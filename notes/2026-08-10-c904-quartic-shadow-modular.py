#!/usr/bin/env python3
"""Exact certificate for the S6-quartic / X0(6) shadow calculation.

This is deliberately elementary: rational polynomial arithmetic, finite
matrix enumeration modulo 2, 3, and 6, and tight-frame identities in the
standard S6 representation.  It has no optional dependencies.
"""

from fractions import Fraction as Q
from itertools import combinations, permutations, product
from math import gcd
from pathlib import Path
import sys


def trim(f):
    f = list(f)
    while len(f) > 1 and f[-1] == 0:
        f.pop()
    return tuple(f)


def padd(f, g):
    n = max(len(f), len(g))
    return trim([(f[i] if i < len(f) else 0) +
                 (g[i] if i < len(g) else 0) for i in range(n)])


def pscale(c, f):
    return trim([c * x for x in f])


def pmul(f, g):
    h = [Q(0)] * (len(f) + len(g) - 1)
    for i, a in enumerate(f):
        for j, b in enumerate(g):
            h[i + j] += a * b
    return trim(h)


def ppow(f, n):
    h = (Q(1),)
    for _ in range(n):
        h = pmul(h, f)
    return h


class Rat:
    def __init__(self, num, den=(Q(1),)):
        self.num, self.den = trim(num), trim(den)

    def __add__(self, other):
        if not isinstance(other, Rat):
            other = Rat((Q(other),))
        return Rat(padd(pmul(self.num, other.den),
                        pmul(other.num, self.den)), pmul(self.den, other.den))

    __radd__ = __add__

    def __neg__(self):
        return Rat(pscale(-1, self.num), self.den)

    def __sub__(self, other):
        return self + (-other)

    def __rsub__(self, other):
        return Rat((Q(other),)) - self

    def __mul__(self, other):
        if not isinstance(other, Rat):
            other = Rat((Q(other),))
        return Rat(pmul(self.num, other.num), pmul(self.den, other.den))

    __rmul__ = __mul__

    def __truediv__(self, other):
        if not isinstance(other, Rat):
            other = Rat((Q(other),))
        return Rat(pmul(self.num, other.den), pmul(self.den, other.num))

    def __rtruediv__(self, other):
        return Rat((Q(other),)) / self

    def __pow__(self, n):
        return Rat(ppow(self.num, n), ppow(self.den, n))

    def __eq__(self, other):
        if not isinstance(other, Rat):
            other = Rat((Q(other),))
        return trim(pmul(self.num, other.den)) == trim(pmul(other.num, self.den))


X = Rat((Q(0), Q(1)))


def cross_ratio(a, b, c, d):
    if d is None:
        return (a - c) / (b - c)
    if c is None:
        return (b - d) / (a - d)
    if b is None:
        return (a - c) / (a - d)
    if a is None:
        return (b - d) / (b - c)
    return (a - c) * (b - d) / ((a - d) * (b - c))


def canonical_line(v, p):
    a, b = (x % p for x in v)
    if a:
        inv = pow(a, -1, p)
        return (1, b * inv % p)
    if b:
        return (0, 1)
    raise ValueError("zero vector")


def sl2(p):
    return [(a, b, c, d) for a, b, c, d in product(range(p), repeat=4)
            if (a * d - b * c) % p == 1]


def act_line(g, line, p):
    a, b, c, d = g
    x, y = line
    return canonical_line((a * x + b * y, c * x + d * y), p)


def outer(v):
    return [[Q(x * y) for y in v] for x in v]


def madd(a, b):
    return [[a[i][j] + b[i][j] for j in range(6)] for i in range(6)]


def msum(vectors):
    out = [[Q(0) for _ in range(6)] for _ in range(6)]
    for v in vectors:
        out = madd(out, outer(v))
    return out


def projector_scaled(c):
    return [[Q(c) * (Q(1) if i == j else Q(0)) - Q(c, 6)
             for j in range(6)] for i in range(6)]


def subgroup_generated(g, h, modulus):
    return frozenset((((r * g[0] + s * h[0]) % modulus),
                      ((r * g[1] + s * h[1]) % modulus))
                     for r in range(modulus) for s in range(modulus))


def emit():
    quartic = [Q(1, 2), Q(1, 4), Q(1, 6), Q(7, 10)]
    x06 = [Q(0), Q(1), Q(9), None]
    cr_quartic = {cross_ratio(*z) for z in permutations(quartic)}
    cr_x06 = {cross_ratio(*z) for z in permutations(x06)}
    assert cr_quartic == cr_x06 == {
        Q(-8), Q(-1, 8), Q(1, 9), Q(8, 9), Q(9, 8), Q(9)
    }

    # Width matching: 1/2,1/6,1/4,7/10 have widths 1,2,3,6.
    y = 3 * (5 - 14 * X) / (8 * (4 * X - 1))
    targets = {
        Q(1, 2): Q(-3, 4),
        Q(1, 6): Q(-3),
        Q(1, 4): None,
        Q(7, 10): Q(-1),
    }
    for t, value in targets.items():
        numerator = sum(c * t**i for i, c in enumerate(y.num))
        denominator = sum(c * t**i for i, c in enumerate(y.den))
        if value is None:
            assert denominator == 0 and numerator != 0
        else:
            assert numerator == value * denominator

    T = -(4 * y + 3) * (y + 3)**2 / (y + 1)**2
    expected_T = Q(6561, 100) * ((X - Q(1, 2)) * (X - Q(1, 6))**2) / (
        (X - Q(1, 4)) * (X - Q(7, 10))**2)
    assert T == expected_T

    # The three isolated boundary orbits give tight-frame constants 6,12,36.
    roots = []
    for i, j in combinations(range(6), 2):
        v = [0] * 6
        v[i], v[j] = 1, -1
        roots.append(v)
    partitions = []
    for S in combinations(range(6), 3):
        if 0 not in S:  # one representative of S/complement
            continue
        partitions.append([1 if i in S else -1 for i in range(6)])
    vertices = [[5 if i == j else -1 for i in range(6)] for j in range(6)]
    assert len(roots) == 15 and len(partitions) == 10 and len(vertices) == 6
    assert msum(roots) == projector_scaled(6)
    assert msum(partitions) == projector_scaled(12)
    assert msum(vertices) == projector_scaled(36)

    # The self-dual root/weight sandwich has 3*4=12 local gluing choices,
    # and the centralizer is transitive on them.  The standard stabilizer is
    # c=0 modulo 6, i.e. Gamma_0(6) at finite level.
    lines = {p: sorted({canonical_line(v, p)
                        for v in product(range(p), repeat=2) if v != (0, 0)})
             for p in (2, 3)}
    assert [len(lines[p]) for p in (2, 3)] == [3, 4]
    for p in (2, 3):
        orbit = {act_line(g, (1, 0), p) for g in sl2(p)}
        assert orbit == set(lines[p])
    group6 = [(a, b, c, d) for a, b, c, d in product(range(6), repeat=4)
              if (a * d - b * c) % 6 == 1]
    assert len(group6) == 144
    orbit6 = {(act_line((a % 2, b % 2, c % 2, d % 2), (1, 0), 2),
               act_line((a % 3, b % 3, c % 3, d % 3), (1, 0), 3))
              for a, b, c, d in group6}
    stabilizer6 = [(a, b, c, d) for a, b, c, d in group6 if c % 6 == 0]
    assert len(orbit6) == 12 and len(stabilizer6) == 12
    elements6 = list(product(range(6), repeat=2))
    subgroups6 = {subgroup_generated(g, h, 6)
                  for g in elements6 for h in elements6}
    lagrangians6 = {
        subgroup for subgroup in subgroups6
        if len(subgroup) == 6 and all(
            (u[0] * v[1] - u[1] * v[0]) % 6 == 0
            for u in subgroup for v in subgroup)
    }
    cyclic6 = {
        frozenset(((r * a) % 6, (r * b) % 6) for r in range(6))
        for a, b in elements6 if gcd(gcd(a, b), 6) == 1
    }
    assert lagrangians6 == cyclic6 and len(lagrangians6) == 12

    return "\n".join([
        "CERTIFICATE PASS",
        "boundary cross-ratio orbit = -8,-1/8,1/9,8/9,9/8,9",
        "frame constants 15/10/6 = 6,12,36 -> cusp widths 1,2,6",
        "quartic cusp widths: 1/2->1, 1/6->2, 1/4->3, 7/10->6",
        "y(t)=3(5-14t)/(8(4t-1))",
        "T(t)=6561/100*(t-1/2)*(t-1/6)^2/((t-1/4)*(t-7/10)^2)",
        "local gluings 3*4=12; SL2(Z/6) orbit=12 stabilizer c=0 mod 6",
    ]) + "\n"


def main():
    output = emit()
    if "--check" in sys.argv:
        expected_path = Path(__file__).with_suffix(".out")
        expected = expected_path.read_text(encoding="utf-8")
        if output != expected:
            raise SystemExit(f"certificate drift: {expected_path}")
        print(f"CHECK PASS {expected_path.name}")
        return
    print(output, end="")


if __name__ == "__main__":
    main()
