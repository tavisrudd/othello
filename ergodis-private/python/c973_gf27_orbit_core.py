#!/usr/bin/env python3
"""Compress the C973 GF(27) extremal switch witnesses into torus orbits.

The input is the frozen 78-row ``e3-good78.tsv`` certificate.  This adapter
independently rebuilds GF(27), verifies every nine-set against the two Hankel
equations for e_3, and quotients the supports by nonzero scalar multiplication.
The resulting three representatives are a small structural proof target: one
representative for each conjugate plane label, plus torus equivariance.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import math
import os
from pathlib import Path
from typing import Iterable

from semantic_parametric_core import fit_monomial_coordinates


def _digits(a: int) -> tuple[int, int, int]:
    return (a % 3, (a // 3) % 3, (a // 9) % 3)


def _undigits(d: Iterable[int]) -> int:
    x = tuple(d)
    return x[0] % 3 + 3 * (x[1] % 3) + 9 * (x[2] % 3)


def add(a: int, b: int) -> int:
    x, y = _digits(a), _digits(b)
    return _undigits((x[0] + y[0], x[1] + y[1], x[2] + y[2]))


def neg(a: int) -> int:
    x = _digits(a)
    return _undigits((-x[0], -x[1], -x[2]))


def mul(a: int, b: int) -> int:
    x, y = _digits(a), _digits(b)
    c = [0] * 5
    for i in range(3):
        for j in range(3):
            c[i + j] = (c[i + j] + x[i] * y[j]) % 3
    return _undigits((c[0] + c[3], c[1] + c[3] + c[4], c[2] + c[4]))


def polynomial_from_roots(roots: Iterable[int]) -> list[int]:
    polynomial = [1]
    for root in roots:
        nxt = [0] * (len(polynomial) + 1)
        for index, coefficient in enumerate(polynomial):
            nxt[index + 1] = add(nxt[index + 1], coefficient)
            nxt[index] = add(nxt[index], neg(mul(coefficient, root)))
        polynomial = nxt
    return polynomial


def scale_support(support: tuple[int, ...], scalar: int) -> tuple[int, ...]:
    return tuple(sorted(mul(scalar, point) for point in support))


def canonical_support(support: tuple[int, ...]) -> tuple[int, ...]:
    return min(scale_support(support, scalar) for scalar in range(1, 27))


def frobenius_support(support: tuple[int, ...], power: int) -> tuple[int, ...]:
    result = support
    for _ in range(power % 3):
        result = tuple(sorted(mul(mul(point, point), point) for point in result))
    return result


def semilinear_orbit(support: tuple[int, ...]) -> set[tuple[int, ...]]:
    return {
        scale_support(frobenius_support(support, power), scalar)
        for power in range(3)
        for scalar in range(1, 27)
    }


def extract(source: Path, extremes: Path | None = None) -> dict[str, object]:
    source_bytes = source.read_bytes()
    rows: list[tuple[str, tuple[int, ...]]] = []
    row_details: dict[tuple[int, ...], dict[str, str]] = {}
    with source.open(newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle, delimiter="\t"):
            support = tuple(sorted(int(value) for value in row["nine_set"].split(",")))
            if len(support) != 9 or len(set(support)) != 9:
                raise ValueError("certificate row is not a nine-point set")
            polynomial = polynomial_from_roots(support)
            if polynomial[2] != 0 or polynomial[3] != 0:
                raise ValueError("certificate row does not close e_3")
            rows.append((row["lambda_label"], support))
            row_details[support] = row

    support_set = {support for _, support in rows}
    if len(support_set) != len(rows):
        raise ValueError("certificate contains duplicate supports")

    groups: dict[tuple[int, ...], list[tuple[str, tuple[int, ...]]]] = {}
    for label, support in rows:
        groups.setdefault(canonical_support(support), []).append((label, support))

    orbits: list[dict[str, object]] = []
    for representative, members in sorted(groups.items()):
        expected = {scale_support(representative, scalar) for scalar in range(1, 27)}
        observed = {support for _, support in members}
        labels = sorted({label for label, _ in members})
        if observed != expected:
            raise ValueError("input does not contain a complete torus orbit")
        if len(labels) != 1:
            raise ValueError("lambda label is not constant on a torus orbit")
        orbits.append(
            {
                "lambda_label": labels[0],
                "representative": list(representative),
                "orbit_size": len(expected),
                "input_members": len(members),
            }
        )

    semilinear_groups: list[dict[str, object]] = []
    unseen = set(support_set)
    while unseen:
        representative = min(unseen)
        orbit = semilinear_orbit(representative)
        if not orbit <= support_set:
            raise ValueError("input does not contain a complete semilinear orbit")
        unseen -= orbit
        semilinear_groups.append(
            {
                "representative": list(representative),
                "orbit_size": len(orbit),
                "frobenius_cycle": [
                    list(canonical_support(frobenius_support(representative, power)))
                    for power in range(3)
                ],
            }
        )

    seed = tuple(semilinear_groups[0]["representative"])
    seed_row = row_details[seed]
    plane = tuple(sorted(int(value) for value in seed_row["plane_points"].split(",")))
    removed = sorted(set(plane) - set(seed))
    added = sorted(set(seed) - set(plane))
    if len(removed) != 2 or len(added) != 2:
        raise ValueError("semilinear seed is not a two-point plane switch")
    if added != sorted((int(seed_row["y1"]), int(seed_row["y2"]))):
        raise ValueError("switch metadata does not match seed support")
    plane_locator = polynomial_from_roots(plane)
    seed_locator = polynomial_from_roots(seed)

    result: dict[str, object] = {
        "schema": "ergodis.semantic-orbit-core.v1",
        "problem": "C973 GF(27) extremal e3 switch witnesses",
        "source": os.fspath(source),
        "source_sha256": hashlib.sha256(source_bytes).hexdigest(),
        "field": "GF(3)[x]/(x^3-x-1)",
        "observable": "monic split degree-nine locator has g_2=g_3=0",
        "input_witnesses": len(rows),
        "torus_orbits": len(orbits),
        "compression_ratio": len(rows) / len(orbits),
        "orbits": orbits,
        "semilinear_orbits": len(semilinear_groups),
        "semilinear_compression_ratio": len(rows) / len(semilinear_groups),
        "semilinear_orbit_cores": semilinear_groups,
        "semilinear_seed_switch": {
            "plane": list(plane),
            "plane_basis_over_F3": [1, 12],
            "plane_locator_coefficients_low_to_high": plane_locator,
            "removed": removed,
            "added": added,
            "support": list(seed),
            "support_locator_coefficients_low_to_high": seed_locator,
            "closing_coefficients": {"g_2": seed_locator[2], "g_3": seed_locator[3]},
        },
        "proof_target": (
            "verify the recorded additive-plane two-point switch identity and prove that "
            "nonzero scalar multiplication and field Frobenius preserve admissibility and closure"
        ),
    }
    if extremes is not None:
        extreme_bytes = extremes.read_bytes()
        minimum_rows: list[tuple[int, ...]] = []
        with extremes.open(newline="", encoding="utf-8") as handle:
            for row in csv.DictReader(handle, delimiter="\t"):
                if int(row["n_good"]) == 78:
                    minimum_rows.append(
                        tuple(int(value) for value in row["z2,z3,z4,z5,z6,z7,z8"].split(","))
                    )
        if len(minimum_rows) != 27:
            raise ValueError("expected exactly 27 extremal syndrome rows")
        fits = fit_monomial_coordinates(
            minimum_rows,
            parameter_index=2,
            coordinate_indices=range(2, 7),
            field_elements=range(27),
            multiply=mul,
            one=1,
            maximum_exponent=8,
        )
        generated = {
            (
                0,
                1,
                *(mul(coefficient, _field_power(t, exponent)) for coefficient, exponent in fits.values()),
            )
            for t in range(27)
        }
        if generated != set(minimum_rows):
            raise ValueError("fitted curve does not equal the extremal syndrome set")
        divided_power_coefficients = [math.comb(index, 3) % 3 for index in range(3, 9)]
        fitted_coefficients = [1] + [coefficient for coefficient, _ in fits.values()]
        if fitted_coefficients != divided_power_coefficients:
            raise ValueError("extremal curve is not the divided-power translation orbit of e_3")
        result["extremes_source"] = os.fspath(extremes)
        result["extremes_source_sha256"] = hashlib.sha256(extreme_bytes).hexdigest()
        result["extremal_curve_core"] = {
            "rows": 27,
            "parameter": "t=z4",
            "formula": "(z2,...,z8)=(0,1,t,t^2,-t^3,-t^4,-t^5)",
            "coordinate_monomials": [
                {"coordinate": f"z{index + 2}", "coefficient": coefficient, "exponent": exponent}
                for index, (coefficient, exponent) in fits.items()
            ],
            "exact_set_equality": True,
            "structural_identity": "z_i=binom(i,3)t^(i-3), 3<=i<=8, in characteristic 3",
            "divided_power_coefficients_mod_3": divided_power_coefficients,
        }
    return result


def _field_power(value: int, exponent: int) -> int:
    result = 1
    for _ in range(exponent):
        result = mul(result, value)
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("--extremes", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = extract(args.source, args.extremes)
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output is None:
        print(rendered, end="")
        return
    with args.output.open("x", encoding="utf-8") as handle:
        handle.write(rendered)


if __name__ == "__main__":
    main()
