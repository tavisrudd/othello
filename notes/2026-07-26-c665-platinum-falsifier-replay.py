#!/usr/bin/env python3
"""Independent generator-based replay of the C665 Platinum falsifier."""

from __future__ import annotations

import importlib.util
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPLAY_PATH = HERE / "2026-07-26-c665-balanced-matching-completeness-replay.py"


def load_replay():
    spec = importlib.util.spec_from_file_location("c665_replay", REPLAY_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


R = load_replay()


def add9(x, y):
    return ((x % 3 + y % 3) % 3) + 3 * ((x // 3 + y // 3) % 3)


def neg9(x):
    return ((-x % 3) % 3) + 3 * ((-(x // 3) % 3) % 3)


def mul9(x, y):
    """Multiply in F_3[b]/(b^2-b-1), a model distinct from the primary."""
    a, b = x % 3, x // 3
    c, d = y % 3, y // 3
    return ((a * c + b * d) % 3) + 3 * ((a * d + b * c + b * d) % 3)


def pow9(x, exponent):
    answer = 1
    while exponent:
        if exponent & 1:
            answer = mul9(answer, x)
        x = mul9(x, x)
        exponent //= 2
    return answer


def inv9(x):
    assert x
    return pow9(x, 7)


def mobius9(entries, x):
    a, b, c, d = entries
    if x == 9:
        return 9 if c == 0 else mul9(a, inv9(c))
    numerator = add9(mul9(a, x), b)
    denominator = add9(mul9(c, x), d)
    return 9 if denominator == 0 else mul9(numerator, inv9(denominator))


def q9_generator_groups():
    translation = tuple(mobius9((1, 1, 0, 1), x) for x in range(10))
    extension_translation = tuple(mobius9((1, 3, 0, 1), x) for x in range(10))
    inversion = tuple(mobius9((0, neg9(1), 1, 0), x) for x in range(10))
    squares = {mul9(x, x) for x in range(1, 9)}
    nonsquare = next(x for x in range(1, 9) if x not in squares)
    dilation = tuple(mobius9((nonsquare, 0, 0, 1), x) for x in range(10))
    psl = R.generated_group((translation, extension_translation, inversion))
    pgl = R.generated_group((translation, extension_translation, inversion, dilation))
    assert len(psl) == 360 and len(pgl) == 720
    return pgl, psl


def q9_replay():
    pgl, psl = q9_generator_groups()
    objects = list(R.matchings(tuple(range(10))))
    full_parts = R.partition(pgl, objects)
    sizes = Counter(len(part) for part in full_parts)
    assert len(objects) == 945
    assert sizes == Counter({180: 3, 72: 2, 90: 2, 36: 1, 45: 1})
    assert all(len(R.partition(psl, part)) == 1 for part in full_parts)


def q13_replay():
    q = 13
    pgl, psl = R.groups(q)
    objects = list(R.matchings(tuple(range(q + 1))))
    full_parts = R.partition(pgl, objects)
    split = [
        len(part)
        for part in full_parts
        if len(R.partition(psl, part)) == 2
    ]
    assert len(objects) == 135135
    assert len(full_parts) == 128
    assert Counter(split) == Counter({364: 1, 1092: 10, 2184: 21})
    assert 253 < min(split)


def square_summary(q, representative):
    pgl, psl = R.groups(q)
    full_orbit = R.partition(pgl, {representative})[0]
    special_parts = R.partition(psl, full_orbit)
    ordered = sorted(full_orbit)
    base_product = R.secant_product(ordered[0], q)
    points = []
    for matching in ordered:
        product = R.secant_product(matching, q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % q
            for exponent in set(product) | set(base_product)
        }
        points.append(R.quotient_coefficients(difference, (q - 3) // 2, q))
    rows = R.independent_rows(
        [[1] * len(points)] + [list(column) for column in zip(*points)], q
    )
    square = [
        [a * b % q for a, b in zip(rows[i], rows[j])]
        for i in range(len(rows))
        for j in range(i, len(rows))
    ]
    rank = R.matrix_rank(square, q)
    return len(full_orbit), sorted(len(x) for x in special_parts), len(rows), rank


Q17 = (
    ((0, 1), (2, 7), (3, 4), (5, 10), (6, 9), (8, 13), (11, 12), (14, 15), (16, 17)),
    ((0, 1), (2, 3), (4, 5), (6, 16), (7, 13), (8, 14), (9, 15), (10, 12), (11, 17)),
    ((0, 1), (2, 4), (3, 10), (5, 12), (6, 16), (7, 9), (8, 17), (11, 14), (13, 15)),
)

Q19 = (
    (0, 1),
    (2, 10),
    (3, 14),
    (4, 8),
    (5, 17),
    (6, 18),
    (7, 16),
    (9, 15),
    (11, 12),
    (13, 19),
)


def main():
    q9_replay()
    q13_replay()
    q17 = [square_summary(17, representative) for representative in Q17]
    assert q17 == [
        (204, [102, 102], 16, 120),
        (408, [204, 204], 23, 215),
        (612, [306, 306], 27, 324),
    ]
    assert square_summary(19, Q19) == (114, [57, 57], 32, 100)
    print("C665 Platinum independent replay: OK")


if __name__ == "__main__":
    main()
