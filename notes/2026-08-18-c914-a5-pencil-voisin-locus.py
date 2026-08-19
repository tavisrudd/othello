#!/usr/bin/env python3
"""C914: the A_5-pencil against Voisin's odd-degree-isogeny criterion.

Input data, taken from the epilogue manuscript and from Hartlieb:

  * the geometric generic fibre J of the nonstandard A_5-cubic pencil satisfies
    H_1(J, Q) = W_5 tensor H_1(E, Q) for an elliptic curve E, and
  * the six norm-image elliptic axes give a map f : A -> J from the quotient of
    E^Omega by the sum, whose Rosati Gram matrix is G_6 = 6 I_6 - J_6; choosing
    any five axes identifies H_1(A, Z) with Z^5 tensor H_1(E, Z), on which the
    pulled-back polarization form is G = 6 I_5 - J_5 tensor omega, of Smith type
    (1, 6, 6, 6, 6); the kernel of f is an A_5-stable maximal isotropic subgroup
    of the discriminant group.

The script works with that lattice model and answers one question: is there a
sublattice of H_1(J, Z) of ODD index that splits into orthogonal sub-Hodge
structures of dimension at most three, each carrying m times a unimodular
alternating form with m odd?  A positive answer is exactly Voisin's criterion
(arXiv:1407.7261, proof of Theorem 4.5) for the algebraicity of theta^4/4!.

Everything is exact integer/rational arithmetic; no dependencies.

Replay:  python3 notes/2026-08-18-c914-a5-pencil-voisin-locus.py
         (add --json <path> to write the certificate)
"""

from fractions import Fraction as Fr
from itertools import product
import json
import sys

# ---------------------------------------------------------------- linear algebra


def matmul(A, B):
    return [[sum(A[i][k] * B[k][j] for k in range(len(B))) for j in range(len(B[0]))]
            for i in range(len(A))]


def transp(A):
    return [list(r) for r in zip(*A)]


def det(A):
    A = [[Fr(x) for x in r] for r in A]
    n = len(A)
    d = Fr(1)
    for i in range(n):
        p = None
        for r in range(i, n):
            if A[r][i] != 0:
                p = r
                break
        if p is None:
            return Fr(0)
        if p != i:
            A[i], A[p] = A[p], A[i]
            d = -d
        d *= A[i][i]
        piv = A[i][i]
        for r in range(i + 1, n):
            f = A[r][i] / piv
            if f:
                A[r] = [A[r][c] - f * A[i][c] for c in range(n)]
    return d


def elementary_divisors(mat):
    """Smith normal form invariant factors of an integer matrix."""
    A = [row[:] for row in mat]
    m, n = len(A), len(A[0])
    res = []
    r = c = 0
    while r < m and c < n:
        piv = None
        best = None
        for i in range(r, m):
            for j in range(c, n):
                if A[i][j] and (best is None or abs(A[i][j]) < best):
                    best, piv = abs(A[i][j]), (i, j)
        if piv is None:
            break
        i, j = piv
        A[r], A[i] = A[i], A[r]
        for row in A:
            row[c], row[j] = row[j], row[c]
        again = True
        while again:
            again = False
            for i in range(r + 1, m):
                if A[i][c]:
                    q = A[i][c] // A[r][c]
                    A[i] = [A[i][k] - q * A[r][k] for k in range(n)]
                    if A[i][c]:
                        A[r], A[i] = A[i], A[r]
                        again = True
            for j in range(c + 1, n):
                if A[r][j]:
                    q = A[r][j] // A[r][c]
                    for row in A:
                        row[j] -= q * row[c]
                    if A[r][j]:
                        for row in A:
                            row[c], row[j] = row[j], row[c]
                        again = True
        res.append(abs(A[r][c]))
        r += 1
        c += 1
    # normalize to a divisibility chain
    for i in range(len(res)):
        for j in range(i + 1, len(res)):
            a, b = res[i], res[j]
            g = gcd(a, b)
            res[i], res[j] = g, a * b // g
    return res


