#!/usr/bin/env python3
"""Independent audit of the retired q=121 top Hasse pairing.

This deliberately does not import Sage or the original detector.  It
expands the stated translation on two monomials over F_11 and evaluates
the detector's closed monomial pairing directly.
"""

import argparse
import json
from math import comb, factorial
from pathlib import Path


P = 11
DEGREE = 59
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c665-q121-contraction-audit.json"


def add_term(polynomial, exponent, coefficient):
    value = (polynomial.get(exponent, 0) + coefficient) % P
    if value:
        polynomial[exponent] = value
    elif exponent in polynomial:
        del polynomial[exponent]


def translate(exponent, parameter=1):
    """Substitute X-2uY+u^2Z, Y-uZ, Z in one monomial."""
    i, j, k = exponent
    answer = {}
    for y_from_x in range(i + 1):
        for z_from_x in range(i - y_from_x + 1):
            x_from_x = i - y_from_x - z_from_x
            x_coefficient = (
                comb(i, y_from_x)
                * comb(i - y_from_x, z_from_x)
                * (-2 * parameter) ** y_from_x
                * parameter ** (2 * z_from_x)
            )
            for z_from_y in range(j + 1):
                target = (
                    x_from_x,
                    y_from_x + j - z_from_y,
                    z_from_x + z_from_y + k,
                )
                coefficient = (
                    x_coefficient
                    * comb(j, z_from_y)
                    * (-parameter) ** z_from_y
                )
                add_term(answer, target, coefficient)
    return answer


def top_pairing(left, right):
    half = pow(2, -1, P)
    answer = 0
    for (i, j, k), left_coefficient in left.items():
        answer += (
            left_coefficient
            * right.get((k, j, i), 0)
            * pow(-half, j, P)
        )
    return answer % P


def calculate():
    left_exponent = (2, 0, 57)
    right_exponent = (57, 1, 1)
    left = {left_exponent: 1}
    right = {right_exponent: 1}
    translated_left = translate(left_exponent)
    translated_right = translate(right_exponent)
    before = top_pairing(left, right)
    after = top_pairing(translated_left, translated_right)
    assert before == 0 and after != before
    assert factorial(DEGREE) % P == 0
    return {
        "schema": 1,
        "p": P,
        "degree": DEGREE,
        "translation": [
            "X -> X - 2Y + Z",
            "Y -> Y - Z",
            "Z -> Z",
        ],
        "left_exponent": list(left_exponent),
        "right_exponent": list(right_exponent),
        "pairing_before": before,
        "pairing_after": after,
        "translation_defect": (after - before) % P,
        "degree_factorial_mod_p": factorial(DEGREE) % P,
        "conclusion": (
            "the retired Hasse top pairing is not translation-equivariant; "
            "the genuine order-59 ordinary contraction is zero"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = json.dumps(calculate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(encoded)
        print(f"wrote {CERTIFICATE.name}")
    elif args.check:
        assert CERTIFICATE.read_text() == encoded
        print(f"checked {CERTIFICATE.name}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
