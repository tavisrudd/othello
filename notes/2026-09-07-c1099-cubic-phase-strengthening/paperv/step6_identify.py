"""Step 6: identify the restricted cubic with Paper V's chordal generator.

(a) axis relabelling against Paper V's own certificate vectors;
(b) explicit projectivity carrying the standard Hankel determinant onto the
    restricted logical cubic, built from the A_5-equivariant bijection between the
    twelve singular points and P^1(F_11);
(c) Hankel census; (d) Paper V's pivot normalization of (q-1)h = alpha c_B.
"""
import itertools
import json
import pickle
import sys

sys.path.insert(0, "/home/tavis/src/othello/notes/2026-09-07-c1099-cubic-phase-strengthening/paperv")

from geom11 import P, rref, matmul, matinv, transpose, act_point       # noqa: E402
from step4_bridge import (BASIS3, IDX3, subst_cubic, pnorm, aug_matrix)  # noqa: E402
from step5_pencil import sym_tensor, singular_points, census, general_position, PTS  # noqa: E402

EV = "/home/tavis/src/othello/papers/chordal-conference-reconstruction/verification/evidence"
N5 = 5


def hankel_cubic():
    """det [[z0,z1,z2],[z1,z2,z3],[z2,z3,z4]] as a coefficient vector against BASIS3."""
    terms = {(0, 2, 4): 1, (1, 2, 3): 2, (0, 3, 3): -1, (1, 1, 4): -1, (2, 2, 2): -1}
    v = [0] * len(BASIS3)
    for mono, c in terms.items():
        v[IDX3[tuple(sorted(mono))]] = c % P
    return v


def nu(t):
    if t == "inf":
        return [0, 0, 0, 0, 1]
    return [pow(t, k, P) for k in range(5)]


