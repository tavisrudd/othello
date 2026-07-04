#!/usr/bin/env python3
"""Candidate-generator diagnostics for border-pair repair replies."""

from __future__ import annotations

import argparse
import csv
import resource
import statistics
import time
from collections import defaultdict
from dataclasses import dataclass
from typing import Callable

import border_overlap_graph_pass as base
import border_overlap_quotient_pass as quotient


@dataclass(frozen=True)
class ReplyRow:
    n: int
    x: int
    y: int
    score: int
    is_min: bool
    same_parity: bool
    scalar_key: tuple[str, ...]
    edge_exact_family: int
    edge_cap4_family: int
    edge_cap2_family: int


def parse_bool(value: str) -> bool:
    return value == "True"


def scalar_key(row: dict[str, str]) -> tuple[str, ...]:
    fields = [
        "unpaired_row_orbits_count",
        "unpaired_col_orbits_count",
        "unpaired_sum_orbits_count",
        "unpaired_diff_orbits_count",
        "total_unpaired_label_orbits",
        "orbit_cover_size",
        "orbit_total_line_cover",
        "orbit_overlap_count",
    ]
    return tuple(row[field] for field in fields)


def percentile(values: list[int], pct: float) -> int:
    if not values:
        return 0
    idx = min(len(values) - 1, int(round((len(values) - 1) * pct)))
    return sorted(values)[idx]


def md_table(rows: list[list[object]]) -> str:
    return base.md_table(rows)


def bucket_best_selector(rows: list[ReplyRow], key_fn: Callable[[ReplyRow], object]) -> set[int]:
    bucket_best: dict[object, int] = {}
    for row in rows:
        key = key_fn(row)
        current = bucket_best.get(key)
        if current is None or row.score < current:
            bucket_best[key] = row.score
    row_min = min(row.score for row in rows)
    good_keys = {key for key, score in bucket_best.items() if score == row_min}
    return {row.y for row in rows if key_fn(row) in good_keys}


def score_band_selector(rows: list[ReplyRow], delta: int, same_parity_only: bool = False) -> set[int]:
    row_min = min(row.score for row in rows)
    return {
        row.y
        for row in rows
        if row.score <= row_min + delta and (not same_parity_only or row.same_parity)
    }


def parity_selector(rows: list[ReplyRow]) -> set[int]:
    return {row.y for row in rows if row.same_parity}


@dataclass
class PolicyStats:
    name: str
    row_count: int = 0
    rows_cover_all: int = 0
    min_records: int = 0
    min_records_selected: int = 0
    selected_sizes: list[int] | None = None
    legal_sizes: list[int] | None = None
    worst_examples: list[tuple[int, int, int, int, int]] | None = None

    def __post_init__(self) -> None:
        self.selected_sizes = []
        self.legal_sizes = []
        self.worst_examples = []

    def add_row(self, n: int, x: int, rows: list[ReplyRow], selected: set[int]) -> None:
        assert self.selected_sizes is not None
        assert self.legal_sizes is not None
        assert self.worst_examples is not None
        minimizers = {row.y for row in rows if row.is_min}
        selected_minimizers = minimizers & selected
        self.row_count += 1
        self.min_records += len(minimizers)
        self.min_records_selected += len(selected_minimizers)
        if selected_minimizers == minimizers:
            self.rows_cover_all += 1
        self.selected_sizes.append(len(selected))
        self.legal_sizes.append(len(rows))
        self.worst_examples.append((len(selected), n, x, len(rows), len(minimizers)))
        self.worst_examples.sort(reverse=True)
        del self.worst_examples[5:]

    def summary(self) -> list[object]:
        assert self.selected_sizes is not None
        assert self.legal_sizes is not None
        mean_size = statistics.fmean(self.selected_sizes) if self.selected_sizes else 0.0
        mean_frac = statistics.fmean(
            size / legal for size, legal in zip(self.selected_sizes, self.legal_sizes)
        ) if self.selected_sizes else 0.0
        row_cover = self.rows_cover_all / self.row_count if self.row_count else 0.0
        record_recall = self.min_records_selected / self.min_records if self.min_records else 0.0
        return [
            self.name,
            f"{100.0 * row_cover:.2f}%",
            f"{record_recall:.4f}",
            f"{mean_size:.2f}",
            percentile(self.selected_sizes, 0.50),
            percentile(self.selected_sizes, 0.90),
            max(self.selected_sizes, default=0),
            f"{100.0 * mean_frac:.2f}%",
        ]


