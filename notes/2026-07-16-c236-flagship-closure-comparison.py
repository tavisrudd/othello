#!/usr/bin/env python3
"""C236: cubic/harmonic bounded-closure comparison certificate."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import combinations
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-13-projective-completion-verifier.py"
HARMONIC = HERE / "2026-07-16-c218-quartic-nucleus-verifier.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def cubic_small_circuits(base, field, points):
    circuits = []
    for size in range(2, 5):
        for support in combinations(range(len(points)), size):
            columns = [points[index] for index in support]
            if base.rank(field, columns) == size:
                continue
            if not all(
                base.rank(field, columns[:deleted] + columns[deleted + 1 :]) == size - 1
                for deleted in range(size)
            ):
                continue
            circuits.append(frozenset(support))
    return tuple(circuits)


def cubic_closed_set_replay(base, field):
    """Compare closed sets; equality of closed-set families proves equality on every seed."""

    q = field.q
    points, labels = base.completed_points(field)
    circuits = cubic_small_circuits(base, field, points)
    axis_offset = q + 1
    axis_all = (1 << (q + 1)) - 1

    axis_circuits = [c for c in circuits if all(index >= axis_offset for index in c)]
    mixed = [c for c in circuits if sum(index < axis_offset for index in c) == 3]
    assert len(axis_circuits) == q * (q * q - 1) // 6
    assert len(mixed) == (q + 1) * q * (q - 1) // 6
    assert all(len(circuit) == 3 for circuit in axis_circuits)
    assert all(len(circuit) == 4 for circuit in mixed)
    assert len(circuits) == len(axis_circuits) + len(mixed)

    completions = []
    for circuit in mixed:
        cubic_mask = sum(1 << index for index in circuit if index < axis_offset)
        axis_index = next(index - axis_offset for index in circuit if index >= axis_offset)
        completions.append((cubic_mask, 1 << axis_index))

    horn_closed = []
    for cubic_mask in range(1 << (q + 1)):
        required_axis = 0
        forbidden_axis = 0
        for triple, axis_bit in completions:
            intersection = (cubic_mask & triple).bit_count()
            if intersection == 3:
                required_axis |= axis_bit
            elif intersection == 2:
                forbidden_axis |= axis_bit
        if required_axis & forbidden_axis:
            continue
        # A Horn-closed subset of a projective line has zero, one, or every point.
        axis_candidates = (0, axis_all, *(1 << index for index in range(q + 1)))
        for axis_mask in axis_candidates:
            if required_axis & ~axis_mask or forbidden_axis & axis_mask:
                continue
            horn_closed.append(cubic_mask | (axis_mask << axis_offset))

    horn_closed = sorted(set(horn_closed))
    rank_histogram = Counter()
    for support_mask in horn_closed:
        support = [points[index] for index in range(len(points)) if support_mask & (1 << index)]
        support_rank = base.rank(field, support)
        rank_histogram[support_rank] += 1
        for index, point in enumerate(points):
            if support_mask & (1 << index):
                continue
            assert base.rank(field, support + [point]) > support_rank, (
                q,
                [labels[item] for item in range(len(points)) if support_mask & (1 << item)],
                labels[index],
            )

    # Directly guard the proof's load-bearing four-curve completion lemma.
    completion_by_triple = {triple: axis for triple, axis in completions}
    for four in combinations(range(q + 1), 4):
        values = {
            completion_by_triple[sum(1 << index for index in triple)]
            for triple in combinations(four, 3)
        }
        assert len(values) >= 2

    return {
        "q": q,
        "point_count": len(points),
        "small_circuit_count": len(circuits),
        "axis_triple_count": len(axis_circuits),
        "mixed_completion_count": len(mixed),
        "horn_closed_set_count": len(horn_closed),
        "horn_closed_rank_histogram": dict(sorted(rank_histogram.items())),
        "all_horn_closed_sets_are_matroid_closed": True,
        "four_curve_completion_lemma_checked": True,
    }


def add_many(field, values):
    answer = 0
    for value in values:
        answer = field.add(answer, value)
    return answer


def harmonic_witness(base, harmonic):
    field = base.FIELDS[1]  # GF(9), represented in the base verifier's polynomial basis.
    q = field.q
    blocks = harmonic.harmonic_blocks(field)
    finite_witness = None
    for four in combinations(range(q), 4):
        zero_sum_free = all(add_many(field, triple) != 0 for triple in combinations(four, 3))
        e2 = add_many(field, (field.mul(a, b) for a, b in combinations(four, 2)))
        if zero_sum_free and e2 != 0:
            finite_witness = four
            break
    assert finite_witness is not None

    infinity = q
    curve_seed = frozenset((*finite_witness, infinity))
    assert all(not block.issubset(curve_seed) for block in blocks)
    points = harmonic.quartic_system(field)
    seed_columns = [points[index] for index in sorted(curve_seed)]
    assert harmonic.rank(field, seed_columns) == 5
    assert all(harmonic.rank(field, seed_columns + [point]) == 5 for point in points)

    # Radius-four circuits are exactly {N} union B.  With N erased and no B in the
    # five curve survivors, no Horn implication can fire.
    nucleus = q + 1
    active = sum(1 << index for index in curve_seed)
    for block in blocks:
        circuit = sum(1 << index for index in block) | (1 << nucleus)
        assert (circuit & active).bit_count() != 4
    assert len(points) == 11

    return {
        "q": q,
        "finite_parameters": list(finite_witness),
        "curve_seed": [*(f"V({value})" for value in finite_witness), "V(infinity)"],
        "zero_sum_free": True,
        "e2": add_many(field, (field.mul(a, b) for a, b in combinations(finite_witness, 2))),
        "harmonic_blocks_contained": 0,
        "sequential_radius_four_closure_size": 5,
        "matroid_closure_size": 11,
        "seed_rank": 5,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    base = load_module("c236_projective_completion", BASE)
    harmonic = load_module("c236_quartic_nucleus", HARMONIC)
    certificate = {
        "task": "C236",
        "claim": "cubic L_3 equals matroid closure; harmonic q=9 has strict L_4 below closure",
        "cubic_replays": [cubic_closed_set_replay(base, field) for field in base.FIELDS[:2]],
        "harmonic_witness": harmonic_witness(base, harmonic),
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
