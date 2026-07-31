#!/usr/bin/env python3
"""Generate the exact C715 anomaly-inverse certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
import tempfile
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes" / "2026-07-31-c715-golden-anomaly-inverse.json"
TRIPLES = tuple(itertools.combinations(range(6), 3))
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
BASE_TOTAL = (
    ((0, 1), (2, 3), (4, 5)),
    ((0, 2), (1, 4), (3, 5)),
    ((0, 3), (1, 5), (2, 4)),
    ((0, 4), (1, 3), (2, 5)),
    ((0, 5), (1, 2), (3, 4)),
)
RAW_FILTER = (-3, -2, -1, 0, 1, 3)
CHARGES = (11, -10, -8, 5, 4, -2)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def parity(permutation: tuple[int, ...]) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(6)
        for j in range(i + 1, 6)
    )
    return -1 if inversions % 2 else 1


def triangle_cubic(matrix: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return tuple(
        matrix[i][j] * matrix[j][k] * matrix[k][i]
        for i, j, k in TRIPLES
    )


def permute_cubic(cubic: tuple[int, ...], p: tuple[int, ...]) -> tuple[int, ...]:
    target = {}
    for coefficient, support in zip(cubic, TRIPLES):
        target[tuple(sorted(p[i] for i in support))] = coefficient
    return tuple(target[support] for support in TRIPLES)


def total_key(total) -> tuple[tuple[tuple[int, int], ...], ...]:
    return tuple(sorted(tuple(sorted(matching)) for matching in total))


def outer_cubics() -> tuple[tuple[int, ...], ...]:
    base = triangle_cubic(BASE_C)
    oriented = {}
    for p in itertools.permutations(range(6)):
        key = total_key(
            tuple(
                tuple(sorted(tuple(sorted((p[i], p[j]))) for i, j in matching))
                for matching in BASE_TOTAL
            )
        )
        cubic = tuple(parity(p) * value for value in permute_cubic(base, p))
        if key in oriented:
            assert oriented[key] == cubic
        else:
            oriented[key] = cubic
    result = tuple(oriented[key] for key in sorted(oriented))
    assert len(result) == 6
    assert all(sum(cubic[i] for cubic in result) == 0 for i in range(20))
    return result


def matchings(remaining: tuple[int, ...], pairs=()):
    if not remaining:
        yield pairs
        return
    first = remaining[0]
    for index in range(1, len(remaining)):
        yield from matchings(
            remaining[1:index] + remaining[index + 1 :],
            pairs + ((first, remaining[index]),),
        )


def matching_key(matching: tuple[tuple[int, int], ...]) -> str:
    return "|".join(f"{i}{j}" for i, j in matching)


def matching_coefficients(matching: tuple[tuple[int, int], ...]) -> tuple[int, ...]:
    coefficients = {support: 0 for support in TRIPLES}
    for choices in itertools.product((0, 1), repeat=3):
        support = tuple(sorted(matching[j][choices[j]] for j in range(3)))
        coefficients[support] += (-1) ** sum(choices)
    return tuple(coefficients[support] for support in TRIPLES)


def matching_dictionary(cubics):
    result = {}
    for matching in matchings(tuple(range(6))):
        coefficients = matching_coefficients(matching)
        candidates = []
        for i, j in itertools.combinations(range(6), 2):
            for sign in (-1, 1):
                twice_difference = tuple(
                    2 * coefficients[k] - sign * (cubics[i][k] + cubics[j][k])
                    for k in range(20)
                )
                # A multiple of sum_T Z_T is the zero polynomial.
                if len(set(twice_difference)) == 1:
                    candidates.append((sign, i, j))
        assert len(candidates) == 1
        sign, i, j = candidates[0]
        result[matching_key(matching)] = {"sign": sign, "outer_pair": [i, j]}
    assert len(result) == 15
    return result


def matching_value(entry, z):
    i, j = entry["outer_pair"]
    return Fraction(entry["sign"] * (z[i] + z[j]), 2)


def inverse_chart(dictionary, z):
    names = {
        "A0": "01|23|45",
        "A1": "02|13|45",
        "Ad": "03|12|45",
        "B0": "01|24|35",
        "B1": "02|14|35",
        "Bd": "04|12|35",
        "C0": "01|25|34",
        "C1": "02|15|34",
        "Cd": "05|12|34",
    }
    values = {name: matching_value(dictionary[key], z) for name, key in names.items()}
    assert values["A1"] - values["A0"] == values["Ad"]
    assert values["B1"] - values["B0"] == values["Bd"]
    assert values["C1"] - values["C0"] == values["Cd"]
    points = (
        "infinity",
        "0",
        "1",
        str(values["A1"] / values["Ad"]),
        str(values["B1"] / values["Bd"]),
        str(values["C1"] / values["Cd"]),
    )
    return names, values, points


def evaluate(cubic, x) -> int:
    return sum(
        coefficient * math.prod(x[i] for i in support)
        for coefficient, support in zip(cubic, TRIPLES)
    )


def elementary_symmetric_five(values):
    return sum(
        math.prod(values[j] for j in range(6) if j != i)
        for i in range(6)
    )


def vandermonde(values):
    return math.prod(
        values[j] - values[i]
        for i in range(6)
        for j in range(i + 1, 6)
    )


def finite_height(cubics):
    hits = []
    for x in itertools.permutations(range(-3, 4), 6):
        z = tuple(evaluate(cubic, x) for cubic in cubics)
        if z != (0,) * 6 and all(z[i] * CHARGES[0] == z[0] * CHARGES[i] for i in range(6)):
            hits.append({"filter": list(x), "charge_scale": z[0] // CHARGES[0]})
    assert hits == [
        {"filter": [-3, -2, -1, 0, 1, 3], "charge_scale": 4},
        {"filter": [3, 2, 1, 0, -1, -3], "charge_scale": -4},
    ]
    return {
        "height_definition": "max absolute entry of a centered integral representative",
        "height_below_3_impossible": "six distinct integers do not fit in [-2,2]",
        "height_3_search_domain": "ordered distinct sextuples in [-3,3]^6",
        "height_3_checked": math.perm(7, 6),
        "hits": hits,
    }


def trim(polynomial):
    polynomial = list(polynomial)
    while len(polynomial) > 1 and polynomial[-1] == 0:
        polynomial.pop()
    return polynomial


def derivative(polynomial):
    return trim([index * value for index, value in enumerate(polynomial)][1:] or [Fraction(0)])


def polynomial_divmod(left, right):
    left = trim([Fraction(value) for value in left])
    right = trim([Fraction(value) for value in right])
    quotient = [Fraction(0)] * max(1, len(left) - len(right) + 1)
    while len(left) >= len(right) and any(left):
        degree = len(left) - len(right)
        coefficient = left[-1] / right[-1]
        quotient[degree] = coefficient
        for index, value in enumerate(right):
            left[degree + index] -= coefficient * value
        left = trim(left)
    return trim(quotient), trim(left)


def sturm_sequence(polynomial):
    sequence = [trim([Fraction(value) for value in polynomial])]
    sequence.append(derivative(sequence[0]))
    while any(sequence[-1]):
        _, remainder = polynomial_divmod(sequence[-2], sequence[-1])
        if not any(remainder):
            break
        sequence.append([-value for value in remainder])
    return sequence


def sign(value):
    return (value > 0) - (value < 0)


def polynomial_value(polynomial, value):
    answer = Fraction(0)
    for coefficient in reversed(polynomial):
        answer = answer * value + coefficient
    return answer


def variations(sequence, point):
    signs = []
    for polynomial in sequence:
        if point is None:
            current = sign(polynomial[-1])
        elif point == "-infinity":
            current = sign(polynomial[-1]) * (-1 if (len(polynomial) - 1) % 2 else 1)
        else:
            current = sign(polynomial_value(polynomial, point))
        if current:
            signs.append(current)
    return sum(signs[i] != signs[i - 1] for i in range(1, len(signs)))


def root_count(sequence, left, right):
    left_point = "-infinity" if left is None else left
    right_point = None if right is None else right
    return variations(sequence, left_point) - variations(sequence, right_point)


def multiply(left, right):
    result = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] += a * b
    return trim(result)


def critical_polynomial(range_pair):
    coefficients = [2 if root in range_pair else -1 for root in RAW_FILTER]
    result = [Fraction(0)] * 6
    for i, root in enumerate(RAW_FILTER):
        term = [Fraction(1)]
        for j, other in enumerate(RAW_FILTER):
            if i != j:
                term = multiply(term, [-other, 1])
        for degree, value in enumerate(term):
            result[degree] += coefficients[i] * value
    result = trim(result)
    denominators = [value.denominator for value in result]
    common = math.lcm(*denominators)
    integers = [int(value * common) for value in result]
    divisor = math.gcd(*[abs(value) for value in integers if value])
    integers = [value // divisor for value in integers]
    if integers[-1] < 0:
        integers = [-value for value in integers]
    return integers


def isolate_root(polynomial, left, right, total_count):
    sequence = sturm_sequence(polynomial)
    if total_count == 0:
        return None
    finite_left = Fraction(-64) if left is None else left
    while left is None and root_count(sequence, None, finite_left):
        finite_left *= 2
    finite_right = Fraction(64) if right is None else right
    while right is None and root_count(sequence, finite_right, None):
        finite_right *= 2
    assert root_count(sequence, finite_left, finite_right) == 1
    while finite_right - finite_left > Fraction(1, 10**12):
        middle = (finite_left + finite_right) / 2
        if root_count(sequence, finite_left, middle):
            finite_right = middle
        else:
            finite_left = middle
    return finite_left, finite_right


def fraction_string(value):
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def success_multiplier(t):
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
        endpoints = (abs(left - root), abs(right - root))
        factor_min, factor_max = min(endpoints), max(endpoints)
        if root in range_pair:
            numerator_min *= factor_min**2
            numerator_max *= factor_max**2
        else:
            denominator_min *= factor_min
            denominator_max *= factor_max
    return constant * numerator_min / denominator_max, constant * numerator_max / denominator_min


def optimization_certificate():
    domains = [
        (None, Fraction(-3), (-3, 3), True),
        (Fraction(-3), Fraction(-2), (-3, -2), False),
        (Fraction(-2), Fraction(-1), (-2, -1), False),
        (Fraction(-1), Fraction(0), (-1, 0), False),
        (Fraction(0), Fraction(1), (0, 1), False),
        (Fraction(1), Fraction(3), (1, 3), False),
        (Fraction(3), None, (-3, 3), True),
    ]
    rows = []
    global_lower = None
    competitor_uppers = []
    for index, (left, right, range_pair, outside) in enumerate(domains):
        polynomial = critical_polynomial(range_pair)
        sequence = sturm_sequence(polynomial)
        count = root_count(sequence, left, right)
        isolation = isolate_root(polynomial, left, right, count)
        row = {
            "domain": ["-infinity" if left is None else fraction_string(left), "infinity" if right is None else fraction_string(right)],
            "range_pair": list(range_pair),
            "critical_polynomial_ascending": polynomial,
            "critical_root_count": count,
        }
        if isolation:
            lower, upper = isolation
            bounds = multiplier_bounds(range_pair, lower, upper, outside)
            row["root_isolation"] = [fraction_string(lower), fraction_string(upper)]
            row["multiplier_bounds"] = [fraction_string(bounds[0]), fraction_string(bounds[1])]
            row["root_midpoint_decimal"] = float((lower + upper) / 2)
            row["multiplier_midpoint_decimal"] = float(success_multiplier((lower + upper) / 2))
            if index == 0:
                global_lower = bounds[0]
            else:
                competitor_uppers.append(bounds[1])
        else:
            assert index == 6
            row["supremum_at_infinity"] = "1/27"
            competitor_uppers.append(Fraction(1, 27))
        rows.append(row)
    assert global_lower is not None and global_lower > max(competitor_uppers)

    primitive = rows[0]["critical_polynomial_ascending"]
    rational_candidates = {
        Fraction(numerator, denominator)
        for numerator in (1, 3, 9, -1, -3, -9)
        for denominator in (1,)
    }
    assert all(polynomial_value(primitive, candidate) for candidate in rational_candidates)

    rational_t = Fraction(-15)
    multiplier = success_multiplier(rational_t)
    assert multiplier == Fraction(18, 455)
    normalized_filter = tuple(
        Fraction(72, root + 15) - 5 for root in RAW_FILTER
    )
    assert normalized_filter == (
        Fraction(1), Fraction(7, 13), Fraction(1, 7), Fraction(-1, 5), Fraction(-1, 2), Fraction(-1)
    )
    gain = (multiplier / Fraction(1, 27)) ** 2
    assert gain == Fraction(236196, 207025)
    compact_polynomial = [-9, 51, -24, -3, 1]
    compact_parameter = Fraction(1, 5)
    compact_filter = tuple(-value for value in normalized_filter)
    compact_amplitude_gain = Fraction(486, 455)
    assert compact_filter == (
        Fraction(-1), Fraction(-7, 13), Fraction(-1, 7), Fraction(1, 5), Fraction(1, 2), Fraction(1)
    )
    assert compact_amplitude_gain**2 == gain
    return {
        "parameterization": "y_i=1/(r_i-t), followed by the unique affine normalization with range [-1,1]",
        "base_filter": list(RAW_FILTER),
        "base_charge_scale": 4,
        "multiplier_definition": "Z(normalize(1/(r-t))) = 4*m(t)*q",
        "domains": rows,
        "global_maximum_domain": ["-infinity", "-3"],
        "global_maximizer_is_irrational": True,
        "rational_filters_have_supremum_not_maximum": True,
        "explicit_better_rational_pole": fraction_string(rational_t),
        "explicit_better_filter": [fraction_string(value) for value in normalized_filter],
        "explicit_multiplier": fraction_string(multiplier),
        "explicit_charge_scale": fraction_string(4 * multiplier),
        "probability_gain_over_integral_witness": fraction_string(gain),
        "compact_parameterization": {
            "map": "h_u(v)=(v+u)/(u*v+1), with pole t=-3/u in the raw-pole parameter",
            "critical_polynomial_ascending": compact_polynomial,
            "maximizer_decimal": 0.194719332570311,
            "explicit_rational_parameter": fraction_string(compact_parameter),
            "explicit_filter": [fraction_string(value) for value in compact_filter],
            "explicit_amplitude_gain": fraction_string(compact_amplitude_gain),
        },
    }


def generate():
    cubics = outer_cubics()
    assert tuple(evaluate(cubic, RAW_FILTER) for cubic in cubics) == tuple(4 * value for value in CHARGES)
    discriminant_tests = []
    for sample in (tuple(range(6)), RAW_FILTER, (1, 2, 4, 7, 11, 16)):
        z_sample = tuple(evaluate(cubic, sample) for cubic in cubics)
        left = elementary_symmetric_five(z_sample)
        right = 32 * vandermonde(sample)
        assert left == right
        discriminant_tests.append({"filter": list(sample), "value": left})
    dictionary = matching_dictionary(cubics)
    chart_names, chart_values, chart_points = inverse_chart(dictionary, CHARGES)
    assert chart_points == ("infinity", "0", "1", "4/3", "3/2", "5/3")
    height = finite_height(cubics)
    optimization = optimization_certificate()
    witness_scale = Fraction(4, 27)
    probabilities = [witness_scale**2 * value**2 / 500 for value in CHARGES]
    return {
        "schema": "c715-golden-anomaly-inverse-v1",
        "frozen_marking": {
            "triple_order": [list(triple) for triple in TRIPLES],
            "outer_cubics": [list(cubic) for cubic in cubics],
        },
        "matching_dictionary": dictionary,
        "collision_discriminant": {
            "identity": "e5(Z(x))=32*product_{i<j}(x_j-x_i)",
            "normalization_tests": discriminant_tests,
        },
        "inverse_chart": {
            "normalization": ["infinity", "0", "1", "a", "b", "c"],
            "matching_names": chart_names,
            "matching_values_at_charge_witness": {key: fraction_string(value) for key, value in chart_values.items()},
            "reconstructed_points": list(chart_points),
        },
        "charge_witness": {
            "primitive_charges": list(CHARGES),
            "integral_filter": list(RAW_FILTER),
            "physical_filter": [fraction_string(Fraction(value, 3)) for value in RAW_FILTER],
            "physical_charge_scale": fraction_string(witness_scale),
            "success_probabilities": [fraction_string(value) for value in probabilities],
            "expected_trials": [fraction_string(1 / value) for value in probabilities],
        },
        "finite_height": height,
        "success_optimization": optimization,
    }


def canonical_bytes(data) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(generate())
    if args.check:
        assert OUTPUT.read_bytes() == payload
        print(f"C715 certificate OK: {sha256(OUTPUT)}")
        return
    with tempfile.NamedTemporaryFile(dir=OUTPUT.parent, delete=False) as handle:
        handle.write(payload)
        temporary = Path(handle.name)
    temporary.replace(OUTPUT)
    print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
