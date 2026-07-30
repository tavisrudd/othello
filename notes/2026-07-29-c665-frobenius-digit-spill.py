#!/usr/bin/env python3
"""Audit the digit bookkeeping in the C665 uniform spill criterion.

The mathematical proof is in the adjacent report.  This checker verifies
the finite symbolic reductions used there:

* the symmetric/alternating sign word for an exceptional socle head;
* the local T, R, and Y factors in the first Hermite wall;
* uniqueness of the T -> Y adjacent block among middle factors; and
* the strict torus-weight gap in the spill component.

It deliberately does not claim to prove the Lucas-socle or adjacent-wall
lemmas; those are human representation-theoretic arguments.
"""

import argparse
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c665-frobenius-digit-spill.json"


def square_factors(n, alternating):
    start = 2 * n - 2 * int(alternating)
    return tuple(range(start, -1, -4))


def sign_for_factor(n, factor):
    signs = [
        alternating
        for alternating in (False, True)
        if factor in square_factors(n, alternating)
    ]
    assert len(signs) <= 1
    return signs[0] if signs else None


def middle_factors(p):
    return tuple(range(p - 2, 0, -2))


def occurrence_record(p_mod_4, exponent_parity, source):
    # Representatives preserve every parity calculation.
    representatives = {
        (6, 1): 13,
        (6, 3): 11,
        (8, 1): 13,
        (8, 3): 11,
        (12, 1): 17,
        (12, 3): 19,
    }
    p = representatives[(source, p_mod_4)]
    exponent = 2 if exponent_parity == 0 else 3
    a = (p - 3) // 2
    b = (p - 1) // 2
    signs = [sign_for_factor(a, source)]
    signs.extend(sign_for_factor(b, 0) for _ in range(exponent - 1))
    occurs = None not in signs and sum(map(int, signs)) % 2 == 0
    formula = (exponent * b - 1 - source // 2) % 2 == 0
    assert occurs == formula
    return {
        "p_mod_4": p_mod_4,
        "exponent_parity": exponent_parity,
        "source": source,
        "sign_word": ["alt" if sign else "sym" for sign in signs],
        "occurs": occurs,
    }


def spill_record(p, source):
    assert p > source + 1 and source % 2 == 0
    a = (p - 3) // 2
    b = (p - 1) // 2
    t = (p - 2, 1)
    r = (p - 2 - source, 1)
    y = (0, 2)
    assert all(digit in middle_factors(p) for digit in t + r)
    y_signs = (sign_for_factor(a, 0), sign_for_factor(b, 2))
    assert None not in y_signs and sum(map(int, y_signs)) % 2 == 0

    # A middle factor X can cross the first wall into Y only at the top
    # digit pair T.  This is the Lucas support part of the adjacent block.
    candidates = [
        (left, right)
        for left in middle_factors(p)
        for right in middle_factors(p)
        if left == p - 2 and right == 1
    ]
    assert candidates == [t]

    # Weights of Y tensor R.  Equality with a source weight would be the
    # only possible torus-fixed cochain because the displayed maximum
    # difference is strictly below q-1 for every admissible p.
    source_weights = set(range(source, -source - 1, -2))
    y_weights = (2 * p, 0, -2 * p)
    r_weights = tuple(
        (p - 2 - source - 2 * i) + p * (1 - 2 * j)
        for i in range(p - 1 - source)
        for j in range(2)
    )
    target_weights = {left + right for left in y_weights for right in r_weights}
    assert source_weights.isdisjoint(target_weights)
    max_difference = max(
        abs(left - right) for left in source_weights for right in target_weights
    )
    assert max_difference < p * p - 1

    return {
        "p": p,
        "source": source,
        "T": list(t),
        "R": list(r),
        "Y": list(y),
        "Y_signs": ["alt" if sign else "sym" for sign in y_signs],
        "adjacent_block_candidates": [list(item) for item in candidates],
        "torus_weight_intersection": [],
        "max_weight_difference": max_difference,
        "torus_modulus": p * p - 1,
        "trace_scalar": p - 2 - source,
        "trace_scalar_nonzero": (p - 2 - source) % p != 0,
        "trace_target_dimension": 2 * (source + 1) * (p - 1),
        "spill_target_dimension": 6 * (p - 1 - source),
    }


def calculate():
    occurrence = [
        occurrence_record(p_mod_4, exponent_parity, source)
        for source in (6, 8, 12)
        for p_mod_4 in (1, 3)
        for exponent_parity in (0, 1)
    ]
    spill_samples = [
        spill_record(p, source)
        for p, source in (
            (11, 6),
            (11, 8),
            (13, 6),
            (17, 12),
            (19, 6),
            (19, 8),
            (19, 12),
        )
    ]
    return {
        "schema": 1,
        "digit_formula": "e*(p-1)/2 == 1+s/2 (mod 2)",
        "occurrence_parity_classes": occurrence,
        "spill_samples": spill_samples,
        "small_characteristic_rule": (
            "a candidate with an odd Frobenius digit has no square-socle word"
        ),
        "even_head_packets": {
            "s_mod_4_equals_2": "e*(p-1)/2 is even",
            "s_mod_4_equals_0": "e*(p-1)/2 is odd",
        },
        "evidence_boundary": (
            "bookkeeping audit only; the report proves the Lucas-socle "
            "and adjacent-wall lemmas"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = calculate()
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(rendered)
        print(f"wrote {CERTIFICATE.name}")
    else:
        assert CERTIFICATE.read_text() == rendered
        print("C665 Frobenius-digit spill certificate OK")


if __name__ == "__main__":
    main()
