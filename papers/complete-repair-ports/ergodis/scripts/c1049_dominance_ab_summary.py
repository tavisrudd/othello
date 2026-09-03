#!/usr/bin/env python3
"""Reduce the C1049 dominance A/B raw samples to per-cell medians.

Reads the tab-separated raw sample stream written by the
`c1049_l2_dominance_ab` example and prints one row per (demands, relation)
with the median wall time and the exact work counters, which are identical
across rounds by construction and are asserted to be so here.

usage: c1049_dominance_ab_summary.py <raw.tsv>
"""

import statistics
import sys
from collections import defaultdict

EXACT_COLUMNS = [
    "repaired",
    "transitions",
    "peak_states",
    "pruned",
    "comparisons",
    "witness_bytes",
    "verified",
]


def main() -> int:
    if len(sys.argv) != 2:
        print(__doc__, file=sys.stderr)
        return 2
    with open(sys.argv[1], encoding="utf-8") as handle:
        header = handle.readline().rstrip("\n").split("\t")
        rows = [
            dict(zip(header, line.rstrip("\n").split("\t")))
            for line in handle
            if line.strip()
        ]

    samples = defaultdict(list)
    for row in rows:
        samples[(int(row["demands"]), row["mode"])].append(row)

    print(
        "demands\tmode\trounds\tmedian_ms\t"
        + "\t".join(EXACT_COLUMNS)
        + "\tpeak_rss_kib"
    )
    medians = {}
    for key in sorted(samples):
        group = samples[key]
        for column in EXACT_COLUMNS:
            values = {row[column] for row in group}
            assert len(values) == 1, f"{key} varies in {column}: {values}"
        median_ms = statistics.median(int(row["elapsed_ns"]) for row in group) / 1e6
        medians[key] = median_ms
        first = group[0]
        print(
            f"{key[0]}\t{key[1]}\t{len(group)}\t{median_ms:.3f}\t"
            + "\t".join(first[column] for column in EXACT_COLUMNS)
            + f"\t{max(int(row['peak_rss_kib']) for row in group)}"
        )

    print()
    print("demands\tlegacy_ms\texact_ms\tclamped_ms\texact_x\tclamped_x")
    for demands in sorted({key[0] for key in medians}):
        legacy = medians.get((demands, "legacy"))
        exact = medians.get((demands, "exact"))
        clamped = medians.get((demands, "clamped"))
        if legacy is None or exact is None or clamped is None:
            continue
        print(
            f"{demands}\t{legacy:.3f}\t{exact:.3f}\t{clamped:.3f}\t"
            f"{legacy / exact:.2f}\t{legacy / clamped:.2f}"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
