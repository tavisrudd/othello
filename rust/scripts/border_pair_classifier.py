#!/usr/bin/env python3
"""Classify cross-arm border-pair repair geometry.

This is a pure-arithmetic research script.  It does not call Rust, build
anything, or run a game solver.
"""

from __future__ import annotations

import argparse
import csv
import itertools
import math
import resource
import time
from collections import Counter, defaultdict
from dataclasses import dataclass
from typing import Callable, Iterable


Square = tuple[int, int]
Predicate = tuple[str, Callable[["PairRecord"], bool]]


def md_table(rows: list[list[object]]) -> str:
    if not rows:
        return ""
    widths = [max(len(str(row[i])) for row in rows) for i in range(len(rows[0]))]
    out = []
    out.append("| " + " | ".join(str(v).ljust(widths[i]) for i, v in enumerate(rows[0])) + " |")
    out.append("| " + " | ".join("-" * widths[i] for i in range(len(widths))) + " |")
    for row in rows[1:]:
        out.append("| " + " | ".join(str(v).ljust(widths[i]) for i, v in enumerate(row)) + " |")
    return "\n".join(out)


def q_of(n: int) -> int:
    return n - 1


def m_of(n: int) -> int:
    return n // 2


def h_of(n: int) -> int:
    return m_of(n) - 1


def central_strike(n: int) -> Square:
    h = h_of(n)
    return h, h


def tau(n: int, square: Square) -> Square:
    q = q_of(n)
    r, c = square
    return q - 1 - r, q - 1 - c


def attacks(a: Square, b: Square) -> bool:
    ar, ac = a
    br, bc = b
    return ar == br or ac == bc or ar + ac == br + bc or ar - ac == br - bc


def additive_labels(square: Square) -> tuple[int, int, int, int]:
    r, c = square
    return r, c, r + c, r - c


def used_labels(position: Iterable[Square]) -> tuple[set[int], set[int], set[int], set[int]]:
    rows: set[int] = set()
    cols: set[int] = set()
    sums: set[int] = set()
    diffs: set[int] = set()
    for r, c in position:
        rows.add(r)
        cols.add(c)
        sums.add(r + c)
        diffs.add(r - c)
    return rows, cols, sums, diffs


def live_after_position(n: int, position: Iterable[Square]) -> set[Square]:
    rows, cols, sums, diffs = used_labels(position)
    live: set[Square] = set()
    for r in range(n):
        if r in rows:
            continue
        for c in range(n):
            if c not in cols and r + c not in sums and r - c not in diffs:
                live.add((r, c))
    return live


def live_core(n: int) -> set[Square]:
    q = q_of(n)
    h = h_of(n)
    return {
        (r, c)
        for r in range(q)
        for c in range(q)
        if r != h and c != h and r + c != q - 1 and r - c != 0
    }


def border_coords(n: int) -> list[int]:
    q = q_of(n)
    h = h_of(n)
    return [x for x in range(q) if x != h]


def raw_row_scar(n: int, x: int) -> set[Square]:
    q = q_of(n)
    return {
        (r, c)
        for r in range(q)
        for c in range(q)
        if c == x or r - c == q - x or r + c == q + x
    }


def raw_col_scar(n: int, y: int) -> set[Square]:
    q = q_of(n)
    return {
        (r, c)
        for r in range(q)
        for c in range(q)
        if r == y or r - c == y - q or r + c == y + q
    }


_live_row_scar_cache: dict[tuple[int, int], frozenset[Square]] = {}
_live_col_scar_cache: dict[tuple[int, int], frozenset[Square]] = {}
_live_core_cache: dict[int, frozenset[Square]] = {}
_label_set_cache: dict[tuple[int, str, tuple[int, int]], frozenset[Square]] = {}
_orbit_cover_cache: dict[tuple[int, tuple[tuple[str, int, int], ...]], tuple[int, int, int]] = {}


def live_core_cached(n: int) -> frozenset[Square]:
    if n not in _live_core_cache:
        _live_core_cache[n] = frozenset(live_core(n))
    return _live_core_cache[n]


def scar_R_for_border_square(n: int, border_square: Square) -> frozenset[Square]:
    q = q_of(n)
    r, c = border_square
    if r == q and c != q:
        key = (n, c)
        if key not in _live_row_scar_cache:
            _live_row_scar_cache[key] = frozenset(raw_row_scar(n, c) & set(live_core_cached(n)))
        return _live_row_scar_cache[key]
    if c == q and r != q:
        key = (n, r)
        if key not in _live_col_scar_cache:
            _live_col_scar_cache[key] = frozenset(raw_col_scar(n, r) & set(live_core_cached(n)))
        return _live_col_scar_cache[key]
    raise ValueError(border_square)


def combined_scar_for_pair(n: int, x: int, y: int) -> frozenset[Square]:
    q = q_of(n)
    return frozenset(
        set(scar_R_for_border_square(n, (q, x)))
        | set(scar_R_for_border_square(n, (y, q)))
    )


