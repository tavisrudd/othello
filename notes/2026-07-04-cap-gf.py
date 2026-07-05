"""Cap achievement game outcome on AG(n,q) over a general finite field GF(q).
Confirms the theorem for odd prime-power q (incl. non-prime q=9,25,27) and probes
the open even-q (char 2) boundary q=4,8,16."""
import sys
from itertools import product
from functools import lru_cache
from gf import GF

sys.setrecursionlimit(1 << 20)


def build(n, q):
    F = GF(q)
    pts = list(product(*[range(q)] * n))
    idx = {p: i for i, p in enumerate(pts)}
    N = len(pts)

    def line_pts(i, j):
        a, b = pts[i], pts[j]
        d = tuple(F.sub(b[k], a[k]) for k in range(n))
        out = []
        for t in range(q):
            out.append(idx[tuple(F.add(a[k], F.mul(t, d[k])) for k in range(n))])
        return out

    return N, F, pts, idx, line_pts


def forbidden(A, line_pts):
    f = set()
    Al = sorted(A)
    for x in range(len(Al)):
        for y in range(x + 1, len(Al)):
            for p in line_pts(Al[x], Al[y]):
                if p != Al[x] and p != Al[y]:
                    f.add(p)
    return f


def legal(A, N, line_pts):
    f = forbidden(A, line_pts)
    return [y for y in range(N) if y not in A and y not in f]


def outcome(n, q):
    N, F, pts, idx, line_pts = build(n, q)

    @lru_cache(maxsize=None)
    def g(A):  # returns 0 (P) or 1 (N), outcome-only
        for y in legal(set(A), N, line_pts):
            if g(A | frozenset([y])) == 0:
                return 1
        return 0

    val = g(frozenset())
    states = g.cache_info().currsize
    g.cache_clear()
    return val, states


if __name__ == "__main__":
    # (n, q): odd q (theorem => P), even q (open)
    cases = eval(sys.argv[1]) if len(sys.argv) > 1 else [
        (2, 9), (1, 4), (2, 4), (1, 8), (2, 8),
    ]
    print(f"{'AG(n,q)':>10} {'char':>4} {'|pts|':>6} {'outcome':>9} {'states':>9}")
    for (n, q) in cases:
        F = GF(q)
        val, states = outcome(n, q)
        outc = "P (2nd)" if val == 0 else "N (1st)"
        print(f"AG({n},{q}){'':>3} {F.p:>4} {q**n:>6} {outc:>9} {states:>9}", flush=True)
    print("CAP_GF_DONE")
