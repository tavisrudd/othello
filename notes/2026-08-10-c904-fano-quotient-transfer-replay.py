#!/usr/bin/env python3
"""Exact C2/V4 transfer and Fano sum/difference degree certificate."""

import importlib.util
from fractions import Fraction
from itertools import permutations
from math import factorial
from pathlib import Path


def load_module(name, filename):
    spec = importlib.util.spec_from_file_location(name, Path(__file__).with_name(filename))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


EXT = load_module(
    "c904_poincare_replay", "2026-08-10-c904-poincare-cubic-fano-replay.py"
)
GROUP = load_module(
    "c904_resolution_replay", "2026-08-10-c904-primitive-theta-resolution-replay.py"
)


def add_forms(*forms):
    result = {}
    for form in forms:
        for indices, coefficient in form.items():
            result[indices] = result.get(indices, Fraction(0)) + coefficient
            if not result[indices]:
                del result[indices]
    return result


def scale_form(coefficient, form):
    return {indices: coefficient * value for indices, value in form.items()}


def fano_degrees():
    theta_first = {}
    theta_second = {}
    poincare = {}
    for i in range(5):
        a = 2 * i
        b = 2 * i + 1
        theta_first[(a, b)] = Fraction(1)
        theta_second[(10 + a, 10 + b)] = Fraction(1)
        poincare[(a, 10 + b)] = Fraction(1)
        poincare[(b, 10 + a)] = Fraction(-1)
    fano_product = EXT.wedge(EXT.divided_power(theta_first, 3),
                             EXT.divided_power(theta_second, 3))
    sum_theta = add_forms(theta_first, theta_second, poincare)
    difference_theta = add_forms(
        theta_first, theta_second, scale_form(Fraction(-1), poincare)
    )
    top = tuple(range(20))
    sum_degree = EXT.wedge(
        fano_product, EXT.divided_power(sum_theta, 4)
    ).get(top, Fraction(0))
    difference_degree = EXT.wedge(
        fano_product, EXT.divided_power(difference_theta, 4)
    ).get(top, Fraction(0))
    return sum_degree, difference_degree


def perm(transpositions):
    value = list(range(5))
    for left, right in transpositions:
        value[left], value[right] = value[right], value[left]
    return tuple(value)


def group_indices():
    a5 = frozenset(value for value in permutations(range(5))
                   if GROUP.parity(value) == 0)
    identity = tuple(range(5))
    involution = perm(((0, 1), (2, 3)))
    c2 = frozenset((identity, involution))
    v4 = frozenset((
        identity,
        perm(((0, 1), (2, 3))),
        perm(((0, 2), (1, 3))),
        perm(((0, 3), (1, 2))),
    ))
    assert all(GROUP.compose(x, y) in v4 for x in v4 for y in v4)
    assert c2 < v4 < a5
    return len(a5) // len(v4), len(a5) // len(c2), len(a5)


def main():
    sum_degree, difference_degree = fano_degrees()
    assert sum_degree == difference_degree == 30
    # [D_+]=3 Theta and [Theta]=Theta; Theta^5/5!=1, so
    # int_D+ Theta^4/4!=15 and int_Theta Theta^4/4!=5.
    assert sum_degree == 2 * 15
    assert difference_degree == 6 * 5

    orbit_degrees = group_indices()
    assert orbit_degrees == (15, 30, 60)

    # For a two-primary class alpha, cor(res(alpha))=[L:K] alpha.
    transfer_mod_two = tuple(degree % 2 for degree in orbit_degrees)
    assert transfer_mod_two == (1, 0, 0)

    print("C904 Fano quotient and transfer audit")
    print(f"sum pullback theta-volume={sum_degree}; degree 2 * Dplus-volume 15")
    print(f"difference pullback theta-volume={difference_degree}; degree 6 * theta-volume 5")
    print("swap quotient: F^2 -> Sym^2(F) has degree 2; q_*q^*=2")
    print(f"A5 orbit degrees for stabilizers V4,C2,1={orbit_degrees}")
    print(f"restriction-corestriction multipliers mod2={transfer_mod_two}")
    print("only the V4-stabilized degree-15 extension is injective on 2-torsion")
    print("PASS")


if __name__ == "__main__":
    main()
