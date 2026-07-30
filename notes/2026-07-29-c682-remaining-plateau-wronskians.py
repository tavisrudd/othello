#!/usr/bin/env python3
"""Signed boundary Wronskians for the four remaining C682 plateau types."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
CORE_PATH = HERE / "2026-07-29-c682-signed-block-wronskian.py"
OPERATORS = HERE / "2026-07-29-c682-remaining-plateau-wronskians-operators.json"
BOUNDARY = HERE / "2026-07-29-c682-remaining-plateau-wronskians-boundary.json"
CERTIFICATE = HERE / "2026-07-29-c682-remaining-plateau-wronskians.json"
FAMILIES = {
    "2_13": {"module": "2", "base_degree": 73},
    "3_14": {"module": "3", "base_degree": 74},
    "3p_14": {"module": "3p", "base_degree": 74},
    "3p_18": {"module": "3p", "base_degree": 78},
}


def load_core():
    spec = importlib.util.spec_from_file_location(
        "remaining_plateau_wronskian_core", CORE_PATH
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


CORE = load_core()


def configure(family):
    row = FAMILIES[family]
    CORE.FAMILIES[row["module"]] = row["base_degree"]
    CORE.exact_spaces.cache_clear()
    CORE.exact_operator.cache_clear()
    return row["module"]


def family_operators(family, operators):
    module = configure(family)
    return module, {module: operators[family]}


def boundary_wronskian(family, q, operators):
    module, selected = family_operators(family, operators)
    return CORE.boundary_wronskian(module, q, selected)


def symbol_valuations(family, operators):
    module, selected = family_operators(family, operators)
    return CORE.boundary_symbol_valuations(module, selected)


def generate_operators():
    out = {}
    for family in FAMILIES:
        module = configure(family)
        out[family] = {
            operator: CORE.universal_operator(module, operator)
            for operator in CORE.OPERATOR_SPECS
        }
    return out


def generate_boundary(operators):
    out = {}
    for family in FAMILIES:
        first = boundary_wronskian(family, 10, operators)
        size = first["tail_dimension"]
        quotient = first["quotient_dimension"]
        degree_bound = 3 * (size - quotient) + 15 * quotient
        values = [
            boundary_wronskian(family, q, operators)["determinant"]
            for q in range(10, 10 + degree_bound + 1)
        ]
        differences = values
        coefficients = []
        while differences:
            coefficients.append(differences[0])
            differences = [
                right - left
                for left, right in zip(differences, differences[1:])
            ]
        while coefficients and not coefficients[-1]:
            coefficients.pop()
        out[family] = {
            **FAMILIES[family],
            "base_q": 10,
            "tail_dimension": size,
            "quotient_dimension": quotient,
            "endpoint_indices_at_q10": first["endpoint_indices"],
            "degree_bound": degree_bound,
            "degree": len(coefficients) - 1,
            "newton_coefficients": [str(value) for value in coefficients],
        }
    return out


def certificate(operators, boundary_data):
    results = {}
    for family, specification in FAMILIES.items():
        row = boundary_data[family]
        base_q = row["base_q"]
        polynomial = CORE.newton_to_monomial(
            [Fraction(value) for value in row["newton_coefficients"]]
        )
        roots = []
        residual = polynomial
        for root in range(-500, 0):
            while (
                len(residual) > 1
                and not CORE.polynomial_value(residual, root)
            ):
                roots.append(root)
                residual = CORE.divide_linear(residual, Fraction(root))
        shift = next(
            candidate
            for candidate in range(501)
            if CORE.uniform_sign(
                CORE.shifted_coefficients(residual, candidate)
            )
        )
        threshold = base_q + shift
        shifted_residual = CORE.shifted_coefficients(residual, shift)
        finite_boundary = [
            boundary_wronskian(family, q, operators)["determinant"]
            for q in range(base_q, threshold)
        ]
        low_boundary = [
            boundary_wronskian(family, q, operators)
            for q in range(1, base_q)
        ]
        valuations = symbol_valuations(family, operators)
        assert all(finite_boundary)
        assert all(entry["determinant"] for entry in low_boundary)
        assert sum(valuations) == row["degree_bound"] - row["degree"]
        results[family] = {
            **specification,
            "family": (
                f"n={specification['base_degree']}+60q"
            ),
            "tail_dimension": row["tail_dimension"],
            "quotient_dimension": row["quotient_dimension"],
            "degree_bound": row["degree_bound"],
            "exact_degree": row["degree"],
            "smith_valuations_at_infinity": valuations,
            "linear_roots_in_x_equals_q_minus_10": roots,
            "residual_degree": len(residual) - 1,
            "positivity_threshold_q": threshold,
            "shifted_residual_coefficient_sign": CORE.uniform_sign(
                shifted_residual
            ),
            "shifted_residual_nonzero_coefficients": sum(
                bool(value) for value in shifted_residual
            ),
            "finite_boundary_signs_q10_to_threshold_minus_1": [
                (value > 0) - (value < 0)
                for value in finite_boundary
            ],
            "low_boundary_quotient_dimensions_q1_to_9": [
                entry["quotient_dimension"] for entry in low_boundary
            ],
            "low_boundary_determinant_signs_q1_to_9": [
                (entry["determinant"] > 0)
                - (entry["determinant"] < 0)
                for entry in low_boundary
            ],
            "conclusion": (
                "the selected endpoint returns surject onto the complete "
                "local boundary quotient for every integer q>=1"
            ),
        }
    return {
        "schema": "c682-remaining-plateau-wronskians-v1",
        "families": results,
        "hilbert_plateau_types_mod_20": {
            "invariant_degree": 20,
            "plateau_entrances": {
                "1": [4],
                "2": [3, 13],
                "3": [12, 14],
                "3p": [10, 14, 18],
            },
            "previously_certified": {
                "1": [4],
                "2": [3],
                "3": [12],
                "3p": [10],
            },
            "newly_certified": {
                "2": [13],
                "3": [14],
                "3p": [14, 18],
            },
            "claim_boundary": (
                "This classifies multiplicity patterns only. The "
                "third-order transvectant is not asserted to be linear "
                "over multiplication by the degree-20 invariant, so the "
                "other modulo-60 phases remain a separate gate."
            ),
        },
        "phase_audit_mod_60": {
            "all_plateau_entrances": {
                "1": [4, 24, 44],
                "2": [3, 13, 23, 33, 43, 53],
                "3": [12, 14, 32, 34, 52, 54],
                "3p": [10, 14, 18, 30, 34, 38, 50, 54, 58],
            },
            "certified_phases": {
                "1": [4],
                "2": [3, 13],
                "3": [12, 14],
                "3p": [10, 14, 18],
            },
            "remaining_phases": {
                "1": [24, 44],
                "2": [23, 33, 43, 53],
                "3": [32, 34, 52, 54],
                "3p": [30, 34, 38, 50, 54, 58],
            },
            "remaining_count": 16,
        },
        "claim": (
            "One representative of each of the four previously missing "
            "modulo-20 plateau-entry types is boundary-controllable for "
            "every integer q>=1."
        ),
        "trusted_boundary": (
            "The exact operator formulas are interpolated only within "
            "formal differential-order bounds 3,3,9. Fixed boundary "
            "determinants are certified by their formal degree bounds, "
            "stored Newton coefficients, exact finite prefixes, and "
            "coefficientwise one-sign residuals."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write-operators", action="store_true")
    mode.add_argument("--write-boundary", action="store_true")
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    if arguments.write_operators:
        rendered = json.dumps(
            generate_operators(), indent=2, sort_keys=True
        ) + "\n"
        OPERATORS.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {OPERATORS}")
        return
    operators = json.loads(OPERATORS.read_text(encoding="utf-8"))
    if arguments.write_boundary:
        rendered = json.dumps(
            generate_boundary(operators), indent=2, sort_keys=True
        ) + "\n"
        BOUNDARY.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {BOUNDARY}")
        return
    if arguments.check:
        expected_operators = json.dumps(
            generate_operators(), indent=2, sort_keys=True
        ) + "\n"
        assert OPERATORS.read_text(encoding="utf-8") == expected_operators
        expected_boundary = json.dumps(
            generate_boundary(operators), indent=2, sort_keys=True
        ) + "\n"
        assert BOUNDARY.read_text(encoding="utf-8") == expected_boundary
    boundary_data = json.loads(BOUNDARY.read_text(encoding="utf-8"))
    rendered = json.dumps(
        certificate(operators, boundary_data), indent=2, sort_keys=True
    ) + "\n"
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")
    else:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 remaining plateau Wronskians")


if __name__ == "__main__":
    main()
