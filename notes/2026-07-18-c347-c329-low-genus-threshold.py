#!/usr/bin/env python3
"""Generate/check the C347 ordered-root quotient arithmetic certificate."""

from __future__ import annotations

import argparse
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
DEFAULT_OUTPUT = HERE / "2026-07-18-c347-c329-low-genus-threshold.json"


def falling(n: int, k: int) -> int:
    value = 1
    for j in range(k):
        value *= n - j
    return value


def quotient_rows(legality_degree: int) -> tuple[list[dict[str, int]], Fraction]:
    rows: list[dict[str, int]] = []
    weighted_genus = Fraction(0)
    for a in range(6):
        for b in range(6):
            if a + b == 0 or a + b > 5:
                continue
            degree = falling(5, a) * falling(5, b)
            fixed_first = (falling(3, a) if a <= 3 else 0) * falling(5, b)
            fixed_second = falling(5, a) * (falling(3, b) if b <= 3 else 0)
            finite_different = 2 * legality_degree * (
                degree - fixed_first + degree - fixed_second
            )
            # Infinity contributes less than 4*degree/3.  Riemann--Hurwitz and
            # integrality therefore give this conservative genus upper bound.
            genus_upper = math.floor(
                Fraction(1) + Fraction(finite_different, 2) - Fraction(degree, 3)
            )
            denominator = math.factorial(a) * math.factorial(b)
            weighted_genus += Fraction(genus_upper, denominator)
            rows.append(
                {
                    "a": a,
                    "b": b,
                    "degree": degree,
                    "finite_different": finite_different,
                    "fixed_by_first_transposition": fixed_first,
                    "fixed_by_second_transposition": fixed_second,
                    "genus_upper": genus_upper,
                    "moment_denominator": denominator,
                }
            )
    return rows, weighted_genus


def signed_margin(exponent: int, sqrt_coefficient: int, constant: int) -> int:
    q = 1 << exponent
    rational_part = q + 1 - constant
    if rational_part <= 0:
        return -1
    # For odd exponent, positivity of rational_part-A*sqrt(q) is equivalent
    # to positivity of this exact integer after squaring.
    return rational_part * rational_part - sqrt_coefficient * sqrt_coefficient * q


def permutation_replay() -> dict[str, object]:
    permutations = list(itertools.permutations(range(5)))
    fixed_counts = [sum(i == image for i, image in enumerate(p)) for p in permutations]
    bonferroni_total = 0
    exact_total = 0
    for r1 in fixed_counts:
        for r2 in fixed_counts:
            roots = r1 + r2
            bonferroni_total += sum(
                (-1) ** k * math.comb(roots, k) for k in range(6)
            )
            exact_total += int(roots == 0)
    population = len(permutations) ** 2
    bonferroni = Fraction(bonferroni_total, population)
    exact = Fraction(exact_total, population)
    assert bonferroni == Fraction(1, 15)
    assert exact == Fraction(121, 900)
    return {
        "group_population": population,
        "bonferroni_density": f"{bonferroni.numerator}/{bonferroni.denominator}",
        "exact_derangement_density": f"{exact.numerator}/{exact.denominator}",
    }


def build_case(legality_degree: int, old_exponent: int, new_exponent: int) -> dict[str, object]:
    rows, weighted_genus = quotient_rows(legality_degree)
    normalized_sqrt = 30 * weighted_genus
    assert normalized_sqrt.denominator == 1
    sqrt_coefficient = normalized_sqrt.numerator
    deleted_base_points = 4 * legality_degree + 1
    positive_even_degree_sum = math.comb(10, 2) + math.comb(10, 4)
    boundary_on_legality_curve = deleted_base_points * (1 + positive_even_degree_sum)
    assert boundary_on_legality_curve % legality_degree == 0
    projected_boundary = boundary_on_legality_curve // legality_degree + 2
    bound_denominator = 15 * legality_degree
    normalized_constant = bound_denominator * projected_boundary
    previous_exponent = new_exponent - 2
    previous_margin = signed_margin(previous_exponent, sqrt_coefficient, normalized_constant)
    new_margin = signed_margin(new_exponent, sqrt_coefficient, normalized_constant)
    assert previous_margin < 0 < new_margin
    return {
        "legality_degree": legality_degree,
        "old_odd_tower_exponent": old_exponent,
        "new_odd_tower_exponent": new_exponent,
        "previous_odd_exponent_checked": previous_exponent,
        "max_quotient_degree": max(row["degree"] for row in rows),
        "finite_branch_points": 4 * legality_degree,
        "deleted_base_points": deleted_base_points,
        "positive_even_degree_sum": positive_even_degree_sum,
        "weighted_genus_upper": (
            f"{weighted_genus.numerator}/{weighted_genus.denominator}"
        ),
        "normalized_sqrt_coefficient": sqrt_coefficient,
        "projected_boundary_constant": projected_boundary,
        "normalized_constant": normalized_constant,
        "lower_bound": (
            f"(Q+1-{sqrt_coefficient}*sqrt(Q))/{bound_denominator}"
            f"-{projected_boundary}"
        ),
        "previous_margin_after_squaring": previous_margin,
        "new_margin_after_squaring": new_margin,
        "quotient_rows": rows,
    }


def payload() -> dict[str, object]:
    return {
        "schema": "c347-ordered-root-bonferroni-v1",
        "bonferroni_order": 5,
        "permutation_replay": permutation_replay(),
        "cases": [
            build_case(16, 41, 39),
            build_case(64, 45, 43),
        ],
    }


def encoded_payload() -> bytes:
    return (json.dumps(payload(), indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = encoded_payload()
    if args.check:
        actual = args.output.read_bytes()
        if actual != expected:
            raise SystemExit(f"certificate mismatch: {args.output}")
        print(f"ok: {args.output} ({len(actual)} bytes)")
    else:
        args.output.write_bytes(expected)
        print(f"wrote: {args.output} ({len(expected)} bytes)")


if __name__ == "__main__":
    main()
