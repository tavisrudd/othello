#!/usr/bin/env python3
"""Generate and independently check the compact C595 certificate.

The primary scheme computations live in the adjacent Singular script.  This
file reconstructs the integral equations with a tiny sparse-polynomial engine,
checks the cleared-denominator identities over Z, and performs independent
finite-field point controls in characteristics 2, 3, and 5.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path
from typing import Iterable


STEM = Path(__file__).with_suffix("")
JSON_PATH = STEM.with_suffix(".json")
MANIFEST_PATH = STEM.with_suffix(".sha256")
NAMES = ("x", "y", "d0", "d1", "d2", "d3", "d4", "d5")
NVAR = len(NAMES)
Poly = dict[tuple[int, ...], int]


def const(value: int) -> Poly:
    return {} if value == 0 else {(0,) * NVAR: value}


def var(index: int) -> Poly:
    exponent = [0] * NVAR
    exponent[index] = 1
    return {tuple(exponent): 1}


def add(*polys: Poly) -> Poly:
    result: Poly = {}
    for poly in polys:
        for monomial, coefficient in poly.items():
            result[monomial] = result.get(monomial, 0) + coefficient
            if result[monomial] == 0:
                del result[monomial]
    return result


def scale(poly: Poly, coefficient: int) -> Poly:
    return {
        monomial: coefficient * value
        for monomial, value in poly.items()
        if coefficient * value
    }


def mul(*polys: Poly) -> Poly:
    result = const(1)
    for poly in polys:
        product: Poly = {}
        for left, left_coefficient in result.items():
            for right, right_coefficient in poly.items():
                monomial = tuple(a + b for a, b in zip(left, right))
                product[monomial] = (
                    product.get(monomial, 0)
                    + left_coefficient * right_coefficient
                )
        result = {monomial: value for monomial, value in product.items() if value}
    return result


def power(poly: Poly, exponent: int) -> Poly:
    result = const(1)
    for _ in range(exponent):
        result = mul(result, poly)
    return result


def determinant(matrix: list[list[Poly]]) -> Poly:
    size = len(matrix)
    result: Poly = {}
    for permutation in itertools.permutations(range(size)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(size)
            for j in range(i + 1, size)
        )
        term = mul(*(matrix[row][permutation[row]] for row in range(size)))
        result = add(result, scale(term, -1 if inversions % 2 else 1))
    return result


def cyclic_carrier(c: list[Poly]) -> list[Poly]:
    c0, c1, c2, c3, c4 = c
    return [
        add(scale(power(c3, 3), 2), scale(mul(c2, c3, c4), -3), mul(c1, power(c4, 2))),
        add(
            scale(mul(c2, power(c3, 2)), 6),
            scale(mul(power(c2, 2), c4), -9),
            scale(mul(c1, c3, c4), 2),
            mul(c0, power(c4, 2)),
        ),
        add(
            scale(mul(c1, power(c3, 2)), 2),
            scale(mul(c1, c2, c4), -3),
            mul(c0, c3, c4),
        ),
        add(mul(c0, power(c3, 2)), scale(mul(power(c1, 2), c4), -1)),
        add(
            scale(mul(power(c1, 2), c3), 2),
            scale(mul(c0, c2, c3), -3),
            mul(c0, c1, c4),
        ),
        add(
            scale(mul(power(c1, 2), c2), 6),
            scale(mul(c0, power(c2, 2)), -9),
            scale(mul(c0, c1, c3), 2),
            mul(power(c0, 2), c4),
        ),
        add(
            scale(power(c1, 3), 2),
            scale(mul(c0, c1, c2), -3),
            mul(power(c0, 2), c3),
        ),
    ]


def polar_coefficients() -> list[Poly]:
    x, y = var(0), var(1)
    d = [var(index) for index in range(2, 8)]
    c = [add(mul(x, d[index]), mul(y, d[index + 1])) for index in range(5)]
    result = []
    for equation in cyclic_carrier(c):
        for y_degree in range(4):
            coefficient: Poly = {}
            for monomial, value in equation.items():
                if monomial[0] == 3 - y_degree and monomial[1] == y_degree:
                    reduced = (0, 0) + monomial[2:]
                    coefficient[reduced] = coefficient.get(reduced, 0) + value
            result.append(coefficient)
    return result


def hankel_minors() -> list[Poly]:
    d = [var(index) for index in range(2, 8)]
    columns = [[d[index], d[index + 1], d[index + 2]] for index in range(4)]
    return [
        determinant(
            [[columns[column][row] for column in choice] for row in range(3)]
        )
        for choice in itertools.combinations(range(4), 3)
    ]


LIFT_BY_MINOR = (
    ((12, -3), (17, -2), (22, 1), (27, -6)),
    ((8, -6), (13, 9), (18, 6), (23, -3)),
    ((4, -3), (9, 6), (14, -9), (19, -6)),
    ((0, -6), (5, 1), (10, -2), (15, 3)),
)


def poly_string(poly: Poly) -> str:
    if not poly:
        return "0"
    terms = []
    for monomial in sorted(poly, reverse=True):
        coefficient = poly[monomial]
        factors = []
        for name, exponent in zip(NAMES, monomial):
            if exponent:
                factors.append(name if exponent == 1 else f"{name}^{exponent}")
        body = "*".join(factors) or "1"
        terms.append(f"{coefficient:+d}*{body}")
    return "".join(terms).lstrip("+").replace("*1", "")


def evaluate(poly: Poly, point: tuple[int, ...], prime: int) -> int:
    value = 0
    for monomial, coefficient in poly.items():
        term = coefficient
        for coordinate, exponent in zip(point, monomial):
            term *= pow(coordinate, exponent, prime)
        value += term
    return value % prime


def rank_mod_prime(rows: list[list[int]], prime: int) -> int:
    matrix = [[entry % prime for entry in row] for row in rows]
    rank = 0
    width = len(matrix[0]) if matrix else 0
    for column in range(width):
        pivot = next(
            (row for row in range(rank, len(matrix)) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [(inverse * entry) % prime for entry in matrix[rank]]
        for row in range(len(matrix)):
            if row != rank and matrix[row][column]:
                factor = matrix[row][column]
                matrix[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(matrix[row], matrix[rank])
                ]
        rank += 1
    return rank


def denominator_obstructions(
    coefficients: list[Poly], minors: list[Poly]
) -> dict[str, dict[str, bool]]:
    monomials = sorted(set().union(*(poly.keys() for poly in coefficients + minors)))
    coefficient_rows = [
        [poly.get(monomial, 0) for monomial in monomials]
        for poly in coefficients
    ]
    result = {}
    for minor_index, minor in enumerate(minors, 1):
        target = [minor.get(monomial, 0) for monomial in monomials]
        result[str(minor_index)] = {}
        for prime in (2, 3):
            base_rank = rank_mod_prime(coefficient_rows, prime)
            extended_rank = rank_mod_prime(coefficient_rows + [target], prime)
            result[str(minor_index)][f"outside_span_mod_{prime}"] = (
                extended_rank > base_rank
            )
    return result


def projective_points(prime: int, dimension: int) -> Iterable[tuple[int, ...]]:
    for pivot in range(dimension + 1):
        prefix = (0,) * pivot + (1,)
        for tail in itertools.product(range(prime), repeat=dimension - pivot):
            yield prefix + tail


def finite_control(prime: int, coefficients: list[Poly], minors: list[Poly]) -> dict[str, int]:
    cyclic_points = 0
    persistent_points = 0
    outside_persistent = 0
    modular_points = 0
    for projective in projective_points(prime, 5):
        point = (0, 0) + projective
        in_cyclic = all(evaluate(poly, point, prime) == 0 for poly in coefficients)
        in_persistent = all(evaluate(poly, point, prime) == 0 for poly in minors)
        in_modular = (
            prime == 2
            and projective[0] == projective[1] == projective[4] == projective[5] == 0
        )
        cyclic_points += in_cyclic
        persistent_points += in_persistent
        outside_persistent += in_cyclic and not in_persistent and not in_modular
        modular_points += in_cyclic and in_modular
    return {
        "projective_cyclic_fano_points": cyclic_points,
        "projective_persistent_points": persistent_points,
        "cyclic_points_outside_persistent_or_modular": outside_persistent,
        "modular_points_in_cyclic_fano": modular_points,
    }


def verify_identities(coefficients: list[Poly], minors: list[Poly]) -> None:
    assert len(coefficients) == 28
    assert len(minors) == 4
    for minor, lift in zip(minors, LIFT_BY_MINOR):
        right = add(*(scale(coefficients[index], value) for index, value in lift))
        assert scale(minor, 6) == right
    for equation_index in range(7):
        block = coefficients[4 * equation_index : 4 * equation_index + 4]
        assert all(poly for poly in block)
        assert all(
            all(monomial[0] == monomial[1] == 0 for monomial in poly)
            for poly in block
        )
    obstructions = denominator_obstructions(coefficients, minors)
    assert obstructions["1"]["outside_span_mod_2"]
    assert obstructions["1"]["outside_span_mod_3"]
    assert obstructions["4"]["outside_span_mod_2"]
    assert obstructions["4"]["outside_span_mod_3"]


def payload() -> dict[str, object]:
    coefficients = polar_coefficients()
    minors = hankel_minors()
    verify_identities(coefficients, minors)
    return {
        "schema": "c595-stable-component-fano-elimination-v1",
        "integral_model": {
            "coordinate_order": list(NAMES),
            "carrier_generator_count": 7,
            "polar_coefficient_count": len(coefficients),
            "polar_coefficients": [poly_string(poly) for poly in coefficients],
            "persistent_hankel_minors": [poly_string(poly) for poly in minors],
        },
        "cleared_denominator_certificate": {
            "integer_N": 6,
            "minimal_common_integer": True,
            "identity": "6*H[j] = sum_i lift[j][i]*F[i]",
            "lift_by_minor_zero_based": [
                [[index, value] for index, value in entries]
                for entries in LIFT_BY_MINOR
            ],
            "consequence": (
                "After saturation by the lower persistent Hankel ideal, "
                "the cyclic Fano residual is empty over Z[1/6]."
            ),
            "minimality_controls": denominator_obstructions(coefficients, minors),
        },
        "small_characteristic_controls": {
            str(prime): finite_control(prime, coefficients, minors)
            for prime in (2, 3, 5)
        },
        "regression": {
            "R6": {
                "generic_residual": "empty after persistent saturation",
                "characteristic_2": (
                    "the true cyclic plane pulls back to "
                    "(d0,d1,d4,d5), the declared nucleus line"
                ),
                "characteristic_3": (
                    "the wild-cone Fano locus is contained in the "
                    "rank/fixed-factor boundary"
                ),
                "infinity": "both x^3 and y^3 endpoint coefficients are retained",
            },
            "R7": {
                "persistent": "J_6=I_6 integrally",
                "characteristic_2": (
                    "the lower nucleus line pulls back to the central point e3"
                ),
                "residual": "none",
            },
        },
        "first_unresolved_application": {
            "redundancy": 11,
            "old_marker_count": 5,
            "contracted_coordinates": (
                "d_i=a_(i+5)-s1*a_(i+4)+s2*a_(i+3)-"
                "s3*a_(i+2)+s4*a_(i+1)-s5*a_i"
            ),
            "cyclic_residual": "empty after declared saturation on D(6)",
            "remaining_obstruction": (
                "No integral generator ideal is available for the non-cyclic "
                "positive-moduli R10 lower carrier, so full SC(11) cannot yet "
                "be saturated or certified."
            ),
        },
        "trusted_boundary": {
            "python": (
                "reconstructs all integral polynomials, checks the Z identities, "
                "and exhausts projective F_p points for p=2,3,5"
            ),
            "singular": (
                "checks characteristic-zero and small-characteristic minimal "
                "primes and the exact R6/R7 ideal equalities"
            ),
        },
    }


def canonical_bytes() -> bytes:
    return (json.dumps(payload(), indent=2, sort_keys=True) + "\n").encode()


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def manifest_bytes() -> bytes:
    paths = (
        Path(__file__),
        STEM.with_suffix(".sing"),
        JSON_PATH,
    )
    return "".join(
        f"{digest(path)}  {path.stat().st_size}  {path.name}\n" for path in paths
    ).encode()


def write_bundle() -> None:
    JSON_PATH.write_bytes(canonical_bytes())
    MANIFEST_PATH.write_bytes(manifest_bytes())


def check_bundle() -> None:
    if JSON_PATH.read_bytes() != canonical_bytes():
        raise SystemExit(f"stale certificate: {JSON_PATH}")
    if MANIFEST_PATH.read_bytes() != manifest_bytes():
        raise SystemExit(f"stale manifest: {MANIFEST_PATH}")
    controls = payload()["small_characteristic_controls"]
    assert all(
        record["cyclic_points_outside_persistent_or_modular"] == 0
        for record in controls.values()
    )
    print(
        "C595 Python certificate OK: 28 integral coefficients, "
        "N=6, F_2/F_3/F_5 point controls"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--write", action="store_true")
    action.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write:
        write_bundle()
    else:
        check_bundle()


if __name__ == "__main__":
    main()
