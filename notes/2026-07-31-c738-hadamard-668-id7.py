#!/usr/bin/env python3
"""Generate the exact orbit certificate excluding LP(333) multiplier ID 7."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

LENGTH = 333
SHIFT = 111
GENERATORS = (73, 112)
POSITIVE_CONTROL = (
    (17, -5, 1, -11, -5, 1, 7, -5, 1),
    (1, 1, 1, -7, 1, 1, 1, 1, 1),
)


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


def action_orbits(group: tuple[int, ...]) -> list[tuple[int, ...]]:
    remaining = set(range(LENGTH))
    orbits = []
    while remaining:
        seed = min(remaining)
        orbit = tuple(sorted({h * seed % LENGTH for h in group}))
        orbits.append(orbit)
        remaining.difference_update(orbit)
    return orbits


def periodic_autocorrelation(sequence: tuple[int, ...]) -> tuple[int, ...]:
    size = len(sequence)
    return tuple(
        sum(sequence[x] * sequence[(x + shift) % size] for x in range(size))
        for shift in range(1, size)
    )


def build_certificate() -> dict:
    group = closure(GENERATORS)
    assert group == (1, 73, 112, 184, 223, 295)
    orbits = action_orbits(group)
    orbit_index = {x: index for index, orbit in enumerate(orbits) for x in orbit}

    forced_equal = [
        x for x in range(LENGTH) if orbit_index[x] == orbit_index[(x + SHIFT) % LENGTH]
    ]
    free = sorted(set(range(LENGTH)) - set(forced_equal))
    assert forced_equal == [x for x in range(LENGTH) if x % 3]
    assert free == [x for x in range(LENGTH) if x % 3 == 0]
    assert all(112 * x % LENGTH == (x + SHIFT) % LENGTH for x in forced_equal if x % 3 == 1)
    assert all(223 * x % LENGTH == (x + SHIFT) % LENGTH for x in forced_equal if x % 3 == 2)

    witness_a, witness_b = POSITIVE_CONTROL
    paf_sum = tuple(
        x + y
        for x, y in zip(
            periodic_autocorrelation(witness_a), periodic_autocorrelation(witness_b)
        )
    )
    assert sum(witness_a) == sum(witness_b) == 1
    assert sum(x * x for x in witness_a + witness_b) == 594
    assert paf_sum == (-74,) * 8
    assert all(witness_a[4 * x % 9] == witness_a[x] for x in range(9))
    assert all(witness_b[4 * x % 9] == witness_b[x] for x in range(9))

    required_joint_hamming = LENGTH + 1
    per_sequence_hamming_upper_bound = len(free)
    joint_hamming_upper_bound = 2 * per_sequence_hamming_upper_bound
    assert joint_hamming_upper_bound < required_joint_hamming

    sizes: dict[str, int] = {}
    for orbit in orbits:
        key = str(len(orbit))
        sizes[key] = sizes.get(key, 0) + 1
    return {
        "schema": "c738-lp333-id7-orbit-obstruction-v1",
        "length": LENGTH,
        "stable_id": 7,
        "generators": list(GENERATORS),
        "group": list(group),
        "orbit_count": len(orbits),
        "orbit_size_counts": sizes,
        "obstruction": {
            "shift": SHIFT,
            "forced_equal_positions": len(forced_equal),
            "forced_equal_residue_classes_mod_3": [1, 2],
            "free_positions_per_sequence": len(free),
            "per_sequence_hamming_upper_bound": per_sequence_hamming_upper_bound,
            "joint_hamming_upper_bound": joint_hamming_upper_bound,
            "legendre_required_joint_hamming": required_joint_hamming,
            "equivalent_joint_paf_lower_bound": 2 * LENGTH - 2 * joint_hamming_upper_bound,
            "legendre_required_joint_paf": -2,
        },
        "positive_control_9_compression": {
            "source": "C736 committed feasible witness",
            "sequences": [list(witness_a), list(witness_b)],
            "row_sums": [sum(witness_a), sum(witness_b)],
            "joint_squared_norm": sum(x * x for x in witness_a + witness_b),
            "joint_paf_nonzero_shifts": list(paf_sum),
            "required_joint_paf": -74,
            "status": "FEASIBLE",
        },
        "conclusion": "ID 7 admits no fixed common-multiplier Legendre pair of length 333",
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
