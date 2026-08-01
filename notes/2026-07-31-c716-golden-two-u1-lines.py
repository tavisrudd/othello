#!/usr/bin/env python3
"""Generate the exact C716 two-U(1) Golden-line certificate."""

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
OUTPUT = ROOT / "notes" / "2026-07-31-c716-golden-two-u1-lines.json"
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
                difference = tuple(
                    2 * coefficients[k] - sign * (cubics[i][k] + cubics[j][k])
                    for k in range(20)
                )
                if len(set(difference)) == 1:
                    candidates.append((sign, i, j))
        assert len(candidates) == 1
        sign, i, j = candidates[0]
        result[matching_key(matching)] = {"sign": sign, "outer_pair": (i, j)}
    return result


def evaluate(cubic, x):
    return sum(
        coefficient * math.prod(x[i] for i in support)
        for coefficient, support in zip(cubic, TRIPLES)
    )


def amplitude(cubics, x):
    return tuple(evaluate(cubic, x) for cubic in cubics)


def primitive(values) -> tuple[int, ...]:
    values = tuple(Fraction(value) for value in values)
    denominator = math.lcm(*(value.denominator for value in values))
    integers = tuple(int(value * denominator) for value in values)
    divisor = math.gcd(*integers)
    integers = tuple(value // abs(divisor) for value in integers)
    for value in integers:
        if value:
            return tuple(-x for x in integers) if value < 0 else integers
    return integers


def anomaly_certificate(q, r):
    values = {
        "linear_q": sum(q),
        "linear_r": sum(r),
        "cubic_q": sum(x**3 for x in q),
        "q_squared_r": sum(q[i] ** 2 * r[i] for i in range(6)),
        "q_r_squared": sum(q[i] * r[i] ** 2 for i in range(6)),
        "cubic_r": sum(x**3 for x in r),
    }
    assert all(Fraction(value).denominator == 1 for value in values.values())
    return {key: int(value) for key, value in values.items()}


def strict_chiral(q) -> bool:
    return all(q) and all(q[i] + q[j] for i, j in itertools.combinations(range(6), 2))


def permute_control(values, permutation):
    result = [None] * 6
    for old, new in enumerate(permutation):
        result[new] = values[old]
    return tuple(result)


def fraction_string(value):
    value = Fraction(value)
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def vector_strings(values):
    return [fraction_string(value) for value in values]


def collision_synthemes(dictionary):
    result = {}
    for i, j in itertools.combinations(range(6), 2):
        pairs = []
        for key, entry in dictionary.items():
            matching = tuple(tuple(int(x) for x in pair) for pair in key.split("|"))
            if (i, j) in matching:
                pairs.append(tuple(entry["outer_pair"]))
        assert len(pairs) == 3
        assert sorted(x for pair in pairs for x in pair) == list(range(6))
        result[f"{i}{j}"] = [list(pair) for pair in sorted(pairs)]
    return result


def line_from_controls(cubics, intercept, moving_index):
    q = amplitude(cubics, intercept)
    endpoint = list(intercept)
    endpoint[moving_index] += 1
    endpoint = amplitude(cubics, tuple(endpoint))
    r = tuple(endpoint[i] - q[i] for i in range(6))
    assert all(value == 0 for value in anomaly_certificate(q, r).values())
    return q, r


def chiral_components(cubics):
    base = (
        Fraction(0), Fraction(-1, 2), Fraction(-1),
        Fraction(-3, 7), Fraction(0), Fraction(-3, 5),
    )
    result = []
    for moving in range(6):
        permutation = list(range(6))
        permutation[4], permutation[moving] = permutation[moving], permutation[4]
        intercept = permute_control(base, permutation)
        q, r = line_from_controls(cubics, intercept, moving)
        witness = tuple(q[i] + Fraction(1, 2) * r[i] for i in range(6))
        assert strict_chiral(witness)
        result.append(
            {
                "component": f"D_path_{moving}",
                "moving_path": moving,
                "control_intercept": vector_strings(intercept),
                "control_direction": [1 if i == moving else 0 for i in range(6)],
                "amplitude_intercept": vector_strings(q),
                "amplitude_direction": vector_strings(r),
                "lambda_half_primitive_charge": list(primitive(witness)),
                "anomaly_coefficients": anomaly_certificate(q, r),
            }
        )
    assert result[4]["lambda_half_primitive_charge"] == [59, 29, 19, -55, -41, -11]
    return result


def plane_components(cubics, synthemes):
    base = (
        Fraction(0), Fraction(0), Fraction(-1),
        Fraction(-1, 2), Fraction(1, 2), Fraction(0),
    )
    result = []
    remaining_base = (2, 3, 4, 5)
    for i, j in itertools.combinations(range(6), 2):
        remaining = tuple(k for k in range(6) if k not in (i, j))
        permutation = [None] * 6
        permutation[0], permutation[1] = i, j
        for old, new in zip(remaining_base, remaining):
            permutation[old] = new
        intercept = permute_control(base, permutation)
        moving = permutation[5]
        q, r = line_from_controls(cubics, intercept, moving)
        charge_pairs = synthemes[f"{i}{j}"]
        for a, b in charge_pairs:
            assert q[a] + q[b] == r[a] + r[b] == 0
        witness = tuple(q[k] + Fraction(1, 2) * r[k] for k in range(6))
        result.append(
            {
                "component": f"P_collision_{i}{j}",
                "collision_pair": [i, j],
                "charge_syntheme": charge_pairs,
                "moving_path": moving,
                "control_intercept": vector_strings(intercept),
                "control_direction": [1 if k == moving else 0 for k in range(6)],
                "amplitude_intercept": vector_strings(q),
                "amplitude_direction": vector_strings(r),
                "lambda_half_primitive_charge": list(primitive(witness)),
                "anomaly_coefficients": anomaly_certificate(q, r),
            }
        )
    return result


def richmond_map(v):
    a, b, c, d = v
    return (
        -a*c+b*c+a*d-b*d-a*b+c*d,
        -a*c+b*c+a*d-b*d+a*b-c*d,
        a*c+b*c-a*d+b*d-a*b-c*d,
        -a*c-b*c-a*d+b*d+a*b+c*d,
        a*c-b*c+a*d+b*d-a*b-c*d,
        a*c-b*c-a*d-b*d+a*b+c*d,
    )


def poly_add(a, b):
    size = max(len(a), len(b))
    return tuple(
        Fraction(a[i] if i < len(a) else 0) + Fraction(b[i] if i < len(b) else 0)
        for i in range(size)
    )


def poly_neg(a):
    return tuple(-x for x in a)


def poly_mul(a, b):
    result = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            result[i+j] += x*y
    return tuple(result)


def poly_derivative(a):
    return tuple(i*a[i] for i in range(1, len(a))) or (Fraction(0),)


def rational_subtract(a, b):
    return (
        poly_add(poly_mul(a[0], b[1]), poly_neg(poly_mul(b[0], a[1]))),
        poly_mul(a[1], b[1]),
    )


def rational_multiply(a, b):
    return poly_mul(a[0], b[0]), poly_mul(a[1], b[1])


def rational_divide(a, b):
    return poly_mul(a[0], b[1]), poly_mul(a[1], b[0])


def rational_constant(a):
    numerator = poly_add(
        poly_mul(poly_derivative(a[0]), a[1]),
        poly_neg(poly_mul(a[0], poly_derivative(a[1]))),
    )
    return all(value == 0 for value in numerator)


INFINITY = None


def cross_ratio(a, b, c, d):
    if a is INFINITY:
        return rational_divide(rational_subtract(b, d), rational_subtract(b, c))
    return rational_divide(
        rational_multiply(rational_subtract(a, c), rational_subtract(b, d)),
        rational_multiply(rational_subtract(a, d), rational_subtract(b, c)),
    )


def inverse_points(dictionary, q, r):
    points = [INFINITY, ((Fraction(0),), (Fraction(1),)), ((Fraction(1),), (Fraction(1),))]
    for numerator_key, denominator_key in (
        ("02|13|45", "03|12|45"),
        ("02|14|35", "04|12|35"),
        ("02|15|34", "05|12|34"),
    ):
        forms = []
        for key in (numerator_key, denominator_key):
            entry = dictionary[key]
            i, j = entry["outer_pair"]
            sign = Fraction(entry["sign"], 2)
            forms.append((sign*(q[i]+q[j]), sign*(r[i]+r[j])))
        points.append((forms[0], forms[1]))
    return points


def moving_path_from_line(dictionary, q, r):
    points = inverse_points(dictionary, q, r)
    candidates = []
    for omitted in range(6):
        remaining = tuple(i for i in range(6) if i != omitted)
        if all(
            rational_constant(cross_ratio(*(points[i] for i in indices)))
            for indices in itertools.combinations(remaining, 4)
        ):
            candidates.append(omitted)
    assert len(candidates) == 1
    return candidates[0]


def source_component_map(dictionary):
    special = (
        (1, 0, 0, 0), (0, 1, 0, 0), (0, 0, 1, 0),
        (0, 0, 0, 1), (1, 1, 1, 1),
    )
    directions = (
        (2, 3, 5, 7), (3, 5, 7, 11), (5, 7, 11, 13),
        (7, 11, 13, 17), (2, 5, 11, 17),
    )
    result = {}
    for source_index, (point, direction) in enumerate(zip(special, directions), 1):
        quadratic = richmond_map(direction)
        mixed = richmond_map(tuple(point[i]+direction[i] for i in range(4)))
        q = tuple(mixed[i]-quadratic[i] for i in range(6))
        r = quadratic
        result[f"D{source_index}"] = moving_path_from_line(dictionary, q, r)
    q0 = (2, -2, 4, 0, -4, 0)
    r0 = (1, 7, -7, -5, 5, -1)
    result["D0"] = moving_path_from_line(dictionary, q0, r0)
    expected = {"D0": 4, "D1": 1, "D2": 0, "D3": 2, "D4": 3, "D5": 5}
    assert result == expected
    return result


def outer_action_generators(cubics):
    result = {}
    for adjacent in range(5):
        permutation = list(range(6))
        permutation[adjacent], permutation[adjacent+1] = (
            permutation[adjacent+1], permutation[adjacent]
        )
        charge_permutation = []
        signs = []
        for cubic in cubics:
            transformed = permute_cubic(cubic, tuple(permutation))
            hits = [
                (index, sign)
                for index, candidate in enumerate(cubics)
                for sign in (-1, 1)
                if transformed == tuple(sign*value for value in candidate)
            ]
            assert len(hits) == 1
            charge_permutation.append(hits[0][0])
            signs.append(hits[0][1])
        assert signs == [-1]*6
        result[f"path_transposition_{adjacent}{adjacent+1}"] = {
            "charge_coordinate_image": charge_permutation,
            "common_oriented_sign": -1,
            "chiral_component_image": permutation,
        }
    return result


def generate():
    cubics = outer_cubics()
    dictionary = matching_dictionary(cubics)
    synthemes = collision_synthemes(dictionary)
    chiral = chiral_components(cubics)
    planes = plane_components(cubics, synthemes)
    assert len(chiral) == 6 and len(planes) == 15
    return {
        "schema": "c716-golden-two-u1-lines-v1",
        "frozen_c707_marking": {
            "triple_order": [list(support) for support in TRIPLES],
            "outer_cubics": [list(cubic) for cubic in cubics],
        },
        "line_criterion_coefficient_order": [
            "sum(q)", "sum(r)", "sum(q^3)", "sum(q^2*r)",
            "sum(q*r^2)", "sum(r^3)",
        ],
        "collision_pair_to_charge_syntheme": synthemes,
        "source_2607_09879_to_c707_component": source_component_map(dictionary),
        "outer_s6_coxeter_generators": outer_action_generators(cubics),
        "chiral_components": chiral,
        "plane_components": planes,
        "operator_normalization": {
            "pfaffian": "Pf([D_x,C_T])=4*Z_T(x)",
            "determinant": "det([D_x,C_T])=16*Z_T(x)^2",
            "mixed_identity_1": "sum_T det(A_T(x))*Pf(A_T(y))=0",
            "mixed_identity_2": "sum_T Pf(A_T(x))*det(A_T(y))=0",
        },
        "counts": {
            "chiral_del_pezzo_components": len(chiral),
            "nonchiral_plane_components": len(planes),
            "exact_line_families": len(chiral) + len(planes),
        },
    }


def render(data):
    return json.dumps(data, indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    text = render(generate())
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUTPUT.name
            candidate.write_text(text)
            assert candidate.read_bytes() == OUTPUT.read_bytes(), "tracked certificate is stale"
        print(f"ok: {OUTPUT.relative_to(ROOT)} ({hashlib.sha256(text.encode()).hexdigest()})")
    else:
        OUTPUT.write_text(text)
        print(f"wrote {OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
