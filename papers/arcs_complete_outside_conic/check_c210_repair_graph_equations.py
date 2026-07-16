#!/usr/bin/env python3
"""Exhaustively check the C210 repair-graph chord equations over GF(9)."""

from __future__ import annotations

import itertools

from probe_c210_two_layer_parabolas import QuadraticField


def chord_height(field: QuadraticField, x: int, h: int, xp: int, hp: int,
                 y: int) -> int:
    """Height H with [1:y:y^2+H] on the chord through (x,h),(xp,hp)."""
    ratio = field.div(field.sub(y, x), field.sub(xp, x))
    interpolated = field.add(h, field.mul(ratio, field.sub(hp, h)))
    parabola_correction = field.mul(field.sub(y, x), field.sub(y, xp))
    return field.sub(interpolated, parabola_correction)


def incident(field: QuadraticField, line: tuple[int, int, int],
             point: tuple[int, int, int]) -> bool:
    return field.add(
        field.add(field.mul(line[0], point[0]), field.mul(line[1], point[1])),
        field.mul(line[2], point[2]),
    ) == 0


def main() -> None:
    field = QuadraticField.for_subfield_order(3)
    checked = 0
    for x, xp in itertools.permutations(range(field.q), 2):
        for h, hp, y in itertools.product(range(field.q), repeat=3):
            height = chord_height(field, x, h, xp, hp, y)
            first = (1, x, field.add(field.mul(x, x), h))
            second = (1, xp, field.add(field.mul(xp, xp), hp))
            target = (1, y, field.add(field.mul(y, y), height))
            assert incident(field, field.cross(first, second), target)
            checked += 1
    print(f"checked={checked} field=GF({field.q}) status=ok")


if __name__ == "__main__":
    main()
