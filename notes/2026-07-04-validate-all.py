"""Validate the P2 winning strategy for the cap game on AG(n,q), BOTH parities:
  - q odd  : move-then-mirror. P1 opens a; P2 replies b!=a; center c=(a+b)/2
             (midpoint) self-blocks; P2 mirrors via reflection sigma_c(x)=2c-x.
  - q even : whole-board translation mirror. tau_v(x)=x+v is a fixed-point-free
             INVOLUTION (char 2), so P2 mirrors every P1 move x with x+v from the
             start (no opening burn needed; board q^n is even).
Both rely on the same parity lemma: the mirror's invariant line meets a symmetric
cap in an even number of points, forced to 0 by the just-played legal move.
Check: P2 beats ALL P1 play (never stuck; P1 always first stuck)."""
import sys
from itertools import product
from gf import GF

sys.setrecursionlimit(1 << 20)


def build(n, q):
    F = GF(q)
    pts = list(product(*[range(q)] * n))
    idx = {p: i for i, p in enumerate(pts)}
    N = len(pts)

    def addp(i, j):
        return idx[tuple(F.add(pts[i][k], pts[j][k]) for k in range(n))]

    def line_pts(i, j):
        a, b = pts[i], pts[j]
        d = tuple(F.sub(b[k], a[k]) for k in range(n))
        return [idx[tuple(F.add(a[k], F.mul(t, d[k])) for k in range(n))] for t in range(q)]

    def midpoint(i, j):
        inv2 = F.inv(2 % q)
        a, b = pts[i], pts[j]
        s = tuple(F.add(a[k], b[k]) for k in range(n))
        return idx[tuple(F.mul(inv2, s[k]) for k in range(n))]

    def refl(y, c):  # 2c - y
        cc, yy = pts[c], pts[y]
        return idx[tuple(F.sub(F.add(cc[k], cc[k]), yy[k]) for k in range(n))]

    return N, F, pts, idx, addp, line_pts, midpoint, refl


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
    N, F, pts, idx, addp, line_pts, midpoint, refl = build(n, q)
    odd = (F.p % 2 == 1)

    def solver(reply):
        memo = {}

        def p1(Afs):
            if Afs in memo:
                return memo[Afs]
            A = set(Afs)
            res = True
            for y in legal(A, N, line_pts):
                yp = reply(y)
                if yp == y or yp in A:
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

    bad = []
    if odd:
        a = 0
        for b in range(N):
            if b == a:
                continue
            c = midpoint(a, b)
            if not solver(lambda y, c=c: refl(y, c))(frozenset({a, b})):
                bad.append(("open", a, b, c))
    else:
        v = 1  # any nonzero point; tau_v is a fpf involution in char 2
        rep = lambda y: addp(y, v)
        # whole-board mirror: for every P1 opening x, P2 replies x+v, then recurse
        for x in range(N):
            xp = rep(x)
            if xp == x:
                bad.append(("v-fixed", x))
                continue
            if not solver(rep)(frozenset({x, xp})):
                bad.append(("open", x))
    return len(bad) == 0, bad


if __name__ == "__main__":
    cases = eval(sys.argv[1]) if len(sys.argv) > 1 else [
        (2, 3), (2, 4), (2, 5), (2, 7), (2, 8), (2, 9), (3, 3), (3, 4),
    ]
    for (n, q) in cases:
        F = GF(q)
        kind = "reflect(odd)" if F.p % 2 else "translate(even)"
        ok, bad = verify(n, q)
        print(f"AG({n},{q}) [{kind:>15}]: P2 beats all P1 play = {ok}"
              + ("" if ok else f"  FAIL {bad[:3]}"), flush=True)
    print("VALIDATE_ALL_DONE")
