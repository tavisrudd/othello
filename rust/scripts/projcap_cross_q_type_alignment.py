#!/usr/bin/env python3
"""Cross-q type/value alignment for ProjectiveCap S4 mining logs.

This consumes `s4mine --depth 2 --state-rows` logs and checks two signatures:

* a coarse geometric shape signature from conic-defect and zone-proxy fields;
* a strict normalized-coordinate signature that refines the coarse shape by the
  selected cells, writing conic cells as parameter tokens C<t>.

The strict signature is deliberately not the solver's canonical key.  It is a
reproducible, q-independent query signature over the normalized S4 chart.
"""

from __future__ import annotations

import argparse
import csv
import re
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


KV_RE = re.compile(r"([A-Za-z0-9_]+)=([^ \t]+)")
CELL_RE = re.compile(r"cells=([^=]+?) legal=")


@dataclass(frozen=True)
class Row:
    q: int
    source: str
    t4: str
    ply: int
    value: str
    cells: tuple[tuple[int, int], ...]
    cellsig: str
    kv: dict[str, str]


def parse_kv(line: str) -> dict[str, str]:
    return {m.group(1): m.group(2) for m in KV_RE.finditer(line)}


def parse_cells(line: str) -> tuple[tuple[int, int], ...]:
    m = CELL_RE.search(line)
    if not m:
        raise ValueError(f"STATE row has no cells field: {line[:120]}")
    cells = []
    for part in m.group(1).strip().split():
        r, c = part.split(",", 1)
        cells.append((int(r), int(c)))
    return tuple(cells)


def cell_signature(q: int, cells: Iterable[tuple[int, int]]) -> str:
    tokens: list[tuple[str, int, int | None]] = []
    for r, c in cells:
        if (r * c) % q == 1:
            tokens.append(("C", r, None))
        else:
            tokens.append(("O", r, c))
    tokens.sort()
    out = []
    for kind, a, b in tokens:
        if kind == "C":
            out.append(f"C{a}")
        else:
            out.append(f"O{a}:{b}")
    return ",".join(out)


def read_rows(log_dir: Path) -> list[Row]:
    rows: list[Row] = []
    for path in sorted(log_dir.glob("*.depth2.out")):
        q: int | None = None
        t4 = ""
        for line in path.read_text().splitlines():
            if line.startswith("S4MINE "):
                kv = parse_kv(line)
                q = int(kv["q"])
                tm = re.search(r"t4=\[([^\]]+)\]", line)
                if tm:
                    t4 = tm.group(1).replace(" ", "")
                continue
            if not line.startswith("STATE "):
                continue
            if q is None:
                raise ValueError(f"STATE before S4MINE header in {path}")
            kv = parse_kv(line)
            value = kv.get("value", "")
            if value not in {"P", "N"}:
                continue
            ply = int(kv["ply"])
            if ply not in {5, 6}:
                continue
            cells = parse_cells(line)
            rows.append(
                Row(
                    q=q,
                    source=path.name,
                    t4=t4,
                    ply=ply,
                    value=value,
                    cells=cells,
                    cellsig=cell_signature(q, cells),
                    kv=kv,
                )
            )
    return rows


def parse_size_text(text: str) -> tuple[int, ...]:
    if not text or text == "-":
        return ()
    return tuple(int(x) for x in text.split(",") if x)


def bucket_sizes(sizes: Iterable[int], small: int = 6) -> str:
    parts = []
    for n in sorted(sizes):
        if n <= small:
            parts.append(str(n))
        else:
            parts.append("Lodd" if n % 2 else "Leven")
    return ",".join(parts) if parts else "-"


def bucket_counter(values: Iterable[int], small: int = 6) -> str:
    counts = Counter("L" if x > small else str(x) for x in values)
    return ",".join(f"{k}:{counts[k]}" for k in sorted(counts, key=lambda x: (x == "L", x)))


def det0(a: tuple[int, int], b: tuple[int, int], c: tuple[int, int], q: int) -> bool:
    return ((b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])) % q == 0


def legal_cells(q: int, cells: tuple[tuple[int, int], ...]) -> list[tuple[int, int]]:
    chosen = set(cells)
    rows = {r for r, _ in cells}
    cols = {c for _, c in cells}
    pairs = [(cells[i], cells[j]) for i in range(len(cells)) for j in range(i + 1, len(cells))]
    legal = []
    for r in range(q):
        if r in rows:
            continue
        for c in range(q):
            z = (r, c)
            if c in cols or z in chosen:
                continue
            if any(det0(a, b, z, q) for a, b in pairs):
                continue
            legal.append(z)
    return legal


