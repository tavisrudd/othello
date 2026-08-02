#!/usr/bin/env python3
"""Bounded prime-field lacunarity test for C756's first angle cofactor."""

from __future__ import annotations

import argparse
from collections import Counter
from importlib.util import module_from_spec, spec_from_file_location
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-08-01-c756-probability-cheap-tests.py"
AUDIT = HERE / "2026-08-01-c756-saturated-internal-audit.json"
OUTPUT = HERE / "2026-08-02-c756-prime-field-lacunary-first-cofactor.json"
FIELDS = (5, 7, 11, 19, 23, 31, 43)

spec = spec_from_file_location("c756_probability", SOURCE)
source = module_from_spec(spec)
spec.loader.exec_module(source)


def trim(poly):
    while len(poly) > 1 and poly[-1] == 0:
        poly.pop()
    return poly


def add(left, right, p):
    result = [0] * max(len(left), len(right))
    for index, value in enumerate(left):
        result[index] = value
    for index, value in enumerate(right):
        result[index] = (result[index] + value) % p
    return trim(result)


def sub(left, right, p):
    return add(left, [(-value) % p for value in right], p)


def mul(left, right, p):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] = (result[i + j] + a * b) % p
    return trim(result)


def divmod_poly(dividend, divisor, p):
    remainder = trim(dividend[:])
    divisor = trim(divisor[:])
    quotient = [0] * max(1, len(remainder) - len(divisor) + 1)
    inverse_lead = pow(divisor[-1], -1, p)
    while len(remainder) >= len(divisor) and remainder != [0]:
        shift = len(remainder) - len(divisor)
        coefficient = remainder[-1] * inverse_lead % p
        quotient[shift] = coefficient
        for index, value in enumerate(divisor):
            remainder[index + shift] = (
                remainder[index + shift] - coefficient * value
            ) % p
        trim(remainder)
    return trim(quotient), remainder


def mod(poly, modulus, p):
    return divmod_poly(poly, modulus, p)[1]


def mulmod(left, right, modulus, p):
    return mod(mul(left, right, p), modulus, p)


def powmod(base, exponent, modulus, p):
    result = [1]
    base = mod(base, modulus, p)
    while exponent:
        if exponent & 1:
            result = mulmod(result, base, modulus, p)
        base = mulmod(base, base, modulus, p)
        exponent //= 2
    return result


def derivative(poly, p):
    return trim([(index * value) % p for index, value in enumerate(poly[1:], 1)])


def inverse_mod(poly, modulus, p):
    old_r, r = modulus[:], mod(poly, modulus, p)
    old_s, s = [0], [1]
    while r != [0]:
        quotient, remainder = divmod_poly(old_r, r, p)
        old_r, r = r, remainder
        old_s, s = s, sub(old_s, mul(quotient, s, p), p)
    assert len(old_r) == 1 and old_r[0] != 0
    scalar = pow(old_r[0], -1, p)
    return mod([(scalar * value) % p for value in old_s], modulus, p)


def minimal_polynomial(z, eps, p):
    a, b = z
    return [(a * a - eps * b * b) % p, (-2 * a) % p, 1]


def master_polynomial(candidate, eps, p):
    result = [1]
    factors = []
    for z in candidate:
        factor = minimal_polynomial(z, eps, p)
        factors.append(factor)
        result = mul(result, factor, p)
    return result, factors


def frobenius_polynomial(poly, p):
    result = [0] * (p * (len(poly) - 1) + 1)
    for index, value in enumerate(poly):
        result[p * index] = value
    return trim(result)


def first_cofactor_section(factors, master, p):
    """Return E_2' mod G, where E_2 chooses two f's and all other f^p's."""
    sections = [[1], [0], [0]]
    derivatives = [[0], [0], [0]]
    for factor in factors:
        frozen = mod(frobenius_polynomial(factor, p), master, p)
        factor_prime = derivative(factor, p)
        next_sections = [[0], [0], [0]]
        next_derivatives = [[0], [0], [0]]
        for chosen in range(3):
            next_sections[chosen] = mulmod(sections[chosen], frozen, master, p)
            next_derivatives[chosen] = mulmod(
                derivatives[chosen], frozen, master, p
            )
            if chosen:
                next_sections[chosen] = add(
                    next_sections[chosen],
                    mulmod(sections[chosen - 1], factor, master, p),
                    p,
                )
                next_derivatives[chosen] = add(
                    next_derivatives[chosen],
                    mulmod(derivatives[chosen - 1], factor, master, p),
                    p,
                )
                next_derivatives[chosen] = add(
                    next_derivatives[chosen],
                    mulmod(sections[chosen - 1], factor_prime, master, p),
                    p,
                )
        sections, derivatives = next_sections, next_derivatives
    return derivatives[2]


def field_evaluate(poly, value, field, p):
    result = (0, 0)
    for coefficient in reversed(poly):
        result = field["add"](field["mul"](result, value), (coefficient % p, 0))
    return result


def angle(field, p, zi, zj):
    value = field["mul"](
        field["sub"](zi, zj), field["sub"](zi, field["conj"](zj))
    )
    return field["fpow"](value, p * p - p)


