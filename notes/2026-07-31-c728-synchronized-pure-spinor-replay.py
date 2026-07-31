#!/usr/bin/env python3
"""Independent finite replay for the C728 character and Segre identities."""

from __future__ import annotations

import itertools


MATRICES = (
    ((0,1,1,1,1,1),(1,0,-1,-1,1,1),(1,-1,0,1,-1,1),(1,-1,1,0,1,-1),(1,1,-1,1,0,-1),(1,1,1,-1,-1,0)),
    ((0,1,1,1,1,1),(1,0,1,1,-1,-1),(1,1,0,-1,-1,1),(1,1,-1,0,1,-1),(1,-1,-1,1,0,1),(1,-1,1,-1,1,0)),
    ((0,1,1,1,1,1),(1,0,1,-1,1,-1),(1,1,0,1,-1,-1),(1,-1,1,0,-1,1),(1,1,-1,-1,0,1),(1,-1,-1,1,1,0)),
    ((0,1,1,1,1,1),(1,0,-1,1,-1,1),(1,-1,0,1,1,-1),(1,1,1,0,-1,-1),(1,-1,1,-1,0,1),(1,1,-1,-1,1,0)),
    ((0,1,1,1,1,1),(1,0,-1,1,1,-1),(1,-1,0,-1,1,1),(1,1,-1,0,-1,1),(1,1,1,-1,0,-1),(1,-1,1,1,-1,0)),
    ((0,1,1,1,1,1),(1,0,1,-1,-1,1),(1,1,0,-1,1,-1),(1,-1,-1,0,1,1),(1,-1,1,1,0,-1),(1,1,-1,1,-1,0)),
)

# size, sign, chi(A), fixed outer totals, chi(product tangent), chi(Sym^3 A),
# chi(signed outer permutation), chi(signed outer augmentation)
CHARACTERS = (
    (1, 1, 5, 6, 90, 35, 6, 5),
    (15, -1, 3, 0, 0, 13, 0, 1),
    (45, 1, 1, 2, -2, 3, 2, 1),
    (15, -1, -1, 4, -12, -3, -4, -3),
    (40, 1, 2, 0, 0, 5, 0, -1),
    (120, -1, 0, 0, 0, 1, 0, 1),
    (40, 1, -1, 3, 0, 2, 3, 2),
    (90, -1, 1, 2, 2, 1, -2, -1),
    (90, 1, -1, 0, 0, -1, 0, -1),
    (144, 1, 0, 1, 0, 0, 1, 0),
    (120, -1, -1, 1, 0, 0, -1, 0),
)


def pfaffian6(matrix: tuple[tuple[int, ...], ...], point: tuple[int, ...]) -> int:
    def a(i: int, j: int) -> int:
        return (point[i] - point[j]) * matrix[i][j]

    return (
        a(0,1)*a(2,3)*a(4,5)-a(0,1)*a(2,4)*a(3,5)+a(0,1)*a(2,5)*a(3,4)
        -a(0,2)*a(1,3)*a(4,5)+a(0,2)*a(1,4)*a(3,5)-a(0,2)*a(1,5)*a(3,4)
        +a(0,3)*a(1,2)*a(4,5)-a(0,3)*a(1,4)*a(2,5)+a(0,3)*a(1,5)*a(2,4)
        -a(0,4)*a(1,2)*a(3,5)+a(0,4)*a(1,3)*a(2,5)-a(0,4)*a(1,5)*a(2,3)
        +a(0,5)*a(1,2)*a(3,4)-a(0,5)*a(1,3)*a(2,4)+a(0,5)*a(1,4)*a(2,3)
    )


def main() -> None:
    assert sum(row[0] for row in CHARACTERS) == 720
    linear_hom = sum(row[0] * row[2] * row[4] for row in CHARACTERS) // 720
    cubic_permutation_hom = sum(row[0] * row[5] * row[6] for row in CHARACTERS) // 720
    cubic_augmentation_hom = sum(row[0] * row[5] * row[7] for row in CHARACTERS) // 720
    assert (linear_hom, cubic_permutation_hom, cubic_augmentation_hom) == (1, 1, 1)

    # Each top Pfaffian is multiaffine.  Its cube has degree at most three in
    # each variable, so the 4^5 grid below is an interpolation-complete check
    # after fixing the translation gauge x5=0.
    checked = 0
    for first_five in itertools.product(range(4), repeat=5):
        point = first_five + (0,)
        tops = tuple(pfaffian6(matrix, point) for matrix in MATRICES)
        assert sum(tops) == 0
        assert sum(value**3 for value in tops) == 0
        checked += 1
    assert checked == 4**5
    print(
        "C728_REPLAY_OK "
        f"character_inner_products={(linear_hom, cubic_permutation_hom, cubic_augmentation_hom)} "
        f"interpolation_points={checked}"
    )


if __name__ == "__main__":
    main()