def zone_signature(row: Row) -> str:
    # Coarse, q-independent proxy: row/column support and bucketed conflict
    # degree histogram over legal off-conic cells.
    zone = [z for z in legal_cells(row.q, row.cells) if (z[0] * z[1]) % row.q != 1]
    row_counts = Counter(r for r, _ in zone)
    col_counts = Counter(c for _, c in zone)
    degrees = [0] * len(zone)
    for i, a in enumerate(zone):
        for j in range(i + 1, len(zone)):
            b = zone[j]
            edge = a[0] == b[0] or a[1] == b[1] or any(det0(x, a, b, row.q) for x in row.cells)
            if edge:
                degrees[i] += 1
                degrees[j] += 1
    degree_buckets = Counter()
    for d in degrees:
        if d <= 2:
            degree_buckets[str(d)] += 1
        elif d <= 4:
            degree_buckets["3-4"] += 1
        elif d <= 8:
            degree_buckets["5-8"] += 1
        elif d <= 16:
            degree_buckets["9-16"] += 1
        else:
            degree_buckets["17+"] += 1
    deg_text = ",".join(f"{k}:{degree_buckets[k]}" for k in ["0", "1", "2", "3-4", "5-8", "9-16", "17+"] if degree_buckets[k])
    return "|".join(
        [
            f"v={len(zone)}",
            f"rows={len(row_counts)}",
            f"cols={len(col_counts)}",
            f"row_sizes={bucket_counter(row_counts.values())}",
            f"col_sizes={bucket_counter(col_counts.values())}",
            f"deg={deg_text or '-'}",
        ]
    )


def conic_defect_signature(row: Row) -> str:
    kv = row.kv
    return "|".join(
        [
            f"off={kv.get('conic_off', '')}",
            f"dead={kv.get('dead_on', '')}",
            f"nk={kv.get('conic_nk_known', '')}:{kv.get('conic_nk_xor', '')}",
            f"path={bucket_sizes(parse_size_text(kv.get('conic_path_sizes', '')))}",
            f"cycle={bucket_sizes(parse_size_text(kv.get('conic_cycle_sizes', '')))}",
            f"other={bucket_sizes(parse_size_text(kv.get('conic_other_sizes', '')))}",
        ]
    )


def group_values(rows: list[Row], key_fn):
    values: dict[tuple[int, tuple[str, ...]], set[str]] = defaultdict(set)
    counts: Counter[tuple[int, tuple[str, ...]]] = Counter()
    examples: dict[tuple[int, tuple[str, ...]], Row] = {}
    for row in rows:
        key = key_fn(row)
        qkey = (row.q, key)
        values[qkey].add(row.value)
        counts[qkey] += 1
        examples.setdefault(qkey, row)
    return values, counts, examples


def collision_rows(values, counts, examples, limit: int) -> list[dict[str, str]]:
    out = []
    for (q, key), vals in values.items():
        if len(vals) <= 1:
            continue
        ex = examples[(q, key)]
        out.append(
            {
                "q": str(q),
                "values": "/".join(sorted(vals)),
                "count": str(counts[(q, key)]),
                "source": ex.source,
                "t4": ex.t4,
                "ply": str(ex.ply),
                "cellsig": ex.cellsig,
                "key": " || ".join(key),
            }
        )
        if len(out) >= limit:
            break
    return out


def alignment(values, counts, examples):
    by_type: dict[tuple[str, ...], dict[int, str]] = defaultdict(dict)
    type_counts: dict[tuple[str, ...], dict[int, int]] = defaultdict(dict)
    type_examples: dict[tuple[str, ...], dict[int, Row]] = defaultdict(dict)
    for (q, key), vals in values.items():
        if len(vals) != 1:
            continue
        by_type[key][q] = next(iter(vals))
        type_counts[key][q] = counts[(q, key)]
        type_examples[key][q] = examples[(q, key)]
    shared = {k: v for k, v in by_type.items() if len(v) >= 2}
    nonconstant = {k: v for k, v in shared.items() if len(set(v.values())) > 1}
    return shared, nonconstant, type_counts, type_examples


