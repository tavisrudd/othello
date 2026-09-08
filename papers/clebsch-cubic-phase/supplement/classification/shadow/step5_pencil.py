"""Step 5: classify every member of the invariant pencil and place the logical cubic.

For each of the twelve projective members of Pi = Sym^3(A_M^*)^{A_5}:
singular F_11-points, whether they lie on a rational normal quartic, and the full
Hessian-rank census over F_11^5.  Then the action of the outer involution q and of
global negation.
"""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[2]/"reconstruction"))

import itertools
import pickle
import sys


from geom11 import P, rref, matmul                                     # noqa: E402
from step4_bridge import BASIS3, IDX3, subst_cubic, pnorm, eval_cubic  # noqa: E402

N5 = 5
INV = [0] + [pow(x, P - 2, P) for x in range(1, P)]


def sym_tensor(cvec):
    S = [[[0] * N5 for _ in range(N5)] for _ in range(N5)]
    for c, mono in zip(cvec, BASIS3):
        if not c % P:
            continue
        perms = set(itertools.permutations(mono))
        share = c * INV[len(perms) % P] % P
        for i, j, k in perms:
            S[i][j][k] = share
    return S


def grad(S, y):
    return [sum(S[m][j][k] * y[j] * y[k] for j in range(N5) for k in range(N5)) % P
            for m in range(N5)]


def hess_slices(S):
    """H(y) = sum_k y_k * T_k, with T_k[m][n] = 6 S[m][n][k] (the factor is a unit)."""
    return [[[6 * S[m][n][k] % P for n in range(N5)] for m in range(N5)]
            for k in range(N5)]


def rank5(M):
    m = [r[:] for r in M]
    r = 0
    for c in range(N5):
        pr = None
        for i in range(r, N5):
            if m[i][c] % P:
                pr = i
                break
        if pr is None:
            continue
        m[r], m[pr] = m[pr], m[r]
        iv = INV[m[r][c] % P]
        m[r] = [x * iv % P for x in m[r]]
        for i in range(N5):
            if i != r and m[i][c] % P:
                f = m[i][c]
                m[i] = [(m[i][j] - f * m[r][j]) % P for j in range(N5)]
        r += 1
    return r


def proj_points():
    pts = []
    for lead in range(N5):
        for tail in range(P ** (N5 - 1 - lead)):
            v = [0] * N5
            v[lead] = 1
            t = tail
            for s in range(N5 - 1 - lead):
                v[lead + 1 + s] = t % P
                t //= P
            pts.append(tuple(v))
    return pts


PTS = proj_points()


def singular_points(S):
    return [v for v in PTS if not any(grad(S, v))]


def census(S):
    T = hess_slices(S)
    counts = {}
    for a0 in range(P):
        M0 = [[a0 * T[0][m][n] % P for n in range(N5)] for m in range(N5)]
        for a1 in range(P):
            M1 = [[(M0[m][n] + a1 * T[1][m][n]) % P for n in range(N5)] for m in range(N5)]
            for a2 in range(P):
                M2 = [[(M1[m][n] + a2 * T[2][m][n]) % P for n in range(N5)] for m in range(N5)]
                for a3 in range(P):
                    M3 = [[(M2[m][n] + a3 * T[3][m][n]) % P for n in range(N5)]
                          for m in range(N5)]
                    for a4 in range(P):
                        M4 = [[(M3[m][n] + a4 * T[4][m][n]) % P for n in range(N5)]
                              for m in range(N5)]
                        r = rank5(M4)
                        counts[r] = counts.get(r, 0) + 1
    return counts


def general_position(pts):
    """True when every 5-subset of pts is a basis (points on a rational normal quartic)."""
    for sub in itertools.combinations(pts, 5):
        if len(rref([list(v) for v in sub], N5)[1]) != 5:
            return False
    return True


