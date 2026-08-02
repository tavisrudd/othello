#!/usr/bin/env python3
"""C756 split-fiber census -- independent cross-check (lane: clebsch).

Deliberately uses a different algorithm from the Rust census:

  Rust  : enumerate every monic R (Gray-coded coefficient sweep), evaluate over
          F_{q^2}, and look for a fibre of size nn.
  Python: enumerate every nn-element SUBSET Z of F_{q^2} (all of it -- rational
          elements and conjugate pairs included, nothing assumed), form
          P(X) = prod_{z in Z} (X - z), and keep Z when P has coefficients in
          F_q in degrees 1..nn-1 and gamma = -P(0) lies outside F_q.  Then
          R = P - P(0) is monic of degree nn with R(0) = 0 and R^{-1}(gamma)
          contains Z, i.e. (R, gamma) is a split-fibre pair, and every split
          pair arises exactly once this way.

Because the Python side never restricts the subsets, it independently confirms
the Rust assertion that the roots of a split fibre are automatically irrational
and pairwise non-conjugate.

Conventions match the Rust program exactly: eps = smallest nonsquare in F_q,
F_{q^2} = F_q(s) with s^2 = eps, element index a + b*q denotes a + b*s,
chi(u) = legendre(N(u), q) with N(a+bs) = a^2 - eps*b^2, chi(0) = 0,
t = (q+1)/2, nn = (q+3)/2.

Run:  python3 2026-08-02-c756-split-fiber-census.py [--json <rust-cert.json>]
Exits nonzero if any check fails or if the JSON comparison disagrees.
"""

import argparse
import json
import sys
from collections import Counter


