#!/usr/bin/env python3
"""C77: value-blind existence test for balanced maximum-pencil centers.

For each PGL(2,q) orbit of five conic points A and every maximum C74 pencil
(e,w), enumerate its legal involution centers tau_a.  Compute the five spoke
defects: ordinary C74 product-collision d on secants, and the tangent/chord
intersection count on tangent spokes.  Test existence of the balanced type

    sorted defects = (d_min, 5, 5, 6, 6).

This is geometry only: no grid-game P/N labels are read.  Supports prime q and
GF(25) through c74_fan_orbits.Field.
"""
from collections import Counter
from itertools import combinations
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from c74_fan_orbits import (  # noqa: E402
    Field,
    act,
    line_pencil_summary,
    normalize_pair,
    orbit_map,
    pgl_matrices,
)


def preimage(F, y, zero, infinity):
    if zero == 0 and infinity == F.q:
        return y
    if y == 0:
        return zero
    if y == F.q:
        return infinity
    for t in range(F.q + 1):
        if t in (zero, infinity):
            continue
        if normalize_pair(F, t, zero, infinity) == y:
            return t
    raise AssertionError((F.q, y, zero, infinity))


def tau_image(F, a, t, zero, infinity):
    if t == zero:
        return infinity
    u = normalize_pair(F, t, zero, infinity)
    y = F.q if u == 0 else F.mul(a, F.inv(u))
    return preimage(F, y, zero, infinity)


def secant_defect(F, A, e, image):
    U = [normalize_pair(F, t, e, image) for t in A if t != e]
    assert len(U) == 4 and 0 not in U and F.q not in U
    return len({F.mul(x, y) for x, y in combinations(U, 2)})


def cross(F, x, y):
    return (
        F.sub(F.mul(x[1], y[2]), F.mul(x[2], y[1])),
        F.sub(F.mul(x[2], y[0]), F.mul(x[0], y[2])),
        F.sub(F.mul(x[0], y[1]), F.mul(x[1], y[0])),
    )


def normalize_point(F, x):
    pivot = next(v for v in x if v)
    pi = F.inv(pivot)
    return tuple(F.mul(v, pi) for v in x)


def conic(F, t):
    return (1, 0, 0) if t == F.q else (F.mul(t, t), t, 1)


def tangent(F, t):
    if t == F.q:
        return (0, 0, 1)  # Z=0
    return (1, F.neg(F.add(t, t)), F.mul(t, t))


def tangent_defect(F, A, e):
    line = tangent(F, e)
    others = [t for t in A if t != e]
    hits = {
        normalize_point(F, cross(F, line, cross(F, conic(F, u), conic(F, v))))
        for u, v in combinations(others, 2)
    }
    assert 4 <= len(hits) <= 6
    return len(hits)


def center_defect_vector(F, A, e, w, a):
    out = []
    for f in A:
        image = tau_image(F, a, f, e, w)
        assert image not in A or image == f
        out.append(tangent_defect(F, A, f) if image == f
                   else secant_defect(F, A, f, image))
    return tuple(out)


def center_defects(F, A, e, w, a):
    return tuple(sorted(center_defect_vector(F, A, e, w, a)))


def primary_products(F, A, e, w):
    U = [normalize_pair(F, t, e, w) for t in A if t != e]
    return {F.mul(x, y) for x, y in combinations(U, 2)}


