#!/usr/bin/env python3
"""C756, twenty-seventh pass: the coupled pair invariant of a coherent system.

Both halves of the crown are carried by a single PGL(2,q)-invariant of the pair of
conjugate point-pairs {z_i, z_i^q}, {z_j, z_j^q}:

    g_ij = (z_i - z_i^q)(z_j - z_j^q) / N(z_i - z_j)   in F_q^*.

Checks:
  (G1) g_ij lies in F_q, is symmetric, and equals the cross-ratio of the quadruple
       (z_i, z_i^q; z_j, z_j^q); it is invariant under z -> a z + b with a in F_q^*,
       b in F_q.
  (G2) With alpha_ij = N(z_i - z_j), beta_ij = N(z_i - z_j^q) one has the exact
       identity beta_ij = alpha_ij - 4 eps c_i c_j = alpha_ij (1 - g_ij), where
       z = a + s c.
  (G3) Condition (A) is chi_q(alpha_ij) = delta, and given (A), condition (B) is
       exactly chi_q(1 - g_ij) = -1.  Also chi_q(g_ij) = -delta eta_i eta_j with
       eta_i = chi_q(c_i), which is implied by (A) and is not extra information.
  (G4) Exact class counts N(u,v) = #{x : chi(x)=u, chi(1-x)=v} = (q-2-u-v+uv*delta)/4,
       so #{x : chi_q(1-x) = -1} = (q-1)/2 exactly.
  (G5) Pigeonhole: for each fixed i the (q+1)/2 values g_ij lie in a set of size
       (q-1)/2, so at least one collision g_ij = g_ik with j != k is forced.
       Reported explicitly on the q=5 frames.

Replay:  python3 2026-08-02-c756-coupled-pair-invariant.py
"""

import itertools
import json
import sys


