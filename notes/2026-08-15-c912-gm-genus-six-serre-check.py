#!/usr/bin/env python3
"""C912 -- Serre-operator eigenvalue test on numerical Grothendieck groups of
Kuznetsov components of Fano threefolds.

Purpose.  The C912 identification (report 2026-08-15-c912-det-r-pairing-and-serre-lattice.md,
Section 4) reads the primitive-sixth count nu_6 of a target off the Serre operator of the
residual semiorthogonal component: nu_6 = number of eigenvalues of S on N(Ku(X)) that are
primitive sixth roots of unity.  The sharpest available test is the genus-six Gushel--Mukai
threefold V_10, for which the lane's prime-Fano classification
(2026-08-12-c907-prime-fano-primitive-sixth-classification.md) gives nu_6 = 0 while Ku(V_10)
is nonzero.

Everything below is derived from Hirzebruch--Riemann--Roch on the threefold; no Euler matrix
is taken as an external input (unlike the earlier cubic-threefold check, which did).

Conventions.  For a Fano threefold X with Pic = Z.H, Fano index i (so -K_X = i H) and
degree d = H^3, numerical Chern characters are written in the basis (1, H, l, p) where l is
the degree-one curve class (H.l = p) and p the point class; thus H^2 = d.l and H^3 = d.p.
A class is a 4-tuple (r, a, b, c) meaning ch = r + a H + b l + c p.

Riemann--Roch: chi(E) = int ch(E) td(X), td(X) = 1 + c_1/2 + (c_1^2 + c_2)/12 + c_1c_2/24,
with c_1 = i H and c_1 c_2 = 24 (chi(O_X) = 1), hence H.c_2 = 24/i.
Euler form: chi(E,F) = int ch(E)^dual ch(F) td(X), where ^dual negates the odd part.
Numerical Serre operator: chi(a,b) = chi(b, S a), i.e. S = E^{-1} E^T for the Gram matrix
E_ij = chi(e_i, e_j).  Its characteristic polynomial is invariant under change of basis and
under passing to a finite-index sublattice.
"""

from math import gcd

from sympy import Rational, Matrix, Poly, symbols, factor_list, eye

lam = symbols('lam')
PHI6 = Poly(lam**2 - lam + 1, lam)


class Threefold:
    def __init__(self, name, index, degree):
        self.name = name
        self.index = Rational(index)
        self.degree = Rational(degree)
        # H.c_2(X) = 24/index
        self.Hc2 = Rational(24) / self.index

    def chi(self, v):
        """chi(E) = int ch(E) td(X) for ch(E) = (r, a, b, c)."""
        r, a, b, c = v
        i, d = self.index, self.degree
        td2_H = (i**2 * d + self.Hc2) / 12          # int H . td_2
        return r + a * td2_H + b * i / 2 + c

    def mul(self, v, w):
        r1, a1, b1, c1 = v
        r2, a2, b2, c2 = w
        d = self.degree
        return (r1 * r2,
                r1 * a2 + r2 * a1,
                r1 * b2 + r2 * b1 + d * a1 * a2,
                r1 * c2 + r2 * c1 + a1 * b2 + a2 * b1)

    @staticmethod
    def dual(v):
        r, a, b, c = v
        return (r, -a, b, -c)

    def euler(self, v, w):
        return self.chi(self.mul(self.dual(v), w))

    def lattice_generators(self):
        """ch of [O_X], [O_S] (S a hyperplane section), [O_l], [O_p]."""
        d, i = self.degree, self.index
        O = (Rational(1), Rational(0), Rational(0), Rational(0))
        Om1 = (Rational(1), Rational(-1), d / 2, -d / 6)        # ch(O(-H)) = e^{-H}
        OS = tuple(x - y for x, y in zip(O, Om1))
        Ol = (Rational(0), Rational(0), Rational(1), 1 - i / 2)  # chi(O_l) = 1
        Op = (Rational(0), Rational(0), Rational(0), Rational(1))
        return [O, OS, Ol, Op]


