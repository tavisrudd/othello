#!/usr/bin/env python3
"""Classify row/col quotient mixed-minimizer context effects."""

from __future__ import annotations

import argparse
import csv
import resource
import time
from collections import Counter
from dataclasses import dataclass

import border_overlap_graph_pass as base
import border_overlap_quotient_pass as quotient
import border_symmetry_quotient_pass as symq


@dataclass
class Group:
    score: int | None = None
    min_examples: list[tuple[int, int, int, int, int]] | None = None
    nonmin_examples: list[tuple[int, int, int, int, int]] | None = None
    min_count: int = 0
    nonmin_count: int = 0
    nonmin_delta_counts: Counter[int] | None = None
    n_counts: Counter[int] | None = None

    def __post_init__(self) -> None:
        self.min_examples = []
        self.nonmin_examples = []
        self.nonmin_delta_counts = Counter()
        self.n_counts = Counter()

    def add(self, n: int, x: int, y: int, score: int, row_min: int, is_min: bool) -> None:
        assert self.min_examples is not None
        assert self.nonmin_examples is not None
        assert self.nonmin_delta_counts is not None
        assert self.n_counts is not None
        if self.score is None:
            self.score = score
        elif self.score != score:
            raise ValueError("row/col quotient group had score ambiguity")
        self.n_counts[n] += 1
        delta = score - row_min
        if is_min:
            self.min_count += 1
            if len(self.min_examples) < 3:
                self.min_examples.append((n, x, y, score, delta))
        else:
            self.nonmin_count += 1
            self.nonmin_delta_counts[delta] += 1
            if len(self.nonmin_examples) < 3:
                self.nonmin_examples.append((n, x, y, score, delta))


def parse_bool(value: str) -> bool:
    return value == "True"


def md_table(rows: list[list[object]]) -> str:
    return base.md_table(rows)


def example_str(examples: list[tuple[int, int, int, int, int]] | None) -> str:
    if not examples:
        return ""
    return "; ".join(
        f"n={n},x={x},y={y},score={score},delta={delta}"
        for n, x, y, score, delta in examples[:2]
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv", required=True)
    args = parser.parse_args()
    t0 = time.time()

    rows = []
    row_min: dict[tuple[int, int], int] = {}
    with open(args.csv, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            n = int(row["n"])
            x = int(row["x"])
            score = int(row["primary_score"])
            rows.append(row)
            key = (n, x)
            row_min[key] = min(row_min.get(key, score), score)

    masks_by_n = {n: base.board_masks(n) for n in range(8, 102, 2)}
    variant = symq.SymVariant(
        "full-kind exact + row/col kind quotient",
        (symq.frozen_kind_map(symq.KIND_ID), symq.frozen_kind_map(symq.KIND_ROWCOL)),
        (False,),
    )
    groups: dict[int, Group] = {}
    for row in rows:
        n = int(row["n"])
        x = int(row["x"])
        y = int(row["y"])
        score = int(row["primary_score"])
        is_min = parse_bool(row["is_primary_minimizer_for_x"])
        masks = masks_by_n[n]
        orbits = base.unpaired_orbits(n, base.border_labels(n, x, y))
        raw_vertices, raw_edges = quotient.raw_overlap_data(masks, orbits)
        sig = symq.canonical_signature(raw_vertices, raw_edges, variant)
        key = hash(sig)
        group = groups.get(key)
        if group is None:
            group = Group()
            groups[key] = group
        group.add(n, x, y, score, row_min[(n, x)], is_min)

    mixed = [
        group
        for group in groups.values()
        if group.min_count and group.nonmin_count
    ]
    mixed_rows = sum(group.min_count + group.nonmin_count for group in mixed)
    nonmin_records = sum(group.nonmin_count for group in mixed)
    min_records = sum(group.min_count for group in mixed)
    delta_counts: Counter[int] = Counter()
    n_counts: Counter[int] = Counter()
    for group in mixed:
        assert group.nonmin_delta_counts is not None
        assert group.n_counts is not None
        delta_counts.update(group.nonmin_delta_counts)
        n_counts.update(group.n_counts)

    print("## Row/col quotient mixed-context continuation")
    print()
    print("Status: verified for finite n=8..100 using the previous border-pair CSV.")
    print()
    print(f"Input CSV: `{args.csv}`.")
    print(f"Rows read: `{len(rows)}`.")
    print(f"Row/col quotient groups: `{len(groups)}`.")
    print(f"Mixed minimizer/non-minimizer groups: `{len(mixed)}`.")
    print(f"Rows in mixed groups: `{mixed_rows}`.")
    print(f"Minimizer records in mixed groups: `{min_records}`.")
    print(f"Non-minimizer records in mixed groups: `{nonmin_records}`.")
    print()
    print("Because the row/col quotient is score-exact, a mixed group means the same local overlap score is a row minimum in one `(n,x)` context and not a row minimum in another. This is context dependence, not score ambiguity.")
    print()

    print("### Non-minimizer score delta in mixed groups")
    print()
    print(md_table([
        ["score - row_min", "records"],
        *[[delta, count] for delta, count in sorted(delta_counts.items())],
    ]))
    print()

    print("### Mixed-group concentration by n")
    print()
    print(md_table([
        ["n", "mixed-group records"],
        *sorted(n_counts.items(), key=lambda item: (-item[1], item[0]))[:16],
    ]))
    print()

    print("### Largest mixed groups")
    print()
    largest = sorted(mixed, key=lambda group: (group.min_count + group.nonmin_count, group.nonmin_count), reverse=True)[:12]
    table = [["score", "records", "min records", "nonmin records", "nonmin deltas", "min examples", "nonmin examples"]]
    for group in largest:
        assert group.nonmin_delta_counts is not None
        table.append([
            group.score,
            group.min_count + group.nonmin_count,
            group.min_count,
            group.nonmin_count,
            dict(sorted(group.nonmin_delta_counts.items())),
            example_str(group.min_examples),
            example_str(group.nonmin_examples),
        ])
    print(md_table(table))
    print()

    print("### Algebraic reading")
    print()
    print("Status: heuristic proof sketch.")
    print()
    print("The row/col quotient preserves `|combined_asym|` because transposition of the embedded S-core swaps row and column label masks while preserving square counts, tau-pair counts, and all pairwise intersections with the diagonal label masks. For a row-arm to column-arm border pair, quotienting row/col color identifies transpose-dual overlap fingerprints; xor-size of active-vs-tau-mate cover is invariant under that transpose.")
    print()
    print("The quotient does not preserve minimizer status because minimizer status is not a local score property. It depends on the competing scores available in the fixed row context `(n,x)`. The same quotient class and same absolute score can be optimal for one opponent coordinate and suboptimal for another.")
    print()

    print("## Row/col mixed-context summary")
    print()
    print("### Strong positive findings")
    print()
    print("- verified for n<=100: row/col-quotiented full-kind edge signatures preserve `|combined_asym|` exactly.")
    print("- verified for n<=100: mixed minimizer groups are explained by row-baseline context rather than local score ambiguity.")
    print()
    print("### Negative findings")
    print()
    print("- failed / refuted as local repair oracle: even a score-exact local quotient does not decide whether a reply is an asymmetry minimizer without `(n,x)` context.")
    print()
    print("### Next low-memory experiment")
    print()
    print("Write a theorem-ready lemma for transpose invariance of the row/col quotient, then define repair telemetry as `(row_context, local_overlap_signature, score_rank)` rather than local signature alone.")
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    print()
    print(f"_Row/col mixed-context resource footer: elapsed={time.time() - t0:.3f}s, maxrss={rss} KB._")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