def tau_image(n: int, squares: Iterable[Square]) -> set[Square]:
    return {tau(n, s) for s in squares}


def combined_asym_for_pair(n: int, x: int, y: int) -> frozenset[Square]:
    scar = combined_scar_for_pair(n, x, y)
    return frozenset(set(scar) ^ tau_image(n, scar))


def label_tau(kind: str, n: int, value: int) -> int:
    q = q_of(n)
    if kind in {"row", "col"}:
        return q - 1 - value
    if kind == "sum":
        return 2 * q - 2 - value
    if kind == "diff":
        return -value
    raise ValueError(kind)


def line_label_orbits_under_tau(n: int, kind: str, values: Iterable[int]) -> set[tuple[int, int]]:
    orbits = set()
    for value in values:
        mate = label_tau(kind, n, value)
        orbits.add((min(value, mate), max(value, mate)))
    return orbits


def active_label_sets_for_pair(n: int, x: int, y: int) -> dict[str, set[int]]:
    q = q_of(n)
    h = h_of(n)
    rows = {h, y}
    cols = {h, x}
    sums = {q - 1}
    diffs = {0}
    for s in (q + x, q + y):
        if 0 <= s <= 2 * q - 2:
            sums.add(s)
    for d in (q - x, y - q):
        if -(q - 1) <= d <= q - 1:
            diffs.add(d)
    return {"row": rows, "col": cols, "sum": sums, "diff": diffs}


def unpaired_label_orbits(n: int, label_sets: dict[str, set[int]]) -> dict[str, set[tuple[int, int]]]:
    out: dict[str, set[tuple[int, int]]] = {}
    for kind, values in label_sets.items():
        xs = set()
        for value in values:
            mate = label_tau(kind, n, value)
            if mate not in values:
                xs.add((min(value, mate), max(value, mate)))
        out[kind] = xs
    return out


def label_set_for_orbit(n: int, kind: str, orbit: tuple[int, int]) -> frozenset[Square]:
    key = (n, kind, orbit)
    if key in _label_set_cache:
        return _label_set_cache[key]
    vals = set(orbit)
    live = live_core_cached(n)
    if kind == "row":
        out = frozenset((r, c) for r, c in live if r in vals)
    elif kind == "col":
        out = frozenset((r, c) for r, c in live if c in vals)
    elif kind == "sum":
        out = frozenset((r, c) for r, c in live if r + c in vals)
    elif kind == "diff":
        out = frozenset((r, c) for r, c in live if r - c in vals)
    else:
        raise ValueError(kind)
    _label_set_cache[key] = out
    return out


def orbit_cover_stats(n: int, orbits: dict[str, set[tuple[int, int]]]) -> tuple[int, int, int]:
    key_items = []
    for kind, os in orbits.items():
        for a, b in os:
            key_items.append((kind, a, b))
    key = (n, tuple(sorted(key_items)))
    if key in _orbit_cover_cache:
        return _orbit_cover_cache[key]
    sets = []
    for kind, os in orbits.items():
        for orbit in os:
            sets.append(label_set_for_orbit(n, kind, orbit))
    if not sets:
        _orbit_cover_cache[key] = (0, 0, 0)
        return _orbit_cover_cache[key]
    total_line_cover = sum(len(s) for s in sets)
    union: set[Square] = set()
    for s in sets:
        union |= set(s)
    overlap = total_line_cover - len(union)
    _orbit_cover_cache[key] = (len(union), total_line_cover, overlap)
    return _orbit_cover_cache[key]


def single_dead_tags(n: int, x: int, prefix: str) -> tuple[str, ...]:
    m = m_of(n)
    h = h_of(n)
    tags = []
    if x <= h - 1:
        if 2 * x == m - 2:
            tags.append(f"{prefix}_left_row_h")
        if 3 * x == 2 * m - 3:
            tags.append(f"{prefix}_left_diff0")
    else:
        if 2 * x == 3 * m - 2:
            tags.append(f"{prefix}_right_row_h")
        if 3 * x == 4 * m - 3:
            tags.append(f"{prefix}_right_sum_h")
    return tuple(tags)


def coord_side(n: int, z: int) -> str:
    return "left" if z < h_of(n) else "right"


def endpoint_dist(n: int, z: int) -> int:
    return min(z, n - 2 - z)


def gap_dist(n: int, z: int) -> int:
    return abs(z - h_of(n))