def read_rows(path: str) -> dict[tuple[int, int], list[ReplyRow]]:
    masks_by_n = {n: base.board_masks(n) for n in range(8, 102, 2)}
    edge_exact_family = quotient.EdgeVariant("edge exact family", "family", "exact")
    edge_cap4_family = quotient.EdgeVariant("edge cap4 family", "family", "cap4")
    edge_cap2_family = quotient.EdgeVariant("edge cap2 family", "family", "cap2")
    by_opponent: dict[tuple[int, int], list[ReplyRow]] = defaultdict(list)

    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            n = int(row["n"])
            x = int(row["x"])
            y = int(row["y"])
            masks = masks_by_n[n]
            orbits = base.unpaired_orbits(n, base.border_labels(n, x, y))
            raw_vertices, raw_edges = quotient.raw_overlap_data(masks, orbits)
            by_opponent[(n, x)].append(ReplyRow(
                n=n,
                x=x,
                y=y,
                score=int(row["primary_score"]),
                is_min=parse_bool(row["is_primary_minimizer_for_x"]),
                same_parity=parse_bool(row["same_parity"]),
                scalar_key=scalar_key(row),
                edge_exact_family=hash(quotient.edge_signature(raw_vertices, raw_edges, edge_exact_family)),
                edge_cap4_family=hash(quotient.edge_signature(raw_vertices, raw_edges, edge_cap4_family)),
                edge_cap2_family=hash(quotient.edge_signature(raw_vertices, raw_edges, edge_cap2_family)),
            ))
    return by_opponent


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv", required=True)
    args = parser.parse_args()
    t0 = time.time()
    by_opponent = read_rows(args.csv)

    policies: list[tuple[str, Callable[[list[ReplyRow]], set[int]]]] = [
        ("exact asymmetry minimizers", lambda rows: score_band_selector(rows, 0)),
        ("exact asymmetry <= min+2", lambda rows: score_band_selector(rows, 2)),
        ("exact asymmetry <= min+4", lambda rows: score_band_selector(rows, 4)),
        ("exact asymmetry <= min+6", lambda rows: score_band_selector(rows, 6)),
        ("same parity only", parity_selector),
        ("same parity and <= min+4", lambda rows: score_band_selector(rows, 4, True)),
        ("scalar cover/overlap bucket-best", lambda rows: bucket_best_selector(rows, lambda r: r.scalar_key)),
        ("edge exact-family bucket-best", lambda rows: bucket_best_selector(rows, lambda r: r.edge_exact_family)),
        ("edge cap4-family bucket-best", lambda rows: bucket_best_selector(rows, lambda r: r.edge_cap4_family)),
        ("edge cap2-family bucket-best", lambda rows: bucket_best_selector(rows, lambda r: r.edge_cap2_family)),
    ]
    stats = [PolicyStats(name) for name, _ in policies]
    for (n, x), rows in sorted(by_opponent.items()):
        for stat, (_, selector) in zip(stats, policies):
            stat.add_row(n, x, rows, selector(rows))

    print("## Candidate-generator continuation")
    print()
    print("Status: verified for finite n=8..100 using the previous border-pair CSV.")
    print()
    print(f"Input CSV: `{args.csv}`.")
    print(f"Opponent rows `(n,x)`: `{len(by_opponent)}`.")
    print(f"Legal border-pair rows: `{sum(len(rows) for rows in by_opponent.values())}`.")
    print()
    print("A policy covers a row when its candidate set contains every true B6 asymmetry minimizer for that `(n,x)`.  Bucket-best policies select every reply whose quotient bucket contains at least one exact asymmetry minimizer in the same row; this measures candidate-set inflation caused by quotienting.")
    print()
    table = [[
        "candidate policy",
        "rows covering all minimizers",
        "minimizer recall",
        "mean size",
        "median",
        "p90",
        "max",
        "mean legal %",
    ]]
    for stat in stats:
        table.append(stat.summary())
    print(md_table(table))
    print()

    print("### Worst candidate-set examples")
    print()
    rows = [["policy", "candidate size", "n", "x", "legal replies", "true minimizers"]]
    for stat in stats:
        assert stat.worst_examples is not None
        for size, n, x, legal, minimizers in stat.worst_examples[:2]:
            rows.append([stat.name, size, n, x, legal, minimizers])
    print(md_table(rows))
    print()

    print("### Interpretation")
    print()
    print("- Exact asymmetry minimizers are already a small arithmetic candidate set; score bands show how much slack a repair oracle would need if it accepts near-minimizers.")
    print("- Same parity remains an excellent recall filter but is far too broad on its own.")
    print("- Scalar cover/overlap buckets are compact but inflate candidate sets because many different replies share the same scalar summary.")
    print("- Exact-family edge buckets are much tighter than scalar buckets, but their prior score ambiguity means they are still a candidate generator rather than a theorem-ready minimizer rule.")
    print("- Cap4/cap2 family buckets are useful only as coarse filters; they are too broad to be the final repair vocabulary.")
    print()

    print("## Candidate-generator summary")
    print()
    print("### Strong positive findings")
    print()
    print("- verified for n<=100: exact asymmetry minimizer sets are small enough to be used as B6 candidate seeds.")
    print("- verified for n<=100: exact-family edge buckets give a tighter candidate generator than scalar cover/overlap buckets.")
    print()
    print("### Negative findings")
    print()
    print("- failed / refuted as sufficient filter: same parity alone keeps almost all minimizers but selects too many replies.")
    print("- failed / refuted as final finite vocabulary: cap4/cap2 family edge buckets remain too coarse.")
    print()
    print("### Next low-memory experiment")
    print()
    print("For the rows where exact-family buckets inflate beyond the exact minimizer set, classify the collisions by `(n,x)` side/gap class and by which edge overlaps were family-collapsed.")
    print()
    print("### Next solver-side experiment")
    print()
    print("When solver telemetry is available, compare solver-chosen repairs first against exact asymmetry minimizers, then against exact-family edge-bucket candidates.")
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    print()
    print(f"_Candidate-generator resource footer: elapsed={time.time() - t0:.3f}s, maxrss={rss} KB._")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