def support(poly):
    return sum(value != 0 for value in poly)


def cartier_kernel_profile(poly, p):
    """Profile all p-section operators Lambda_r on the reduced representative."""
    children = []
    for residue in range(p):
        child = trim(poly[residue::p] or [0])
        if child != [0]:
            children.append(child)
    normalized = set()
    for child in children:
        scale = pow(next(value for value in child if value), -1, p)
        normalized.add(tuple((scale * value) % p for value in child))
    return {
        "nonzero_first_sections": len(children),
        "distinct_projective_first_sections": len(normalized),
        "maximum_first_section_support": max(map(support, children), default=0),
    }


def polynomial_profile(poly, p):
    return {
        "degree": len(poly) - 1,
        "support": support(poly),
        "cartier": cartier_kernel_profile(poly, p),
    }


def candidate_profile(candidate, field, p):
    master, factors = master_polynomial(candidate, field["eps"], p)
    assert len(master) - 1 == p + 3
    cleared_with_conormal = first_cofactor_section(factors, master, p)

    # On f_i=0, E_2'=f_i'C_i and f_i'=X-X^p.  This removes f_i
    # canonically on the reduced divisor, without choosing a tangent direction.
    conormal = mod(sub([0, 1], frobenius_polynomial([0, 1], p), p), master, p)
    cleared = mulmod(
        cleared_with_conormal, inverse_mod(conormal, master, p), master, p
    )

    # G'/(X-X^p) restricts to g_i=product_{j!=i} f_j.  Dividing C_i by
    # g_i^p recovers the un-cleared first angle moment.
    reduced_cofactor = mulmod(
        derivative(master, p), inverse_mod(conormal, master, p), master, p
    )
    reduced_cofactor_p = powmod(reduced_cofactor, p, master, p)
    angle_moment = mulmod(
        cleared, inverse_mod(reduced_cofactor_p, master, p), master, p
    )

    for index, zi in enumerate(candidate):
        direct_angles = [angle(field, p, zi, zj)
                         for j, zj in enumerate(candidate) if j != index]
        direct_moment = (0, 0)
        for value in direct_angles:
            direct_moment = field["add"](direct_moment, value)
        assert field_evaluate(angle_moment, zi, field, p) == direct_moment

        direct_cleared = (0, 0)
        for j, factor in enumerate(factors):
            if j == index:
                continue
            term = field_evaluate(factor, zi, field, p)
            for r, other in enumerate(factors):
                if r not in (index, j):
                    term = field["mul"](
                        term,
                        field["fpow"](field_evaluate(other, zi, field, p), p),
                    )
            direct_cleared = field["add"](direct_cleared, term)
        assert field_evaluate(cleared, zi, field, p) == direct_cleared

    return {
        "cleared_first_cofactor": polynomial_profile(cleared, p),
        "angle_moment": polynomial_profile(angle_moment, p),
        "vanishes": cleared == [0],
    }


def range_profile(values):
    return {
        "minimum": min(values),
        "maximum": max(values),
        "distribution": dict(sorted(Counter(values).items())),
    }


def field_row(p, expected_candidates):
    candidates, field = source.saturated_candidates(p)
    assert len(candidates) == expected_candidates
    profiles = [candidate_profile(candidate, field, p) for candidate in candidates]

    def values(section, key, cartier_key=None):
        if cartier_key is None:
            return [row[section][key] for row in profiles]
        return [row[section]["cartier"][cartier_key] for row in profiles]

    result = {
        "q": p,
        "candidate_count": len(profiles),
        "vanishing_candidates": sum(row["vanishes"] for row in profiles),
    }
    for section in ("cleared_first_cofactor", "angle_moment"):
        result[section] = {
            "degree": range_profile(values(section, "degree")),
            "support": range_profile(values(section, "support")),
            "nonzero_cartier_sections": range_profile(values(
                section, "cartier", "nonzero_first_sections"
            )),
            "distinct_projective_cartier_sections": range_profile(values(
                section, "cartier", "distinct_projective_first_sections"
            )),
        }
    return result


def generate():
    expected = {
        row["q"]: row["candidates"]
        for row in json.loads(AUDIT.read_text())["rows"]
    }
    rows = [field_row(p, expected[p]) for p in FIELDS]
    assert rows[0]["vanishing_candidates"] == 2
    assert all(row["vanishing_candidates"] == 0 for row in rows[1:])
    return {
        "schema": "c756-prime-field-lacunary-first-cofactor-v1",
        "scope": (
            "every normalized pairwise-character candidate in the audited prime "
            "fields q in {5,7,11,19,23,31,43}"
        ),
        "construction": (
            "E2=sum_{a<b} f_a f_b product_{r notin {a,b}} f_r^q; "
            "E2'/(X-X^q) mod G is the canonical cleared first cofactor section"
        ),
        "inputs": [SOURCE.name, AUDIT.name],
        "rows": rows,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write and --check")
    rendered = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
    else:
        assert OUTPUT.read_text() == rendered
        print(f"verified {OUTPUT}")


if __name__ == "__main__":
    main()
