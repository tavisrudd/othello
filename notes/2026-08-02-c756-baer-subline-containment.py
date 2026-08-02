#!/usr/bin/env python3
"""C756, twenty-sixth pass: Baer-subline containment for coherent systems.

Verifies over prime fields q the structural facts behind the containment theorem.

  (1) Circle coboundary identity.  For distinct c, c' on the norm-one circle
      C = {z : N(z) = 1} of F_{q^2},
          chi(c - c') = delta * lam(c) * lam(c'),
      where lam = +1 on the index-two subgroup Q_0 of C and -1 on the coset Q_1,
      and delta = (-1)^((q+1)/2).  Equivalently C induces the complete bipartite
      graph K_{m,m}, m = (q+1)/2, in the cross-class Paley graph.
  (2) |Q_0| = |Q_1| = (q+1)/2, and the t-parametrization c(t) = (t-i)/(t+i) is a
      bijection P^1(F_q) -> C with c(t)^q = c(-t) and lam(c(t)) = chi_q(t^2-eps).
  (3) The AGL(1,q^2)-orbit of C has size exactly q^2(q-1), which is the number of
      Baer sublines of P^1(F_{q^2}) not through infinity.  Hence every such Baer
      subline is aC + b.
  (4) Consequence: condition (A) alone confines a coherent system inside a circle
      to a single lam-class, of size (q+1)/2 < (q+3)/2.  Reported as the exact
      maximum size of an (A)-only clique inside a circle.
  (5) Sharp local bound: the maximum clique of the full coherence graph
      (conditions (A) and (B)) inside a single circle, maximized over all circles.

Replay:  python3 2026-08-02-c756-baer-subline-containment.py
"""

import json
import sys

# Exhaustive-over-all-circles range for step (5); the proof itself is uniform.
PRIMES = [5, 7, 11, 13, 17, 19, 23]


