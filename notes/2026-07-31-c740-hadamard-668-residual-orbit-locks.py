#!/usr/bin/env python3
"""Exact one-shift orbit-lock census for residual LP(333) multipliers."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path

LENGTH = 333
GENERATORS = {0: (1,), 1: (73,), 2: (112,), 3: (10,), 4: (121,), 5: (211,)}
EXPECTED_ORDERS = {0: 1, 1: 2, 2: 3, 3: 3, 4: 3, 5: 3}
COMPRESSION_CONTROLS = {
    2: ((17, -5, 1, -11, -5, 1, 7, -5, 1), (1, 1, 1, -7, 1, 1, 1, 1, 1)),
    4: ((-17, 5, -3, 1, 5, -3, 11, 5, -3), (-7, 3, -1, 1, 3, -1, 1, 3, -1)),
    5: ((-17, 5, -3, 1, 5, -3, 11, 5, -3), (-7, 3, -1, 1, 3, -1, 1, 3, -1)),
}


def closure(generators: tuple[int, ...]) -> tuple[int, ...]:
    group = {1}
    frontier = [1]
    while frontier:
        x = frontier.pop()
        for generator in generators:
            product = x * generator % LENGTH
            if product not in group:
                group.add(product)
                frontier.append(product)
    return tuple(sorted(group))


def orbit_partition(group: tuple[int, ...]) -> list[tuple[int, ...]]:
    unused = set(range(LENGTH))
    answer = []
    while unused:
        seed = min(unused)
        orbit = tuple(sorted({h * seed % LENGTH for h in group}))
        answer.append(orbit)
        unused.difference_update(orbit)
    return answer


def paf(sequence: tuple[int, ...]) -> tuple[int, ...]:
    n = len(sequence)
    return tuple(
        sum(sequence[x] * sequence[(x + shift) % n] for x in range(n))
        for shift in range(1, n)
    )


def compression_control(stable_id: int) -> dict | None:
    if stable_id not in COMPRESSION_CONTROLS:
        return None
    a, b = COMPRESSION_CONTROLS[stable_id]
    joint_paf = tuple(x + y for x, y in zip(paf(a), paf(b)))
    assert sum(a) == sum(b) == 1
    assert sum(x * x for x in a + b) == 594
    assert joint_paf == (-74,) * 8
    return {
        "source": "C736 committed feasible 9-compression witness",
        "sequences": [list(a), list(b)],
        "row_sums": [1, 1],
        "joint_squared_norm": 594,
        "joint_paf_nonzero_shifts": list(joint_paf),
        "status": "FEASIBLE_COMPRESSION_ONLY",
    }


def build_case(stable_id: int, generators: tuple[int, ...]) -> dict:
    group = closure(generators)
    assert len(group) == EXPECTED_ORDERS[stable_id]
    orbits = orbit_partition(group)
    orbit_of = {x: number for number, orbit in enumerate(orbits) for x in orbit}
    locked_by_shift = {
        shift: sum(orbit_of[x] == orbit_of[(x + shift) % LENGTH] for x in range(LENGTH))
        for shift in range(1, LENGTH)
    }
    spectrum = Counter(locked_by_shift.values())
    maximum = max(spectrum)
    maximum_shifts = [shift for shift, count in locked_by_shift.items() if count == maximum]
    joint_hamming_upper_bound = 2 * (LENGTH - maximum)
    required = LENGTH + 1
    excluded = joint_hamming_upper_bound < required
    size_counts = Counter(map(len, orbits))
    return {
        "id": stable_id,
        "generators": list(generators),
        "group": list(group),
        "order": len(group),
        "orbit_count": len(orbits),
        "orbit_size_counts": {str(k): v for k, v in sorted(size_counts.items())},
        "locked_position_spectrum": {str(k): v for k, v in sorted(spectrum.items())},
        "maximum_locked_positions": maximum,
        "maximum_lock_shifts": maximum_shifts,
        "joint_hamming_upper_bound_at_maximum_lock": joint_hamming_upper_bound,
        "legendre_required_joint_hamming": required,
        "orbit_lock_status": "EXCLUDED" if excluded else "NOT_EXCLUDED",
        "positive_control_9_compression": compression_control(stable_id),
    }


def build_certificate() -> dict:
    cases = [build_case(stable_id, generators) for stable_id, generators in GENERATORS.items()]
    excluded = [case["id"] for case in cases if case["orbit_lock_status"] == "EXCLUDED"]
    assert excluded == [2]
    id2 = cases[2]
    assert id2["group"] == [1, 112, 223]
    assert id2["maximum_locked_positions"] == 222
    assert id2["maximum_lock_shifts"] == [111, 222]
    return {
        "schema": "c740-lp333-residual-orbit-lock-census-v1",
        "length": LENGTH,
        "scope": "fixed untranslated common multipliers for residual stable IDs 0 through 5",
        "criterion": {
            "required_joint_hamming": LENGTH + 1,
            "exclusion_condition": "2*(length-locked_positions) < length+1",
            "minimum_locked_positions_for_exclusion": 167,
        },
        "cases": cases,
        "newly_excluded_ids": excluded,
        "surviving_ids": [0, 1, 3, 4, 5],
        "updated_impossible_subgroups": 25,
        "total_mod3_compatible_subgroups": 30,
    }


def canonical_bytes(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    choice = parser.add_mutually_exclusive_group(required=True)
    choice.add_argument("--output", type=Path)
    choice.add_argument("--check", type=Path)
    args = parser.parse_args()
    encoded = canonical_bytes(build_certificate())
    if args.output:
        args.output.write_bytes(encoded)
        print(f"wrote {args.output} sha256={hashlib.sha256(encoded).hexdigest()}")
    else:
        if args.check.read_bytes() != encoded:
            raise SystemExit("FAIL: regenerated certificate differs")
        print(f"PASS sha256={hashlib.sha256(encoded).hexdigest()}")


if __name__ == "__main__":
    main()
