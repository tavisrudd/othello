"""check5 (p=7): Waring-rank bracket for F_7.
 - the 13-term decomposition read off from E_7 (one row is zero) and its rigidity
 - the apolar quadrics F^perp_2 and their common zero locus
 - the 4sI+3J normal-form route (diagonalisation of I)
 - sparse search over cubes of linear forms with coefficients in {0,+-1}
"""
import itertools
import random
import sys
import time

sys.path.insert(0, "/home/tavis/src/othello/notes/2026-09-07-c1090-resource-classification")
sys.path.append("/home/tavis/src/othello/notes/2026-09-06-clebsch-quantum-replay")

import numpy as np  # noqa: E402
import sympy as sp  # noqa: E402
from common import data, eps  # noqa: E402
from check1 import hess_tensor  # noqa: E402

P, K = 7, 6
MON3 = [t for t in itertools.combinations_with_replacement(range(K), 3)]  # 56
IDX3 = {t: i for i, t in enumerate(MON3)}
MON2 = [t for t in itertools.combinations_with_replacement(range(K), 2)]  # 21
INV = [0] + [pow(x, P - 2, P) for x in range(1, P)]


def cube_vec(a):
    """coefficient vector of (sum a_i u_i)^3 in the MON3 monomial basis, mod 7."""
    v = np.zeros(len(MON3), dtype=np.int64)
    for i in range(K):
        if not a[i] % P:
            continue
        for j in range(i, K):
            if not a[j] % P:
                continue
            for l in range(j, K):
                if not a[l] % P:
                    continue
                mult = len(set(itertools.permutations((i, j, l))))
                v[IDX3[(i, j, l)]] = (v[IDX3[(i, j, l)]] + mult * a[i] * a[j] * a[l]) % P
    return v


def poly_vec(expr, u):
    pol = sp.Poly(sp.expand(expr), *u)
    v = np.zeros(len(MON3), dtype=np.int64)
    for t, i in IDX3.items():
        mon = [0] * K
        for x in t:
            mon[x] += 1
        v[i] = int(pol.coeff_monomial(sp.prod([u[m] ** mon[m] for m in range(K)]))) % P
    return v


def rref(M):
    """row reduce a numpy int64 matrix mod 7; returns (R, pivot columns)."""
    R = M.copy() % P
    rows, cols = R.shape
    piv = []
    r = 0
    for c in range(cols):
        nz = np.nonzero(R[r:, c])[0]
        if nz.size == 0:
            continue
        i = r + nz[0]
        if i != r:
            R[[r, i]] = R[[i, r]]
        R[r] = (R[r] * INV[R[r, c]]) % P
        f = R[:, c].copy()
        f[r] = 0
        R = (R - np.outer(f, R[r])) % P
        piv.append(c)
        r += 1
        if r == rows:
            break
    return R, piv


def in_span(cols, target):
    """is target in the column span of `cols` (list of 1-d arrays)?"""
    if not len(cols):
        return not target.any()
    M = np.array(cols, dtype=np.int64)  # each row is a candidate cube
    aug = np.vstack([M, target[None, :]])
    _, p1 = rref(M)
    _, p2 = rref(aug)
    return len(p1) == len(p2)


def solve_coeffs(cols, target):
    """solve sum x_i cols[i] = target over F_7; returns x or None."""
    M = np.array(cols, dtype=np.int64).T  # 56 x m
    aug = np.hstack([M, target[:, None]]) % P
    R, piv = rref(aug)
    m = M.shape[1]
    if m in piv:
        return None
    x = np.zeros(m, dtype=np.int64)
    for r, c in enumerate(piv):
        x[c] = R[r, m]
    return x


