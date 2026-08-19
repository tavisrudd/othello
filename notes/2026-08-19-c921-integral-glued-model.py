#!/usr/bin/env python3
"""C921 - the integral glued model of the four-dimensional factor.

Certifies, by exact integer linear algebra over Z, the lattice statements of
notes/2026-08-19-c921-integral-glued-model.md.

Objects.

  Omega   six axes; A_5 = PSL_2(F_5) acts two-transitively on them.
  Lambda  Z^Omega / Z 1, rank five, Gram G = 6 I_5 - J_5 in the basis
          f_1..f_5 of the classes of e_1..e_5; the class of the sixth axis is
          v = -(f_1 + ... + f_5), and kappa(v,v) = 5.
  M       H_1(E_b, Z), rank two, unimodular alternating form.
  L       H_1(J(X_b), Z): the unimodular overlattice of Lambda tensor M glued
          along the maximal isotropic A_5-stable kernel K = K_2 + K_3 of order
          6^4, with K_2 the exotic F_4-graph in H_2 tensor E[2] and
          K_3 = H_3 tensor C for a line C in E[3].
  L_1     L intersected with Qv tensor M_Q         (the elliptic factor E')
  L_4     L intersected with N_Q tensor M_Q,  N = v^perp   (the fourfold A_b)

Claims checked.

  A  det G = 6^4, Smith(G) = (1,6,6,6,6), disc(Lambda) = (Z/6)^4.
  B  N = v^perp is the A_4 root lattice scaled by six.
  C  [Lambda : Zv + N] = 5, prime to six.
  D  H_p = disc(Lambda)_p is a simple F_p A_5-module of dimension four, with
     commutant F_4 at p = 2 and F_3 at p = 3; the field-of-four scalar exists.
  E  The glued L is integral, unimodular and A_5-stable, of index 6^4 over
     Lambda tensor M, for the exotic and for a rational two-primary kernel.
  F  L_1 has symplectic type (5); L_4 has determinant 25 and symplectic type
     (1,1,1,5); [L : L_1 + L_4] = 25, all of it at the prime five.  So the
     four-dimensional factor is NOT principally polarized.
  G  disc(L_4) = (Z/5)^2 has exactly six subgroups of order five, each
     isotropic and each giving a unimodular overlattice of L_4: six principal
     polarizations.  The axis stabilizer D_5 acts through +-1 and fixes all
     six of them.
  H  Dropping the three-primary glue reproduces C914's rank-eight elementary
     divisors (3,3,3,3,3,3,15,15), which is how that task's script was built.

Replay:

    python3 notes/2026-08-19-c921-integral-glued-model.py \
        > notes/2026-08-19-c921-integral-glued-model.txt
    python3 notes/2026-08-19-c921-integral-glued-model.py --check \
        notes/2026-08-19-c921-integral-glued-model.txt

No third-party dependencies.
"""

from __future__ import annotations

import io
import sys
from fractions import Fraction as F
from itertools import product

# ------------------------------------------------------------- linear algebra


def mat_mul(A, B):
    n, k, m = len(A), len(B), len(B[0])
    return [[sum(A[i][t] * B[t][j] for t in range(k)) for j in range(m)]
            for i in range(n)]


def mat_T(A):
    return [list(c) for c in zip(*A)]


def identity(n):
    return [[1 if i == j else 0 for j in range(n)] for i in range(n)]


def det_exact(A):
    A = [[F(x) for x in row] for row in A]
    n = len(A)
    sign, out = 1, F(1)
    for c in range(n):
        piv = next((r for r in range(c, n) if A[r][c] != 0), None)
        if piv is None:
            return F(0)
        if piv != c:
            A[c], A[piv] = A[piv], A[c]
            sign = -sign
        out *= A[c][c]
        for r in range(c + 1, n):
            if A[r][c]:
                f = A[r][c] / A[c][c]
                for j in range(c, n):
                    A[r][j] -= f * A[c][j]
    return sign * out


