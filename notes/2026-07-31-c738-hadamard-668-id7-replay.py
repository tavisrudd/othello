#!/usr/bin/env python3
"""Independent elementary replay of the C738 orbit obstruction."""

from __future__ import annotations

import json
import sys
from collections import Counter
from pathlib import Path

N = 333


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit(f"usage: {Path(sys.argv[0]).name} CERTIFICATE.json")
    certificate = json.loads(Path(sys.argv[1]).read_text())
    if certificate["schema"] != "c738-lp333-id7-orbit-obstruction-v1":
        raise SystemExit("FAIL: unknown schema")

    generated = {1}
    while True:
        enlarged = generated | {(x * g) % N for x in generated for g in (73, 112)}
        if enlarged == generated:
            break
        generated = enlarged
    group = sorted(generated)
    assert group == certificate["group"] == [1, 73, 112, 184, 223, 295]

    representatives = {}
    for x in range(N):
        orbit = tuple(sorted({(h * x) % N for h in group}))
        representatives[x] = orbit
    orbit_set = set(representatives.values())
    size_counts = Counter(map(len, orbit_set))
    assert len(orbit_set) == certificate["orbit_count"] == 95
    assert {str(k): v for k, v in sorted(size_counts.items())} == certificate["orbit_size_counts"]

    forced = []
    for x in range(N):
        same_orbit = representatives[x] == representatives[(x + 111) % N]
        direct_reason = (x % 3 == 1 and 112 * x % N == (x + 111) % N) or (
            x % 3 == 2 and 223 * x % N == (x + 111) % N
        )
        assert same_orbit == direct_reason == (x % 3 != 0)
        if same_orbit:
            forced.append(x)
    obstruction = certificate["obstruction"]
    assert len(forced) == obstruction["forced_equal_positions"] == 222
    free = N - len(forced)
    assert free == obstruction["per_sequence_hamming_upper_bound"] == 111
    assert 2 * free == obstruction["joint_hamming_upper_bound"] == 222
    assert N + 1 == obstruction["legendre_required_joint_hamming"] == 334
    assert 2 * N - 2 * (2 * free) == obstruction["equivalent_joint_paf_lower_bound"] == 222
    assert obstruction["legendre_required_joint_paf"] == -2

    control = certificate["positive_control_9_compression"]
    a, b = control["sequences"]
    assert len(a) == len(b) == 9
    assert [sum(a), sum(b)] == control["row_sums"] == [1, 1]
    assert sum(value**2 for value in a) + sum(value**2 for value in b) == 594
    correlations = []
    for shift in range(1, 9):
        total = 0
        for sequence in (a, b):
            total += sum(sequence[(i - shift) % 9] * sequence[i] for i in range(9))
        correlations.append(total)
    assert correlations == control["joint_paf_nonzero_shifts"] == [-74] * 8
    assert all(a[(7 * i) % 9] == a[i] and b[(7 * i) % 9] == b[i] for i in range(9))
    assert control["status"] == "FEASIBLE"

    assert certificate["conclusion"] == (
        "ID 7 admits no fixed common-multiplier Legendre pair of length 333"
    )
    print("PASS: independent orbit obstruction and 9-compression positive control")


if __name__ == "__main__":
    main()
