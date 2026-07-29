#!/usr/bin/env python3
"""Certify the four-point quotient of the C682 Bockstein pencil."""

from __future__ import annotations

import argparse
import hashlib
import json
import tempfile
from pathlib import Path


PRIME = 11
MODULUS = PRIME**2
NOTES = Path(__file__).resolve().parent
OUTPUT = NOTES / "2026-07-28-c682-zariski-bockstein-orbits.json"
PENCIL = NOTES / "2026-07-28-c682-u22-bockstein-pencil.json"
RESOLVENT = NOTES / "2026-07-28-c682-rank-four-resolvent.json"
BRIDGE = NOTES / "2026-07-28-c682-corrected-bridge-mod-1331.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def input_record(path: Path) -> dict[str, int | str]:
    return {"bytes": path.stat().st_size, "sha256": sha256(path)}


def polynomial_from_roots(roots: list[int]) -> list[int]:
    coefficients = [1]
    for root in roots:
        updated = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            updated[index] += coefficient
            updated[index + 1] -= root * coefficient
        coefficients = updated
    return coefficients


def discriminant(roots: list[int]) -> int:
    answer = 1
    for left in range(len(roots)):
        for right in range(left + 1, len(roots)):
            answer *= (roots[right] - roots[left]) ** 2
    return answer


def valuation(value: int, prime: int) -> tuple[int, int]:
    exponent = 0
    while value % prime == 0:
        exponent += 1
        value //= prime
    return exponent, value % prime


