#!/usr/bin/env python3
"""Test the trace-parametrized C210 three-layer family in even square order."""

from __future__ import annotations

import argparse
import itertools
import json
from math import comb

from probe_c210_two_layer_parabolas import (
    QuadraticField,
    covered_points,
    layer,
    projective_points,
)


def probe(s: int) -> dict[str, object]:
    field = QuadraticField.for_subfield_order(s)
    if field.neg(1) != 1:
        raise ValueError("trace-parametrized family currently requires characteristic two")
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    all_points = projective_points(field)
    affine_plane = {point for point in all_points if point[0] == 1}
    conic = ({(0, 0, 1)}
             | {(1, t, field.mul(t, t)) for t in range(field.q)})

    extension_degree = s.bit_length() - 1
    assert 1 << extension_degree == s

    def absolute_trace(x: int) -> int:
        out = 0
        conjugate = x
        for _ in range(extension_degree):
            out = field.add(out, conjugate)
            conjugate = field.mul(conjugate, conjugate)
        return out

    reciprocal_trace_zero = [
        z for z in subfield if z != 0
        if absolute_trace(z) == 0 and absolute_trace(field.inv(z)) == 0
    ]
    kloosterman_sum = sum(
        1 if absolute_trace(field.add(z, field.inv(z))) == 0 else -1
        for z in subfield if z != 0
    )
    assert 4 * len(reciprocal_trace_zero) == s - 3 + kloosterman_sum

    successes = []
    predicted_betas = []
    arc_legal = affine_complete = projective_complete = 0
    for beta in range(field.q):
        if field.in_subfield(beta):
            continue
        relative_trace = field.add(beta, field.power(beta, s))
        assert relative_trace != 0 and field.in_subfield(relative_trace)
        relative_norm = field.mul(beta, field.power(beta, s))
        if (absolute_trace(relative_trace) == 0
                and relative_norm == field.power(relative_trace, 5)):
            assert absolute_trace(field.power(relative_trace, 3)) == 1
            predicted_betas.append(beta)
        beta_cubed = field.mul(field.mul(beta, beta), beta)
        b_squared = field.div(beta_cubed, relative_trace)
        b = field.power(b_squared, field.q // 2)
        assert field.mul(b, b) == b_squared
        a = field.mul(relative_trace, b)
        c = field.inv(b_squared)
        seed = layer(field, 1, subfield) + layer(field, beta, subfield)
        repair = tuple(
            (1, field.add(beta, r), field.add(
                field.mul(field.add(beta, r), field.add(beta, r)),
                field.add(
                    field.add(field.mul(a, field.mul(r, r)), field.mul(b, r)), c
                ),
            ))
            for r in subfield
        )
        arc = seed + repair
        if not set(arc).isdisjoint(conic):
            continue
        lines = {field.cross(x, y) for x, y in itertools.combinations(arc, 2)}
        if len(lines) != comb(len(arc), 2):
            continue
        arc_legal += 1
        uncovered = all_points - covered_points(field, arc)
        affine_uncovered = uncovered & affine_plane
        if affine_uncovered:
            continue
        affine_complete += 1
        infinity_uncovered = sorted(uncovered)
        assert all(point[0] == 0 for point in infinity_uncovered)
        completed = arc + tuple(infinity_uncovered[:2])
        completed_lines = {
            field.cross(x, y) for x, y in itertools.combinations(completed, 2)
        }
        assert len(completed_lines) == comb(len(completed), 2)
        if all_points - covered_points(field, completed):
            continue
        projective_complete += 1
        successes.append({
            "beta": beta,
            "relative_trace": relative_trace,
            "relative_norm": relative_norm,
            "a": a,
            "b": b,
            "c": c,
            "affine_arc_size": len(arc),
            "directions_uncovered": len(infinity_uncovered),
            "projective_completion_size": len(completed),
        })
    assert [row["beta"] for row in successes] == predicted_betas
    return {
        "s": s,
        "q": field.q,
        "beta_tested": field.q - s,
        "arc_legal": arc_legal,
        "affine_complete": affine_complete,
        "projective_complete": projective_complete,
        "predicted_betas": predicted_betas,
        "reciprocal_trace_zero": reciprocal_trace_zero,
        "kloosterman_sum": kloosterman_sum,
        "successes": successes,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("s", nargs="*", type=int, default=[4, 8])
    args = parser.parse_args()
    for s in args.s:
        print(json.dumps(probe(s), sort_keys=True))


if __name__ == "__main__":
    main()
