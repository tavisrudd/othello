#!/usr/bin/env python3
"""Decompose q=64 C210 affine coverage by secant type."""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path

from probe_c210_two_layer_parabolas import (
    QuadraticField,
    additive_cosets,
    layer,
    line_points,
)
from analyze_c210_q64_quadratic_orbits import repair_points

Point = tuple[int, int, int]


def main() -> None:
    field = QuadraticField.for_subfield_order(8)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    record = json.loads(
        Path(__file__).with_name(
            "probe_c210_quadratic_coset_repairs_output.txt"
        ).read_text().splitlines()[-1]
    )
    alpha, beta = record["seed_offsets"]
    eta, a, b, c = record["nonlinear_legal_parameters"][0][:4]
    labelled: list[tuple[str, Point]] = []
    labelled.extend(("A", point) for point in layer(field, alpha, subfield))
    labelled.extend(("B", point) for point in layer(field, beta, subfield))
    labelled.extend(
        ("R", point) for point in sorted(repair_points(field, subfield, eta, a, b, c))
    )

    category_names = ("AA", "AB", "AR", "BB", "BR", "RR")
    covered: dict[str, set[Point]] = {name: set() for name in category_names}
    for (left_label, left), (right_label, right) in itertools.combinations(labelled, 2):
        category = "".join(sorted((left_label, right_label)))
        line = field.cross(left, right)
        covered[category].update(
            point for point in line_points(field, line) if point[0] == 1
        )

    affine_plane = {
        (1, y, z) for y in range(field.q) for z in range(field.q)
    }
    additive_cosets_list = additive_cosets(field, subfield)

    def absolute_trace(x: int) -> int:
        return field.add(field.add(x, field.mul(x, x)), field.power(x, 4))

    trace_set_checks = 0
    for U in range(field.q):
        if field.in_subfield(U):
            continue
        pair_values = {
            field.add(field.mul(U, field.add(r, s)), field.mul(r, s))
            for r, s in itertools.combinations(subfield, 2)
        }
        trace_values = {
            field.add(field.mul(U, p), q)
            for p in subfield if p != 0
            for q in subfield
            if absolute_trace(field.div(q, field.mul(p, p))) == 0
        }
        assert pair_values == trace_values
        assert len(pair_values) == 28
        trace_set_checks += 1

    def profile(categories: tuple[str, ...]) -> dict[str, object]:
        union = set().union(*(covered[name] for name in categories))
        uncovered = affine_plane - union
        by_coset = Counter(
            next(i for i, coset in enumerate(additive_cosets_list) if point[1] in coset)
            for point in uncovered
        )
        return {
            "categories": list(categories),
            "uncovered_affine": len(uncovered),
            "uncovered_by_y_coset": dict(sorted(by_coset.items())),
        }

    covering_subsets = []
    for size in range(1, len(category_names) + 1):
        for categories in itertools.combinations(category_names, size):
            if profile(categories)["uncovered_affine"] == 0:
                covering_subsets.append(list(categories))
        if covering_subsets:
            break

    per_category_fiber_sizes = {}
    for name in category_names:
        counts = Counter(point[1] for point in covered[name])
        per_category_fiber_sizes[name] = {
            "covered_affine": len(covered[name]),
            "min_heights_per_fiber": min(counts.get(y, 0) for y in range(field.q)),
            "max_heights_per_fiber": max(counts.get(y, 0) for y in range(field.q)),
        }

    print(json.dumps({
        "q": field.q,
        "representative": [eta, a, b, c],
        "trace_set_checks": trace_set_checks,
        "category_profiles": per_category_fiber_sizes,
        "minimal_covering_category_subsets": covering_subsets,
        "named_profiles": [
            profile(("AA", "BB", "RR")),
            profile(("AB", "AR", "BR")),
            profile(("AA", "AB", "AR", "BR")),
            profile(("AB", "AR", "BB", "BR")),
            profile(("AB", "AR", "BR", "RR")),
            profile(("AA", "AB", "BB", "RR")),
            profile(category_names),
        ],
    }, sort_keys=True))


if __name__ == "__main__":
    main()
