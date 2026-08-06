#!/usr/bin/env python3
"""Exact A3/H3 arrangement checks used in the Clebsch-code synthesis.

The checker is standard-library-only and fail-closed.  It verifies the displayed
H3 root directions over F_11, their full intersection spectrum, the explicit
projectivity to the paper's Clebsch hexagon, the induced equality between the
fifteen mirrors and fifteen secants, and the A3 four-frame model over F_5.
"""

from __future__ import annotations

from collections import Counter
from itertools import combinations, product
from typing import Iterable


Point = tuple[int, int, int]
Matrix = tuple[Point, Point, Point]


def inv(value: int, q: int) -> int:
    assert value % q
    return pow(value, -1, q)


def normalize(vector: Point, q: int) -> Point:
    pivot = next(value for value in vector if value % q)
    scale = inv(pivot, q)
    return tuple(value * scale % q for value in vector)  # type: ignore[return-value]


def projective_points(q: int) -> list[Point]:
    points = (
        [(1, y, z) for y in range(q) for z in range(q)]
        + [(0, 1, z) for z in range(q)]
        + [(0, 0, 1)]
    )
    assert len(points) == q * q + q + 1
    return points


def dot(left: Point, right: Point, q: int) -> int:
    return sum(a * b for a, b in zip(left, right)) % q


def cross(left: Point, right: Point, q: int) -> Point:
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        ),
        q,
    )


def matrix_vector(matrix: Matrix, vector: Point, q: int) -> Point:
    return tuple(
        sum(matrix[row][column] * vector[column] for column in range(3)) % q
        for row in range(3)
    )  # type: ignore[return-value]


def matrix_multiply(left: Matrix, right: Matrix, q: int) -> Matrix:
    return tuple(
        tuple(
            sum(left[row][k] * right[k][column] for k in range(3)) % q
            for column in range(3)
        )
        for row in range(3)
    )  # type: ignore[return-value]


def matrix_inverse(matrix: Matrix, q: int) -> Matrix:
    augmented = [
        list(matrix[row]) + [int(row == column) for column in range(3)]
        for row in range(3)
    ]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if augmented[row][column] % q)
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = inv(augmented[column][column] % q, q)
        augmented[column] = [value * scale % q for value in augmented[column]]
        for row in range(3):
            if row == column:
                continue
            scale = augmented[row][column]
            augmented[row] = [
                (value - scale * pivot_value) % q
                for value, pivot_value in zip(augmented[row], augmented[column])
            ]
    return tuple(tuple(row[3:]) for row in augmented)  # type: ignore[return-value]


def row_matrix(line: Point) -> Matrix:
    return (line, (0, 0, 0), (0, 0, 0))


def transform_line(line: Point, inverse_matrix: Matrix, q: int) -> Point:
    # Points transform by x |-> T x, so row-vector line equations transform by T^{-1}.
    return normalize(matrix_multiply(row_matrix(line), inverse_matrix, q)[0], q)


def line_arrangement_spectrum(lines: Iterable[Point], q: int) -> tuple[Counter[int], dict[Point, int]]:
    line_set = set(lines)
    multiplicity = {
        point: sum(dot(line, point, q) == 0 for line in line_set)
        for point in projective_points(q)
    }
    return Counter(multiplicity.values()), multiplicity


def h3_mirrors(q: int, tau: int) -> set[Point]:
    """The 15 projective positive-root directions of H3.

    Besides the three coordinate roots, use cyclic permutations of
    (1, +/-tau, +/-(tau-1)), where tau^2=tau+1.
    """

    assert (tau * tau - tau - 1) % q == 0
    roots: set[Point] = {(1, 0, 0), (0, 1, 0), (0, 0, 1)}
    for left_sign, right_sign in product((1, -1), repeat=2):
        root = (1, left_sign * tau % q, right_sign * (tau - 1) % q)
        roots.update(
            {
                normalize(root, q),
                normalize((root[1], root[2], root[0]), q),
                normalize((root[2], root[0], root[1]), q),
            }
        )
    assert len(roots) == 15
    return roots