def gcd(a, b):
    while b:
        a, b = b, a % b
    return abs(a)


def hnf_rows(rows):
    """Row-style Hermite normal form; returns a basis of the row lattice."""
    A = [row[:] for row in rows]
    n = len(A[0])
    basis = []
    col = 0
    while col < n and A:
        nz = [i for i in range(len(A)) if A[i][col]]
        while len(nz) > 1:
            nz.sort(key=lambda i: abs(A[i][col]))
            p = nz[0]
            for i in nz[1:]:
                q = A[i][col] // A[p][col]
                A[i] = [A[i][k] - q * A[p][k] for k in range(n)]
            nz = [i for i in range(len(A)) if A[i][col]]
        if nz:
            p = nz[0]
            basis.append(A[p])
            A = [A[i] for i in range(len(A)) if i != p]
        col += 1
    return basis


# ---------------------------------------------------------------- the A_5 model

def _act(mat, z):
    a, b, c, d = mat
    if z == 5:
        num, den = a, c
    else:
        num, den = (a * z + b) % 5, (c * z + d) % 5
    if den % 5 == 0:
        return 5
    return (num * pow(den, 3, 5)) % 5


def _perm(mat):
    return tuple(_act(mat, z) for z in range(6))


def _mulp(p, q):
    return tuple(p[q[i]] for i in range(6))


def a5_on_six_points():
    """A_5 = PSL(2,5) on P^1(F_5); the six points are the six D_5-axes."""
    gens = [_perm((1, 1, 0, 1)), _perm((0, 4, 1, 0))]
    grp = {tuple(range(6))}
    frontier = [tuple(range(6))]
    while frontier:
        p = frontier.pop()
        for g in gens:
            r = _mulp(g, p)
            if r not in grp:
                grp.add(r)
                frontier.append(r)
    return sorted(grp)


A5 = a5_on_six_points()
assert len(A5) == 60

# axis Gram in the basis of the first five axis classes, sixth = minus their sum
G = [[(6 if i == j else 0) - 1 for j in range(5)] for i in range(5)]


def rho(sig):
    cols = []
    for i in range(5):
        j = sig[i]
        col = [0] * 5
        if j < 5:
            col[j] = 1
        else:
            col = [-1] * 5
        cols.append(col)
    return transp(cols)


for sig in A5:
    R = rho(sig)
    assert matmul(transp(R), matmul(G, R)) == G

OMEGA = [[0, 1], [-1, 0]]
S = [[0] * 10 for _ in range(10)]
for i in range(5):
    for j in range(5):
        for a in range(2):
            for b in range(2):
                S[2 * i + a][2 * j + b] = G[i][j] * OMEGA[a][b]


def qform(u, v):
    return sum(u[i] * G[i][j] * v[j] for i in range(5) for j in range(5))


# ------------------------------------------------- the 2-primary discriminant


def rref2(rows):
    rows = [r[:] for r in rows]
    n = len(rows[0]) if rows else 0
    piv = []
    r = 0
    for c in range(n):
        pr = None
        for i in range(r, len(rows)):
            if rows[i][c]:
                pr = i
                break
        if pr is None:
            continue
        rows[r], rows[pr] = rows[pr], rows[r]
        for i in range(len(rows)):
            if i != r and rows[i][c]:
                rows[i] = [rows[i][k] ^ rows[r][k] for k in range(n)]
        piv.append(c)
        r += 1
        if r == len(rows):
            break
    return [row for row in rows if any(row)], piv


def kernel2(A):
    n = len(A[0])
    R, piv = rref2(A)
    free = [c for c in range(n) if c not in piv]
    basis = []
    for f in free:
        v = [0] * n
        v[f] = 1
        for r, c in enumerate(piv):
            v[c] = R[r][f]
        basis.append(v)
    return basis


S2 = [[S[i][j] % 2 for j in range(10)] for i in range(10)]
D2_BASIS = kernel2(S2)          # x = v/2 with v in ker(S mod 2)


