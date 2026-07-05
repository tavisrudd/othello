"""Validate the GENERAL-q 'always P' proof of the cap achievement game on AG(n,q)
(q odd prime). P2 strategy: after P1 opens a, reply any b!=a; center c=(a+b)/2
(midpoint, exists since q odd); c is collinear with a,b so self-blocks; thereafter
mirror each P1 move y with sigma_c(y)=2c-y.

Key lemma (why it works for all odd q, not just q=3): the reflection line through
{y,sigma_c(y)} passes through c and is sigma_c-invariant; a sigma_c-symmetric cap A
with c not in A meets it in an EVEN number of points; y legal => <=1 point of A on
it => exactly 0 => adding sigma_c(y) leaves only {y,sigma_c(y)} on that line.

Checks, for each (n,q): simulate P2's strategy vs ALL P1 play; P2 must never be
stuck and P1 must always be first stuck (P2 wins every line).
"""
import sys
from itertools import product

sys.setrecursionlimit(1 << 20)


def build(n, q):
    pts = list(product(*[range(q)] * n))
    idx = {p: i for i, p in enumerate(pts)}
    N = len(pts)
    inv2 = (q + 1) // 2  # inverse of 2 mod q (q odd)

    def line_pts(i, j):
        a, b = pts[i], pts[j]
        d = tuple((b[k] - a[k]) % q for k in range(n))
        return [idx[tuple((a[k] + t * d[k]) % q for k in range(n))] for t in range(q)]

    def midpoint(i, j):
        a, b = pts[i], pts[j]
        return idx[tuple(((a[k] + b[k]) * inv2) % q for k in range(n))]

    def refl(y, c):
        yy, cc = pts[y], pts[c]
        return idx[tuple((2 * cc[k] - yy[k]) % q for k in range(n))]

    return N, pts, idx, line_pts, midpoint, refl


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


def verify(n, q):
    N, pts, idx, line_pts, midpoint, refl = build(n, q)

    def run_opening(c):
        memo = {}

        def p1(Afs):
            if Afs in memo:
                return memo[Afs]
            A = set(Afs)
            res = True
            for y in legal(A, N, line_pts):
                yp = refl(y, c)
                if yp == y or yp in A or yp == c:
                    res = False
                    break
                A2 = A | {y}
                if yp in forbidden(A2, line_pts):
                    res = False
                    break
                if not p1(frozenset(A2 | {yp})):
                    res = False
                    break
            memo[Afs] = res
            return res
        return p1

    # by AGL 2-transitivity every ordered (a,b) is equivalent; test opening a=0,
    # b = each other point (all inequivalent b under the stabilizer are covered by
    # trying all b, which is cheap and fully rigorous for these sizes).
    a = 0
    bad = []
    for b in range(N):
        if b == a:
            continue
        c = midpoint(a, b)
        if not run_opening(c)(frozenset({a, b})):
            bad.append((a, b, c))
    return len(bad) == 0, bad


if __name__ == "__main__":
    cases = [(2, 3), (2, 5), (2, 7), (3, 3)]
    for (n, q) in cases:
        ok, bad = verify(n, q)
        print(f"AG({n},{q}): P2 mirror strategy beats all P1 play = {ok}"
              + ("" if ok else f"  FAIL {bad[:3]}"), flush=True)
    print("AG_STRATEGY_DONE")