def run(q, details=False):
    F = Field(q)
    group = pgl_matrices(F)
    rows, _owner, _sizes, _stabs = orbit_map(F, 5, group)
    pencils = 0
    missing = []
    multiplicities = Counter()
    type_hist = Counter()
    baer_missing = 0
    for row, A in enumerate(rows):
        _hist, dmin, keys = line_pencil_summary(F, A)
        target = tuple(sorted((dmin, 5, 5, 6, 6)))
        for e, w in keys:
            forbidden = primary_products(F, A, e, w)
            matches = 0
            pencil_types = Counter()
            balanced_parameters = []
            for a in range(1, q):
                if a in forbidden:
                    continue
                defects = center_defects(F, A, e, w, a)
                type_hist[defects] += 1
                pencil_types[defects] += 1
                matches += defects == target
                if defects == target:
                    balanced_parameters.append((a, center_defect_vector(F, A, e, w, a)))
            pencils += 1
            multiplicities[(dmin, matches)] += 1
            if details:
                U = tuple(sorted(normalize_pair(F, t, e, w) for t in A if t != e))
                print(
                    f"BALANCED-PENCIL q={q} row={row} A={A} e={e} w={w} "
                    f"d={dmin} U={U} types={dict(sorted(pencil_types.items()))} "
                    f"balanced={balanced_parameters}"
                )
            if matches == 0:
                six = set((*A, w))
                six_stab = sum({act(F, g, x) for x in six} == six for g in group)
                baer_missing += six_stab == 120
                missing.append((row, A, e, w, dmin, six_stab,
                                dict(sorted(pencil_types.items()))))
    print(
        f"BALANCED-GEOM q={q} rows={len(rows)} pencils={pencils} "
        f"multiplicity={dict(sorted(multiplicities.items()))} missing={len(missing)} "
        f"baer-stab120={baer_missing}"
    )
    if missing:
        print(f"BALANCED-MISSING q={q} examples={missing[:10]}")
    print(f"BALANCED-TYPES q={q} types={dict(sorted(type_hist.items()))}")
    return missing


def run_d4_normal_forms(q):
    """Test the d=4 normal form A={0,+-1,+-x}, (e,w)=(0,infinity)."""
    F = Field(q)
    zero, one = 0, 1
    minus_one = F.neg(one)
    failures = []
    formula_mismatches = []
    histogram = Counter()
    for x in range(q):
        if x in (zero, one, minus_one):
            continue
        A = (zero, one, minus_one, x, F.neg(x))
        if len(set(A)) != 5:
            continue
        forbidden = primary_products(F, A, zero, q)
        assert len(forbidden) == 4
        target = (4, 5, 5, 6, 6)
        types = Counter()
        matches = []
        for a in range(1, q):
            if a in forbidden:
                continue
            defects = center_defects(F, A, zero, q, a)
            types[defects] += 1
            if defects == target:
                matches.append(a)
        def ratio(num, den):
            return None if den == 0 else F.mul(num, F.inv(den))

        three = F.add(one, F.add(one, one))
        candidates = [
            ratio(F.mul(x, F.sub(x, one)), F.add(one, F.mul(three, x))),
            ratio(F.neg(F.mul(x, F.add(x, one))), F.sub(F.mul(three, x), one)),
            ratio(F.neg(F.mul(x, F.sub(x, one))), F.add(x, three)),
            ratio(F.mul(x, F.add(x, one)), F.sub(x, three)),
        ]
        common = ratio(
            F.neg(F.mul(F.add(one, one), F.mul(x, x))),
            F.add(one, F.mul(x, x)),
        )
        candidate_counts = Counter(a for a in candidates if a is not None)
        predicted = sorted(
            a for a, count in candidate_counts.items()
            if count == 1 and a != common and a not in forbidden
        )
        if predicted != matches:
            formula_mismatches.append((x, predicted, matches))
        histogram[len(matches)] += 1
        if not matches:
            failures.append((x, tuple(sorted(forbidden)), dict(sorted(types.items()))))
    print(
        f"BALANCED-D4-NORMAL q={q} x-count={sum(histogram.values())} "
        f"multiplicity={dict(sorted(histogram.items()))} failures={failures} "
        f"formula-mismatches={formula_mismatches}"
    )
    return failures


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("q", type=int, nargs="*", default=[11, 13, 17, 19, 23, 25])
    ap.add_argument("--details", action="store_true")
    ap.add_argument("--normal-forms", action="store_true")
    args = ap.parse_args()
    for q in args.q:
        if args.normal_forms:
            run_d4_normal_forms(q)
        else:
            run(q, args.details)