def inverse_exact(A):
    n = len(A)
    aug = [[F(A[i][j]) for j in range(n)] + [F(1 if i == j else 0)
                                             for j in range(n)] for i in range(n)]
    for c in range(n):
        piv = next(r for r in range(c, n) if aug[r][c] != 0)
        aug[c], aug[piv] = aug[piv], aug[c]
        pv = aug[c][c]
        aug[c] = [x / pv for x in aug[c]]
        for r in range(n):
            if r != c and aug[r][c]:
                f = aug[r][c]
                aug[r] = [x - f * y for x, y in zip(aug[r], aug[c])]
    return [row[n:] for row in aug]


def hnf_with_transform(A):
    """Row Hermite form: returns (H, U) with U unimodular and U A = H."""
    A = [list(map(int, row)) for row in A]
    n = len(A)
    m = len(A[0]) if n else 0
    U = identity(n)
    row = 0
    for col in range(m):
        if row >= n:
            break
        piv = None
        for r in range(row, n):
            if A[r][col] and (piv is None or abs(A[r][col]) < abs(A[piv][col])):
                piv = r
        if piv is None:
            continue
        A[row], A[piv] = A[piv], A[row]
        U[row], U[piv] = U[piv], U[row]
        again = True
        while again:
            again = False
            for r in range(row + 1, n):
                if A[r][col]:
                    q = A[r][col] // A[row][col]
                    if q:
                        A[r] = [x - q * y for x, y in zip(A[r], A[row])]
                        U[r] = [x - q * y for x, y in zip(U[r], U[row])]
                    if A[r][col]:
                        A[row], A[r] = A[r], A[row]
                        U[row], U[r] = U[r], U[row]
                        again = True
        if A[row][col] < 0:
            A[row] = [-x for x in A[row]]
            U[row] = [-x for x in U[row]]
        for r in range(row):
            if A[r][col]:
                q = A[r][col] // A[row][col]
                if q:
                    A[r] = [x - q * y for x, y in zip(A[r], A[row])]
                    U[r] = [x - q * y for x, y in zip(U[r], U[row])]
        row += 1
    return A, U


def lattice_basis(rows):
    H, _ = hnf_with_transform(rows)
    return [r for r in H if any(r)]


def left_kernel(A):
    H, U = hnf_with_transform(A)
    return [U[i] for i in range(len(H)) if not any(H[i])]


def smith_with_transform(A):
    """Returns (D, U, V) with U A V = diag(D), U and V unimodular."""
    A = [list(map(int, row)) for row in A]
    n, m = len(A), len(A[0])
    U, V = identity(n), identity(m)
    t = 0
    while t < min(n, m):
        piv = None
        for r in range(t, n):
            for c in range(t, m):
                if A[r][c] and (piv is None or
                                abs(A[r][c]) < abs(A[piv[0]][piv[1]])):
                    piv = (r, c)
        if piv is None:
            break
        r0, c0 = piv
        A[t], A[r0] = A[r0], A[t]
        U[t], U[r0] = U[r0], U[t]
        for row in A:
            row[t], row[c0] = row[c0], row[t]
        for row in V:
            row[t], row[c0] = row[c0], row[t]
        while True:
            changed = False
            for r in range(t + 1, n):
                if A[r][t]:
                    q = A[r][t] // A[t][t]
                    A[r] = [x - q * y for x, y in zip(A[r], A[t])]
                    U[r] = [x - q * y for x, y in zip(U[r], U[t])]
                    if A[r][t]:
                        A[t], A[r] = A[r], A[t]
                        U[t], U[r] = U[r], U[t]
                        changed = True
            for c in range(t + 1, m):
                if A[t][c]:
                    q = A[t][c] // A[t][t]
                    for row in A:
                        row[c] -= q * row[t]
                    for row in V:
                        row[c] -= q * row[t]
                    if A[t][c]:
                        for row in A:
                            row[t], row[c] = row[c], row[t]
                        for row in V:
                            row[t], row[c] = row[c], row[t]
                        changed = True
            if not changed:
                break
        d = A[t][t]
        bad = None
        for r in range(t + 1, n):
            for c in range(t + 1, m):
                if A[r][c] % d:
                    bad = r
                    break
            if bad is not None:
                break
        if bad is not None:
            A[t] = [x + y for x, y in zip(A[t], A[bad])]
            U[t] = [x + y for x, y in zip(U[t], U[bad])]
            continue
        if d < 0:
            A[t] = [-x for x in A[t]]
            U[t] = [-x for x in U[t]]
        t += 1
    D = [A[i][i] if i < min(n, m) else 0 for i in range(min(n, m))]
    return D, U, V


