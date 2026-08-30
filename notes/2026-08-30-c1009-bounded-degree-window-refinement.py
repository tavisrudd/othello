#!/usr/bin/env python3
"""Exact arithmetic checks for C1009's bounded-degree window refinement."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path


def beta(k: int) -> int:
    r = k // 2
    return math.comb(k, 2) - k + 6 * math.comb(k, 4) // r


def exact_upper_root(k: int, degree: int) -> int | None:
    a = math.comb(k, 2) + degree - 1
    discriminant = a * a - 4 * beta(k)
    if discriminant < 0:
        return None
    candidate = (a + math.isqrt(discriminant)) // 2
    while (candidate + 1) ** 2 - a * (candidate + 1) + beta(k) <= 0:
        candidate += 1
    while candidate * candidate - a * candidate + beta(k) > 0:
        candidate -= 1
    return candidate


def compute() -> dict[str, object]:
    checked = 0
    low_degree_rows = 0
    examples = {}
    for k in range(6, 101):
        r = k // 2
        n = math.comb(k, 2)
        b = beta(k)
        target_t = k - 2 if k % 2 == 0 else k - 1
        for degree in range(1, 101):
            a = n + degree - 1
            root = exact_upper_root(k, degree)
            if root is not None:
                assert root * root - a * root + b <= 0
                assert (root + 1) ** 2 - a * (root + 1) + b > 0

            # On the upper branch, excluding t=1,...,target_t-1 is
            # equivalent to testing the final value because t(a-t) is
            # increasing throughout this range.
            last_small_t = target_t - 1
            excludes_all_smaller_t = (
                last_small_t * (a - last_small_t) < b
            )
            predicted_range = degree <= r - 2
            assert excludes_all_smaller_t == predicted_range
            if predicted_range:
                low_degree_rows += 1
                if root is not None:
                    bound = (
                        n + degree - k + 1
                        if k % 2 == 0
                        else n + degree - k
                    )
                    assert root <= bound
            checked += 1

    for k, degree in ((6, 1), (6, 3), (8, 2), (10, 3), (11, 3)):
        n = math.comb(k, 2)
        a = n + degree - 1
        examples[f"k{k}_d{degree}"] = {
            "a": a,
            "beta": beta(k),
            "discriminant": a * a - 4 * beta(k),
            "exact_upper_root": exact_upper_root(k, degree),
            "old_coarse_upper_bound": n + degree - 2,
        }

    return {
        "schema": "c1009-bounded-degree-window-v1",
        "theorem": {
            "exact_root": (
                "q <= floor((a+sqrt(a^2-4*beta_k))/2), "
                "a=binom(k,2)+d-1"
            ),
            "even_low_degree": (
                "k=2r, 1<=d<=r-2 implies "
                "q<=binom(k,2)+d-k+1"
            ),
            "odd_low_degree": (
                "k=2r+1, 1<=d<=r-2 implies "
                "q<=binom(k,2)+d-k"
            ),
        },
        "bounded_check": {
            "k_range": [6, 100],
            "degree_range": [1, 100],
            "rows": checked,
            "rows_in_low_degree_range": low_degree_rows,
            "all_exact_root_and_range_checks_pass": True,
        },
        "examples": examples,
        "controller_discovery_replay": {
            "rows": 9500,
            "weighted_correct": 9500,
            "false_positive": 0,
            "false_negative": 0,
            "plan": "d <= r-2",
            "outcome_hash": (
                "8c4c1a9502882f220766a1f6a8f9c37d433e60341bd0038d677a591d5e3cdd42"
            ),
            "note": (
                "This bounded control-plane replay motivated the formula; "
                "the theorem is proved symbolically in the report."
            ),
        },
    }


def render(result: dict[str, object]) -> str:
    return json.dumps(result, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    output = render(compute())
    if arguments.write:
        arguments.write.write_text(output, encoding="utf-8")
    elif arguments.check:
        assert arguments.check.read_text(encoding="utf-8") == output
        print("C1009 bounded-degree window certificate: PASS")
    else:
        print(output, end="")


if __name__ == "__main__":
    main()
