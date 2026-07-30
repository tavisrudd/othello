#!/usr/bin/env python3
"""Independent modular replay of the C697 gauge-rank and orientation claims."""

from __future__ import annotations

import itertools


def modular_rank(matrix, prime):
    work = [[value % prime for value in row] for row in matrix]
    row = 0
    for column in range(len(work[0])):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, prime)
        work[row] = [value * inverse % prime for value in work[row]]
        for index in range(len(work)):
            if index == row:
                continue
            scale = work[index][column]
            work[index] = [
                (left - scale * right) % prime
                for left, right in zip(work[index], work[row], strict=True)
            ]
        row += 1
    return row


def matchings(values):
    if not values:
        yield ()
        return
    first = values[0]
    for position in range(1, len(values)):
        second = values[position]
        remainder = values[1:position] + values[position + 1 :]
        for tail in matchings(remainder):
            yield ((min(first, second), max(first, second)),) + tail


def inversion_sign(permutation):
    count = sum(
        left > right
        for index, left in enumerate(permutation)
        for right in permutation[index + 1 :]
    )
    return (-1) ** count


def main():
    indices = tuple(range(6))
    vertices = (
        [("x", i) for i in indices]
        + [("y", i) for i in indices]
        + [("w", i, j) for i, j in itertools.combinations(indices, 2)]
    )
    edges = [
        (("x", i), ("y", j), ("w", min(i, j), max(i, j)))
        for i in indices
        for j in indices
        if i != j
    ]
    edges.extend(
        tuple(("w", i, j) for i, j in matching)
        for matching in matchings(indices)
    )
    matrix = [[int(vertex in edge) for vertex in vertices] for edge in edges]
    assert (len(edges), len(vertices)) == (45, 27)
    ranks = {prime: modular_rank(matrix, prime) for prime in (2, 3, 5, 7, 11)}
    assert set(ranks.values()) == {21}

    signs = {}
    for exponent in (1, 2, 3, 4):
        permutation = (0,) + tuple(
            1 + exponent * power % 5 for power in range(5)
        )
        signs[exponent] = inversion_sign(permutation)
    assert signs == {1: 1, 2: -1, 3: -1, 4: 1}
    print(
        "PASS independent C697 replay "
        f"ranks={ranks} orientation_signs={signs}"
    )


if __name__ == "__main__":
    main()
