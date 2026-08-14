#!/usr/bin/env python3
"""Exact dependency-free algebra regressions for the complete-neutral kernel."""

from __future__ import annotations

import json
from fractions import Fraction


def index_factor(n: int, x: Fraction) -> Fraction:
    """Exact finite-product continuation of Gamma(x)/Gamma(x+n+1)."""
    if n >= 0:
        value = Fraction(1)
        for m in range(0, n + 1):
            value /= x + m
        return value
    if n == -1:
        return Fraction(1)
    value = Fraction(1)
    for m in range(n + 1, 0):
        value *= x + m
    return value


def check_index_tower(bound: int = 8) -> list[dict[str, object]]:
    checks: list[dict[str, object]] = []
    x = Fraction(17, 3)
    for n in range(-bound, bound + 1):
        finite = index_factor(n, x)
        assert index_factor(n + 1, x) * (x + n + 1) == finite
        checks.append({"n": n, "value_at_x_17_over_3": str(finite)})
    return checks


def check_adjacent_ratio() -> dict[str, object]:
    h, k, a = 3, 5, Fraction(2, 7)
    x = h * k + a
    assert index_factor(0, x) == 1 / x
    return {
        "identity": "Gamma(h*k+a)/Gamma(h*k+a+1)=1/(h*k+a)",
        "signed_slope": 0,
    }


def main() -> None:
    charges = [3, 1, 1, -1, -1, -1, -2]
    assert sum(charges) == 0
    payload = {
        "index_tower": check_index_tower(),
        "adjacent_ratio": check_adjacent_ratio(),
        "balanced_regression_charges": charges,
        "balanced_regression_sum": sum(charges),
    }
    print(json.dumps(payload, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
