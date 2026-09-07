"""check3 (p=7): identify the PGL_2(7) action on the 6-dim u-space, verify it preserves
F_7 up to a scalar, confirm the minimum-rank locus is the conic, and decompose every
Hessian-rank stratum of PG(5,7) into PGL_2(7)-orbits."""
import sys
import time

sys.path.insert(0, "/home/tavis/src/othello/notes/2026-09-07-c1090-resource-classification")
sys.path.append("/home/tavis/src/othello/notes/2026-09-06-clebsch-quantum-replay")

import numpy as np  # noqa: E402
import sympy as sp  # noqa: E402
from check1 import hess_tensor  # noqa: E402
from check2 import rank_mod_p  # noqa: E402

P, K = 7, 6
# u-space is the space of evaluation functionals on conics:
#   point (X:Y:Z)  ->  nu(X,Y,Z) = (X^2, XY, XZ, Y^2, YZ, Z^2)
# matching the monomial order X^2, XY, XZ, Y^2, YZ, Z^2 of E_7.
XS, YS, ZS = sp.symbols("X Y Z")
NU = [XS**2, XS*YS, XS*ZS, YS**2, YS*ZS, ZS**2]


def nu(pt):
    X, Y, Z = pt
    return ((X*X) % P, (X*Y) % P, (X*Z) % P, (Y*Y) % P, (Y*Z) % P, (Z*Z) % P)


def p3(g):
    """3x3 action on (X,Y,Z) induced by g=[[al,be],[ga,de]] on (s,t) via X=s^2,Y=st,Z=t^2."""
    al, be, ga, de = g
    return [[al*al % P, 2*al*be % P, be*be % P],
            [al*ga % P, (al*de + be*ga) % P, be*de % P],
            [ga*ga % P, 2*ga*de % P, de*de % P]]


def s6(g):
    """6x6 action on the u-space: nu(P(g).pt) = S(g).nu(pt)."""
    M = p3(g)
    Xp = M[0][0]*XS + M[0][1]*YS + M[0][2]*ZS
    Yp = M[1][0]*XS + M[1][1]*YS + M[1][2]*ZS
    Zp = M[2][0]*XS + M[2][1]*YS + M[2][2]*ZS
    S = []
    for mon in NU:
        e = sp.expand(mon.subs({XS: Xp, YS: Yp, ZS: Zp}, simultaneous=True))
        pol = sp.Poly(e, XS, YS, ZS)
        row = []
        for m2 in NU:
            row.append(int(pol.coeff_monomial(m2)) % P)
        S.append(row)
    return S


def F7_vals(A, v):
    """F(v) = T(v,v,v) = sum_{j,l,m} v_j v_l v_m A[m][j][l]."""
    s = 0
    for m in range(K):
        for j in range(K):
            for l in range(K):
                s += v[m]*v[j]*v[l]*A[m][j][l]
    return s % P


