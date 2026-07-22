#!/usr/bin/env python3
"""Generate the exact C466 Dickson-fusion certificate.

The computation uses only prime-field arithmetic and canonical exhaustive
enumeration.  It reconstructs the frozen golden H3 sheets, the rational
octahedral hinge, their induced PGL2 actions, the characteristic-31 C395 A5,
and the q=41 quadratic Gauss sum.
"""

from __future__ import annotations

import argparse
import cmath
import hashlib
import itertools
import json
from collections import Counter, deque
from pathlib import Path

HERE = Path(__file__).resolve().parent
STEM = "2026-07-21-c466-dickson-fusion-mechanism"
JSON_PATH = HERE / f"{STEM}.json"
SHA_PATH = HERE / f"{STEM}.sha256"
I3 = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
INF = -1
INPUT_STEMS = (
    "2026-07-21-c445-characteristic-11-gluing",
    "2026-07-21-c453-continuation-laws",
    "2026-07-21-c451-roquette-theta",
    "2026-07-21-c455-fourier-weil",
    "2026-07-21-c442-antipodal-singleton-reduction",
    "2026-07-21-c444-silver-fusion",
    "2026-07-21-c458-golden-sheet-frame-freeze",
    "2026-07-20-c395-clebsch-ame-pencil-arithmetic",
)


def inv(a: int, q: int) -> int:
    return pow(a % q, q - 2, q)


def legendre(a: int, q: int) -> int:
    z = pow(a % q, (q - 1) // 2, q)
    return 0 if z == 0 else (1 if z == 1 else -1)


def norm_vec(v: tuple[int, ...], q: int) -> tuple[int, ...]:
    s = inv(next(x for x in v if x % q), q)
    return tuple(s * x % q for x in v)


def norm_mat(m: tuple[tuple[int, ...], ...], q: int) -> tuple[tuple[int, ...], ...]:
    s = inv(next(x for row in m for x in row if x % q), q)
    return tuple(tuple(s * x % q for x in row) for row in m)


def mm(a: tuple[tuple[int, ...], ...], b: tuple[tuple[int, ...], ...], q: int):
    n, r, m = len(a), len(b), len(b[0])
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(r)) % q for j in range(m)) for i in range(n))


def mv(a: tuple[tuple[int, ...], ...], v: tuple[int, ...], q: int) -> tuple[int, ...]:
    return tuple(sum(row[j] * v[j] for j in range(len(v))) % q for row in a)


def transpose(a: tuple[tuple[int, ...], ...]):
    return tuple(zip(*a))


def det3(a: tuple[tuple[int, ...], ...], q: int) -> int:
    return (
        a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
        - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
        + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0])
    ) % q


def inverse3(a, q: int):
    d = det3(a, q)
    assert d
    cof = tuple(
        tuple(
            ((-1) ** (i+j) * (
                a[(i+1)%3][(j+1)%3] * a[(i+2)%3][(j+2)%3]
                - a[(i+1)%3][(j+2)%3] * a[(i+2)%3][(j+1)%3]
            )) % q
            for j in range(3)
        )
        for i in range(3)
    )
    adj = transpose(cof)
    return tuple(tuple(inv(d,q)*x % q for x in row) for row in adj)


def closure3(gens, q: int):
    ident = I3
    out = {ident}
    todo = deque([ident])
    while todo:
        a = todo.popleft()
        for b in gens:
            c = norm_mat(mm(a, b, q), q)
            if c not in out:
                out.add(c)
                todo.append(c)
    return out


def roots(tau: int, q: int):
    out = {(1, 0, 0), (0, 1, 0), (0, 0, 1)}
    for s, t in itertools.product((1, -1), repeat=2):
        v = (1, s * tau % q, t * (tau - 1) % q)
        out |= {norm_vec(v[k:] + v[:k], q) for k in range(3)}
    assert len(out) == 15
    return out