def rho10(sig):
    R = rho(sig)
    M = [[0] * 10 for _ in range(10)]
    for i in range(5):
        for j in range(5):
            for a in range(2):
                M[2 * i + a][2 * j + a] = R[i][j] % 2
    return M


ACT10 = [rho10(s) for s in A5]


def applyv(M, v):
    return [sum(M[i][j] * v[j] for j in range(10)) % 2 for i in range(10)]


def disc_pair(v, w):
    t = sum(v[i] * S[i][j] * w[j] for i in range(10) for j in range(10))
    assert t % 2 == 0
    return (t // 2) % 2


def span2(vecs):
    R, _ = rref2([list(v) for v in vecs])
    return tuple(tuple(r) for r in R)


def elements2(sub):
    els = [[0] * 10]
    for b in sub:
        els = els + [[e[k] ^ b[k] for k in range(10)] for e in els]
    return els


def glue_groups():
    """A_5-stable maximal isotropic subgroups of the 2-primary discriminant."""
    vecs = []
    for coeff in product([0, 1], repeat=len(D2_BASIS)):
        if not any(coeff):
            continue
        v = [0] * 10
        for c, b in zip(coeff, D2_BASIS):
            if c:
                v = [v[k] ^ b[k] for k in range(10)]
        vecs.append(v)
    cyclic = {span2([applyv(M, v) for M in ACT10]) for v in vecs}
    subs = set(cyclic) | {()}
    changed = True
    while changed:
        changed = False
        new = set()
        for a in subs:
            for b in cyclic:
                s = span2([list(x) for x in a] + [list(x) for x in b]) if a else b
                if s not in subs:
                    new.add(s)
        if new:
            subs |= new
            changed = True
    out = []
    for s in subs:
        if len(s) != 4:
            continue
        els = elements2(s)
        if all(disc_pair(x, y) == 0 for x in els for y in els):
            out.append(s)
    return sorted(out)


# ------------------------------------------------------ the (1,2,2) splitting

# U1 = <e1>;  U2 = <5e2+e1, 5e3+e1>;  U3 = the G-orthogonal complement of both.
LAM1 = [[1, 0, 0, 0, 0]]
LAM2 = [[0, 1, -1, 0, 0], [1, 5, 0, 0, 0]]
LAM3 = [[0, 0, 0, 1, -1], [1, 1, 1, 0, 3]]
PIECES_W = [LAM1, LAM2, LAM3]

# the second splitting: U1 = <e1> and its full G-orthogonal complement
PIECES_1_4 = [[[1, 0, 0, 0, 0]],
              [[1, 5, 0, 0, 0], [0, -1, 1, 0, 0], [0, -1, 0, 1, 0], [0, -1, 0, 0, 1]]]


def tensor_with_M(basis):
    out = []
    for v in basis:
        for a in range(2):
            w = [0] * 10
            for i in range(5):
                w[2 * i + a] = v[i]
            out.append(w)
    return out


def piece_lattice(basis10, glue):
    """L_K intersected with the span of basis10, as a basis of row vectors over Q."""
    els = set(tuple(e) for e in elements2(glue))
    gens = [[Fr(x) for x in b] for b in basis10]
    k = len(basis10)
    for coeff in product([0, 1], repeat=k):
        if not any(coeff):
            continue
        v = [0] * 10
        for c, b in zip(coeff, basis10):
            if c:
                v = [(v[i] + c * b[i]) for i in range(10)]
        if tuple(x % 2 for x in v) in els:
            gens.append([Fr(x, 2) for x in v])
    scaled = [[int(x * 2) for x in g] for g in gens]
    hb = hnf_rows(scaled)
    return [[Fr(x, 2) for x in row] for row in hb]


def gram(basis):
    return [[sum(u[i] * S[i][j] * v[j] for i in range(10) for j in range(10))
             for v in basis] for u in basis]



def test_split(pieces_w, glue):
    pieces = [piece_lattice(tensor_with_M(p), glue) for p in pieces_w]
    dets = []
    eds = []
    for p in pieces:
        gm = gram(p)
        d = det(gm)
        if d.denominator != 1:
            return None
        dets.append(int(d))
        eds.append(elementary_divisors([[int(x) for x in row] for row in gm]))
    stacked = [row for p in pieces for row in p]
    index = abs(det(stacked)) * 16
    if index.denominator != 1:
        return None
    ok = all(d % 2 == 1 for d in dets) and int(index) % 2 == 1
    return {"piece_dims": [len(p) for p in pieces_w],
            "pieces_w": [[list(map(int, v)) for v in p] for p in pieces_w],
            "piece_form_dets": dets,
            "piece_form_elementary_divisors": eds,
            "index_in_L": int(index),
            "ok": ok}


# ------------------------------------------- the coefficient heart H_2 and F_4


def coefficient_heart():
    """H_2 = 2-torsion of Lambda*/Lambda, realized as ker(G mod 2) in F_2^5."""
    G2 = [[G[i][j] % 2 for j in range(5)] for i in range(5)]
    basis = kernel2(G2)
    els = []
    for c in product([0, 1], repeat=len(basis)):
        v = [0] * 5
        for ci, b in zip(c, basis):
            if ci:
                v = [v[k] ^ b[k] for k in range(5)]
        els.append(tuple(v))
    return basis, sorted(set(els))


def heart_pairing(x, y):
    """discriminant pairing of two 2-torsion classes, in (1/2)Z/Z ~ F_2."""
    val = Fr(qform([Fr(a) for a in x], [Fr(a) for a in y]), 4)
    return int((val * 2) % 2)


def heart_commutant(basis, els):
    """all A_5-equivariant F_2-endomorphisms of H_2, as image tuples."""
    acts = [[[rho(s)[i][j] % 2 for j in range(5)] for i in range(5)] for s in A5]

    def ap(M, v):
        return tuple(sum(M[i][j] * v[j] for j in range(5)) % 2 for i in range(5))

    coords = {}
    n = len(basis)
    for v in els:
        for c in product([0, 1], repeat=n):
            w = [0] * 5
            for ci, b in zip(c, basis):
                if ci:
                    w = [w[k] ^ b[k] for k in range(5)]
            if tuple(w) == v:
                coords[v] = c
                break

    def mk(images):
        def phi(v):
            w = [0] * 5
            for ci, im in zip(coords[tuple(v)], images):
                if ci:
                    w = [w[k] ^ im[k] for k in range(5)]
            return tuple(w)
        return phi

    out = []
    for images in product(els, repeat=n):
        phi = mk(images)
        good = True
        for M in acts:
            for b in basis:
                if phi(ap(M, b)) != ap(M, phi(b)):
                    good = False
                    break
            if not good:
                break
        if good:
            out.append(images)
    return out, mk


def glue_scalar(g, els, mk_phi, commutant):
    """express a glue group as a graph {(x, phi x)} or a rational slot."""
    def slots(e):
        return [tuple(e[2 * i] for i in range(5)), tuple(e[2 * i + 1] for i in range(5))]
    members = [slots(e) for e in elements2(g)]
    first = [a for a, b in members]
    second = [b for a, b in members]
    if all(all(x == 0 for x in b) for a, b in members):
        return "slot1"
    if all(all(x == 0 for x in a) for a, b in members):
        return "slot2"
    for images in commutant:
        phi = mk_phi(images)
        if all(tuple(b) == phi(a) for a, b in members):
            order = 1
            f = phi
            probe = [v for v in els if any(v)][0]
            seq = [probe]
            cur = probe
            for _ in range(4):
                cur = phi(cur)
                seq.append(cur)
                if cur == probe:
                    break
            return "graph(order %d)" % (len(seq) - 1)
    return "other"


def main():
    report = {}
    report["det_G"] = int(det(G))
    report["smith_G"] = elementary_divisors(G)
    report["det_S"] = int(det(S))
    report["smith_S"] = elementary_divisors(S)
    report["dim_D2"] = len(D2_BASIS)

    for a in range(3):
        for b in range(3):
            if a == b:
                continue
            for u in PIECES_W[a]:
                for v in PIECES_W[b]:
                    assert qform(u, v) == 0, "canonical (1,2,2) pieces not orthogonal"
    for p in PIECES_W:
        assert set(elementary_divisors(p)) == {1}, "piece not saturated in Z^5"
    for a in range(2):
        for b in range(2):
            if a == b:
                continue
            for u in PIECES_1_4[a]:
                for v in PIECES_1_4[b]:
                    assert qform(u, v) == 0, "canonical (1,4) pieces not orthogonal"
    for p in PIECES_1_4:
        assert set(elementary_divisors(p)) == {1}, "piece not saturated in Z^5"

    # 2-adic Jordan data of the axis form: <5> orthogonal to 2 * (even unimodular)
    comp = [[Fr(1, 5) if i == 0 else (1 if i == j else 0) for i in range(5)]
            for j in range(1, 5)]
    halved = [[qform([Fr(x) for x in u], [Fr(x) for x in v]) / 2 for v in comp]
              for u in comp]
    report["complement_gram_halved"] = [[str(x) for x in row] for row in halved]
    report["complement_halved_det"] = str(det(halved))
    report["complement_halved_is_even"] = all(
        halved[i][i].numerator % 2 == 0 and halved[i][i].denominator % 2 == 1
        for i in range(4))

    # the coefficient heart, its F_4 structure, and the discriminant pairing
    hbasis, hels = coefficient_heart()
    commutant, mk_phi = heart_commutant(hbasis, hels)
    report["dim_H2"] = len(hbasis)
    report["commutant_size"] = len(commutant)
    omega = None
    for images in commutant:
        phi = mk_phi(images)
        if all(phi(v) != v for v in hels if any(v)) and            all(phi(phi(phi(v))) == v for v in hels):
            omega = phi
            break
    assert omega is not None, "no F_4 scalar of order three"
    lines = set()
    for v in hels:
        if any(v):
            lines.add(frozenset([tuple([0] * 5), v, omega(v), omega(omega(v))]))
    report["num_F4_lines"] = len(lines)
    line_data = []
    for l in sorted(lines, key=lambda s: sorted(s)):
        els = sorted(l)
        perp = frozenset(w for w in hels if all(heart_pairing(w, x) == 0 for x in els))
        line_data.append({
            "line": [list(v) for v in els[1:]],
            "isotropic": all(heart_pairing(x, y) == 0 for x in els for y in els),
            "perp_size": len(perp),
            "perp_equals_line": perp == l,
        })
    report["F4_lines"] = line_data
    report["every_F4_line_is_its_own_perp"] = all(d["perp_equals_line"] for d in line_data)

    glues = glue_groups()
    report["num_glue_groups"] = len(glues)
    per_glue = []
    for g in glues:
        entry = {"generators": [list(v) for v in g],
                 "type": glue_scalar(g, hels, mk_phi, commutant)}
        entry["split_1_2_2"] = test_split(PIECES_W, g)
        entry["split_1_4"] = test_split(PIECES_1_4, g)
        per_glue.append(entry)
    report["per_glue"] = per_glue
    report["rational_glues_split_1_2_2"] = [
        e["split_1_2_2"]["ok"] for e in per_glue if e["type"] != "graph(order 3)"]
    report["exotic_glues_split_1_2_2"] = [
        e["split_1_2_2"]["ok"] for e in per_glue if e["type"] == "graph(order 3)"]
    report["all_glues_split_1_4"] = all(e["split_1_4"]["ok"] for e in per_glue)

    print(json.dumps(report, indent=1, sort_keys=True))
    if "--json" in sys.argv:
        path = sys.argv[sys.argv.index("--json") + 1]
        with open(path, "w") as fh:
            json.dump(report, fh, indent=1, sort_keys=True)
            fh.write("\n")


if __name__ == "__main__":
    main()
