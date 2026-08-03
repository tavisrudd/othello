#!/usr/bin/env python3
"""C855 target 1 probe: maximum arcs all of whose chords are passant to a conic.

For PG(2,q), q an odd prime, with the conic XZ = Y^2, this enumerates every set of
off-conic points that is an arc (no three collinear) and all of whose joins miss the
conic, counting them by size and reporting the maximum. It also reports the
internal/external type profile of the maximum-size examples.

With --greedy it instead runs randomized greedy restarts, which give lower bounds only
but stay cheap at orders where exhaustive enumeration does not.

Replay:  python3 notes/2026-08-03-c855-passant-arc-search.py 11 13 17 19 23
         python3 notes/2026-08-03-c855-passant-arc-search.py --greedy 23 29 31 37 41 43
"""
import random
import sys
from itertools import combinations


def build(q):
    pts, idx = [], {}
    for v in [(1, y, z) for y in range(q) for z in range(q)] + \
             [(0, 1, z) for z in range(q)] + [(0, 0, 1)]:
        idx[v] = len(pts)
        pts.append(v)
    # conic XZ = Y^2
    on = [(x * z - y * y) % q == 0 for (x, y, z) in pts]
    lines = {}
    for i in range(len(pts)):
        for j in range(i + 1, len(pts)):
            a, b = pts[i], pts[j]
            l = ((a[1] * b[2] - a[2] * b[1]) % q,
                 (a[2] * b[0] - a[0] * b[2]) % q,
                 (a[0] * b[1] - a[1] * b[0]) % q)
            for c in l:
                if c:
                    inv = pow(c, q - 2, q)
                    break
            l = tuple((c * inv) % q for c in l)
            lines.setdefault(l, set()).update((i, j))
    return pts, on, lines


def run(q, want_profiles=False):
    pts, on, lines = build(q)
    n = len(pts)
    off = [i for i in range(n) if not on[i]]
    passant_mask = {}
    adj = [0] * n
    for l, members in lines.items():
        if any(on[i] for i in members):
            continue
        m = 0
        for i in members:
            m |= 1 << i
        passant_mask[l] = m
        for i in members:
            adj[i] |= m & ~(1 << i)
    # line index for a pair of points
    linemask = {}
    for l, m in passant_mask.items():
        ms = [i for i in range(n) if m >> i & 1]
        for a, b in combinations(ms, 2):
            linemask[(a, b)] = m
            linemask[(b, a)] = m

    offmask = 0
    for i in off:
        offmask |= 1 << i
    counts = {}
    best = [0, []]

    def dfs(chosen, cand):
        k = len(chosen)
        counts[k] = counts.get(k, 0) + 1
        if k > best[0]:
            best[0] = k
            best[1] = list(chosen)
        c = cand
        while c:
            low = c & -c
            v = low.bit_length() - 1
            c ^= low
            forbid = 0
            for u in chosen:
                forbid |= linemask[(u, v)]
            dfs(chosen + [v], c & adj[v] & ~forbid)

    dfs([], offmask)
    sizes = {k: counts[k] for k in sorted(counts) if k >= 2}
    return sizes, best, pts, on


def point_type(q, p):
    """internal points are those with no tangent line, detected via the polarity."""
    x, y, z = p
    # polar of (x,y,z) w.r.t. XZ - Y^2 is  z*X - 2y*Y + x*Z
    # the point is external iff its polar meets the conic, i.e. iff the
    # discriminant y^2 - x z is a nonzero square
    d = (y * y - x * z) % q
    return "external" if pow(d, (q - 1) // 2, q) == 1 else "internal"


def greedy(q, tries=600):
    pts = [(1, y, z) for y in range(q) for z in range(q)] + \
          [(0, 1, z) for z in range(q)] + [(0, 0, 1)]

    def form(p):
        x, y, z = p
        return (y * y - x * z) % q

    def polar(p, r):
        x, y, z = p
        X, Y, Z = r
        return (2 * y * Y - (x * Z + X * z)) % q

    def sq(a):
        return pow(a, (q - 1) // 2, q) == 1

    def det(a, b, c):
        return (a[0] * (b[1] * c[2] - b[2] * c[1])
                - a[1] * (b[0] * c[2] - b[2] * c[0])
                + a[2] * (b[0] * c[1] - b[1] * c[0])) % q

    off = [p for p in pts if form(p)]

    def passant(p, r):
        d = (polar(p, r) ** 2 - 4 * form(p) * form(r)) % q
        return d != 0 and not sq(d)

    best = 0
    for _ in range(tries):
        random.shuffle(off)
        S = []
        for p in off:
            if all(passant(p, u) for u in S) and \
               all(det(p, u, v) for u, v in combinations(S, 2)):
                S.append(p)
        best = max(best, len(S))
    return best


if __name__ == "__main__":
    args = sys.argv[1:]
    if args and args[0] == "--greedy":
        for q in (int(a) for a in args[1:]):
            print(f"q={q} greedy lower bound: {greedy(q)}")
        sys.exit(0)
    for q in (int(a) for a in args):
        sizes, best, pts, on = run(q)
        print(f"q={q} arcs by size: {sizes}")
        k, witness = best
        prof = [point_type(q, pts[i]) for i in witness]
        print(f"   maximum size {k}, witness {[pts[i] for i in witness]}")
        print(f"   type profile {prof}")
