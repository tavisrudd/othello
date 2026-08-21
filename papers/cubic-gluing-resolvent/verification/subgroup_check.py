#!/usr/bin/env python3
"""Independent finite quotient check for the three level-six subgroups."""

from __future__ import annotations

import argparse
import itertools
from pathlib import Path


def determinant(matrix: tuple[int, int, int, int], modulus: int) -> int:
    a, b, c, d = matrix
    return (a * d - b * c) % modulus


def mod2_action(matrix: tuple[int, int, int, int]) -> tuple[int, int, int]:
    a, b, c, d = (entry % 2 for entry in matrix)
    vectors = ((1, 0), (0, 1), (1, 1))
    images = []
    for x, y in vectors:
        image = ((a * x + b * y) % 2, (c * x + d * y) % 2)
        images.append(vectors.index(image))
    return tuple(images)


def sign(permutation: tuple[int, int, int]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(3)
        for j in range(i + 1, 3)
    )
    return -1 if inversions % 2 else 1


def main() -> str:
    matrices = [
        matrix
        for matrix in itertools.product(range(6), repeat=4)
        if determinant(matrix, 6) == 1 and matrix[2] % 3 == 0
    ]
    images = {mod2_action(matrix) for matrix in matrices}
    sign_kernel = [matrix for matrix in matrices if sign(mod2_action(matrix)) == 1]
    point_kernel = [matrix for matrix in matrices if mod2_action(matrix)[0] == 0]
    split_kernel = [matrix for matrix in matrices if mod2_action(matrix) == (0, 1, 2)]
    gamma0_6 = [matrix for matrix in matrices if matrix[2] % 6 == 0]
    intersection = [matrix for matrix in sign_kernel if matrix in point_kernel]

    assert len(matrices) == 36
    assert len(images) == 6
    assert len(sign_kernel) == 18
    assert len(point_kernel) == 12
    assert len(split_kernel) == 6
    assert set(point_kernel) == set(gamma0_6)
    assert set(intersection) == set(split_kernel)

    return (
        "Gamma0(3) mod 6: 36 elements; mod-2 image S3 has order 6\n"
        "sign/root/split indices in Gamma0(3): 2, 3, 6\n"
        "root subgroup equals Gamma0(6) mod 6\n"
        "sign intersection root equals split kernel\n"
        "over the sign cover the root packet is regular cyclic C3\n"
        "PASS\n"
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    output = main()
    if args.check is not None and output != args.check.read_text():
        raise SystemExit("subgroup output differs from checked fixture")
    print(output, end="")
