#!/usr/bin/env python3
"""Exact bounded audit of the published V_10 period formula.

This is deliberately a reconnaissance checker, not a creative-telescoping
certificate.  It checks the displayed candidate scalar operator on a finite
prefix and records the formal calculation that would apply *if* that operator
were proved to be the full small-even quantum differential equation.
"""

from fractions import Fraction
from math import factorial
import argparse
import hashlib
import json
from pathlib import Path


OPERATOR = {
    "theta_0": "theta^4",
    "theta_1": "-10*theta*(theta+1)*(2*theta+1)",
    "theta_2": "-16*(37*theta^2+74*theta+39)",
    "theta_3": "-2040*(2*theta+3)",
    "theta_4": "-8784",
}


def coefficients(bound: int):
    """The CCGK V_10 double sum, then the e^(-6t) mirror-map factor."""
    harmonic = [Fraction(0)] * (bound + 1)
    for m in range(1, bound + 1):
        harmonic[m] = harmonic[m - 1] + Fraction(1, m)

    raw = [Fraction(0)] * (bound + 1)
    for ell in range(bound + 1):
        for m in range(bound + 1 - ell):
            n = ell + m
            raw[n] += (-1) ** n * Fraction(
                factorial(n) ** 2 * factorial(2 * n),
                factorial(ell) ** 5 * factorial(m) ** 5,
            ) * (1 - 5 * (m - ell) * harmonic[m])

    return [
        sum(Fraction((-6) ** k, factorial(k)) * raw[n - k]
            for k in range(n + 1))
        for n in range(bound + 1)
    ]


def recurrence(g, n):
    return (
        n ** 4 * g[n]
        - 10 * (n - 1) * n * (2 * n - 1) * g[n - 1]
        - 16 * (37 * n ** 2 - 74 * n + 39) * g[n - 2]
        - 2040 * (2 * n - 3) * g[n - 3]
        - 8784 * g[n - 4]
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--bound", type=int, default=48)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.bound < 10:
        raise SystemExit("--bound must be at least 10")

    g = coefficients(args.bound)
    regularized = [g[n] * factorial(n) for n in range(args.bound + 1)]
    expected_prefix = [1, 0, 78, 1320, 37746, 1051920, 31464780,
                       971757360, 30859805970, 1000739433120]
    if regularized[:10] != expected_prefix:
        raise AssertionError("published regularized-period prefix disagrees")

    failures = [n for n in range(4, args.bound + 1) if recurrence(g, n) != 0]
    if failures:
        raise AssertionError(f"candidate recurrence fails at {failures[0]}")

    body = {
        "schema": "c907-v10-period-reconnaissance-v1",
        "scope": "finite exact check only; not a telescoping proof or full-QDM scalarization",
        "input": "CCGK Section 12 V_10 period double sum with e^(-6t) factor",
        "bound": args.bound,
        "operator": OPERATOR,
        "coefficient_recurrence": (
            "n^4 g_n - 10(n-1)n(2n-1)g_(n-1) "
            "-16(37n^2-74n+39)g_(n-2) "
            "-2040(2n-3)g_(n-3)-8784g_(n-4)=0"
        ),
        "regularized_prefix_0_through_9": [str(x) for x in regularized[:10]],
        "checked_indices": [4, args.bound],
        "formal_infinity": {
            "leading_polynomial": "lambda^4-20lambda^3-592lambda^2-4080lambda-8784",
            "factorization": "(lambda+6)^2*(lambda^2-32lambda-244)",
            "simple_exponentials": ["16+10*sqrt(5)", "16-10*sqrt(5)"],
            "simple_power_exponents": ["-3/2", "-3/2"],
            "double_exponential": "-6",
            "double_indicial_factor": "-4*(2*alpha+1)*(2*alpha+3)",
            "double_power_exponents": ["-1/2", "-3/2"],
            "warning": "the double block is resonant; this does not certify splitting or absence of logarithms",
        },
        "missing_for_theorem": [
            "an all-n creative-telescoping/WZ certificate for the recurrence, or a source proving this exact operator",
            "a direct theorem that this order-four scalar equation is cyclically equivalent to the full ordinary small-even QDM of V_10",
            "normalization and threefold framing comparison between the period variable and the numerical small-QDM convention",
        ],
    }
    rendered = json.dumps(body, indent=2, sort_keys=True) + "\n"
    body["sha256_without_self_hash"] = hashlib.sha256(rendered.encode()).hexdigest()
    args.output.write_text(json.dumps(body, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
