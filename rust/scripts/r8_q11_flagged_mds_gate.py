#!/usr/bin/env python3
"""Label-free replay of the round-8 q=11 flagged-MDS calculations.

The two centers and compatible boundary pairs are the frozen round-6 collision
inputs.  This script performs no game solve and reads no P/N label.  Run from
rust/:

    python3 scripts/r8_q11_flagged_mds_gate.py
"""

from collections import Counter
from itertools import combinations
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import r5_q11_voltage_signature as R


Q = 11
BOUNDARY_PAIRS = {
    9: ((3, 8), (8, 3)),
    5: ((3, 10), (8, 1)),
}


def rank_mod(rows):
    matrix = [[entry % Q for entry in row] for row in rows]
    if not matrix:
        return 0
    nrows, ncols = len(matrix), len(matrix[0])
    pivot_row = 0
    for column in range(ncols):
        pivot = next(
            (row for row in range(pivot_row, nrows) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        scale = pow(matrix[pivot_row][column], -1, Q)
        matrix[pivot_row] = [entry * scale % Q for entry in matrix[pivot_row]]
        for row in range(nrows):
            if row == pivot_row or not matrix[row][column]:
                continue
            factor = matrix[row][column]
            matrix[row] = [
                (left - factor * right) % Q
                for left, right in zip(matrix[row], matrix[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == nrows:
            break
    return pivot_row


def schur_square_dim(columns):
    generator_rows = list(zip(*columns))
    products = [
        tuple(generator_rows[i][k] * generator_rows[j][k] % Q for k in range(len(columns)))
        for i in range(3)
        for j in range(i, 3)
    ]
    return rank_mod(products)


def conic(t):
    return R.norm((t * t, t, 1), Q)


def center(a):
    return R.norm((-a, 0, 1), Q)


def six_cap(a):
    return (conic(0), conic(1), conic(-1), conic(4), conic(-4), center(a))


def is_arc(points):
    return all(R.det(x, y, z, Q) for x, y, z in combinations(points, 3))


def legal(point, points):
    return point not in points and all(
        R.det(point, x, y, Q) for x, y in combinations(points, 2)
    )


def boundary_x(parameter):
    return R.norm((0, 1, parameter), Q)


def boundary_y(a, parameter):
    return R.norm((-a * parameter, 1, parameter), Q)


def main():
    conic_infinity = R.norm((1, 0, 0), Q)
    for a in (9, 5):
        base = six_cap(a)
        assert is_arc(base)
        square_dim = schur_square_dim(base)
        puncture_profile = tuple(
            schur_square_dim(base[:index] + base[index + 1:])
            for index in range(len(base))
        )
        extensions = tuple(
            t for t in range(Q) if legal(conic(t), base)
        )
        infinity_legal = legal(conic_infinity, base)
        print(
            f"BASE a={a} schur_dim={square_dim} "
            f"puncture_profile={puncture_profile}"
        )
        print(
            f"EXTENSIONS a={a} finite={extensions} count={len(extensions)} "
            f"infinity_legal={infinity_legal}"
        )
        assert square_dim == 6
        assert puncture_profile == (5, 5, 5, 5, 5, 5)
        assert not infinity_legal

        for p, d in BOUNDARY_PAIRS[a]:
            eight = base + (boundary_x(p), boundary_y(a, d))
            assert is_arc(eight)
            six_profile = Counter(
                schur_square_dim(tuple(eight[index] for index in subset))
                for subset in combinations(range(8), 6)
            )
            seven_conics = sum(
                schur_square_dim(tuple(eight[index] for index in subset)) == 5
                for subset in combinations(range(8), 7)
            )
            print(
                f"PAIR a={a} pair=({p},{d}) six_profile={dict(sorted(six_profile.items()))} "
                f"seven_conic_subsets={seven_conics}"
            )

    assert tuple(t for t in range(Q) if legal(conic(t), six_cap(9))) == (3, 8)
    assert tuple(t for t in range(Q) if legal(conic(t), six_cap(5))) == (2, 3, 8, 9)
    print("SUMMARY all_assertions=PASS")


if __name__ == "__main__":
    main()
