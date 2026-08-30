#!/usr/bin/env python3
"""Profile frozen GF(27) locator witnesses by distance from affine F3 planes."""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
from collections import Counter
from pathlib import Path

from c973_gf27_orbit_core import _digits, add, mul, polynomial_from_roots
from semantic_subspace_core import enumerate_affine_subspaces


def extract(source: Path) -> dict[str, object]:
    planes = enumerate_affine_subspaces(range(27), 2, _digits, add, 3)
    if len(planes) != 39:
        raise ValueError("unexpected number of affine F3 planes in GF(27)")
    overlap_histogram: Counter[int] = Counter()
    weighted_overlap_histogram: Counter[int] = Counter()
    rows = 0
    weighted_witnesses = 0
    with source.open(newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle, delimiter="\t"):
            if "z2,z3,z4,z5,z6,z7,z8" in row:
                syndrome = tuple(
                    int(value) for value in row["z2,z3,z4,z5,z6,z7,z8"].split(",")
                )
                weight = 1
            else:
                syndrome = (0, 1, 0, 0, 0, 0, 0)
                weight = int(row["orbit_size"])
            support = tuple(int(value) for value in row["nine_set"].split(","))
            polynomial = polynomial_from_roots(support)
            equations = []
            for offset in (1, 2):
                value = 0
                for index, coefficient in enumerate(syndrome):
                    value = add(value, mul(coefficient, polynomial[index + offset]))
                equations.append(value)
            if equations != [0, 0]:
                raise ValueError("witness does not satisfy its Hankel equations")
            maximum_overlap = max(len(set(support) & set(plane)) for plane in planes)
            overlap_histogram[maximum_overlap] += 1
            weighted_overlap_histogram[maximum_overlap] += weight
            rows += 1
            weighted_witnesses += weight
    return {
        "schema": "ergodis.semantic-affine-switch-profile.v1",
        "problem": "C973 GF(27) certified switch witness sample",
        "source": os.fspath(source),
        "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "affine_F3_planes": len(planes),
        "witnesses": rows,
        "weighted_witnesses": weighted_witnesses,
        "maximum_plane_overlap_histogram": {
            str(overlap): count for overlap, count in sorted(overlap_histogram.items())
        },
        "replacement_distance_histogram": {
            str(9 - overlap): count for overlap, count in sorted(overlap_histogram.items(), reverse=True)
        },
        "weighted_maximum_plane_overlap_histogram": {
            str(overlap): count for overlap, count in sorted(weighted_overlap_histogram.items())
        },
        "weighted_replacement_distance_histogram": {
            str(9 - overlap): count
            for overlap, count in sorted(weighted_overlap_histogram.items(), reverse=True)
        },
        "maximum_replacement_distance": 9 - min(overlap_histogram),
        "all_hankel_witnesses_replayed": True,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    rendered = json.dumps(extract(args.source), indent=2, sort_keys=True) + "\n"
    if args.output is None:
        print(rendered, end="")
    else:
        with args.output.open("x", encoding="utf-8") as handle:
            handle.write(rendered)


if __name__ == "__main__":
    main()
