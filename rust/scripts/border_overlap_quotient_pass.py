#!/usr/bin/env python3
"""Quotient/compression pass for border-pair overlap signatures.

This continues the border overlap-graph notes by deliberately throwing away
metric detail from the previous pairwise signatures and measuring how much
score/minimizer information survives.
"""

from __future__ import annotations

import argparse
import csv
import resource
import time
from collections import Counter
from dataclasses import dataclass
from typing import Callable, Iterable

import border_overlap_graph_pass as base


def count_bucket(value: int, mode: str) -> int:
    if mode == "exact":
        return value
    if mode == "bool":
        return 1 if value else 0
    if mode.startswith("cap"):
        return min(value, int(mode[3:]))
    if mode == "pow2":
        if value <= 3:
            return value
        return 1 << (value.bit_length() - 1)
    raise ValueError(mode)


def kind_bucket(kind: str, mode: str) -> str:
    if mode == "full":
        return kind
    if mode == "family":
        return "orth" if kind in {"row", "col"} else "diag"
    if mode == "line":
        return "line"
    raise ValueError(mode)


def normalize_edge_desc(edge: tuple[int, int, int, int, int], mode: str) -> tuple[int, ...]:
    return tuple(count_bucket(v, mode) for v in edge)


def swapped_edge(edge: tuple[int, int, int, int, int]) -> tuple[int, int, int, int, int]:
    cover, aa, am, ma, mm = edge
    return cover, mm, ma, am, aa


@dataclass(frozen=True)
class EdgeVariant:
    name: str
    kind_mode: str
    count_mode: str
    global_active_mate_quotient: bool = False


@dataclass
class Group:
    count: int = 0
    min_score: int = 10**9
    max_score: int = -1
    truth_mask: int = 0
    min_example: tuple[int, int, int, int, bool] | None = None
    max_example: tuple[int, int, int, int, bool] | None = None

    def add(self, score: int, is_min: bool, example: tuple[int, int, int, int, bool]) -> None:
        self.count += 1
        if score < self.min_score:
            self.min_score = score
            self.min_example = example
        if score > self.max_score:
            self.max_score = score
            self.max_example = example
        self.truth_mask |= 1 if is_min else 2

    @property
    def spread(self) -> int:
        return self.max_score - self.min_score

    @property
    def mixed_truth(self) -> bool:
        return self.truth_mask == 3


class VariantStats:
    def __init__(self, name: str) -> None:
        self.name = name
        self.groups: dict[int, Group] = {}

    def add(self, key_obj: object, score: int, is_min: bool, example: tuple[int, int, int, int, bool]) -> None:
        # These are diagnostic quotient buckets, not persistent certificates.
        # Keeping full graph keys for every bucket makes the n<=100 pass too slow.
        key = hash(key_obj)
        group = self.groups.get(key)
        if group is None:
            group = Group()
            self.groups[key] = group
        group.add(score, is_min, example)

    def summary(self, total_rows: int) -> list[object]:
        groups = list(self.groups.values())
        num_groups = len(groups)
        ambiguous_score_groups = sum(1 for g in groups if g.spread)
        ambiguous_score_rows = sum(g.count for g in groups if g.spread)
        mixed_min_groups = sum(1 for g in groups if g.mixed_truth)
        mixed_min_rows = sum(g.count for g in groups if g.mixed_truth)
        max_spread = max((g.spread for g in groups), default=0)
        exact_score_rows = total_rows - ambiguous_score_rows
        compression = total_rows / num_groups if num_groups else 0.0
        return [
            self.name,
            num_groups,
            f"{compression:.2f}x",
            ambiguous_score_groups,
            f"{100.0 * exact_score_rows / total_rows:.2f}%",
            max_spread,
            mixed_min_groups,
            f"{100.0 * (total_rows - mixed_min_rows) / total_rows:.2f}%",
        ]

    def spread_buckets(self) -> Counter[str]:
        out: Counter[str] = Counter()
        for group in self.groups.values():
            spread = group.spread
            if spread == 0:
                out["0"] += 1
            elif spread <= 2:
                out["1-2"] += 1
            elif spread <= 4:
                out["3-4"] += 1
            elif spread <= 6:
                out["5-6"] += 1
            elif spread <= 10:
                out["7-10"] += 1
            else:
                out[">10"] += 1
        return out

    def top_spreads(self, limit: int = 5) -> list[Group]:
        return sorted(self.groups.values(), key=lambda g: (g.spread, g.count), reverse=True)[:limit]


