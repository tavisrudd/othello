#!/usr/bin/env python3
"""C219: exact finite reliability profiles and Steiner overlap checks."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import combinations
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
C202 = HERE / "2026-07-15-c202-repair-extremizers.py"
C218 = HERE / "2026-07-16-c218-quartic-nucleus-verifier.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def reliability_profile(edges: tuple[int, ...], helpers: tuple[int, ...]) -> dict:
    """Return Bernstein coefficients for success under iid helper survival."""

    local = {helper: index for index, helper in enumerate(helpers)}
    local_edges = {
        sum(1 << local[helper] for helper in helpers if edge & (1 << helper))
        for edge in edges
    }
    size = 1 << len(helpers)
    succeeds = bytearray(size)
    for edge in local_edges:
        succeeds[edge] = 1
    # Upward Boolean zeta transform: a set succeeds iff it contains an edge.
    for bit in range(len(helpers)):
        step = 1 << bit
        for chosen in range(size):
            if chosen & step and succeeds[chosen ^ step]:
                succeeds[chosen] = 1
    success = Counter()
    failure = Counter()
    for chosen, value in enumerate(succeeds):
        (success if value else failure)[chosen.bit_count()] += 1
    assert all(
        success[k] + failure[k] == len(tuple(combinations(helpers, k)))
        for k in range(len(helpers) + 1)
    )
    return {
        "helper_count": len(helpers),
        "edge_count": len(local_edges),
        "success_by_survivor_count": [success[k] for k in range(len(helpers) + 1)],
        "failure_by_survivor_count": [failure[k] for k in range(len(helpers) + 1)],
    }


def c202_profiles() -> dict:
    extremizers = load_module("c202_extremizers", C202)
    verifier = extremizers.load_verifier()
    field = verifier.FIELDS[1]
    assert field.q == 9
    points, labels = verifier.completed_points(field)
    circuits = tuple(verifier.minimal_circuits_up_to_five(field, points))
    q = field.q
    expected = {
        ("cubic_infinity", 3): (8, 45),
        ("cubic_infinity", 4): (8, 9),
        ("axis_infinity", 3): (13, 486),
        ("axis_infinity", 4): (15, 108),
    }
    answer = {}
    for target, name in ((q, "cubic_infinity"), (2 * q + 1, "axis_infinity")):
        helpers = tuple(item for item in range(len(points)) if item != target)
        radii = {}
        for radius in (3, 4):
            edges = extremizers.repair_edges(circuits, target, radius)
            profile = reliability_profile(edges, helpers)
            blocker_size, blocker_count = expected[(name, radius)]
            survivor_count = len(helpers) - blocker_size
            # At the first possible failure layer, failures are complements of
            # the minimum blockers certified by C202.
            assert profile["failure_by_survivor_count"][survivor_count] == blocker_count
            assert not any(profile["failure_by_survivor_count"][survivor_count + 1 :])
            profile["minimum_blocker_size"] = blocker_size
            profile["minimum_blocker_count"] = blocker_count
            radii[str(radius)] = profile
        answer[name] = {"label": labels[target], "radii": radii}
    return answer


def intersection_profile(blocks: set[frozenset[int]]) -> dict:
    histogram = Counter(len(left & right) for left, right in combinations(blocks, 2))
    return {str(size): histogram[size] for size in sorted(histogram)}


def c218_profiles() -> dict:
    quartic = load_module("c218_quartic", C218)
    base = quartic.load_base()
    field = base.FIELDS[1]
    assert field.q == 9
    blocks = quartic.harmonic_blocks(field)
    n = field.q + 1
    nucleus = n

    nucleus_edges = tuple(sum(1 << point for point in block) for block in blocks)
    nucleus_profile = reliability_profile(nucleus_edges, tuple(range(n)))
    assert nucleus_profile["edge_count"] == n * (n - 1) * (n - 2) // 24
    assert not any(nucleus_profile["failure_by_survivor_count"][6:])
    assert nucleus_profile["failure_by_survivor_count"][5] == 72

    target = 0
    target_blocks = {block for block in blocks if target in block}
    curve_helpers = tuple(point for point in range(n) if point != target)
    curve_edges = tuple(
        (1 << nucleus) | sum(1 << point for point in block if point != target)
        for block in target_blocks
    )
    curve_profile = reliability_profile(curve_edges, (nucleus, *curve_helpers))
    assert curve_profile["edge_count"] == (n - 1) * (n - 2) // 6
    assert all(edge & (1 << nucleus) for edge in curve_edges)
    assert curve_profile["failure_by_survivor_count"][9] == 1
    assert curve_profile["failure_by_survivor_count"][10] == 0

    # The blocks through a point derive an S(2,3,n-1).
    derived = {frozenset(block - {target}) for block in target_blocks}
    assert all(sum(triple.issuperset(pair) for triple in derived) == 1
               for pair in combinations(curve_helpers, 2))

    empirical = intersection_profile(blocks)
    predicted = {
        "0": n * (n - 1) * (n - 2)
        * (n**3 - 19 * n**2 + 122 * n - 248) // 1152,
        "1": n * (n - 1) * (n - 2) * (n - 4) * (n - 8) // 72,
        "2": n * (n - 1) * (n - 2) * (n - 4) // 16,
    }
    assert empirical == {key: value for key, value in predicted.items() if value}

    m = n - 1
    derived_empirical = intersection_profile(derived)
    derived_predicted = {
        "0": m * (m - 1) * (m - 3) * (m - 7) // 72,
        "1": m * (m - 1) * (m - 3) // 8,
    }
    assert derived_empirical == {key: value for key, value in derived_predicted.items() if value}

    return {
        "n": n,
        "nucleus_target": {
            **nucleus_profile,
            "minimum_blocker_size": 5,
            "minimum_blocker_count": 72,
            "block_intersection_pairs": empirical,
            "predicted_block_intersection_pairs": predicted,
        },
        "curve_target": {
            **curve_profile,
            "common_nucleus_helper": nucleus,
            "minimum_blocker_size": 1,
            "minimum_blocker_count": 1,
            "derived_steiner_triple_count": len(derived),
            "derived_intersection_pairs": derived_empirical,
            "predicted_derived_intersection_pairs": derived_predicted,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    certificate = {
        "task": "C219",
        "reliability_basis": (
            "success probability is sum_k a_k*s^k*(1-s)^(N-k), "
            "where a_k is success_by_survivor_count[k]"
        ),
        "c202_q9": c202_profiles(),
        "c218_q9": c218_profiles(),
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
