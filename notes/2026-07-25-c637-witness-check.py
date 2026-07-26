#!/usr/bin/env python3
"""Independent verifier for a C637 relative-conic witness JSON file."""

from itertools import combinations, product
import json
import sys


def verify(path):
    data = json.load(open(path, encoding="ascii"))
    q = data["q"]
    arc_points = [tuple(p) for p in data["arc"]]

    def inv(x):
        return pow(x, q - 2, q)

    def norm(p):
        z = inv(next(x for x in p if x))
        return tuple(z * x % q for x in p)

    def det(a, b, c):
        return (
            a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])
        ) % q

    def qrow(p):
        x, y, z = p
        return (x * x % q, y * y % q, z * z % q,
                x * y % q, x * z % q, y * z % q)

    def nullspace(rows):
        a = [list(row) for row in rows]
        pivots = []
        r = 0
        for col in range(6):
            pivot = next((i for i in range(r, len(a)) if a[i][col]), None)
            if pivot is None:
                continue
            a[r], a[pivot] = a[pivot], a[r]
            z = inv(a[r][col])
            a[r] = [(z * x) % q for x in a[r]]
            for i in range(len(a)):
                if i != r and a[i][col]:
                    w = a[i][col]
                    a[i] = [(x - w * y) % q for x, y in zip(a[i], a[r])]
            pivots.append(col)
            r += 1
        free = [col for col in range(6) if col not in pivots]
        basis = []
        for col in free:
            v = [0] * 6
            v[col] = 1
            for i, pivot in enumerate(pivots):
                v[pivot] = -a[i][col] % q
            basis.append(tuple(v))
        return basis

    points = sorted({
        norm((x, y, z))
        for x in range(q) for y in range(q) for z in range(q)
        if x or y or z
    })
    point_set = set(points)
    assert len(arc_points) == data["k"]
    assert len(set(arc_points)) == len(arc_points)
    assert set(arc_points) <= point_set
    assert all(det(a, b, c) for a, b, c in combinations(arc_points, 3))

    uncovered = [
        p for p in points
        if p not in arc_points
        and all(det(a, b, p) for a, b in combinations(arc_points, 2))
    ]
    basis = nullspace([qrow(p) for p in uncovered])
    conic = None
    for pivot in range(len(basis)):
        for tail in product(range(q), repeat=len(basis) - pivot - 1):
            coordinates = [0] * len(basis)
            coordinates[pivot] = 1
            coordinates[pivot + 1:] = tail
            form = tuple(
                sum(coordinates[i] * basis[i][j] for i in range(len(basis))) % q
                for j in range(6)
            )
            zeros = [
                p for p in points
                if sum(x * y for x, y in zip(form, qrow(p))) % q == 0
            ]
            if (
                len(zeros) == q + 1
                and not set(arc_points) & set(zeros)
                and all(det(a, b, c) for a, b, c in combinations(zeros, 3))
            ):
                conic = form
                break
        if conic is not None:
            break
    assert conic is not None
    return {
        "input": path,
        "q": q,
        "k": len(arc_points),
        "ordinary_uncovered": len(uncovered),
        "quadratic_nullity": len(basis),
        "avoiding_nonsingular_conic": list(conic),
        "verdict": "verified",
    }


def main():
    if len(sys.argv) < 3:
        raise SystemExit("usage: witness-check.py OUTPUT.json INPUT.json...")
    result = {
        "schema": "secant-hull-witness-check-v1",
        "checks": [verify(path) for path in sys.argv[2:]],
    }
    with open(sys.argv[1], "w", encoding="ascii") as out:
        json.dump(result, out, separators=(",", ":"), sort_keys=True)
        out.write("\n")


if __name__ == "__main__":
    main()
