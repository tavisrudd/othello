#!/usr/bin/env python3
"""Build a pinned manifest for all 100 official VLSAT-2 instances."""

from __future__ import annotations

import argparse
import html
import json
import re
from pathlib import Path

from run_satcomp24_portfolio import sha256


INDEX_URL = "https://cadp.inria.fr/resources/vlsat/2.html"
DOWNLOAD_ROOT = "https://cadp.inria.fr/ftp/benchmarks/vlsat/"


def cell_text(cell: str) -> str:
    text = re.sub(r"<[^>]+>", " ", cell)
    return " ".join(html.unescape(text).replace(",", "").split())


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--index", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    source = args.index.read_text()
    instances = []
    for row in re.findall(r"<tr>(.*?)</tr>", source, re.IGNORECASE | re.DOTALL):
        match = re.search(r"(vlsat2_(\d+)_(\d+)\.cnf\.bz2)", row)
        if match is None:
            continue
        cells = [
            cell_text(cell)
            for cell in re.findall(
                r"<td[^>]*>(.*?)</td>", row, re.IGNORECASE | re.DOTALL
            )
        ]
        if len(cells) != 8:
            raise SystemExit(f"unexpected table row for {match.group(1)}")
        variables = int(match.group(2))
        clauses = int(match.group(3))
        if int(cells[1]) != variables or int(cells[2]) != clauses:
            raise SystemExit(f"table/header mismatch for {match.group(1)}")
        instances.append(
            {
                "filename": match.group(1).removesuffix(".bz2"),
                "archive": match.group(1),
                "variables": variables,
                "clauses": clauses,
                "expected": "sat" if cells[3] == "Yes" else "unsat",
                "competition": cells[4] or None,
                "difficulty": cells[5],
                "uncompressed_bytes": int(cells[6]),
                "compressed_bytes": int(cells[7]),
                "official_url": DOWNLOAD_ROOT + match.group(1),
            }
        )
    if len(instances) != 100:
        raise SystemExit(f"expected 100 official rows, found {len(instances)}")
    outcomes = {outcome: 0 for outcome in ("sat", "unsat")}
    for entry in instances:
        outcomes[entry["expected"]] += 1
    if outcomes != {"sat": 50, "unsat": 50}:
        raise SystemExit(f"unexpected official outcome balance: {outcomes}")
    document = {
        "schema": "ergodis-vlsat2-full-manifest-v1",
        "official_index": INDEX_URL,
        "official_index_sha256": sha256(args.index),
        "builder_sha256": sha256(Path(__file__)),
        "selection": "all rows in official table order",
        "outcomes": outcomes,
        "compressed_bytes": sum(entry["compressed_bytes"] for entry in instances),
        "uncompressed_bytes": sum(entry["uncompressed_bytes"] for entry in instances),
        "instances": instances,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(document, indent=2) + "\n")


if __name__ == "__main__":
    main()