def six_axes(tau: int, q: int):
    return frozenset(
        norm_vec(v, q)
        for v in (
            (0, 1, 1 - tau), (0, 1, tau - 1),
            (1, 1 - tau, 0), (1, tau - 1, 0),
            (1, 0, -tau), (1, 0, tau),
        )
    )


def reflection(v, q: int):
    d = sum(x * x for x in v) % q
    f = 2 * inv(d, q) % q
    return tuple(tuple((int(i == j) - f * v[i] * v[j]) % q for j in range(3)) for i in range(3))


def golden_a5(tau: int, q: int):
    return closure3([reflection(v, q) for v in sorted(roots(tau, q))], q)


def qeval(coeff, v, q: int) -> int:
    x, y, z = v
    a, b, c, d, e, f = coeff
    return (a*x*x + b*y*y + c*z*z + d*x*y + e*x*z + f*y*z) % q


def projective_points(q: int):
    return sorted({norm_vec(v, q) for v in itertools.product(range(q), repeat=3) if any(v)})


def conic_points(coeff, q: int):
    return tuple(p for p in projective_points(q) if qeval(coeff, p, q) == 0)


def standard_matching(tau: int, points, q: int):
    pairs = []
    profile = []
    for axis in sorted(six_axes(tau, q)):
        pair = tuple(p for p in points if sum(axis[i] * p[i] for i in range(3)) % q == 0)
        profile.append(len(pair))
        if len(pair) == 2:
            pairs.append(tuple(sorted(pair)))
    if len(pairs) != 6:
        return None, profile
    ans = tuple(sorted(pairs))
    assert len({p for pair in ans for p in pair}) == 12
    return ans, profile


def rank3(columns, q: int) -> bool:
    return det3(tuple(zip(*columns)), q) != 0


def conic_labels(coeff, points, q: int):
    origin = points[0]
    basis = [(1, 0, 0), (0, 1, 0), (0, 0, 1)]
    uv = next((u, v) for u, v in itertools.permutations(basis, 2) if rank3((origin, u, v), q))
    u, v = uv
    labels = list(range(q)) + [INF]
    label_to_point = {}
    for label in labels:
        direction = u if label == INF else tuple((label * u[i] + v[i]) % q for i in range(3))
        aa = qeval(coeff, direction, q)
        cross = (qeval(coeff, tuple((origin[i] + direction[i]) % q for i in range(3)), q) - aa) % q
        if aa:
            lam = -cross * inv(aa, q) % q
            point = origin if lam == 0 else norm_vec(tuple((origin[i] + lam * direction[i]) % q for i in range(3)), q)
        else:
            assert cross != 0
            point = norm_vec(direction, q)
        assert point in points
        label_to_point[label] = point
    assert len(set(label_to_point.values())) == q + 1
    return label_to_point, {p: x for x, p in label_to_point.items()}


def perm_from_mat3(g, label_to_point, point_to_label, q: int):
    labels = list(range(q)) + [INF]
    return tuple(point_to_label[norm_vec(mv(g, label_to_point[x], q), q)] for x in labels)


def p1_index(x: int, q: int) -> int:
    return q if x == INF else x


def mobius_apply(g, x: int, q: int) -> int:
    a, b, c, d = g
    if x == INF:
        return INF if c == 0 else a * inv(c, q) % q
    den = (c * x + d) % q
    return INF if den == 0 else (a * x + b) * inv(den, q) % q


def pgl2_matrices(q: int):
    seen = set()
    for raw in itertools.product(range(q), repeat=4):
        a, b, c, d = raw
        if (a*d - b*c) % q == 0:
            continue
        g = norm_vec(raw, q)
        if g not in seen:
            seen.add(g)
            yield g


def mobius_perm(g, q: int):
    labels = list(range(q)) + [INF]
    return tuple(mobius_apply(g, x, q) for x in labels)


def pgl_lookup(q: int):
    lookup = {}
    matrices = []
    for g in pgl2_matrices(q):
        p = mobius_perm(g, q)
        key = (p[0], p[1], p[q])
        assert key not in lookup
        lookup[key] = g
        matrices.append(g)
    assert len(matrices) == q * (q*q - 1)
    return tuple(matrices), lookup