def smith_divisors(A):
    return [abs(d) for d in smith_with_transform(A)[0]]


def nullspace_mod_p(A, p):
    A = [[x % p for x in row] for row in A]
    m = len(A[0]) if A else 0
    piv_cols, r = [], 0
    for c in range(m):
        piv = next((i for i in range(r, len(A)) if A[i][c] % p), None)
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        inv = pow(A[r][c], p - 2, p)
        A[r] = [(x * inv) % p for x in A[r]]
        for i in range(len(A)):
            if i != r and A[i][c] % p:
                f = A[i][c]
                A[i] = [(x - f * y) % p for x, y in zip(A[i], A[r])]
        piv_cols.append(c)
        r += 1
        if r == len(A):
            break
    out = []
    for f in [c for c in range(m) if c not in piv_cols]:
        vec = [0] * m
        vec[f] = 1
        for i, c in enumerate(piv_cols):
            vec[c] = (-A[i][f]) % p
        out.append(vec)
    return out


# ---------------------------------------------------------------- the lattices

G = [[6 * (i == j) - 1 for j in range(5)] for i in range(5)]
G_INV = [[F(2, 6) if i == j else F(1, 6) for j in range(5)] for i in range(5)]
V6 = [-1] * 5                                  # the class of the sixth axis
J2 = [[0, 1], [-1, 0]]
OMEGA_SIZE = 6


def kappa(x, y):
    return sum(F(x[i]) * G[i][j] * F(y[j]) for i in range(5) for j in range(5))


def a5_generators():
    """z -> z+1 and z -> -1/z on P^1(F_5) = {0,1,2,3,4,inf}, 0-based indices."""
    pts = [0, 1, 2, 3, 4, 'inf']
    idx = {p: i for i, p in enumerate(pts)}

    def shift(z):
        return 'inf' if z == 'inf' else (z + 1) % 5

    def invert(z):
        if z == 'inf':
            return 0
        if z == 0:
            return 'inf'
        return (-pow(z, 3, 5)) % 5

    return [tuple(idx[shift(p)] for p in pts), tuple(idx[invert(p)] for p in pts)]


def perm_closure(gens):
    ident = tuple(range(OMEGA_SIZE))
    seen, frontier = {ident}, [ident]
    while frontier:
        new = []
        for s in frontier:
            for g in gens:
                t = tuple(g[s[i]] for i in range(OMEGA_SIZE))
                if t not in seen:
                    seen.add(t)
                    new.append(t)
        frontier = new
    return sorted(seen)


def rho(sigma):
    """sigma acting on Lambda in the basis f_1..f_5; f_6 := v."""
    cols = []
    for i in range(5):
        j = sigma[i]
        cols.append([1 if k == j else 0 for k in range(5)] if j < 5 else [-1] * 5)
    return mat_T(cols)


def rho10(sigma):
    r = rho(sigma)
    out = [[0] * 10 for _ in range(10)]
    for i in range(5):
        for j in range(5):
            for a in range(2):
                out[2 * i + a][2 * j + a] = r[i][j]
    return out


OM = [[0] * 10 for _ in range(10)]
for _i in range(5):
    for _j in range(5):
        for _a in range(2):
            for _b in range(2):
                OM[2 * _i + _a][2 * _j + _b] = G[_i][_j] * J2[_a][_b]


def pair10(x, y):
    return sum(F(x[i]) * OM[i][j] * F(y[j]) for i in range(10) for j in range(10))


