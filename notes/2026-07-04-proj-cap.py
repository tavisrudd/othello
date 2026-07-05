"""Cap achievement game on PROJECTIVE space PG(m,q): points = 1-dim subspaces of
F_q^{m+1} (canonical rep: scale so first nonzero coord = 1); a projective line has
q+1 points; cap = no 3 collinear. Build a cap, last to move wins.

Note: the F_2^k sum-free game (forbid a+b=c) equals the PG(k-1,2) cap game, since
over F_2 each projective point is one nonzero vector and a line is {a,b,a+b}."""
import sys
from itertools import product
from functools import lru_cache
from gf import GF

sys.setrecursionlimit(1 << 20)


def canon(vec, F, q):
    # scale so first nonzero coord == 1
    for c in vec:
        if c != 0:
            inv = F.inv(c)
            return tuple(F.mul(inv, x) for x in vec)
    return None  # zero vector


def build(m, q):
    F = GF(q)
    dim = m + 1
    reps = set()
    for vec in product(range(q), repeat=dim):
        if any(vec):
            reps.add(canon(vec, F, q))
    pts = sorted(reps)
    idx = {p: i for i, p in enumerate(pts)}
    N = len(pts)

    def line(i, j):
        # projective line through points i,j = canon(a*P + b*Q) over (a,b) != 0
        P, Q = pts[i], pts[j]
        out = set()
        for a in range(q):
            for b in range(q):
                if a == 0 and b == 0:
                    continue
                v = tuple(F.add(F.mul(a, P[k]), F.mul(b, Q[k])) for k in range(dim))
                c = canon(v, F, q)
                if c is not None:
                    out.add(idx[c])
        return out

    return N, F, pts, idx, line


def forbidden(A, line):
    f = set()
    Al = sorted(A)
    for x in range(len(Al)):
        for y in range(x + 1, len(Al)):
            for p in line(Al[x], Al[y]):
                if p != Al[x] and p != Al[y]:
                    f.add(p)
    return f


def outcome(m, q):
    N, F, pts, idx, line = build(m, q)
    # precompute all lines' point-sets keyed by pair for speed
    @lru_cache(maxsize=None)
    def g(A):
        f = forbidden(set(A), line)
        for y in range(N):
            if y in A or y in f:
                continue
            if g(A | frozenset([y])) == 0:
                return 1
        return 0
    val = g(frozenset())
    st = g.cache_info().currsize
    g.cache_clear()
    return val, N, st


if __name__ == "__main__":
    cases = eval(sys.argv[1]) if len(sys.argv) > 1 else [
        (1, 2), (2, 2), (3, 2), (1, 3), (2, 3), (1, 4), (2, 4), (1, 5), (2, 5),
    ]
    print(f"{'PG(m,q)':>9} {'|pts|':>6} {'outcome':>8} {'states':>9}")
    for (m, q) in cases:
        val, N, st = outcome(m, q)
        outc = "P (2nd)" if val == 0 else "N (1st)"
        print(f"PG({m},{q}){'':>2} {N:>6} {outc:>8} {st:>9}", flush=True)
    print("PROJ_CAP_DONE")
