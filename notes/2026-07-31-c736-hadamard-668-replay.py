#!/usr/bin/env python3
"""Independent compact replay of the C736 id9/id10 exclusion.

This deliberately does not import the generator.  It uses the explicit
five-variable form of every allowed 9-compression and checks the committed
profile ledger as well as the complement obstruction.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

V6 = (-37, -35, -25, -23, -13, -11, -1, 1, 11, 13, 23, 25, 35, 37)
ODD37 = tuple(range(-37, 38, 2))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    args = parser.parse_args()
    certificate = json.loads(args.certificate.read_text())

    # Exhaust the complete residue-class proof independently of all magnitude
    # bounds and of the profile enumeration below.
    fixed_mod24 = (1, 11, 13, 23)
    odd_mod24 = tuple(range(1, 24, 2))
    residue_models = 0
    for c0 in fixed_mod24:
        for c3 in fixed_mod24:
            for c6 in fixed_mod24:
                for x in odd_mod24:
                    for y in odd_mod24:
                        singleton_sum = c0 + c3 + c6
                        if (singleton_sum + 3 * (x + y) - 1) % 24:
                            continue
                        residue_models += 1
                        six_shift = singleton_sum * (x + y) + 3 * x * y
                        assert six_shift % 8 == 5
    assert residue_models > 0
    assert (2 * 5) % 8 != (-74) % 8

    profiles = set()
    accepted = 0
    observed_shift_residues = set()
    # Sequence positions are (c0,x,y,c3,x,y,c6,x,y).  Derive y from
    # c0+c3+c6+3(x+y)=1 rather than iterating a fifth domain.
    for c0 in V6:
        for c3 in V6:
            for c6 in V6:
                singleton_sum = c0 + c3 + c6
                for x in ODD37:
                    numerator = 1 - singleton_sum - 3 * x
                    if numerator % 3:
                        continue
                    y = numerator // 3
                    if y not in ODD37:
                        continue
                    norm = c0 * c0 + c3 * c3 + c6 * c6 + 3 * x * x + 3 * y * y
                    if norm > 594:
                        continue
                    accepted += 1
                    six_shift = singleton_sum * (x + y) + 3 * x * y
                    three_shift = c0 * c3 + c3 * c6 + c6 * c0 + 3 * x * x + 3 * y * y
                    # Ordered full profile for shifts 1,...,8.
                    profile = (six_shift, six_shift, three_shift, six_shift,
                               six_shift, three_shift, six_shift, six_shift)
                    profiles.add((norm, profile))
                    observed_shift_residues.add(six_shift % 8)

    assert accepted == 504, accepted
    assert len(profiles) == 52, len(profiles)
    assert observed_shift_residues == {5}
    assert (5 + 5) % 8 == 2 != (-74) % 8
    for norm, profile in profiles:
        complement = (594 - norm, tuple(-74 - value for value in profile))
        assert complement not in profiles

    expected_ledger = [[norm, list(profile)] for norm, profile in sorted(profiles)]
    for stable_id in (9, 10):
        case = next(x for x in certificate["cases"] if x["id"] == stable_id)
        compression = next(x for x in case["compressions"] if x["d"] == 9)
        assert compression["status"] == "INFEASIBLE"
        assert compression["profile_ledger"] == expected_ledger
        assert case["analytic_obstruction"]["forced_paf_mod_8"] == 5

    print("PASS: ids 9 and 10; 504 sequences, 52 profiles, no complementary pair")


if __name__ == "__main__":
    main()
