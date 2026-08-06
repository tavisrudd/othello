#!/usr/bin/env python3
"""
Companion run 2 (Section 8): the two icosahedral hexads on the twelve conic points
vs. the 132 hexads of the Steiner system S(5,6,12).

Points: P^1(11) = {0,...,10,inf}, identified with the conic's 12 points via the same
chart used throughout the Lean formalization (RelativeConicArcs/Q11Residual.lean:
conicVec i = (1,i,i^2) for i<11, (0,0,1) for i=11=="the point at infinity"; witness
antipodal pairs (0,9),(1,7),(2,inf),(3,4),(5,8),(6,10) from `antipode`).

S(5,6,12) is built by the standard construction: base hexad {inf} u QR(11)
(QR(11) = {1,3,4,5,9}, the nonzero squares mod 11), closed under PSL(2,11) acting by
Mobius transformations on P^1(11). This gives the classical 132 blocks.

The two icosahedral hexads tested are the two complementary transversals of the six
antipodal chords: hexadA = one point from each chord, hexadB = the other (its
complement). These are exactly the two size-6 "halves" the icosahedral antipodal
structure singles out on the twelve conic points.

Run: uv run python check_mathieu_hexads.py    (no third-party deps)
"""

from itertools import combinations

P = 11
INF = "inf"

def mobius(a, b, c, d, t):
    if t == INF:
        return (a * pow(c, P - 2, P)) % P if c % P != 0 else INF
    denom = (c * t + d) % P
    if denom == 0:
        return INF
    numer = (a * t + b) % P
    return (numer * pow(denom, P - 2, P)) % P

def sl2_11():
    """All matrices [[a,b],[c,d]] over F_11 with det = ad-bc = 1 (SL(2,11), order 1320).
    Its image in PGL(2,11) is PSL(2,11) (order 660); -I acts trivially on P^1 so using
    SL(2,11) directly still generates exactly the PSL(2,11) orbit."""
    mats = []
    for a in range(P):
        for b in range(P):
            for c in range(P):
                for d in range(P):
                    if (a * d - b * c) % P == 1:
                        mats.append((a, b, c, d))
    return mats

def quadratic_residues(p):
    return sorted({(x * x) % p for x in range(1, p)})

def main():
    QR = quadratic_residues(P)
    print(f"QR(11) = {QR}")
    assert QR == [1, 3, 4, 5, 9]
    H0 = frozenset([INF] + QR)
    print(f"base hexad H0 = {sorted(H0, key=lambda x: (x == INF, x))}")
    assert len(H0) == 6

    G = sl2_11()
    print(f"|SL(2,11)| = {len(G)} (expect 1320; image in PGL(2,11) is PSL(2,11), order 660)")
    assert len(G) == 1320

    orbit = set()
    for (a, b, c, d) in G:
        img = frozenset(mobius(a, b, c, d, t) for t in H0)
        orbit.add(img)

    print(f"orbit of H0 under PSL(2,11): {len(orbit)} distinct hexads (expect 132)")
    assert len(orbit) == 132
    assert all(len(block) == 6 for block in orbit)

    # Sanity: S(5,6,12) design property -- every 5-subset of the 12 points lies in
    # exactly one block.
    points12 = list(range(11)) + [INF]
    count_ok = True
    bad = []
    for five in combinations(points12, 5):
        five_s = set(five)
        hits = sum(1 for blk in orbit if five_s <= blk)
        if hits != 1:
            count_ok = False
            bad.append((five, hits))
    print(f"S(5,6,12) design check (every 5-subset in exactly one block): {count_ok}")
    if not count_ok:
        print(f"  counterexamples (first 5): {bad[:5]}")
    assert count_ok, f"Steiner design check failed: {bad[:5]}"

    # The six antipodal chords (Q11Residual.lean `antipode`), in t-value form:
    # (idx11 == point at infinity).
    pairs = [(0, 9), (1, 7), (2, INF), (3, 4), (5, 8), (6, 10)]
    hexadA = frozenset(p[0] for p in pairs)
    hexadB = frozenset(p[1] for p in pairs)
    assert hexadA == frozenset({0, 1, 2, 3, 5, 6})
    assert hexadB == frozenset({4, 7, 8, 9, 10, INF})
    print(f"\nhexadA (one point per antipodal chord)      = {sorted(hexadA, key=lambda x: (x == INF, x))}")
    print(f"hexadB (the complementary chord partners)   = {sorted(hexadB, key=lambda x: (x == INF, x))}")
    partition = hexadA | hexadB == frozenset(points12) and hexadA & hexadB == frozenset()
    print(f"hexadA and hexadB partition the 12 points: {partition}")
    assert partition

    inA = hexadA in orbit
    inB = hexadB in orbit
    print(f"\nhexadA is one of the 132 Mathieu hexads: {inA}")
    print(f"hexadB is one of the 132 Mathieu hexads: {inB}")
    assert not inA and not inB

    def overlap_histogram(hexad):
        from collections import Counter
        return Counter(len(hexad & blk) for blk in orbit)

    histA = overlap_histogram(hexadA)
    histB = overlap_histogram(hexadB)
    print(f"\nintersection-size histogram, hexadA vs all 132 blocks: {dict(sorted(histA.items()))}")
    print(f"intersection-size histogram, hexadB vs all 132 blocks: {dict(sorted(histB.items()))}")
    expected_histogram = {1: 6, 2: 30, 3: 60, 4: 30, 5: 6}
    assert dict(histA) == expected_histogram
    assert dict(histB) == expected_histogram

    print("\n=== VERDICT ===")
    if inA or inB:
        which = []
        if inA:
            which.append("hexadA")
        if inB:
            which.append("hexadB")
        print(f"  {' and '.join(which)} IS/ARE among the 132 Mathieu hexads of S(5,6,12).")
    else:
        print("  Neither hexadA nor hexadB is among the 132 Mathieu hexads: the two")
        print("  icosahedral transversal hexads are TRANSVERSE to the Steiner system --")
        print("  they meet its blocks only in the intersection sizes tabulated above,")
        print("  never achieving the full size-6 agreement a block would require.")
    print("all assertions passed")

if __name__ == "__main__":
    main()
