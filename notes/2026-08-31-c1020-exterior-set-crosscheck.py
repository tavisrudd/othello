#!/usr/bin/env python3
"""C1020 independent cross-check of the complete-exterior-set census.

A from-scratch second implementation of the census run by the Rust driver
`ergodis-private/src/bin/c1020_exterior_sets.rs`, written so that it disagrees
if either is wrong. What differs deliberately:

  * `census` uses the conic `x^2 + y^2 + z^2 = 0`, where the Rust driver uses
    `x0 x2 = x1^2`, so the point labelling, the internal/external split and the
    passant set are all different objects. All nondegenerate conics of
    `PG(2,q)` are projectively equivalent, so the class counts must agree
    anyway, and that agreement is the check.
  * `verify` uses `x0 x2 = x1^2` so that coordinates emitted by the Rust driver
    can be checked directly, but every routine is still this file's own.
  * the clique enumeration is a plain recursive Bron-Kerbosch over Python sets,
    with no bitsets.

Prime fields only, which covers every cell of Blokhuis-Seress-Wilbrink 1992
section 3 except `q = 27`.

Usage:
    python3 2026-08-31-c1020-exterior-set-crosscheck.py census 7 11 19 23
    python3 2026-08-31-c1020-exterior-set-crosscheck.py verify 31 1,0,3 1,1,0 ...
"""

import sys
from itertools import combinations


def plane(q, form):
    """Points of PG(2,q) in leading-one normal form, plus the conic split."""
    pts = []
    for x in range(q):
        for y in range(q):
            pts.append((1, x, y))
    for y in range(q):
        pts.append((0, 1, y))
    pts.append((0, 0, 1))
    idx = {p: i for i, p in enumerate(pts)}

    def norm(v):
        for c in v:
            if c % q:
                inv = pow(c % q, q - 2, q)
                return tuple((t * inv) % q for t in v)
        return None

    def pair(line, point):
        """Line-point incidence pairing, independent of the conic."""
        return (line[0] * point[0] + line[1] * point[1] + line[2] * point[2]) % q

    if form == "sum":

        def quad(p):
            return (p[0] * p[0] + p[1] * p[1] + p[2] * p[2]) % q

        def polar(a, b):
            return (a[0] * b[0] + a[1] * b[1] + a[2] * b[2]) % q

    elif form == "xz":

        def quad(p):
            return (p[0] * p[2] - p[1] * p[1]) % q

        def polar(a, b):
            return (a[0] * b[2] + a[2] * b[0] - 2 * a[1] * b[1]) % q

    else:
        raise SystemExit("form must be sum or xz")

    conic = [i for i, p in enumerate(pts) if quad(p) == 0]
    assert len(conic) == q + 1, (q, len(conic))

    ptype = {}
    for i, p in enumerate(pts):
        if quad(p) == 0:
            ptype[i] = "conic"
            continue
        t = sum(1 for c in conic if polar(p, pts[c]) == 0)
        assert t in (0, 2), (i, t)
        ptype[i] = "external" if t == 2 else "internal"

    def cross(a, b):
        return norm(
            (
                a[1] * b[2] - a[2] * b[1],
                a[2] * b[0] - a[0] * b[2],
                a[0] * b[1] - a[1] * b[0],
            )
        )

    return pts, idx, norm, pair, polar, cross, conic, ptype


def build(q, form):
    pts, idx, norm, pair, polar, cross, conic, ptype = plane(q, form)

    def misses(line):
        return all(pair(line, pts[c]) != 0 for c in conic)

    ext = [i for i in range(len(pts)) if ptype[i] == "external"]
    assert len(ext) == q * (q + 1) // 2
    cache = {}
    adj = {e: set() for e in ext}
    for a, b in combinations(ext, 2):
        line = cross(pts[a], pts[b])
        if line not in cache:
            cache[line] = misses(line)
        if cache[line]:
            adj[a].add(b)
            adj[b].add(a)
    return pts, idx, norm, pair, polar, cross, conic, ptype, ext, adj, misses


def maximal_cliques(adj, r, p, x, out):
    if not p and not x:
        out.append(set(r))
        return
    pivot = max(p | x, key=lambda u: len(p & adj[u]))
    for v in list(p - adj[pivot]):
        maximal_cliques(adj, r | {v}, p & adj[v], x & adj[v], out)
        p = p - {v}
        x = x | {v}


def line_profile(pts, pair, cross, s):
    prof = {}
    for line in {cross(pts[a], pts[b]) for a, b in combinations(sorted(s), 2)}:
        k = sum(1 for p in s if pair(line, pts[p]) == 0)
        prof[k] = prof.get(k, 0) + 1
    return prof


