#!/usr/bin/env python3
"""Exact fusion-primitivity audit for the q=13 elliptic scheme."""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "c1010-paper-review-ergodis.py"
OUTPUT = Path(__file__).with_suffix(".json")


def load_source():
    spec = importlib.util.spec_from_file_location("c1010_source", SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def compute():
    source = load_source()
    points = source.internal_points(13)
    relations = source.RELATIONS
    relation = [
        [
            -1 if left == right else source.rho(13, points[left], points[right])
            for right in range(78)
        ]
        for left in range(78)
    ]
    rows = []
    for mask in range(1, 32):
        selected = {
            label for index, label in enumerate(relations) if mask >> index & 1
        }
        colors = [
            [
                2 if left == right else int(relation[left][right] in selected)
                for right in range(78)
            ]
            for left in range(78)
        ]
        ranks = []
        for _ in range(5):
            ranks.append(len({entry for row in colors for entry in row}))
            colors = source.coherent_refinement(colors)
        relation_colors = {
            label: {
                colors[left][right]
                for left in range(78)
                for right in range(left)
                if relation[left][right] == label
            }
            for label in relations
        }
        full = all(len(value) == 1 for value in relation_colors.values()) and len(
            {next(iter(value)) for value in relation_colors.values()}
        ) == 6
        assert full
        rows.append(
            {
                "canonical_mask": mask,
                "selected_relations": sorted(selected),
                "coherent_ranks": ranks,
                "full_scheme_recovered": full,
            }
        )
    return {
        "schema": "c1012-q13-fusion-primitive-v1",
        "vertices": 78,
        "off_diagonal_relations": list(relations),
        "complement_representatives_checked": len(rows),
        "all_nontrivial_relation_unions_recover_full_scheme": True,
        "consequence": "the elliptic association scheme is fusion-primitive",
        "rows": rows,
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(compute(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
    else:
        assert OUTPUT.read_text() == rendered
        print("C1012 q=13 fusion-primitivity: PASS")


if __name__ == "__main__":
    main()
