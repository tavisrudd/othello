#!/usr/bin/env python3
"""Frozen q=11 entry test and q=13/q=17/q=19 controls for a d=4 boundary signature.

The signature is defined without P/N values.  For an initial d=4 center z_a it is
the finite colored relational graph on D_0 union D_a:

* vertices are every projective point of the two defect lines (their common
  point occurs once);
* vertex color is (D_0-only, D_a-only, intersection) times
  (selected, already deleted, legal);
* relation I joins two unselected vertices exactly when their joining line
  contains one of the selected six points (so the two moves are incompatible);
* relation S is the involution sigma:(X:Y:Z)->(X:-Y:Z), including fixed loops.

Thus an isomorphism must preserve sigma.  Passing to sigma-orbits turns I into a
signed quotient; changing a lift representative performs vertex switching, so
all Z/2 cycle voltages are retained.  P/N labels are read only with --unblind,
after this definition and the exact geometry classes have been printed.

No solve is performed.  Run from rust/:

    python3 scripts/r5_q11_voltage_signature.py --geometry
    python3 scripts/r5_q11_voltage_signature.py --unblind
    python3 scripts/r5_q11_voltage_signature.py --q 13 --unblind
    python3 scripts/r5_q11_voltage_signature.py --q 17 --unblind
    python3 scripts/r5_q11_voltage_signature.py --q 19 --unblind
"""

from collections import Counter
import argparse
from itertools import combinations, permutations
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import DATA, PRIME_FILES, analyze, inv, parse
from c74_line_pencil import INF, line_product_data


