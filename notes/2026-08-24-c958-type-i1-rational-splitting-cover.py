#!/usr/bin/env python3
"""Rationalize the type-I1 splitting field and its exceptional sections."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "notes/2026-08-24-c958-type-i1-exceptional-sections.json"
EXPECTED_INPUT_SHA256 = "cb7ad6fbd78b44f692d28c057c6d591ffcca87e6f0973a50ad23d002c17fab24"

a, beta, r, d, v, z = sp.symbols("a beta r d v z")
s, t = sp.symbols("s t")


def canonical(expression):
    return sp.factor(sp.cancel(expression))


def transform(expression, image):
    return canonical(expression.subs(z, image, simultaneous=True))


def build():
    input_bytes = INPUT.read_bytes()
    assert hashlib.sha256(input_bytes).hexdigest() == EXPECTED_INPUT_SHA256
    source = json.loads(input_bytes)

    m = canonical((z**2 - 3) / (2 * z))
    n = canonical((z**2 + 3) / (2 * z))
    r0 = canonical(2 * a * (z**4 - 18 * z**2 + 9) / (z**2 + 3) ** 2)
    d0 = canonical(-24 * a * z * (z**2 - 3) / (z**2 + 3) ** 2)
    beta0 = canonical(r0**3 - 3 * a**2 * r0)
    v0 = canonical(36 * a**2 * z * (z - 3) * (z - 1) * (z + 1) * (z + 3) / (z**2 + 3) ** 3)
    u0 = canonical(-3 * (r0**2 - a**2) * d0)
    e20 = canonical(v0 * u0 / (9 * (2 * a**3 - beta0)))

    assert canonical(d0 / (r0 - 2 * a) - m) == 0
    recovered_n = canonical(18 * a**2 * (m**2 - 1) / (v0 * (m**2 + 3)))
    assert canonical(recovered_n - n) == 0
    assert canonical(m + recovered_n - z) == 0
    assert canonical(r0**3 - 3 * a**2 * r0 - beta0) == 0
    assert canonical(d0**2 + 3 * r0**2 - 12 * a**2) == 0
    assert canonical(v0**2 - 3 * a * (2 * a**3 - beta0)) == 0
    assert canonical(u0**2 - 27 * (2 * a**3 + beta0) * (2 * a**3 - beta0)) == 0
    assert canonical(e20**2 - a * (2 * a**3 + beta0)) == 0

    mobius = {
        "sigma": canonical(-(z + 3) / (z - 1)),
        "tau": canonical(3 / z),
        "iota": canonical(-3 / z),
    }
    sigma, tau, iota = mobius["sigma"], mobius["tau"], mobius["iota"]
    sigma2 = transform(sigma, sigma)
    sigma3 = transform(sigma2, sigma)
    assert canonical(sigma3 - z) == 0 and canonical(sigma - z) != 0
    assert canonical(transform(tau, tau) - z) == 0
    assert canonical(transform(iota, iota) - z) == 0
    assert canonical(transform(transform(tau, sigma), tau) - sigma2) == 0
    assert canonical(transform(sigma, iota) - transform(iota, sigma)) == 0
    assert canonical(transform(tau, iota) - transform(iota, tau)) == 0

    group = {str(z): z}
    frontier = [z]
    while frontier:
        value = frontier.pop()
        for generator in mobius.values():
            for product in (transform(value, generator), transform(generator, value)):
                key = str(product)
                if key not in group:
                    group[key] = product
                    frontier.append(product)
    assert len(group) == 12

    for image in mobius.values():
        assert canonical(transform(beta0, image) - beta0) == 0
    expected_actions = {
        "sigma": ((-r0 + d0) / 2, (-3 * r0 - d0) / 2, v0),
        "tau": (r0, -d0, v0),
        "iota": (r0, d0, -v0),
    }
    for name, image in mobius.items():
        transformed = tuple(transform(value, image) for value in (r0, d0, v0))
        assert all(canonical(left - right) == 0 for left, right in zip(transformed, expected_actions[name]))

    beta_numerator_expression, beta_denominator_expression = sp.fraction(beta0)
    beta_numerator = sp.Poly(beta_numerator_expression, z, domain=sp.QQ.frac_field(a))
    beta_denominator = sp.Poly(beta_denominator_expression, z, domain=sp.QQ.frac_field(a))
    assert sp.gcd(beta_numerator, beta_denominator) == 1
    assert beta_numerator.degree() == beta_denominator.degree() == 12

    substitution = {r: r0, d: d0, v: v0, beta: beta0}
    sections = {}
    lengths = []
    for name, record in source["sections"].items():
        coefficients = {
            symbol: canonical(sp.sympify(expression).subs(substitution, simultaneous=True))
            for symbol, expression in record["coefficients"].items()
        }
        lengths.extend(len(str(value)) for value in coefficients.values())
        y1 = coefficients["A"] * s + coefficients["B"] * t
        y2 = coefficients["C"] * s + coefficients["D"] * t
        cubic = s * (beta0 * s**2 + 2 * a * (3 * y2**2 - y1**2))
        cubic += t * (y1**2 + 3 * y2**2 + 3 * a**2 * s**2 - t**2)
        assert canonical(cubic) == 0
        sections[name] = {
            "plus_subset": record["plus_subset"],
            "coefficients": {symbol: str(value) for symbol, value in coefficients.items()},
        }

    for generator, table in source["generator_actions"].items():
        image = mobius[generator]
        for name, image_name in table.items():
            for symbol in ("A", "B", "C", "D"):
                left = transform(sp.sympify(sections[name]["coefficients"][symbol]), image)
                right = sp.sympify(sections[image_name]["coefficients"][symbol])
                assert canonical(left - right) == 0

    return {
        "schema": "c958-type-i1-rational-splitting-cover-v1",
        "input_sha256": EXPECTED_INPUT_SHA256,
        "rational_parameter": "z=n+m",
        "inverse_parameter": str(canonical(d / (r - 2 * a) + 18 * a**2 * ((d / (r - 2 * a)) ** 2 - 1) / (v * ((d / (r - 2 * a)) ** 2 + 3)))),
        "field_formulas": {
            "m": str(m),
            "n": str(n),
            "r": str(r0),
            "d": str(d0),
            "beta": str(beta0),
            "v": str(v0),
            "u": str(u0),
            "e2": str(e20),
        },
        "mobius_actions": {name: str(value) for name, value in mobius.items()},
        "mobius_group_order": len(group),
        "invariant_map_degree": 12,
        "section_formula_characters": {
            "minimum": min(lengths),
            "maximum": max(lengths),
            "total": sum(lengths),
        },
        "sections": sections,
        "certified": [
            "the degree-twelve splitting field is K(z) with the displayed rational inverse",
            "beta is a degree-twelve invariant of the displayed Mobius group",
            "the Mobius transformations satisfy C2 times S3 and reproduce the radical actions",
            "all sixteen exceptional-line formulas rationalize over Q(a,z)",
            "the rationalized lines satisfy the cubic equation and the full generator action",
        ],
        "not_certified": [
            "the contraction of the five singleton lines",
            "a scalar-normalized Cox embedding or ground-field quotient",
            "forward and inverse maps for the cubic product",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
