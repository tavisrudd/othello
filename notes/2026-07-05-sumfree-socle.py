"""Socle reduction test for the sum-free game: outcome(G) == outcome(G[6])?
G[6] = {x : 6x = 0} = the socle = (Z2)^s2 x (Z3)^r3.  If it holds, the sum-free
game outcome depends ONLY on (2-rank, 3-rank).  Also solves the open-core socle
games (Z3)^b and Z2x(Z3)^b directly.
"""
import sys
from itertools import product
from functools import lru_cache
sys.setrecursionlimit(1 << 22)


def solve(mods, restrict_socle=False):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple(0 for _ in mods)]
    N = len(elems)
    add = [[idx[tuple((a + b) % m for a, b, m in zip(elems[i], elems[j], mods))]
            for j in range(N)] for i in range(N)]

    def mul(k, i):
        r = zero
        for _ in range(k):
            r = add[r][i]
        return r

    socle = set(i for i in range(N) if mul(6, i) == zero)
    ground = [i for i in range(N) if i != zero and (not restrict_socle or i in socle)]

    def sf(A):
        for a in A:
            for b in A:
                if add[a][b] in A:
                    return False
        return True

    @lru_cache(maxsize=None)
    def win(A):
        for x in ground:
            if x in A:
                continue
            A2 = A | frozenset([x])
            if sf(set(A2)) and not win(A2):
                return True
        return False
    return ("N" if win(frozenset()) else "P"), len(socle)


if __name__ == "__main__":
    groups = [(4,), (8,), (16,), (9,), (27,), (2, 4), (4, 4), (2, 8), (9, 3),
              (2, 9), (8, 3), (2, 2, 9), (3, 3), (2, 3, 3), (2, 2, 3),
              (10,), (14,), (30,), (35,), (5, 9), (5, 3, 3), (7, 3), (25,)]
    print(f"{'G':12s} {'outcome':>8} {'socle':>6} {'|G[6]|':>7}  match")
    ok = True
    for mods in groups:
        oG, _ = solve(mods)
        oS, sz = solve(mods, True)
        lbl = "x".join(f"Z{m}" for m in mods)
        m = "OK" if oG == oS else "*** MISMATCH ***"
        ok &= (oG == oS)
        print(f"{lbl:12s} {oG:>8} {oS:>6} {sz:>7}  {m}", flush=True)
    print("ALL_MATCH" if ok else "MISMATCH_FOUND")
    print("=== open-core socle games ===")
    for mods in [(3, 3), (3, 3, 3), (2, 3, 3)]:
        o, _ = solve(mods)
        print(f"  {'x'.join(f'Z{m}' for m in mods):12s} = {o}")
    print("SOCLE_DONE")