def main():
    E, _, _ = data(P)
    ep = eps(P)
    u = sp.symbols("u0:6")
    A = hess_tensor(P)

    Fexpr = sum(ep[i] * (sum(E[i][j] * u[j] for j in range(K))) ** 3 for i in range(2 * P))
    Fv = poly_vec(Fexpr, u)

    # ---- 1. the 13-term decomposition -------------------------------------------
    print("== 1. the decomposition read off from E_7 ==")
    nzrows = [i for i in range(2 * P) if any(x % P for x in E[i])]
    print(f"  rows of E_7: {2*P}; nonzero rows: {len(nzrows)} "
          f"(row {[i for i in range(2*P) if i not in nzrows]} is identically zero)")
    # eps_i = +-1 and -1 = (-1)^3 in F_7, so each signed term is a genuine cube
    lin = []
    for i in nzrows:
        a = [E[i][j] % P for j in range(K)]
        if ep[i] != 1:  # eps = -1: absorb into the linear form
            a = [(-x) % P for x in a]
        lin.append(a)
    S = sum(sp.expand((sum(a[j] * u[j] for j in range(K))) ** 3) for a in lin)
    print(f"  F_7 == sum of the {len(lin)} cubes: "
          f"{all(c % P == 0 for c in sp.Poly(sp.expand(S - Fexpr), *u).coeffs())}")
    cols13 = [cube_vec(a) for a in lin]
    R13, p13 = rref(np.array(cols13))
    print(f"  rank of those {len(cols13)} cubes in the 56-dim cubic space: {len(p13)}"
          f"  -> representation unique: {len(p13) == len(cols13)}")
    print("  => no sub-multiset of these 13 cubes represents F_7; upper bound r <= 13.")

    # ---- 2. catalecticants / apolarity -------------------------------------------
    print("\n== 2. apolarity ==")
    # Cat_{1,2}: y_i -> dF/du_i  (6 -> 21)
    rows = []
    for i in range(K):
        d = sp.expand(sp.diff(Fexpr, u[i]))
        pol = sp.Poly(d, *u)
        rows.append([int(pol.coeff_monomial(u[a] * u[b])) % P for a, b in MON2])
    _, pv = rref(np.array(rows, dtype=np.int64))
    print(f"  rank Cat_(1,2) (span of the 6 first partials) = {len(pv)}  "
          f"-> classical lower bound r >= {len(pv)}")
    # F^perp_2 = ker( T_2 -> S_1,  y_i y_j -> H_ij )
    M = np.zeros((K, len(MON2)), dtype=np.int64)  # M[m][(i,j)] = coeff of u_m in H_ij
    for c, (i, j) in enumerate(MON2):
        for m in range(K):
            M[m, c] = (6 * A[m][i][j]) % P
    Rm, pm = rref(M)
    print(f"  rank of (y_iy_j -> H_ij) = {len(pm)}; dim F^perp_2 = {len(MON2) - len(pm)}")
    # V(F^perp_2) = { a : (a_i a_j)_{i<=j} in rowspace(M) }
    basis = Rm[:len(pm)]
    zeros = []
    for lead in range(K):
        for tail in range(P ** (K - 1 - lead)):
            a = [0] * K
            a[lead] = 1
            t = tail
            for s in range(K - 1 - lead):
                a[lead + 1 + s] = t % P
                t //= P
            nu = np.array([a[i] * a[j] % P for i, j in MON2], dtype=np.int64)
            aug = np.vstack([basis, nu[None, :]])
            _, pa = rref(aug)
            if len(pa) == len(pm):
                zeros.append(tuple(a))
    print(f"  |V(F^perp_2)| = {len(zeros)} projective points")
    for z in zeros[:12]:
        print("    ", " ".join(map(str, z)))
    if zeros:
        colsz = [cube_vec(list(z)) for z in zeros]
        print(f"  F_7 in span of their cubes: {in_span(colsz, Fv)}")

    # ---- 3. normal-form route 4sI + 3J -------------------------------------------
    print("\n== 3. the 4sI + 3J normal form ==")
    a_, b_, c_, d_, e_, s_ = sp.symbols("a b c d e s")
    Isym = a_ * e_ - 4 * b_ * d_ + 3 * c_ ** 2
    Jsym = a_ * c_ * e_ + 2 * b_ * c_ * d_ - a_ * d_ ** 2 - b_ ** 2 * e_ - c_ ** 3
    subs = {u[0]: a_, u[1]: b_, u[2]: s_ + c_, u[3]: 3 * s_ + c_, u[4]: d_, u[5]: e_}
    lhs = sp.expand(Fexpr.subs(subs, simultaneous=True) - (4 * s_ * Isym + 3 * Jsym))
    print(f"  F_7(u(a,b,c,d,e,s)) == 4 s I + 3 J mod 7: "
          f"{all(x % P == 0 for x in sp.Poly(lhs, a_, b_, c_, d_, e_, s_).coeffs())}")
    # diagonalise I over F_7 (5 variables)
    vs = [a_, b_, c_, d_, e_]
    inv2 = INV[2]
    # Gram matrix over F_7: Q_ij = (1/2) d^2 I / dv_i dv_j, with 1/2 taken mod 7
    Qm = np.array([[int(sp.diff(Isym, vs[i], vs[j])) * inv2 % P for j in range(5)]
                   for i in range(5)], dtype=np.int64)
    _, qp = rref(Qm)
    print(f"  rank of the Gram matrix of I over F_7 = {len(qp)} (memo claims 5)")
    # symmetric Gram-Schmidt over F_7
    Mq = Qm.copy()
    T = np.eye(5, dtype=np.int64)
    lam = []
    n = 5
    for i in range(n):
        if Mq[i, i] % P == 0:
            k2 = next((j for j in range(i + 1, n) if Mq[j, j] % P), None)
            if k2 is not None:
                Mq[[i, k2]] = Mq[[k2, i]]
                Mq[:, [i, k2]] = Mq[:, [k2, i]]
                T[[i, k2]] = T[[k2, i]]
            else:
                k2 = next((j for j in range(i + 1, n) if Mq[i, j] % P), None)
                if k2 is None:
                    lam.append(0)
                    continue
                Mq[i] = (Mq[i] + Mq[k2]) % P
                Mq[:, i] = (Mq[:, i] + Mq[:, k2]) % P
                T[i] = (T[i] + T[k2]) % P
        piv = Mq[i, i] % P
        for j in range(i + 1, n):
            if Mq[j, i] % P:
                f = Mq[j, i] * INV[piv] % P
                Mq[j] = (Mq[j] - f * Mq[i]) % P
                Mq[:, j] = (Mq[:, j] - f * Mq[:, i]) % P
                T[j] = (T[j] - f * T[i]) % P
        lam.append(int(Mq[i, i] % P))
    print(f"  I diagonalised: lambda = {lam}  (nonzero entries {sum(1 for x in lam if x)})")
    nzl = len(qp)
    print(f"  #nonzero lambda_i == rank(Gram): {sum(1 for x in lam if x) == len(qp)}")
    print(f"  s*y^2 = ((s+y)^3 + (s-y)^3 - 2 s^3)/6  =>  4 s I costs {2*nzl + 1} cubes")
    # Waring rank of J is at least the number of independent first partials
    rows = []
    mon2_5 = list(itertools.combinations_with_replacement(range(5), 2))
    for i in range(5):
        pol = sp.Poly(sp.expand(sp.diff(Jsym, vs[i])), *vs)
        rows.append([int(pol.coeff_monomial(vs[x] * vs[y])) % P for x, y in mon2_5])
    _, jp = rref(np.array(rows, dtype=np.int64))
    print(f"  rank Cat_(1,2)(J) = {len(jp)}  ->  Waring rank of J is at least {len(jp)}")
    print(f"  so this route needs at least {2*nzl+1} + {len(jp)} = {2*nzl+1+len(jp)} cubes: "
          f"worse than the 13 already available.")

    # ---- 4. sparse search over {0,+-1} linear forms --------------------------------
    print("\n== 4. sparse search over cubes of {0,+-1} linear forms ==")
    seen = set()
    pool = []
    for a in itertools.product((0, 1, P - 1), repeat=K):
        if not any(a):
            continue
        key = tuple(a)
        neg = tuple((-x) % P for x in a)
        if neg in seen:
            continue
        seen.add(key)
        pool.append(list(a))
    print(f"  candidate linear forms with coefficients in {{0,+-1}}: 3^6-1 = {3**K-1} nonzero,"
          f" {len(pool)} up to sign")
    cubes = [cube_vec(a) for a in pool]
    Rp, pp = rref(np.array(cubes))
    print(f"  rank of their cubes = {len(pp)} (cubic space has dim {len(MON3)})")
    print(f"  F_7 in span of all {len(pool)} cubes: {in_span(cubes, Fv)}")

    RESTARTS = 10000
    for label, pl in (("{0,+-1} forms", pool),
                      ("{0,+-1} forms + the 13 rows of E_7", pool + lin)):
        cl = [cube_vec(a) for a in pl]
        if not in_span(cl, Fv):
            print(f"  [{label}] F_7 not in span; skipping search")
            continue
        Cm = np.array(cl, dtype=np.int64).T % P  # 56 x m
        m = Cm.shape[1]
        rng = np.random.default_rng(12345)
        t0 = time.time()
        best, bestx = m + 1, None
        hist = {}
        for _ in range(RESTARTS):
            perm = rng.permutation(m)
            Aug = np.hstack([Cm[:, perm], Fv[:, None]]) % P
            R, piv = rref(Aug)
            if m in piv:
                continue
            x = np.zeros(m, dtype=np.int64)
            for r, c in enumerate(piv):
                x[perm[c]] = R[r, m]
            w = int(np.count_nonzero(x % P))
            hist[w] = hist.get(w, 0) + 1
            if w < best:
                best, bestx = w, x.copy()
        # deterministic prune of the best solution found
        supp = [i for i in range(m) if bestx[i] % P]
        changed = True
        while changed:
            changed = False
            for t in list(supp):
                trial = [i for i in supp if i != t]
                if in_span([cl[i] for i in trial], Fv):
                    supp = trial
                    changed = True
                    break
        print(f"  [{label}] {RESTARTS} random-column-order eliminations in "
              f"{time.time()-t0:.1f}s")
        print(f"    support sizes seen: min={min(hist)} max={max(hist)} "
              f"(distribution head: "
              f"{sorted(hist.items())[:4]})")
        print(f"    after greedy pruning of the best: {len(supp)} cubes")
        if len(supp) <= 12:
            x = solve_coeffs([cl[i] for i in supp], Fv)
            for i, idx in enumerate(supp):
                if x[i] % P:
                    print(f"      {int(x[i])} * ("
                          f"{' + '.join(f'{pl[idx][j]}*u{j}' for j in range(K) if pl[idx][j])})^3")


if __name__ == "__main__":
    main()
