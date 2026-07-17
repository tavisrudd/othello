#!/usr/bin/env python3
"""Classify extension persistence of the q=64 coverage singletons.

For every non-repair singleton target, factor the two seed-color elimination
resultants over GF(8), then compute the residue degree of the seed parameter.
This determines exactly which odd extension degrees acquire new candidates.
"""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path

from probe_c210_two_layer_parabolas import QuadraticField, layer, line_points

Poly = tuple[int, ...]
Point = tuple[int, int, int]


def main() -> None:
    field = QuadraticField.for_subfield_order(8)
    base = tuple(x for x in range(field.q) if field.in_subfield(x))
    source = json.loads(Path(__file__).with_name(
        "probe_c210_quadratic_coset_repairs_output.txt"
    ).read_text().splitlines()[-1])
    alpha, beta = source["seed_offsets"]
    eta, a_big, b_big, c_big = source["nonlinear_legal_parameters"][0][:4]
    tau = field.add(beta, field.power(beta, 8))
    omega = field.div(field.add(beta, 1), tau)

    def coordinates(value: int) -> tuple[int, int]:
        for second in base:
            first = field.add(value, field.mul(second, omega))
            if field.in_subfield(first):
                return first, second
        raise AssertionError(value)

    eta0, eta1 = coordinates(eta)
    _, a1 = coordinates(a_big)
    _, b1 = coordinates(b_big)
    c0, c1 = coordinates(c_big)

    seeds = tuple(layer(field, alpha, base) + layer(field, beta, base))
    repairs = {
        r: (1, field.add(eta, r), field.add(
            field.mul(field.add(eta, r), field.add(eta, r)),
            field.add(field.add(field.mul(a_big, field.mul(r, r)),
                                  field.mul(b_big, r)), c_big),
        ))
        for r in base
    }
    affine = {(1, y, z) for y in range(field.q) for z in range(field.q)}
    seed_covered: set[Point] = set()
    for left, right in itertools.combinations(seeds, 2):
        seed_covered.update(affine_line(field, left, right))
    candidates = {point: set() for point in affine - seed_covered}
    for r, repair in repairs.items():
        for seed in seeds:
            for point in affine_line(field, repair, seed):
                if point in candidates:
                    candidates[point].add(r)

    singleton_rows = []
    for point, values in candidates.items():
        if len(values) != 1 or point in repairs.values():
            continue
        r = next(iter(values))
        y0, y1 = coordinates(point[1])
        height = field.add(point[2], field.mul(point[1], point[1]))
        h0, h1 = coordinates(height)
        resultants = []
        for seed_height in (alpha, beta):
            equations = coverage_equations(
                field, coordinates, eta0, eta1, a1, b1, c0, c1,
                seed_height, y0, y1, h0, h1,
            )
            resultant = sylvester_resultant(field, *equations)
            resultants.append((resultant, factor(field, base, resultant)))
        closed_degrees = []
        factor_profiles = []
        for seed_index, (resultant, factors) in enumerate(resultants):
            equations = coverage_equations(
                field, coordinates, eta0, eta1, a1, b1, c0, c1,
                (alpha, beta)[seed_index], y0, y1, h0, h1,
            )
            factor_profiles.append([len(f) - 1 for f in factors])
            for modulus in dict.fromkeys(factors):
                degree = len(modulus) - 1
                gcd = t_gcd_modulus(
                    field, modulus, equations[:3], equations[3:]
                )
                if len(gcd) == 1:
                    continue  # common root only at t=infinity after degree drop
                if len(gcd) == 2 or quadratic_splits(field, modulus, gcd):
                    closed_degrees.append(degree)
                else:
                    closed_degrees.append(2 * degree)
        assert closed_degrees.count(1) == 1
        extra_degrees = sorted(degree for degree in closed_degrees if degree != 1)
        singleton_rows.append({
            "repair_parameter": r,
            "target_coordinates": [y0, y1, h0, h1],
            "seed_resultant_factor_degrees": factor_profiles,
            "extra_closed_point_degrees": extra_degrees,
            "extra_odd_degrees": sorted({
                degree for degree in extra_degrees if degree % 2 == 1
            }),
        })

    assert len(singleton_rows) == 72
    divisors = (3, 5, 7)
    forced_masks = []
    for mask in range(1 << len(divisors)):
        present = {divisors[i] for i in range(len(divisors)) if mask & (1 << i)}
        forced_parameters = []
        for r in base:
            witnesses = [
                row for row in singleton_rows
                if row["repair_parameter"] == r
                and not (set(row["extra_odd_degrees"]) & present)
            ]
            if witnesses:
                forced_parameters.append(r)
        forced_masks.append({
            "odd_divisors_of_m": sorted(present),
            "forced_repair_parameters": sorted(forced_parameters),
            "full_layer_forced": set(forced_parameters) == set(base),
        })

    profile_histogram = Counter(
        tuple(row["extra_odd_degrees"]) for row in singleton_rows
    )
    forcing_witnesses = {}
    for r in base:
        forcing_witnesses[r] = {}
        for divisor in divisors:
            witness = next(
                row for row in singleton_rows
                if row["repair_parameter"] == r
                and row["extra_odd_degrees"] == [divisor]
            )
            forcing_witnesses[r][divisor] = witness["target_coordinates"]

    print(json.dumps({
        "field_tower": "GF(8^m), m odd",
        "orbit": 1,
        "q64_nonrepair_singletons": len(singleton_rows),
        "extra_odd_degree_profile_histogram": {
            "+".join(map(str, profile)): count
            for profile, count in sorted(profile_histogram.items())
        },
        "forcing_witness_target_by_parameter_and_degree": forcing_witnesses,
        "divisibility_summary": forced_masks,
        "reason":
            "a GF(8) singleton persists in GF(8^m) exactly when none of its "
            "extra odd closed-point degrees divides m",
        "consequence":
            "unless 105 divides m, affine coverage forces the full repair "
            "layer, which is not arc-legal for s>=16",
        "status":
            "partial-domain scalar extension obstructed off the 105|m "
            "subtower; that subtower remains open",
    }, sort_keys=True))