def embed(vec5, slot):
    out = [F(0)] * 10
    for i in range(5):
        out[2 * i + slot] = F(vec5[i])
    return out


def gram_of(basis):
    return [[pair10(x, y) for y in basis] for x in basis]


def scale_int(rows, den):
    return [[int(F(x) * den) for x in row] for row in rows]


def unscale(rows, den):
    return [[F(t, den) for t in row] for row in rows]


def in_lattice(w, basis):
    """Is the rational vector w in the Z-span of the rational rows `basis`?"""
    B = [[F(t) for t in row] for row in basis]
    n = len(B)
    # solve c B = w in Q, then test integrality
    cols = list(range(len(w)))
    Bt = mat_T(B)
    aug = [[Bt[r][c] for c in range(n)] + [F(w[r])] for r in cols]
    # gaussian elimination
    piv_rows, r = [], 0
    for c in range(n):
        piv = next((i for i in range(r, len(aug)) if aug[i][c] != 0), None)
        if piv is None:
            continue
        aug[r], aug[piv] = aug[piv], aug[r]
        pv = aug[r][c]
        aug[r] = [x / pv for x in aug[r]]
        for i in range(len(aug)):
            if i != r and aug[i][c]:
                f = aug[i][c]
                aug[i] = [x - f * y for x, y in zip(aug[i], aug[r])]
        piv_rows.append(c)
        r += 1
    for i in range(r, len(aug)):
        if aug[i][n] != 0:
            return False
    sol = [F(0)] * n
    for i, c in enumerate(piv_rows):
        sol[c] = aug[i][n]
    return all(t.denominator == 1 for t in sol)


# ---------------------------------------------------------------- disc(Lambda)

def disc_data():
    D, U, _ = smith_with_transform([row[:] for row in G])
    Uinv = inverse_exact(U)
    gens = []
    for i in range(5):
        col = [Uinv[r][i] for r in range(5)]
        gens.append([sum(G_INV[r][s] * col[s] for s in range(5)) for r in range(5)])
    return [abs(d) for d in D], U, gens


DORD, UMAT, DGENS = disc_data()


def disc_coords(x):
    u = [sum(G[i][j] * F(x[j]) for j in range(5)) for i in range(5)]
    assert all(t.denominator == 1 for t in u), "not in the dual lattice"
    w = [sum(UMAT[i][j] * int(u[j]) for j in range(5)) for i in range(5)]
    return [w[i] % DORD[i] for i in range(5)]