def mobius_for_perm(p, lookup, q: int):
    g = lookup[(p[0], p[1], p[q])]
    assert mobius_perm(g, q) == p
    return g


def act_label_matching(g, matching, q: int):
    pairs = (
        tuple(sorted((mobius_apply(g, a, q), mobius_apply(g, b, q)), key=lambda x: p1_index(x, q)))
        for a, b in matching
    )
    return tuple(sorted(pairs))


def label_matching(matching, point_to_label, q: int):
    pairs = (
        tuple(sorted((point_to_label[a], point_to_label[b]), key=lambda x: p1_index(x, q)))
        for a, b in matching
    )
    return tuple(sorted(pairs))


def signed_monomial_hinge(q: int):
    out = set()
    for perm in itertools.permutations(range(3)):
        for signs in itertools.product((1, -1), repeat=3):
            m = tuple(tuple(signs[i] % q if j == perm[i] else 0 for j in range(3)) for i in range(3))
            out.add(norm_mat(m, q))
    assert len(out) == 24
    return out


def subgroup_mobius(group, labels, inverse_labels, lookup, q: int):
    return tuple(sorted(mobius_for_perm(perm_from_mat3(g, labels, inverse_labels, q), lookup, q) for g in group))


def inverse_perm(p, q: int):
    out = [0] * (q + 1)
    for x in list(range(q)) + [INF]:
        out[p1_index(p[p1_index(x, q)], q)] = x
    return tuple(out)


def compose_perm(p, r, q: int):
    labels = list(range(q)) + [INF]
    return tuple(p[p1_index(r[p1_index(x, q)], q)] for x in labels)


def mul2(g, h, q: int):
    a,b,c,d = g
    e,f,k,l = h
    return norm_vec(((a*e+b*k) % q, (a*f+b*l) % q, (c*e+d*k) % q, (c*f+d*l) % q), q)


def inverse2(g, q: int):
    a,b,c,d = g
    return norm_vec((d, -b, -c, a), q)


def closure2(gens, q: int):
    ident = (1,0,0,1)
    out = {ident}
    todo = deque([ident])
    while todo:
        a = todo.popleft()
        for b in gens:
            c = mul2(a, b, q)
            if c not in out:
                out.add(c)
                todo.append(c)
    return out


def small_generators(group, q: int):
    ordered = sorted(group)
    for a in ordered:
        for b in ordered:
            if len(closure2((a,b), q)) == len(group):
                return (a,b)
    raise AssertionError("no two-generator presentation found")


def conjugators(group_a, group_b, matrices, q: int):
    gens = small_generators(group_a, q)
    target = set(group_b)
    found = []
    for g in matrices:
        ig = inverse2(g, q)
        if all(mul2(mul2(g, h, q), ig, q) in target for h in gens):
            found.append(g)
    return found


def orbit(group, point, q: int):
    return frozenset(norm_vec(mv(g, point, q), q) for g in group)