def coverage_equations(
    field: QuadraticField,
    coordinates,
    eta0: int,
    eta1: int,
    a1: int,
    b1: int,
    c0: int,
    c1: int,
    seed_height: int,
    y0: int,
    y1: int,
    h0: int,
    h1: int,
) -> tuple[Poly, Poly, Poly, Poly, Poly, Poly]:
    seed0, seed1 = coordinates(seed_height)
    d = field.add(eta0, y0)
    k = field.add(eta1, y1)
    q00 = field.add(field.add(field.mul(d, d), field.mul(k, k)),
                        field.add(h0, c0))
    q10 = field.add(field.add(c1, field.mul(k, k)), h1)
    r00 = field.add(field.add(field.mul(eta0, eta0),
                              field.mul(eta1, eta1)),
                    field.add(seed0, c0))
    r10 = field.add(field.add(c1, field.mul(eta1, eta1)), seed1)
    e0r2 = field.add(y0, field.mul(a1, y1))
    e0r = field.add(field.add(q00, r00), field.mul(b1, y1))
    e0c = field.add(
        field.add(field.mul(eta0, q00), field.mul(eta1, q10)),
        field.add(field.mul(d, r00), field.mul(k, r10)),
    )
    e1r2 = field.add(field.mul(a1, field.add(y0, y1)), y1)
    e1r = field.add(field.add(q10, r10),
                    field.mul(b1, field.add(y0, y1)))
    e1c = field.add(
        field.add(field.mul(eta0, q10), field.mul(eta1, q00)),
        field.add(field.mul(eta1, q10), field.add(
            field.mul(d, r10),
            field.add(field.mul(k, r00), field.mul(k, r10)),
        )),
    )
    # Each triple is the t^2, t, and constant coefficient, as polynomials in r.
    return (
        (d, 1), (q00, 0, 1), (e0c, e0r, e0r2),
        (k,), (q10, b1, a1), (e1c, e1r, e1r2),
    )


def trim(poly: list[int] | tuple[int, ...]) -> Poly:
    out = list(poly)
    while out and out[-1] == 0:
        out.pop()
    return tuple(out)


def poly_add(field: QuadraticField, left: Poly, right: Poly) -> Poly:
    return trim([
        field.add(left[i] if i < len(left) else 0,
                  right[i] if i < len(right) else 0)
        for i in range(max(len(left), len(right)))
    ])


def poly_mul(field: QuadraticField, left: Poly, right: Poly) -> Poly:
    out = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            out[i + j] = field.add(out[i + j], field.mul(a, b))
    return trim(out)


def poly_scale(field: QuadraticField, poly: Poly, scalar: int) -> Poly:
    return trim([field.mul(value, scalar) for value in poly])


def poly_divmod(field: QuadraticField, left: Poly, right: Poly) -> tuple[Poly, Poly]:
    remainder = list(left)
    quotient = [0] * max(1, len(left) - len(right) + 1)
    while len(trim(remainder)) >= len(right):
        remainder = list(trim(remainder))
        degree = len(remainder) - len(right)
        scalar = field.div(remainder[-1], right[-1])
        quotient[degree] = scalar
        for i, value in enumerate(right):
            remainder[i + degree] = field.add(
                remainder[i + degree], field.mul(scalar, value)
            )
    return trim(quotient), trim(remainder)


