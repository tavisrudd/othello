#!/usr/bin/env python3
"""characteristic_zero independent replay. Imports no primary code.

Independently re-verifies:
  - T^2-T-1 mod 11 factors as (T-4)(T-8); sigma: T->1-T swaps the roots;
  - the golden_six_arc descended decoration is rational (one matching at both primes);
  - h^T h = G mod 11, sqrt5 reduces to Galois-conjugate 4 / 7 at phi = 8 / 4;
  - Hilbert-90 transport yields two distinct golden sheets that lie in one
    PGL_2(11) orbit but different PSL_2(11) orbits (an outer, nonsquare-det swap).
PGL/PSL are built by full enumeration of GL_2(F_11) modulo scalars, and the conic
is parametrised from a different base point than the primary.
"""
import json, hashlib, os
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
q = 11
PIN = {
    "golden-six-arc.json": "d4e037ce13702b42",
    "characteristic-eleven-gluing.json": "9f649c40b4649f2d",
}


def pin(name):
    p = os.path.join(HERE, name)
    h = hashlib.sha256(open(p, "rb").read()).hexdigest()[:16]
    assert h == PIN[name], f"{name}: {h} != {PIN[name]}"
    return json.load(open(p))


def rf(s):
    f = Fraction(s)
    return int(f.numerator * pow(int(f.denominator), q - 2, q)) % q


def cell(c, phi):
    return (rf(c[0]) + rf(c[1]) * phi) % q


def pn(p):
    for e in p:
        if e % q:
            s = pow(e % q, q - 2, q)
            return tuple((x * s) % q for x in p)
    return p


def conic_pts(C):
    return [pn(v) for v in ([(1, y, z) for y in range(q) for z in range(q)] +
            [(0, 1, z) for z in range(q)] + [(0, 0, 1)])
            if sum(v[i] * C[i][j] * v[j] for i in range(3) for j in range(3)) % q == 0]


def polar_match(C, arc, cp):
    out = []
    for P in arc:
        L = [sum(C[i][j] * P[j] for j in range(3)) % q for i in range(3)]
        out.append(tuple(sorted(Q for Q in cp if sum(L[i] * Q[i] for i in range(3)) % q == 0)))
    return frozenset(out)


def matmul(M, v):
    return tuple(sum(M[i][j] * v[j] for j in range(3)) % q for i in range(3))


def full_pgl():
    seen = {}
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    m = (a, b, c, d)
                    for e in m:
                        if e % q:
                            s = pow(e % q, q - 2, q)
                            seen[tuple((x * s) % q for x in m)] = True
                            break
    return list(seen)


def det(m):
    a, b, c, d = m
    return (a * d - b * c) % q


def mob(m, x):
    a, b, c, d = m
    if x == q:
        return q if c % q == 0 else (a * pow(c, q - 2, q)) % q
    den = (c * x + d) % q
    return q if den == 0 else ((a * x + b) % q * pow(den, q - 2, q)) % q


def act(m, M):
    return frozenset(tuple(sorted((mob(m, a), mob(m, b)))) for a, b in M)


def main():
    golden_six_arc = pin("golden-six-arc.json")
    pin("characteristic-eleven-gluing.json")
    rep = golden_six_arc["representative"]
    pts = rep["descended_arc_projective_points"]
    Gm = [[rf(rep["descended_conic_gram"][i][j]) for j in range(3)] for i in range(3)]
    hh = rep["hilbert90_h"]

    roots = sorted(t for t in range(q) if (t * t - t - 1) % q == 0)
    assert roots == [4, 8] and sorted((1 - r) % q for r in roots) == roots

    cpG = conic_pts(Gm)
    arc = {phi: [pn(tuple(cell(P[k], phi) for k in range(3))) for P in pts] for phi in (8, 4)}
    assert polar_match(Gm, arc[8], cpG) == polar_match(Gm, arc[4], cpG)

    I = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    cpI = conic_pts(I)
    sheets = {}
    for phi in (8, 4):
        hp = [[cell(hh[i][j], phi) for j in range(3)] for i in range(3)]
        hT = [[hp[j][i] for j in range(3)] for i in range(3)]
        assert [[sum(hT[i][k] * hp[k][j] for k in range(3)) % q for j in range(3)]
                for i in range(3)] == Gm
        Sarc = [pn(matmul(hp, P)) for P in arc[phi]]
        sheets[phi] = polar_match(I, Sarc, cpI)
    assert {(2 * 8 - 1) % q, (2 * 4 - 1) % q} == {4, 7}
    assert sheets[8] != sheets[4]

    # independent parametrisation from a different base point
    def dot(a, b):
        return sum(a[i] * b[i] for i in range(3)) % q

    def crs(u, v):
        return ((u[1] * v[2] - u[2] * v[1]) % q, (u[2] * v[0] - u[0] * v[2]) % q,
                (u[0] * v[1] - u[1] * v[0]) % q)

    O = cpI[5]
    tan = (2 * O[0] % q, 2 * O[1] % q, 2 * O[2] % q)
    Ln = next(c for c in [(0, 0, 1), (0, 1, 0), (1, 0, 0), (1, 1, 1)] if dot(c, O))
    bM = [P for P in [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (1, 0, 1),
                      (0, 1, 1), (1, 1, 1)] if dot(Ln, P) == 0][:2]

    def lc(X):
        for (al, be) in [(1, t) for t in range(q)] + [(0, 1)]:
            if pn(tuple((al * bM[0][i] + be * bM[1][i]) % q for i in range(3))) == pn(X):
                return q if be == 0 else (al * pow(be, q - 2, q)) % q
        raise RuntimeError

    idx = {}
    for P in cpI:
        ell = tan if pn(P) == O else crs(O, pn(P))
        idx[pn(P)] = lc(crs(ell, Ln))
    assert sorted(idx.values()) == list(range(12))

    def to_p1(M):
        return frozenset(tuple(sorted((idx[a], idx[b]))) for a, b in M)

    m8, m4 = to_p1(sheets[8]), to_p1(sheets[4])
    G = full_pgl()
    PSL = [m for m in G if pow(det(m), (q - 1) // 2, q) == 1]
    orbit = {act(m, m8) for m in G}
    psl8 = {act(m, m8) for m in PSL}
    psl4 = {act(m, m4) for m in PSL}
    assert m4 in orbit and m4 not in psl8 and m8 not in psl4
    swap = next(m for m in G if act(m, m8) == m4)
    assert pow(det(swap), (q - 1) // 2, q) == q - 1
    print("characteristic_zero REPLAY OK: char-zero descent is a T_q realization row; "
          "sigma <-> outer coset (nonsquare-det swap of the two golden sheets)")


if __name__ == "__main__":
    main()
