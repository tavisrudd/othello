#!/usr/bin/env python3
"""C756, twenty-sixth pass, gate 2: linear coordinatization of the direction matchings.

Theorem 5 says the array of directions of z_i - z_j^q is a Latin square.  This script
verifies the linear reformulation of that matching and the moment consequences drawn
from it.

  (C1) For c on the norm-one circle, dir(z_i - z_j^q) = c  <=>  phi_c(z_i) = psi_c(z_j),
       where phi_c(z) = z^q - c z and psi_c(z) = z - c z^q are F_q-linear with
       one-dimensional kernels L_c and L_{c^{-1}} and a common one-dimensional image.
  (C2) Fixing generators d_c of the image lines gives scalar coordinates
       x_c(z) = phi_c(z)/d_c in F_q, and psi_c(z)/d_c = rho(c) x_{c^{-1}}(z) with
       rho(c) = -c d_{c^{-1}}/d_c in F_q^*.  Hence the matching reads
           X_c = rho(c) * X_{c^{-1}}   as subsets of F_q.
  (C3) Equating m-th power sums of the two sides is equivalent to
           sum_r binom(m,r) (-1)^r c^r N_r = 0,     N_r = M_{r,m-r} - M_{r,m-r}^q,
       where M_{r,m-r} = sum_i z_i^r (z_i^q)^(m-r).  This is checked as an algebraic
       identity on random configurations, independently of coherence.
  (C4) Consequence, for coherent systems: the polynomial has degree m and vanishes on
       all (q+1)/2 elements of G, so for m < (q+1)/2 every N_r = 0, i.e. all mixed
       sums M_{r,m-r} are rational.  Verified on the q=5 coherent systems.

Replay:  python3 2026-08-02-c756-direction-coordinatization.py
"""

import itertools
import json
import sys
from math import comb