def sylvester_resultant(field: QuadraticField, *rows: Poly) -> Poly:
    a2, a1, a0, b2, b1, b0 = rows
    zero: Poly = ()
    matrix = (
        (a2, a1, a0, zero), (zero, a2, a1, a0),
        (b2, b1, b0, zero), (zero, b2, b1, b0),
    )
    result: Poly = ()
    for permutation in itertools.permutations(range(4)):
        term: Poly = (1,)
        for i, j in enumerate(permutation):
            term = poly_mul(field, term, matrix[i][j])
        result = poly_add(field, result, term)
    return result


def factor(field: QuadraticField, base: tuple[int, ...], poly: Poly) -> list[Poly]:
    poly = poly_scale(field, poly, field.inv(poly[-1]))
    factors = []
    while len(poly) > 1:
        root = next((x for x in base if poly_value(field, poly, x) == 0), None)
        if root is not None:
            divisor = (root, 1)
        else:
            divisor = ()
            for degree in range(2, (len(poly) - 1) // 2 + 1):
                for coefficients in itertools.product(base, repeat=degree):
                    candidate = tuple(coefficients) + (1,)
                    _, remainder = poly_divmod(field, poly, candidate)
                    if not remainder:
                        divisor = candidate
                        break
                if divisor:
                    break
            if not divisor:
                divisor = poly
        quotient, remainder = poly_divmod(field, poly, divisor)
        assert not remainder
        factors.append(divisor)
        poly = quotient
    return sorted(factors, key=len)


def poly_value(field: QuadraticField, poly: Poly, value: int) -> int:
    out = 0
    for coefficient in reversed(poly):
        out = field.add(field.mul(out, value), coefficient)
    return out


def ext_add(field: QuadraticField, left: Poly, right: Poly) -> Poly:
    return poly_add(field, left, right)


def ext_mul(field: QuadraticField, modulus: Poly, left: Poly, right: Poly) -> Poly:
    _, remainder = poly_divmod(field, poly_mul(field, left, right), modulus)
    return remainder


def ext_inv(field: QuadraticField, modulus: Poly, value: Poly) -> Poly:
    old_r, r = modulus, value
    old_t, t = (), (1,)
    while r:
        quotient, remainder = poly_divmod(field, old_r, r)
        old_r, r = r, remainder
        old_t, t = t, ext_add(
            field, old_t, ext_mul(field, modulus, quotient, t)
        )
    assert len(old_r) == 1
    return poly_scale(field, old_t, field.inv(old_r[0]))


def t_gcd_modulus(
    field: QuadraticField, modulus: Poly,
    left: tuple[Poly, Poly, Poly], right: tuple[Poly, Poly, Poly],
) -> tuple[Poly, ...]:
    def reduce_coefficient(poly: Poly) -> Poly:
        return poly_divmod(field, poly, modulus)[1]

    def t_trim(poly: list[Poly] | tuple[Poly, ...]) -> tuple[Poly, ...]:
        out = list(poly)
        while out and not out[-1]:
            out.pop()
        return tuple(out)

    def t_divmod(a, b):
        remainder = list(a)
        quotient = [()] * max(1, len(a) - len(b) + 1)
        while len(t_trim(remainder)) >= len(b):
            remainder = list(t_trim(remainder))
            degree = len(remainder) - len(b)
            scalar = ext_mul(
                field, modulus, remainder[-1], ext_inv(field, modulus, b[-1])
            )
            quotient[degree] = scalar
            for i, value in enumerate(b):
                remainder[i + degree] = ext_add(
                    field, remainder[i + degree],
                    ext_mul(field, modulus, scalar, value),
                )
        return t_trim(quotient), t_trim(remainder)

    a = t_trim([reduce_coefficient(x) for x in reversed(left)])
    b = t_trim([reduce_coefficient(x) for x in reversed(right)])
    while b:
        _, remainder = t_divmod(a, b)
        a, b = b, remainder
    inverse = ext_inv(field, modulus, a[-1])
    return tuple(ext_mul(field, modulus, x, inverse) for x in a)


def quadratic_splits(
    field: QuadraticField, modulus: Poly, polynomial: tuple[Poly, ...]
) -> bool:
    constant, linear, quadratic = polynomial
    if not linear:
        return True
    ratio = ext_mul(
        field, modulus,
        ext_mul(field, modulus, quadratic, constant),
        ext_mul(field, modulus, ext_inv(field, modulus, linear),
                ext_inv(field, modulus, linear)),
    )
    trace: Poly = ()
    conjugate = ratio
    for _ in range(3 * (len(modulus) - 1)):
        trace = ext_add(field, trace, conjugate)
        conjugate = ext_mul(field, modulus, conjugate, conjugate)
    return not trace


def affine_line(field: QuadraticField, left: Point, right: Point) -> set[Point]:
    return {
        point for point in line_points(field, field.cross(left, right))
        if point[0] == 1
    }


if __name__ == "__main__":
    main()