def write_tsv(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not rows:
        path.write_text("")
        return
    with path.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(rows[0].keys()), delimiter="\t")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("log_dir", type=Path)
    ap.add_argument("--out-dir", type=Path, default=Path("s4-dumps/2026-07-09/c36-analysis"))
    ap.add_argument("--example-limit", type=int, default=25)
    args = ap.parse_args()

    rows = read_rows(args.log_dir)
    zone_cache: dict[tuple[int, tuple[tuple[int, int], ...]], str] = {}

    def coarse_key(row: Row) -> tuple[str, ...]:
        cache_key = (row.q, row.cells)
        if cache_key not in zone_cache:
            zone_cache[cache_key] = zone_signature(row)
        return (
            f"t4={row.t4}",
            f"ply={row.ply}",
            conic_defect_signature(row),
            zone_cache[cache_key],
        )

    def strict_key(row: Row) -> tuple[str, ...]:
        return (
            f"t4={row.t4}",
            f"ply={row.ply}",
            f"cells={row.cellsig}",
        )

    q_counts = Counter(row.q for row in rows)
    coarse_values, coarse_counts, coarse_examples = group_values(rows, coarse_key)
    strict_values, strict_counts, strict_examples = group_values(rows, strict_key)
    coarse_collisions = [1 for vals in coarse_values.values() if len(vals) > 1]
    strict_collisions = [1 for vals in strict_values.values() if len(vals) > 1]
    shared, nonconstant, type_counts, type_examples = alignment(strict_values, strict_counts, strict_examples)

    nonconstant_rows = []
    for key, vals in sorted(nonconstant.items(), key=lambda kv: (min(kv[1]), kv[0])):
        examples = type_examples[key]
        row = {
            "qs": ",".join(str(q) for q in sorted(vals)),
            "values": ",".join(f"{q}:{vals[q]}" for q in sorted(vals)),
            "counts": ",".join(f"{q}:{type_counts[key][q]}" for q in sorted(vals)),
            "t4": key[0].removeprefix("t4="),
            "ply": key[1].removeprefix("ply="),
            "cellsig": key[2].removeprefix("cells="),
            "sources": ",".join(f"{q}:{examples[q].source}" for q in sorted(vals)),
            "legal": ",".join(f"{q}:{examples[q].kv.get('legal', '')}" for q in sorted(vals)),
            "conic_sizes": ",".join(f"{q}:{examples[q].kv.get('conic_sizes', '')}" for q in sorted(vals)),
        }
        nonconstant_rows.append(row)

    shared_counter = Counter(tuple(sorted(vals)) for vals in shared.values())
    nonconstant_counter = Counter(tuple(sorted(vals)) for vals in nonconstant.values())
    by_ply_value = Counter()
    for key, vals in nonconstant.items():
        by_ply_value[(key[1].removeprefix("ply="), tuple(f"{q}:{vals[q]}" for q in sorted(vals)))] += 1

    args.out_dir.mkdir(parents=True, exist_ok=True)
    write_tsv(args.out_dir / "coarse-collisions.tsv", collision_rows(coarse_values, coarse_counts, coarse_examples, args.example_limit))
    write_tsv(args.out_dir / "nonconstant-strict-types.tsv", nonconstant_rows)

    summary_lines = [
        "# C36 Cross-Q Type Alignment Summary",
        "",
        f"input_log_dir: {args.log_dir}",
        f"known_s5_s6_rows: {len(rows)}",
        "known_rows_by_q: " + ", ".join(f"q={q}:{q_counts[q]}" for q in sorted(q_counts)),
        f"coarse_shape_q_types: {len(coarse_values)}",
        f"coarse_shape_self_consistency_collisions: {sum(coarse_collisions)}",
        f"strict_coordinate_q_types: {len(strict_values)}",
        f"strict_coordinate_self_consistency_collisions: {sum(strict_collisions)}",
        f"strict_shared_types_ge2q: {len(shared)}",
        f"strict_nonconstant_types: {len(nonconstant)}",
        "strict_shared_by_qset: " + ", ".join(f"{'/'.join(map(str, k))}:{v}" for k, v in sorted(shared_counter.items())),
        "strict_nonconstant_by_qset: " + ", ".join(f"{'/'.join(map(str, k))}:{v}" for k, v in sorted(nonconstant_counter.items())),
        "strict_nonconstant_by_ply_values:",
    ]
    for (ply, vals), n in sorted(by_ply_value.items()):
        summary_lines.append(f"  ply={ply} {'/'.join(vals)}: {n}")
    summary_lines += [
        "",
        "First nonconstant strict types:",
    ]
    for row in nonconstant_rows[: args.example_limit]:
        summary_lines.append(
            f"- values={row['values']} t4={row['t4']} ply={row['ply']} cells={row['cellsig']} "
            f"legal={row['legal']} conic_sizes={row['conic_sizes']}"
        )
    (args.out_dir / "summary.md").write_text("\n".join(summary_lines) + "\n")
    print("\n".join(summary_lines))


if __name__ == "__main__":
    main()