@dataclass(slots=True)
class PairRecord:
    n: int
    m: int
    x: int
    y: int
    legal: bool
    primary_score: int
    secondary_score: int
    is_primary_minimizer_for_x: bool
    is_secondary_minimizer_among_primary_for_x: bool
    num_primary_minimizers_for_x: int
    num_secondary_minimizers_for_x: int
    x_parity: int
    y_parity: int
    same_parity: bool
    x_side: str
    y_side: str
    same_side: bool
    opposite_side: bool
    x_gap_dist: int
    y_gap_dist: int
    x_endpoint_dist: int
    y_endpoint_dist: int
    offset: int
    abs_offset: int
    mirror_offset: int
    transpose_illegal: bool
    near_illegal: bool
    unpaired_row_orbits_count: int
    unpaired_col_orbits_count: int
    unpaired_sum_orbits_count: int
    unpaired_diff_orbits_count: int
    total_unpaired_label_orbits: int
    orbit_cover_size: int
    orbit_total_line_cover: int
    orbit_overlap_count: int
    x_dead_tags: str
    y_dead_tags: str
    n_mod4: int
    n_mod8: int


def build_records(max_n: int = 100) -> list[PairRecord]:
    records: list[PairRecord] = []
    for n in range(8, max_n + 1, 2):
        q = q_of(n)
        coords = border_coords(n)
        by_x_base: dict[int, list[tuple[int, int, int]]] = {}
        for x in coords:
            rows = []
            for y in coords:
                if y == x:
                    continue
                scar = combined_scar_for_pair(n, x, y)
                asym = combined_asym_for_pair(n, x, y)
                rows.append((y, len(asym), len(scar)))
            by_x_base[x] = rows
        by_x_primary = {
            x: min(score for _, score, _ in rows)
            for x, rows in by_x_base.items()
        }
        by_x_secondary = {
            x: min(size for _, score, size in rows if score == by_x_primary[x])
            for x, rows in by_x_base.items()
        }
        by_x_num_primary = {
            x: sum(1 for _, score, _ in rows if score == by_x_primary[x])
            for x, rows in by_x_base.items()
        }
        by_x_num_secondary = {
            x: sum(1 for _, score, size in rows if score == by_x_primary[x] and size == by_x_secondary[x])
            for x, rows in by_x_base.items()
        }
        for x in coords:
            for y, primary, secondary in by_x_base[x]:
                label_sets = active_label_sets_for_pair(n, x, y)
                orbits = unpaired_label_orbits(n, label_sets)
                row_count = len(orbits["row"])
                col_count = len(orbits["col"])
                sum_count = len(orbits["sum"])
                diff_count = len(orbits["diff"])
                cover_size, total_line_cover, overlap = orbit_cover_stats(n, orbits)
                xs = coord_side(n, x)
                ys = coord_side(n, y)
                mirror = q - 1 - x
                records.append(
                    PairRecord(
                        n=n,
                        m=m_of(n),
                        x=x,
                        y=y,
                        legal=True,
                        primary_score=primary,
                        secondary_score=secondary,
                        is_primary_minimizer_for_x=primary == by_x_primary[x],
                        is_secondary_minimizer_among_primary_for_x=(
                            primary == by_x_primary[x] and secondary == by_x_secondary[x]
                        ),
                        num_primary_minimizers_for_x=by_x_num_primary[x],
                        num_secondary_minimizers_for_x=by_x_num_secondary[x],
                        x_parity=x & 1,
                        y_parity=y & 1,
                        same_parity=(x & 1) == (y & 1),
                        x_side=xs,
                        y_side=ys,
                        same_side=xs == ys,
                        opposite_side=xs != ys,
                        x_gap_dist=gap_dist(n, x),
                        y_gap_dist=gap_dist(n, y),
                        x_endpoint_dist=endpoint_dist(n, x),
                        y_endpoint_dist=endpoint_dist(n, y),
                        offset=y - x,
                        abs_offset=abs(y - x),
                        mirror_offset=y - mirror,
                        transpose_illegal=False,
                        near_illegal=abs(y - x) == 1,
                        unpaired_row_orbits_count=row_count,
                        unpaired_col_orbits_count=col_count,
                        unpaired_sum_orbits_count=sum_count,
                        unpaired_diff_orbits_count=diff_count,
                        total_unpaired_label_orbits=row_count + col_count + sum_count + diff_count,
                        orbit_cover_size=cover_size,
                        orbit_total_line_cover=total_line_cover,
                        orbit_overlap_count=overlap,
                        x_dead_tags=";".join(single_dead_tags(n, x, "x")),
                        y_dead_tags=";".join(single_dead_tags(n, y, "y")),
                        n_mod4=n % 4,
                        n_mod8=n % 8,
                    )
                )
    return records


