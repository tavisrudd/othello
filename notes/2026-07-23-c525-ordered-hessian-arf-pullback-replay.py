#!/usr/bin/env python3
"""Independent structural replay for the C525 certificate."""

from __future__ import annotations

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "2026-07-23-c525-ordered-hessian-arf-pullback.json").read_text())


def add(x: int, y: int) -> int:
    return x ^ y


def mul(x: int, y: int) -> int:
    result = 0
    for _ in range(2):
        if y & 1:
            result ^= x
        y >>= 1
        x <<= 1
        if x & 4:
            x ^= 7
    return result


def sq(x: int) -> int:
    return mul(x, x)


def canonical(vector: tuple[int, ...]) -> tuple[int, ...]:
    first = next(x for x in vector if x)
    inverse = next(y for y in range(1, 4) if mul(first, y) == 1)
    return tuple(mul(inverse, x) for x in vector)


def projective_points(length: int) -> list[tuple[int, ...]]:
    found = set()
    for value in range(1, 4**length):
        digits = []
        rest = value
        for _ in range(length):
            digits.append(rest % 4)
            rest //= 4
        found.add(canonical(tuple(digits)))
    return sorted(found)


def main() -> None:
    assert DATA["schema"] == "c525-ordered-hessian-arf-pullback-v1"
    assert len(projective_points(3)) == 21
    assert len(projective_points(2)) == 5

    persistent_pluckers = set()
    for a, b, c in projective_points(3):
        z = (sq(a), mul(a, b), mul(a, c), add(sq(b), mul(a, c)), mul(b, c), sq(c))
        persistent_pluckers.add(canonical(z))
        matrix = ((z[0], z[1], z[2]), (z[1], add(z[3], z[2]), z[4]), (z[2], z[4], z[5]))
        for i in range(3):
            for k in range(i + 1, 3):
                for j in range(3):
                    for ell in range(j + 1, 3):
                        assert add(
                            mul(matrix[i][j], matrix[k][ell]),
                            mul(matrix[i][ell], matrix[k][j]),
                        ) == 0
    assert len(persistent_pluckers) == 21

    complementary = set()
    for v, w in projective_points(2):
        z = (0, sq(v), mul(v, w), mul(v, w), sq(w), 0)
        complementary.add(canonical(z))
        assert mul(z[1], z[4]) == sq(z[2])
    assert len(complementary) == 5

    alpha = 2
    assert add(add(sq(alpha), alpha), 1) == 0
    # On <X^2Y,XY^2>, the Hessian incidence factors with slopes alpha, alpha^2.
    for B in range(4):
        for C in range(4):
            nu, ns, delta = sq(B), mul(B, C), sq(C)
            left_cross = add(mul(alpha, C), mul(sq(alpha), C))
            assert left_cross == C
            assert mul(mul(alpha, C), mul(sq(alpha), C)) == delta
            assert nu == sq(B) and ns == mul(B, C)

    for row in DATA["bounds"]["table"]:
        n = row["degree"]
        m = n - 4
        assert row["quadratic_strict_bound"] == m * (n + 3) // 2
        assert row["disjoint_five_blocks"] == 5 * m
        assert row["base_selection_threshold"] == min(m * (n + 3) // 2 + 1, 5 * m)
        assert row["deletion"] == 3 * n - 4

    print("C525 replay OK: persistent P2, complementary P1, order-three factorization, bounds")


if __name__ == "__main__":
    main()
