#!/usr/bin/env python3
"""C45 lightweight defect-spectrum validator.

This parses the tracked C20 reply-state rows and checks only the stored
spectral data.  It deliberately does not instantiate the grid solver or run
new game search.
"""

from __future__ import annotations

import argparse
import gzip
import json
from collections import Counter
from pathlib import Path
from typing import Iterable


REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_ROWS = (
    REPO_ROOT / "notes/data/c20-q13-q17-states.jsonl.gz",
    REPO_ROOT / "notes/data/c20-q19-states.jsonl.gz",
)


def mex(values: Iterable[int]) -> int:
    seen = set(values)
    out = 0
    while out in seen:
        out += 1
    return out


def dawson_tables(maxn: int) -> tuple[list[int], list[int]]:
    """Node-Kayles values for paths and cycles up to maxn vertices."""
    gp = [0] * (maxn + 1)
    for n in range(1, maxn + 1):
        opts = set()
        for i in range(n):
            left = max(i - 1, 0)
            right = max(n - (i + 2), 0)
            opts.add(gp[left] ^ gp[right])
        gp[n] = mex(opts)

    gc = [0] * (maxn + 1)
    for n in range(3, maxn + 1):
        gc[n] = mex({gp[n - 3]})
    return gp, gc


def iter_rows(paths: list[Path]):
    for path in paths:
        with gzip.open(path, "rt", encoding="utf-8") as f:
            for line_no, line in enumerate(f, 1):
                if not line.strip():
                    continue
                row = json.loads(line)
                row["_source"] = f"{path}:{line_no}"
                yield row


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", nargs="*", type=Path, default=list(DEFAULT_ROWS))
    parser.add_argument("--max-errors", type=int, default=12)
    args = parser.parse_args()

    max_q = 0
    cached_rows = []
    for row in iter_rows(args.rows):
        cached_rows.append(row)
        max_q = max(max_q, int(row["q"]))
    gp, gc = dawson_tables(2 * max_q + 2)

    rows = Counter()
    wins = Counter()
    orders = Counter()
    components = Counter()
    cycles = Counter()
    failures = Counter()
    examples: list[str] = []

    def fail(kind: str, row: dict, detail: str) -> None:
        failures[kind] += 1
        if len(examples) < args.max_errors:
            examples.append(f"{kind}: {row['_source']}: {detail}; row={row}")

    for row in cached_rows:
        q = int(row["q"])
        y_kind = row["y_kind"]
        rows[(q, y_kind)] += 1
        wins[(q, y_kind, bool(row["winning_reply"]))] += 1
        spectrum = [(str(kind), int(n)) for kind, n in row["spectrum"]]

        recomputed = 0
        for kind, n in spectrum:
            components[(q, y_kind, kind, n)] += 1
            if kind == "path":
                recomputed ^= gp[n]
            elif kind == "cycle":
                recomputed ^= gc[n]
            else:
                fail("bad_component_kind", row, f"component {kind} {n}")

        if recomputed != int(row["defxor"]):
            fail("defxor_mismatch", row, f"stored={row['defxor']} recomputed={recomputed}")

        if y_kind == "conic":
            if row["order"] is not None:
                fail("one_intruder_has_order", row, f"order={row['order']}")
            for kind, n in spectrum:
                if kind != "path" or n not in (1, 2):
                    fail("one_intruder_not_matching_fragment", row, f"{kind} {n}")
            continue

        if y_kind != "intruder":
            fail("unknown_reply_kind", row, y_kind)
            continue

        order = row["order"]
        if not isinstance(order, int):
            fail("missing_order", row, f"order={order!r}")
            continue
        orders[(q, order)] += 1
        if (q - 1) % order != 0 and (q + 1) % order != 0 and order != q:
            fail("order_not_split_elliptic_or_parabolic", row, f"q={q} order={order}")

        for kind, n in spectrum:
            if kind not in ("path", "cycle"):
                fail("two_intruder_not_path_cycle", row, f"{kind} {n}")
            if kind == "cycle":
                cycles[(q, order, n)] += 1
                if n % 2:
                    fail("odd_cycle", row, f"cycle {n}")
                if n != 2 * order:
                    fail("cycle_not_2order", row, f"order={order} cycle={n}")
                if gc[n] != 0:
                    fail("cycle_nonzero_grundy", row, f"cycle={n} grundy={gc[n]}")

    print(f"ROWS total={len(cached_rows)} files={len(args.rows)}")
    for q in sorted({q for q, _ in rows}):
        conic = rows[(q, "conic")]
        intruder = rows[(q, "intruder")]
        wc = wins[(q, "conic", True)]
        wi = wins[(q, "intruder", True)]
        print(f"Q q={q} rows={conic + intruder} conic={conic} intruder={intruder} winning_conic={wc} winning_intruder={wi}")

    print("CHECK defxor_mismatch failures=" + str(failures["defxor_mismatch"]))
    print("CHECK one_intruder_matching failures=" + str(failures["one_intruder_not_matching_fragment"]))
    print("CHECK two_intruder_path_cycle failures=" + str(failures["two_intruder_not_path_cycle"] + failures["bad_component_kind"]))
    print("CHECK product_order_law failures=" + str(failures["order_not_split_elliptic_or_parabolic"]))
    print("CHECK even_cycle_zero failures=" + str(failures["odd_cycle"] + failures["cycle_not_2order"] + failures["cycle_nonzero_grundy"]))

    for q in sorted({q for q, _ in orders}):
        q_orders = " ".join(f"{d}:{orders[(q, d)]}" for d in sorted(d for qq, d in orders if qq == q))
        print(f"ORDERS q={q} {q_orders}")
    for q in sorted({q for q, _, _ in cycles}):
        q_cycles = " ".join(
            f"order={d},len={n}:{cycles[(q, d, n)]}"
            for d, n in sorted((d, n) for qq, d, n in cycles if qq == q)
        )
        print(f"CYCLES q={q} {q_cycles}")

    total_failures = sum(failures.values())
    if total_failures:
        print(f"FAILURES total={total_failures}")
        for example in examples:
            print(example)
        return 1
    print("FAILURES total=0")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