def build_certificate() -> dict:
    pencil = json.loads(PENCIL.read_text(encoding="utf-8"))
    resolvent = json.loads(RESOLVENT.read_text(encoding="utf-8"))
    bridge = json.loads(BRIDGE.read_text(encoding="utf-8"))

    histogram = {
        int(value): count
        for value, count in pencil["global_invariant_pencil"][
            "ratio_histogram_mod_121"
        ].items()
    }
    assert sorted(histogram.values()) == [1, 5, 6, 10]
    ratio_by_size = {count: value for value, count in histogram.items()}
    assert sorted(resolvent["A5_orbits"]["orbit_sizes"]) == [1, 5, 6, 10]
    assert resolvent["A5_orbits"]["stabilizer_orders"] == [60, 12, 10, 6]

    orbit_data = [
        ("radial", "A5", 1, 60, 1),
        ("Clebsch-parent", "A4", 5, 12, -1),
        ("fivefold-axis", "D5", 6, 10, -1),
        ("pair", "S3", 10, 6, 1),
    ]
    rows = []
    for name, stabilizer, size, stabilizer_order, sheet in orbit_data:
        ratio = ratio_by_size[size]
        sheet_modulus = sheet % MODULUS
        difference = (ratio - sheet_modulus) % MODULUS
        assert difference % PRIME == 0
        first_digit = difference // PRIME
        centered_digit = (first_digit - 4) % PRIME
        sheet_mod_prime = sheet % PRIME
        other_root = (3 + 2 * sheet_mod_prime) % PRIME
        assert centered_digit * (centered_digit - other_root) % PRIME == 0
        rows.append(
            {
                "name": name,
                "stabilizer": stabilizer,
                "orbit_size": size,
                "stabilizer_order": stabilizer_order,
                "sheet_sign": sheet,
                "ratio_mod_121": ratio,
                "first_bockstein_digit": first_digit,
                "centered_digit": centered_digit,
                "quotient_point": [sheet_mod_prime, centered_digit],
            }
        )

    row_by_size = {row["orbit_size"]: row for row in rows}
    assert {
        size: row_by_size[size]["ratio_mod_121"]
        for size in (1, 5, 6, 10)
    } == {1: 100, 5: 43, 6: 54, 10: 45}
    assert {
        size: row_by_size[size]["first_bockstein_digit"]
        for size in (1, 5, 6, 10)
    } == {1: 9, 5: 4, 6: 5, 10: 4}
    assert {
        size: row_by_size[size]["centered_digit"]
        for size in (1, 5, 6, 10)
    } == {1: 5, 5: 0, 6: 1, 10: 0}

    positive_speed = (
        row_by_size[1]["ratio_mod_121"]
        - row_by_size[10]["ratio_mod_121"]
    ) // PRIME
    negative_speed = (
        row_by_size[6]["ratio_mod_121"]
        - row_by_size[5]["ratio_mod_121"]
    ) // PRIME
    assert (positive_speed, negative_speed) == (5, 1)

    roots = [
        row_by_size[size]["ratio_mod_121"] for size in (1, 5, 6, 10)
    ]
    coefficients = polynomial_from_roots(roots)
    coefficients_modulus = [coefficient % MODULUS for coefficient in coefficients]
    assert coefficients_modulus == [1, 0, 75, 0, 45]
    assert coefficients_modulus == [1, 0, -46 % MODULUS, 0, 23**2 % MODULUS]
    discriminant_value = discriminant(roots)
    discriminant_valuation, discriminant_unit = valuation(
        discriminant_value, PRIME
    )
    assert (discriminant_valuation, discriminant_unit) == (4, 9)

    all_order = bridge["all_order_hensel_gate"]
    assert all_order["presentation_jacobian_rank_mod_11"] == 5
    assert all_order["presentation_constraint_count"] == 5
    assert all_order["prime_is_coprime_to_group_order"]
    assert pencil["hensel_section"]["all_chart_jacobian_ranks_mod_11"] == 12
    assert pencil["hensel_section"]["point_count"] == 22
    assert pencil["global_invariant_pencil"]["all_22_denominators_are_units"]

    return {
        "schema": "c682-zariski-bockstein-orbits-v1",
        "base": {
            "prime": PRIME,
            "first_order_modulus": MODULUS,
            "marked_presentation_is_smooth_at_special_point": True,
            "binary_group_order": all_order["binary_group_order"],
            "reynolds_denominator_is_a_unit": True,
        },
        "zariski_globalization_gates": {
            "presentation_jacobian_rank": 5,
            "presentation_constraint_count": 5,
            "section_chart_jacobian_rank": 12,
            "section_point_count": 22,
            "pencil_denominator_is_a_unit_at_every_special_point": True,
            "interpretation": (
                "Flatness divides the two covariants by 11 on an actual "
                "marked-presentation open; transversality then gives a "
                "finite-etale degree-22 relative section, and its A5 "
                "quotient is finite etale of degree four."
            ),
        },
        "four_orbit_quotient": {
            "rows": rows,
            "special_sheet_function": (
                "s=e_1+e_10-e_5-e_6"
            ),
            "first_digit_function": (
                "a=(r-s)/11=4+5*e_1+e_6"
            ),
            "centered_digit_function": "b=a-4=5*e_1+e_6",
            "normal_cone_presentation": (
                "F_11[s,b]/(s^2-1, b*(b-(3+2*s)))"
            ),
            "ratio_reconstruction_mod_121": "r=s+11*(4+b)",
            "within_sheet_splitting_speeds": {
                "positive_radial_over_pair": positive_speed,
                "negative_D5_over_A4": negative_speed,
                "ratio": positive_speed * pow(negative_speed, -1, PRIME)
                % PRIME,
            },
        },
        "quotient_polynomial_mod_121": {
            "root_order_by_orbit_size": [1, 5, 6, 10],
            "coefficients": coefficients_modulus,
            "factorization": "(T^2-23)^2 mod 121",
            "discriminant_11_adic_valuation": discriminant_valuation,
            "discriminant_unit_mod_11": discriminant_unit,
            "interpretation": (
                "The quotient has two double special-fibre sheets; their "
                "four branches separate transversely only in the first "
                "Bockstein digit."
            ),
        },
        "normalization_boundary": {
            "intrinsic": [
                "the four stabilizer-labelled quotient branches",
                "the two sheet collisions",
                "the two nonzero within-sheet first-order separations",
            ],
            "depends_on_the_normalized_pencil": [
                "the common first digit 4",
                "the representatives 100,43,54,45",
                "the golden-pair midpoint 11 mod 121",
            ],
            "warning": (
                "Orbit sizes alone force multiplicities, not numerical "
                "pencil values; the latter use the fixed (8*epsilon,7*eta) "
                "normalization."
            ),
        },
        "inputs": {
            str(path.relative_to(NOTES.parent)): input_record(path)
            for path in (PENCIL, RESOLVENT, BRIDGE)
        },
    }


def serialize(certificate: dict) -> bytes:
    return (
        json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    ).encode("utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    payload = serialize(build_certificate())
    if arguments.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUTPUT.name
            candidate.write_bytes(payload)
            assert candidate.read_bytes() == OUTPUT.read_bytes()
        print(f"PASS {OUTPUT.name} {len(payload)} bytes {sha256(OUTPUT)}")
    else:
        OUTPUT.write_bytes(payload)
        print(f"WROTE {OUTPUT.name} {len(payload)} bytes")


if __name__ == "__main__":
    main()