def heart(p):
    """Basis of H_p inside Lambda^*, its F_p-coordinate map, and the A_5 action."""
    step = 6 // p
    base = [[step * t for t in DGENS[k + 1]] for k in range(4)]

    def coords(x):
        dc = disc_coords(x)
        assert dc[0] == 0
        assert all(t % step == 0 for t in dc[1:])
        return [(t // step) % p for t in dc[1:]]

    return base, coords


class Report:
    def __init__(self):
        self.buf = io.StringIO()
        self.fail = 0

    def say(self, text=""):
        print(text, file=self.buf)

    def check(self, label, ok, detail=""):
        if not ok:
            self.fail += 1
        self.say(f"  [{'OK  ' if ok else 'FAIL'}] {label}"
                 + (f"   {detail}" if detail else ""))


def main():
    R = Report()
    R.say("C921 - integral glued model of the four-dimensional factor")
    R.say("=" * 68)
    R.say()

    # -------------------------------------------------------------------- A
    R.say("A. The six-axis lattice Lambda")
    R.check("det G = 6^4", det_exact(G) == 6 ** 4, f"det = {det_exact(G)}")
    R.check("Smith(G) = (1,6,6,6,6)", smith_divisors(G) == [1, 6, 6, 6, 6],
            str(smith_divisors(G)))
    R.check("kappa(v,v) = 5", kappa(V6, V6) == 5)
    R.check("disc(Lambda) = (Z/6)^4", DORD == [1, 6, 6, 6, 6], f"orders {DORD}")
    R.check("disc generators have order 6",
            all(disc_coords([t * 6 for t in DGENS[i]]) == [0] * 5
                and disc_coords([t * 3 for t in DGENS[i]]) != [0] * 5
                for i in range(1, 5)))
    R.say()

    # -------------------------------------------------------------------- B
    R.say("B. N = v^perp is the A_4 root lattice scaled by six")
    ker = left_kernel([[int(sum(G[i][j] * V6[j] for j in range(5)))]
                       for i in range(5)])
    Nb = lattice_basis(ker)
    R.check("rank N = 4", len(Nb) == 4)
    GN = [[int(kappa(x, y)) for y in Nb] for x in Nb]
    R.check("det N = 6^4 * 5", det_exact(GN) == 6 ** 4 * 5, f"det = {det_exact(GN)}")
    R.check("Gram(N) is six times an integral matrix",
            all(t % 6 == 0 for row in GN for t in row))
    GN6 = [[t // 6 for t in row] for row in GN]
    R.check("Gram(N)/6 is even", all(GN6[i][i] % 2 == 0 for i in range(4)))
    R.check("det(Gram(N)/6) = 5", det_exact(GN6) == 5)
    roots = sum(1 for c in product(range(-3, 4), repeat=4)
                if sum(c[i] * GN6[i][j] * c[j]
                       for i in range(4) for j in range(4)) == 2)
    R.check("twenty vectors of norm two, so A_4", roots == 20, f"count {roots}")
    R.say()

    # -------------------------------------------------------------------- C
    R.say("C. The splitting Zv + N inside Lambda")
    sub = lattice_basis([list(map(int, V6))] + [list(map(int, r)) for r in Nb])
    index = abs(det_exact(sub))
    R.check("[Lambda : Zv + N] = 5", index == 5, f"index {index}")
    R.check("that index is prime to six", index % 2 and index % 3)
    R.say()

    # -------------------------------------------------------------------- D
    R.say("D. The primary coefficient hearts and the field-of-four scalar")
    sigmas = perm_closure(a5_generators())
    R.check("|A_5| = 60", len(sigmas) == 60, f"order {len(sigmas)}")
    R.check("A_5 preserves kappa",
            all(mat_mul(mat_mul(mat_T(rho(s)), G), rho(s)) == G for s in sigmas))

    hearts = {}
    for p in (2, 3):
        base, coords = heart(p)
        acts = []
        for s in sigmas:
            r = rho(s)
            cols = []
            for k in range(4):
                y = [sum(F(r[i][j]) * base[k][j] for j in range(5)) for i in range(5)]
                cols.append(coords(y))
            acts.append(mat_T(cols))
        simple = True
        for c in product(range(p), repeat=4):
            if not any(c):
                continue
            span, frontier = {tuple(c)}, [tuple(c)]
            while frontier:
                nxt = []
                for w in list(frontier):
                    for A in acts:
                        img = tuple(sum(A[i][j] * w[j] for j in range(4)) % p
                                    for i in range(4))
                        if img not in span:
                            span.add(img)
                            nxt.append(img)
                    for u in list(span):
                        s2 = tuple((u[i] + w[i]) % p for i in range(4))
                        if s2 not in span:
                            span.add(s2)
                            nxt.append(s2)
                frontier = nxt
            if len(span) != p ** 4:
                simple = False
                break
        R.check(f"H_{p} is a simple F_{p}A_5-module of dimension four", simple)
        eqs = []
        for A in acts:
            for i in range(4):
                for j in range(4):
                    row = [0] * 16
                    for k in range(4):
                        row[4 * i + k] += A[k][j]
                        row[4 * k + j] -= A[i][k]
                    eqs.append([t % p for t in row])
        comm = nullspace_mod_p(eqs, p)
        want = 2 if p == 2 else 1
        R.check(f"dim End_(A_5)(H_{p}) = {want}", len(comm) == want, f"dim {len(comm)}")
        hearts[p] = (base, coords, comm)

    base2, _, comm2 = hearts[2]
    omega = None
    for c in product(range(2), repeat=len(comm2)):
        if not any(c):
            continue
        flat = [0] * 16
        for t, b in zip(c, comm2):
            if t:
                flat = [(x + y) % 2 for x, y in zip(flat, b)]
        Mm = [[flat[4 * i + j] for j in range(4)] for i in range(4)]
        sq = [[sum(Mm[i][k] * Mm[k][j] for k in range(4)) % 2 for j in range(4)]
              for i in range(4)]
        if all((sq[i][j] + Mm[i][j] + (1 if i == j else 0)) % 2 == 0
               for i in range(4) for j in range(4)):
            omega = Mm
            break
    R.check("the field-of-four scalar omega exists, omega^2 + omega + 1 = 0",
            omega is not None)
    R.say()

    # -------------------------------------------------------------------- E
    R.say("E. Gluing")

    def build(kind, use_three=True):
        base2, _, _ = hearts[2]
        base3, _, _ = hearts[3]
        rows = [[F(1 if k == i else 0) for k in range(10)] for i in range(10)]
        for k in range(4):
            img = [omega[i][k] % 2 for i in range(4)] if kind == 'exotic' \
                else [1 if i == k else 0 for i in range(4)]
            y = [F(0)] * 5
            for i in range(4):
                if img[i]:
                    y = [y[t] + base2[i][t] for t in range(5)]
            rows.append([a + b for a, b in zip(embed(base2[k], 0), embed(y, 1))])
        if use_three:
            for k in range(4):
                rows.append(embed(base3[k], 0))
        return unscale(lattice_basis(scale_int(rows, 6)), 6)

    results = {}
    for kind in ('exotic', 'rational'):
        Lb = build(kind)
        gl = gram_of(Lb)
        integral = all(x.denominator == 1 for row in gl for x in row)
        R.check(f"[{kind}] L is an integral lattice", integral)
        gi = [[int(x) for x in row] for row in gl]
        R.check(f"[{kind}] det Gram(L) = 1", det_exact(gi) == 1, f"det {det_exact(gi)}")
        idxL = 1 / abs(det_exact(Lb))
        R.check(f"[{kind}] [L : Lambda tensor M] = 6^4", idxL == 6 ** 4,
                f"index {idxL}")
        stable = all(in_lattice([sum(F(rho10(s)[i][j]) * F(x[j]) for j in range(10))
                                 for i in range(10)], Lb)
                     for s in a5_generators() for x in Lb)
        R.check(f"[{kind}] L is A_5-stable", stable)
        results[kind] = Lb
    R.say()

    # -------------------------------------------------------------------- F
    R.say("F. The elliptic factor and the four-dimensional factor")
    for kind in ('exotic', 'rational'):
        Lb = results[kind]
        eq1 = [[int(pair10(x, embed(nb, a)) * 6) for nb in Nb for a in range(2)]
               for x in Lb]
        eq4 = [[int(pair10(x, embed(V6, a)) * 6) for a in range(2)] for x in Lb]
        L1 = [[sum(F(c[i]) * F(Lb[i][k]) for i in range(10)) for k in range(10)]
              for c in left_kernel(eq1)]
        L4 = [[sum(F(c[i]) * F(Lb[i][k]) for i in range(10)) for k in range(10)]
              for c in left_kernel(eq4)]
        R.check(f"[{kind}] rank L_1 = 2, rank L_4 = 8",
                len(L1) == 2 and len(L4) == 8, f"{len(L1)}, {len(L4)}")
        g1 = [[int(x) for x in row] for row in gram_of(L1)]
        g4 = [[int(x) for x in row] for row in gram_of(L4)]
        R.check(f"[{kind}] L_1 has symplectic type (5)",
                smith_divisors(g1) == [5, 5], str(smith_divisors(g1)))
        R.check(f"[{kind}] det L_4 = 25", det_exact(g4) == 25, f"det {det_exact(g4)}")
        R.check(f"[{kind}] L_4 has symplectic type (1,1,1,5)",
                smith_divisors(g4) == [1, 1, 1, 1, 1, 1, 5, 5],
                str(smith_divisors(g4)))
        direct = unscale(lattice_basis(scale_int(list(L1) + list(L4), 6)), 6)
        idx14 = abs(det_exact(direct)) / abs(det_exact(Lb))
        R.check(f"[{kind}] [L : L_1 + L_4] = 25", idx14 == 25, f"index {idx14}")
        if kind == 'exotic':
            EX_L, EX_L1, EX_L4, EX_G4 = Lb, L1, L4, g4
    R.say()

    # -------------------------------------------------------------------- G
    R.say("G. The six principal polarizations of the fourfold")
    dg = [d for d in smith_divisors(EX_G4) if d > 1]
    R.check("disc(L_4) = (Z/5)^2", dg == [5, 5], str(dg))
    D4, U4, _ = smith_with_transform([row[:] for row in EX_G4])
    U4inv = inverse_exact(U4)
    G4inv = inverse_exact(EX_G4)
    tors = []
    for i in range(8):
        if abs(D4[i]) == 5:
            col = [U4inv[r][i] for r in range(8)]
            coef = [sum(G4inv[r][s] * col[s] for s in range(8)) for r in range(8)]
            tors.append([sum(coef[j] * F(EX_L4[j][k]) for j in range(8))
                         for k in range(10)])
    R.check("two generators of order five", len(tors) == 2)
    lines = [[F(1), F(0)]] + [[F(t), F(1)] for t in range(5)]
    R.check("six lines in (Z/5)^2", len(lines) == 6)
    good = 0
    isotropic = 0
    for a, b in lines:
        w = [a * F(tors[0][k]) + b * F(tors[1][k]) for k in range(10)]
        if pair10(w, w) == 0:
            isotropic += 1
        ext = unscale(lattice_basis(scale_int(list(EX_L4) + [w], 30)), 30)
        gx = gram_of(ext)
        if all(x.denominator == 1 for row in gx for x in row) and \
                det_exact([[int(x) for x in row] for row in gx]) == 1:
            good += 1
    R.check("all six lines are isotropic", isotropic == 6, f"count {isotropic}")
    R.check("each gives a unimodular (principally polarized) overlattice",
            good == 6, f"count {good}")

    d5 = [s for s in sigmas if s[5] == 5]
    R.check("|D_5| = 10", len(d5) == 10, f"order {len(d5)}")
    fixes_all = True
    for s in d5:
        r = rho10(s)
        for a, b in lines:
            w = [a * F(tors[0][k]) + b * F(tors[1][k]) for k in range(10)]
            img = [sum(F(r[i][j]) * F(w[j]) for j in range(10)) for i in range(10)]
            if not any(in_lattice([img[k] - lam * w[k] for k in range(10)], EX_L4)
                       for lam in (F(1), F(-1), F(2), F(-2))):
                fixes_all = False
    R.check("D_5 fixes every one of the six lines", fixes_all)
    R.say()

    # -------------------------------------------------------------------- H
    R.say("H. Reproducing C914's rank-eight divisors without the three-primary glue")
    Lb2 = build('exotic', use_three=False)
    eq4 = [[int(pair10(x, embed(V6, a)) * 6) for a in range(2)] for x in Lb2]
    L4b = [[sum(F(c[i]) * F(Lb2[i][k]) for i in range(10)) for k in range(10)]
           for c in left_kernel(eq4)]
    d = smith_divisors([[int(x) for x in row] for row in gram_of(L4b)])
    R.check("elementary divisors (3,3,3,3,3,3,15,15)",
            d == [3, 3, 3, 3, 3, 3, 15, 15], str(d))
    R.say()

    R.say("=" * 68)
    R.say(f"failures: {R.fail}")
    return R


if __name__ == "__main__":
    rep = main()
    text = rep.buf.getvalue()
    if len(sys.argv) > 2 and sys.argv[1] == "--check":
        with open(sys.argv[2]) as fh:
            want = fh.read()
        ok = want == text and rep.fail == 0
        print("check:", "OK" if ok else "MISMATCH")
        sys.exit(0 if ok else 1)
    sys.stdout.write(text)
    sys.exit(0 if rep.fail == 0 else 1)
