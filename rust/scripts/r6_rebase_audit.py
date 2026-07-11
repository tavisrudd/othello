#!/usr/bin/env python3
"""Exact q=11 audit of PGL involution rebases for the round-5 collision.

The criterion and four positions are fixed before any P/N label is mentioned.
All involutions of an eight-set with zero or two fixed points are enumerated:
105 + 28*15 = 525 permutations.  Run from rust/:

    python3 scripts/r6_rebase_audit.py
"""

from itertools import combinations
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from r5_q11_voltage_signature import det, inverse3, norm


Q = 11
IDENTITY = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
NAMES = ("C0", "C1", "C-1", "C4", "C-4", "za", "x", "y")


def matmul(a, b):
    return tuple(tuple(sum(a[i][k]*b[k][j] for k in range(3)) % Q
                       for j in range(3)) for i in range(3))


def matvec(a, v):
    return tuple(sum(a[i][k]*v[k] for k in range(3)) % Q for i in range(3))


def canonical_matrix(a):
    pivot = next(x for row in a for x in row if x % Q)
    scale = pow(pivot, Q-2, Q)
    return tuple(tuple(x*scale % Q for x in row) for row in a)


def frame_normalizer(points):
    columns = tuple(tuple(points[j][i] for j in range(3)) for i in range(3))
    inverse = inverse3(columns, Q)
    coefficients = matvec(inverse, points[3])
    assert all(coefficients)
    return tuple(tuple(pow(coefficients[i], Q-2, Q)*inverse[i][j] % Q
                       for j in range(3)) for i in range(3))


def involutive_permutations(n=8):
    def visit(remaining, permutation):
        if not remaining:
            yield tuple(permutation)
            return
        i = remaining[0]
        permutation[i] = i
        yield from visit(remaining[1:], permutation)
        permutation[i] = -1
        for position in range(1, len(remaining)):
            j = remaining[position]
            permutation[i] = j
            permutation[j] = i
            yield from visit(remaining[1:position] + remaining[position+1:], permutation)
            permutation[i] = permutation[j] = -1

    for permutation in visit(list(range(n)), [-1]*n):
        fixed = sum(permutation[i] == i for i in range(n))
        if fixed in (0, 2):
            yield permutation


PERMUTATIONS = tuple(involutive_permutations())
assert len(PERMUTATIONS) == 525
assert sum(all(p[i] != i for i in range(8)) for p in PERMUTATIONS) == 105
assert sum(sum(p[i] == i for i in range(8)) == 2 for p in PERMUTATIONS) == 420


def projective_points():
    points = set()
    for x in range(Q):
        for y in range(Q):
            for z in range(Q):
                if (x, y, z) != (0, 0, 0):
                    points.add(norm((x, y, z), Q))
    assert len(points) == Q*Q+Q+1
    return tuple(sorted(points))


PG = projective_points()


def is_cap(points):
    return len(set(points)) == len(points) and all(
        det(a, b, c, Q) != 0 for a, b, c in combinations(points, 3)
    )


def legal_over(point, selected):
    return point not in selected and all(
        det(point, a, b, Q) != 0 for a, b in combinations(selected, 2)
    )


def cycles(permutation):
    result = []
    seen = set()
    for i, j in enumerate(permutation):
        if i in seen:
            continue
        cycle = (i,) if i == j else (i, j)
        result.append("(" + " ".join(NAMES[k] for k in cycle) + ")")
        seen.update(cycle)
    return "".join(result)


def rebase_involutions(selected):
    assert len(selected) == 8 and is_cap(selected)
    source = frame_normalizer(selected[:4])
    results = {}
    for permutation in PERMUTATIONS:
        target_points = tuple(selected[permutation[i]] for i in range(4))
        target = frame_normalizer(target_points)
        matrix = canonical_matrix(matmul(inverse3(target, Q), source))
        assert all(norm(matvec(matrix, selected[i]), Q) == selected[permutation[i]]
                   for i in range(4))
        if not all(norm(matvec(matrix, selected[i]), Q) == selected[permutation[i]]
                   for i in range(8)):
            continue
        assert canonical_matrix(matmul(matrix, matrix)) == IDENTITY
        assert matrix != IDENTITY
        fixed_points = tuple(point for point in PG
                             if norm(matvec(matrix, point), Q) == point)
        legal_fixed = tuple(point for point in fixed_points if legal_over(point, selected))
        fixed_on_cap = tuple(i for i in range(8) if permutation[i] == i)
        results[matrix] = (permutation, fixed_on_cap, fixed_points, legal_fixed)
    return results


def conic(t):
    return norm((t*t, t, 1), Q)


def base_cap(a):
    selected = (conic(0), conic(1), conic(-1), conic(4), conic(-4),
                norm((-a, 0, 1), Q))
    assert is_cap(selected)
    return selected


CASES = {9: ((3, 8), (8, 3)), 5: ((3, 10), (8, 1))}


def main():
    print("permutations total=525 free_on_T=105 two_fixed=420")
    total_rebases = 0
    total_free_on_cap = 0
    for a, expected_pairs in CASES.items():
        base = base_cap(a)
        live_p = tuple(p for p in range(Q)
                       if legal_over(norm((0, 1, p), Q), base))
        live_q = tuple(q for q in range(Q)
                       if legal_over(norm((-a*q, 1, q), Q), base))
        compatible = tuple((p, q) for p in live_p for q in live_q
                           if is_cap(base + (norm((0, 1, p), Q),
                                             norm((-a*q, 1, q), Q))))
        assert compatible == expected_pairs
        print(f"a={a} live_p={live_p} live_q={live_q} compatible={compatible}")
        for p, q in compatible:
            x = norm((0, 1, p), Q)
            y = norm((-a*q, 1, q), Q)
            selected = base + (x, y)
            rebases = rebase_involutions(selected)
            assert len(rebases) == 1
            matrix, (permutation, fixed_on_cap, fixed_points, legal_fixed) = next(
                iter(rebases.items())
            )
            assert len(fixed_on_cap) == 2
            assert not legal_fixed
            assert len(fixed_points) == Q+2
            total_rebases += 1
            total_free_on_cap += not fixed_on_cap
            print(f"  pair=({p},{q}) rebases=1 free_on_T=0 legal_fixed=0 "
                  f"cycles={cycles(permutation)} H={matrix}")
    assert total_rebases == 4 and total_free_on_cap == 0
    print("SUMMARY cases=4 unique_rebases=4 free_on_T_rebases=0 all_assertions=PASS")


if __name__ == "__main__":
    main()
