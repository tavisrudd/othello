"""Pairwise sums of the six outer cubics of the order-six conference matrix.

For the fixed order-six integral conference matrix C, let Z(x) be its oriented
triangle cubic and let the six outer cubics be the signed translates

    Z_t(x) = sgn(p_t) * Z(x . p_t),

where p_0, ..., p_5 are the six reorderings fixing the labels 0, 1, 2 and
permuting 3, 4, 5.  These are the coordinates proved in Lean
(RelativeConicArcs.ClebschOuterSegreRelations) to satisfy the two Segre
equations.

This script checks a separate exact statement about them: each of the fifteen
pairwise sums Z_a + Z_b equals +/-2 times the product of the three coordinate
differences of one perfect matching of the six labels, and the fifteen
matchings so obtained are distinct, so the fifteen pairs of outer cubics are in
bijection with the fifteen perfect matchings.  All arithmetic is exact
polynomial expansion over the integers.

Replay:  uv run --with sympy python3 notes/2026-08-05-c815-outer-pair-matchings.py
"""

import itertools

import sympy as sp

CONFERENCE = [
    [0, 1, 1, 1, -1, -1],
    [1, 0, -1, -1, -1, -1],
    [1, -1, 0, 1, 1, -1],
    [1, -1, 1, 0, -1, 1],
    [-1, -1, 1, -1, 0, -1],
    [-1, -1, -1, 1, -1, 0],
]

X = sp.symbols("x0:6")


def triangle_cubic(reindex):
    """The oriented triangle cubic evaluated on the reordered coordinates."""
    return sp.expand(
        sum(
            CONFERENCE[i][j] * CONFERENCE[j][k] * CONFERENCE[k][i]
            * X[reindex[i]] * X[reindex[j]] * X[reindex[k]]
            for i, j, k in itertools.combinations(range(6), 3)
        )
    )


def sign(reindex):
    return (-1) ** sum(
        1 for i in range(6) for j in range(i + 1, 6) if reindex[i] > reindex[j]
    )


def perfect_matchings(labels):
    if not labels:
        yield []
        return
    first = labels[0]
    for i in range(1, len(labels)):
        for rest in perfect_matchings(labels[1:i] + labels[i + 1:]):
            yield [(first, labels[i])] + rest


def main() -> int:
    reindexings = [(0, 1, 2) + tail for tail in itertools.permutations((3, 4, 5))]
    outer = [sign(p) * triangle_cubic(p) for p in reindexings]

    linear = sp.expand(sum(outer))
    cubic = sp.expand(sum(z ** 3 for z in outer))
    print(f"sum of the six outer cubics: {linear}")
    print(f"sum of their cubes:          {cubic}")
    assert linear == 0 and cubic == 0

    products = {
        tuple(m): sp.expand(sp.prod([X[a] - X[b] for a, b in m]))
        for m in perfect_matchings(list(range(6)))
    }
    assert len(products) == 15

    used = set()
    for a, b in itertools.combinations(range(6), 2):
        total = sp.expand(outer[a] + outer[b])
        hits = [
            (m, c)
            for m, product in products.items()
            for c in (2, -2)
            if sp.expand(total - c * product) == 0
        ]
        assert len(hits) == 1, (a, b, hits)
        matching, coefficient = hits[0]
        used.add(matching)
        pairs = " ".join(f"({i}{j})" for i, j in matching)
        print(f"Z{a} + Z{b} = {coefficient:+d} * {pairs}")

    assert len(used) == 15
    print("all fifteen pairs hit distinct perfect matchings")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
