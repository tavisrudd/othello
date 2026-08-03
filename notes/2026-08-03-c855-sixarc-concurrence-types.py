#!/usr/bin/env python3
"""C855 target 2 probe: realizable concurrence patterns of six-arcs in PG(2,q), q prime.

For every four-frame-normalized six-arc in PG(2,q) this records the set of one-factors
of K6 whose three chords are concurrent, canonicalizes it under the symmetric group on
the six vertices, and reports which combinatorial types occur at each order.

Conjecture under test: the concurrence count n3 = |M| never takes the values 5, 7, 8, 9.

Replay:  python3 notes/2026-08-03-c855-sixarc-concurrence-types.py 7 11 13 17 19
"""
import sys
from itertools import combinations, permutations


def pg2_points(q):
    pts = []
    for z in range(q):
        for y in range(q):
            for x in range(q):
                v = (x, y, z)
                if v == (0, 0, 0):
                    continue
                # normalize: first nonzero coordinate equal to 1
                for c in v:
                    if c:
                        inv = pow(c, q - 2, q)
                        break
                w = tuple((c * inv) % q for c in v)
                if w == v:
                    pts.append(v)
    return pts


def det3(a, b, c, q):
    return (a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])) % q


def cross(a, b, q):
    return ((a[1] * b[2] - a[2] * b[1]) % q,
            (a[2] * b[0] - a[0] * b[2]) % q,
            (a[0] * b[1] - a[1] * b[0]) % q)


ONE_FACTORS = []
for a in combinations(range(6), 2):
    rest = [i for i in range(6) if i not in a]
    b0 = rest[0]
    for b1 in rest[1:]:
        c = tuple(i for i in rest if i not in (b0, b1))
        f = tuple(sorted([a, (b0, b1), c]))
        if f not in ONE_FACTORS:
            ONE_FACTORS.append(f)
ONE_FACTORS.sort()
assert len(ONE_FACTORS) == 15
FACTOR_INDEX = {f: i for i, f in enumerate(ONE_FACTORS)}

PERM_ACTION = []
for p in permutations(range(6)):
    img = []
    for f in ONE_FACTORS:
        g = tuple(sorted(tuple(sorted((p[u], p[v]))) for (u, v) in f))
        img.append(FACTOR_INDEX[g])
    PERM_ACTION.append(tuple(img))


def canonical(mask):
    best = None
    for act in PERM_ACTION:
        m = 0
        for i in range(15):
            if mask >> i & 1:
                m |= 1 << act[i]
        if best is None or m < best:
            best = m
    return best


def is_arc(pts, q):
    return all(det3(a, b, c, q) for a, b, c in combinations(pts, 3))


def concurrence_mask(pts, q):
    lines = {}
    for (i, j) in combinations(range(6), 2):
        lines[(i, j)] = cross(pts[i], pts[j], q)
    mask = 0
    for idx, f in enumerate(ONE_FACTORS):
        l1, l2, l3 = (lines[e] for e in f)
        if det3(l1, l2, l3, q) == 0:
            mask |= 1 << idx
    return mask


def run(q):
    pts = pg2_points(q)
    frame = [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1)]
    cands = [p for p in pts
             if all(det3(a, b, p, q) for a, b in combinations(frame, 2))]
    raw = set()
    for i5 in range(len(cands)):
        p5 = cands[i5]
        base = frame + [p5]
        if not is_arc(base, q):
            continue
        for i6 in range(i5 + 1, len(cands)):
            p6 = cands[i6]
            six = base + [p6]
            if not is_arc(six, q):
                continue
            raw.add(concurrence_mask(six, q))
    types = {}
    for m in raw:
        c = canonical(m)
        types.setdefault(c, 0)
        types[c] += 1
    counts = {}
    for c in types:
        n3 = bin(c).count("1")
        counts.setdefault(n3, []).append(c)
    return counts


if __name__ == "__main__":
    for q in (int(a) for a in sys.argv[1:]):
        counts = run(q)
        summary = ", ".join(
            f"n3={n}: {len(counts[n])} type(s)" for n in sorted(counts))
        print(f"q={q}: {summary}")
        for n in sorted(counts):
            for c in sorted(counts[n]):
                fs = [ONE_FACTORS[i] for i in range(15) if c >> i & 1]
                deg = [0] * 15
                edges = sorted(combinations(range(6), 2))
                eidx = {e: k for k, e in enumerate(edges)}
                for f in fs:
                    for e in f:
                        deg[eidx[e]] += 1
                print(f"   n3={n} mask={c:#07x} edge-multiplicities={sorted(deg, reverse=True)}")

# ---------------------------------------------------------------------------
# Outer-automorphism translation: each one-factor lies in exactly two of the six
# one-factorizations of K6, so one-factors correspond to duads on a synthetic
# six-element set and the concurrent set M becomes a graph G on six vertices.

def one_factorizations():
    out = []

    def rec(chosen, used):
        if len(chosen) == 5:
            out.append(tuple(sorted(chosen)))
            return
        for k, f in enumerate(ONE_FACTORS):
            if chosen and k <= chosen[-1]:
                continue
            if any(e in used for e in f):
                continue
            rec(chosen + [k], used | set(f))
    rec([], set())
    return out


OFZ = one_factorizations()
assert len(OFZ) == 6, len(OFZ)
DUAD = []
for k in range(15):
    d = tuple(i for i, F in enumerate(OFZ) if k in F)
    assert len(d) == 2
    DUAD.append(d)


def graph_of(mask):
    return sorted(DUAD[k] for k in range(15) if mask >> k & 1)


def graph_invariant(mask):
    es = graph_of(mask)
    deg = [0] * 6
    for u, v in es:
        deg[u] += 1
        deg[v] += 1
    return tuple(sorted(deg, reverse=True))
