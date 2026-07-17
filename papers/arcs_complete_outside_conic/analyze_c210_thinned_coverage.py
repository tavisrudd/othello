#!/usr/bin/env python3
"""Audit how affine coverage changes when the q=64 repair layer is thinned.

The full three-layer orbit-1 arc is affine-complete.  This checker fixes the
two seed layers, records for every seed-uncovered affine target the set of
repair parameters whose seed--repair secants cover it, and exhausts all 256
repair subsets.  It also verifies the general height-coordinate determinant
used for the next symbolic candidate-hypergraph analysis.
"""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path

from analyze_c210_q64_quadratic_orbits import repair_points
from probe_c210_two_layer_parabolas import (
    QuadraticField,
    layer,
    line_points,
)

Point = tuple[int, int, int]


def main() -> None:
    field = QuadraticField.for_subfield_order(8)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    source_path = Path(__file__).with_name(
        "probe_c210_quadratic_coset_repairs_output.txt"
    )
    source = json.loads(source_path.read_text().splitlines()[-1])
    alpha, beta = source["seed_offsets"]
    eta, a, b, c = source["nonlinear_legal_parameters"][0][:4]

    seed_a = tuple(layer(field, alpha, subfield))
    seed_b = tuple(layer(field, beta, subfield))
    seeds = seed_a + seed_b
    repair_by_parameter = {
        r: (1, field.add(eta, r), field.add(
            field.mul(field.add(eta, r), field.add(eta, r)),
            field.add(
                field.add(field.mul(a, field.mul(r, r)), field.mul(b, r)), c
            ),
        ))
        for r in subfield
    }
    assert set(repair_by_parameter.values()) == repair_points(
        field, subfield, eta, a, b, c
    )

    affine_plane = {
        (1, y, z) for y in range(field.q) for z in range(field.q)
    }

    def affine_line(left: Point, right: Point) -> set[Point]:
        line = field.cross(left, right)
        return {
            point for point in line_points(field, line) if point[0] == 1
        }

    def incident(line: Point, point: Point) -> bool:
        value = 0
        for coefficient, coordinate in zip(line, point, strict=True):
            value = field.add(value, field.mul(coefficient, coordinate))
        return value == 0

    seed_covered: set[Point] = set()
    for left, right in itertools.combinations(seeds, 2):
        seed_covered.update(affine_line(left, right))

    repair_coverage = {r: set() for r in subfield}
    candidates = {point: set() for point in affine_plane - seed_covered}
    determinant_checks = 0
    for r, repair in repair_by_parameter.items():
        x = repair[1]
        g = field.add(repair[2], field.mul(x, x))
        for seed in seeds:
            t = seed[1]
            seed_height = field.add(seed[2], field.mul(t, t))
            line = affine_line(repair, seed)
            repair_coverage[r].update(line)
            for target in line:
                if target in candidates:
                    candidates[target].add(r)

            # Check the height-coordinate determinant on every affine target.
            for target in affine_plane:
                y = target[1]
                h = field.add(target[2], field.mul(y, y))
                y_plus_x = field.add(y, x)
                t_plus_x = field.add(t, x)
                determinant = field.add(
                    field.mul(
                        t_plus_x,
                        field.add(
                            field.mul(y_plus_x, y_plus_x), field.add(h, g)
                        ),
                    ),
                    field.mul(
                        y_plus_x,
                        field.add(
                            field.mul(t_plus_x, t_plus_x),
                            field.add(seed_height, g),
                        ),
                    ),
                )
                assert (determinant == 0) == (
                    incident(field.cross(repair, seed), target)
                )
                determinant_checks += 1

    candidate_histogram = Counter(map(len, candidates.values()))
    assert candidate_histogram.get(0, 0) == 0
    singleton_by_parameter = Counter(
        next(iter(values)) for values in candidates.values() if len(values) == 1
    )
    assert set(singleton_by_parameter) == set(subfield)

    covering_subsets = []
    best_proper_uncovered = len(affine_plane)
    for mask in range(1 << len(subfield)):
        chosen = {
            r for index, r in enumerate(subfield) if mask & (1 << index)
        }
        covered = set(seed_covered)
        for r in chosen:
            covered.update(repair_coverage[r])
        uncovered = len(affine_plane - covered)
        if uncovered == 0:
            covering_subsets.append(sorted(chosen))
        if len(chosen) < len(subfield):
            best_proper_uncovered = min(best_proper_uncovered, uncovered)

    assert covering_subsets == [sorted(subfield)]

    print(json.dumps({
        "q": field.q,
        "representative": [eta, a, b, c],
        "seed_covered_affine": len(seed_covered),
        "seed_uncovered_affine": len(candidates),
        "candidate_parameter_histogram": dict(sorted(candidate_histogram.items())),
        "singleton_targets_by_repair_parameter": dict(
            sorted(singleton_by_parameter.items())
        ),
        "repair_subsets_checked": 1 << len(subfield),
        "affine_covering_repair_subsets": covering_subsets,
        "best_proper_subset_uncovered_affine": best_proper_uncovered,
        "height_determinant_checks": determinant_checks,
        "height_determinant":
            "(t+x)*((y+x)^2+h+g)+(y+x)*((t+x)^2+c_seed+g)=0",
        "status":
            "q=64 affine coverage forces the full repair domain; asymptotic "
            "partial coverage requires a new candidate-hypergraph argument",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
