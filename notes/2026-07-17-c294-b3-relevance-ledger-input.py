#!/usr/bin/env python3
"""Emit the fixed C294 graph plus coloured 02-block coordinates for E1."""

from __future__ import annotations

import argparse
import importlib.util
from pathlib import Path
from types import ModuleType


def load_module(filename: str, name: str) -> ModuleType:
    path = Path(__file__).with_name(filename)
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


E0 = load_module("2026-07-17-c294-b3-coordinate-audit.py", "c294_e1_e0")
R = E0.R


def emit(field_order: int, type_index: int) -> None:
    model = R.Model(field_order, type_index)
    targets = E0.coloured_targets(model)
    sheets = E0.determinant_sheets(model, targets)
    blocks = E0.pair_blocks(targets, 0, 2)
    words = tuple(E0.alternating_word(targets, block, 0, 2) for block in blocks)
    order = E0.greedy_order(model.adjacency, blocks)
    block_of = {vertex: block for block, vertices in enumerate(blocks) for vertex in vertices}
    position = {vertex: offset for word in words for offset, vertex in enumerate(word)}
    root = model.full & ~model.closed[model.identity_index]

    print(field_order, type_index, len(model.adjacency))
    for neighbours in model.adjacency:
        print(neighbours & ((1 << 64) - 1), neighbours >> 64)
    print(root & ((1 << 64) - 1), root >> 64)
    print(len(blocks), *order)
    for vertex in range(len(model.adjacency)):
        print(
            targets[vertex][0],
            targets[vertex][1],
            targets[vertex][2],
            sheets[vertex],
            block_of[vertex],
            position[vertex],
        )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, choices=(3, 5), required=True)
    parser.add_argument("--type", type=int, default=0)
    args = parser.parse_args()
    emit(args.q, args.type)


if __name__ == "__main__":
    main()
