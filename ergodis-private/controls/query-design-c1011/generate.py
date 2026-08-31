#!/usr/bin/env python3
"""Derive the frozen generic query masks from the private projective fixture."""

import argparse
import importlib.util
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SOURCE = ROOT / "notes/clebsch-tasks/c1011_paper_v_shadow.py"
EVIDENCE = ROOT / "notes/clebsch-tasks/c1011_paper_v_shadow.json"
OUTPUT = HERE / "c1011-query-input.json"


def derive() -> dict[str, object]:
    spec = importlib.util.spec_from_file_location("c1011_shadow", SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    with module.SCOUT.open() as handle:
        scout = json.load(handle)
    h3 = next(record for record in scout["types"] if record["type"] == "H3")
    base = tuple(tuple(pair) for pair in h3["coxeter_invariant_matching"])
    orbit = sorted(
        {
            module.matching_image(permutation, base)
            for permutation in module.pgl_permutations()
        }
    )
    edges = sorted(
        {
            tuple(
                index
                for index, matching in enumerate(orbit)
                if pair in matching
            )
            for pair in module.itertools.combinations(range(12), 2)
        }
    )
    with EVIDENCE.open() as handle:
        evidence = json.load(handle)
    witness_edges = [
        tuple(edge)
        for edge in evidence["pair_membership_queries"][
            "nonadaptive_witness_query_edges"
        ]
    ]
    edge_index = {edge: index for index, edge in enumerate(edges)}
    return {
        "hypotheses": len(orbit),
        "selected": [edge_index[edge] for edge in witness_edges],
        "tests": [(1 << left) | (1 << right) for left, right in edges],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    derived = derive()
    if args.write:
        OUTPUT.write_text(json.dumps(derived, separators=(",", ":")) + "\n")
        return
    assert json.loads(OUTPUT.read_text()) == derived


if __name__ == "__main__":
    main()
