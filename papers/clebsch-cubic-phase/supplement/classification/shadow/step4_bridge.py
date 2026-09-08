"""Step 4: identify the V_5-summand with chordal companion's augmentation module and restrict F_11.

Builds the six-set Omega (the pairs of M_11), the augmentation module A_M with its
A_5-action, the multiplicity-one bridge T : A_M -> W, the restricted cubic, the
invariant pencil Pi = Sym^3(A_M^*)^{A_5}, the A_5-invariant conference triangle cubics
and the outer involution q.
"""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[2]/"reconstruction"))

import itertools
import pickle
import sys


from geom11 import (P, build, act_matching, M11, matmul, rref, transpose,    # noqa: E402
                    identity)
from step2_action import compose                                            # noqa: E402

N5 = 5
BASIS3 = list(itertools.combinations_with_replacement(range(N5), 3))   # 35 monomials
IDX3 = {m: i for i, m in enumerate(BASIS3)}


def pairs_of_M11():
    return sorted(M11, key=lambda s: sorted(str(t) for t in s))


def perm_on_pairs(g, pairs):
    idx = {q: i for i, q in enumerate(pairs)}
    return [idx[next(iter(act_matching(g, frozenset([q]))))] for q in pairs]


def aug_matrix(perm):
    """rho_A(g) on the augmentation basis f_a = e_a - e_5, a = 0..4."""
    cols = []
    for a in range(5):
        img = [0] * 5
        if perm[a] < 5:
            img[perm[a]] = 1
        if perm[5] < 5:
            img[perm[5]] = (img[perm[5]] - 1) % P
        cols.append(img)
    return [[cols[a][r] % P for a in range(5)] for r in range(5)]


def subst_cubic(coeffs, Mmat):
    """Coefficients of y -> c(M y)."""
    out = [0] * len(BASIS3)
    for c, (i, j, k) in zip(coeffs, BASIS3):
        if not c % P:
            continue
        for a in range(N5):
            if not Mmat[i][a] % P:
                continue
            for b in range(N5):
                if not Mmat[j][b] % P:
                    continue
                t = c * Mmat[i][a] * Mmat[j][b] % P
                for d in range(N5):
                    if not Mmat[k][d] % P:
                        continue
                    key = IDX3[tuple(sorted((a, b, d)))]
                    out[key] = (out[key] + t * Mmat[k][d]) % P
    return out


def eval_cubic(coeffs, y):
    s = 0
    for c, (i, j, k) in zip(coeffs, BASIS3):
        if c % P:
            s += c * y[i] * y[j] * y[k]
    return s % P


def pnorm(v):
    for x in v:
        if x % P:
            iv = pow(x % P, P - 2, P)
            return tuple(y * iv % P for y in v)
    return tuple(0 for _ in v)


def triangle_cubic(sig):
    """sig: dict on 3-subsets of range(6) -> +-1; restricted to the augmentation."""
    aug = [[(1 if a == c else 0) - (1 if a == 5 else 0) for c in range(5)]
           for a in range(6)]
    co = [0] * len(BASIS3)
    for i, j, k in itertools.combinations(range(6), 3):
        t = sig[(i, j, k)] % P
        if not t:
            continue
        for a, b, d in itertools.product(range(5), repeat=3):
            key = IDX3[tuple(sorted((a, b, d)))]
            co[key] = (co[key] + t * aug[i][a] * aug[j][b] * aug[k][d]) % P
    return co


