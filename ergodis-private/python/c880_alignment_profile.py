#!/usr/bin/env python3
"""Summarize SAT near-misses for the C880 attachment problem.

This is deliberately outside the public ergodis tree: it translates a solver
model back into invariant hypergraph data that can suggest a structural lemma.
"""

from __future__ import annotations

import argparse
import collections
import itertools
import json
from pathlib import Path

from c880_alignment_sat import CUTS, TRIPLES, read_model, side


def cut_is_bipartite(selected: list[bool], cut_index: int) -> bool:
    _cut, pairs, edge_count = CUTS[cut_index]
    adjacency = [[] for _ in range(edge_count)]
    for keep, pair in zip(selected, pairs, strict=True):
        if keep and pair is not None:
            left, right = pair
            adjacency[left].append(right)
            adjacency[right].append(left)
    colors = [-1] * edge_count
    for root in range(edge_count):
        if colors[root] >= 0:
            continue
        colors[root] = 0
        queue = [root]
        for vertex in queue:
            for neighbor in adjacency[vertex]:
                if colors[neighbor] < 0:
                    colors[neighbor] = colors[vertex] ^ 1
                    queue.append(neighbor)
                elif colors[neighbor] == colors[vertex]:
                    return False
    return True


def histogram(values: list[int]) -> dict[str, int]:
    return {str(value): count for value, count in sorted(collections.Counter(values).items())}


def profile(selected: list[bool]) -> dict[str, object]:
    chosen = [triple for triple, keep in zip(TRIPLES, selected, strict=True) if keep]
    point_degrees = [sum(point in triple for triple in chosen) for point in range(8)]
    pair_degrees = [
        sum(left in triple and right in triple for triple in chosen)
        for left, right in itertools.combinations(range(8), 2)
    ]
    failed: list[dict[str, object]] = []
    for cut_index, (cut, _pairs, _edge_count) in enumerate(CUTS):
        if not cut_is_bipartite(selected, cut_index):
            continue
        left = [point for point in range(8) if side(cut, point) == 0]
        right = [point for point in range(8) if side(cut, point) == 1]
        smaller = min(len(left), len(right))
        failed.append({"side_size": smaller, "left": left, "right": right})
    return {
        "schema": "c880-alignment-near-miss/v1",
        "selected_count": len(chosen),
        "family_indices": [index for index, keep in enumerate(selected) if keep],
        "family_triples": chosen,
        "point_degrees": point_degrees,
        "point_degree_histogram": histogram(point_degrees),
        "pair_codegrees": pair_degrees,
        "pair_codegree_histogram": histogram(pair_degrees),
        "failed_cut_count": len(failed),
        "failed_cut_type_histogram": histogram(
            [int(item["side_size"]) for item in failed]
        ),
        "failed_cuts": failed,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=Path, required=True)
    parser.add_argument("--out", type=Path)
    arguments = parser.parse_args()
    selected = read_model(arguments.model)
    if selected is None:
        raise SystemExit("model file does not contain a SAT assignment")
    text = json.dumps(profile(selected), indent=2, sort_keys=True) + "\n"
    if arguments.out is None:
        print(text, end="")
    else:
        arguments.out.write_text(text, encoding="utf-8")


if __name__ == "__main__":
    main()