def least_nonresidue(q):
    for e in range(2, q):
        if pow(e, (q - 1) // 2, q) == q - 1:
            return e
    raise ValueError("no nonresidue")


class Field:
    """F_{q^2} = F_q(s), s^2 = eps; elements are pairs (a, c) = a + c*s."""

    def __init__(self, q):
        self.q = q
        self.eps = least_nonresidue(q)
        self.delta = 1 if ((q + 1) // 2) % 2 == 0 else -1
        self.elements = [(a, c) for a in range(q) for c in range(q)]

    def mul(self, u, v):
        q, e = self.q, self.eps
        return ((u[0] * v[0] + e * u[1] * v[1]) % q, (u[0] * v[1] + u[1] * v[0]) % q)

    def add(self, u, v):
        q = self.q
        return ((u[0] + v[0]) % q, (u[1] + v[1]) % q)

    def sub(self, u, v):
        q = self.q
        return ((u[0] - v[0]) % q, (u[1] - v[1]) % q)

    def conj(self, u):
        return (u[0], (-u[1]) % self.q)

    def norm(self, u):
        return (u[0] * u[0] - self.eps * u[1] * u[1]) % self.q

    def inv(self, u):
        ninv = pow(self.norm(u), self.q - 2, self.q)
        c = self.conj(u)
        return ((c[0] * ninv) % self.q, (c[1] * ninv) % self.q)

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


def g_invariant(F, zi, zj):
    """(z_i - z_i^q)(z_j - z_j^q) / N(z_i - z_j), returned as an element of F_q."""
    num = F.mul(F.sub(zi, F.conj(zi)), F.sub(zj, F.conj(zj)))
    den = F.norm(F.sub(zi, zj))
    assert num[1] == 0 and den != 0
    return (num[0] * pow(den, F.q - 2, F.q)) % F.q


def cross_ratio(F, p, r, u, v):
    """((p-r)(u-v)) / ((p-u)(r-v)) in F_{q^2}: the cross-ratio of (p,r;u,v)."""
    return F.mul(F.mul(F.sub(p, r), F.sub(u, v)),
                 F.inv(F.mul(F.sub(p, u), F.sub(r, v))))


def coherent_systems(F):
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
    out = []
    for combo in itertools.combinations(irr, n):
        if all(b in ok.get(a, ()) for a, b in itertools.combinations(combo, 2)):
            out.append(combo)
    return out


def analyse(q):
    F = Field(q)
    delta, eps = F.delta, F.eps
    irr = [u for u in F.elements if not F.is_rational(u)]

    # (G1)-(G3) as algebraic identities on all irrational pairs; coherence not assumed.
    g1 = g2 = g3 = True
    for zi in irr:
        for zj in irr:
            if zi == zj or F.conj(zi) == zj:
                continue
            g = g_invariant(F, zi, zj)
            if g != g_invariant(F, zj, zi):
                g1 = False
            cr = cross_ratio(F, zi, F.conj(zi), zj, F.conj(zj))
            if cr != (g, 0):
                g1 = False
            alpha = F.norm(F.sub(zi, zj))
            beta = F.norm(F.sub(zi, F.conj(zj)))
            if beta != (alpha - 4 * eps * zi[1] * zj[1]) % q:
                g2 = False
            if beta != (alpha * (1 - g)) % q:
                g2 = False
            a_ok = F.chi(F.sub(zi, zj)) == delta
            b_ok = F.chi(F.sub(zi, F.conj(zj))) == -delta
            if a_ok and (b_ok != (F.chi_q(1 - g) == -1)):
                g3 = False
            if a_ok and F.chi_q(g) != -delta * F.chi_q(zi[1]) * F.chi_q(zj[1]):
                g3 = False
    # affine invariance
    for a in range(1, q):
        for b in range(q):
            zi, zj = irr[0], irr[3]
            if F.conj(zi) == zj:
                continue
            zi2 = F.add(F.scal(a, zi), (b, 0))
            zj2 = F.add(F.scal(a, zj), (b, 0))
            if g_invariant(F, zi, zj) != g_invariant(F, zi2, zj2):
                g1 = False

    # (G4) exact class counts
    g4 = True
    for u in (1, -1):
        for v in (1, -1):
            actual = sum(1 for x in range(q)
                         if F.chi_q(x) == u and F.chi_q(1 - x) == v)
            pred = (q - 2 - u - v + u * v * delta) // 4
            if actual != pred:
                g4 = False
    target = [x for x in range(q) if F.chi_q(1 - x) == -1]
    g4 &= (len(target) == (q - 1) // 2)
    g4 &= all(x != 0 for x in target)

    res = {
        "q": q, "delta": delta,
        "G1_symmetric_crossratio_affine_invariant": g1,
        "G2_beta_identity": g2,
        "G3_conditionB_is_chi_one_minus_g": g3,
        "G4_exact_class_counts": g4,
        "row_length": (q + 1) // 2,
        "target_set_size": (q - 1) // 2,
        "collision_forced": (q + 1) // 2 > (q - 1) // 2,
    }

    if q == 5:
        systems = coherent_systems(F)
        rows = []
        all_in_target = True
        for Z in systems:
            for i, zi in enumerate(Z):
                vals = [g_invariant(F, zi, zj) for j, zj in enumerate(Z) if j != i]
                if not all(F.chi_q(1 - v) == -1 for v in vals):
                    all_in_target = False
                rows.append((len(vals), len(set(vals))))
        res["coherent_systems"] = len(systems)
        res["all_g_values_in_target_set"] = all_in_target
        res["row_profiles_len_distinct"] = sorted(set(rows))
    return res


def main():
    out = []
    for q in [5, 7, 11, 13]:
        r = analyse(q)
        out.append(r)
        for k in ("G1_symmetric_crossratio_affine_invariant", "G2_beta_identity",
                  "G3_conditionB_is_chi_one_minus_g", "G4_exact_class_counts",
                  "collision_forced"):
            assert r[k], (q, k)
        line = ("q=%-3d delta=%+d  G1=%s G2=%s G3=%s G4=%s  row=%d into target=%d"
                % (r["q"], r["delta"], r["G1_symmetric_crossratio_affine_invariant"],
                   r["G2_beta_identity"], r["G3_conditionB_is_chi_one_minus_g"],
                   r["G4_exact_class_counts"], r["row_length"], r["target_set_size"]))
        if q == 5:
            assert r["all_g_values_in_target_set"], q
            line += ("  systems=%d rows(len,distinct)=%s"
                     % (r["coherent_systems"], r["row_profiles_len_distinct"]))
        print(line)
    with open("2026-08-02-c756-coupled-pair-invariant.json", "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print("all assertions passed")
    return 0


if __name__ == "__main__":
    sys.exit(main())
