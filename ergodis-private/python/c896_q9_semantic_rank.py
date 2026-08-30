#!/usr/bin/env python3
"""Lift the C895 q=9 Hom calculation into semantic rank cores for C896."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

from semantic_rank_core import (
    block_marginals,
    flatten,
    greedy_independent_rows,
    minimum_full_rank_subsets,
)


ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "notes/2026-08-09-c895-q9-hom-falsifier.py"
SOURCE_SHA256 = "782087ca2931c7438dca514010b65cb152d90df18cc27ae86822dde0fea20ab6"
GENERATOR_NAMES = ["u(1)", "u(a)", "weyl", "torus"]


def load_source():
    if hashlib.sha256(SOURCE.read_bytes()).hexdigest() != SOURCE_SHA256:
        raise RuntimeError("frozen q=9 computation has changed")
    specification = importlib.util.spec_from_file_location("c895_q9", SOURCE)
    if specification is None or specification.loader is None:
        raise RuntimeError("could not load the frozen q=9 computation")
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def analyze_source(module, c0: int, c1: int) -> dict[str, object]:
    generators, _primitive = module.generators(False)
    targets = module.target_matrices(generators)
    sources = module.source_matrices(generators, c0, c1)
    blocks = []
    labels: list[dict[str, object]] = []
    for generator, (target, source) in enumerate(zip(targets, sources, strict=True)):
        equations, variables = module.intertwiner_equations([target], [source])
        blocks.append(equations)
        for out_index in range(len(target)):
            for in_index in range(len(source)):
                labels.append(
                    {
                        "generator": GENERATOR_NAMES[generator],
                        "out_index": out_index,
                        "in_index": in_index,
                    }
                )
    rank = module.rank
    full_rank, minimum_subsets = minimum_full_rank_subsets(blocks, rank)
    rows = flatten(blocks, range(len(blocks)))
    independent = greedy_independent_rows(rows, rank)
    return {
        "digits": [c0, c1],
        "source_dimension": len(sources[0]),
        "variables": variables,
        "rank": full_rank,
        "hom_dimension": variables - full_rank,
        "minimum_generator_core_size": len(minimum_subsets[0]),
        "minimum_generator_cores": [
            [GENERATOR_NAMES[index] for index in subset]
            for subset in minimum_subsets
        ],
        "generator_marginals": [
            {**record, "generator": GENERATOR_NAMES[int(record["block"])]}
            for record in block_marginals(blocks, rank)
        ],
        "independent_equation_count": len(independent),
        "independent_equations": [labels[index] for index in independent],
    }


def compute() -> dict[str, object]:
    module = load_source()
    records = []
    for c0 in range(3):
        for c1 in range(3):
            if (c0 + c1) % 2 == 0:
                records.append(analyze_source(module, c0, c1))
    return {
        "schema": "c896-q9-semantic-rank/v1",
        "source_sha256": SOURCE_SHA256,
        "field": "F_3[a]/(a^2+1)",
        "target": "Sym^2(Sym^3 natural)",
        "generator_blocks": GENERATOR_NAMES,
        "sources": records,
        "boundary": "bounded q=9 rank-core extraction; not an all-field theorem",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path)
    arguments = parser.parse_args()
    text = json.dumps(compute(), indent=2, sort_keys=True) + "\n"
    if arguments.out is None:
        print(text, end="")
    else:
        arguments.out.write_text(text, encoding="utf-8")


if __name__ == "__main__":
    main()
