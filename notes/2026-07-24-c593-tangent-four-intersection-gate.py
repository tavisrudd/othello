#!/usr/bin/env python3
"""Find and verify resolutions in the two certified MATCH(10,5,1) designs."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "notes/2026-07-24-c574-match10-rank-three-realizability.json"
OUTPUT = ROOT / "notes/2026-07-24-c593-tangent-four-intersection-gate.json"
SOURCE_SHA256 = "ce83bb36f5dcaf8161a8e28a26878e009e74e24c6393576b5b1bb3c0c938ec95"
ALL_EDGES = frozenset((i, j) for i in range(10) for j in range(i + 1, 10))


def file_sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_matching(raw: list[list[int]]) -> frozenset[tuple[int, int]]:
    matching = frozenset(tuple(sorted(edge)) for edge in raw)
    assert len(matching) == 5
    assert {vertex for edge in matching for vertex in edge} == set(range(10))
    return matching


def find_resolution(
    blocks: list[frozenset[tuple[int, int]]],
) -> list[int]:
    by_edge = {edge: [] for edge in sorted(ALL_EDGES)}
    for index, block in enumerate(blocks):
        for edge in block:
            by_edge[edge].append(index)

    chosen: list[int] = []

    def search(used: frozenset[tuple[int, int]]) -> bool:
        if len(chosen) == 9:
            return used == ALL_EDGES
        uncovered = [edge for edge in sorted(ALL_EDGES) if edge not in used]
        edge = min(
            uncovered,
            key=lambda candidate: sum(
                not (blocks[index] & used) for index in by_edge[candidate]
            ),
        )
        for index in by_edge[edge]:
            if blocks[index] & used:
                continue
            chosen.append(index)
            if search(used | blocks[index]):
                return True
            chosen.pop()
        return False

    assert search(frozenset())
    return chosen


def generate() -> dict[str, object]:
    assert file_sha256(SOURCE) == SOURCE_SHA256
    source = json.loads(SOURCE.read_text())
    results = []
    for design_class in source["classes"]:
        blocks = [
            canonical_matching(raw)
            for raw in design_class["matching_design"]
        ]
        assert len(blocks) == 63
        resolution = find_resolution(blocks)
        covered = frozenset().union(*(blocks[index] for index in resolution))
        assert len(resolution) == 9
        assert sum(len(blocks[index]) for index in resolution) == 45
        assert covered == ALL_EDGES
        results.append(
            {
                "class": design_class["name"],
                "resolution_block_indices": resolution,
                "resolution_matchings": [
                    [list(edge) for edge in sorted(blocks[index])]
                    for index in resolution
                ],
            }
        )
    return {
        "schema": "c593-match10-resolution-v1",
        "source": SOURCE.name,
        "source_bytes": SOURCE.stat().st_size,
        "source_sha256": SOURCE_SHA256,
        "claim": (
            "Each of the two certified MATCH(10,5,1) classes contains "
            "nine pairwise edge-disjoint blocks resolving K_10."
        ),
        "classes": results,
    }


def serialized() -> str:
    return json.dumps(generate(), indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    content = serialized()
    if args.write:
        OUTPUT.write_text(content)
    else:
        assert OUTPUT.read_text() == content
        print("C593 MATCH(10,5,1) resolution certificate: OK")


if __name__ == "__main__":
    main()
