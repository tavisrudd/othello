#!/usr/bin/env python3
"""Exact regression for the cubic endpoint lemma.

The human proof is in Section 9 of the manuscript.  This script protects its
rational block calculation, hypergeometric recurrence, and projective-space
grading identity against transcription drift.  It does not verify the
asymptotic theorem or any localization statement.
"""

from __future__ import annotations

import argparse
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CERTIFICATE = ROOT / "cubic_endpoint_certificate.json"
SCHEMA = "gamma-point-row-cubic-endpoint-v1"


def evaluate_quadratic(coefficients: list[Fraction], value: Fraction) -> Fraction:
    constant, linear, quadratic = coefficients
    return constant + linear * value + quadratic * value * value


def build_certificate() -> dict[str, object]:
    d11 = Fraction(-19, 18)
    d22 = Fraction(19, 18)
    jordan_link = Fraction(1)
    return_link = Fraction(-16, 81)

    # (rho-d11)(rho+1-d22)-jordan_link*return_link
    indicial = [
        (-d11) * (1 - d22) - jordan_link * return_link,
        (1 - d22) - d11,
        Fraction(1),
    ]
    expected = [Fraction(5, 36), Fraction(1), Fraction(1)]
    assert indicial == expected
    roots = [Fraction(-1, 6), Fraction(-5, 6)]
    assert all(evaluate_quadratic(indicial, root) == 0 for root in roots)

    period_checks: list[dict[str, object]] = []
    previous = Fraction(1)
    for degree in range(1, 13):
        coefficient = Fraction(
            math.factorial(3 * degree),
            math.factorial(degree) ** 5 * 27**degree,
        )
        right = (
            (Fraction(degree) - Fraction(1, 3))
            * (Fraction(degree) - Fraction(2, 3))
            * previous
        )
        assert degree**4 * coefficient == right
        period_checks.append(
            {
                "degree": degree,
                "coefficient_in_x": str(coefficient),
                "recurrence": True,
            }
        )
        previous = coefficient

    projective_checks: list[dict[str, object]] = []
    for dimension in range(0, 65):
        diagonal_sum = sum(
            (Fraction(dimension, 2) - k for k in range(dimension + 1)),
            Fraction(0),
        )
        assert diagonal_sum == 0
        projective_checks.append(
            {
                "dimension": dimension,
                "rank": dimension + 1,
                "grading_diagonal_average": "0",
            }
        )

    gamma_arguments = [Fraction(1, 3), Fraction(2, 3), Fraction(-1, 3)]
    assert all(argument.denominator != 1 or argument > 0 for argument in gamma_arguments)

    return {
        "schema": SCHEMA,
        "cai_rank_two_block": {
            "d11": str(d11),
            "d22": str(d22),
            "jordan_link": str(jordan_link),
            "return_link": str(return_link),
            "indicial_coefficients_constant_first": [str(value) for value in indicial],
            "roots": [str(root) for root in roots],
            "fractional_residues_mod_Z": ["-1/6", "1/6"],
        },
        "hypergeometric": {
            "operator": "D^4-x(D+1/3)(D+2/3)",
            "checked_degree_range": [0, 12],
            "checks": period_checks,
        },
        "barnes_nonpole_arguments": [str(argument) for argument in gamma_arguments],
        "projective_space": {
            "identity": "sum_{k=0}^m (m/2-k)=0",
            "checked_dimension_range": [0, 64],
            "checks": projective_checks,
        },
        "trust_boundary": (
            "Exact arithmetic regression only; the Barnes asymptotic theorem, "
            "quantum Kunneth theorem, and birational localization proof are not "
            "machine-verified."
        ),
    }


def canonical_json(value: object) -> str:
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = canonical_json(build_certificate())
    if args.check:
        if not CERTIFICATE.is_file() or CERTIFICATE.read_text(encoding="utf-8") != rendered:
            raise SystemExit("cubic endpoint certificate is stale; regenerate without --check")
        print("cubic endpoint exact regression: CHECK OK")
        return
    CERTIFICATE.write_text(rendered, encoding="utf-8")
    print(f"wrote {CERTIFICATE.name}")


if __name__ == "__main__":
    main()