def main():
    with open("out/bridge.pkl", "rb") as fh:
        D = pickle.load(fh)
    cvec, basisPi, conf, q = D["cvec"], D["basisPi"], D["conf"], D["q"]
    print(f"outer permutation tau = {D['tau']}")

    members = []
    for s in range(P):
        members.append([(basisPi[0][i] + s * basisPi[1][i]) % P for i in range(len(BASIS3))])
    members.append(basisPi[1][:])
    members = [pnorm(m) for m in members]
    assert len(set(members)) == 12

    cN = pnorm(cvec)
    confN = pnorm(conf[0])
    print(f"logical cubic lies in Pi: {cN in members}")
    print(f"conference triangle cubic lies in Pi: {confN in members}")

    info = {}
    for m in members:
        S = sym_tensor(list(m))
        sp = singular_points(S)
        info[m] = (len(sp), sp)
    print("\nmember | #singular F_11-points | role")
    for i, m in enumerate(members):
        tag = []
        if m == cN:
            tag.append("logical F_11|_W")
        if m == confN:
            tag.append("conference")
        print(f"  {i:2d} | {info[m][0]:5d} | {', '.join(tag) if tag else ''}")

    chordal = [m for m in members if info[m][0] == 12 and general_position(info[m][1])]
    print(f"\nmembers with 12 singular points in general position (rational normal "
          f"quartic): {[members.index(m) for m in chordal]}")
    nodal = [m for m in members if info[m][0] == 6]
    print(f"members with exactly six singular points: {[members.index(m) for m in nodal]}")
    print(f"logical cubic is chordal: {cN in chordal}; is conference: {cN == confN}")

    # census for the interesting members
    print("\nHessian-rank censuses over F_11^5 (N_0, N_1, ..., N_5):")
    for name, m in [("logical F_11|_W", cN), ("conference c_B", confN)] + \
                   [(f"chordal #{members.index(x)}", x) for x in chordal]:
        cs = census(sym_tensor(list(m)))
        print(f"  {name:20s} {tuple(cs.get(r, 0) for r in range(6))}")

    # action of q on Pi
    qc = pnorm(subst_cubic(list(cN), q))
    print(f"\nq sends the logical member to member index "
          f"{members.index(qc) if qc in members else 'off-pencil'}")
    print(f"q fixes the conference member: {pnorm(subst_cubic(list(confN), q)) == confN}")
    print(f"q exchanges the two chordal members: "
          f"{pnorm(subst_cubic(list(chordal[0]), q)) == chordal[1]}")

    # exact matrix of q on Pi in the basis (c_B, h), with actual (not projective) cubics
    cB = list(conf[0])
    h = list(cvec)
    qh = subst_cubic(h, q)
    # solve qh = alpha cB + beta h
    rows = [[cB[i], h[i], qh[i]] for i in range(len(BASIS3))]
    R, piv = rref(rows, 2)
    alpha, beta = R[0][2], R[1][2]
    qcB = subst_cubic(cB, q)
    rows2 = [[cB[i], h[i], qcB[i]] for i in range(len(BASIS3))]
    R2, piv2 = rref(rows2, 2)
    print(f"\nq_Pi in the basis (c_B, h) [c_B is the pentagon triangle cubic, "
          f"h the logical cubic]:")
    print(f"  q(c_B) = {R2[0][2]} c_B + {R2[1][2]} h")
    print(f"  q(h)   = {alpha} c_B + {beta} h")
    scal = alpha
    print(f"  (q - 1)h = {scal} c_B   with beta = {beta}")

    # global negation
    neg = pnorm([(-x) % P for x in cvec])
    print(f"\nglobal negation -I: c -> -c, same projective member: {neg == cN}; "
          f"as actual cubics equal: {[(-x) % P for x in cvec] == list(cvec)}")

    with open("out/pencil.pkl", "wb") as fh:
        pickle.dump({"members": members, "cN": cN, "confN": confN,
                     "chordal": chordal, "qmat": (R2[0][2], R2[1][2], alpha, beta)}, fh)
    print("wrote out/pencil.pkl")


if __name__ == "__main__":
    main()
