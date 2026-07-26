#!/usr/bin/env python3
"""Find explicit projective normalizations for the C637 q=13,17 witnesses."""

import json
import sys


def normalize_witness(path):
    data = json.load(open(path, encoding="ascii"))
    q = data["q"]
    coeff = {
        13: (6, 5, 5, 6, 6, 1),
        17: (8, 5, 6, 10, 7, 1),
    }[q]

    def inv(x):
        return pow(x, q - 2, q)

    def norm(v):
        z = inv(next(x for x in v if x))
        return tuple(z * x % q for x in v)

    def qeval(v):
        x, y, z = v
        row = (x * x, y * y, z * z, x * y, x * z, y * z)
        return sum(a * b for a, b in zip(coeff, row)) % q

    def standard(v):
        return (v[0] * v[2] - v[1] * v[1]) % q

    def matmul(a, b):
        return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(3)) % q
                           for j in range(3)) for i in range(3))

    def matvec(a, v):
        return tuple(sum(a[i][j] * v[j] for j in range(3)) % q for i in range(3))

    def inverse(a):
        aug = [list(a[i]) + [int(i == j) for j in range(3)] for i in range(3)]
        for col in range(3):
            pivot = next(i for i in range(col, 3) if aug[i][col])
            aug[col], aug[pivot] = aug[pivot], aug[col]
            z = inv(aug[col][col])
            aug[col] = [z * x % q for x in aug[col]]
            for i in range(3):
                if i != col and aug[i][col]:
                    w = aug[i][col]
                    aug[i] = [(x - w * y) % q for x, y in zip(aug[i], aug[col])]
        return tuple(tuple(row[3:]) for row in aug)

    points = sorted({
        norm((x, y, z))
        for x in range(q) for y in range(q) for z in range(q)
        if x or y or z
    })
    source = [p for p in points if qeval(p) == 0]
    target = [p for p in points if standard(p) == 0]
    u = tuple(tuple(source[j][i] for j in range(3)) for i in range(3))
    u_inv = inverse(u)
    matrix = None
    for a in target:
        for b in target:
            if b == a:
                continue
            for c in target:
                if c == a or c == b:
                    continue
                for sb in range(1, q):
                    for sc in range(1, q):
                        columns = (a, tuple(sb * x % q for x in b),
                                   tuple(sc * x % q for x in c))
                        target_matrix = tuple(
                            tuple(columns[j][i] for j in range(3)) for i in range(3)
                        )
                        candidate = matmul(target_matrix, u_inv)
                        if all(standard(matvec(candidate, p)) == 0 for p in source):
                            matrix = candidate
                            break
                    if matrix is not None:
                        break
                if matrix is not None:
                    break
            if matrix is not None:
                break
        if matrix is not None:
            break
    assert matrix is not None
    raw_transformed = [matvec(matrix, tuple(p)) for p in data["arc"]]
    transformed = [norm(p) for p in raw_transformed]
    assert all(standard(p) for p in transformed)
    return {
        "q": q,
        "matrix": matrix,
        "raw_transformed_arc": raw_transformed,
        "transformed_arc": transformed,
    }


def main():
    if len(sys.argv) != 4:
        raise SystemExit("usage: normalizations.py OUTPUT.json Q13.json Q17.json")
    result = {
        "schema": "c637-conic-normalizations-v1",
        "normalizations": [normalize_witness(path) for path in sys.argv[2:]],
    }
    with open(sys.argv[1], "w", encoding="ascii") as out:
        json.dump(result, out, separators=(",", ":"), sort_keys=True)
        out.write("\n")


if __name__ == "__main__":
    main()
