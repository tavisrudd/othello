#!/usr/bin/env python3
"""Exact GF(25) replay for the round-7 semilinear Baer obstruction."""

from collections import Counter
from itertools import combinations, product


# Elements are a+5b with w=5 and w^2=2 over F_5.
def add(x, y):
    return ((x % 5 + y % 5) % 5) + 5 * (((x // 5) + (y // 5)) % 5)


def neg(x):
    return (-x % 5) + 5 * (-(x // 5) % 5)


def sub(x, y):
    return add(x, neg(y))


def mul(x, y):
    a, b = x % 5, x // 5
    c, d = y % 5, y // 5
    return ((a*c + 2*b*d) % 5) + 5 * ((a*d + b*c) % 5)


def power(x, n):
    result = 1
    while n:
        if n & 1:
            result = mul(result, x)
        x = mul(x, x)
        n >>= 1
    return result


def inv(x):
    assert x
    result = power(x, 23)
    assert mul(x, result) == 1
    return result


def normalize(vector):
    pivot = next(x for x in vector if x)
    scale = inv(pivot)
    return tuple(mul(x, scale) for x in vector)


def frobenius(vector):
    return normalize(tuple(power(x, 5) for x in vector))


def det(a, b, c):
    return add(
        sub(mul(a[0], sub(mul(b[1], c[2]), mul(b[2], c[1]))),
            mul(a[1], sub(mul(b[0], c[2]), mul(b[2], c[0])))),
        mul(a[2], sub(mul(b[0], c[1]), mul(b[1], c[0]))),
    )


def main():
    w = 5
    assert mul(w, w) == 2 and power(w, 5) == neg(w)
    assert all(mul(x, inv(x)) == 1 for x in range(1, 25))

    points = {normalize(v) for v in product(range(25), repeat=3) if any(v)}
    baer = {normalize(v) for v in product(range(5), repeat=3) if any(v)}
    conic_f5 = {normalize((mul(t, t), t, 1)) for t in range(5)} | {(1, 0, 0)}
    p = normalize((2, w, 1))
    hp = normalize((2, neg(w), 1))
    selected = conic_f5 | {p, hp}

    assert len(points) == 651 and len(baer) == 31
    assert len(conic_f5) == 6 and len(selected) == 8
    assert frobenius(p) == hp and frobenius(hp) == p
    assert {x for x in points if frobenius(x) == x} == baer
    assert all(det(*triple) != 0 for triple in combinations(selected, 3))

    legal = {x for x in points-selected
             if all(det(x, a, b) != 0 for a, b in combinations(selected, 2))}
    fixed_legal = {x for x in legal if frobenius(x) == x}
    bad_deck_orbits = []
    witness_counts = Counter()
    for x in sorted(legal):
        hx = frobenius(x)
        if x >= hx:
            continue
        assert hx in legal
        witnesses = tuple(sorted(t for t in selected if det(x, hx, t) == 0))
        if witnesses:
            assert len(witnesses) == 1 and witnesses[0] in conic_f5
            bad_deck_orbits.append((x, hx, witnesses[0]))
            witness_counts[witnesses[0]] += 1

    assert not fixed_legal
    assert len(bad_deck_orbits) == 30
    assert set(witness_counts) == conic_f5 and set(witness_counts.values()) == {5}
    print(f"q=25 points={len(points)} T={len(selected)} cap=PASS "
          f"fixed_B={len(baer)} legal={len(legal)} fixed_legal={len(fixed_legal)}")
    print(f"P={p} tauP={hp}")
    print(f"bad_deck_orbits={len(bad_deck_orbits)} defect_lines={len(witness_counts)} "
          f"orbits_per_line={sorted(witness_counts.values())}")
    print("all_assertions=PASS")


if __name__ == "__main__":
    main()