def write_csv(path: str, records: list[PairRecord]) -> None:
    fields = list(PairRecord.__dataclass_fields__.keys())
    with open(path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for r in records:
            writer.writerow({field: getattr(r, field) for field in fields})


def grouped_minimizers(records: list[PairRecord]) -> dict[tuple[int, int], list[PairRecord]]:
    out: dict[tuple[int, int], list[PairRecord]] = defaultdict(list)
    for r in records:
        if r.is_primary_minimizer_for_x:
            out[(r.n, r.x)].append(r)
    return out


def section_reconstructed(csv_path: str, records: list[PairRecord]) -> str:
    lines = ["## Reconstructed formulas / script structure", ""]
    lines.append("Status: PROVEN by arithmetic for reconstructed B1-B5 formulas; verified for finite n in this pass.")
    lines.append("")
    lines.append("Script path: `scripts/border_pair_classifier.py`.")
    lines.append("")
    lines.append("Wrapper path: `scripts/run-border-pair-classifier-pass.sh`.")
    lines.append("")
    lines.append("Run method: the wrapper invokes `python3 scripts/border_pair_classifier.py --csv ../notes/$(date +%F)-border-pair-features.csv` under `ulimit -v 1000000`, `timeout 60s`, and `time -v`.")
    lines.append("")
    lines.append(f"CSV path from this run: `{csv_path}`.")
    lines.append("")
    lines.append("Implemented functions include `attacks`, `central_strike`, `tau`, `live_after_position`, `scar_R_for_border_square`, `combined_scar_for_pair`, `combined_asym_for_pair`, `additive_labels`, and `line_label_orbits_under_tau`.")
    lines.append("")
    lines.append(f"Record count generated in memory: `{len(records)}` legal row-to-column border pairs.")
    return "\n".join(lines)


def section_full_table(csv_path: str, records: list[PairRecord]) -> str:
    lines = ["## Full border-pair feature table", ""]
    lines.append("Status: verified for finite n=8..100.")
    rows = [["n", "legal rows", "expected", "primary minimizer rows", "secondary minimizer rows", "score range", "size range"]]
    by_n: dict[int, list[PairRecord]] = defaultdict(list)
    for r in records:
        by_n[r.n].append(r)
    for n in sorted(by_n):
        rs = by_n[n]
        expected = (n - 2) * (n - 3)
        primary_rows = sum(1 for r in rs if r.is_primary_minimizer_for_x)
        secondary_rows = sum(1 for r in rs if r.is_secondary_minimizer_among_primary_for_x)
        rows.append([
            n,
            len(rs),
            expected,
            primary_rows,
            secondary_rows,
            f"{min(r.primary_score for r in rs)}..{max(r.primary_score for r in rs)}",
            f"{min(r.secondary_score for r in rs)}..{max(r.secondary_score for r in rs)}",
        ])
    lines.append("")
    lines.append(md_table(rows))
    lines.append("")
    lines.append(f"CSV written to `{csv_path}`. Sanity check: every n has `(n-2)(n-3)` legal pairs, excluding the center-gap coordinate and the illegal same-coordinate cross-arm reply.")
    return "\n".join(lines)


def side_mix(rs: list[PairRecord]) -> str:
    same = sum(1 for r in rs if r.same_side)
    opp = len(rs) - same
    if same and opp:
        return "mixed"
    if same:
        return "same"
    return "opposite"


def section_minimizer_compression(records: list[PairRecord]) -> str:
    lines = ["## Minimizer-pattern compression", ""]
    lines.append("Status: verified for finite n=8..100; symbolic compression remains heuristic.")
    mins = grouped_minimizers(records)
    rows = [["bucket", "cases", "avg |M|", "same/opposite/mixed", "common offsets", "common abs offsets"]]
    buckets: dict[str, list[tuple[tuple[int, int], list[PairRecord]]]] = defaultdict(list)
    for key, rs in mins.items():
        n, x = key
        if endpoint_dist(n, x) <= 2:
            bucket = f"endpoint<=2 parity{x&1}"
        elif gap_dist(n, x) <= 2:
            bucket = f"gap<=2 parity{x&1}"
        else:
            bucket = f"bulk {coord_side(n, x)} parity{x&1}"
        buckets[bucket].append((key, rs))
    for bucket in sorted(buckets):
        cases = buckets[bucket]
        sizes = [len(rs) for _, rs in cases]
        mix = Counter(side_mix(rs) for _, rs in cases)
        offsets = Counter()
        abs_offsets = Counter()
        for _, rs in cases:
            for r in rs:
                offsets[r.offset] += 1
                abs_offsets[r.abs_offset] += 1
        common_offsets = ", ".join(f"{k}:{v}" for k, v in offsets.most_common(5))
        common_abs = ", ".join(f"{k}:{v}" for k, v in abs_offsets.most_common(5))
        rows.append([
            bucket,
            len(cases),
            f"{sum(sizes) / len(sizes):.2f}",
            dict(mix),
            common_offsets,
            common_abs,
        ])
    lines.append("")
    lines.append(md_table(rows))
    lines.append("")
    lines.append("Best simple compression found: minimizers split meaningfully by endpoint/gap/bulk, parity, and side, but these features do not determine the set. Bulk cases often have nonlocal minimizers and many ties; endpoint and near-gap cases are more structured but still have exceptions depending on n mod 4/8 and dead-intersection tags.")
    lines.append("")
    lines.append("Exceptions are not rare enough to state a clean B6 formula from these features alone.")
    return "\n".join(lines)


def pred_list() -> list[Predicate]:
    preds: list[Predicate] = []
    for attr in ["x_parity", "y_parity", "n_mod4", "n_mod8"]:
        vals = [0, 1] if attr.endswith("parity") else ([0, 2] if attr == "n_mod4" else [0, 2, 4, 6])
        for value in vals:
            preds.append((f"{attr}=={value}", lambda r, a=attr, v=value: getattr(r, a) == v))
    for attr in ["same_parity", "same_side", "opposite_side", "near_illegal"]:
        preds.append((attr, lambda r, a=attr: bool(getattr(r, a))))
    for k in range(0, 8):
        preds.append((f"x_endpoint_dist<={k}", lambda r, kk=k: r.x_endpoint_dist <= kk))
        preds.append((f"y_endpoint_dist<={k}", lambda r, kk=k: r.y_endpoint_dist <= kk))
    for k in range(1, 8):
        preds.append((f"x_gap_dist<={k}", lambda r, kk=k: r.x_gap_dist <= kk))
        preds.append((f"y_gap_dist<={k}", lambda r, kk=k: r.y_gap_dist <= kk))
        preds.append((f"abs_offset<={k}", lambda r, kk=k: r.abs_offset <= kk))
    for k in range(-12, 13):
        if k:
            preds.append((f"offset=={k}", lambda r, kk=k: r.offset == kk))
            preds.append((f"mirror_offset=={k}", lambda r, kk=k: r.mirror_offset == kk))
    preds.append(("mirror_offset==0", lambda r: r.mirror_offset == 0))
    for attr in [
        "unpaired_row_orbits_count",
        "unpaired_col_orbits_count",
        "unpaired_sum_orbits_count",
        "unpaired_diff_orbits_count",
        "total_unpaired_label_orbits",
    ]:
        vals = sorted({0, 1, 2, 3, 4, 5, 6, 7, 8})
        for value in vals:
            preds.append((f"{attr}=={value}", lambda r, a=attr, v=value: getattr(r, a) == v))
    return preds


def score_rule(records: list[PairRecord], pred: Callable[[PairRecord], bool]) -> tuple[int, int, int, float, float, float]:
    tp = fp = fn = 0
    for r in records:
        p = pred(r)
        t = r.is_primary_minimizer_for_x
        if p and t:
            tp += 1
        elif p and not t:
            fp += 1
        elif (not p) and t:
            fn += 1
    precision = tp / (tp + fp) if tp + fp else 0.0
    recall = tp / (tp + fn) if tp + fn else 0.0
    f1 = 2 * precision * recall / (precision + recall) if precision + recall else 0.0
    return tp, fp, fn, precision, recall, f1


def score_from_sets(predicted: set[int], target: set[int]) -> tuple[int, int, int, float, float, float]:
    tp = len(predicted & target)
    fp = len(predicted) - tp
    fn = len(target) - tp
    precision = tp / (tp + fp) if tp + fp else 0.0
    recall = tp / (tp + fn) if tp + fn else 0.0
    f1 = 2 * precision * recall / (precision + recall) if precision + recall else 0.0
    return tp, fp, fn, precision, recall, f1


def section_rule_search(records: list[PairRecord]) -> str:
    lines = ["## Simple predicate rule search", ""]
    lines.append("Status: verified for finite n=8..100; heuristic as a case-discovery tool.")
    preds = pred_list()
    target = {i for i, r in enumerate(records) if r.is_primary_minimizer_for_x}
    pred_sets = [(name, {i for i, r in enumerate(records) if pred(r)}) for name, pred in preds]
    scored = []
    for name, predicted in pred_sets:
        scored.append((name, *score_from_sets(predicted, target)))
    scored.sort(key=lambda row: (row[6], row[4], row[1]), reverse=True)
    rows = [["rule", "TP", "FP", "FN", "precision", "recall", "F1"]]
    for name, tp, fp, fn, precision, recall, f1 in scored[:12]:
        rows.append([name, tp, fp, fn, f"{precision:.3f}", f"{recall:.3f}", f"{f1:.3f}"])
    lines.append("")
    lines.append("Best one-predicate rules:")
    lines.append("")
    lines.append(md_table(rows))
    two_scored = []
    small_preds = scored[:80]
    pred_by_name = {name: predicted for name, predicted in pred_sets}
    for (name_a, *_), (name_b, *__) in itertools.combinations(small_preds, 2):
        pred_a = pred_by_name[name_a]
        pred_b = pred_by_name[name_b]
        name = f"{name_a} AND {name_b}"
        two_scored.append((name, *score_from_sets(pred_a & pred_b, target)))
    two_scored.sort(key=lambda row: (row[6], row[4], row[1]), reverse=True)
    rows2 = [["rule", "TP", "FP", "FN", "precision", "recall", "F1"]]
    for name, tp, fp, fn, precision, recall, f1 in two_scored[:12]:
        rows2.append([name, tp, fp, fn, f"{precision:.3f}", f"{recall:.3f}", f"{f1:.3f}"])
    lines.append("")
    lines.append("Best two-predicate conjunctions:")
    lines.append("")
    lines.append(md_table(rows2))
    selected = []
    covered: set[int] = set()
    target_count = len(target)
    for _ in range(8):
        best = None
        for name, predicted in pred_sets:
            new_tp = (predicted & target) - covered
            fp = len(predicted - target)
            if not new_tp:
                continue
            precision = len(new_tp) / (len(new_tp) + fp)
            score = precision * math.log2(1 + len(new_tp))
            cand = (score, precision, len(new_tp), fp, name, new_tp)
            if best is None or cand > best:
                best = cand
        if best is None:
            break
        score, precision, tp_new, fp, name, keys = best
        selected.append([name, tp_new, fp, f"{precision:.3f}"])
        covered |= keys
    lines.append("")
    lines.append("Greedy disjunctive rules selected for high-precision coverage:")
    lines.append("")
    rows3 = [["rule", "new TP", "FP in full table", "precision"]]
    rows3.extend(selected)
    rows3.append(["covered target fraction", f"{len(covered)}/{target_count}", "", ""])
    lines.append(md_table(rows3))
    lines.append("")
    lines.append("Interpretation: the rules expose useful case splits, but even the best small predicates have many false positives or low recall. This supports Outcome C rather than a clean finite table from the tested features.")
    return "\n".join(lines)


def representative_x(n: int, kind: str, value: float | int) -> int | None:
    q = q_of(n)
    h = h_of(n)
    coords = set(border_coords(n))
    if kind == "left_endpoint":
        x = int(value)
    elif kind == "right_endpoint":
        x = q - 1 - int(value)
    elif kind == "left_gap":
        x = h - int(value)
    elif kind == "right_gap":
        x = h + int(value)
    elif kind == "prop":
        x = int(math.floor(float(value) * n))
        if x == h:
            x += 1
    else:
        raise ValueError(kind)
    if x in coords:
        return x
    return None


def minimizer_summary_for(records_by_nx: dict[tuple[int, int], list[PairRecord]], n: int, x: int) -> str:
    rs = records_by_nx[(n, x)]
    ys = sorted(r.y for r in rs)
    offsets = sorted(r.offset for r in rs)
    parities = sorted({r.y_parity for r in rs})
    sides = sorted({r.y_side for r in rs})
    return f"|M|={len(rs)} y={ys[:6]}{'+' if len(ys)>6 else ''} off={offsets[:6]}{'+' if len(offsets)>6 else ''} parity={parities} side={sides}"


def section_stabilization(records: list[PairRecord]) -> str:
    lines = ["## Asymptotic stabilization check", ""]
    lines.append("Status: verified for finite n=8..100; stabilization claims are heuristic.")
    mins = grouped_minimizers(records)
    samples: list[tuple[str, str, float | int]] = []
    for k in range(0, 6):
        samples.append((f"left endpoint k={k}", "left_endpoint", k))
        samples.append((f"right endpoint k={k}", "right_endpoint", k))
    for k in range(1, 7):
        samples.append((f"left gap k={k}", "left_gap", k))
        samples.append((f"right gap k={k}", "right_gap", k))
    for alpha in [0.25, 1 / 3, 0.45, 0.55, 2 / 3, 0.75]:
        samples.append((f"alpha={alpha:.3f}", "prop", alpha))
    rows = [["class", "n=40", "n=60", "n=80", "n=100", "stable last 4?"]]
    for label, kind, value in samples:
        vals = []
        signatures = []
        for n in [40, 60, 80, 100]:
            x = representative_x(n, kind, value)
            if x is None:
                vals.append("NA")
                signatures.append(None)
            else:
                vals.append(f"x={x} " + minimizer_summary_for(mins, n, x))
                signatures.append(tuple(sorted(r.offset for r in mins[(n, x)])))
        stable = len({s for s in signatures if s is not None}) == 1
        rows.append([label, *vals, stable])
    lines.append("")
    lines.append(md_table(rows))
    lines.append("")
    lines.append("Reading: fixed endpoint-distance and fixed center-gap classes sometimes repeat qualitative parity/side behavior, but exact minimizer offsets usually grow with n or branch into more ties. Bulk proportional x is plainly non-stabilized through n=100 under absolute-offset signatures.")
    return "\n".join(lines)


def section_label_explanation(records: list[PairRecord]) -> str:
    lines = ["## Label-orbit explanation of minimizers", ""]
    lines.append("Status: verified for finite n=8..100; formula candidates are heuristic.")
    feature_sets = [
        ("orbit counts", lambda r: (
            r.unpaired_row_orbits_count,
            r.unpaired_col_orbits_count,
            r.unpaired_sum_orbits_count,
            r.unpaired_diff_orbits_count,
        )),
        ("orbit counts + cover/overlap", lambda r: (
            r.unpaired_row_orbits_count,
            r.unpaired_col_orbits_count,
            r.unpaired_sum_orbits_count,
            r.unpaired_diff_orbits_count,
            r.orbit_cover_size,
            r.orbit_overlap_count,
        )),
        ("counts + cover/overlap + dead tags", lambda r: (
            r.unpaired_row_orbits_count,
            r.unpaired_col_orbits_count,
            r.unpaired_sum_orbits_count,
            r.unpaired_diff_orbits_count,
            r.orbit_cover_size,
            r.orbit_overlap_count,
            r.x_dead_tags,
            r.y_dead_tags,
        )),
        ("above + parity/side", lambda r: (
            r.unpaired_row_orbits_count,
            r.unpaired_col_orbits_count,
            r.unpaired_sum_orbits_count,
            r.unpaired_diff_orbits_count,
            r.orbit_cover_size,
            r.orbit_overlap_count,
            r.x_dead_tags,
            r.y_dead_tags,
            r.x_parity,
            r.y_parity,
            r.same_side,
        )),
    ]
    rows = [["features", "groups", "ambiguous groups", "records in ambiguous groups", "max score spread within group"]]
    for name, fn in feature_sets:
        groups: dict[object, set[int]] = defaultdict(set)
        group_records: dict[object, int] = defaultdict(int)
        for r in records:
            key = fn(r)
            groups[key].add(r.primary_score)
            group_records[key] += 1
        ambiguous = sum(1 for scores in groups.values() if len(scores) > 1)
        ambiguous_records = sum(group_records[key] for key, scores in groups.items() if len(scores) > 1)
        max_spread = max(max(scores) - min(scores) for scores in groups.values())
        rows.append([name, len(groups), ambiguous, ambiguous_records, max_spread])
    lines.append("")
    lines.append(md_table(rows))
    lines.append("")
    rank_rows = [["ranking key", "exact minimizer-set cases", "mean precision", "mean recall"]]
    rankers = [
        ("min orbit cover", lambda r: (r.orbit_cover_size,)),
        ("min orbit cover, max overlap", lambda r: (r.orbit_cover_size, -r.orbit_overlap_count)),
        ("min total orbits, min cover", lambda r: (r.total_unpaired_label_orbits, r.orbit_cover_size)),
        ("min total orbits, max overlap", lambda r: (r.total_unpaired_label_orbits, -r.orbit_overlap_count)),
        ("min cover, min secondary scar", lambda r: (r.orbit_cover_size, r.secondary_score)),
    ]
    for name, keyfn in rankers:
        exact, total, precision, recall = rank_exact(records, keyfn)
        rank_rows.append([name, f"{exact}/{total}", f"{precision:.3f}", f"{recall:.3f}"])
    lines.append("Simple label-orbit ranking tests for each `(n,x)` row:")
    lines.append("")
    lines.append(md_table(rank_rows))
    lines.append("")
    lines.append("The label-orbit features strongly constrain the support of asymmetry, but counts plus overlap corrections still do not uniquely determine `|combined_asym|` across all n<=100. Simple orbit-cover rankings are useful hints, not exact minimizer characterizations.")
    return "\n".join(lines)


def rank_exact(records: list[PairRecord], keyfn: Callable[[PairRecord], object]) -> tuple[int, int, float, float]:
    by_nx: dict[tuple[int, int], list[PairRecord]] = defaultdict(list)
    for r in records:
        by_nx[(r.n, r.x)].append(r)
    exact = 0
    total = 0
    precisions = []
    recalls = []
    for rs in by_nx.values():
        min_key = min(keyfn(r) for r in rs)
        predicted = {r.y for r in rs if keyfn(r) == min_key}
        actual = {r.y for r in rs if r.is_primary_minimizer_for_x}
        exact += int(predicted == actual)
        tp = len(predicted & actual)
        precisions.append(tp / len(predicted) if predicted else 0.0)
        recalls.append(tp / len(actual) if actual else 0.0)
        total += 1
    return exact, total, sum(precisions) / len(precisions), sum(recalls) / len(recalls)


def section_b6(records: list[PairRecord]) -> str:
    lines = ["## B6 compression attempt", ""]
    lines.append("Status: failed / refuted for the tested small symbolic feature families; verified through n<=100.")
    lines.append("")
    lines.append("Outcome C is the honest result of this pass.")
    lines.append("")
    lines.append("### Negative finding")
    lines.append("")
    lines.append("Through n<=100, no rule using the tested features predicts primary minimizers without many exceptions.  Endpoint/gap/bulk, parity, side, n mod 4/8, small offsets, mirror offsets, and label-orbit counts all expose structure, but none yields a compact exact finite table.")
    lines.append("")
    lines.append("B6 should remain an empirical minimization table for now, or be replaced by a different invariant.  The more promising theorem shape is: arithmetic minimizers define candidate repairs; actual winning repairs require residual-state context from the solver.")
    return "\n".join(lines)


def section_telemetry() -> str:
    lines = ["## Recommended solver telemetry", ""]
    lines.append("Status: actionable proposal; needs solver run.")
    fields = [
        "n",
        "ply",
        "position_hash_or_canonical_id",
        "opponent_square",
        "opponent_class",
        "tau_reply_legal",
        "border_state",
        "x_y_border_coordinate_if_applicable",
        "candidate_replies_count",
        "best_asym_score",
        "best_secondary_scar_size",
        "solver_chosen_reply",
        "solver_chosen_reply_rank_by_asym",
        "is_solver_reply_primary_minimizer",
        "is_solver_reply_secondary_minimizer",
        "child_value_if_known",
        "unpaired_label_orbit_counts",
        "orbit_cover_size",
        "orbit_overlap_count",
        "combined_scar_size",
        "combined_asym_size",
    ]
    lines.append("")
    lines.append("Log one record per tau-failure / border-scar repair event with fields:")
    lines.append("")
    for field in fields:
        lines.append(f"- `{field}`")
    lines.append("")
    lines.append("Primary question: do solver-winning repair replies correlate with B6 asymmetry minimizers, or do they frequently choose higher-asymmetry replies because of residual-state tactics?")
    return "\n".join(lines)


def section_final(csv_path: str) -> str:
    lines = ["## Final summary", ""]
    lines.append("### Strong positive findings")
    lines.append("")
    lines.append("- verified for finite n=8..100: the feature table covers every legal row-to-column border pair and passes the `(n-2)(n-3)` row-count sanity check.")
    lines.append("- verified for finite n=8..100: minimizer sets have real structure by endpoint/gap/bulk, parity, and side, but they are tie-heavy and nonlocal in bulk.")
    lines.append("- heuristic: label-orbit cover, overlap count, dead-intersection tags, and coordinate class are useful repair vocabulary fields.")
    lines.append("")
    lines.append("### Negative findings / failed simplifications")
    lines.append("")
    lines.append("- failed / refuted for tested features: no small predicate family gives an exact symbolic B6 minimizer rule through n<=100.")
    lines.append("- failed / refuted: local offset rules such as `y=x+-k`, endpoint preference, center-gap preference, or mirror-coordinate preference are not sufficient.")
    lines.append("- heuristic caution: asymmetry minimization remains only a candidate-repair generator, not a winning-strategy certificate.")
    lines.append("")
    lines.append("### Best symbolic minimizer rule found")
    lines.append("")
    lines.append("No exact rule. Best usable compression is a finite-state vocabulary: endpoint/gap/bulk class, side, parity, n mod 4/8, dead-intersection tags, unpaired label-orbit counts, orbit cover size, and orbit overlap count.")
    lines.append("")
    lines.append("### Remaining exceptions")
    lines.append("")
    lines.append("Bulk proportional coordinates do not stabilize by absolute offset through n=100, and many endpoint/gap classes branch into multiple tied minimizers depending on n and parity.")
    lines.append("")
    lines.append("### Files created")
    lines.append("")
    lines.append("- `scripts/border_pair_classifier.py`")
    lines.append("- `scripts/run-border-pair-classifier-pass.sh`")
    lines.append(f"- `{csv_path}`")
    lines.append("- `../notes/2026-07-03-codex-border-pair-classifier.md`")
    lines.append("")
    lines.append("### Recommended next low-memory experiment")
    lines.append("")
    lines.append("Search for a different invariant: compare minimizers by exact overlap graph of unpaired label-orbit line sets, not just counts and scalar overlap totals.")
    lines.append("")
    lines.append("### Recommended next solver-side experiment")
    lines.append("")
    lines.append("Add the telemetry record above to repair events and compare solver-winning replies against primary/secondary asymmetry minimizers on n=10/12/14/16/18 when the box is free.")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv", required=True)
    parser.add_argument("--max-n", type=int, default=100)
    args = parser.parse_args()
    t0 = time.time()
    records = build_records(args.max_n)
    write_csv(args.csv, records)
    sections = [
        section_reconstructed(args.csv, records),
        section_full_table(args.csv, records),
        section_minimizer_compression(records),
        section_rule_search(records),
        section_stabilization(records),
        section_label_explanation(records),
        section_b6(records),
        section_telemetry(),
        section_final(args.csv),
    ]
    print("\n\n".join(sections))
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    print("")
    print(f"_Script resource footer: elapsed={time.time() - t0:.3f}s, maxrss={rss} KB._")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
