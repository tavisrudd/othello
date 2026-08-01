#!/usr/bin/env python3
"""Independent direct-congruence replay of the C740 orbit-lock census."""

from __future__ import annotations

import json
import sys
from collections import Counter
from pathlib import Path

N = 333
GENERATORS = {0: (1,), 1: (73,), 2: (112,), 3: (10,), 4: (121,), 5: (211,)}


def generated_group(generators: tuple[int, ...]) -> list[int]:
    previous: set[int] = set()
    current = {1}
    while current != previous:
        previous = set(current)
        current.update((x * g) % N for x in tuple(current) for g in generators)
    return sorted(current)


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(f"usage: {Path(sys.argv[0]).name} CERTIFICATE.json")
    data = json.loads(Path(sys.argv[1]).read_text())
    assert data["schema"] == "c740-lp333-residual-orbit-lock-census-v1"
    assert data["length"] == N
    assert data["criterion"]["required_joint_hamming"] == 334
    assert data["criterion"]["minimum_locked_positions_for_exclusion"] == 167

    excluded = []
    for case in data["cases"]:
        stable_id = case["id"]
        group = generated_group(GENERATORS[stable_id])
        assert group == case["group"]

        # Direct test: x and x+s share an orbit iff h*x=x+s for some h in H.
        counts = []
        for shift in range(1, N):
            locked = sum(any((h * x) % N == (x + shift) % N for h in group) for x in range(N))
            counts.append(locked)
        spectrum = Counter(counts)
        assert {str(k): v for k, v in sorted(spectrum.items())} == case["locked_position_spectrum"]
        maximum = max(counts)
        assert maximum == case["maximum_locked_positions"]
        assert [i + 1 for i, count in enumerate(counts) if count == maximum] == case[
            "maximum_lock_shifts"
        ]
        upper = 2 * (N - maximum)
        assert upper == case["joint_hamming_upper_bound_at_maximum_lock"]
        status = "EXCLUDED" if upper < N + 1 else "NOT_EXCLUDED"
        assert status == case["orbit_lock_status"]
        if status == "EXCLUDED":
            excluded.append(stable_id)

        control = case["positive_control_9_compression"]
        if control is not None:
            a, b = control["sequences"]
            assert sum(a) == sum(b) == 1
            assert sum(x * x for x in a + b) == 594
            totals = []
            for shift in range(1, 9):
                totals.append(
                    sum(
                        sequence[i] * sequence[(i - shift) % 9]
                        for sequence in (a, b)
                        for i in range(9)
                    )
                )
            assert totals == control["joint_paf_nonzero_shifts"] == [-74] * 8
            assert control["status"] == "FEASIBLE_COMPRESSION_ONLY"

    assert excluded == data["newly_excluded_ids"] == [2]
    assert data["surviving_ids"] == [0, 1, 3, 4, 5]
    assert data["updated_impossible_subgroups"] == 25
    assert data["total_mod3_compatible_subgroups"] == 30

    id2 = data["cases"][2]
    assert id2["group"] == [1, 112, 223]
    for x in range(N):
        if x % 3 == 1:
            assert 112 * x % N == (x + 111) % N
        elif x % 3 == 2:
            assert 223 * x % N == (x + 111) % N
    print("PASS: independent six-case congruence census and compression controls")


if __name__ == "__main__":
    main()
