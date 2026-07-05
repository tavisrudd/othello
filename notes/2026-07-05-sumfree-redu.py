"""Test the reduction outcome(G) == outcome(G3) [3-Sylow subgame], odd G, small."""
import sys
from itertools import product
from functools import lru_cache
sys.setrecursionlimit(1 << 20)


def solve(mods, restrict=None):
    elems = list(product(*[range(m) for m in mods]))
    idx = {e: i for i, e in enumerate(elems)}
    zero = idx[tuple(0 for _ in mods)]
    N = len(elems)
    add = [[idx[tuple((a + b) % m for a, b, m in zip(elems[i], elems[j], mods))]
            for j in range(N)] for i in range(N)]

    def order(i):
        o, s = 1, i
        while s != zero:
            s = add[s][i]; o += 1
        return o

    def is3pow(i):
        o = order(i)
        while o % 3 == 0:
            o //= 3
        return o == 1

    if restrict == "g3":
        ground = [i for i in range(N) if i != zero and is3pow(i)]
    else:
        ground = [i for i in range(N) if i != zero]

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
    g3size = sum(1 for i in range(N) if i != zero and is3pow(i)) + 1
    return ("N" if win(frozenset()) else "P"), g3size


if __name__ == "__main__":
    print("=== outcome(G) vs outcome(G3), odd G (small) ===")
    for mods in [(5, 3), (7, 3), (11, 3), (13, 3), (5, 3, 3),
                 (3,), (9,), (27,), (3, 3), (9, 3), (3, 3, 3),
                 (5,), (7,), (35,), (25,)]:
        oG, g3 = solve(mods)
        oG3, _ = solve(mods, restrict="g3")
        lbl = "x".join(f"Z{m}" for m in mods)
        flag = "" if oG == oG3 else "   <<< MISMATCH"
        print(f"  {lbl:10s} outcome(G)={oG} outcome(G3)={oG3} |G3|={g3}{flag}", flush=True)
    print("REDU_DONE")
