"""Step 7: invariant-theoretic normal forms, and the p = 7 analogue.

Checks the memo's gate identities F_11 = 4 s I_2 + 2 I_3 and F_7 = 4 s I + 3 J,
shows that the V_5-summand of the p = 11 logical space lies in s = 0 (so the
restricted gate is the octavic cubic invariant I_3), and records that at p = 7 the
whole s = 0 slice is already the Hankel/chordal cubic.
"""
from pathlib import Path
import sys
sys.path.append(str(Path(__file__).resolve().parents[2]/"reconstruction"))

import itertools
import pickle
import random
import sys


from common import E7                                          # noqa: E402
from geom11 import P, build, matinv, matmul, rref              # noqa: E402

P7 = 7


def F11_from_config(xs, es, u):
    s = 0
    for v, e in zip(xs, es):
        t = sum(v[j] * u[j] for j in range(10)) % P
        s += e * t * t * t
    return s % P


def I2(z):
    return (2 * z[0] * z[8] + 6 * z[1] * z[7] + z[2] * z[6] + 9 * z[3] * z[5]
            + 4 * z[4] * z[4]) % P


def I3(z):
    return (6 * z[0] * z[4] * z[8] + 9 * z[0] * z[5] * z[7] + 7 * z[0] * z[6] ** 2
            + 9 * z[1] * z[3] * z[8] + 6 * z[1] * z[4] * z[7] + 7 * z[1] * z[5] * z[6]
            + 7 * z[2] ** 2 * z[8] + 7 * z[2] * z[3] * z[7] + z[2] * z[5] ** 2
            + z[3] ** 2 * z[6] + 4 * z[3] * z[4] * z[5] + 2 * z[4] ** 3) % P


def u_of_sz(s, z):
    return [z[0], z[1], 7 * z[2] % P, 6 * z[3] % P, (3 * s + 6 * z[4]) % P,
            (s + 3 * z[4]) % P, 6 * z[5] % P, 7 * z[6] % P, z[7], z[8]]


def F7_from_config(u):
    s = 0
    eps = [1] * P7 + [P7 - 1] * P7
    for row, e in zip(E7, eps):
        t = sum(row[j] * u[j] for j in range(6)) % P7
        s += e * t * t * t
    return s % P7


def Ibin(a, b, c, d, e):
    return (a * e - 4 * b * d + 3 * c * c) % P7


def Jbin(a, b, c, d, e):
    return (a * c * e + 2 * b * c * d - a * d * d - b * b * e - c ** 3) % P7


def rank_mod(M, p):
    m = [r[:] for r in M]
    n = len(m)
    r = 0
    for c in range(len(m[0])):
        pr = next((i for i in range(r, n) if m[i][c] % p), None)
        if pr is None:
            continue
        m[r], m[pr] = m[pr], m[r]
        iv = pow(m[r][c], p - 2, p)
        m[r] = [x * iv % p for x in m[r]]
        for i in range(n):
            if i != r and m[i][c] % p:
                f = m[i][c]
                m[i] = [(m[i][j] - f * m[r][j]) % p for j in range(len(m[0]))]
        r += 1
    return r


def main():
    random.seed(11)
    ms, es, xs, _ = build()
    ok = True
    for _ in range(200):
        s = random.randrange(P)
        z = [random.randrange(P) for _ in range(9)]
        if F11_from_config(xs, es, u_of_sz(s, z)) != (4 * s * I2(z) + 2 * I3(z)) % P:
            ok = False
    print(f"F_11(u(s,z)) = 4 s I_2(z) + 2 I_3(z) at 200 random points: {ok}")

    # (s, z) as coordinates on the logical space; where does W sit?
    with open("out/decomp.pkl", "rb") as fh:
        Dd = pickle.load(fh)
    W = Dd["W"]
    cols = []
    for j in range(10):
        sz = [0] * 10
        sz[j] = 1
        cols.append(u_of_sz(sz[0], sz[1:]))
    Mu = [[cols[j][i] for j in range(10)] for i in range(10)]     # u = Mu (s,z)
    Minv = matinv(Mu)
    Wsz = matmul(Minv, W)
    print(f"s-row of the V_5 summand in (s,z) coordinates: {Wsz[0]}  "
          f"(zero means W lies in the octavic space)")
    triv = Dd["projs"]["triv"]
    Rt, pt = rref([r[:] for r in [[triv[i][j] for j in range(10)] for i in range(10)]], 10)
    trivvec = [triv[i][0] for i in range(10)]
    if not any(trivvec):
        trivvec = next([triv[i][k] for i in range(10)] for k in range(10)
                       if any(triv[i][k] for i in range(10)))
    tsz = matmul(Minv, [[x] for x in trivvec])
    print(f"s-coordinate of the A_5-trivial summand: {tsz[0][0]} (nonzero)")

    # V_4 summand also lies in the octavic space
    p4 = Dd["projs"]["V4"]
    v4 = [[p4[i][k] for i in range(10)] for k in range(10)]
    s4 = {matmul(Minv, [[x] for x in col])[0][0] for col in v4}
    print(f"s-coordinates of the V_4 summand's spanning set: {sorted(s4)}")

    # ---------------- p = 7
    ok7 = True
    for _ in range(200):
        s, a, b, c, d, e = [random.randrange(P7) for _ in range(6)]
        u = [a, b, (s + c) % P7, (3 * s + c) % P7, d, e]
        if F7_from_config(u) != (4 * s * Ibin(a, b, c, d, e) + 3 * Jbin(a, b, c, d, e)) % P7:
            ok7 = False
    print(f"\nF_7(u(s,a,b,c,d,e)) = 4 s I + 3 J at 200 random points: {ok7}")

    # singular locus and Hessian census of J over F_7
    def gradJ(v):
        a, b, c, d, e = v
        return [(c * e - d * d) % P7, (2 * c * d - 2 * b * e) % P7,
                (a * e + 2 * b * d - 3 * c * c) % P7, (2 * b * c - 2 * a * d) % P7,
                (a * c - b * b) % P7]

    pts = []
    for lead in range(5):
        for tail in range(P7 ** (4 - lead)):
            v = [0] * 5
            v[lead] = 1
            t = tail
            for s2 in range(4 - lead):
                v[lead + 1 + s2] = t % P7
                t //= P7
            pts.append(tuple(v))
    sing = [v for v in pts if not any(gradJ(v))]
    gp = all(rank_mod([list(x) for x in sub], P7) == 5
             for sub in itertools.combinations(sing, 5))
    print(f"J over F_7: {len(sing)} singular projective points "
          f"(|P^1(F_7)| = {P7 + 1}), in general position: {gp}")

    # Hessian rank census of 3J over F_7^5
    def hessJ(v):
        a, b, c, d, e = v
        return [[0, 0, e, -2 * d, c], [0, -2 * e, 2 * d, 2 * c, -2 * b],
                [e, 2 * d, -6 * c, 2 * b, a], [-2 * d, 2 * c, 2 * b, -2 * a, 0],
                [c, -2 * b, a, 0, 0]]

    counts = {}
    for v in itertools.product(range(P7), repeat=5):
        r = rank_mod([[x % P7 for x in row] for row in hessJ(v)], P7)
        counts[r] = counts.get(r, 0) + 1
    print(f"Hessian-rank census of J over F_7^5: "
          f"{tuple(counts.get(r, 0) for r in range(6))}")


if __name__ == "__main__":
    main()