def least_nonresidue(q):
    for e in range(2, q):
        if pow(e, (q - 1) // 2, q) == q - 1:
            return e
    raise ValueError("no nonresidue")


class Field:
    """F_{q^2} = F_q(s), s^2 = eps, elements as pairs (x, y) meaning x + y*s."""

    def __init__(self, q):
        self.q = q
        self.eps = least_nonresidue(q)
        self.delta = 1 if ((q + 1) // 2) % 2 == 0 else -1
        self.elements = [(x, y) for x in range(q) for y in range(q)]

    def mul(self, u, v):
        q, e = self.q, self.eps
        return ((u[0] * v[0] + e * u[1] * v[1]) % q, (u[0] * v[1] + u[1] * v[0]) % q)

    def sub(self, u, v):
        q = self.q
        return ((u[0] - v[0]) % q, (u[1] - v[1]) % q)

    def conj(self, u):
        return (u[0], (-u[1]) % self.q)

    def norm(self, u):
        return (u[0] * u[0] - self.eps * u[1] * u[1]) % self.q

    def inv(self, u):
        n = self.norm(u)
        ninv = pow(n, self.q - 2, self.q)
        c = self.conj(u)
        return ((c[0] * ninv) % self.q, (c[1] * ninv) % self.q)

    def chi_q(self, a):
        a %= self.q
        if a == 0:
            return 0
        return 1 if pow(a, (self.q - 1) // 2, self.q) == 1 else -1

    def chi(self, u):
        return self.chi_q(self.norm(u))

    def is_rational(self, u):
        return u[1] == 0


def bron_kerbosch_max(adj, vertices):
    """Maximum clique size on a small graph given as adjacency sets."""
    best = 0

    def expand(r, p, x):
        nonlocal best
        if not p and not x:
            best = max(best, len(r))
            return
        if len(r) + len(p) <= best:
            return
        pivot = max(p | x, key=lambda v: len(adj[v] & p))
        for v in list(p - adj[pivot]):
            expand(r | {v}, p & adj[v], x & adj[v])
            p = p - {v}
            x = x | {v}

    expand(set(), set(vertices), set())
    return best


def analyse(q):
    F = Field(q)
    delta = F.delta
    one = (1, 0)
    iota = (0, 1)

    circle = [u for u in F.elements if F.norm(u) == 1]
    assert len(circle) == q + 1

    # index-two subgroup Q_0 = squares of the cyclic group C
    squares = {F.mul(c, c) for c in circle}
    lam = {c: (1 if c in squares else -1) for c in circle}
    sizes = (sum(1 for c in circle if lam[c] == 1), sum(1 for c in circle if lam[c] == -1))
    assert sizes == ((q + 1) // 2, (q + 1) // 2), sizes

    # (2) t-parametrization
    param_ok = True
    seen = {}
    for t in list(range(q)) + ["inf"]:
        if t == "inf":
            c = one
            lam_pred = 1
        else:
            num = F.sub((t, 0), iota)
            den = ((t) % q, 1)
            c = F.mul(num, F.inv(den))
            lam_pred = F.chi_q(t * t - F.eps)
        param_ok &= F.norm(c) == 1
        param_ok &= lam[c] == lam_pred
        if t != "inf":
            param_ok &= F.conj(c) == F.mul(F.sub(((-t) % q, 0), iota), F.inv(((-t) % q, 1)))
        seen[t] = c
    param_ok &= len(set(seen.values())) == q + 1

    # (1) coboundary identity on the circle
    identity_ok = True
    for i, c in enumerate(circle):
        for d in circle[i + 1:]:
            if F.chi(F.sub(c, d)) != delta * lam[c] * lam[d]:
                identity_ok = False
    # chi(z - z^q) = delta for every irrational z
    conj_ok = all(
        F.chi(F.sub(u, F.conj(u))) == delta for u in F.elements if not F.is_rational(u)
    )

    # (3) AGL(1, q^2)-orbit of C
    orbit = set()
    for a in F.elements:
        if a == (0, 0):
            continue
        aC = [F.mul(a, c) for c in circle]
        for b in F.elements:
            orbit.add(frozenset(((x[0] + b[0]) % q, (x[1] + b[1]) % q) for x in aC))
    orbit_ok = len(orbit) == q * q * (q - 1)

    # (4) and (5): cliques inside a single circle
    max_A = 0
    max_AB = 0
    for B in orbit:
        pts = [u for u in B if not F.is_rational(u)]
        idx = {u: i for i, u in enumerate(pts)}
        adjA = {i: set() for i in range(len(pts))}
        adjAB = {i: set() for i in range(len(pts))}
        for i, u in enumerate(pts):
            for j in range(i + 1, len(pts)):
                v = pts[j]
                if F.conj(u) == v:
                    continue
                a_ok = F.chi(F.sub(u, v)) == delta
                b_ok = F.chi(F.sub(u, F.conj(v))) == -delta
                if a_ok:
                    adjA[i].add(j)
                    adjA[j].add(i)
                    if b_ok:
                        adjAB[i].add(j)
                        adjAB[j].add(i)
        max_A = max(max_A, bron_kerbosch_max(adjA, range(len(pts))))
        max_AB = max(max_AB, bron_kerbosch_max(adjAB, range(len(pts))))

    return {
        "q": q,
        "eps": F.eps,
        "delta": delta,
        "n_required": (q + 3) // 2,
        "half_circle": (q + 1) // 2,
        "coboundary_identity": identity_ok,
        "conjugate_class_delta": conj_ok,
        "parametrization": param_ok,
        "coset_sizes": list(sizes),
        "circle_orbit_size": len(orbit),
        "circle_orbit_expected": q * q * (q - 1),
        "circle_orbit_ok": orbit_ok,
        "max_clique_A_only_in_circle": max_A,
        "max_clique_AB_in_circle": max_AB,
    }


def main():
    out = []
    for q in PRIMES:
        r = analyse(q)
        out.append(r)
        assert r["coboundary_identity"], q
        assert r["conjugate_class_delta"], q
        assert r["parametrization"], q
        assert r["circle_orbit_ok"], q
        assert r["max_clique_A_only_in_circle"] <= r["half_circle"], q
        assert r["max_clique_A_only_in_circle"] < r["n_required"], q
        print(
            "q=%-3d delta=%+d  n=%2d  half-circle=%2d  maxclique(A)=%2d  maxclique(A&B)=%2d  "
            "identity=%s orbit=%d/%d"
            % (
                r["q"], r["delta"], r["n_required"], r["half_circle"],
                r["max_clique_A_only_in_circle"], r["max_clique_AB_in_circle"],
                "ok" if r["coboundary_identity"] else "FAIL",
                r["circle_orbit_size"], r["circle_orbit_expected"],
            )
        )
    with open("2026-08-02-c756-baer-subline-containment.json", "w") as fh:
        json.dump(out, fh, indent=1, sort_keys=True)
    print("all assertions passed; no coherent system fits in a circle for any tested q")
    return 0


if __name__ == "__main__":
    sys.exit(main())
