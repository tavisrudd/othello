#!/usr/bin/env python3
"""Independent exact replay of the Kaipa--Pradhan square-class comparison."""

import json
from pathlib import Path

import sympy as sp


def main() -> None:
    a0, a1, a2, a3, a4, x, t = sp.symbols("a0 a1 a2 a3 a4 x t")
    a = [a0, a1, a2, a3, a4]
    delta = a0 * a2 - a1**2

    # Compute the minor-normalized residual discriminant independently.
    bordered = sp.Matrix([
        [a0, a1, a2, a3],
        [a1, a2, a3, a4],
        [1, x, x**2, x**3],
    ])
    minors = [
        (-1) ** j * bordered[:, [k for k in range(4) if k != j]].det()
        for j in range(4)
    ]
    cubic = sum(minors[j] * t**j for j in range(4))
    quadratic, remainder = sp.div(sp.Poly(cubic, t), sp.Poly(t - x, t))
    assert remainder.is_zero
    leading, linear, constant = quadratic.all_coeffs()
    disc = sp.expand(linear**2 - 4 * leading * constant)

    # Solve the Hankel kernel on the delta != 0 patch and convert ordinary
    # cubic coefficients to the divided-power basis of Kaipa--Pradhan.
    leading_block = sp.Matrix([[a0, a1], [a1, a2]])
    tails = [sp.Matrix([a2, a3]), sp.Matrix([a3, a4])]
    ordinary = []
    for index, tail in enumerate(tails):
        head = -leading_block.inv() * tail
        ordinary.append([head[0], head[1], int(index == 0), int(index == 1)])
    divided = [
        [row[0], -row[1] / 3, row[2] / 3, -row[3]]
        for row in ordinary
    ]
    p = {
        (i, j): sp.cancel(divided[0][i] * divided[1][j] - divided[0][j] * divided[1][i])
        for i in range(4)
        for j in range(i + 1, 4)
    }
    z0 = p[0, 1]
    z1 = p[0, 2] / 2
    z2 = p[0, 3] / 6 + p[1, 2] / 2
    z5 = p[0, 3] / 6 - p[1, 2] / 2
    z3 = p[1, 3] / 2
    z4 = p[2, 3]

    phi = z0 - 4 * z1 * x + 6 * z2 * x**2 - 4 * z3 * x**3 + z4 * x**4
    kaipa_pradhan_disc = sp.expand(
        -z5 * phi
        + (z1**2 - z0 * z2)
        + 2 * (z0 * z3 - z1 * z2) * x
        - (z0 * z4 + 2 * z1 * z3 - 3 * z2**2) * x**2
        + 2 * (z1 * z4 - z2 * z3) * x**3
        + (z3**2 - z2 * z4) * x**4
    )
    assert sp.cancel(kaipa_pradhan_disc - disc / (36 * delta**2)) == 0

    certificate = json.loads(Path(__file__).with_name(
        "2026-08-07-c883-hankel-plucker-covariant.json"
    ).read_text(encoding="utf-8"))
    assert certificate["kaipa_pradhan_discriminant_square_class_on_patch"] is True
    assert certificate["fibre_to_kaipa_pradhan_square_factor"] == (
        "(3*(a0*a2 - a1**2))**2"
    )
    print("Kaipa--Pradhan square-class replay: PASS")


if __name__ == "__main__":
    main()
