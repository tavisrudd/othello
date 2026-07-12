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


def three_pairings(xs):
    a, b, c, d = xs
    return (((a, b), (c, d)), ((a, c), (b, d)), ((a, d), (b, c)))


def collision_parameter(F, f, left, right):
    """Nontrivial tau_a parameter for one opposite-edge collision at f."""
    p, q = left
    r, s = right
    alpha = F.mul(F.sub(p, f), F.sub(q, f))
    beta = F.mul(F.sub(r, f), F.sub(s, f))
    lead = F.sub(alpha, beta)
    if lead == 0:
        return None
    constant = F.sub(F.mul(alpha, F.mul(r, s)),
                     F.mul(beta, F.mul(p, q)))
    # The quadratic in b=tau_a(f) has one root b=f.  Product of roots
    # is constant/lead, so the other center parameter is a=f*b.
    return F.mul(constant, F.inv(lead))


def collision_certificate_degrees(F, A, primary=0):
    degrees = Counter()
    by_parameter = {}
    for f in A:
        if f == primary:
            continue
        others = tuple(x for x in A if x != f)
        for left, right in three_pairings(others):
            a = collision_parameter(F, f, left, right)
            if a is not None and a != 0:
                degrees[a] += 1
                by_parameter.setdefault(a, []).append((f, left, right))
    return degrees, by_parameter


def directed_collision_parameter(F, U, f, g):
    h, k = (x for x in U if x not in (f, g))
    return collision_parameter(F, f, (0, g), (h, k))


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


