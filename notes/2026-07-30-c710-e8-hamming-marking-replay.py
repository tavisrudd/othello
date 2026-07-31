#!/usr/bin/env python3
"""Independent hard-coded replay for the C710 isometry and minor obstruction."""

from __future__ import annotations

from itertools import combinations


ROOTS = (
    (2, 0, 0, 0, 0, 0, 0, 0),
    (-1, -1, 0, 0, 0, 0, -1, -1),
    (0, 2, 0, 0, 0, 0, 0, 0),
    (0, -1, -1, 0, 0, -1, 1, 0),
    (0, 0, 2, 0, 0, 0, 0, 0),
    (0, 0, -1, -1, 0, 0, -1, 1),
    (0, 0, -1, 1, -1, 1, 0, 0),
    (0, 0, 0, 0, 2, 0, 0, 0),
)
EDGES = ((0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (4, 6), (6, 7))
R10_CHECKS = tuple(
    int(row, 2)
    for row in (
        "1100110000",
        "1110001000",
        "0111000100",
        "0011100010",
        "1001100001",
    )
)


def dot(left, right):
    return sum(a * b for a, b in zip(left, right))


def delete_bit(word, coordinate):
    return (word & ((1 << coordinate) - 1)) | (
        (word >> (coordinate + 1)) << coordinate
    )


def minor(code, operations):
    result = code
    for coordinate, shorten in sorted(operations, reverse=True):
        result = {
            delete_bit(word, coordinate)
            for word in result
            if not shorten or not ((word >> coordinate) & 1)
        }
    return result


def parameters(code):
    return (
        len(code).bit_length() - 1,
        min(word.bit_count() for word in code if word),
    )


def main():
    gram = [
        [dot(left, right) // 2 for right in ROOTS] for left in ROOTS
    ]
    assert all(gram[i][i] == 2 for i in range(8))
    assert all(
        gram[i][j] == (-1 if (i, j) in EDGES or (j, i) in EDGES else 0)
        for i in range(8)
        for j in range(8)
        if i != j
    )

    code = {
        word
        for word in range(1 << 10)
        if all((word & check).bit_count() % 2 == 0 for check in R10_CHECKS)
    }
    counts = {"PP": 0, "SS": 0, "SP": 0}
    for left, right in combinations(range(10), 2):
        assert parameters(minor(code, ((left, False), (right, False)))) == (5, 2)
        counts["PP"] += 1
        assert parameters(minor(code, ((left, True), (right, True)))) == (3, 4)
        counts["SS"] += 1
        for operations in (
            ((left, True), (right, False)),
            ((left, False), (right, True)),
        ):
            candidate = minor(code, operations)
            assert parameters(candidate) == (4, 3)
            assert any(word.bit_count() == 3 for word in candidate)
            counts["SP"] += 1
    assert counts == {"PP": 45, "SS": 45, "SP": 90}
    print("C710 independent root/minor replay: PASS")


if __name__ == "__main__":
    main()