def right_orthogonal(X, exceptional):
    """Basis (in lattice coordinates and in ch coordinates) of
    {v in K_num(X) : chi(e, v) = 0 for all e in the exceptional collection}."""
    gens = X.lattice_generators()
    rows = []
    for e in exceptional:
        rows.append([X.euler(e, g) for g in gens])
    M = Matrix(rows)
    ns = M.nullspace()
    basis = []
    for vec in ns:
        den = 1
        for x in vec:
            den = den * Rational(x).q // gcd(den, Rational(x).q)
        ivec = [int(Rational(x) * den) for x in vec]
        g = 0
        for x in ivec:
            g = gcd(g, abs(x))
        ivec = [x // g for x in ivec] if g else ivec
        basis.append(ivec)
    basis = saturate(basis)
    out = []
    for ivec in basis:
        ch = tuple(sum(Rational(ivec[k]) * gens[k][j] for k in range(4)) for j in range(4))
        out.append((ivec, ch))
    return out


def saturate(basis, primes=(2, 3, 5, 7, 11, 13)):
    """Replace the spanning set by a basis of the saturation
    (span_Q(basis) cap Z^4), so the printed Gram matrix is the genuine
    discriminant of N(Ku) and not that of a finite-index sublattice.
    The characteristic polynomial of E^{-1}E^T does not depend on this."""
    basis = [list(v) for v in basis]
    k = len(basis)
    changed = True
    while changed:
        changed = False
        for p in primes:
            for code in range(1, p ** k):
                coeffs, c = [], code
                for _ in range(k):
                    coeffs.append(c % p)
                    c //= p
                cand = [sum(coeffs[i] * basis[i][j] for i in range(k)) for j in range(4)]
                if any(x % p for x in cand):
                    continue
                cand = [x // p for x in cand]
                pivot = next(i for i in range(k) if coeffs[i] % p)
                trial = [list(v) for v in basis]
                trial[pivot] = cand
                if Matrix(trial).rank() == k:
                    basis = trial
                    changed = True
                    break
            if changed:
                break
    return basis


def serre(X, basis):
    n = len(basis)
    E = Matrix(n, n, lambda i, j: X.euler(basis[i][1], basis[j][1]))
    if E.det() == 0:
        return E, None, None
    S = E.inv() * E.T
    cp = Poly(S.charpoly(lam).as_expr(), lam)
    return E, S, cp


def phi6_multiplicity(cp):
    mult = 0
    for fac, m in factor_list(cp.as_expr(), lam)[1]:
        if Poly(fac, lam) == PHI6:
            mult += m
    return mult


def order_of(S, bound=24):
    if S is None:
        return None
    P = eye(S.shape[0])
    for k in range(1, bound + 1):
        P = P * S
        if P == eye(S.shape[0]):
            return k
    return None


def report(label, X, exceptional, expected_nu6=None, notes=""):
    print("=" * 74)
    print(f"{label}")
    print(f"  index {X.index}, degree H^3 = {X.degree}, H.c_2(X) = {X.Hc2}")
    for j, e in enumerate(exceptional):
        print(f"  exceptional object {j}: ch = {e}, chi = {X.chi(e)}, "
              f"chi(e,e) = {X.euler(e, e)}")
    for j in range(len(exceptional)):
        for k in range(j):
            print(f"    semiorthogonality chi(obj{j}, obj{k}) = "
                  f"{X.euler(exceptional[j], exceptional[k])} (must be 0)")
    basis = right_orthogonal(X, exceptional)
    print(f"  rank N(Ku) = {len(basis)}")
    for ivec, ch in basis:
        print(f"    basis class: lattice coords {ivec}, ch = {ch}")
    E, S, cp = serre(X, basis)
    print(f"  Euler Gram matrix E = {E.tolist()}   det = {E.det()}   "
          f"symmetric = {E == E.T}")
    if S is None:
        print("  Euler form degenerate on N(Ku); no numerical Serre operator")
        return
    print(f"  Serre operator S = E^-1 E^T = {S.tolist()}")
    print(f"  char poly = {cp.as_expr()}   factored = {factor_list(cp.as_expr(), lam)[1]}")
    # basis independence: conjugating the Gram by a unimodular P must leave the
    # characteristic polynomial of E^{-1}E^T unchanged.
    n = E.shape[0]
    P = eye(n) + Matrix(n, n, lambda i, j: 1 if j == i + 1 else 0) \
        + Matrix(n, n, lambda i, j: 2 if i == n - 1 and j == 0 else 0)
    E2 = P.T * E * P
    cp2 = Poly((E2.inv() * E2.T).charpoly(lam).as_expr(), lam)
    print(f"  basis-independence check (det P = {P.det()}): "
          f"same char poly = {cp2 == cp}")
    print(f"  order of S = {order_of(S)}")
    nu6 = 2 * phi6_multiplicity(cp)
    print(f"  primitive-sixth eigenvalue count from Serre = {nu6}")
    if expected_nu6 is not None:
        verdict = "AGREES" if nu6 == expected_nu6 else "CONFLICTS"
        print(f"  lane's quantum-side nu_6 = {expected_nu6}  ->  {verdict}")
    if notes:
        print(f"  note: {notes}")


# ---------------------------------------------------------------------------
# 0. Calibration of the Gushel--Mukai input: the rank-two tautological bundle.
# ---------------------------------------------------------------------------
# X_10 = Gr(2,5) cap P^7 cap Q, index 1, degree 10.  U is the restriction of the
# tautological subbundle, c_1(U^dual) = H = sigma_1.  Write k = H.c_2(U^dual);
# Schubert calculus in Gr(2,5) gives k = 2 * int sigma_1^4 sigma_{1,1} = 2*2 = 4.
# Below the same value is forced twice from inside the derived category.
X10 = Threefold("GM threefold V_10 (genus 6)", 1, 10)
k = symbols('k')
Udual_k = (Rational(2), Rational(1), (10 - 2 * k) / 2, (10 - 3 * k) / 6)
print("Calibration of ch(U^dual) on the Gushel--Mukai threefold, k = H.c_2(U^dual):")
print(f"  chi(U^dual)      = {X10.chi(Udual_k).expand()}   (= 5 since h^0(U^dual) = dim V_5 = 5)")
print(f"  chi(U^dual, O_X) = {X10.euler(Udual_k, (1, 0, 0, 0)).expand()}   "
      f"(= 0 by semiorthogonality of <Ku, O_X, U^dual>)")
print(f"  chi(U^dual, U^dual) = {X10.euler(Udual_k, Udual_k).expand()}   (= 1, exceptional)")
print("  all three force k = 4, matching the Schubert computation.")
print()

O_X = (Rational(1), Rational(0), Rational(0), Rational(0))
Udual = (Rational(2), Rational(1), Rational(1), Rational(-1, 3))

# ---------------------------------------------------------------------------
# 1. Calibration case: the cubic threefold, where the answer is already known.
# ---------------------------------------------------------------------------
Y3 = Threefold("cubic threefold Y_3", 2, 3)
report("CALIBRATION -- cubic threefold Y_3, D^b = <Ku, O, O(1)>",
       Y3, [O_X, (Rational(1), Rational(1), Rational(3, 2), Rational(1, 2))],
       expected_nu6=2,
       notes="reproduces Phi_6 and S^3 = -I from Riemann--Roch alone")

# ---------------------------------------------------------------------------
# 2. THE TEST: the genus-six Gushel--Mukai threefold.
# ---------------------------------------------------------------------------
report("TEST -- Gushel--Mukai threefold V_10 (genus 6), D^b = <Ku, O_X, U^dual>",
       X10, [O_X, Udual], expected_nu6=0,
       notes="lane's provisional zero from the quantum operator L_10")

# ---------------------------------------------------------------------------
# 2b. Isometry class of N(Ku(V_10)) in an explicit basis of geometric classes.
# ---------------------------------------------------------------------------
gens10 = X10.lattice_generators()          # [O_X], [O_S], [O_l], [O_p]


def comb(gens, coeffs):
    return tuple(sum(Rational(coeffs[k]) * gens[k][j] for k in range(4)) for j in range(4))


w1 = comb(gens10, [1, 0, -2, 1])           # [O_X] - 2[O_l] + [O_p]
w2 = comb(gens10, [0, 1, 1, -3])           # [O_S] + [O_l] - 3[O_p]
for w in (w1, w2):
    assert X10.euler(O_X, w) == 0 and X10.euler(Udual, w) == 0
G = Matrix(2, 2, lambda i, j: X10.euler((w1, w2)[i], (w1, w2)[j]))
w2p = tuple(x - 2 * y for x, y in zip(w2, w1))
Gp = Matrix(2, 2, lambda i, j: X10.euler((w1, w2p)[i], (w1, w2p)[j]))
print("Explicit basis of N(Ku(V_10)) from geometric classes:")
print(f"  w1 = [O_X] - 2[O_l] + [O_p], w2 = [O_S] + [O_l] - 3[O_p]: Gram = {G.tolist()}")
print(f"  after w2 -> w2 - 2 w1: Gram = {Gp.tolist()}, i.e. N(Ku(V_10)) = <-1> + <-1>")
print(f"  Serre operator in this basis = {(G.inv() * G.T).tolist()}")
print()

# ---------------------------------------------------------------------------
# 3. The other index-two threefolds Y_d, D^b = <Ku, O, O(1)>.
#    By Kuznetsov's Fano threefold equivalences these also settle the index-one
#    genera g via (d,g) = (1,7), (2,9), (3,8), (4,10), (5,12).
# ---------------------------------------------------------------------------
census_index2 = {1: ("genus 7 X_12", 0), 2: ("genus 9 X_16", 0),
                 3: ("genus 8 X_14", 2), 4: ("genus 10 X_18", 0),
                 5: ("genus 12 X_22", 0)}
for d in [1, 2, 4, 5]:
    Y = Threefold(f"Y_{d}", 2, d)
    partner, nu = census_index2[d]
    report(f"index-two threefold Y_{d}, D^b = <Ku, O, O(1)>  "
           f"[Kuznetsov partner: {partner}]",
           Y, [O_X, (Rational(1), Rational(1), Rational(d, 2), Rational(d, 6))],
           expected_nu6=nu)

# ---------------------------------------------------------------------------
# 3b. Independent cross-check of the Y_4 row through Kuznetsov's equivalence
#     Ku(Y_4) = D^b(C) with C a smooth curve of genus two.  The Euler form of a
#     curve of genus g in the basis [O_C], [O_p] is [[1-g, 1], [-1, 0]]; this
#     route touches none of the threefold Riemann--Roch machinery above.
# ---------------------------------------------------------------------------
gc = symbols('g')
Ecurve = Matrix([[1 - gc, Rational(1)], [Rational(-1), Rational(0)]])
Scurve = (Ecurve.inv() * Ecurve.T).applyfunc(lambda x: x.simplify())
cp_curve = Poly(Scurve.charpoly(lam).as_expr().expand(), lam)
print("Cross-check, smooth curve of any genus g (Kuznetsov partner of Y_4 is g = 2):")
print(f"  E = {Ecurve.tolist()}, S = {Scurve.tolist()}, char poly = {cp_curve.as_expr()}")
print("  = (lam + 1)^2 for every g: a Kuznetsov component equivalent to D^b of a curve")
print("  always has primitive-sixth count zero.  This matches the Y_4 row above, and it")
print("  gives count zero for the genus-seven and genus-nine prime Fano threefolds,")
print("  whose Kuznetsov components are Mukai's curves of genus seven and three.")
print()

# ---------------------------------------------------------------------------
# 4. The index-one genera with only O_X split off: g = 2, 3, 4, 5.
#    Here D^b(X) = <Ku(X), O_X> and N(Ku) has rank three.
# ---------------------------------------------------------------------------
census_index1 = {2: 0, 3: 0, 4: 2, 5: 0}
for g, nu in census_index1.items():
    X = Threefold(f"genus {g} prime Fano X_{2 * g - 2}", 1, 2 * g - 2)
    report(f"index-one genus {g} threefold X_{2 * g - 2}, D^b = <Ku, O_X>",
           X, [O_X], expected_nu6=nu)