def main():
    A = hess_tensor(P)

    # --- 1. the group and its 6-dim representation -------------------------------
    gens = [(1, 1, 0, 1), (0, 1, 1, 0), (3, 0, 0, 1)]  # a->a+1, a->1/a, scaling by 3
    Sg = {}
    for g in gens:
        Sg[g] = s6(g)
    print("generators of PGL_2(7): a->a+1, a->1/a, a->3a")
    for g in gens:
        S = np.array(Sg[g], dtype=np.int64)
        # F(S v) = lam * F(v)?
        rng = np.random.default_rng(0)
        lams = set()
        ok = True
        for _ in range(40):
            v = [int(x) for x in rng.integers(0, P, K)]
            fv = int(F7_vals(A, v))
            fw = int(F7_vals(A, [int(x) for x in (S @ np.array(v)) % P]))
            if fv == 0:
                if fw != 0:
                    ok = False
                continue
            lams.add(fw * pow(fv, P-2, P) % P)
        print(f"  g={g}: F(S(g)v) = lam*F(v) for all sampled v: {ok and len(lams) == 1},"
              f" lam in {sorted(lams)}")

    # --- 2. minimum-rank locus is the conic ---------------------------------------
    conic = [nu((1, a, a*a % P)) for a in range(P)] + [nu((0, 0, 1))]
    minv = set()
    with open("minrank7.txt") as fh:
        for line in fh:
            if line.startswith("#"):
                continue
            minv.add(tuple(int(x) for x in line.split()))
    # projectivize both sides
    def norm(v):
        for x in v:
            if x % P:
                iv = pow(x % P, P-2, P)
                return tuple(y*iv % P for y in v)
        return tuple(0 for _ in v)
    minproj = {norm(v) for v in minv}
    conicproj = {norm(v) for v in conic}
    print(f"\nminimum-rank locus: {len(minv)} vectors, {len(minproj)} projective points")
    print(f"Veronese image of the conic Q: {len(conicproj)} projective points")
    print(f"  min-rank locus == conic: {minproj == conicproj}")

    # --- 3. full orbit decomposition of PG(5,7) by rank ----------------------------
    t0 = time.time()
    pts = []
    for lead in range(K):
        for tail in range(P**(K-1-lead)):
            v = [0]*K
            v[lead] = 1
            t = tail
            for s in range(K-1-lead):
                v[lead+1+s] = t % P
                t //= P
            pts.append(tuple(v))
    idx = {v: i for i, v in enumerate(pts)}
    V = np.array(pts, dtype=np.int64)
    N = len(pts)
    print(f"\nPG(5,7): {N} points (expected {(P**K-1)//(P-1)})")

    ranks = np.zeros(N, dtype=np.int8)
    for i, v in enumerate(pts):
        H = [[sum(v[m]*A[m][j][l] for m in range(K)) % P for l in range(K)] for j in range(K)]
        ranks[i] = rank_mod_p(H, P)

    # all invertible 2x2 over F_7 (scalars act trivially projectively)
    # projective representatives: invertible, first nonzero entry equal to 1
    G = [(a, b, c, d) for a in range(P) for b in range(P) for c in range(P) for d in range(P)
         if (a*d - b*c) % P and next(x for x in (a, b, c, d) if x) == 1]
    print(f"|PGL_2(7)| = {len(G)} (expected 336)")

    parent = list(range(N))

    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x

    def union(x, y):
        rx, ry = find(x), find(y)
        if rx != ry:
            parent[max(rx, ry)] = min(rx, ry)

    # normalization lookup: map any nonzero vector to its projective index
    pow7 = np.array([P**(K-1-j) for j in range(K)], dtype=np.int64)
    keymap = {}
    for i, v in enumerate(pts):
        keymap[int(np.dot(np.array(v), pow7))] = i

    for g in G:
        S = np.array(s6(g), dtype=np.int64)
        W = (V @ S.T) % P
        # normalize: divide by leading nonzero
        lead = (W != 0).argmax(axis=1)
        leadval = W[np.arange(N), lead]
        invv = np.array([0] + [pow(x, P-2, P) for x in range(1, P)], dtype=np.int64)
        W = (W * invv[leadval][:, None]) % P
        keys = W @ pow7
        for i in range(N):
            union(i, keymap[int(keys[i])])

    orb = {}
    for i in range(N):
        orb.setdefault(find(i), []).append(i)
    print(f"orbits found: {len(orb)}  ({time.time()-t0:.1f}s)")
    from collections import Counter
    bysize = {}
    for root, mem in orb.items():
        r = int(ranks[mem[0]])
        assert all(int(ranks[m]) == r for m in mem), "rank not constant on an orbit!"
        bysize.setdefault(r, Counter())[len(mem)] += 1
    print("\nPGL_2(7)-orbit decomposition of PG(5,7), by Hessian rank:")
    for r in sorted(bysize):
        tot = sum(sz*n for sz, n in bysize[r].items())
        parts = ", ".join(f"{n} x {sz}" for sz, n in sorted(bysize[r].items()))
        print(f"  rank {r}: {tot} points = {parts}")
    print("\nsmall orbits (size <= 8):")
    for root, mem in sorted(orb.items(), key=lambda kv: len(kv[1])):
        if len(mem) > 8:
            continue
        print(f"  size {len(mem)} rank {int(ranks[mem[0]])}: "
              + "; ".join(" ".join(map(str, pts[i])) for i in mem))


if __name__ == "__main__":
    main()
