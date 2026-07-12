#!/usr/bin/env python3
"""C84: verify the small-subgroup escape/sealing negative results.

Independent check (full PG(2,q) model, all off-conic centres) of:
  - the maximum cap among the involution-centres of H = V4, D8, S4, i.e. the
    largest subgroup-preserving centre set: V4 -> 3, D8 -> 3, S4 -> 4 (with 39
    four-caps, no five-cap). A generating triple already uses 3, so V4/D8 have no
    subgroup-preserving fourth move and S4 survives at most one further move.
  - directly: enumerate legal fourth centres of a V4/D8/S4 triple and confirm they
    all enlarge H (escape).

Usage:  c84_escape_probe.py [q ...]
"""
from __future__ import annotations

import argparse
import itertools
from collections import Counter

INF = None


def inv(a, q):
    return pow(a % q, q - 2, q)


def normalize(point, q):
    for coord in point:
        if coord % q:
            s = inv(coord, q)
            return tuple(v * s % q for v in point)
    raise ValueError("zero point")


def det(rows, q):
    (a, b, c), (d, e, f), (g, h, i) = rows
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % q


def line(q):
    return tuple(range(q)) + (INF,)


def conic_pt(t, q):
    return (1, 0, 0) if t is INF else (t * t % q, t, 1)


def centres(q):
    pts = {normalize(p, q) for p in itertools.product(range(q), repeat=3) if p != (0, 0, 0)}
    return tuple(sorted(p for p in pts if p[0] * p[2] % q != p[1] ** 2 % q))


def sigma(center, t, q):
    a, b, c = center
    if t is INF:
        return INF if c == 0 else b * inv(c, q) % q
    num = (b * t - a) % q
    den = (c * t - b) % q
    return INF if den == 0 else num * inv(den, q) % q


def compose(p, r):
    return tuple(p[r[i]] for i in range(len(r)))


def gen_group(gens, cap=None):
    ident = tuple(range(len(gens[0])))
    grp = {ident}
    frontier = [ident]
    while frontier:
        g = frontier.pop()
        for s in gens:
            h = compose(g, s)
            if h not in grp:
                grp.add(h)
                if cap is not None and len(grp) > cap:
                    return grp
                frontier.append(h)
    return grp


def max_cap(points, q):
    """largest subset of `points` with no three collinear (brute force; |points| small)."""
    n = len(points)
    best = 0
    best_count = 0
    for r in range(n, 0, -1):
        found = 0
        for sub in itertools.combinations(range(n), r):
            ok = True
            for a, b, c in itertools.combinations(sub, 3):
                if det((points[a], points[b], points[c]), q) == 0:
                    ok = False
                    break
            if ok:
                found += 1
        if found:
            return r, found
    return best, best_count


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("q", nargs="*", type=int, default=[13])
    args = ap.parse_args()

    for q in args.q:
        params = line(q)
        pindex = {t: i for i, t in enumerate(params)}
        ext = centres(q)
        perm = {c: tuple(pindex[sigma(c, t, q)] for t in params) for c in ext}
        perm_to_centre = {perm[c]: c for c in ext}

        # find a representative triple for each target order
        want = {4: "V4", 8: "D8", 24: "S4"}
        reps = {}
        for tri in itertools.combinations(ext, 3):
            if det(tri, q) == 0:
                continue
            order = len(gen_group([perm[c] for c in tri]))
            if order in want and order not in reps:
                reps[order] = tri
            if len(reps) == len(want):
                break

        print(f"=== q={q} centres={len(ext)} ===")
        for order, name in want.items():
            if order not in reps:
                print(f"  {name}: no representative triple at q={q}")
                continue
            tri = reps[order]
            H = gen_group([perm[c] for c in tri])
            ident = tuple(range(len(params)))
            invols = [g for g in H if g != ident and compose(g, g) == ident]
            centres_of_H = [perm_to_centre[g] for g in invols if g in perm_to_centre]
            cap, count = max_cap(centres_of_H, q)
            # direct: legal 4th centres that keep H unchanged
            legal4_preserving = 0
            legal4_total = 0
            for w in ext:
                if w in tri:
                    continue
                # legal 4th move: no three of {tri, w} collinear
                quad = tri + (w,)
                if any(det((quad[a], quad[b], quad[c]), q) == 0
                       for a, b, c in itertools.combinations(range(4), 3)):
                    continue
                legal4_total += 1
                if len(gen_group([perm[c] for c in quad], cap=order)) == order:
                    legal4_preserving += 1
            print(f"  {name}: |H|={order} involutions={len(invols)} "
                  f"involution_centres={len(centres_of_H)} max_cap={cap} "
                  f"(#max-caps={count})  legal_4th_moves={legal4_total} "
                  f"subgroup_preserving_4th={legal4_preserving}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