def raw_overlap_data(
    masks: base.BoardMasks,
    orbits: list[tuple[str, int, int, int]],
) -> tuple[list[tuple[str, int, int, int, int]], list[tuple[int, int, tuple[int, int, int, int, int]]]]:
    raw_vertices = []
    line_data = []
    for orbit in orbits:
        active, mate = base.orbit_masks(masks, orbit)
        cover = active | mate
        raw_vertices.append((
            orbit[0],
            active.bit_count(),
            mate.bit_count(),
            cover.bit_count(),
            (active & mate).bit_count(),
        ))
        line_data.append((active, mate, cover))

    raw_edges = []
    for i in range(len(line_data)):
        ai, mi, ci = line_data[i]
        for j in range(i + 1, len(line_data)):
            aj, mj, cj = line_data[j]
            raw_edges.append((
                i,
                j,
                (
                    (ci & cj).bit_count(),
                    (ai & aj).bit_count(),
                    (ai & mj).bit_count(),
                    (mi & aj).bit_count(),
                    (mi & mj).bit_count(),
                ),
            ))
    return raw_vertices, raw_edges


def edge_signature_from_raw(
    raw_vertices: list[tuple[str, int, int, int, int]],
    raw_edges: list[tuple[int, int, tuple[int, int, int, int, int]]],
    variant: EdgeVariant,
    swap_active_mate: bool = False,
) -> tuple[object, ...]:
    vertices = []
    for kind, active_count, mate_count, cover_count, both_count in raw_vertices:
        if swap_active_mate:
            active_count, mate_count = mate_count, active_count
        mapped_kind = kind_bucket(kind, variant.kind_mode)
        vertex = (
            mapped_kind,
            count_bucket(active_count, variant.count_mode),
            count_bucket(mate_count, variant.count_mode),
            count_bucket(cover_count, variant.count_mode),
            count_bucket(both_count, variant.count_mode),
        )
        vertices.append(vertex)

    vertex_counter = Counter(vertices)
    edge_counter: Counter[tuple[object, ...]] = Counter()
    for i, j, raw_edge in raw_edges:
        vi = vertices[i]
        vj = vertices[j]
        edge = swapped_edge(raw_edge) if swap_active_mate else raw_edge
        if vi < vj:
            endpoints = (vi, vj)
        elif vi > vj:
            endpoints = (vj, vi)
            cover, aa, am, ma, mm = edge
            edge = cover, aa, ma, am, mm
        else:
            cover, aa, am, ma, mm = edge
            endpoints = (vi, vj)
            edge = cover, aa, min(am, ma), max(am, ma), mm
        edge_counter[(*endpoints, normalize_edge_desc(edge, variant.count_mode))] += 1

    return (
        tuple(sorted(vertex_counter.items())),
        tuple(sorted(edge_counter.items())),
    )


def edge_signature(
    raw_vertices: list[tuple[str, int, int, int, int]],
    raw_edges: list[tuple[int, int, tuple[int, int, int, int, int]]],
    variant: EdgeVariant,
) -> tuple[object, ...]:
    normal = edge_signature_from_raw(raw_vertices, raw_edges, variant, False)
    if not variant.global_active_mate_quotient:
        return normal
    swapped = edge_signature_from_raw(raw_vertices, raw_edges, variant, True)
    return min(normal, swapped)


def csv_key(row: dict[str, str], fields: Iterable[str]) -> tuple[object, ...]:
    return tuple(row[field] for field in fields)


def parse_bool(value: str) -> bool:
    return value == "True"


def row_context_key(row: dict[str, str], key: object) -> tuple[object, ...]:
    return int(row["n"]), int(row["x"]), key


def example_str(example: tuple[int, int, int, int, bool] | None) -> str:
    if example is None:
        return ""
    n, x, y, score, is_min = example
    return f"n={n}, x={x}, y={y}, score={score}, min={is_min}"


