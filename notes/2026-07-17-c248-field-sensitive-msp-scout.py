#!/usr/bin/env python3
"""Finite flagship checks for C248's monotone-span-program scout."""

from __future__ import annotations

import argparse
from itertools import combinations
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
C217 = HERE / "2026-07-16-c217-gauge-invariant-verifier.py"
C218 = HERE / "2026-07-16-c218-quartic-nucleus-verifier.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def connected(point_count: int, supports) -> bool:
    adjacency = [set() for _ in range(point_count)]
    for support in supports:
        for left, right in combinations(support, 2):
            adjacency[left].add(right)
            adjacency[right].add(left)
    reached = {0}
    frontier = [0]
    while frontier:
        vertex = frontier.pop()
        for neighbor in adjacency[vertex] - reached:
            reached.add(neighbor)
            frontier.append(neighbor)
    return len(reached) == point_count


def contracted_triples(field, rank, points, contracted, candidates):
    base_rank = rank(field, [points[index] for index in contracted])
    result = set()
    for triple in combinations(candidates, 3):
        if rank(field, [points[index] for index in (*contracted, *triple)]) >= base_rank + 3:
            continue
        assert all(
            rank(field, [points[index] for index in (*contracted, *pair)]) == base_rank + 2
            for pair in combinations(triple, 2)
        )
        result.add(frozenset(triple))
    return result


def zero_sum_triples(field):
    return {
        frozenset(triple)
        for triple in combinations(range(field.q), 3)
        if field.add(field.add(triple[0], triple[1]), triple[2]) == 0
    }


def assert_affine_plane(triples, point_count: int) -> None:
    assert len(triples) == 12
    pairs = map(frozenset, combinations(range(point_count), 2))
    assert all(sum(pair <= triple for triple in triples) == 1 for pair in pairs)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    c217 = load("c248_c217", C217)
    c203 = c217.load_c203()
    cubic_base = c203.load_base()
    field = cubic_base.FIELDS[1]
    assert field.q == 9

    cubic_points, _labels = cubic_base.completed_points(field)
    cubic_small_circuits = c203.enumerate_small_circuits(field, cubic_points)
    cubic_connected = connected(len(cubic_points), cubic_small_circuits)
    assert cubic_connected
    cubic_contraction = contracted_triples(
        field,
        cubic_base.rank,
        cubic_points,
        (2 * field.q + 1,),  # A(infinity)
        tuple(range(field.q)),
    )

    c218 = load("c248_c218", C218)
    harmonic_base = c218.load_base()
    harmonic_field = harmonic_base.FIELDS[1]
    assert harmonic_field.q == 9
    harmonic_points = c218.quartic_system(harmonic_field)
    harmonic_blocks = c218.harmonic_blocks(harmonic_field)
    nucleus = harmonic_field.q + 1
    harmonic_circuits = {frozenset((*block, nucleus)) for block in harmonic_blocks}
    harmonic_connected = connected(len(harmonic_points), harmonic_circuits)
    assert harmonic_connected
    harmonic_contraction = contracted_triples(
        harmonic_field,
        c218.rank,
        harmonic_points,
        (harmonic_field.q, nucleus),  # V(infinity), N
        tuple(range(harmonic_field.q)),
    )

    expected = zero_sum_triples(field)
    assert cubic_contraction == expected
    assert harmonic_contraction == expected
    assert_affine_plane(expected, field.q)

    result = {
        "task": "C248",
        "q": field.q,
        "affine_plane_line_count": len(expected),
        "affine_plane_pair_multiplicity": 1,
        "cubic": {
            "point_count": len(cubic_points),
            "helper_count": len(cubic_points) - 1,
            "small_circuit_connected": cubic_connected,
            "contract_A_infinity_AG23": True,
        },
        "harmonic": {
            "point_count": len(harmonic_points),
            "helper_count": len(harmonic_points) - 1,
            "small_circuit_connected": harmonic_connected,
            "contract_N_V_infinity_AG23": True,
        },
    }
    rendered = json.dumps(result, indent=2, sort_keys=True)
    if args.output:
        args.output.write_text(rendered + "\n")
    print(rendered)


if __name__ == "__main__":
    main()
