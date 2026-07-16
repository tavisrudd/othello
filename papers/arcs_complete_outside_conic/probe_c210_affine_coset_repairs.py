#!/usr/bin/env python3
"""C210 targeted probe: affine-height repairs over one additive F-coset.

For the best two-layer seed selected by probe_c210_two_layer_parabolas.py,
test full repair graphs with y=eta+r and height g(r)=a*r+b, r in F.  This is
an algebraic function-class test, not an arbitrary arc census.
"""

from __future__ import annotations

import argparse
import itertools
import json
from math import comb

from probe_c210_two_layer_parabolas import (
    QuadraticField,
    additive_cosets,
    layer,
    profile,
    projective_points,
    run,
)


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

    tested = off_conic = legal = complete = 0
    best: tuple[int, int, int, int, int] | None = None
    for coset in additive_cosets(field, subfield)[1:]:
        eta = coset[0]
        parameters = tuple((y, field.sub(y, eta)) for y in coset)
        assert all(r in subfield for _, r in parameters)
        for slope, intercept in itertools.product(range(field.q), repeat=2):
            tested += 1
            repair = tuple(
                (1, y, field.add(
                    field.mul(y, y),
                    field.add(field.mul(slope, r), intercept),
                ))
                for y, r in parameters
            )
            if not set(repair).isdisjoint(conic):
                continue
            off_conic += 1
            arc = seed + repair
            lines = {field.cross(x, y) for x, y in itertools.combinations(arc, 2)}
            if len(lines) != comb(len(arc), 2):
                continue
            legal += 1
            required_uncovered, ordinary_uncovered = profile(field, arc, all_points, conic)
            if required_uncovered == 0:
                complete += 1
            result = (required_uncovered, ordinary_uncovered, eta, slope, intercept)
            if best is None or result < best:
                best = result
    return {
        "s": s,
        "q": field.q,
        "seed_offsets": [alpha, beta],
        "tested": tested,
        "off_conic": off_conic,
        "arc_legal": legal,
        "relative_complete": complete,
        "best_required_uncovered": None if best is None else best[0],
        "best_ordinary_uncovered": None if best is None else best[1],
        "best_coset_representative": None if best is None else best[2],
        "best_slope": None if best is None else best[3],
        "best_intercept": None if best is None else best[4],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("s", nargs="*", type=int, default=[3, 4, 5, 7, 8])
    args = parser.parse_args()
    for s in args.s:
        print(json.dumps(probe(s), sort_keys=True))


if __name__ == "__main__":
    main()
