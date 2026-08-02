#!/usr/bin/env python3
"""Independent reduced-orbit replay for C814 complex conference rigidity."""

from __future__ import annotations

import itertools
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-08-02-c814-complex-conference-rigidity.json"
V = tuple(range(5))
E = tuple(itertools.combinations(V, 2))


def edge_index(i: int, j: int) -> int:
    return E.index((min(i, j), max(i, j)))


def tournament_value(bits: tuple[int, ...], i: int, j: int) -> int:
    value = bits[edge_index(i, j)]
    return value if i < j else -value


def fixed_cycle_value(i: int, j: int) -> int:
    cycle = {frozenset(edge) for edge in ((0, 1), (1, 2), (2, 3), (3, 4), (4, 0))}
    return 1 if frozenset((i, j)) in cycle else -1


def regular_tournaments() -> tuple[tuple[int, ...], ...]:
    return tuple(
        bits
        for bits in itertools.product((-1, 1), repeat=10)
        if all(sum(tournament_value(bits, i, j) for j in V if j != i) == 0 for i in V)
    )


def fixed_cycle_has_no_interior_solution(bits: tuple[int, ...]) -> bool:
    parameter: Fraction | None = None
    for i, j in E:
        real_constant = 0
        real_slope = 0
        imaginary = 0
        for k in V:
            if k in (i, j):
                continue
            a = fixed_cycle_value(i, k)
            c = fixed_cycle_value(k, j)
            b = tournament_value(bits, i, k)
            d = tournament_value(bits, k, j)
            real_constant -= b * d
            real_slope += a * c + b * d
            imaginary += a * d + b * c
        if imaginary:
            return True
        if real_slope:
            value = Fraction(-1 - real_constant, real_slope)
            if parameter is None:
                parameter = value
            elif parameter != value:
                return True
        elif real_constant != -1:
            return True
    if parameter is None or not 0 < parameter < 1:
        return True

    for i, j, k in itertools.combinations(V, 3):
        a = fixed_cycle_value(i, j)
        c = fixed_cycle_value(j, k)
        e = fixed_cycle_value(k, i)
        b = tournament_value(bits, i, j)
        d = tournament_value(bits, j, k)
        f = tournament_value(bits, k, i)
        cross = a * d * f + b * c * f + b * d * e
        normalized = (a * c * e + cross) * parameter - cross
        if normalized * normalized != 1:
            return True
    return False


def add(z: tuple[int, int], w: tuple[int, int]) -> tuple[int, int]:
    return z[0] + w[0], z[1] + w[1]


def multiply(z: tuple[int, int], w: tuple[int, int]) -> tuple[int, int]:
    return z[0] * w[0] - z[1] * w[1], z[0] * w[1] + z[1] * w[0]


def matrix_product(
    left: tuple[tuple[tuple[int, int], ...], ...],
    right: tuple[tuple[tuple[int, int], ...], ...],
) -> tuple[tuple[tuple[int, int], ...], ...]:
    return tuple(
        tuple(
            sum_gaussian(multiply(left[i][k], right[k][j]) for k in range(6))
            for j in range(6)
        )
        for i in range(6)
    )


def sum_gaussian(values: object) -> tuple[int, int]:
    total = (0, 0)
    for value in values:  # type: ignore[union-attr]
        total = add(total, value)
    return total


def ettaoui_i_matrix() -> tuple[tuple[tuple[int, int], ...], ...]:
    z = (0, 0)
    one = (1, 0)
    minus = (-1, 0)
    ii = (0, 1)
    mi = (0, -1)
    return (
        (z, one, one, one, one, one),
        (one, z, minus, ii, one, mi),
        (one, minus, z, mi, one, ii),
        (one, mi, ii, z, minus, one),
        (one, one, one, minus, z, minus),
        (one, ii, mi, one, minus, z),
    )


def triangle_real_holonomy(
    matrix: tuple[tuple[tuple[int, int], ...], ...], triple: tuple[int, int, int]
) -> int:
    i, j, k = triple
    value = multiply(multiply(matrix[i][j], matrix[j][k]), matrix[k][i])
    return value[0]


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    tournaments = regular_tournaments()
    assert len(tournaments) == 24
    assert all(fixed_cycle_has_no_interior_solution(bits) for bits in tournaments)

    matrix = ettaoui_i_matrix()
    square = matrix_product(matrix, matrix)
    assert square == tuple(
        tuple((5, 0) if i == j else (0, 0) for j in range(6)) for i in range(6)
    )
    assert triangle_real_holonomy(matrix, (0, 1, 2)) == -1
    assert triangle_real_holonomy(matrix, (0, 1, 3)) == 0
    counterexample = certificate["ettaoui_b_i_counterexample"]
    assert counterexample["cut_012_squared_singular_spectrum"] == ["1/5", "4/5", "4/5"]
    assert counterexample["cut_013_squared_singular_spectrum"] == ["2/5", "2/5", "1"]
    print("C814 complex-conference reduced-orbit replay: PASS (24 relative tournaments)")


if __name__ == "__main__":
    main()
