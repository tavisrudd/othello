"""Step 2: the PGL_2(11) action on the 10-dimensional logical space.

For g in PGL_2(11) the induced map on the 22-point configuration is affine,
x_{gM} = A_g x_M + b_g.  The linear part A_g acts on the logical (u-) space by
the contragredient; F_11 is invariant on PSL_2(11) and negated on the outer coset.
"""
import pickle
import random
import sys

sys.path.insert(0, "/home/tavis/src/othello/notes/2026-09-07-c1099-cubic-phase-strengthening/paperv")

from geom11 import (P, build, act_matching, pgl_elements, SQUARES, matmul,     # noqa: E402
                    matinv, transpose, rref)

N = 10


def affine_part(xs, perm):
    """Solve x_{perm(i)} = A x_i + b over all i; return (A, b) or None."""
    base = next(i for i, v in enumerate(xs) if not any(v))
    b = xs[perm[base]][:]
    aug = []
    for i in range(len(xs)):
        if i == base:
            continue
        aug.append(xs[i] + [(xs[perm[i]][j] - b[j]) % P for j in range(N)])
    R, piv = rref(aug, N)
    if piv != list(range(N)):
        return None
    A = transpose([R[i][N:] for i in range(N)])
    for i in range(len(xs)):
        img = [(sum(A[r][c] * xs[i][c] for c in range(N)) + b[r]) % P for r in range(N)]
        if img != xs[perm[i]]:
            return None
    return A, b


def norm_g(g):
    a, b, c, d = (x % P for x in g)
    lead = next(x for x in (a, b, c, d) if x)
    iv = pow(lead, P - 2, P)
    return (a * iv % P, b * iv % P, c * iv % P, d * iv % P)


def compose(g, h):
    return norm_g((g[0] * h[0] + g[1] * h[2], g[0] * h[1] + g[1] * h[3],
                   g[2] * h[0] + g[3] * h[2], g[2] * h[1] + g[3] * h[3]))


def main():
    ms, es, xs, _ = build()
    index = {M: i for i, M in enumerate(ms)}
    base = next(i for i, v in enumerate(xs) if not any(v))
    M0 = ms[base]
    G = pgl_elements()
    print(f"|PGL_2(11)| = {len(G)}")
    a, bb = (0, 1, 2, 3), (0, 1, 7, 8)
    print(f"a=[[0,1],[2,3]] fixes M_11: {act_matching(a, M0) == M0}; "
          f"b=[[0,1],[7,8]] fixes M_11: {act_matching(bb, M0) == M0}")

    Amats, bvecs = {}, {}
    fails = 0
    for g in G:
        perm = [index[act_matching(g, M)] for M in ms]
        res = affine_part(xs, perm)
        if res is None:
            fails += 1
        else:
            Amats[g], bvecs[g] = res
    print(f"elements acting affinely on the 22 points: {len(Amats)} (failures {fails})")
    print(f"elements with nonzero translation part: "
          f"{sum(1 for g in Amats if any(bvecs[g]))}")

    rho = {g: transpose(matinv(Amats[g])) for g in Amats}

    def Fval(u):
        s = 0
        for v, e in zip(xs, es):
            t = sum(v[j] * u[j] for j in range(N)) % P
            s += e * t * t * t
        return s % P

    random.seed(7)
    probes = [[random.randrange(P) for _ in range(N)] for _ in range(30)]
    ok = {1: 0, P - 1: 0}
    bad = 0
    for g in Amats:
        det = (g[0] * g[3] - g[1] * g[2]) % P
        chi = 1 if det in SQUARES else P - 1
        R = rho[g]
        good = all(Fval([sum(R[r][c] * u[c] for c in range(N)) % P for r in range(N)])
                   == chi * Fval(u) % P for u in probes)
        if good:
            ok[chi] += 1
        else:
            bad += 1
    print(f"F(rho(g)u) = chi(g)F(u): PSL ok {ok[1]}/660, outer-coset ok "
          f"{ok[P-1]}/660, failures {bad}")

    hom = all(matmul(rho[g], rho[h]) == rho[compose(g, h)]
              for g in list(Amats)[:60] for h in list(Amats)[:60])
    print(f"rho(g)rho(h) = rho(gh) on 3600 sampled pairs: {hom}")

    with open("out/action.pkl", "wb") as fh:
        pickle.dump({"es": es, "xs": xs, "rho": rho, "A": Amats, "b": bvecs,
                     "ms": ms, "base": base}, fh)
    print("wrote out/action.pkl")


if __name__ == "__main__":
    main()