def main():
    ms, es, xs, _ = build()
    with open("out/action.pkl", "rb") as fh:
        D = pickle.load(fh)
    with open("out/decomp.pkl", "rb") as fh:
        Dd = pickle.load(fh)
    rho, W, A5 = D["rho"], Dd["W"], Dd["A5"]
    a, b = Dd["gens"]

    pairs = pairs_of_M11()
    print("six-set Omega (pairs of M_11): " +
          ", ".join("{" + ",".join(sorted(str(t) for t in q)) + "}" for q in pairs))
    perms = {g: perm_on_pairs(g, pairs) for g in A5}
    print(f"permutation image of A_5 in S_6 has order "
          f"{len({tuple(v) for v in perms.values()})}; transitive: "
          f"{len(set(perms[a][0] for a in A5)) == 6}")

    rhoA = {g: aug_matrix(perms[g]) for g in A5}

    # rho_W: 5x5 blocks of rho on W (columns of W are a basis of the summand)
    def restrict(R):
        img = matmul(R, W)                        # 10 x 5
        aug = [W[i][:] + img[i][:] for i in range(10)]
        Rr, piv = rref(aug, 5)
        assert piv == list(range(5))
        return [Rr[i][5:] for i in range(5)]

    rhoW = {g: restrict(rho[g]) for g in A5}
    assert all(matmul(rhoW[g], rhoW[h]) == rhoW[compose(g, h)]
               for g in list(A5)[:20] for h in list(A5)[:20])

    # bridge T with rho_W(g) T = T rho_A(g) for the generators
    rows = []
    for g in (a, b):
        Rw, Ra = rhoW[g], rhoA[g]
        for i in range(5):
            for j in range(5):
                row = [0] * 25
                for t in range(5):
                    row[t * 5 + j] = (row[t * 5 + j] + Rw[i][t]) % P
                    row[i * 5 + t] = (row[i * 5 + t] - Ra[t][j]) % P
                rows.append(row)
    R, piv = rref(rows, 25)
    free = [c for c in range(25) if c not in piv]
    print(f"dim Hom_{{A_5}}(A_M, W) = {len(free)}")
    sol = [0] * 25
    sol[free[0]] = 1
    for r, c in enumerate(piv):
        sol[c] = (-R[r][free[0]]) % P
    T = [sol[i * 5:(i + 1) * 5] for i in range(5)]
    assert all(matmul(rhoW[g], T) == matmul(T, rhoA[g]) for g in A5)
    print("bridge T verified equivariant on all 60 elements; det T != 0: "
          f"{len(rref([r[:] for r in T], 5)[1]) == 5}")

    psi = matmul(W, T)          # 10 x 5 : A_M -> u-space

    def Fval(u):
        s = 0
        for v, e in zip(xs, es):
            t = sum(v[j] * u[j] for j in range(10)) % P
            s += e * t * t * t
        return s % P

    # coefficient vector of c(y) = F(psi y) by interpolation on monomials
    cvec = [0] * len(BASIS3)
    import random
    random.seed(3)
    pts = []
    rowsI = []
    while len(pts) < len(BASIS3):
        y = [random.randrange(P) for _ in range(5)]
        row = [1] * len(BASIS3)
        for t, (i, j, k) in enumerate(BASIS3):
            row[t] = y[i] * y[j] * y[k] % P
        trial = rowsI + [row]
        if len(rref([r[:] for r in trial], len(BASIS3))[1]) == len(trial):
            rowsI.append(row)
            pts.append(y)
    rhsv = [Fval([sum(psi[r][c] * y[c] for c in range(5)) % P for r in range(10)])
            for y in pts]
    augm = [rowsI[i] + [rhsv[i]] for i in range(len(BASIS3))]
    Rr, piv2 = rref(augm, len(BASIS3))
    cvec = [Rr[i][len(BASIS3)] for i in range(len(BASIS3))]
    assert all(eval_cubic(cvec, [random.randrange(P) for _ in range(5)]) is not None
               for _ in range(1))
    for _ in range(20):
        y = [random.randrange(P) for _ in range(5)]
        assert eval_cubic(cvec, y) == Fval(
            [sum(psi[r][c] * y[c] for c in range(5)) % P for r in range(10)])
    print("restricted cubic c = F_11 o psi obtained and checked at 20 points")
    print(f"c is A_5-invariant: "
          f"{all(subst_cubic(cvec, rhoA[g]) == cvec for g in A5)}")

    # invariant pencil Pi = ker of (subst by g) - id, for the two generators
    Mrows = []
    for g in (a, b):
        Ra = rhoA[g]
        cols = []
        for t in range(len(BASIS3)):
            e = [0] * len(BASIS3)
            e[t] = 1
            img = subst_cubic(e, Ra)
            cols.append([(img[s] - e[s]) % P for s in range(len(BASIS3))])
        for s in range(len(BASIS3)):
            Mrows.append([cols[t][s] for t in range(len(BASIS3))])
    Rr, piv4 = rref(Mrows, len(BASIS3))
    freec = [c for c in range(len(BASIS3)) if c not in piv4]
    basisPi = []
    for f in freec:
        v = [0] * len(BASIS3)
        v[f] = 1
        for r, c in enumerate(piv4):
            v[c] = (-Rr[r][f]) % P
        basisPi.append(v)
    print(f"dim Pi = dim Sym^3(A_M^*)^{{A_5}} = {len(basisPi)}")

    # A_5-invariant conference two-graphs on Omega
    found = {}
    for bits in range(1 << 15):
        S = [[0] * 6 for _ in range(6)]
        t = bits
        for i, j in itertools.combinations(range(6), 2):
            S[i][j] = S[j][i] = 1 if (t & 1) == 0 else -1
            t >>= 1
        sq = [[sum(S[i][k] * S[k][j] for k in range(6)) for j in range(6)] for i in range(6)]
        if any(sq[i][j] != (5 if i == j else 0) for i in range(6) for j in range(6)):
            continue
        sig = {(i, j, k): S[i][j] * S[j][k] * S[k][i]
               for i, j, k in itertools.combinations(range(6), 3)}
        inv = True
        for g in (a, b):
            pm = perms[g]
            for key, val in sig.items():
                kk = tuple(sorted(pm[x] for x in key))
                if sig[kk] != val:
                    inv = False
                    break
            if not inv:
                break
        if inv:
            co = triangle_cubic(sig)
            found.setdefault(pnorm(co), []).append(bits)
    print(f"A_5-invariant order-six conference two-graphs on Omega: "
          f"{sum(len(v) for v in found.values())} signings, "
          f"{len(found)} projective triangle cubics")
    conf = [list(k) for k in found]

    # outer involution q: an odd permutation of Omega normalizing the A_5-image
    imgA5 = {tuple(perms[g]) for g in A5}

    def sgn(pm):
        s = 1
        seen = [False] * 6
        for i in range(6):
            if seen[i]:
                continue
            n = 0
            j = i
            while not seen[j]:
                seen[j] = True
                j = pm[j]
                n += 1
            if n % 2 == 0:
                s = -s
        return s

    qcands = []
    for pm in itertools.permutations(range(6)):
        if sgn(list(pm)) != -1:
            continue
        inv = [0] * 6
        for i, v in enumerate(pm):
            inv[v] = i
        if all(tuple(pm[h[inv[x]]] for x in range(6)) in imgA5 for h in imgA5):
            qcands.append(list(pm))
    print(f"odd permutations of Omega normalizing the A_5-image: {len(qcands)}")
    qinv = [pm for pm in qcands if all(pm[pm[i]] == i for i in range(6))]
    print(f"  of which involutions: {len(qinv)}")
    q = aug_matrix(qinv[0]) if qinv else aug_matrix(qcands[0])
    print(f"chosen outer permutation tau = {qinv[0] if qinv else qcands[0]}")

    with open("out/bridge.pkl", "wb") as fh:
        pickle.dump({"pairs": [sorted(str(t) for t in s) for s in pairs],
                     "perms": {g: perms[g] for g in A5}, "rhoA": rhoA,
                     "T": T, "psi": psi, "cvec": cvec, "basisPi": basisPi,
                     "conf": conf, "q": q, "tau": qinv[0] if qinv else qcands[0]}, fh)
    print("wrote out/bridge.pkl")


if __name__ == "__main__":
    main()