def run_d5_normal_forms(q, details=False):
    """Test maximum d=5 normal forms A={0,1,r,s,rs}."""
    F = Field(q)
    seen = set()
    pencils = 0
    multiplicities = Counter()
    formula_mismatches = []
    degree_hist = Counter()
    ledger_hist = Counter()
    ledger_violations = []
    nonmaximum_controls = Counter()
    pairing_identity_mismatches = []
    pole_pattern_controls = Counter()
    forbidden_pattern_controls = Counter()
    forbidden_pattern_violations = []
    forbidden_assignment_controls = Counter()
    failures = []
    for r in range(1, q):
        for s in range(1, q):
            A = tuple(sorted((0, 1, r, s, F.mul(r, s))))
            if len(set(A)) != 5 or A in seen:
                continue
            seen.add(A)
            forbidden = primary_products(F, A, 0, q)
            if len(forbidden) != 5:
                continue
            _hist, dmin, keys = line_pencil_summary(F, A)
            t = F.mul(r, s)
            U = (1, r, s, t)
            paired_edges = (
                ((1, r), (s, t)),
                ((1, s), (r, t)),
                ((r, 1), (t, s)),
                ((s, 1), (t, r)),
            )
            for edge1, edge2 in paired_edges:
                value1 = directed_collision_parameter(F, U, *edge1)
                value2 = directed_collision_parameter(F, U, *edge2)
                if value1 != value2:
                    pairing_identity_mismatches.append((A, edge1, value1,
                                                        edge2, value2))
            directed_values = {
                (f, g): directed_collision_parameter(F, U, f, g)
                for f in U for g in U if f != g
            }
            grouped_values = {
                "P1r": directed_values[(1, r)],
                "P1s": directed_values[(1, s)],
                "Pr1": directed_values[(r, 1)],
                "Ps1": directed_values[(s, 1)],
                "S1t": directed_values[(1, t)],
                "St1": directed_values[(t, 1)],
                "Srs": directed_values[(r, s)],
                "Ssr": directed_values[(s, r)],
            }
            if dmin != 5 or (0, q) not in keys:
                degrees, _certs = collision_certificate_degrees(F, A)
                legal_degrees = [degrees[a] for a in range(1, q)
                                 if a not in forbidden]
                if details and sum(degrees.values()) < 10:
                    directed = {
                        (f, g): directed_collision_parameter(F, U, f, g)
                        for f in U for g in U if f != g
                    }
                    print(
                        f"BALANCED-D5-POLE-CONTROL q={q} A={A} dmin={dmin} "
                        f"d4keys={keys} directed={directed}"
                    )
                nonmaximum_controls[(dmin,
                                     sum(degrees.values()) < 10,
                                     sum(degrees[a] for a in forbidden) > 3,
                                     sum(d == 1 for d in legal_degrees) > 4,
                                     max(legal_degrees, default=0) > 2)] += 1
                poles = tuple(sorted(edge for edge, value in directed_values.items()
                                     if value is None))
                if len(poles) >= 3:
                    role = {1: "1", r: "r", s: "s", t: "t"}
                    role_poles = tuple(sorted((role[f], role[g]) for f, g in poles))
                    pole_pattern_controls[(role_poles, len(keys))] += 1
                forbidden_groups = tuple(sorted(
                    name for name, value in grouped_values.items()
                    if value is not None and value in forbidden
                ))
                forbidden_group_weight = sum(
                    2 if name.startswith("P") else 1 for name in forbidden_groups
                )
                if forbidden_group_weight > 3:
                    forbidden_pattern_controls[(forbidden_groups, len(keys))] += 1
                    paired_names = [name for name in forbidden_groups
                                    if name.startswith("P")]
                    singleton_names = [name for name in forbidden_groups
                                       if name.startswith("S")]
                    if (len(paired_names) != 1 or len(singleton_names) != 2
                            or not any(grouped_values[paired_names[0]]
                                       == grouped_values[name]
                                       for name in singleton_names)):
                        forbidden_pattern_violations.append(
                            (A, forbidden_groups, grouped_values)
                        )
                    forbidden_names = {
                        r: "r",
                        s: "s",
                        t: "t",
                        F.mul(r, t): "rt",
                        F.mul(s, t): "st",
                    }
                    assignments = tuple(
                        (name, forbidden_names[grouped_values[name]])
                        for name in forbidden_groups
                    )
                    forbidden_assignment_controls[(assignments, len(keys))] += 1
                    if details:
                        print(
                            f"BALANCED-D5-FORBIDDEN-CONTROL q={q} A={A} "
                            f"r={r} s={s} t={t} "
                            f"forbidden={sorted(forbidden)} groups={forbidden_groups} "
                            f"values={grouped_values} d4keys={keys}"
                        )
                continue
            pencils += 1
            matches = []
            for a in range(1, q):
                if a in forbidden:
                    continue
                if center_defects(F, A, 0, q, a) == (5, 5, 5, 6, 6):
                    matches.append(a)
            degrees, certs = collision_certificate_degrees(F, A)
            predicted = sorted(a for a, degree in degrees.items()
                               if degree == 2 and a not in forbidden)
            if predicted != matches:
                formula_mismatches.append((A, predicted, matches,
                                           dict(sorted(degrees.items()))))
            degree_hist.update(degrees[a] for a in range(1, q) if a not in forbidden)
            legal_positive = Counter(
                degrees[a] for a in range(1, q)
                if a not in forbidden and degrees[a] > 0
            )
            ledger_hist[(sum(degrees.values()),
                         sum(degrees[a] for a in forbidden),
                         legal_positive.get(1, 0),
                         legal_positive.get(2, 0))] += 1
            forbidden_weight = sum(degrees[a] for a in forbidden)
            degree_one_sources = Counter(
                certs[a][0][0] for a in range(1, q)
                if a not in forbidden and degrees[a] == 1
            )
            max_legal_degree = max((degrees[a] for a in range(1, q)
                                    if a not in forbidden), default=0)
            if (sum(degrees.values()) < 10 or forbidden_weight > 3
                    or legal_positive.get(1, 0) > 4 or max_legal_degree > 2
                    or max(degree_one_sources.values(), default=0) > 1):
                ledger_violations.append((A, sum(degrees.values()), forbidden_weight,
                                          legal_positive.get(1, 0),
                                          max_legal_degree,
                                          dict(degree_one_sources)))
            multiplicities[len(matches)] += 1
            if not matches:
                failures.append(A)
            if details and len(matches) == 2:
                compact_certs = {}
                for a, rows in certs.items():
                    compact_certs[a] = [
                        (f, next(v for pair in (left, right) if 0 in pair
                                 for v in pair if v != 0))
                        for f, left, right in rows
                    ]
                print(
                    f"BALANCED-D5-TIGHT q={q} A={A} forbidden={sorted(forbidden)} "
                    f"matches={matches} degrees={dict(sorted(degrees.items()))} "
                    f"edges={dict(sorted(compact_certs.items()))}"
                )
    print(
        f"BALANCED-D5-NORMAL q={q} forms={pencils} "
        f"multiplicity={dict(sorted(multiplicities.items()))} "
        f"legal-certificate-degrees={dict(sorted(degree_hist.items()))} "
        f"ledger(total,forbidden,n1,n2)={dict(sorted(ledger_hist.items()))} "
        f"failures={failures} formula-mismatches={formula_mismatches[:10]} "
        f"ledger-violations={ledger_violations[:10]} "
        f"pairing-identity-mismatches={pairing_identity_mismatches[:10]} "
        f"nonmaximum-controls={dict(sorted(nonmaximum_controls.items()))} "
        f"pole-pattern-controls={dict(sorted(pole_pattern_controls.items()))} "
        f"forbidden-pattern-controls={dict(sorted(forbidden_pattern_controls.items()))} "
        f"forbidden-pattern-violations={forbidden_pattern_violations[:10]} "
        f"forbidden-assignment-controls={dict(sorted(forbidden_assignment_controls.items()))}"
    )
    return failures


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("q", type=int, nargs="*", default=[11, 13, 17, 19, 23, 25])
    ap.add_argument("--details", action="store_true")
    ap.add_argument("--normal-forms", action="store_true")
    ap.add_argument("--d5-normal-forms", action="store_true")
    args = ap.parse_args()
    for q in args.q:
        if args.d5_normal_forms:
            run_d5_normal_forms(q, args.details)
        elif args.normal_forms:
            run_d4_normal_forms(q)
        else:
            run(q, args.details)
