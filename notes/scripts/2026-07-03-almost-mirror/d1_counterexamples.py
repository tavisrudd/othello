#!/usr/bin/env python3
"""Independent verification + characterization of the D1 counterexamples at
n=10: symmetric d=1 positions with G >= 2, found by d1_verify.py.

Verification path is independent of d1_verify's grundy: cgtlib.make_grundy.
Also searches for an explicit placement witness (independent queen set whose
available set equals the position), proving in-game reachability, and prints
board diagrams + a D4-orbit classification of all counterexamples.
"""
import sys, os
from collections import Counter

sys.setrecursionlimit(1000000)
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, '..', '2026-07-03-geometry'))
from small_boards import build              # noqa: E402
import cgtlib                               # noqa: E402
from d1_verify import Board, bits, d_of     # noqa: E402


def show(bd, A, marks=None):
    n = bd.n
    marks = marks or {}
    for r in range(n):
        row = []
        for c in range(n):
            s = r * n + c
            if s in marks:
                row.append(marks[s])
            elif (A >> s) & 1:
                row.append('o')
            else:
                row.append('.')
        print('   ' + ' '.join(row))


def find_witness(bd, A, max_q=8):
    """Search an independent queen set Q with avail(Q) == A (placement
    witness). Queens must be dead squares; prune on coverage."""
    n = bd.n
    dead = bd.full & ~A
    # candidate queen squares: dead squares whose whole neighborhood is dead
    cands = [q for q in bits(dead) if (bd.att[q] & A) == 0]

    def rec(start, placed, cover):
        if cover == dead:
            return placed
        if len(placed) >= max_q:
            return None
        for i in range(start, len(cands)):
            q = cands[i]
            if any((bd.att[q] >> p) & 1 for p in placed):
                continue
            if bd.att[q] & ~cover & dead == 0:
                continue  # adds nothing
            r = rec(i + 1, placed + [q], cover | (bd.att[q] & bd.full))
            if r is not None:
                return r
        return None
    return rec(0, [], 0)


def d4_maps(n):
    return [lambda r, c: (r, c), lambda r, c: (c, n - 1 - r),
            lambda r, c: (n - 1 - r, n - 1 - c), lambda r, c: (n - 1 - c, r),
            lambda r, c: (r, n - 1 - c), lambda r, c: (n - 1 - r, c),
            lambda r, c: (c, r), lambda r, c: (n - 1 - c, n - 1 - r)]


def mask_map(bd, A, f):
    n = bd.n
    out = 0
    for s in bits(A):
        r, c = divmod(s, n)
        r2, c2 = f(r, c)
        out |= 1 << (r2 * n + c2)
    return out


def main(n=10):
    bd = Board(n)
    print(f"n={n}: recomputing full DAG grundy (d1_verify path)...")
    bd.grundy(bd.full)
    sym = [a for a in list(bd.memo.keys()) + [bd.full, 0]
           if a == bd.mask_rho(a)]
    cex = sorted(a for a in set(sym)
                 if d_of(bd, a) == 1 and bd.grundy(a) >= 2)
    print(f"d=1 counterexamples (G >= 2): {len(cex)}")

    # D4 orbit classification
    fs = d4_maps(n)
    orbits = []
    seen = set()
    for a in cex:
        if a in seen:
            continue
        orb = {mask_map(bd, a, f) for f in fs}
        seen |= orb
        orbits.append((a, orb))
    print(f"D4 orbit classes: {len(orbits)}")

    # independent grundy for verification
    att2 = cgtlib.queen_attacks(n)
    g2, _ = cgtlib.make_grundy(att2, n * n)

    feat = Counter()
    for a, orb in orbits:
        gA = bd.grundy(a)
        gI = g2(a)
        livediag = a & bd.diagm
        e = (livediag & -livediag).bit_length() - 1
        re = bd.rho[e]
        Ae = a & ~bd.att[e]
        gstar = bd.grundy(Ae)
        Delta = Ae & bd.att[re]
        w = find_witness(bd, a)
        nb = sum(1 for s in bits(a)
                 if divmod(s, n)[0] in (0, n - 1) or divmod(s, n)[1] in (0, n - 1))
        print(f"\nA={a:#x}  |orbit|={len(orb)}  G={gA} (independent recheck: {gI})"
              f"  gstar={gstar}  |live|={a.bit_count()}  |Delta|={Delta.bit_count()}"
              f"  border-live={nb}")
        er, ec = divmod(e, n)
        print(f"  pair e=({er},{ec}) ebar=({n-1-er},{n-1-ec})   "
              f"witness Q={[divmod(q, n) for q in (w or [])]}")
        marks = {}
        for q in (w or []):
            marks[q] = 'Q'
        marks[e] = 'E'
        marks[re] = 'E'
        show(bd, a, marks)
        assert gA == gI, "GRUNDY MISMATCH"
        feat[(gA, a.bit_count(), Delta.bit_count())] += 1
    print(f"\n(G, |live|, |Delta|) over orbit classes: {dict(sorted(feat.items()))}")


if __name__ == '__main__':
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 10)