def chi(x, q):
    x %= q
    return 0 if x == 0 else (1 if pow(x, (q - 1) // 2, q) == 1 else -1)


def norm(p, q):
    p = tuple(x % q for x in p)
    for x in p:
        if x:
            z = inv(x, q)
            return tuple(y * z % q for y in p)
    raise ValueError("zero projective vector")


def det(a, b, c, q):
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % q


def mobius_matrix(F, w, q):
    """Matrix [alpha beta; gamma delta] for F->0,w->infinity."""
    F = 0 if F == "0" else F
    if F == INF:
        return (0, 1, 1, -w % q)
    if w == INF:
        return (1, -F % q, 0, 1)
    return (1, -F % q, 1, -w % q)


def transformed_center_a(rec, key, cell):
    """Lift the P1 Mobius map by Sym^2 and read z_a=(-a:0:1)."""
    q = rec["q"]
    F, w = key
    alpha, beta, gamma, delta = mobius_matrix(F, w, q)
    r, c = cell
    # H^{-1}(r:c:1), where H C(t)=(t^2+rho*t:A*t+B:t).
    v0 = (r - rec["rho"]) % q
    v1 = 1
    v2 = (c - rec["A"]) * inv(rec["B"], q) % q
    X = (alpha * alpha * v0 + 2 * alpha * beta * v1 + beta * beta * v2) % q
    Y = (alpha * gamma * v0 + (alpha * delta + beta * gamma) * v1
         + beta * delta * v2) % q
    Z = (gamma * gamma * v0 + 2 * gamma * delta * v1 + delta * delta * v2) % q
    assert Y == 0 and Z != 0, (rec["cls"], key, cell, (X, Y, Z))
    return -X * inv(Z, q) % q


def build_graph(U, a, q, live_only=False):
    """Return (node colors, symmetric relation matrix) for the frozen signature."""
    C = lambda t: norm((t * t, t, 1), q)
    c0 = C(0)
    za = norm((-a, 0, 1), q)
    selected = {c0, za, *(C(u) for u in U)}
    assert len(selected) == 6
    selected_list = sorted(selected)
    assert all(det(x, y, z, q) for x, y, z in combinations(selected_list, 3))

    locations = {}
    for p in range(q):
        locations.setdefault(norm((0, 1, p), q), set()).add("0")
        locations.setdefault(norm((-a * p, 1, p), q), set()).add("a")
    locations.setdefault(c0, set()).add("0")
    locations.setdefault(za, set()).add("a")
    points = sorted(locations)
    index = {p: i for i, p in enumerate(points)}
    assert len(points) == 2 * (q + 1) - 1

    def status(p):
        if p in selected:
            return "S"
        if any(det(p, x, y, q) == 0 for x, y in combinations(selected_list, 2)):
            return "D"
        return "L"

    colors = []
    for p in points:
        loc = "I" if len(locations[p]) == 2 else next(iter(locations[p]))
        colors.append((loc, status(p)))

    # Bit 0 = incompatibility I; bit 1 = sigma relation S.
    n = len(points)
    rel = [[0] * n for _ in range(n)]
    for i, x in enumerate(points):
        if colors[i][1] == "S":
            continue
        for j in range(i + 1, n):
            y = points[j]
            if colors[j][1] != "S" and any(det(x, y, s, q) == 0 for s in selected):
                rel[i][j] |= 1
                rel[j][i] |= 1
    for i, (X, Y, Z) in enumerate(points):
        j = index[norm((X, -Y, Z), q)]
        rel[i][j] |= 2
        rel[j][i] |= 2
    if live_only:
        keep = [i for i, color in enumerate(colors) if color[1] == "L"]
        return ([colors[i][0] for i in keep],
                [[rel[i][j] for j in keep] for i in keep])
    return colors, rel


def joint_refine(g1, g2):
    """Joint 1-WL refinement, used only to prune exact backtracking."""
    graphs = (g1, g2)
    palette = {c: i for i, c in enumerate(sorted(set(g1[0] + g2[0])))}
    cols = [[palette[c] for c in g[0]] for g in graphs]
    while True:
        keys = []
        for gi, (_, rel) in enumerate(graphs):
            keys.append([
                (cols[gi][i], tuple(sorted((rel[i][j], cols[gi][j])
                                            for j in range(len(rel)) if rel[i][j])))
                for i in range(len(rel))
            ])
        pal = {k: i for i, k in enumerate(sorted(set(keys[0] + keys[1])))}
        nxt = [[pal[k] for k in kk] for kk in keys]
        if nxt == cols:
            return cols
        cols = nxt


def isomorphic(g1, g2, want_mapping=False):
    """Exact color- and relation-preserving isomorphism by refined backtracking."""
    if len(g1[0]) != len(g2[0]) or Counter(g1[0]) != Counter(g2[0]):
        return None if want_mapping else False
    cols = joint_refine(g1, g2)
    if Counter(cols[0]) != Counter(cols[1]):
        return None if want_mapping else False
    r1, r2 = g1[1], g2[1]
    n = len(r1)
    buckets = {}
    for j, c in enumerate(cols[1]):
        buckets.setdefault(c, []).append(j)
    mapping = {}
    used = set()

    def search():
        if len(mapping) == n:
            return True
        best_i = None
        best_cands = None
        for i in range(n):
            if i in mapping:
                continue
            cs = []
            for j in buckets[cols[0][i]]:
                if j in used or r1[i][i] != r2[j][j]:
                    continue
                if all(r1[i][ii] == r2[j][jj] for ii, jj in mapping.items()):
                    cs.append(j)
            if not cs:
                return False
            if best_cands is None or len(cs) < len(best_cands):
                best_i, best_cands = i, cs
        for j in best_cands:
            mapping[best_i] = j
            used.add(j)
            if search():
                return True
            used.remove(j)
            del mapping[best_i]
        return False

    ok = search()
    if want_mapping:
        return dict(mapping) if ok else None
    return ok


def graph_stats(g):
    colors, rel = g
    return (
        tuple(sorted(Counter(colors).items())),
        sum(bool(rel[i][j] & 1) for i in range(len(rel)) for j in range(i + 1, len(rel))),
        (len(colors) if not colors or isinstance(colors[0], str)
         else sum(colors[i][1] == "L" for i in range(len(colors)))),
    )


def live_trace_profiles(U, a, q):
    """Per-live-vertex counts of I-neighbors by full side/status color."""
    colors, rel = build_graph(U, a, q, False)
    live = [i for i, color in enumerate(colors) if color[1] == "L"]
    return [tuple(sorted(Counter(
        colors[j] for j in range(len(colors)) if rel[i][j] & 1
    ).items())) for i in live]


def inverse3(matrix, q):
    a, b, c = matrix[0]
    d, e, f = matrix[1]
    g, h, i = matrix[2]
    determinant = (a * (e*i-f*h) - b * (d*i-f*g) + c * (d*h-e*g)) % q
    assert determinant
    z = inv(determinant, q)
    return (
        ((e*i-f*h)*z % q, (c*h-b*i)*z % q, (b*f-c*e)*z % q),
        ((f*g-d*i)*z % q, (a*i-c*g)*z % q, (c*d-a*f)*z % q),
        ((d*h-e*g)*z % q, (b*g-a*h)*z % q, (a*e-b*d)*z % q),
    )


def matrix_vector(matrix, vector, q):
    return tuple(sum(matrix[i][j] * vector[j] for j in range(3)) % q for i in range(3))


def canonical_six_cap(points, q):
    """Exact PGL(3,q) canonical key by sending each ordered 4-frame to standard form."""
    best = None
    for order in permutations(range(6), 4):
        p0, p1, p2, p3 = (points[j] for j in order)
        columns = tuple(tuple((p0, p1, p2)[j][i] for j in range(3)) for i in range(3))
        inverse = inverse3(columns, q)
        coefficients = matrix_vector(inverse, p3, q)
        assert all(coefficients)  # no three points of a cap are collinear
        diagonal = tuple(inv(x, q) for x in coefficients)
        image = tuple(sorted(
            norm(tuple(diagonal[i] * matrix_vector(inverse, p, q)[i] % q
                       for i in range(3)), q)
            for p in points
        ))
        if best is None or image < best:
            best = image
    assert best is not None
    return best


def geometry_records(q, all_frames=False, live_only=False):
    recs = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
    rows = []
    minimum_onp = min(rec["onP"] for rec in recs.values())
    for cls, rec in sorted(recs.items()):
        # This is the predeclared extremal-fan gate, not a scan of all labels.
        if not all_frames and rec["onP"] != minimum_onp:
            continue
        mx = max(d["nlegal"] for d in rec["cand"].values())
        keys = [k for k, d in rec["cand"].items() if d["nlegal"] == mx]
        for key in sorted(keys, key=str):
            U, products, d = line_product_data(rec, key)
            # "Maximum-capacity" is per frame; retain only the d=4 defect phase.
            if d != 4:
                continue
            oncell = rec["cand"][key]["oncell"]
            for cell, _value, pos in rec["cand"][key]["hit"]:
                if cell == oncell:
                    continue
                a = transformed_center_a(rec, key, cell)
                assert a not in products
                # D_a: X+aZ=0 is external to the conic iff -a is nonsquare.
                assert (chi(-a, q) == -1) == all((t * t + a) % q for t in range(q))
                if chi(-a, q) != -1:
                    continue
                graph = build_graph(U, a, q, live_only)
                rows.append(dict(cls=cls, key=key, cell=cell, a=a,
                                 U=tuple(sorted(U)), graph=graph))
    if q == 11 and not all_frames:
        assert len(rows) == 40

    reps = []
    for row in rows:
        for gid, rep in enumerate(reps):
            if isomorphic(row["graph"], rep["graph"]):
                row["gid"] = gid
                break
        else:
            row["gid"] = len(reps)
            reps.append(row)
    return recs, rows, reps


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--q", type=int, choices=(11, 13, 17, 19), default=11)
    ap.add_argument("--geometry", action="store_true")
    ap.add_argument("--unblind", action="store_true")
    ap.add_argument("--all-frames", action="store_true",
                    help="use every frame whose maximum pencil has a d=4 stratum")
    ap.add_argument("--summary", action="store_true", help="suppress per-class/per-line output")
    ap.add_argument("--audit-pgl", action="store_true",
                    help="compare signature classes with exact full PGL(3,q) six-cap orbits")
    ap.add_argument("--live-only", action="store_true",
                    help="discard the old deleted/selected trace and retain only the live cover")
    ns = ap.parse_args()
    if not ns.geometry and not ns.unblind and not ns.audit_pgl:
        ap.error("choose --geometry, --unblind, or --audit-pgl")

    recs, rows, reps = geometry_records(ns.q, ns.all_frames, ns.live_only)
    name = ("live-(D0,Da)-boundary+incompatibility+sigma" if ns.live_only else
            "colored-(D0,Da)-boundary+incompatibility+sigma")
    print(f"FROZEN signature={name} exact-isomorphism")
    unique_children = {(r["cls"], r["cell"]) for r in rows}
    print(f"GEOMETRY incidences={len(rows)} unique_children={len(unique_children)} "
          f"exact_classes={len(reps)}")
    if not ns.summary:
        for gid, rep in enumerate(reps):
            members = [r for r in rows if r["gid"] == gid]
            print(f"G{gid} incidences={len(members)} "
                  f"unique_children={len({(r['cls'], r['cell']) for r in members})} "
                  f"stats={graph_stats(rep['graph'])} "
                  f"representative=(cls={rep['cls']},key={rep['key']},cell={rep['cell']},"
                  f"a={rep['a']},U={rep['U']})")
    by_line = {}
    for row in rows:
        by_line.setdefault((row["cls"], row["key"]), []).append(row["gid"])
    if not ns.summary:
        for (cls, key), gids in sorted(by_line.items(), key=lambda x: (x[0][0], str(x[0][1]))):
            print(f"LINE cls={cls} key={key} geometry_classes={tuple(sorted(gids))}")

    if ns.audit_pgl:
        by_signature = {}
        by_cap = {}
        for row in rows:
            C = lambda t: norm((t*t, t, 1), ns.q)
            points = (C(0), *(C(u) for u in row["U"]), norm((-row["a"], 0, 1), ns.q))
            cap_key = canonical_six_cap(points, ns.q)
            by_signature.setdefault(row["gid"], set()).add(cap_key)
            by_cap.setdefault(cap_key, set()).add(row["gid"])
        print(f"PGL-AUDIT q={ns.q} signatures={len(reps)} cap_orbits={len(by_cap)} "
              f"max_cap_orbits_per_signature={max(map(len, by_signature.values()))} "
              f"max_signatures_per_cap_orbit={max(map(len, by_cap.values()))} "
              f"multi_cap_signatures={sum(len(v)>1 for v in by_signature.values())}")

    if ns.geometry or (ns.audit_pgl and not ns.unblind):
        return

    # This is the only phase that consults P/N values.
    labels = {}
    for cls, rec in recs.items():
        for cell, value, _pos in rec["children"]:
            old = labels.setdefault((cls, cell), value)
            assert old == value
    assert all((r["cls"], r["cell"]) in labels for r in rows)
    print("UNBLIND")
    collision = None
    for gid, rep in enumerate(reps):
        members = [r for r in rows if r["gid"] == gid]
        vals = Counter(labels[(r["cls"], r["cell"])] for r in members)
        if not ns.summary:
            print(f"G{gid} labels={dict(sorted(vals.items()))}")
        ps = [r for r in members if labels[(r["cls"], r["cell"])] == "P"]
        ns_ = [r for r in members if labels[(r["cls"], r["cell"])] == "N"]
        if ps and ns_ and collision is None:
            p, n = ps[0], ns_[0]
            mp = isomorphic(p["graph"], n["graph"], want_mapping=True)
            assert mp is not None
            collision = (p, n, mp)
    for (cls, key), gids in sorted(by_line.items(), key=lambda x: (x[0][0], str(x[0][1]))):
        members = [r for r in rows if r["cls"] == cls and r["key"] == key]
        if ns.q == 11 and not ns.all_frames:
            assert Counter(labels[(cls, r["cell"])] for r in members) == Counter(P=3, N=1)
        if not ns.summary:
            print(f"LINE-LABEL cls={cls} key={key} "
                  + " ".join(f"G{r['gid']}:{labels[(cls, r['cell'])]}" for r in
                               sorted(members, key=lambda x: x["gid"])))
    totals = Counter(labels[(r["cls"], r["cell"])] for r in rows)
    pure = sum(1 for gid in range(len(reps)) if len({labels[(r["cls"], r["cell"])]
               for r in rows if r["gid"] == gid}) == 1)
    print(f"LABEL-SUMMARY totals={dict(sorted(totals.items()))} pure_classes={pure} "
          f"mixed_classes={len(reps)-pure}")
    if collision:
        p, n, mp = collision
        print("KILL exact_PN_collision=YES")
        print(f"  P cls={p['cls']} key={p['key']} cell={p['cell']} a={p['a']} U={p['U']}")
        print(f"  N cls={n['cls']} key={n['key']} cell={n['cell']} a={n['a']} U={n['U']}")
        print("  certified_mapping=" + ",".join(f"{i}->{mp[i]}" for i in sorted(mp)))
        if ns.live_only:
            pp = live_trace_profiles(p["U"], p["a"], ns.q)
            np = live_trace_profiles(n["U"], n["a"], ns.q)
            assert all(pp[i] == np[j] for i, j in mp.items())
            print("  deleted_neighbor_profiles_equal=YES")
    else:
        print("KILL exact_PN_collision=NO")


if __name__ == "__main__":
    main()