def census(q):
    pts, idx, norm, pair, polar, cross, conic, ptype, ext, adj, misses = build(q, "sum")
    base = ext[0]
    out = []
    sys.setrecursionlimit(100000)
    maximal_cliques(adj, set(), set(adj[base]), set(), out)
    cliques = [c | {base} for c in out]
    hist = {}
    for c in cliques:
        hist[len(c)] = hist.get(len(c), 0) + 1
    top = max(hist)
    profiles = {}
    for c in cliques:
        if len(c) == top:
            tag = tuple(sorted(line_profile(pts, pair, cross, c).items()))
            profiles[tag] = profiles.get(tag, 0) + 1
    print(f"q={q} external={len(ext)} maximal_cliques_through_base={len(cliques)}")
    print(
        f"  size_histogram={dict(sorted(hist.items()))} max_size={top} "
        f"expected={(q + 1) // 2}"
    )
    for tag, count in sorted(profiles.items()):
        linear = len(tag) == 1 and tag[0][0] == top
        print(f"  max_size_line_profile={dict(tag)} count={count} linear={linear}")


def perfect_matchings(n):
    out = []

    def rec(rem, acc):
        if not rem:
            out.append(list(acc))
            return
        a = rem[0]
        for i in range(1, len(rem)):
            b = rem[i]
            rec([x for x in rem[1:] if x != b], acc + [(a, b)])

    rec(list(range(n)), [])
    return out


def verify(q, coords):
    pts, idx, norm, pair, polar, cross, conic, ptype, ext, adj, misses = build(q, "xz")
    s = [idx[norm(c)] for c in coords]
    assert len(set(s)) == len(s)
    print(f"q={q} set_size={len(s)}")
    print("  all_external=", all(ptype[p] == "external" for p in s))
    bad = sum(0 if misses(cross(pts[a], pts[b])) else 1 for a, b in combinations(s, 2))
    print("  non_passant_joins=", bad)

    cover = {}
    for p in s:
        for c in conic:
            if polar(pts[p], pts[c]) == 0:
                cover[c] = cover.get(c, 0) + 1
    print(
        "  tangent_points_covered=", len(cover), "of", len(conic),
        "each_once=", len(cover) == len(conic) and all(v == 1 for v in cover.values()),
    )
    print("  line_profile=", dict(sorted(line_profile(pts, pair, cross, s).items())))
    print(
        "  extendable_by=",
        sum(1 for e in ext if e not in s and all(e in adj[p] for p in s)),
    )

    spectrum = {}
    best = None
    for combo in combinations(s, 6):
        lines = {(a, b): cross(pts[a], pts[b]) for a, b in combinations(combo, 2)}
        if any(
            sum(1 for p in combo if pair(line, pts[p]) == 0) > 2
            for line in set(lines.values())
        ):
            continue
        six = list(combo)
        bri = set()
        for m in perfect_matchings(6):
            ls = [lines[(six[i], six[j])] for i, j in m]
            v = cross(ls[0], ls[1])
            if v is None or pair(ls[2], v) != 0:
                continue
            pt = idx[v]
            if pt not in six:
                bri.add(pt)
        spectrum[len(bri)] = spectrum.get(len(bri), 0) + 1
        exact = bri == set(s) - set(six) and len(bri) > 0
        score = (1 if exact else 0, len(bri))
        if best is None or score > best[3]:
            best = (six, bri, lines, score)
    print("  brianchon_spectrum=", dict(sorted(spectrum.items())))
    if not best:
        return
    six, bri, lines, _ = best
    types = {}
    for p in bri:
        types[ptype[p]] = types.get(ptype[p], 0) + 1
    print("  best_arc=", sorted(six), "brianchon=", len(bri), "types=", types)
    print("  brianchon_equals_complement=", bri == set(s) - set(six))
    verts = sorted(bri)
    vpos = {p: i for i, p in enumerate(verts)}
    n = len(verts)
    adjm = [[False] * n for _ in range(n)]
    edges = 0
    for line in set(lines.values()):
        on = [p for p in verts if pair(line, pts[p]) == 0]
        if len(on) == 2:
            adjm[vpos[on[0]]][vpos[on[1]]] = True
            adjm[vpos[on[1]]][vpos[on[0]]] = True
            edges += 1
    deg = [sum(1 for b in row if b) for row in adjm]
    pet = n == 10 and all(d == 3 for d in deg)
    if pet:
        for i in range(n):
            for j in range(i + 1, n):
                common = sum(1 for k in range(n) if adjm[i][k] and adjm[j][k])
                if common != (0 if adjm[i][j] else 1):
                    pet = False
    print("  chord_graph_edges=", edges, "degrees=", deg, "is_petersen=", pet)


def main():
    mode = sys.argv[1]
    if mode == "census":
        for q in (int(a) for a in sys.argv[2:]):
            census(q)
    elif mode == "verify":
        q = int(sys.argv[2])
        coords = [tuple(int(t) for t in a.split(",")) for a in sys.argv[3:]]
        verify(q, coords)
    else:
        raise SystemExit("mode must be census or verify")


if __name__ == "__main__":
    main()
