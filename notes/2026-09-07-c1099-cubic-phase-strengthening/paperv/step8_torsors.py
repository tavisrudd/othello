"""Step 8: the two torsors on the gate.

(a) global negation / sheet exchange; (b) Paper V's residual chordal-line torsor q.
"""
import pickle
import random
import sys

sys.path.insert(0, "/home/tavis/src/othello/notes/2026-09-07-c1099-cubic-phase-strengthening/paperv")

from geom11 import (P, build, act_matching, pgl_elements, SQUARES, matmul,   # noqa: E402
                    matinv, transpose, rref, identity)
from step2_action import compose                                            # noqa: E402
from step4_bridge import subst_cubic, pnorm, BASIS3                         # noqa: E402


def main():
    ms, es, xs, _ = build()
    with open("out/action.pkl", "rb") as fh:
        D = pickle.load(fh)
    with open("out/decomp.pkl", "rb") as fh:
        Dd = pickle.load(fh)
    with open("out/bridge.pkl", "rb") as fh:
        Db = pickle.load(fh)
    with open("out/pencil.pkl", "rb") as fh:
        Dp = pickle.load(fh)
    rho, A5, W = D["rho"], Dd["A5"], Dd["W"]
    q, T, cvec = Db["q"], Db["T"], Db["cvec"]

    # --- (a) the sheet exchange
    A5set = set(A5)
    norm = [g for g in rho if all(compose(compose(g, h), inv(g)) in A5set for h in A5)]
    print(f"|N_{{PGL_2(11)}}(A_5)| = {len(norm)}; contains an outer-coset element: "
          f"{any((g[0]*g[3]-g[1]*g[2]) % P not in SQUARES for g in norm)}")

    S = {tuple(v) for v in xs}
    neg = {tuple((-x) % P for x in v) for v in xs}
    print(f"the configuration is symmetric under x -> -x: {S == neg}")
    if S == neg:
        idx = {tuple(v): i for i, v in enumerate(xs)}
        swaps = all(es[idx[tuple((-x) % P for x in v)]] != es[i]
                    for i, v in enumerate(xs) if any(v))
        print(f"  and -I exchanges the two sheets on every nonzero point: {swaps}")
    minusI = [[(P - 1) if i == j else 0 for j in range(10)] for i in range(10)]
    print(f"-I is in rho(PGL_2(11)): {any(rho[g] == minusI for g in rho)}")
    negc = [(-x) % P for x in cvec]
    print(f"on W the sheet exchange is -1: c -> -c, projectively fixed: "
          f"{pnorm(negc) == pnorm(cvec)}; equal as actual cubics: {negc == list(cvec)}")

    # --- (b) q
    B0 = [[1 + (1 if i == j else 0) for j in range(5)] for i in range(5)]   # I + J
    isom = matmul(matmul(transpose(q), B0), q) == B0
    print(f"\nq preserves the standard quadratic form I+J on the augmentation: {isom}")
    print(f"q is an involution: {matmul(q, q) == identity(5)}")
    qc = subst_cubic(list(cvec), q)
    other = [m for m in Dp["chordal"] if m != Dp["cN"]][0]
    print(f"q sends the logical chordal cubic to the other chordal member: "
          f"{pnorm(qc) == other}")
    print(f"q is A_5-equivariant on the augmentation: "
          f"{all(matmul(q, Db['rhoA'][g]) == matmul(Db['rhoA'][g], q) for g in A5)}")

    # extend q to the whole logical space by the identity on 1 + V_4
    psi = matmul(W, T)                       # A_M -> u-space, image = W
    comp = []
    for name in ("triv", "V4"):
        E = Dd["projs"][name]
        R, piv = rref(transpose(E), 10)
        comp.extend(R)
    Bas = transpose([[psi[i][j] for i in range(10)] for j in range(5)] + comp)
    assert len(rref([r[:] for r in transpose(Bas)], 10)[1]) == 10
    blk = [[0] * 10 for _ in range(10)]
    for i in range(5):
        for j in range(5):
            blk[i][j] = q[i][j]
    for i in range(5, 10):
        blk[i][i] = 1
    qt = matmul(matmul(Bas, blk), matinv(Bas))

    def Fval(u):
        s = 0
        for v, e in zip(xs, es):
            t = sum(v[j] * u[j] for j in range(10)) % P
            s += e * t * t * t
        return s % P

    random.seed(5)
    probes = [[random.randrange(P) for _ in range(10)] for _ in range(40)]
    lams = set()
    for u in probes:
        w = [sum(qt[i][j] * u[j] for j in range(10)) % P for i in range(10)]
        fu, fw = Fval(u), Fval(w)
        if fu:
            lams.add(fw * pow(fu, P - 2, P) % P)
        elif fw:
            lams.add("nonproportional")
    print(f"the identity-on-(1+V_4) extension of q multiplies F_11 by: "
          f"{sorted(lams, key=str)} (a single scalar would mean q lifts to a "
          f"symmetry of the full ten-qudit cubic)")

    # which elements of rho(PGL_2(11)) preserve W, and what do they induce there?
    keepW = []
    for g in rho:
        img = matmul(rho[g], psi)
        aug = [[psi[i][j] for j in range(5)] + [img[i][j] for j in range(5)]
               for i in range(10)]
        R, piv = rref(aug, 5)
        if piv == list(range(5)) and all(
                all((sum(psi[i][t] * R[t][5 + j] for t in range(5)) - img[i][j]) % P == 0
                    for i in range(10)) for j in range(5)):
            keepW.append(g)
    print(f"elements of PGL_2(11) whose action preserves W: {len(keepW)} "
          f"(= |A_5|: {len(keepW) == 60}); none of them induces q, since q is not "
          f"A_5-equivariant")

    import math
    for name, cens in (("chordal shadow", (1, 0, 0, 120, 27720, 133210)),
                       ("conference cubic", (1, 0, 0, 300, 22260, 138490))):
        tot = sum(n * P ** (-r) for r, n in enumerate(cens))
        print(f"stabilizer Renyi-2 magic of the 5-qudit {name}: "
              f"M_2 = {math.log(P ** 5 / tot):.4f} nats")





def inv(g):
    a, b, c, d = g
    det = (a * d - b * c) % P
    iv = pow(det, P - 2, P)
    m = (d * iv % P, (-b) * iv % P, (-c) * iv % P, a * iv % P)
    lead = next(x for x in m if x % P)
    s = pow(lead, P - 2, P)
    return tuple(x * s % P for x in m)


if __name__ == "__main__":
    main()
