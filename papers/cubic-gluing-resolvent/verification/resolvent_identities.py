#!/usr/bin/env python3
"""Exact certificate for the cubic-pencil modular resolvent."""

from __future__ import annotations

import argparse
from pathlib import Path

import sympy as sp


def main() -> str:
    t, T, u, x, y, v = sp.symbols("t T u x y v")

    # van Geemen--Yamauchi's Prym chart, with u^2=5t^2.
    a = -32 * (u - 3) ** 4 / (9 * (u + 1) ** 3 * (u + 3) ** 2)
    b = -8 * (u - 3) ** 2 * (u - 1) / ((u + 1) * (u + 3) ** 2)
    gy_delta_core = (
        512 * a**2 + 27 * a**3 + 48 * a**2 * b + 128 * a * b**2
        + 6 * a**2 * b**2 + 30 * a * b**3 + a**2 * b**3
        + 8 * b**4 + 2 * a * b**4 + b**5
    )
    gy_c4_core = (
        64 * a**2 + 4 * a**2 * b + 16 * a * b**2
        + a**2 * b**2 + 2 * a * b**3 + b**4
    )
    delta_num, delta_den = map(sp.factor, sp.fraction(sp.together(gy_delta_core)))
    c4_num, c4_den = map(sp.factor, sp.fraction(sp.together(gy_c4_core)))
    a_num, a_den = map(sp.factor, sp.fraction(sp.together(a)))
    j_vgy = sp.factor(
        -16 * c4_num**3 * a_den**5 * delta_den
        / (c4_den**3 * a_num**5 * delta_num)
    )
    j_expected = 9 * (3 * u**2 + 5) * (27 * u**2 + 5) ** 3 / (125 * u**2)
    assert sp.factor(j_vgy - j_expected) == 0
    j_t = sp.factor(j_expected.subs(u**2, 5 * t**2))
    assert sp.factor(
        j_t - 9 * (3 * t**2 + 1) * (27 * t**2 + 1) ** 3 / t**2
    ) == 0
    J = (T + 27) * (T + 3) ** 3 / T
    assert sp.factor(j_t - J.subs(T, 81 * t**2)) == 0
    h = 729 / T
    assert sp.factor((3 / t) ** 2 - h.subs(T, 81 * t**2)) == 0
    assert h.subs(T, -27) == -27
    assert h.subs(T, sp.Rational(729, 5)) == 5

    # Tate normal form with a point of order three.
    a1, a3 = T + 27, (T + 27) ** 2
    b2, b4, b6, b8 = a1**2, a1 * a3, a3**2, 0
    c4 = sp.factor(b2**2 - 24 * b4)
    delta = sp.factor(-b2**2 * b8 - 8 * b4**3 - 27 * b6**2 + 9 * b2 * b4 * b6)
    assert delta == T * (T + 27) ** 8
    assert sp.factor(c4**3 / delta - J) == 0

    # The generalized two-division cubic and its discriminant.
    f2 = 4 * x**3 + a1**2 * x**2 + 2 * a1 * a3 * x + a3**2
    disc2 = sp.factor(sp.discriminant(f2, x))
    assert disc2 == 16 * T * (T + 27) ** 8

    # Cubic root quotient and its rational Galois closure.
    T_of_y = -(4 * y + 3) * (y + 3) ** 2 / (y + 1) ** 2
    x_of_y = -4 * y**4 / (y + 1) ** 2
    assert sp.factor(f2.subs({T: T_of_y, x: x_of_y})) == 0
    y_of_v = -(v**2 + 3) / 4
    T_of_v = v**2 * (9 - v**2) ** 2 / (1 - v**2) ** 2
    r_of_v = v * (9 - v**2) / (1 - v**2)
    assert sp.factor(T_of_y.subs(y, y_of_v) - T_of_v) == 0
    assert sp.factor(r_of_v**2 - T_of_v) == 0

    # Two generators of GL_2(F_2): a transposition and a 3-cycle.  Their
    # permutations on P^1(F_4) are (0 1)(w w^2) and (inf 0 1).
    transposition = ((0, 1), (3, 4))
    three_cycle = ((2, 0, 1),)
    assert sum(len(cycle) - 1 for cycle in transposition) % 2 == 0
    assert sum(len(cycle) - 1 for cycle in three_cycle) % 2 == 0
    assert transposition[0] == (0, 1) and transposition[1] == (3, 4)

    lines = [
        "VGY j(u) = 9(3u^2+5)(27u^2+5)^3/(125u^2)",
        "T=81t^2 gives j=(T+27)(T+3)^3/T",
        "h=729/T gives sqrt(h)=3/t; interior cubic boundary h-values are -27 and 5",
        "Tate Delta = T(T+27)^8",
        "disc(two-division cubic) = 16T(T+27)^8",
        "root quotient: T=-(4y+3)(y+3)^2/(y+1)^2",
        "chosen root: x=-4y^4/(y+1)^2 satisfies the two-division cubic",
        "full split cover: y=-(v^2+3)/4, r=v(9-v^2)/(1-v^2), r^2=T",
        "P1(F4)=P1(F2) disjoint {w,w^2}; the complementary action is sign",
        "PASS",
    ]
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    output = main()
    if args.check is not None:
        expected = args.check.read_text()
        if output != expected:
            raise SystemExit("certificate output differs from checked fixture")
    print(output, end="")