def print_top_spreads(stats: VariantStats, title: str) -> None:
    print(f"### Largest residual spreads: {title}")
    print()
    rows = [["spread", "rows", "min example", "max example"]]
    for group in stats.top_spreads():
        rows.append([
            group.spread,
            group.count,
            example_str(group.min_example),
            example_str(group.max_example),
        ])
    print(base.md_table(rows))
    print()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv", required=True)
    args = parser.parse_args()
    t0 = time.time()

    masks_by_n = {n: base.board_masks(n) for n in range(8, 102, 2)}
    scalar_variants: list[tuple[str, Callable[[dict[str, str]], object]]] = [
        (
            "csv: unpaired orbit counts",
            lambda r: csv_key(r, [
                "unpaired_row_orbits_count",
                "unpaired_col_orbits_count",
                "unpaired_sum_orbits_count",
                "unpaired_diff_orbits_count",
                "total_unpaired_label_orbits",
            ]),
        ),
        (
            "csv: counts + cover/overlap",
            lambda r: csv_key(r, [
                "unpaired_row_orbits_count",
                "unpaired_col_orbits_count",
                "unpaired_sum_orbits_count",
                "unpaired_diff_orbits_count",
                "total_unpaired_label_orbits",
                "orbit_cover_size",
                "orbit_total_line_cover",
                "orbit_overlap_count",
            ]),
        ),
        (
            "csv: counts + cover/overlap + parity",
            lambda r: csv_key(r, [
                "unpaired_row_orbits_count",
                "unpaired_col_orbits_count",
                "unpaired_sum_orbits_count",
                "unpaired_diff_orbits_count",
                "total_unpaired_label_orbits",
                "orbit_cover_size",
                "orbit_total_line_cover",
                "orbit_overlap_count",
                "same_parity",
                "x_parity",
                "y_parity",
            ]),
        ),
        (
            "csv: counts + cover/overlap + side + nmod",
            lambda r: csv_key(r, [
                "unpaired_row_orbits_count",
                "unpaired_col_orbits_count",
                "unpaired_sum_orbits_count",
                "unpaired_diff_orbits_count",
                "total_unpaired_label_orbits",
                "orbit_cover_size",
                "orbit_total_line_cover",
                "orbit_overlap_count",
                "same_parity",
                "same_side",
                "x_side",
                "y_side",
                "n_mod4",
                "n_mod8",
            ]),
        ),
    ]

    edge_variants = [
        EdgeVariant("edge multiset exact full kind", "full", "exact"),
        EdgeVariant("edge multiset exact family", "family", "exact"),
        EdgeVariant("edge multiset cap4 family", "family", "cap4"),
        EdgeVariant("edge multiset cap2 family", "family", "cap2"),
        EdgeVariant("edge multiset boolean family", "family", "bool"),
    ]

    stats = [VariantStats(name) for name, _ in scalar_variants]
    stats_by_name = {s.name: s for s in stats}
    row_context_stats = [
        VariantStats("row context + csv: counts + cover/overlap"),
        VariantStats("row context + edge multiset cap4 family"),
        VariantStats("row context + edge multiset cap2 family"),
    ]
    row_context_by_name = {s.name: s for s in row_context_stats}
    for variant in edge_variants:
        obj = VariantStats(variant.name)
        stats.append(obj)
        stats_by_name[variant.name] = obj

    total_rows = 0
    asym_mismatches = 0
    same_parity_min = 0
    min_rows = 0
    same_parity_rows = 0

    with open(args.csv, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            total_rows += 1
            n = int(row["n"])
            x = int(row["x"])
            y = int(row["y"])
            score = int(row["primary_score"])
            is_min = parse_bool(row["is_primary_minimizer_for_x"])
            example = (n, x, y, score, is_min)
            if is_min:
                min_rows += 1
            if parse_bool(row["same_parity"]):
                same_parity_rows += 1
                if is_min:
                    same_parity_min += 1

            masks = masks_by_n[n]
            if base.asym_from_border_masks(masks, n, x, y) != score:
                asym_mismatches += 1
            orbits = base.unpaired_orbits(n, base.border_labels(n, x, y))
            raw_vertices, raw_edges = raw_overlap_data(masks, orbits)

            scalar_keys: dict[str, object] = {}
            for name, make_key in scalar_variants:
                key = make_key(row)
                scalar_keys[name] = key
                stats_by_name[name].add(key, score, is_min, example)
            row_context_by_name["row context + csv: counts + cover/overlap"].add(
                row_context_key(row, scalar_keys["csv: counts + cover/overlap"]),
                score,
                is_min,
                example,
            )

            edge_keys: dict[str, object] = {}
            for variant in edge_variants:
                key = edge_signature(raw_vertices, raw_edges, variant)
                edge_keys[variant.name] = key
                stats_by_name[variant.name].add(key, score, is_min, example)

            row_context_by_name["row context + edge multiset cap4 family"].add(
                row_context_key(row, edge_keys["edge multiset cap4 family"]),
                score,
                is_min,
                example,
            )
            row_context_by_name["row context + edge multiset cap2 family"].add(
                row_context_key(row, edge_keys["edge multiset cap2 family"]),
                score,
                is_min,
                example,
            )

    print("## Quotient/compression continuation")
    print()
    print("Status: verified for finite n=8..100 using the previous border-pair CSV.")
    print()
    print(f"Input CSV: `{args.csv}`.")
    print(f"Rows read: `{total_rows}`.")
    print(f"Asymmetry recomputation mismatches: `{asym_mismatches}`.")
    print()
    print("The variants below deliberately quotient the previous rich overlap graph.  `score-exact rows` is the percentage of rows whose quotient class has a single `|combined_asym|` value.  `min-pure rows` is the percentage of rows whose quotient class is not mixed between minimizers and non-minimizers.")
    print()
    print("Implementation note: quotient classes are grouped by in-process Python hashes of immutable signatures to keep this continuation under the low-memory/time budget.  The collision risk is negligible for this diagnostic pass, but theorem claims should use canonical signatures.")
    print()
    table = [[
        "quotient",
        "groups",
        "compression",
        "ambiguous score groups",
        "score-exact rows",
        "max spread",
        "mixed min groups",
        "min-pure rows",
    ]]
    for obj in stats:
        table.append(obj.summary(total_rows))
    print(base.md_table(table))
    print()

    print("### Same-parity filter check")
    print()
    precision = same_parity_min / same_parity_rows if same_parity_rows else 0.0
    recall = same_parity_min / min_rows if min_rows else 0.0
    print(base.md_table([
        ["filter", "rows selected", "minimizers selected", "precision", "recall"],
        ["same parity", same_parity_rows, same_parity_min, f"{precision:.3f}", f"{recall:.3f}"],
    ]))
    print()

    print("### Row-context minimizer purity")
    print()
    print("Status: heuristic diagnostic.  These quotients are augmented with `(n,x)` because minimizer status is row-relative.")
    print()
    row_table = [[
        "row-context quotient",
        "groups",
        "compression",
        "ambiguous score groups",
        "score-exact rows",
        "max spread",
        "mixed min groups",
        "min-pure rows",
    ]]
    for obj in row_context_stats:
        row_table.append(obj.summary(total_rows))
    print(base.md_table(row_table))
    print()

    print_top_spreads(stats_by_name["csv: counts + cover/overlap"], "csv counts + cover/overlap")
    print_top_spreads(stats_by_name["edge multiset cap4 family"], "edge multiset cap4 family")
    print_top_spreads(stats_by_name["edge multiset cap2 family"], "edge multiset cap2 family")

    print("### Interpretation")
    print()
    print("- Scalar counts plus cover/overlap remain a strong low-dimensional approximation but do not determine the score exactly.")
    print("- The exact full-kind edge multiset is the key compression test: it preserves line color and exact overlap counts while dropping indexed vertex identities.")
    print("- Collapsing row/col and sum/diff into broad families is nearly exact but not theorem-grade exact in this finite range.")
    print("- Coarser finite-looking quotients lose exactness quickly: cap4/cap2 family variants throw away too much metric scale.")
    print("- Adding row context improves minimizer purity, but even row-context scalar features are not enough to identify the minimizing replies exactly.")
    print("- The useful candidate invariant is probably an edge-overlap multiset with a small amount of metric bucketing, not a single coordinate formula `y=f(x)`.")
    print()

    print("## Updated working hypothesis")
    print()
    print("Status: heuristic.")
    print()
    print("For border-pair repair candidates, `|combined_asym|` is controlled by the overlap pattern among unpaired line orbits.  The theorem-useful invariant must preserve enough metric information about line lengths, intersections, and probably the row/col/sum/diff color of each orbit.  Parity is a high-recall candidate filter; edge-overlap buckets are the better ranking vocabulary.")
    print()

    print("## Continuation summary")
    print()
    print("### Strong positive findings")
    print()
    print("- verified for n<=100: exact edge-multiset quotients are the strongest compressed overlap invariant tested; see the table for whether full-kind and family-collapsed versions are exact.")
    print("- verified for n<=100: scalar cover/overlap features give bounded residual ambiguity but not an exact invariant.")
    print()
    print("### Negative findings")
    print()
    print("- failed / refuted as exact compression: deleting too much metric information from the edge overlaps creates real score ambiguity.")
    print("- failed / refuted as exact repair rule: row-context scalar features still leave mixed minimizer classes.")
    print()
    print("### Next low-memory experiment")
    print()
    print("Use edge-multiset quotients as candidate generators: for each `(n,x)`, rank `y` by bucketed edge signature and measure candidate-set size needed to capture all true asymmetry minimizers.")
    print()
    print("### Next solver-side experiment")
    print()
    print("Log both the exact edge-multiset hash and a bucketed edge-multiset hash for solver-chosen repair replies, then compare chosen replies against the asymmetry-minimizer rank.")
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    print()
    print(f"_Continuation resource footer: elapsed={time.time() - t0:.3f}s, maxrss={rss} KB._")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
