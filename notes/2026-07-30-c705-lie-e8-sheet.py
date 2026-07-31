#!/usr/bin/env python3
"""Exact split-fiber computation for the residual C705 Lie-E8 gate.

The characteristic-zero input is the frozen Burkhardt branch sextic.  The
prime 1447 is a good completely split fiber.  On it we:

* enumerate all 720 ordered Weierstrass sheets and evaluate C704's frozen
  Joubert tensor and Segre--Igusa polar;
* construct the six Rains--Sam marked trivectors, one for each branch point;
* verify that each root-to-infinity quintic has exactly the other five
  transformed branch points;
* construct the Coble cubic of one marked trivector as the common quotient
  of its nine principal 8-by-8 Pfaffians.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import runpy
from collections import Counter
from itertools import permutations
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-30-c705-lie-e8-sheet.json"
C704 = ROOT / "2026-07-30-c704-segre-igusa-operator-shadow.py"
PRIME = 1447
BRANCH = (
    295130390826722844,
    -62251283304984120046,
    -5519843141820561948,
    1960910801972693616,
    -445189061771697891,
    103910980411175652,
    39706983135965148,
)


def evaluate_polynomial(coefficients, value, prime=PRIME):
    return sum(
        coefficient * pow(value, degree, prime)
        for degree, coefficient in enumerate(coefficients)
    ) % prime


def derivative_value(coefficients, value, order, prime=PRIME):
    return sum(
        coefficients[degree]
        * math.factorial(degree)
        * pow(math.factorial(degree - order), -1, prime)
        * pow(value, degree - order, prime)
        for degree in range(order, len(coefficients))
    ) % prime


def marked_coefficients(root):
    derivative = derivative_value(BRANCH, root, 1)
    return {
        6: -derivative_value(BRANCH, root, 2) * pow(2, -1, PRIME) % PRIME,
        12: derivative
        * derivative_value(BRANCH, root, 3)
        * pow(6, -1, PRIME)
        % PRIME,
        18: -derivative**2
        * derivative_value(BRANCH, root, 4)
        * pow(24, -1, PRIME)
        % PRIME,
        24: derivative**3
        * derivative_value(BRANCH, root, 5)
        * pow(120, -1, PRIME)
        % PRIME,
        30: -derivative**4
        * derivative_value(BRANCH, root, 6)
        * pow(720, -1, PRIME)
        % PRIME,
    }


def marked_quintic_value(coefficients, value):
    return (
        pow(value, 5, PRIME)
        + coefficients[6] * pow(value, 4, PRIME)
        + coefficients[12] * pow(value, 3, PRIME)
        + coefficients[18] * pow(value, 2, PRIME)
        + coefficients[24] * value
        + coefficients[30]
    ) % PRIME


ZERO_MONOMIAL = (0,) * 9


def poly_add(left, right):
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = (result.get(monomial, 0) + coefficient) % PRIME
    return {monomial: coefficient for monomial, coefficient in result.items() if coefficient}


def poly_scale(poly, scalar):
    return {
        monomial: scalar * coefficient % PRIME
        for monomial, coefficient in poly.items()
        if scalar * coefficient % PRIME
    }


def poly_multiply(left, right):
    result = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(lm[i] + rm[i] for i in range(9))
            result[monomial] = (result.get(monomial, 0) + lc * rc) % PRIME
    return {monomial: coefficient for monomial, coefficient in result.items() if coefficient}


def pfaffian(matrix, indices):
    if not indices:
        return {ZERO_MONOMIAL: 1}
    first = indices[0]
    result = {}
    for position, second in enumerate(indices[1:], 1):
        remainder = indices[1:position] + indices[position + 1 :]
        term = poly_multiply(matrix[first][second], pfaffian(matrix, remainder))
        result = poly_add(result, poly_scale(term, (-1) ** (position + 1)))
    return result


def trivector_terms(coefficients):
    return (
        ((1, 5, 6), 1),
        ((1, 4, 7), 1),
        ((2, 3, 7), 1),
        ((0, 5, 8), 1),
        ((2, 4, 6), 1),
        ((1, 3, 8), 1),
        ((0, 6, 7), 1),
        ((3, 4, 5), 1),
        ((1, 3, 6), -coefficients[6]),
        ((0, 3, 6), -coefficients[12]),
        ((0, 3, 4), coefficients[18]),
        ((0, 2, 3), coefficients[24]),
        ((0, 1, 2), coefficients[30]),
    )


def coble_cubic(coefficients):
    matrix = [[{} for _ in range(9)] for _ in range(9)]
    for support, coefficient in trivector_terms(coefficients):
        for left in range(9):
            for right in range(left + 1, 9):
                if left not in support or right not in support:
                    continue
                remaining = next(index for index in support if index not in (left, right))
                word = (left, right, remaining)
                inversions = sum(
                    word[i] > word[j] for i in range(3) for j in range(i + 1, 3)
                )
                exponent = [0] * 9
                exponent[remaining] = 1
                term = {
                    tuple(exponent): coefficient * (-1) ** inversions % PRIME
                }
                matrix[left][right] = poly_add(matrix[left][right], term)
                matrix[right][left] = poly_scale(matrix[left][right], -1)

    quotients = []
    for omitted in range(9):
        principal = pfaffian(
            matrix, tuple(index for index in range(9) if index != omitted)
        )
        assert all(monomial[omitted] for monomial in principal)
        quotient = {}
        for monomial, coefficient in principal.items():
            reduced = list(monomial)
            reduced[omitted] -= 1
            quotient[tuple(reduced)] = coefficient
        # Principal-Pfaffian signs alternate.
        quotients.append(poly_scale(quotient, (-1) ** omitted))
    pivot = next(quotient for quotient in quotients if quotient)
    pivot_monomial = next(iter(pivot))
    normalized = poly_scale(pivot, pow(pivot[pivot_monomial], -1, PRIME))
    for quotient in quotients:
        candidate = poly_scale(
            quotient, pow(quotient[pivot_monomial], -1, PRIME)
        )
        assert candidate == normalized
    return normalized


def joubert_cubics():
    module = runpy.run_path(str(C704))
    base = module["triangle_cubic"](module["BASE_C"])
    oriented = {}
    for permutation in permutations(range(6)):
        total = module["total_key"](
            tuple(
                tuple(
                    sorted(
                        tuple(sorted((permutation[i], permutation[j])))
                        for i, j in matching
                    )
                )
                for matching in module["BASE_TOTAL"]
            )
        )
        cubic = tuple(
            module["parity"](permutation) * coefficient
            for coefficient in module["permute_cubic"](base, permutation)
        )
        if total in oriented:
            assert oriented[total] == cubic
        else:
            oriented[total] = cubic
    assert len(oriented) == 6
    return module, [oriented[total] for total in sorted(oriented)]


def build_certificate():
    branch_mod = tuple(coefficient % PRIME for coefficient in BRANCH)
    roots = tuple(
        value
        for value in range(PRIME)
        if evaluate_polynomial(branch_mod, value) == 0
    )
    assert roots == (449, 773, 775, 878, 1238, 1321)
    assert len(set(roots)) == 6

    module, cubics = joubert_cubics()
    ordered_images = set()
    first_witness = None
    for ordering in permutations(roots):
        mean = sum(ordering) * pow(6, -1, PRIME) % PRIME
        centered = tuple((value - mean) % PRIME for value in ordering)
        joubert = tuple(
            module["evaluate"](cubic, centered) % PRIME for cubic in cubics
        )
        square_sum = sum(value * value for value in joubert) % PRIME
        polar = tuple((6 * value * value - square_sum) % PRIME for value in joubert)
        assert sum(joubert) % PRIME == 0
        assert sum(pow(value, 3, PRIME) for value in joubert) % PRIME == 0
        assert sum(polar) % PRIME == 0
        assert (
            pow(sum(value * value for value in polar), 2, PRIME)
            - 4 * sum(pow(value, 4, PRIME) for value in polar)
        ) % PRIME == 0
        ordered_images.add(joubert)
        if first_witness is None:
            first_witness = {
                "ordering": ordering,
                "centered": centered,
                "joubert": joubert,
                "polar_times_6": polar,
            }
    assert len(ordered_images) == 720

    marked = []
    for root in roots:
        coefficients = marked_coefficients(root)
        derivative = derivative_value(BRANCH, root, 1)
        finite_roots = tuple(
            -derivative * pow(other - root, -1, PRIME) % PRIME
            for other in roots
            if other != root
        )
        assert all(
            marked_quintic_value(coefficients, value) == 0
            for value in finite_roots
        )
        assert len(set(finite_roots)) == 5
        marked.append(
            {
                "marked_root": root,
                "coefficients": {f"c{weight}": value for weight, value in coefficients.items()},
                "other_five_after_root_to_infinity": finite_roots,
            }
        )

    cubic = coble_cubic(marked_coefficients(roots[0]))
    term_types = Counter(tuple(sorted(monomial, reverse=True)) for monomial in cubic)
    assert sum(term_types.values()) == len(cubic) == 31

    c704_hash = hashlib.sha256(C704.read_bytes()).hexdigest()
    return {
        "schema": "c705-lie-e8-sheet-v1",
        "prime": PRIME,
        "branch_roots": roots,
        "ordered_weierstrass_sheets_checked": len(ordered_images),
        "distinct_ordered_joubert_images": len(ordered_images),
        "first_sheet": first_witness,
        "six_marked_vinberg_forms": marked,
        "first_marked_coble_cubic_terms": [
            {"exponents": monomial, "coefficient": coefficient}
            for monomial, coefficient in sorted(cubic.items())
        ],
        "first_marked_coble_cubic_term_types": {
            str(term_type): multiplicity
            for term_type, multiplicity in sorted(term_types.items())
        },
        "pfaffian_identity": (
            "the nine signed principal 8x8 Pfaffians equal x_i times one cubic"
        ),
        "mechanism": (
            "Rains--Sam Theorem 5.5 identifies the stable PGL9 orbit with "
            "(C,P,psi); for the Jacobian Coble cubic psi=0, and Proposition "
            "5.4 plus Lemma 5.3 reconstruct the projective orbit equivalence"
        ),
        "c704_generator_sha256": c704_hash,
    }


def canonical_bytes(payload):
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = canonical_bytes(build_certificate())
    if args.check:
        assert OUTPUT.read_bytes() == encoded
        print(hashlib.sha256(encoded).hexdigest())
    else:
        OUTPUT.write_bytes(encoded)
        print(OUTPUT)


if __name__ == "__main__":
    main()