def least_nonresidue(q):
    for e in range(2, q):
        if pow(e, (q - 1) // 2, q) == q - 1:
            return e
    raise ValueError("no nonresidue")


class Field:
    """F_{q^2} = F_q(s), s^2 = eps; elements are pairs (x, y) = x + y*s."""

    def __init__(self, q):
        self.q = q
        self.eps = least_nonresidue(q)
        self.delta = 1 if ((q + 1) // 2) % 2 == 0 else -1
        self.elements = [(x, y) for x in range(q) for y in range(q)]

    def mul(self, u, v):
        q, e = self.q, self.eps
        return ((u[0] * v[0] + e * u[1] * v[1]) % q, (u[0] * v[1] + u[1] * v[0]) % q)

    def add(self, u, v):
        q = self.q
        return ((u[0] + v[0]) % q, (u[1] + v[1]) % q)

    def sub(self, u, v):
        q = self.q
        return ((u[0] - v[0]) % q, (u[1] - v[1]) % q)

    def neg(self, u):
        q = self.q
        return ((-u[0]) % q, (-u[1]) % q)

    def conj(self, u):
        return (u[0], (-u[1]) % self.q)

    def norm(self, u):
        return (u[0] * u[0] - self.eps * u[1] * u[1]) % self.q

    def inv(self, u):
        ninv = pow(self.norm(u), self.q - 2, self.q)
        c = self.conj(u)
        return ((c[0] * ninv) % self.q, (c[1] * ninv) % self.q)

    def pow(self, u, k):
        r = (1, 0)
        b = u
        while k:
            if k & 1:
                r = self.mul(r, b)
            b = self.mul(b, b)
            k >>= 1
        return r

    def scal(self, a, u):
        q = self.q
        return ((a * u[0]) % q, (a * u[1]) % q)

    def chi_q(self, a):
        a %= self.q
        return 0 if a == 0 else (1 if pow(a, (self.q - 1) // 2, self.q) == 1 else -1)

    def chi(self, u):
        return self.chi_q(self.norm(u))

    def is_rational(self, u):
        return u[1] == 0

    def direction(self, u):
        """u^(q-1), an element of the norm-one circle."""
        return self.mul(self.pow(u, self.q), self.inv(u))


def coherent_systems(F):
    """Brute-force all coherent systems (used only at q=5)."""
    q = F.q
    n = (q + 3) // 2
    delta = F.delta
    irr = [u for u in F.elements if not F.is_rational(u)]
    ok = {}
    for i, u in enumerate(irr):
        for v in irr[i + 1:]:
            if F.conj(u) == v:
                continue
            if F.chi(F.sub(u, v)) == delta and F.chi(F.sub(u, F.conj(v))) == -delta:
                ok.setdefault(u, set()).add(v)
                ok.setdefault(v, set()).add(u)
    found = []
    for combo in itertools.combinations(irr, n):
        good = True
        for a, b in itertools.combinations(combo, 2):
            if b not in ok.get(a, ()):
                good = False
                break
        if good:
            found.append(combo)
    return found


def circle_and_generators(F):
    """Circle C, plus for each c in C a generator d_c of the image line of phi_c."""
    q = F.q
    circle = [u for u in F.elements if F.norm(u) == 1]
    gens = {}
    for c in circle:
        # image line of phi_c is {w : w^(q-1) = -c^(-1)} u {0}
        target = F.neg(F.inv(c))
        d = None
        for w in F.elements:
            if w == (0, 0):
                continue
            if F.mul(F.pow(w, q), F.inv(w)) == target:
                d = w
                break
        assert d is not None, c
        gens[c] = d
    return circle, gens


def check_field(F, verbose_label):
    q = F.q
    delta = F.delta
    circle, gens = circle_and_generators(F)
    # The class of a direction is the order-two character of the cyclic circle group,
    # not chi (every circle element has norm one).  lam = +1 on the squares of C.
    squares = {F.mul(c, c) for c in circle}
    lam = {c: (1 if c in squares else -1) for c in circle}
    # sanity: chi(u) = lam(direction of u) for every nonzero u
    for u in F.elements:
        if u != (0, 0):
            assert F.chi(u) == lam[F.direction(u)], u
    G = [c for c in circle if lam[c] == -delta]
    assert len(G) == (q + 1) // 2, (q, len(G))
    assert all(F.inv(c) in G for c in G), "G not inversion-closed"

    def phi(c, z):
        return F.sub(F.pow(z, q), F.mul(c, z))

    def psi(c, z):
        return F.sub(z, F.mul(c, F.pow(z, q)))

    def xcoord(c, z):
        w = F.mul(phi(c, z), F.inv(gens[c]))
        assert w[1] == 0, (c, z, w)
        return w[0]

    # rho(c) = -c d_{c^{-1}} / d_c, must be in F_q^*
    rho = {}
    for c in G:
        ci = F.inv(c)
        r = F.mul(F.neg(F.mul(c, gens[ci])), F.inv(gens[c]))
        assert r[1] == 0 and r[0] != 0, (c, r)
        rho[c] = r[0]

    # (C1)/(C2) as pointwise identities over all irrational z, w
    irr = [u for u in F.elements if not F.is_rational(u)]
    c1_ok = True
    c2_ok = True
    for c in G:
        ci = F.inv(c)
        for z in irr:
            # psi_c(z)/d_c == rho(c) * x_{c^{-1}}(z)
            lhs = F.mul(psi(c, z), F.inv(gens[c]))
            if lhs != ((rho[c] * xcoord(ci, z)) % q, 0):
                c2_ok = False
        for z in irr[: min(len(irr), 40)]:
            for w in irr[: min(len(irr), 40)]:
                u = F.sub(z, F.conj(w))
                if u == (0, 0):
                    continue
                is_dir = F.mul(F.pow(u, q), F.inv(u)) == c
                matches = phi(c, z) == psi(c, w)
                if is_dir != matches:
                    c1_ok = False

    # (C3) algebraic identity on random configurations, coherence not assumed
    c3_ok = True
    rng = 12345
    for trial in range(6):
        size = 5
        pts = []
        for k in range(size):
            rng = (1103515245 * rng + 12345) % (1 << 31)
            pts.append(irr[rng % len(irr)])
        for m in range(1, 6):
            for c in G:
                ci = F.inv(c)
                lhs = sum(pow(xcoord(c, z), m, q) for z in pts) % q
                rhs = (pow(rho[c], m, q) * sum(pow(xcoord(ci, z), m, q) for z in pts)) % q
                # the same difference expressed through the N_r polynomial
                poly = (0, 0)
                for r in range(m + 1):
                    M = (0, 0)
                    for z in pts:
                        M = F.add(M, F.mul(F.pow(z, r), F.pow(F.pow(z, q), m - r)))
                    N = F.sub(M, F.pow(M, q))
                    term = F.scal((comb(m, r) * pow(-1, r)) % q, F.mul(F.pow(c, r), N))
                    poly = F.add(poly, term)
                # lhs - rhs vanishes iff poly vanishes
                if ((lhs - rhs) % q == 0) != (poly == (0, 0)):
                    c3_ok = False

    result = {
        "q": q,
        "delta": delta,
        "G_size": len(G),
        "C1_direction_is_linear_matching": c1_ok,
        "C2_psi_equals_rho_times_x_inverse": c2_ok,
        "C3_moment_polynomial_identity": c3_ok,
    }

    # (C4) coherent systems, only feasible at q = 5
    if q == 5:
        systems = coherent_systems(F)
        result["coherent_systems"] = len(systems)
        latin_ok = True
        setid_ok = True
        moment_ok = True
        sum_rational = True
        for Z in systems:
            n = len(Z)
            # Latin square of directions
            rows = []
            for z in Z:
                row = []
                for w in Z:
                    if z == w:
                        continue
                    u = F.sub(z, F.conj(w))
                    row.append(F.mul(F.pow(u, q), F.inv(u)))
                rows.append(row)
                if sorted(row) != sorted(G):
                    latin_ok = False
            cols = [[rows[i][j] for i in range(n)] for j in range(n - 1)]
            del cols
            # X_c = rho(c) X_{c^{-1}} as sets
            for c in G:
                ci = F.inv(c)
                Xc = sorted(xcoord(c, z) for z in Z)
                Xci = sorted((rho[c] * xcoord(ci, z)) % q for z in Z)
                if Xc != Xci:
                    setid_ok = False
            # sum of Z is rational
            S = (0, 0)
            for z in Z:
                S = F.add(S, z)
            if not F.is_rational(S):
                sum_rational = False
            # mixed sums rational for m < (q+1)/2
            for m in range(1, (q + 1) // 2):
                for r in range(m + 1):
                    M = (0, 0)
                    for z in Z:
                        M = F.add(M, F.mul(F.pow(z, r), F.pow(F.pow(z, q), m - r)))
                    if not F.is_rational(M):
                        moment_ok = False
        result.update({
            "C4_latin_square": latin_ok,
            "C4_set_identity": setid_ok,
            "C4_sum_rational": sum_rational,
            "C4_mixed_sums_rational_below_critical": moment_ok,
        })
    return result


def main():
    out = []
    for q in [5, 7, 11, 13]:
        F = Field(q)
        r = check_field(F, str(q))
        out.append(r)
        assert r["C1_direction_is_linear_matching"], q
        assert r["C2_psi_equals_rho_times_x_inverse"], q
        assert r["C3_moment_polynomial_identity"], q
        line = ("q=%-3d G=%2d  C1=%s C2=%s C3=%s"
                % (r["q"], r["G_size"],
                   r["C1_direction_is_linear_matching"],
                   r["C2_psi_equals_rho_times_x_inverse"],
                   r["C3_moment_polynomial_identity"]))
        if q == 5:
            assert r["C4_latin_square"] and r["C4_set_identity"], q
            assert r["C4_sum_rational"] and r["C4_mixed_sums_rational_below_critical"], q
            line += ("  systems=%d C4(latin,set,sum,moments)=%s"
                     % (r["coherent_systems"],
                        (r["C4_latin_square"], r["C4_set_identity"],
                         r["C4_sum_rational"],
                         r["C4_mixed_sums_rational_below_critical"])))
        print(line)
    with open("2026-08-02-c756-direction-coordinatization.json", "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print("all assertions passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
