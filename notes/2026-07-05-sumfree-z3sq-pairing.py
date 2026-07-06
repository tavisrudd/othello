#!/usr/bin/env python3
"""Search for a 2nd-player PAIRING (mirror) strategy proving Z3^2 x Z_p = P.

A pairing strategy is a fixed-point-free involution pi on G\\{0}: 2nd player
always replies pi(x) to 1st player's x.  If, from the empty set, every legal
1st-player move x has pi(x) legal (and distinct) in the resulting position and
this recurses over pi-symmetric positions, then 2nd player always makes the last
move => 2nd wins => G = P.  Verification only explores pi-symmetric sum-free
positions (tiny), so it is cheap and p-scalable -- unlike the full game tree.

Base involution: negation nu(x) = -x.  nu is sum-clean on the BULK (order != 3)
but the SOCLE (order 3, the 8 elements of Z3^2\\{0}) breaks it ({o,-o=2o} has
o+o=2o).  So we keep nu on the bulk and try every fixed-point-free involution
of the 8 socle elements into 4 pairs (avoiding the negation pairs {a,-a}).

Prints, per p, which socle-pairing (if any) yields a verified 2nd-player win,
and whether the SAME pairing verifies across p -- and in particular whether it
correctly FAILS for p=5 (which is N).
"""
from __future__ import annotations
import sys
from itertools import product


def build(p):
    mods = (3, 3, p)
    n = len(mods)
    ELTS = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(ELTS)}
    Z = (0, 0, 0)

    def add(a, b):
        return tuple((a[k] + b[k]) % mods[k] for k in range(n))

    def neg(a):
        return tuple((-a[k]) % mods[k] for k in range(n))

    def order(x):
        c, y = 1, x
        while y != Z:
            y = add(y, x)
            c += 1
        return c

    NZ = [x for x in ELTS if x != Z]
    socle = [x for x in NZ if order(x) == 3]      # 8 elements: (a,b,0)
    bulk = [x for x in NZ if order(x) != 3]
    return mods, ELTS, idx, Z, NZ, socle, bulk, add, neg


def is_sf_add(A, add, Z):
    """A is a set of tuples; check sum-free (a+b not in A for any a,b in A)."""
    S = set(A)
    for a in A:
        for b in A:
            if add(a, b) in S:
                return False
    return True


def legal_moves(A, NZ, add, Z):
    """x legal iff x != 0, x not in A, A u {x} sum-free (given A already sum-free)."""
    S = set(A)
    out = []
    for x in NZ:
        if x in S:
            continue
        # adding x: check no new Schur triple
        ok = True
        # x + x in A ?  (2x = a)   and  a + b = x ?  and  x + a = b ?
        if add(x, x) in S:
            ok = False
        if ok:
            for a in A:
                if add(x, a) in S or add(a, x) in S:  # x+a = some c in A -> triple (x,a,c)
                    ok = False
                    break
                if add(a, a) == x:  # not needed (A sum-free) but harmless
                    pass
        if ok:
            # also a + b = x for a,b in A already excluded since A sum-free doesn't include x's producers?
            # need: no a,b in A with a+b = x
            for a in A:
                if add(a, x) == x:  # a = 0 impossible
                    pass
            for a in A:
                for b in A:
                    if add(a, b) == x:
                        ok = False
                        break
                if not ok:
                    break
        if ok:
            out.append(x)
    return out


def make_pi(neg, socle, socle_pairing):
    """pi = negation on bulk, socle_pairing on socle. socle_pairing: dict socle->socle."""
    def pi(x):
        if x in socle_pairing:
            return socle_pairing[x]
        return neg(x)
    return pi


def verify(pi, NZ, add, Z, memo):
    """Return True if the pairing strategy wins for 2nd player from empty."""
    def rec(A):
        # A: frozenset, pi-symmetric, sum-free, 1st player to move.
        if A in memo:
            return memo[A]
        moves = legal_moves(A, NZ, add, Z)
        res = True
        for x in moves:
            r = pi(x)
            if r == x:
                res = False
                break
            newA = A | {x}
            # r must be legal in A u {x}
            if r not in legal_moves(newA, NZ, add, Z):
                res = False
                break
            child = frozenset(A | {x, r})
            if not is_sf_add(child, add, Z):
                res = False
                break
            if not rec(child):
                res = False
                break
        memo[A] = res
        return res
    return rec(frozenset())


def fpf_socle_pairings(socle, neg):
    """All fixed-point-free involutions of the 8 socle elements into 4 pairs,
    avoiding negation pairs {a,-a} (those are non-sum-free)."""
    elems = list(socle)
    results = []

    def rec(remaining, pairs):
        if not remaining:
            results.append(dict(pairs))
            return
        a = remaining[0]
        rest = remaining[1:]
        for b in rest:
            if b == neg(a):
                continue  # {a,-a} not sum-free
            # form pair a<->b
            newpairs = dict(pairs)
            newpairs[a] = b
            newpairs[b] = a
            rec([x for x in rest if x != b], newpairs)

    rec(elems, {})
    return results


def main():
    ps = [int(x) for x in (sys.argv[1:] or ["5", "7", "11", "13"])]
    # first find working pairings for the smallest P case p=7
    print("=== searching socle-pairings for each p ===")
    per_p_working = {}
    for p in ps:
        mods, ELTS, idx, Z, NZ, socle, bulk, add, neg = build(p)
        pairings = fpf_socle_pairings(socle, neg)
        working = []
        for sp in pairings:
            pi = make_pi(neg, socle, sp)
            if verify(pi, NZ, add, Z, {}):
                working.append(sp)
        per_p_working[p] = (socle, working, len(pairings))
        # summarize each working pairing by the "delta" structure (b - a) in F3^2
        summ = []
        for sp in working:
            deltas = sorted({tuple((sp[a][k] - a[k]) % 3 for k in range(2)) for a in socle})
            summ.append(deltas)
        print(f"p={p:3d}: |socle|={len(socle)} candidate_pairings={len(pairings)} "
              f"WORKING={len(working)}"
              + (f"  (=> P via pairing)" if working else "  (no pairing works => NOT proven P this way)"))
        for sp, ds in zip(working, summ):
            # print pairing as pairs
            seen = set()
            prs = []
            for a in socle:
                b = sp[a]
                key = frozenset((a, b))
                if key in seen:
                    continue
                seen.add(key)
                prs.append(f"{a[:2]}<->{b[:2]}")
            print(f"        pairing: {'  '.join(prs)}")

    # cross-p: does a socle-pairing that works for p=7 also work for others?
    if 7 in per_p_working and per_p_working[7][1]:
        print("\n=== cross-p test: apply p=7's working socle-pairing(s) to every p ===")
        socle7, working7, _ = per_p_working[7]
        # socle is the same set (a,b,0) independent of p; reuse the pairing structure by F3^2 coords
        for sp7 in working7:
            # represent pairing purely by F3^2 coords
            coord_pairing = {a[:2]: sp7[a][:2] for a in socle7}
            print(f"  pairing {sorted({(a, coord_pairing[a]) for a in coord_pairing})}:")
            for p in ps:
                mods, ELTS, idx, Z, NZ, socle, bulk, add, neg = build(p)
                sp = {}
                for a in socle:
                    b2 = coord_pairing[a[:2]]
                    sp[a] = (b2[0], b2[1], 0)
                pi = make_pi(neg, socle, sp)
                ok = verify(pi, NZ, add, Z, {})
                print(f"      p={p:3d}: pairing verifies = {ok}")


if __name__ == "__main__":
    main()
