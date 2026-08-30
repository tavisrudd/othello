#!/usr/bin/env python3
"""Compile one candidate projective Hall edge on the frozen q=11 witness.

This is a diagnostic edge proposal, not a sound charge-transport theorem.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "notes/2026-07-29-c80-causal-one-to-many.json"
SOURCE_SHA256 = "42501fea4df64a737bb3b0a234e1896a1b03fb41954fd90a2a28543b4ed924bc"


def point(value: list[int]) -> tuple[int, int]:
    if len(value) != 2:
        raise ValueError("expected affine point")
    return value[0], value[1]


def collinear(a: tuple[int, int], b: tuple[int, int], c: tuple[int, int], q: int) -> bool:
    return ((b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])) % q == 0


def compile_graph() -> tuple[dict[str, object], dict[str, object]]:
    if hashlib.sha256(SOURCE.read_bytes()).hexdigest() != SOURCE_SHA256:
        raise RuntimeError("frozen C80 witness has changed")
    document = json.loads(SOURCE.read_text(encoding="utf-8"))
    q = int(document["field"]["order"])
    replay = document["independent_affine_determinant_replay"]
    left = [point(value) for value in replay["genuinely_new_defects"]]
    old = [point(value) for value in replay["old_defects"]]
    successor = {point(value) for value in replay["defects_after_causal_reply"]}
    right = [value for value in old if value not in successor]
    ancestral = [point(value) for value in document["witness"]["state"]]

    offsets = [0]
    neighbors: list[int] = []
    edge_records = []
    for defect in left:
        for label_index, label in enumerate(right):
            carriers = [
                carrier
                for carrier in ancestral
                if carrier not in {defect, label} and collinear(defect, label, carrier, q)
            ]
            if not carriers:
                continue
            neighbors.append(label_index)
            edge_records.append(
                {
                    "defect": list(defect),
                    "consumed_label": list(label),
                    "ancestral_carriers": [list(value) for value in carriers],
                }
            )
        offsets.append(len(neighbors))

    graph = {
        "schema": "ergodis-hall-graph/v1",
        "left_count": len(left),
        "right_count": len(right),
        "offsets": offsets,
        "neighbors": neighbors,
    }
    manifest = {
        "schema": "c80-q11-ancestral-secant-hall-probe/v1",
        "source_sha256": SOURCE_SHA256,
        "field_order": q,
        "edge_proposal": (
            "new defect z is adjacent to a consumed old defect label ell "
            "when line(z,ell) contains a pre-exchange selected point"
        ),
        "boundary": "diagnostic projective motif; charge-transport soundness unproved",
        "new_defects": [list(value) for value in left],
        "consumed_labels": [list(value) for value in right],
        "ancestral_state": [list(value) for value in ancestral],
        "edges": edge_records,
        "graph": graph,
    }
    return graph, manifest


def write_new(path: Path, document: dict[str, object]) -> None:
    with path.open("x", encoding="utf-8") as stream:
        json.dump(document, stream, indent=2, sort_keys=True)
        stream.write("\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--graph", type=Path, required=True)
    parser.add_argument("--manifest", type=Path, required=True)
    arguments = parser.parse_args()
    graph, manifest = compile_graph()
    write_new(arguments.graph, graph)
    write_new(arguments.manifest, manifest)


if __name__ == "__main__":
    main()
