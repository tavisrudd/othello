#!/usr/bin/env python3
"""Prime-field audit of the universal quartic Gram-shadow counts."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


OUTPUT = Path(__file__).with_suffix(".json")


def character(value, prime):
    value %= prime
    if value == 0:
        return 0
    return 1 if pow(value, (prime - 1) // 2, prime) == 1 else -1


def is_prime(value):
    return value >= 2 and all(value % divisor for divisor in range(2, int(value**0.5) + 1))


def row(prime):
    counts = {sign: 0 for sign in (-1, 0, 1)}
    for ratio in range(prime):
        if ratio not in (0, 1):
            counts[character(ratio * ratio - ratio + 1, prime)] += 1
    if prime == 3:
        predicted = {-1: 0, 0: 1, 1: prime - 3}
    else:
        epsilon = character(-3, prime)
        predicted = {
            -1: (prime - epsilon) // 2,
            0: 1 + epsilon,
            1: (prime - 6 - epsilon) // 2,
        }
    assert counts == predicted
    order = prime * (prime * prime - 1)
    block_counts = {str(sign): order * count // 24 for sign, count in counts.items()}
    assert sum(block_counts.values()) == (prime + 1) * prime * (prime - 1) * (prime - 2) // 24
    return {
        "q": prime,
        "chi_minus_three": character(-3, prime),
        "normalized_cross_ratio_counts": {str(sign): count for sign, count in counts.items()},
        "unordered_four_set_counts": block_counts,
    }


def compute():
    rows = [row(prime) for prime in range(3, 102) if is_prime(prime) and prime % 2]
    q11 = next(item for item in rows if item["q"] == 11)
    assert q11["unordered_four_set_counts"] == {"-1": 330, "0": 0, "1": 165}
    return {
        "schema": "c1012-quartic-shadow-counts-v1",
        "range": "odd primes 3 through 101",
        "formula_characteristic_not_three": {
            "negative_cross_ratios": "(q-chi(-3))/2",
            "zero_cross_ratios": "1+chi(-3)",
            "positive_cross_ratios": "(q-6-chi(-3))/2",
            "unordered_four_sets": "|PGL(2,q)| times cross-ratio count / 24",
        },
        "rows": rows,
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(compute(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
    else:
        assert OUTPUT.read_text() == rendered
        print("C1012 quartic shadow counts: PASS")


if __name__ == "__main__":
    main()