def legendre(x, q):
    x %= q
    if x == 0:
        return 0
    return 1 if pow(x, (q - 1) // 2, q) == 1 else -1


class F2:
    """F_{q^2} = F_q(s), s^2 = eps; element a + b*s stored as a + b*q."""

    def __init__(self, q):
        self.q = q
        self.eps = next(c for c in range(2, q) if legendre(c, q) == -1)
        self.n2 = q * q
        q2, eps = self.n2, self.eps
        self.chi = [0] * q2
        self.conj = [0] * q2
        self.neg = [0] * q2
        for u in range(q2):
            a, b = u % q, u // q
            self.chi[u] = legendre((a * a - eps * b * b) % q, q)
            self.conj[u] = a + ((q - b) % q) * q
            self.neg[u] = (q - a) % q + ((q - b) % q) * q
        self.mul = [0] * (q2 * q2)
        self.add = [0] * (q2 * q2)
        for u in range(q2):
            a1, b1 = u % q, u // q
            base = u * q2
            for v in range(q2):
                a2, b2 = v % q, v // q
                self.mul[base + v] = (a1 * a2 + eps * b1 * b2) % q + ((a1 * b2 + a2 * b1) % q) * q
                self.add[base + v] = (a1 + a2) % q + ((b1 + b2) % q) * q

    def rational(self, u):
        return u < self.q

    def fmt(self, u):
        return "%d+%ds" % (u % self.q, u // self.q)


def enumerate_pairs(F, nn):
    """All split-fibre pairs, as a list of (root-index tuple, R-coeffs, gamma)."""
    q, n2 = F.q, F.n2
    mul, add, neg = F.mul, F.add, F.neg
    out = []
    # DFS over strictly increasing index tuples, carrying prod (X - z).
    def rec(start, depth, poly):
        if depth == nn:
            # poly[k] = coefficient of X^k, poly[nn] == 1
            for k in range(1, nn):
                if poly[k] >= q:  # not in F_q
                    return
            gamma = neg[poly[0]]
            if gamma < q:  # gamma rational -> not a split-fibre pair
                return
            out.append((tuple(cur), tuple(poly[k] for k in range(nn + 1)), gamma))
            return
        # need n2 - z >= nn - depth remaining choices
        for z in range(start, n2 - (nn - depth) + 1):
            nz = neg[z]
            # new = poly * (X - z)
            new = [0] * (len(poly) + 1)
            for k, c in enumerate(poly):
                new[k + 1] = add[new[k + 1] * n2 + c]
                new[k] = add[new[k] * n2 + mul[c * n2 + nz]]
            cur.append(z)
            rec(z + 1, depth + 1, new)
            cur.pop()

    cur = []
    rec(0, 0, [1])
    return out


def analyse(F, nn, roots, coeffs, gamma, sign_t):
    q = F.q
    chi, conj, neg, add, mul = F.chi, F.conj, F.neg, F.add, F.mul
    n2 = F.n2
    sub = lambda u, v: add[u * n2 + neg[v]]
    sign_t1 = -sign_t
    # structural assertions (not assumed by the enumeration)
    assert len(set(roots)) == nn
    all_irrational = all(not F.rational(z) for z in roots)
    no_conj_pair = all(conj[z] not in set(roots) for z in roots)
    # F1
    # R' = nn X^(nn-1) + sum_{k=1}^{nn-1} k c_k X^(k-1); c_k in F_q for k<nn
    def dr(z):
        acc = nn % q
        for k in range(nn - 1, 0, -1):
            acc = mul[acc * n2 + z]
            acc = add[acc * n2 + (k * coeffs[k]) % q]
        return acc

    f1 = all(chi[dr(z)] == sign_t for z in roots)
    f2 = True
    f3 = True
    coh = 0
    for i in range(nn):
        for j in range(nn):
            if i == j:
                continue
            d = sub(roots[i], roots[j])
            e = sub(roots[i], conj[roots[j]])
            c1 = chi[d] == sign_t
            c2 = chi[e] == sign_t1
            if c1 and c2:
                coh += 1
            else:
                f3 = False
            if i < j and chi[mul[d * n2 + e]] != -1:
                f2 = False
    # F4 crown check on the Cayley graph with connection set chi = (-1)^{t+1}
    verts = list(roots) + [conj[z] for z in roots]
    crown = True
    for i in range(2 * nn):
        for j in range(2 * nn):
            if i == j:
                continue
            want = ((i < nn) != (j < nn)) and (i % nn != j % nn)
            if (chi[sub(verts[i], verts[j])] == sign_t1) != want:
                crown = False
    return dict(f1=f1, f2=f2, f3=f3, coh=coh, crown=crown,
                irr=all_irrational, nocj=no_conj_pair)


def orbits(F, nn, rootsets):
    """Orbits under X -> aX+b, i.e. Z -> {(z-b)/a}."""
    q, n2 = F.q, F.n2
    mul, add, neg = F.mul, F.add, F.neg
    inv = [0] + [pow(a, q - 2, q) for a in range(1, q)]
    allz = set(rootsets)
    canon = set()
    closed = True
    sizes = Counter()
    for Z in rootsets:
        img = set()
        for a in range(1, q):
            ai = inv[a]
            for b in range(q):
                w = tuple(sorted(mul[ai * n2 + add[z * n2 + neg[b]]] for z in Z))
                if w not in allz:
                    closed = False
                img.add(w)
        best = min(img)
        if best not in canon:
            canon.add(best)
            sizes[len(img)] += 1
    return len(canon), closed, dict(sizes)


def run(q):
    F = F2(q)
    nn = (q + 3) // 2
    t = (q + 1) // 2
    sign_t = 1 if t % 2 == 0 else -1
    pairs = enumerate_pairs(F, nn)
    n1 = n2o = n12 = n3 = 0
    hist = Counter()
    sols = []
    rootsets = []
    bad = 0
    f4bad = 0
    for roots, coeffs, gamma in pairs:
        a = analyse(F, nn, roots, coeffs, gamma, sign_t)
        if not (a["irr"] and a["nocj"]):
            bad += 1
        if a["crown"] != a["f3"]:
            f4bad += 1
        if a["f2"]:
            n2o += 1
        if a["f1"]:
            n1 += 1
            if a["f2"]:
                n12 += 1
        if a["f3"]:
            n3 += 1
            sols.append((list(coeffs), F.fmt(gamma), [F.fmt(z) for z in sorted(roots)]))
        hist[a["coh"]] += 1
        rootsets.append(tuple(sorted(roots)))
    norb, closed, osz = orbits(F, nn, rootsets)
    f3sets = [tuple(sorted(r)) for r, c, g in pairs
              if analyse(F, nn, r, c, g, sign_t)["f3"]]
    norb3 = orbits(F, nn, f3sets)[0] if f3sets else 0
    return dict(q=q, eps=F.eps, nn=nn, t=t, sign_t=sign_t,
                raw_split_pairs=len(pairs), unordered_gamma_pairs=len(pairs) // 2,
                affine_orbits=norb, orbit_action_closed=closed,
                orbit_size_histogram={str(k): v for k, v in sorted(osz.items())},
                funnel={"split": len(pairs), "F1": n1, "F2_alone": n2o, "F1_F2": n12, "F3": n3},
                f3_affine_orbits=norb3,
                assertion_failures=bad, f4_equivalence_failures=f4bad,
                coherence_histogram={str(k): v for k, v in sorted(hist.items())},
                f3_solutions=sorted(sols))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--qs", default="5,7")
    ap.add_argument("--json", default=None, help="Rust certificate to compare against")
    args = ap.parse_args()
    res = [run(int(x)) for x in args.qs.split(",")]
    for r in res:
        print("q=%d nn=%d split=%d orbits=%d osz=%s F1=%d F1F2=%d F3=%d f3orb=%d "
              "f4bad=%d bad=%d" % (r["q"], r["nn"], r["raw_split_pairs"],
                                   r["affine_orbits"], r["orbit_size_histogram"],
                                   r["funnel"]["F1"], r["funnel"]["F1_F2"],
                                   r["funnel"]["F3"], r["f3_affine_orbits"],
                                   r["f4_equivalence_failures"],
                                   r["assertion_failures"]))
    ok = True
    if args.json:
        cert = json.load(open(args.json))
        by_q = {c["q"]: c for c in cert["exact_census"]}
        keys = ["eps", "nn", "t", "sign_t", "raw_split_pairs", "unordered_gamma_pairs",
                "affine_orbits", "orbit_action_closed", "orbit_size_histogram",
                "funnel", "f3_affine_orbits", "assertion_failures",
                "f4_equivalence_failures", "coherence_histogram"]
        for r in res:
            c = by_q.get(r["q"])
            if c is None:
                print("MISSING q=%d in certificate" % r["q"])
                ok = False
                continue
            for k in keys:
                if r[k] != c[k]:
                    print("MISMATCH q=%d %s: python=%r rust=%r" % (r["q"], k, r[k], c[k]))
                    ok = False
            pz = sorted(tuple(sorted(s[2])) for s in r["f3_solutions"])
            rz = sorted(tuple(sorted(s["Z"])) for s in c["f3_solutions"])
            if pz != rz:
                print("MISMATCH q=%d F3 root sets" % r["q"])
                ok = False
        print("CROSS-CHECK: " + ("AGREE" if ok else "DISAGREE"))
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
