#!/usr/bin/env python3
"""Exact certificate for the Clebsch four-channel in degree-six harmonics."""

from __future__ import annotations

import argparse
import json
from collections import defaultdict
from fractions import Fraction
from pathlib import Path


Q = Fraction
Surd = tuple[Q, Q]
Monomial = tuple[int, int, int]
Polynomial = dict[Monomial, Surd]

ZERO: Surd = (Q(0), Q(0))
ONE: Surd = (Q(1), Q(0))
PHI: Surd = (Q(1, 2), Q(1, 2))
INV_PHI: Surd = (Q(-1, 2), Q(1, 2))
OUTPUT = Path(__file__).with_suffix(".json")


def s(value: int | Q) -> Surd:
    return Q(value), Q(0)


def s_add(left: Surd, right: Surd) -> Surd:
    return left[0] + right[0], left[1] + right[1]


def s_neg(value: Surd) -> Surd:
    return -value[0], -value[1]


def s_mul(left: Surd, right: Surd) -> Surd:
    return (
        left[0] * right[0] + 5 * left[1] * right[1],
        left[0] * right[1] + left[1] * right[0],
    )


def s_scale(value: Surd, scalar: int | Q) -> Surd:
    return value[0] * scalar, value[1] * scalar


def poly_add(left: Polynomial, right: Polynomial, scale: Surd = ONE) -> Polynomial:
    result: defaultdict[Monomial, Surd] = defaultdict(lambda: ZERO)
    result.update(left)
    for exponent, coefficient in right.items():
        result[exponent] = s_add(result[exponent], s_mul(scale, coefficient))
    return {key: value for key, value in result.items() if value != ZERO}


def poly_mul(left: Polynomial, right: Polynomial) -> Polynomial:
    result: defaultdict[Monomial, Surd] = defaultdict(lambda: ZERO)
    for a, u in left.items():
        for b, v in right.items():
            exponent = tuple(a[i] + b[i] for i in range(3))
            result[exponent] = s_add(result[exponent], s_mul(u, v))
    return {key: value for key, value in result.items() if value != ZERO}


def poly_power(poly: Polynomial, exponent: int) -> Polynomial:
    result: Polynomial = {(0, 0, 0): ONE}
    for _ in range(exponent):
        result = poly_mul(result, poly)
    return result


def double_factorial(value: int) -> int:
    result = 1
    for factor in range(value, 0, -2):
        result *= factor
    return result


def sphere_average(poly: Polynomial) -> Surd:
    result = ZERO
    for (a, b, c), coefficient in poly.items():
        if a % 2 or b % 2 or c % 2:
            continue
        moment = Q(
            double_factorial(a - 1)
            * double_factorial(b - 1)
            * double_factorial(c - 1),
            double_factorial(a + b + c + 1),
        )
        result = s_add(result, s_scale(coefficient, moment))
    return result


def antipode(point: tuple[Surd, Surd, Surd]) -> tuple[Surd, Surd, Surd]:
    return tuple(s_neg(value) for value in point)  # type: ignore[return-value]


def dodecahedral_axes() -> list[tuple[Surd, Surd, Surd]]:
    points: list[tuple[Surd, Surd, Surd]] = []
    for a in (-1, 1):
        for b in (-1, 1):
            for c in (-1, 1):
                points.append((s(a), s(b), s(c)))
    for zero_coordinate in range(3):
        for a in (-1, 1):
            for b in (-1, 1):
                short = s_scale(INV_PHI, a)
                long = s_scale(PHI, b)
                points.append(
                    (
                        (ZERO, short, long),
                        (short, long, ZERO),
                        (long, ZERO, short),
                    )[zero_coordinate]
                )

    representatives: list[tuple[Surd, Surd, Surd]] = []
    for point in points:
        if point not in representatives and antipode(point) not in representatives:
            representatives.append(point)
    assert len(points) == 20 and len(representatives) == 10
    return representatives


R2: Polynomial = {
    (2, 0, 0): ONE,
    (0, 2, 0): ONE,
    (0, 0, 2): ONE,
}


def zonal_harmonic(axis: tuple[Surd, Surd, Surd]) -> Polynomial:
    dot: Polynomial = {
        (1, 0, 0): axis[0],
        (0, 1, 0): axis[1],
        (0, 0, 1): axis[2],
    }
    terms = (
        (poly_power(dot, 6), Q(231, 432)),
        (poly_mul(poly_power(dot, 4), R2), Q(-35, 16)),
        (poly_mul(poly_power(dot, 2), poly_power(R2, 2)), Q(35, 16)),
        (poly_power(R2, 3), Q(-5, 16)),
    )
    result: Polynomial = {}
    for poly, coefficient in terms:
        result = poly_add(result, poly, s(coefficient))
    return result


