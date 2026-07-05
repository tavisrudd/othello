"""3-term-AP-free achievement game on the INTERVAL {1,...,n} (integer, no wrap):
build A subset of {1..n} with no 3-term AP (distinct a<b<c, a+c=2b). Add one per
move, last to move wins. This is the achievement-game version of the famous 3-AP-
free sets (Roth/Behrend, r_3(n)). No group symmetry, so likely irregular; compute
the Grundy sequence + check OEIS."""
import sys
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def ap_free(Sset):
    S = sorted(Sset)
    Sset2 = set(Sset)
    L = len(S)
    for i in range(L):
        for k in range(i + 1, L):
            s = S[i] + S[k]
            if s % 2 == 0 and (s // 2) in Sset2 and (s // 2) != S[i] and (s // 2) != S[k]:
                return False
    return True


def legal(A, n):
    bad = set()
    Al = sorted(A)
    for i in range(len(Al)):
        for j in range(len(Al)):
            if i == j:
                continue
            a, b = Al[i], Al[j]
            bad.add(2 * b - a)             # x endpoint (b middle)
            if (a + b) % 2 == 0:
                bad.add((a + b) // 2)      # x middle
    return [x for x in range(1, n + 1) if x not in A and x not in bad]


def solve(n, grundy=True):
    @lru_cache(maxsize=None)
    def g(A):
        opts = set()
        for x in legal(set(A), n):
            v = g(A | frozenset([x]))
            if not grundy and v == 0:
                return 1
            opts.add(v)
        if not grundy:
            return 0
        mex = 0
        while mex in opts:
            mex += 1
        return mex
    val = g(frozenset())
    g.cache_clear()
    return val


if __name__ == "__main__":
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 26
    vals = [solve(n, grundy=True) for n in range(1, N + 1)]
    print("3-AP-free interval {1..n}, n=1..:", vals, flush=True)
    print("  outcome:", "".join("P" if v == 0 else "N" for v in vals))
    print("  N-positions:", [n for n in range(1, N + 1) if vals[n - 1]])
    print("AP_INTERVAL_DONE")
