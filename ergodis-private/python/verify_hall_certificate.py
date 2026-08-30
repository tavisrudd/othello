#!/usr/bin/env python3
"""Independent replay for Ergodis Hall matching/deficiency certificates."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def neighborhoods(graph: dict[str, object]) -> list[set[int]]:
    left_count = int(graph["left_count"])
    right_count = int(graph["right_count"])
    offsets = [int(value) for value in graph["offsets"]]
    neighbors = [int(value) for value in graph["neighbors"]]
    if (
        graph.get("schema") != "ergodis-hall-graph/v1"
        or len(offsets) != left_count + 1
        or offsets[0] != 0
        or offsets[-1] != len(neighbors)
        or any(left > right for left, right in zip(offsets, offsets[1:]))
        or any(right < 0 or right >= right_count for right in neighbors)
    ):
        raise ValueError("invalid Hall graph")
    return [set(neighbors[offsets[left] : offsets[left + 1]]) for left in range(left_count)]


def verify(graph: dict[str, object], document: dict[str, object]) -> None:
    adjacency = neighborhoods(graph)
    if document.get("schema") != "ergodis-hall-certificate/v1":
        raise ValueError("invalid Hall certificate schema")
    certificate = document["certificate"]
    outcome = certificate.get("outcome")
    if outcome == "saturated":
        matching = [int(value) for value in certificate["matching"]]
        if len(matching) != len(adjacency) or len(set(matching)) != len(matching):
            raise ValueError("matching does not inject every left vertex")
        if any(right not in adjacency[left] for left, right in enumerate(matching)):
            raise ValueError("matching uses a missing edge")
        return
    if outcome == "deficient":
        left = [int(value) for value in certificate["left"]]
        claimed = {int(value) for value in certificate["neighborhood"]}
        if len(left) != len(set(left)) or any(value < 0 or value >= len(adjacency) for value in left):
            raise ValueError("invalid deficient left set")
        exact = set().union(*(adjacency[value] for value in left)) if left else set()
        if claimed != exact or len(claimed) >= len(left):
            raise ValueError("claimed set is not Hall deficient")
        return
    raise ValueError("unknown Hall certificate outcome")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--graph", type=Path, required=True)
    parser.add_argument("--certificate", type=Path, required=True)
    arguments = parser.parse_args()
    graph = json.loads(arguments.graph.read_text(encoding="utf-8"))
    certificate = json.loads(arguments.certificate.read_text(encoding="utf-8"))
    verify(graph, certificate)
    print("VERIFIED")


if __name__ == "__main__":
    main()
