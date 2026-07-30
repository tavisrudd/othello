#!/usr/bin/env python3
"""Explain the C682 virtual transfer levels from E8 indicial residues."""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-30-c682-virtual-levels.json"
NONTRIVIAL = (
    HERE / "2026-07-29-c682-nontrivial-plateau-controllability.json"
)
EXCEPTIONAL = HERE / "2026-07-30-c682-exceptional-monotone-schur.json"

NONTRIVIAL_FAMILIES = {
    "2": {"source_degree": 57, "generator_degrees": [1, 29]},
    "3": {"source_degree": 66, "generator_degrees": [2, 10, 18]},
    "3p": {"source_degree": 64, "generator_degrees": [16, 20, 24]},
}
EXCEPTIONAL_FAMILIES = {
    "4_6": {
        "label": "4",
        "entrance_offset": 6,
        "generator_degrees": [8, 12, 16, 24],
    },
    "4s_3": {
        "label": "4s",
        "entrance_offset": 3,
        "generator_degrees": [9, 13, 17, 21],
    },
    "5_4": {
        "label": "5",
        "entrance_offset": 4,
        "generator_degrees": [10, 14, 18, 22, 26],
    },
    "6_5": {
        "label": "6",
        "entrance_offset": 5,
        "generator_degrees": [7, 11, 15, 15, 19, 23],
    },
}


def h_residue(source_degree: int, generator_degree: int) -> int:
    difference = source_degree - generator_degree
    assert difference % 4 == 0
    # 12a+20b=N-d gives 3a+5b=(N-d)/4, hence b=2(N-d)/4 mod 3.
    return (2 * (difference // 4)) % 3


def residue_counts(source_degree: int, generator_degrees: list[int]):
    residues = [
        h_residue(source_degree, degree) for degree in generator_degrees
    ]
    return residues, [residues.count(residue) for residue in range(3)]


def predicted_exponents(counts: list[int]) -> list[int]:
    c0, c1, c2 = counts
    return [c2, c2 + c1, c0 + c1 + c2, c0 + c1, c0]


def multiply(left: list[Fraction], right: list[Fraction]):
    out = [Fraction(0)] * (len(left) + len(right) - 1)
    for left_degree, left_value in enumerate(left):
        for right_degree, right_value in enumerate(right):
            out[left_degree + right_degree] += left_value * right_value
    return out


def indicial_polynomial(counts: list[int]):
    polynomial = [Fraction(1)]
    for residue, multiplicity in enumerate(counts):
        factor = [Fraction(1)]
        for offset in range(3):
            factor = multiply(
                factor,
                [Fraction(residue - offset), Fraction(3)],
            )
        for _ in range(multiplicity):
            polynomial = multiply(polynomial, factor)
    first_degree = next(
        degree for degree, coefficient in enumerate(polynomial) if coefficient
    )
    first = polynomial[first_degree]
    normalized = [
        coefficient / first for coefficient in polynomial[first_degree:]
    ]
    return first_degree, normalized


def root_exponents(row) -> list[int]:
    lookup = {
        Fraction(item["root"]): item["multiplicity"]
        for item in row["roots"]
    }
    return [
        lookup.get(Fraction(numerator, 3), 0)
        for numerator in (-2, -1, 0, 1, 2)
    ]


def certificate():
    nontrivial_input = json.loads(NONTRIVIAL.read_text(encoding="utf-8"))
    exceptional_input = json.loads(EXCEPTIONAL.read_text(encoding="utf-8"))

    nontrivial = {}
    for label, data in NONTRIVIAL_FAMILIES.items():
        residues, counts = residue_counts(
            data["source_degree"], data["generator_degrees"]
        )
        exponents = predicted_exponents(counts)
        first_degree, normalized = indicial_polynomial(counts)
        stored = nontrivial_input["backward_block_determinants"][label]
        assert first_degree == stored["first_degree"]
        assert [str(value) for value in normalized] == stored[
            "normalized_coefficients_ascending"
        ]
        assert sum(exponents) == 3 * len(data["generator_degrees"])
        nontrivial[label] = {
            "source_degree_mod_60": data["source_degree"],
            "generator_degrees": data["generator_degrees"],
            "h_residues": residues,
            "residue_counts_c0_c1_c2": counts,
            "predicted_root_multiplicities_at_m_over_3": exponents,
            "stored_determinant_polynomial_matches": True,
        }

    exceptional = {}
    for type_name, data in EXCEPTIONAL_FAMILIES.items():
        phases = {}
        for phase in range(3):
            r = 15 + phase
            source_degree = data["entrance_offset"] + 20 * r - 6
            residues, counts = residue_counts(
                source_degree, data["generator_degrees"]
            )
            exponents = predicted_exponents(counts)
            stored = exceptional_input["types"][type_name][
                "backward_block"
            ]["phases_by_r_mod_3"][str(phase)]
            assert exponents == root_exponents(stored)
            assert sum(exponents) == 3 * len(data["generator_degrees"])
            phases[str(phase)] = {
                "source_degree": source_degree,
                "h_residues": residues,
                "residue_counts_c0_c1_c2": counts,
                "predicted_root_multiplicities_at_m_over_3": exponents,
                "stored_factorization_matches": True,
            }
        exceptional[type_name] = {
            "module": data["label"],
            "generator_degrees": data["generator_degrees"],
            "phases": phases,
        }

    assert nontrivial["3"]["residue_counts_c0_c1_c2"] == [1, 1, 1]
    assert nontrivial["3p"]["residue_counts_c0_c1_c2"] == [1, 1, 1]
    assert all(
        row["residue_counts_c0_c1_c2"] == [2, 2, 2]
        for row in exceptional["6_5"]["phases"].values()
    )

    return {
        "schema": "c682-e8-indicial-virtual-levels-v1",
        "e8_degree_60_relation": ["t^2", "h^3", "F^5"],
        "global_level": "h_exponent = 3*j + s, s in {0,1,2}",
        "third_order_indicial_factor": "(3*j+s)_3",
        "root_numerators_over_3": [-2, -1, 0, 1, 2],
        "multiplicity_formula": {
            "-2": "c2",
            "-1": "c2+c1",
            "0": "c0+c1+c2",
            "1": "c0+c1",
            "2": "c0",
        },
        "nontrivial_families": nontrivial,
        "exceptional_families": exceptional,
        "conclusions": {
            "virtual_levels": (
                "They are the order-three indicial roots at h=0, rescaled "
                "by the h^3/F^5 E8 level."
            ),
            "3_and_3p_coincidence": (
                "Both source blocks contain one chain in each h residue."
            ),
            "6_phase_independence": (
                "Every phase contains two chains in each h residue."
            ),
            "other_phase_dependence": (
                "Changing r mod 3 cyclically permutes an unbalanced "
                "h-residue multiset."
            ),
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 E8 indicial virtual levels")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
