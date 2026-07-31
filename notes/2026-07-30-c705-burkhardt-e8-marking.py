#!/usr/bin/env python3
"""Exact C705 specialization of the Burkhardt universal genus-two curve.

The formulas are Proposition 2.5 of Bruin--Nasserden, specialized at the
frozen Burkhardt point (6:17:1:-7:-19).  The modular factorization checks
certify that the branch sextic has Galois group S_6.  Consequently the
ordered Weierstrass marking needed by the Joubert coordinates exists over
the 720-sheeted splitting torsor, but not over Q.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from functools import reduce
from math import gcd
from pathlib import Path


STEM = Path(__file__).with_suffix("")
JSON_PATH = STEM.with_suffix(".json")
ALPHA = (6, 17, 1, -7, -19)


def add(left, right):
    result = [Fraction(0)] * max(len(left), len(right))
    for i, value in enumerate(left):
        result[i] += value
    for i, value in enumerate(right):
        result[i] += value
    return result


def multiply(left, right):
    result = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            result[i + j] += x * y
    return result


def trim(poly):
    while len(poly) > 1 and poly[-1] == 0:
        poly.pop()
    return poly


def remainder(dividend, divisor, prime):
    work = [value % prime for value in dividend]
    divisor = trim([value % prime for value in divisor])
    inverse = pow(divisor[-1], -1, prime)
    while len(work) >= len(divisor) and work != [0]:
        quotient = work[-1] * inverse % prime
        shift = len(work) - len(divisor)
        for i, value in enumerate(divisor):
            work[i + shift] = (work[i + shift] - quotient * value) % prime
        trim(work)
    return work


def modular_multiply(left, right, prime, modulus):
    product = [0] * (len(left) + len(right) - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            product[i + j] = (product[i + j] + x * y) % prime
    return remainder(product, modulus, prime)


def x_power(exponent, prime, modulus):
    result = [1]
    base = [0, 1]
    while exponent:
        if exponent & 1:
            result = modular_multiply(result, base, prime, modulus)
        base = modular_multiply(base, base, prime, modulus)
        exponent //= 2
    return result


def modular_gcd(left, right, prime):
    while right != [0]:
        left, right = right, remainder(left, right, prime)
    inverse = pow(left[-1], -1, prime)
    return [(value * inverse) % prime for value in left]


def factor_degrees(poly, prime):
    """Return the square-free factor-degree multiset over F_prime."""
    reduced = [value % prime for value in poly]
    assert reduced[-1]
    derivative = [i * reduced[i] % prime for i in range(1, len(reduced))]
    assert len(modular_gcd(reduced, derivative, prime)) == 1
    counts = {}
    for exponent in range(1, len(reduced)):
        frobenius = x_power(prime**exponent, prime, reduced)
        difference = frobenius + [0] * (max(2, len(frobenius)) - len(frobenius))
        difference[1] = (difference[1] - 1) % prime
        trim(difference)
        accumulated_degree = len(modular_gcd(reduced, difference, prime)) - 1
        counts[exponent] = (
            accumulated_degree
            - sum(
                degree * counts[degree]
                for degree in range(1, exponent)
                if exponent % degree == 0
            )
        ) // exponent
    return sorted(
        degree
        for degree, multiplicity in counts.items()
        for _ in range(multiplicity)
    )


def primitive_integer_polynomial(poly):
    denominator = 1
    for coefficient in poly:
        denominator = (
            denominator
            * coefficient.denominator
            // gcd(denominator, coefficient.denominator)
        )
    integers = [int(coefficient * denominator) for coefficient in poly]
    content = reduce(gcd, map(abs, integers))
    return [coefficient // content for coefficient in integers]


def compute():
    a0, *coordinates = map(Fraction, ALPHA)
    a1, a2, a3, a4 = [coordinate / a0 for coordinate in coordinates]
    burkhardt = (
        ALPHA[0] ** 4
        + 8 * ALPHA[0] * sum(value**3 for value in ALPHA[1:])
        + 48 * ALPHA[1] * ALPHA[2] * ALPHA[3] * ALPHA[4]
    )
    assert burkhardt == 0

    # Ascending coefficients after z=1.
    h = [-a1 * a4, -a3, a2]
    g = [
        -2 * a1**3 * a4**6
        - a1**3 * a4**3
        + 3 * a1 * a2 * a3 * a4**4
        + a2**3 * a4**3
        - a3**3,
        -3 * a3 * (a4**2 + 1) * (a1**2 * a4**2 - a2 * a3),
        3 * a2 * (a4**3 + 1) * (a1**2 * a4**2 - a2 * a3),
        a1**3 * a4**3
        + 3 * a1 * a2 * a3 * a4**4
        + 2 * a2**3 * a4**3
        + a2**3
        + a3**3 * a4**3,
    ]
    lam = (
        a4**3
        * (a4**3 + 1)
        * (a1 * a4 - a2 - a3)
        * (
            a1**2 * a4**2
            + a1 * a2 * a4
            + a1 * a3 * a4
            + a2**2
            - a2 * a3
            + a3**2
        )
    )
    branch = add(
        multiply(g, g),
        [4 * lam * coefficient for coefficient in multiply(multiply(h, h), h)],
    )
    primitive = primitive_integer_polynomial(branch)
    assert len(primitive) == 7

    patterns = {
        prime: factor_degrees(primitive, prime) for prime in (7, 17, 1303)
    }
    assert patterns == {
        7: [1, 5],
        17: [6],
        1303: [1, 1, 1, 1, 2],
    }

    return {
        "schema": "c705-burkhardt-e8-marking-v1",
        "ground_field": "Q",
        "burkhardt_point": ALPHA,
        "burkhardt_equation_value": burkhardt,
        "affine_H_ascending": [str(value) for value in h],
        "affine_G_ascending": [str(value) for value in g],
        "lambda": str(lam),
        "primitive_branch_sextic_ascending": primitive,
        "frobenius_factor_degrees": {
            str(prime): degrees for prime, degrees in patterns.items()
        },
        "galois_argument": [
            "mod 17 irreducibility gives transitivity and a 6-cycle",
            "mod 7 gives a 5-cycle",
            "mod 1303 gives a transposition",
            "the 5-cycle excludes block systems of sizes 2 or 3",
            "a primitive subgroup of S6 containing a transposition is S6",
        ],
        "galois_group": "S6",
        "rational_weierstrass_point": False,
        "one_weierstrass_point_degree": 6,
        "ordered_weierstrass_torsor_degree": 720,
        "strict_lie_e8_verdict": (
            "possible after base change to the S6 ordered-Weierstrass torsor; "
            "not defined over Q for this frozen Burkhardt point"
        ),
        "sources": {
            "Bruin--Nasserden_arXiv_1705.09006_sha256": (
                "e4d84263b04294adea81aecce0232e359c4a0ed03855c00e57315c5a4224bc3a"
            ),
            "Rains--Sam_arXiv_1702.04840_sha256": (
                "4c46b1edef9252cae1917d9d4fbc91607ae792aafa895ccfae47d5b39dc56296"
            ),
        },
    }


def canonical_bytes(payload):
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = compute()
    encoded = canonical_bytes(payload)
    if args.check:
        assert JSON_PATH.read_bytes() == encoded
        print(hashlib.sha256(encoded).hexdigest())
    else:
        JSON_PATH.write_bytes(encoded)
        print(JSON_PATH)


if __name__ == "__main__":
    main()
