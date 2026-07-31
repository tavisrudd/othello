#!/usr/bin/env python3
"""Independent exact replay of the finite and optimization claims in C715."""

from __future__ import annotations

import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-07-31-c715-golden-anomaly-inverse.json"
TRIPLES = tuple(itertools.combinations(range(6), 3))
CHARGES = (11, -10, -8, 5, 4, -2)
RAW_FILTER = (-3, -2, -1, 0, 1, 3)
CUBICS = (
    (-1, -1, 1, 1, 1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, -1, -1, -1, 1, 1),
    (1, 1, -1, -1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, 1, 1, 1, 1, -1, -1),
    (1, -1, 1, -1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, 1, -1, 1, -1, 1, -1),
    (-1, 1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1),
    (-1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, 1, -1, -1, 1, 1, -1, -1, 1),
    (1, -1, -1, 1, -1, 1, -1, 1, 1, -1, 1, -1, -1, 1, -1, 1, -1, 1, 1, -1),
)


def parse(value: str) -> Fraction:
    return Fraction(value)


def evaluate(cubic, x):
    return sum(
        coefficient * math.prod(x[i] for i in support)
        for coefficient, support in zip(cubic, TRIPLES)
    )


def elementary_symmetric_five(values):
    return sum(math.prod(values[j] for j in range(6) if j != i) for i in range(6))


def vandermonde(values):
    return math.prod(values[j] - values[i] for i in range(6) for j in range(i + 1, 6))


def polynomial_value(coefficients, value):
    answer = Fraction(0)
    for coefficient in reversed(coefficients):
        answer = answer * value + coefficient
    return answer


def descartes_transform(coefficients, left, right):
    degree = len(coefficients) - 1
    transformed = [0] * (degree + 1)
    if left is None:
        # t = right-u, u>0.
        for k, coefficient in enumerate(coefficients):
            for j in range(k + 1):
                transformed[j] += coefficient * math.comb(k, j) * right ** (k - j) * (-1) ** j
    elif right is None:
        # t = left+u, u>0.
        for k, coefficient in enumerate(coefficients):
            for j in range(k + 1):
                transformed[j] += coefficient * math.comb(k, j) * left ** (k - j)
    else:
        # t=(left+right*u)/(1+u), multiplied by (1+u)^degree.
        for k, coefficient in enumerate(coefficients):
            for j in range(k + 1):
                for h in range(degree - k + 1):
                    transformed[j + h] += (
                        coefficient
                        * math.comb(k, j)
                        * left ** (k - j)
                        * right**j
                        * math.comb(degree - k, h)
                    )
    return transformed


def sign_variations(coefficients):
    signs = [(value > 0) - (value < 0) for value in coefficients if value]
    return sum(signs[i] != signs[i - 1] for i in range(1, len(signs)))


def multiplier(t):
    values = [Fraction(1, root - t) for root in RAW_FILTER]
    spread = max(values) - min(values)
    product = math.prod(abs(Fraction(root) - t) for root in RAW_FILTER)
    return (Fraction(2) / spread) ** 3 / product


def multiplier_bounds(range_pair, left, right, outside):
    a, b = range_pair
    constant = Fraction(1, 27) if outside else Fraction(8, (b - a) ** 3)
    numerator_min = numerator_max = Fraction(1)
    denominator_min = denominator_max = Fraction(1)
    for root in RAW_FILTER:
        factor_min = min(abs(left - root), abs(right - root))
        factor_max = max(abs(left - root), abs(right - root))
        if root in range_pair:
            numerator_min *= factor_min**2
            numerator_max *= factor_max**2
        else:
            denominator_min *= factor_min
            denominator_max *= factor_max
    return constant * numerator_min / denominator_max, constant * numerator_max / denominator_min


def main():
    data = json.loads(CERTIFICATE.read_text())
    assert tuple(tuple(row) for row in data["frozen_marking"]["outer_cubics"]) == CUBICS
    assert tuple(evaluate(cubic, RAW_FILTER) for cubic in CUBICS) == tuple(4 * value for value in CHARGES)
    for sample in (tuple(range(6)), RAW_FILTER, (1, 2, 4, 7, 11, 16)):
        z_sample = tuple(evaluate(cubic, sample) for cubic in CUBICS)
        assert elementary_symmetric_five(z_sample) == 32 * vandermonde(sample)
        assert math.prod(
            z_sample[i] + z_sample[j]
            for i, j in itertools.combinations(range(6), 2)
        ) == -(elementary_symmetric_five(z_sample) ** 3)

    hits = []
    for x in itertools.permutations(range(-3, 4), 6):
        z = tuple(evaluate(cubic, x) for cubic in CUBICS)
        if z != (0,) * 6 and all(z[i] * CHARGES[0] == z[0] * CHARGES[i] for i in range(6)):
            hits.append((x, z[0] // CHARGES[0]))
    assert hits == [(RAW_FILTER, 4), (tuple(-value for value in RAW_FILTER), -4)]

    domains = data["success_optimization"]["domains"]
    global_lower = None
    competitor_uppers = []
    for index, row in enumerate(domains):
        left_text, right_text = row["domain"]
        left = None if left_text == "-infinity" else parse(left_text)
        right = None if right_text == "infinity" else parse(right_text)
        polynomial = row["critical_polynomial_ascending"]
        transformed = descartes_transform(polynomial, left, right)
        variations = sign_variations(transformed)
        assert variations == row["critical_root_count"]
        if variations:
            lower, upper = map(parse, row["root_isolation"])
            assert polynomial_value(polynomial, lower) * polynomial_value(polynomial, upper) < 0
            bounds = multiplier_bounds(tuple(row["range_pair"]), lower, upper, index in (0, 6))
            assert list(map(parse, row["multiplier_bounds"])) == list(bounds)
            if index == 0:
                global_lower = bounds[0]
            else:
                competitor_uppers.append(bounds[1])
        else:
            competitor_uppers.append(Fraction(1, 27))
    assert global_lower is not None and global_lower > max(competitor_uppers)

    # The unique global critical point is not rational by the rational-root theorem.
    global_polynomial = domains[0]["critical_polynomial_ascending"]
    assert global_polynomial == [-9, -9, 24, 17, 1]
    assert all(polynomial_value(global_polynomial, Fraction(candidate)) for candidate in (1, 3, 9, -1, -3, -9))

    assert multiplier(Fraction(-15)) == Fraction(18, 455)
    assert (multiplier(Fraction(-15)) / Fraction(1, 27)) ** 2 == Fraction(236196, 207025)
    compact = data["success_optimization"]["compact_parameterization"]
    assert compact["critical_polynomial_ascending"] == [-9, 51, -24, -3, 1]
    assert parse(compact["explicit_amplitude_gain"]) == Fraction(486, 455)
    assert parse(compact["explicit_amplitude_gain"]) ** 2 == Fraction(236196, 207025)
    general = data["general_real_fibre_optimization"]
    assert general["degree_bound"] == 4
    assert all(
        len(polynomial) <= 5
        for polynomial in general["example_critical_polynomials_ascending"].values()
    )
    print("C715 independent replay OK: 15 matchings, 5040 height-three filters, 7 real pole domains")


if __name__ == "__main__":
    main()