def main():
    with open("out/bridge.pkl", "rb") as fh:
        Db = pickle.load(fh)
    with open("out/pencil.pkl", "rb") as fh:
        Dp = pickle.load(fh)
    cvec, conf, q, rhoA = Db["cvec"], Db["conf"], Db["q"], Db["rhoA"]
    cN, confN, chordal = Dp["cN"], Dp["confN"], Dp["chordal"]

    # ---- (a) against Paper V's certificate
    axis = json.load(open(f"{EV}/paper_ii_chordal_axis.json"))
    pv_h = [x % P for x in axis["projected_sheet_cubic_raw"]]
    pv_c = [x % P for x in axis["conference_triangle_cubic"]]
    hits_h, hits_c = [], []
    for pm in itertools.permutations(range(6)):
        A = aug_matrix(list(pm))
        if pnorm(subst_cubic(list(cvec), A)) == pnorm(pv_h):
            hits_h.append(pm)
        if pnorm(subst_cubic(list(conf[0]), A)) == pnorm(pv_c):
            hits_c.append(pm)
    print(f"axis relabellings carrying our restricted cubic onto Paper V's "
          f"projected_sheet_cubic: {len(hits_h)}  e.g. {hits_h[0] if hits_h else None}")
    print(f"axis relabellings carrying our triangle cubic onto Paper V's "
          f"conference_triangle_cubic: {len(hits_c)}  e.g. {hits_c[0] if hits_c else None}")
    other = [m for m in chordal if m != cN][0]
    hits_o = [pm for pm in itertools.permutations(range(6))
              if pnorm(subst_cubic(list(other), aug_matrix(list(pm)))) == pnorm(pv_h)]
    print(f"  (the other chordal member also matches under {len(hits_o)} relabellings)")

    # ---- (b) explicit Hankel projectivity
    S = sym_tensor(list(cN))
    sing = singular_points(S)
    print(f"\nsingular points of the restricted cubic: {len(sing)}")

    def act(g, y):
        A = rhoA[g]
        return [sum(A[i][j] * y[j] for j in range(5)) % P for i in range(5)]

    def pn(y):
        for x in y:
            if x % P:
                iv = pow(x % P, P - 2, P)
                return tuple(v * iv % P for v in y)
        return tuple(y)

    A5 = list(rhoA)
    stabs = {pn(p): frozenset(g for g in A5 if pn(act(g, p)) == pn(p)) for p in sing}
    print(f"stabilizer orders on the singular points: "
          f"{sorted({len(v) for v in stabs.values()})}")
    ptstab = {t: frozenset(g for g in A5 if act_point(g, t) == t)
              for t in list(range(P)) + ["inf"]}
    print(f"stabilizer orders on P^1(F_11): {sorted({len(v) for v in ptstab.values()})}")

    # the two projective A_5-actions on P^1 differ by Out(A_5); realize the outer
    # automorphism as conjugation by tau on the permutation image of A_5.
    perms = Db["perms"]
    tau = Db["tau"]
    tinv = [0] * 6
    for i, v in enumerate(tau):
        tinv[v] = i
    bypm = {tuple(perms[g]): g for g in A5}
    theta = {g: bypm[tuple(tau[perms[g][tinv[x]]] for x in range(6))] for g in A5}

    H = hankel_cubic()
    q0 = pn(sing[0])
    C = stabs[q0]
    cands = [t for t in ptstab if ptstab[t] == C]
    print(f"parameter points with the same C_5 stabilizer as one singular point: {cands}")
    solved = None
    for twist, name in ((lambda g: g, "identity"), (lambda g: theta[g], "outer")):
        for t0 in [t for t in ptstab]:
            phi = {}
            good = True
            for g in A5:
                key = pn(act(g, list(q0)))
                val = act_point(twist(g), t0)
                if key in phi and phi[key] != val:
                    good = False
                    break
                phi[key] = val
            if not good or len(phi) != 12:
                continue
            inv_phi = {t: p for p, t in phi.items()}
            V = transpose([nu(t) for t in [0, 1, 2, 3, 4]])
            U = transpose([list(inv_phi[t]) for t in [0, 1, 2, 3, 4]])
            w = matmul(matinv(V), [[x] for x in nu("inf")])
            r = matmul(matinv(U), [[x] for x in inv_phi["inf"]])
            if any(w[i][0] % P == 0 for i in range(5)):
                continue
            lam = [r[i][0] * pow(w[i][0], P - 2, P) % P for i in range(5)]
            L = matmul(matmul(U, [[lam[j] if i == j else 0 for j in range(5)]
                                  for i in range(5)]), matinv(V))
            ok = all(pn([sum(L[i][j] * nu(t)[j] for j in range(5)) % P for i in range(5)])
                     == inv_phi[t] for t in list(range(P)) + ["inf"])
            if ok and pnorm(subst_cubic(list(cN), L)) == pnorm(H):
                solved = (name, t0, L)
                break
        if solved:
            break
    print(f"equivariance twist that works: {solved[0] if solved else 'none'}; "
          f"base parameter t_0 = {solved[1] if solved else None}")
    if solved:
        L = solved[2]
        pulled = subst_cubic(list(cN), L)
        lamscal = next(pulled[i] * pow(H[i], P - 2, P) % P
                       for i in range(len(H)) if H[i] % P)
        print(f"projectivity L carries the standard rational normal quartic onto the "
              f"singular locus, and c(L z) = {lamscal} * det Hankel(z)")
        print(f"  L = {L}")

    # ---- (c) Hankel census, for the record
    hs = sym_tensor(H)
    hsing = singular_points(hs)
    print(f"\nHankel determinant: {len(hsing)} singular F_11-points, in general "
          f"position: {general_position(hsing)}")
    cs = census(hs)
    print(f"Hankel Hessian-rank census over F_11^5: "
          f"{tuple(cs.get(r, 0) for r in range(6))}")

    # ---- (d) Paper V's pivot normalization
    piv = IDX3[(0, 0, 1)]
    print(f"\nmonomial x_0^2 x_1 is BASIS3 index {piv}")
    cB = list(conf[0])
    h = list(cvec)
    cBn = [x * pow(cB[piv], P - 2, P) % P for x in cB]
    hn = [x * pow(h[piv], P - 2, P) % P for x in h]
    qh = subst_cubic(hn, q)
    print(f"[x_0^2x_1] of q(h) after normalization: {qh[piv]}")
    diff = [(qh[i] - hn[i]) % P for i in range(len(h))]
    alpha = next(diff[i] * pow(cBn[i], P - 2, P) % P
                 for i in range(len(diff)) if cBn[i] % P)
    consistent = all((diff[i] - alpha * cBn[i]) % P == 0 for i in range(len(diff)))
    print(f"(q-1)h = {alpha} * c_B in the pivot normalization (consistent: {consistent})")
    print(f"the same with the opposite conference sign: {(-alpha) % P}")

    # the same computation after relabelling our axes to Paper V's, with Paper V's
    # own outer permutation tau = (3 4 5 6), i.e. [0,1,3,4,5,2] zero-indexed
    pm = hits_h[0]
    A = aug_matrix(list(pm))
    hP = subst_cubic(h, A)
    cP = subst_cubic(cB, A)
    hP = [x * pow(hP[piv], P - 2, P) % P for x in hP]
    qPV = aug_matrix([0, 1, 3, 4, 5, 2])
    print(f"Paper V's tau matrix equals ours for [0,1,3,4,5,2]: {qPV}")
    qhP = subst_cubic(hP, qPV)
    diff = [(qhP[i] - hP[i]) % P for i in range(len(hP))]
    for sgn in (1, P - 1):
        cn = [sgn * x * pow(cP[piv], P - 2, P) % P for x in cP]
        al = next(diff[i] * pow(cn[i], P - 2, P) % P for i in range(len(diff)) if cn[i] % P)
        if all((diff[i] - al * cn[i]) % P == 0 for i in range(len(diff))):
            print(f"  after relabelling to Paper V's axes: [x_0^2x_1]q(h) = {qhP[piv]}, "
                  f"(q-1)h = {al} c_B for the conference sign {'+' if sgn == 1 else '-'}")


if __name__ == "__main__":
    main()
