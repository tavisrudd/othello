#!/usr/bin/env python3
"""Compile the ancestral-secant Hall proposal on three frozen q=23 types."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from c80_hall_motif_probe import collinear, point, write_new


ROOT = Path(__file__).resolve().parents[2]
SOURCES = [
    (
        "type_i",
        ROOT / "notes/2026-07-26-c80-q23-first-new-replacement-orbit.json",
        "276103c81c898e32699089636459035944ed95f1ea881815417092aed8cfcc2a",
    ),
    (
        "type_ii",
        ROOT / "notes/2026-07-26-c80-q23-next-marked-replacement-orbit.json",
        "cb2d4ebcd2105bd9c0e71285f5203785b2cfa20e963325d6f241b3be0f2cd836",
    ),
    (
        "type_iii",
        ROOT / "notes/2026-07-26-c80-q23-next-replacement-ancestry.json",
        "e1c3340a15d3c3242aad766b7b8d95951e114d5f6d5b6839852e7eb540523a7f",
    ),
]


def raw_case(name: str, document: dict[str, object]) -> tuple[list, list, list]:
    if name == "type_i":
        record = document["first_new_orbit"]
        return record["target_cells"], record["new_defects"], record["removed_old_defects"]
    if name == "type_ii":
        record = document["next_new_orbit"]
        return record["target_cells"], record["new_defects"], record["removed_old_defects"]
    target = document["next_replacement_target"]
    witnesses = [
        witness
        for obligation in target["blocking_obligations"]
        for witness in obligation["witnesses"]
    ]
    if len(witnesses) != 1:
        raise ValueError("type-iii frozen source no longer has one witness")
    witness = witnesses[0]
    return target["state_cells"], witness["new_defects"], witness["removed_old_defects"]


def compile_case(name: str, document: dict[str, object]) -> tuple[dict, dict]:
    state_raw, left_raw, right_raw = raw_case(name, document)
    state = [point(value) for value in state_raw]
    left = [point(value) for value in left_raw]
    right = [point(value) for value in right_raw]
    offsets = [0]
    neighbors: list[int] = []
    edge_records = []
    for defect in left:
        for label_index, label in enumerate(right):
            carriers = [
                carrier
                for carrier in state
                if carrier not in {defect, label} and collinear(defect, label, carrier, 23)
            ]
            if carriers:
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
    semantics = {
        "case": name,
        "ancestral_state": [list(value) for value in state],
        "new_defects": [list(value) for value in left],
        "consumed_labels": [list(value) for value in right],
        "edges": edge_records,
        "graph": graph,
    }
    return graph, semantics


def compile_suite() -> tuple[dict[str, dict], dict[str, object]]:
    graphs = {}
    cases = []
    source_hashes = {}
    for name, path, expected_hash in SOURCES:
        actual_hash = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual_hash != expected_hash:
            raise RuntimeError(f"frozen {name} source has changed")
        source_hashes[str(path.relative_to(ROOT))] = expected_hash
        graph, semantics = compile_case(name, json.loads(path.read_text(encoding="utf-8")))
        graphs[name] = graph
        cases.append(semantics)
    return graphs, {
        "schema": "c80-q23-ancestral-secant-hall-probe/v1",
        "source_sha256": source_hashes,
        "edge_proposal": (
            "new defect z is adjacent to a consumed old defect label ell "
            "when line(z,ell) contains a pre-exchange selected point"
        ),
        "boundary": "diagnostic projective motif; charge-transport soundness unproved",
        "cases": cases,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out-dir", type=Path, required=True)
    arguments = parser.parse_args()
    graphs, manifest = compile_suite()
    for name, graph in graphs.items():
        write_new(arguments.out_dir / f"c80-q23-ancestral-secant-{name}-graph.json", graph)
    write_new(arguments.out_dir / "c80-q23-ancestral-secant-manifest.json", manifest)


if __name__ == "__main__":
    main()