def dot(left: tuple[Surd, ...], right: tuple[Surd, ...]) -> Surd:
    result = ZERO
    for a, b in zip(left, right):
        result = s_add(result, s_mul(a, b))
    return result


def p6(value: Surd) -> Surd:
    value2 = s_mul(value, value)
    value4 = s_mul(value2, value2)
    value6 = s_mul(value4, value2)
    result = s_scale(value6, 231)
    result = s_add(result, s_scale(value4, -315))
    result = s_add(result, s_scale(value2, 105))
    result = s_add(result, s(-5))
    return s_scale(result, Q(1, 16))


def fraction_text(value: Q) -> str:
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def surd_data(value: Surd) -> list[str]:
    return [fraction_text(value[0]), fraction_text(value[1])]


def generate() -> dict[str, object]:
    axes = dodecahedral_axes()
    axis_labels = [
        [1, 2], [1, 3], [1, 4], [1, 5], [3, 4],
        [2, 5], [4, 5], [2, 3], [3, 5], [2, 4],
    ]
    kernel = [
        [p6(s_scale(dot(left, right), Q(1, 3))) for right in axes]
        for left in axes
    ]
    allowed = {s(1), s(Q(47, 243)), s(Q(-65, 243))}
    assert {value for row in kernel for value in row} == allowed
    adjacency = [
        [int(kernel[i][j] == s(Q(-65, 243))) for j in range(10)]
        for i in range(10)
    ]
    assert all(sum(row) == 3 for row in adjacency)
    assert all(
        adjacency[i][j]
        == int(i != j and set(axis_labels[i]).isdisjoint(axis_labels[j]))
        for i in range(10)
        for j in range(10)
    )
    spherical_gram = [
        [s_scale(value, Q(1, 13)) for value in row]
        for row in kernel
    ]

    weights = [3] * 4 + [-2] * 6
    assert [
        sum(row[j] * weights[j] for j in range(10))
        for row in adjacency
    ] == [-2 * value for value in weights]

    field: Polynomial = {}
    for weight, axis in zip(weights, axes):
        field = poly_add(field, zonal_harmonic(axis), s(weight))
    norm = sphere_average(poly_power(field, 2))
    cubic = sphere_average(poly_power(field, 3))
    scalar = s_scale(cubic, Q(1, 20))
    assert norm == s(Q(2800, 351))
    assert cubic == s(Q(-15680000, 1247103))
    assert scalar == s(Q(-784000, 1247103))

    return {
        "schema": "clebsch-harmonic-certificate-v2",
        "field": "Q(sqrt(5)) represented as [rational, sqrt(5)-coefficient]",
        "axis_count": len(axes),
        "axis_labels": axis_labels,
        "axes": [[surd_data(coordinate) for coordinate in axis] for axis in axes],
        "kernel_matrix": [[surd_data(value) for value in row] for row in kernel],
        "spherical_gram_matrix": [
            [surd_data(value) for value in row] for row in spherical_gram
        ],
        "petersen_adjacency": adjacency,
        "petersen_spectrum": {"3": 1, "1": 5, "-2": 4},
        "kernel_spectrum": {"110/81": 1, "28/81": 5, "140/81": 4},
        "spherical_gram_spectrum": {
            "110/1053": 1, "28/1053": 5, "140/1053": 4
        },
        "clebsch_witness": weights,
        "sphere_average_F2": fraction_text(norm[0]),
        "sphere_average_F3": fraction_text(cubic[0]),
        "sigma3_witness": "20",
        "gaunt_scalar": fraction_text(scalar[0]),
        "normalized_witness": "-120*sqrt(273)/3553",
        "normalized_witness_square": "3931200/12623809",
        "wigner_3j_6_6_6_0_0_0": "-20/sqrt(46189)",
        "wigner_3j_square": "400/46189",
        "integral_to_standard_W6": "-130/sqrt(3553*pi)",
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()

    payload = canonical_bytes(generate())
    if args.write:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT}")
        return
    if not OUTPUT.exists() or OUTPUT.read_bytes() != payload:
        raise SystemExit("harmonic Clebsch certificate is stale")
    print("harmonic Clebsch certificate: OK")


if __name__ == "__main__":
    main()
