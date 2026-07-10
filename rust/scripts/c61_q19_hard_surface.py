#!/usr/bin/env python3
"""Summarize the q=19 Psi-descent selector exceptions localized by C61/C63."""

from __future__ import annotations

import argparse
import csv
from collections import Counter


HARD_PARENT = "0b7a91f6b96e82780d0fe4202f22b126"


def families(text: str) -> set[str]:
    return {item for item in text.split(",") if item}


def reply_field(text: str, name: str) -> str:
    for item in text.split(":"):
        if item.startswith(name):
            return item[len(name) :]
    raise ValueError(f"missing {name!r} in {text!r}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("tsv")
    args = parser.parse_args()

    with open(args.tsv, newline="") as handle:
        rows = [
            row
            for row in csv.DictReader(handle, delimiter="\t")
            if row["parent_key"] == HARD_PARENT and row["xgeom"] == "on"
        ]
    rows.sort(key=lambda row: tuple(map(int, row["opponent"].split(","))))
    if len(rows) != 12:
        raise SystemExit(f"expected 12 hard-surface rows, found {len(rows)}")

    cover_sets = [families(row["covering_families"]) for row in rows]
    safe_sets = [families(row["safe_families"]) for row in rows]
    cover_counts = Counter(name for names in cover_sets for name in names)
    safe_counts = Counter(name for names in safe_sets for name in names)

    print(f"C61-Q19-HARD parent={HARD_PARENT} rows={len(rows)}")
    for row in rows:
        override = row["best_psi_p"]
        print(
            f"  opponent={row['opponent']:5s} "
            f"override={override.split(':', 1)[0]:5s} "
            f"dpsi={reply_field(override, 'dpsi'):>3s} "
            f"geom={override.split(':')[3]:3s} "
            f"live={reply_field(override, 'live'):>2s} "
            f"comp={reply_field(override, 'comp'):>2s} "
            f"xor0={reply_field(override, 'xor0')} "
            f"safe={row['safe_families'] or '-'}"
        )
    print("  cover_all=" + ",".join(sorted(set.intersection(*cover_sets))))
    print("  safe_all=" + ",".join(sorted(set.intersection(*safe_sets))))
    print(
        "  safe_counts="
        + ",".join(f"{name}:{count}" for name, count in sorted(safe_counts.items()))
    )
    print(
        "  cover_counts="
        + ",".join(f"{name}:{count}" for name, count in sorted(cover_counts.items()))
    )


if __name__ == "__main__":
    main()
