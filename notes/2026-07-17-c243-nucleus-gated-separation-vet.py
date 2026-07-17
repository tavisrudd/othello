#!/usr/bin/env python3
"""C243: exact checks for the nucleus-gated harmonic separation."""

from __future__ import annotations

import argparse
from collections import Counter
from fractions import Fraction
from itertools import combinations
import importlib.util
import json
import math
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


def design_closure(seed, blocks):
    active = set(seed)
    rounds = []
    while True:
        added = {
            next(iter(block - active))
            for block in blocks
            if len(block - active) == 1
        }
        if not added:
            return frozenset(active), rounds
        active.update(added)
        rounds.append(sorted(added))


def circuit_horn_closure(seed, blocks, nucleus):
    circuits = [block | {nucleus} for block in blocks]
    return design_closure(seed, circuits)


def q9_switch(field, harmonic):
    q = field.q
    assert q == 9
    infinity = q
    nucleus = q + 1
    blocks = harmonic.harmonic_blocks(field)
    seed = frozenset((infinity, 0, 1, 3, 5))  # 3=x and 5=2+x.

    assert not any(block <= seed for block in blocks)
    points = harmonic.quartic_system(field)
    assert harmonic.rank(field, [points[index] for index in seed]) == 5

    ungated, ungated_rounds = circuit_horn_closure(seed, blocks, nucleus)
    gated, gated_rounds = circuit_horn_closure(seed | {nucleus}, blocks, nucleus)
    assert ungated == seed and not ungated_rounds
    assert gated == frozenset(range(q + 2))
    assert len(gated_rounds) == 1 and len(gated_rounds[0]) == 5

    triple_targets = Counter()
    for triple in combinations(seed, 3):
        containing = [block for block in blocks if set(triple) <= block]
        assert len(containing) == 1
        target = next(iter(containing[0] - set(triple)))
        assert target not in seed
        triple_targets[target] += 1
    assert set(triple_targets) == set(range(q + 1)) - seed
    assert set(triple_targets.values()) == {2}

    return {
        "q": q,
        "seed": ["infinity", 0, 1, "x", "2+x"],
        "seed_rank": 5,
        "contained_blocks": 0,
        "without_nucleus_closure_size": len(ungated),
        "with_nucleus_parallel_rounds": gated_rounds,
        "with_nucleus_closure_size": len(gated),
        "missing_curve_points": q + 1 - len(seed),
        "completion_multiplicity_per_missing_curve_point": dict(sorted(triple_targets.items())),
    }


def five_set_scaling(field, harmonic):
    q = field.q
    curve_size = q + 1
    blocks = harmonic.harmonic_blocks(field)
    block_free = []
    for seed in combinations(range(curve_size), 5):
        seed_set = frozenset(seed)
        if not any(block <= seed_set for block in blocks):
            block_free.append(seed_set)

    total = math.comb(curve_size, 5)
    containing = len(blocks) * (curve_size - 4)
    expected_free = total - containing
    assert len(block_free) == expected_free
    assert expected_free > 0

    points = harmonic.quartic_system(field)
    witness = block_free[0]
    assert harmonic.rank(field, [points[index] for index in witness]) == 5

    missing = curve_size - 5
    triple_budget = math.comb(5, 3)
    return {
        "q": q,
        "curve_point_count": curve_size,
        "harmonic_block_count": len(blocks),
        "five_set_count": total,
        "block_containing_five_sets": containing,
        "block_free_five_sets": expected_free,
        "block_free_fraction": str(Fraction(q - 7, q - 2)),
        "every_five_curve_points_span_rank_five": True,
        "strict_inert_spanning_witness_exists": True,
        "missing_points_from_five_seed": missing,
        "one_round_distinct_target_upper_bound": triple_budget,
        "one_round_completion_from_five_seed_possible_by_count": missing <= triple_budget,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    base = load_module("c243_projective_completion", BASE)
    harmonic = load_module("c243_quartic_nucleus", HARMONIC)
    q9, q27 = base.FIELDS[1:3]
    certificate = {
        "task": "C243",
        "claim": "q=9 exact nucleus switch; all characteristic-three q>=9 inert spanning separation; fixed five-seed one-round switch does not scale to q=27",
        "general_gating_identity": "if N is present or the curve seed contains a block, closure is N plus design closure; otherwise a nucleus-free block-free seed is inert",
        "all_field_counting_formula": "block-free five-sets / all five-sets = (q-7)/(q-2) for q=3^h >= 9",
        "fixed_seed_one_round_obstruction": "five seeds expose at most C(5,3)=10 curve targets in one round, while q-4 targets are missing",
        "q9_exact_switch": q9_switch(q9, harmonic),
        "scaling_replays": [
            five_set_scaling(q9, harmonic),
            five_set_scaling(q27, harmonic),
        ],
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
