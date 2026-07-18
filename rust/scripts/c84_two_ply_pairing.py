#!/usr/bin/env python3
"""Bounded falsification check for a two-ply adaptive pairing certificate in C84."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter
from functools import cache
from pathlib import Path

from c84_pairing_locus import has_abstract_pairing, s4_representatives
from three_centre_probe import (
    centres,
    conic_point,
    determinant,
    grundy as direct_grundy,
    projective_line,
    residual_graph,
    sigma,
)


def induced_graph(adjacency: tuple[int, ...], mask: int) -> tuple[int, ...]:
    vertices = tuple(i for i in range(len(adjacency)) if (mask >> i) & 1)
    index = {old: new for new, old in enumerate(vertices)}
    return tuple(
        sum(1 << index[other] for other in vertices if (adjacency[old] >> other) & 1)
        for old in vertices
    )


@cache
def pairing_position(adjacency: tuple[int, ...]) -> bool:
    return has_abstract_pairing(adjacency)


def pairing_reply_coverage(adjacency: tuple[int, ...]) -> int:
    """Number of first moves answered by a reply leaving a pairing P-position."""
    closed = tuple(mask | (1 << vertex) for vertex, mask in enumerate(adjacency))
    full = (1 << len(adjacency)) - 1
    covered = 0
    for first in range(len(adjacency)):
        follower = full & ~closed[first]
        replies = follower
        while replies:
            bit = replies & -replies
            second = bit.bit_length() - 1
            grandchild = follower & ~closed[second]
            if pairing_position(induced_graph(adjacency, grandchild)):
                covered += 1
                break
            replies ^= bit
    return covered


def probe(q: int, label: str, verify_values: bool) -> dict[str, object]:
    pairing_position.cache_clear()
    parameters = projective_line(q)
    parameter_index = {parameter: i for i, parameter in enumerate(parameters)}
    conic = tuple(conic_point(t, q) for t in parameters)
    points = centres(q)
    perms = {
        point: tuple(parameter_index[sigma(point, t, q)] for t in parameters)
        for point in points
    }
    reps, subgroup_points = s4_representatives(q, points, perms)
    selected = reps[label]
    coverage_histogram: Counter[int] = Counter()
    vertex_histogram: Counter[int] = Counter()
    certified = 0
    value_check_failures = 0
    roots = 0
    for candidate in points:
        if candidate in selected or candidate in subgroup_points:
            continue
        if any(
            determinant((a, b, candidate), q) == 0
            for a, b in itertools.combinations(selected, 2)
        ):
            continue
        _, adjacency, _ = residual_graph((*selected, candidate), parameters, conic, q)
        coverage = pairing_reply_coverage(adjacency)
        roots += 1
        coverage_histogram[coverage] += 1
        vertex_histogram[len(adjacency)] += 1
        if coverage == len(adjacency):
            certified += 1
            if verify_values:
                direct_grundy.cache_clear()
                value = direct_grundy(adjacency, (1 << len(adjacency)) - 1)
                value_check_failures += value != 0
    return {
        "abstract_pairing_cache_entries": pairing_position.cache_info().currsize,
        "atlas_certified_roots": certified,
        "atlas_value_check_failures": value_check_failures if verify_values else None,
        "class": label,
        "first_move_coverage_histogram": {
            str(key): coverage_histogram[key] for key in sorted(coverage_histogram)
        },
        "q": q,
        "roots": roots,
        "selected": [list(point) for point in selected],
        "vertex_histogram": {str(key): vertex_histogram[key] for key in sorted(vertex_histogram)},
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", type=int, nargs="+")
    parser.add_argument("--class", dest="label", choices=tuple("ABCD"), default="D")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    parser.add_argument("--verify-values", action="store_true")
    args = parser.parse_args()
    result = {
        "cases": [probe(q, args.label, args.verify_values) for q in args.q],
        "schema": "c84-two-ply-pairing-v2",
    }
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check is not None:
        if args.check.read_text() != encoded:
            raise SystemExit(f"mismatch: {args.check}")
        print(f"PASS {args.check}")
    elif args.output is not None:
        args.output.write_text(encoded)
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