def nullspace(rows, width: int, q: int):
    a = [list(x % q for x in row) for row in rows]
    pivots = []
    r = 0
    for c in range(width):
        pivot = next((i for i in range(r, len(a)) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        s = inv(a[r][c], q)
        a[r] = [s*x % q for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][c]:
                t = a[i][c]
                a[i] = [(a[i][j] - t*a[r][j]) % q for j in range(width)]
        pivots.append(c)
        r += 1
    free = [c for c in range(width) if c not in pivots]
    basis = []
    for f in free:
        v = [0] * width
        v[f] = 1
        for i, c in enumerate(pivots):
            v[c] = -a[i][f] % q
        basis.append(tuple(v))
    return basis


def conic_row(p, q: int):
    x, y, z = p
    return (x*x % q, y*y % q, z*z % q, x*y % q, x*z % q, y*z % q)


def frame_projectivity(source, target, q: int):
    rows = []
    for p, image in zip(source, target):
        x,y,z = image
        r0 = (p[0],p[1],p[2],0,0,0,0,0,0)
        r1 = (0,0,0,p[0],p[1],p[2],0,0,0)
        r2 = (0,0,0,0,0,0,p[0],p[1],p[2])
        rows.extend((
            tuple((y*r2[k]-z*r1[k]) % q for k in range(9)),
            tuple((z*r0[k]-x*r2[k]) % q for k in range(9)),
            tuple((x*r1[k]-y*r0[k]) % q for k in range(9)),
        ))
    ns = nullspace(rows, 9, q)
    assert len(ns) == 1
    v = norm_vec(ns[0], q)
    h = tuple(tuple(v[3*i+j] for j in range(3)) for i in range(3))
    assert det3(h,q)
    return h


def map_point_set(h, points, q: int):
    return frozenset(norm_vec(mv(h,p,q),q) for p in points)


def c395_control(q: int, pgl_mats, lookup, golden_mobius):
    assert q == 31
    assert 8 * inv(3,q) % q == 13
    assert (13*13-13-1) % q == 0 and 1-13 == -12
    a = ((1,0,0),(0,1,0),(0,0,-1))
    b = ((0,1,0),(0,0,1),(2,0,0))
    c = ((1,15,8),(22,11,22),(19,24,12))
    group = closure3((a, b, c), q)
    assert len(group) == 60
    points = projective_points(q)
    unseen = set(points)
    orbits = []
    while unseen:
        o = orbit(group, min(unseen), q)
        orbits.append(o)
        unseen -= o
    candidates = []
    for o in orbits:
        if len(o) < 6 or len(o) > 32:
            continue
        ns = nullspace([conic_row(p, q) for p in o], 6, q)
        if len(ns) == 1:
            coeff = norm_vec(ns[0], q)
            zeros = conic_points(coeff, q)
            if len(zeros) == q + 1 and all(norm_vec(mv(g, p, q), q) in zeros for g in group for p in zeros):
                candidates.append((coeff, zeros))
    unique = {c[0]: c[1] for c in candidates}
    assert len(unique) == 1
    coeff, conic = next(iter(unique.items()))
    labels, inverse_labels = conic_labels(coeff, conic, q)
    c395_mobius = subgroup_mobius(group, labels, inverse_labels, lookup, q)
    c395_six = frozenset(norm_vec(p,q) for p in (
        (0,1,2),(0,1,-2),(1,2,0),(1,-2,0),(1,0,1),(1,0,-1)
    ))
    standard_conic = conic_points((1,1,1,0,0,0),q)
    standard_labels, standard_inverse_labels = conic_labels((1,1,1,0,0,0),standard_conic,q)
    comparisons = []
    for tau, gm in golden_mobius.items():
        cs = conjugators(gm, c395_mobius, pgl_mats, q)
        golden_six = six_axes(tau,q)
        source_order = tuple(sorted(c395_six))
        projectivities = set()
        for target_order in itertools.permutations(sorted(golden_six)):
            h = frame_projectivity(source_order[:4],target_order[:4],q)
            if tuple(norm_vec(mv(h,p,q),q) for p in source_order) == target_order:
                projectivities.add(norm_mat(h,q))
        assert len(projectivities) == 60
        h = min(projectivities)
        hi = inverse3(h,q)
        conjugated = {norm_mat(mm(mm(h,g,q),hi,q),q) for g in group}
        assert conjugated == golden_a5(tau,q)
        cross_perm = tuple(
            standard_inverse_labels[norm_vec(mv(h,labels[x],q),q)]
            for x in list(range(q)) + [INF]
        )
        induced = mobius_for_perm(cross_perm,lookup,q)
        induced_det = (induced[0]*induced[3]-induced[1]*induced[2]) % q
        assert legendre(induced_det,q) == -1
        comparisons.append({
            "golden_tau": tau,
            "pgl2_conjugator_count": len(cs),
            "psl2_conjugator_count": sum(legendre((g[0]*g[3]-g[1]*g[2]) % q, q) == 1 for g in cs),
            "canonical_conjugator": list(min(cs)) if cs else None,
            "direct_six_arc_projectivity_count": len(projectivities),
            "canonical_six_arc_projectivity": [list(row) for row in h],
            "c395_six_arc": [list(p) for p in sorted(c395_six)],
            "golden_six_arc": [list(p) for p in sorted(golden_six)],
            "conjugates_full_projective_a5": True,
            "induced_conic_mobius": list(induced),
            "induced_conic_determinant": induced_det,
            "induced_conic_determinant_legendre": -1,
        })
    maps = {item["golden_tau"]: tuple(tuple(row) for row in item["canonical_six_arc_projectivity"]) for item in comparisons}
    sheet_change = norm_mat(mm(maps[19],inverse3(maps[13],q),q),q)
    coordinate_swap = ((1,0,0),(0,0,1),(0,1,0))
    assert sheet_change == coordinate_swap
    assert coordinate_swap in signed_monomial_hinge(q)
    integral_template = ((0,0,1),(0,2*(1-13)%q,0),(13,0,0))
    assert integral_template == maps[13]
    assert (-8)*(-8) + (-8)*3 - 3*3 == 31
    conic_orbits = sorted(len(orbit(group, p, q)) for p in conic)
    return {
        "group_order": len(group),
        "projective_point_orbit_sizes": sorted(len(o) for o in orbits),
        "invariant_conic_coefficients": list(coeff),
        "invariant_conic_point_count": len(conic),
        "invariant_conic_orbit_sizes": sorted(Counter(conic_orbits).items()),
        "induced_pgl2_group": [list(g) for g in c395_mobius],
        "comparisons": comparisons,
        "direct_identification": "The C395 t=-1 six-arc is projectively equivalent to each golden six-arc, with 60 projectivities in each sheet; every such map conjugates the full A5 stabilizers and induces the outer PGL2 class on the invariant conic.",
        "enhancement_prime_derivation": {
            "golden_parameter_condition": "phi = 8/3 (or its conjugate 1-phi)",
            "minimal_polynomial_evaluation": "(8/3)^2-(8/3)-1 = 31/9",
            "conclusion": "31 is exactly the characteristic in which the C395 t=-1 coordinate ratios collide with the golden H3 six-arc ratios",
        },
        "two_identifications_close_through_hinge": {
            "sheet_change_matrix": [list(row) for row in sheet_change],
            "description": "H_19 H_13^{-1} is the coordinate swap (y z), an element of the same rational octahedral hinge; the two outer identifications differ by the inner sheet-fusion map.",
        },
        "integral_golden_template": {
            "over_Z_phi": "H(phi):(x,y,z) -> (z,2(1-phi)y,phi x)",
            "reduction_phi_to_13": [list(row) for row in integral_template],
            "residual_golden_integer": "3phi-8",
            "norm_formula": "N(a+b phi)=a^2+ab-b^2",
            "norm": 31,
            "exact_scope": "the template maps all six C395 points to the phi=13 golden six-arc precisely on the divisor 3phi-8; the conjugate divisor selects the other residue prime, and the certified hinge swap gives the common-coordinate phi=19 map",
        },
    }


def gauss_certificate(q: int):
    coeff = [0] * q
    for t in range(q):
        coeff[t*t % q] += 1
    square = [0] * q
    for i, a in enumerate(coeff):
        for j, b in enumerate(coeff):
            square[(i+j) % q] += a*b
    diff = square[:]
    diff[0] -= q
    reduced = [x - diff[-1] for x in diff[:-1]]
    assert not any(reduced)
    numeric = sum(coeff[k] * cmath.exp(2j * cmath.pi * k / q) for k in range(q))
    gamma = numeric / (q ** 0.5)
    assert abs(gamma - 1) < 1e-12
    return {
        "q": q,
        "quadratic_residue_exponent_counts": coeff,
        "exact_cyclotomic_identity": "G(q)^2=q in Q(zeta_q)",
        "cyclotomic_reduction_of_G2_minus_q": reduced,
        "canonical_embedding_numeric_G": [numeric.real, numeric.imag],
        "gamma": "+1",
        "ambient_dimension": 3,
        "rho_w_scalar_gamma_to_minus_3": "+1",
        "verdict": "rho(w)=F exactly in the frozen C455 linearization",
    }


def digest(path: Path):
    data = path.read_bytes()
    return {"bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()}


def pinned_inputs():
    out = {}
    for stem in INPUT_STEMS:
        manifest = HERE / f"{stem}.sha256"
        listed = {Path(parts[-1]).name: parts[0] for line in manifest.read_text().splitlines() if len(parts := line.split()) >= 2}
        files = {}
        for ext in ("md", "json"):
            path = HERE / f"{stem}.{ext}"
            got = digest(path)
            if path.name in listed:
                assert listed[path.name] == got["sha256"]
            files[ext] = got
        out[stem] = files
    return out


def prime_certificate(q: int):
    roots_phi = sorted(x for x in range(q) if (x*x - x - 1) % q == 0)
    assert len(roots_phi) == 2
    points = conic_points((1,1,1,0,0,0), q)
    assert len(points) == q + 1
    labels, inverse_labels = conic_labels((1,1,1,0,0,0), points, q)
    pgl_mats, lookup = pgl_lookup(q)
    matchings = {}
    golden_groups = {}
    for tau in roots_phi:
        raw, profile = standard_matching(tau, points, q)
        matchings[tau] = None if raw is None else label_matching(raw, inverse_labels, q)
        group = golden_a5(tau, q)
        assert len(group) == 60
        golden_groups[tau] = subgroup_mobius(group, labels, inverse_labels, lookup, q)
    t0, t1 = roots_phi
    hinge = signed_monomial_hinge(q)
    hinge_mobius = subgroup_mobius(hinge, labels, inverse_labels, lookup, q)
    hinge_psl = [g for g in hinge_mobius if legendre((g[0]*g[3]-g[1]*g[2]) % q, q) == 1]
    hinge_swaps = conjugators(golden_groups[t0], golden_groups[t1], hinge_mobius, q)
    assert len(hinge_swaps) == 12
    stabilizers = conjugators(golden_groups[t0], golden_groups[t0], pgl_mats, q)
    transporters = conjugators(golden_groups[t0], golden_groups[t1], pgl_mats, q)
    psl_transporters = [g for g in transporters if legendre((g[0]*g[3]-g[1]*g[2]) % q, q) == 1]
    expected_fused = legendre(2, q) == 1
    assert len(stabilizers) == 60 and len(transporters) == 60
    assert bool(psl_transporters) == expected_fused
    assert len(hinge_psl) == (24 if expected_fused else 12)
    rz = ((0,-1,0),(1,0,0),(0,0,1))
    rz_mobius = mobius_for_perm(perm_from_mat3(rz, labels, inverse_labels, q), lookup, q)
    assert rz_mobius in transporters
    result = {
        "q": q,
        "residue_class_mod_40": q % 40,
        "golden_roots": roots_phi,
        "legendre_5": legendre(5, q),
        "legendre_2": legendre(2, q),
        "outcome": "fused" if expected_fused else "visible",
        "conic_point_count": len(points),
        "sheet_matchings": {
            str(t): None if matchings[t] is None else [[a if a != INF else "inf", b if b != INF else "inf"] for a,b in matchings[t]]
            for t in roots_phi
        },
        "polar_pair_rationality": "six rational pairs" if matchings[t0] is not None else "the six polar lines have no rational intersection pairs",
        "sheet_stabilizer_orders": [len(stabilizers), len(golden_groups[t1])],
        "pgl2_sheet_transporter_count": len(transporters),
        "psl2_sheet_transporter_count": len(psl_transporters),
        "hinge_order": len(hinge_mobius),
        "hinge_psl_intersection_order": len(hinge_psl),
        "hinge_kernel": "A4" if len(hinge_psl) == 12 else "S4",
        "hinge_sheet_swap_count": len(hinge_swaps),
        "hinge_psl_sheet_swap_count": sum(g in hinge_psl for g in hinge_swaps),
        "rz_mobius": list(rz_mobius),
        "rz_determinant": (rz_mobius[0]*rz_mobius[3]-rz_mobius[1]*rz_mobius[2]) % q,
        "rz_determinant_legendre": legendre((rz_mobius[0]*rz_mobius[3]-rz_mobius[1]*rz_mobius[2]) % q, q),
        "canonical_hinge_swap_mobius": list(min(hinge_swaps)),
        "hinge_mobius_group": [list(g) for g in hinge_mobius],
        "golden_mobius_groups": {str(t): [list(g) for g in golden_groups[t]] for t in roots_phi},
    }
    return result, pgl_mats, lookup, golden_groups


def build_certificate():
    primes = {}
    q31_aux = None
    for q in (11,19,29,31,41):
        result, matrices, lookup, golden = prime_certificate(q)
        primes[str(q)] = result
        if q == 31:
            q31_aux = (matrices, lookup, golden)
    assert q31_aux is not None
    c395 = c395_control(31, *q31_aux)
    arfs = []
    for q in (19,31):
        genus = (q - 1) // 2
        h0 = (genus + 1) // 2
        arf = h0 % 2
        assert (-1 if arf else 1) == legendre(2, q)
        arfs.append({"q": q, "genus": genus, "origin_h0": h0, "arf": arf, "minus_one_to_arf": (-1 if arf else 1), "legendre_2": legendre(2,q)})
    return {
        "schema": "c466-dickson-fusion-mechanism-v1",
        "task": "C466",
        "verdict": "GREEN — at every tested golden-split prime, sheet fusion is equivalent to descent of the rational octahedral hinge S4 into PSL2",
        "inputs": pinned_inputs(),
        "tested_primes": primes,
        "mechanism": {
            "tested_domain": [11,19,29,31,41],
            "equivalence_holds_at_every_tested_prime": True,
            "visible_primes": [11,19,29],
            "fused_primes": [31,41],
            "statement": "The hinge has determinant/spinor squareclasses A4:1 and S4\\A4:2. Thus its sheet-swapping coset enters PSL2(F_q) exactly when (2/q)=+1.",
            "biquadratic_field": "Q(sqrt(2),sqrt(5))",
            "conductor": 40,
            "frobenius_reading": "(5/q) controls existence of the two golden reductions; conditional on splitting, (2/q) controls PSL-distinctness versus fusion.",
            "aligned_faces": ["C450/C445: det(Rz)=spinor-norm 2", "C451: (-1)^Arf=(2/q) for q=11,19,31 under the invariant-origin odd-genus model"],
        },
        "arf_face": arfs,
        "characteristic_31_a5_control": c395,
        "weil_gauss_faces": {"29": gauss_certificate(29), "41": gauss_certificate(41)},
        "boundaries": {
            "no_H4_parent_claim": True,
            "no_continuation_claim": True,
            "c395_comparison_scope": "exact conjugacy of the induced conic actions inside PGL2(31)/PSL2(31), plus point-orbit data; no geometric identification of the two six-point objects",
            "gauss_scope": "ambient dimension-three Weyl operator in C455's fixed Schrödinger convention; no whole-Weil-module claim for a restricted orbit space",
        },
    }


def canonical_bytes(obj) -> bytes:
    return (json.dumps(obj, indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes() -> bytes:
    names = [f"{STEM}.md", f"{STEM}.py", f"{STEM}-replay.py", f"{STEM}.json"]
    return "".join(f"{hashlib.sha256((HERE/name).read_bytes()).hexdigest()}  notes/{name}\n" for name in names).encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write-manifest", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build_certificate())
    if args.check:
        assert JSON_PATH.read_bytes() == data
        assert SHA_PATH.read_bytes() == manifest_bytes()
        print("C466 certificate and manifest: OK")
        return
    JSON_PATH.write_bytes(data)
    if args.write_manifest:
        SHA_PATH.write_bytes(manifest_bytes())
    print(f"wrote {JSON_PATH.name}")


if __name__ == "__main__":
    main()
