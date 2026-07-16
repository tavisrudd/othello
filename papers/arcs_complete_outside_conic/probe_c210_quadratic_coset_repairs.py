#!/usr/bin/env python3
"""C210 targeted probe: quadratic-height repairs over one additive F-coset.

The probe uses the repair-graph equations before any projective incidence
check.  For g(r)=a*r^2+b*r+c, internal repair triples are legal exactly when
a+1 != 0.  Each possible two-repair/one-seed collision is reduced to whether
one explicitly determined polynomial X^2-pX+q has two distinct roots in F.
"""

from __future__ import annotations

import argparse
import itertools
import json
from math import comb

from probe_c210_two_layer_parabolas import (
    QuadraticField,
    additive_cosets,
    covered_points,
    greedy_relative_completion,
    layer,
    profile,
    projective_points,
    run,
)


def quadratic_value(field: QuadraticField, a: int, b: int, c: int, r: int) -> int:
    return field.add(field.add(field.mul(a, field.mul(r, r)), field.mul(b, r)), c)


def sum_product_for_seed(field: QuadraticField, subfield: tuple[int, ...],
                         eta: int, a_plus_one: int, b: int, c: int,
                         t: int, seed_height: int) -> tuple[int, int]:
    """Return the unique p,q in F forced by a two-repair/one-seed collision."""
    T = field.sub(t, eta)
    numerator = field.sub(
        field.add(field.add(field.neg(field.mul(T, T)), field.mul(b, T)), c),
        seed_height,
    )
    w = field.div(numerator, a_plus_one)
    solutions = []
    for p in subfield:
        q = field.add(w, field.mul(T, p))
        if field.in_subfield(q):
            solutions.append((p, q))
    assert len(solutions) == 1
    return solutions[0]


def splits_distinctly(field: QuadraticField, subfield: tuple[int, ...],
                      p: int, q: int) -> bool:
    roots = [
        r for r in subfield
        if field.add(field.sub(field.mul(r, r), field.mul(p, r)), q) == 0
    ]
    return len(roots) >= 2


def probe(s: int) -> dict[str, object]:
    field = QuadraticField.for_subfield_order(s)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    baseline = run(s)
    alpha, beta = baseline["best_offsets"]
    assert isinstance(alpha, int) and isinstance(beta, int)
    seed = layer(field, alpha, subfield) + layer(field, beta, subfield)
    all_points = projective_points(field)
    conic = ({(0, 0, 1)}
             | {(1, t, field.mul(t, t)) for t in range(field.q)})
    legal_extensions = all_points - conic - covered_points(field, seed)

    tested = internal_arc = off_conic = seed_point_legal = pair_legal = complete = 0
    best: tuple[int, int, int, int, int, int] | None = None
    best_arc = None
    nonlinear_legal = []
    for coset in additive_cosets(field, subfield)[1:]:
        eta = coset[0]
        parameters = tuple((y, field.sub(y, eta)) for y in coset)
        assert all(r in subfield for _, r in parameters)
        for a, b, c in itertools.product(range(field.q), repeat=3):
            tested += 1
            a_plus_one = field.add(a, 1)
            if a_plus_one == 0:
                continue
            internal_arc += 1
            heights = tuple(quadratic_value(field, a, b, c, r) for _, r in parameters)
            if 0 in heights:
                continue
            off_conic += 1
            repair = tuple(
                (1, y, field.add(field.mul(y, y), height))
                for (y, _), height in zip(parameters, heights)
            )
            if not set(repair) <= legal_extensions:
                continue
            seed_point_legal += 1
            collision = False
            for t, seed_height in itertools.product(subfield, (alpha, beta)):
                p, q = sum_product_for_seed(
                    field, subfield, eta, a_plus_one, b, c, t, seed_height
                )
                if splits_distinctly(field, subfield, p, q):
                    collision = True
                    break
            if collision:
                continue
            pair_legal += 1
            arc = seed + repair
            lines = {field.cross(x, y) for x, y in itertools.combinations(arc, 2)}
            assert len(lines) == comb(len(arc), 2)
            required_uncovered, ordinary_uncovered = profile(field, arc, all_points, conic)
            if a != 0:
                nonlinear_legal.append([
                    eta, a, b, c, required_uncovered, ordinary_uncovered
                ])
            if required_uncovered == 0:
                complete += 1
            result = (required_uncovered, ordinary_uncovered, eta, a, b, c)
            if best is None or result < best:
                best = result
                best_arc = arc
    if best_arc is None:
        completed = None
        completed_ordinary = None
    else:
        completed = greedy_relative_completion(field, best_arc, all_points, conic)
        _, completed_ordinary = profile(field, completed, all_points, conic)
    return {
        "s": s,
        "q": field.q,
        "seed_offsets": [alpha, beta],
        "tested": tested,
        "internal_repair_arc": internal_arc,
        "off_conic": off_conic,
        "repair_points_seed_legal": seed_point_legal,
        "full_arc_legal": pair_legal,
        "nonlinear_full_arc_legal": len(nonlinear_legal),
        "nonlinear_legal_parameters": nonlinear_legal,
        "relative_complete": complete,
        "best_required_uncovered": None if best is None else best[0],
        "best_ordinary_uncovered": None if best is None else best[1],
        "best_coset_representative": None if best is None else best[2],
        "best_quadratic": None if best is None else list(best[3:]),
        "greedy_completed_k": None if completed is None else len(completed),
        "greedy_added": None if completed is None else [
            list(point) for point in completed[3 * s:]
        ],
        "greedy_final_ordinary_uncovered": completed_ordinary,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("s", nargs="*", type=int, default=[3, 4, 5])
    args = parser.parse_args()
    for s in args.s:
        print(json.dumps(probe(s), sort_keys=True))


if __name__ == "__main__":
    main()