def check_h3() -> None:
    q = 11
    tau = 8
    mirrors = h3_mirrors(q, tau)
    spectrum, multiplicity = line_arrangement_spectrum(mirrors, q)
    assert spectrum == Counter({0: 12, 1: 90, 2: 15, 3: 10, 5: 6})

    quintuple_points = {point for point, value in multiplicity.items() if value == 5}
    expected_quintuple_points = {
        (0, 1, (1 - tau) % q),
        (0, 1, (tau - 1) % q),
        (1, (1 - tau) % q, 0),
        (1, (tau - 1) % q, 0),
        (1, 0, -tau % q),
        (1, 0, tau),
    }
    assert quintuple_points == expected_quintuple_points
    assert {cross(left, right, q) for left, right in combinations(quintuple_points, 2)} == mirrors

    clebsch_arc = {
        (1, 10, 0),
        (1, 9, 1),
        (1, 4, 7),
        (1, 8, 5),
        (0, 1, 4),
        (1, 1, 7),
    }
    projectivity: Matrix = ((2, 3, 8), (10, 6, 9), (2, 2, 5))
    inverse_projectivity = matrix_inverse(projectivity, q)
    assert {
        normalize(matrix_vector(projectivity, point, q), q)
        for point in quintuple_points
    } == clebsch_arc

    transformed_mirrors = {
        transform_line(line, inverse_projectivity, q) for line in mirrors
    }
    clebsch_secants = {
        cross(left, right, q) for left, right in combinations(clebsch_arc, 2)
    }
    assert transformed_mirrors == clebsch_secants

    codimension_two_mobius_sum = 6 * (5 - 1) + 10 * (3 - 1) + 15 * (2 - 1)
    assert codimension_two_mobius_sum == 59
    # chi(t)=t^3-15t^2+59t-45=(t-1)(t-5)(t-9).
    assert all(
        t**3 - 15 * t**2 + 59 * t - 45 == (t - 1) * (t - 5) * (t - 9)
        for t in range(-5, 16)
    )
    assert (q - 5) * (q - 9) == spectrum[0] == 12
    assert {
        "one": (6 + spectrum[1]) * (q - 1),
        "two": spectrum[2] * (q - 1),
        "three": spectrum[3] * (q - 1),
        "twenty": spectrum[0] * (q - 1),
    } == {"one": 960, "two": 150, "three": 100, "twenty": 120}

    # Characteristic five is a lattice-faithful modular reduction, although
    # the real reflection representation is no longer semisimple there.
    modular_spectrum, _ = line_arrangement_spectrum(h3_mirrors(5, 3), 5)
    assert modular_spectrum == Counter({2: 15, 3: 10, 5: 6})


def check_a3() -> None:
    q = 5
    frame = {(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1)}
    joins = {cross(left, right, q) for left, right in combinations(frame, 2)}
    # Essentialize x_i=x_j in K^4 by setting x_4=0.
    braid_mirrors = {
        normalize(line, q)
        for line in ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, -1, 0), (1, 0, -1), (0, 1, -1))
    }
    assert joins == braid_mirrors
    spectrum, multiplicity = line_arrangement_spectrum(joins, q)
    assert spectrum == Counter({0: 6, 1: 18, 2: 3, 3: 4})
    assert {point for point, value in multiplicity.items() if value == 3} == frame
    assert all(
        t**3 - 6 * t**2 + 11 * t - 6 == (t - 1) * (t - 2) * (t - 3)
        for t in range(-5, 16)
    )
    assert (q - 2) * (q - 3) == spectrum[0] == 6


def main() -> None:
    check_h3()
    check_a3()
    print("H3_mirrors=Clebsch_secants_over_F11")
    print("H3_intersection_spectrum=[n0:12,n1:90,n2:15,n3:10,n5:6]")
    print("chi_H3=(t-1)(t-5)(t-9)")
    print("A3_mirrors=four_frame_joins_over_F5")
    print("A3_intersection_spectrum=[n0:6,n1:18,n2:3,n3:4]")
    print("chi_A3=(t-1)(t-2)(t-3)")
    print("REFLECTION_ARRANGEMENTS_PASS")


if __name__ == "__main__":
    main()
