"""Cap achievement game on AG(n,q) (q odd prime): build a set with NO 3 collinear
points, add one per move, last to move wins. q=3 is the cap-set game (PROVEN P for
all n). Question: is 'always P' special to q=3? Probe q=5,7 (and q=3 as a control).

A move y into cap A is legal iff y not in A and y is not collinear with any pair
a,b in A (adding it would make 3 collinear). Brute Grundy with memoization; caps
in AG(2,q) are small (max arc = q+1 or q+2), so the tree is shallow.
"""
import sys
from itertools import product
from functools import lru_cache

sys.setrecursionlimit(1 << 20)


def build(n, q):
    pts = list(product(*[range(q)] * n))
    idx = {p: i for i, p in enumerate(pts)}
    N = len(pts)

    def sub(i, j):  # pts[i]-pts[j]
        return tuple((a - b) % q for a, b in zip(pts[i], pts[j]))

    # line through i,j (i!=j): {i + t(j-i)}
    def line(i, j):
        d = sub(j, i)
        base = pts[i]
        return [idx[tuple((base[k] + t * d[k]) % q for k in range(n))]
                for t in range(q)]

    return N, pts, idx, line


def forbidden(A, line):
    f = set()
    Al = sorted(A)
    for x in range(len(Al)):
        for y in range(x + 1, len(Al)):
            for p in line(Al[x], Al[y]):
                if p != Al[x] and p != Al[y]:
                    f.add(p)
    return f


def legal(A, N, line):
    f = forbidden(A, line)
    return [y for y in range(N) if y not in A and y not in f]


def grundy(n, q, outcome_only=False):
    N, pts, idx, line = build(n, q)

    @lru_cache(maxsize=None)
    def g(A):
        opts = set()
        for y in legal(set(A), N, line):
            v = g(A | frozenset([y]))
            if outcome_only:
                if v == 0:      # child is P -> this node is N
                    return 1
                opts.add(v)
            else:
                opts.add(v)
        if outcome_only:
            return 0            # no P child -> P
        mex = 0
        while mex in opts:
            mex += 1
        return mex

    val = g(frozenset())
    info = g.cache_info()
    g.cache_clear()
    return val, info.currsize


if __name__ == "__main__":
    cases = [(1, 3), (2, 3), (1, 5), (2, 5), (1, 7), (2, 7), (3, 3)]
    print(f"{'AG(n,q)':>10} {'|pts|':>6} {'G(empty)':>9} {'outcome':>8} {'states':>9}")
    for (n, q) in cases:
        # outcome_only is much cheaper; use it, but also full Grundy where small
        val, states = grundy(n, q, outcome_only=True)
        outc = "P (2nd)" if val == 0 else "N (1st)"
        print(f"AG({n},{q}){'':>3} {q**n:>6} {val:>9} {outc:>8} {states:>9}", flush=True)
    print("CAP_AGNQ_DONE")
