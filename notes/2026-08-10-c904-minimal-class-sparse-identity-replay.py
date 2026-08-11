#!/usr/bin/env python3
"""Independent exact replay of the 16-term C904 minimal-class identity."""

import importlib.util
from pathlib import Path


SOURCE = Path(__file__).with_name(
    "2026-08-10-c904-minimal-class-divisor-replay.py"
)
SPEC = importlib.util.spec_from_file_location("c904_divisor_replay", SOURCE)
MODULE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(MODULE)


IDENTITY = {
    (0, 1, 1, 1): -787,
    (0, 1, 1, 2): 3253,
    (0, 1, 1, 4): 2167,
    (0, 1, 1, 6): -219,
    (0, 1, 1, 7): 3095,
    (0, 1, 1, 12): 1043,
    (0, 1, 2, 3): 861,
    (0, 1, 2, 6): -2285,
    (0, 1, 12, 13): -749,
    (0, 2, 12, 13): 1245,
    (1, 1, 1, 2): -428,
    (1, 1, 1, 3): 114,
    (1, 1, 2, 3): -599,
    (1, 1, 2, 5): -599,
    (1, 2, 3, 5): -1027,
    (1, 2, 12, 13): -171,
}


def main():
    forms = MODULE.divisor_forms()
    eight_indices, rows, monomials = MODULE.all_products(forms)
    target = MODULE.minimal_vector(eight_indices)
    lookup = {monomial: row for monomial, row in zip(monomials, rows)}
    reconstructed = [
        sum(coefficient * lookup[monomial][column]
            for monomial, coefficient in IDENTITY.items())
        for column in range(len(target))
    ]
    assert reconstructed == target
    assert len(IDENTITY) == 16
    assert sum(abs(value) for value in IDENTITY.values()) == 18642
    print("C904 independent sparse primitive divisor identity")
    print("monomials=3060 support=16 L1=18642")
    print("reconstructed theta^4/4! exactly in all 45 coordinates")
    print("PASS")


if __name__ == "__main__":
    main()
