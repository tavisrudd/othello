#!/usr/bin/env python3
"""Build the deterministic first-ten VLSAT-2 prefix manifest."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from run_satcomp24_portfolio import sha256


ROWS = [
    (544, 8738, "unsat"),
    (600, 11440, "unsat"),
    (684, 9417, "unsat"),
    (684, 13953, "unsat"),
    (708, 10259, "unsat"),
    (736, 11022, "unsat"),
    (798, 17543, "unsat"),
    (1000, 22250, "sat"),
    (1022, 14955, "unsat"),
    (1125, 15795, "unsat"),
]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    instances = []
    for variables, clauses, expected in ROWS:
        stem = f"vlsat2_{variables}_{clauses}.cnf"
        instances.append(
            {
                "filename": stem,
                "archive": stem + ".bz2",
                "variables": variables,
                "clauses": clauses,
                "expected": expected,
                "official_url": (
                    "https://cadp.inria.fr/ftp/benchmarks/vlsat/" + stem + ".bz2"
                ),
            }
        )
    document = {
        "schema": "ergodis-vlsat2-prefix-manifest-v1",
        "official_index": "https://cadp.inria.fr/resources/vlsat/2.html",
        "selection": "the first ten rows of the official size-ordered table",
        "builder_sha256": sha256(Path(__file__)),
        "instances": instances,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(document, indent=2) + "\n")


if __name__ == "__main__":
    main()
