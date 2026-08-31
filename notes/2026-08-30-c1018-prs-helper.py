#!/usr/bin/env python3
"""C1018 independent verifier for PRS deep-hole / normal-rational-curve rank.

Deliberately independent of the Rust driver
(`ergodis-private/src/bin/c1018_prs_deephole.rs`) in three ways:

1.  the finite field is built from a *different* irreducible polynomial
    (highest-code rather than lowest-code monic irreducible), so the element
    labelling differs;
2.  the coset weight is computed from its *definition* -- minimum number of
    parity-check columns whose F_q-span contains the syndrome, decided by
    Gaussian rank -- rather than through the Hankel/apolarity criterion the
    Rust driver uses;
3.  no orbit machinery is used; sets are enumerated directly.

Subcommands
-----------
  census   q r          exhaustive PG(r-1,q) census (small parameters only)
  verify   q r file     re-check the orbit representatives of a driver JSON
"""

import itertools
import json
import sys


# --------------------------------------------------------------------------
# GF(p^h) built from the *last* monic irreducible in lexicographic code order
# --------------------------------------------------------------------------


def prime_power(q):
    p = 2
    while p * p <= q:
        if q % p == 0:
            break
        p += 1
    if p * p > q:
        return q, 1
    h, m = 0, q
    while m % p == 0:
        m //= p
        h += 1
    assert m == 1, f"{q} is not a prime power"
    return p, h


def poly_rem(a, b, p):
    a = list(a)
    db = len(b) - 1
    while len(a) > db:
        da = len(a) - 1
        c = a[da]
        if c:
            for i in range(db + 1):
                a[da - db + i] = (a[da - db + i] - c * b[i]) % p
        a.pop()
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return a


def irreducible(p, h):
    if h == 1:
        return [0, 1]
    found = None
    for code in range(p**h):
        f, c = [0] * h + [1], code
        for i in range(h):
            f[i] = c % p
            c //= p
        ok = True
        for m in range(1, h // 2 + 1):
            for gc in range(p**m):
                g, c = [0] * m + [1], gc
                for i in range(m):
                    g[i] = c % p
                    c //= p
                if poly_rem(f, g, p) == [0]:
                    ok = False
                    break
            if not ok:
                break
        if ok:
            found = f  # keep the LAST one: differs from the Rust driver
    assert found is not None
    return found


class GF:
    def __init__(self, q, poly=None):
        """`poly` overrides the defining polynomial.

        `census` leaves it None and picks its own (last-in-code-order) monic
        irreducible, so the field model is independent of the Rust driver.
        `verify` must pass the driver's polynomial: syndrome coordinates are
        element *labels*, and labels are only comparable inside one model.  The
        independence that matters there is the method -- definition-level span
        rank instead of the Hankel criterion -- not the labelling.
        """
        self.q = q
        self.p, self.h = prime_power(q)
        self.f = list(poly) if poly is not None else irreducible(self.p, self.h)
        p, h = self.p, self.h

        def digits(x):
            return [(x // p**i) % p for i in range(h)]

        def pack(v):
            return sum(v[i] % p * p**i for i in range(h))

        self.add = [[0] * q for _ in range(q)]
        self.mul = [[0] * q for _ in range(q)]
        for a in range(q):
            da = digits(a)
            for b in range(q):
                db = digits(b)
                self.add[a][b] = pack([(da[i] + db[i]) % p for i in range(h)])
                prod = [0] * (2 * h)
                for i in range(h):
                    if da[i]:
                        for j in range(h):
                            prod[i + j] = (prod[i + j] + da[i] * db[j]) % p
                while len(prod) > 1 and prod[-1] == 0:
                    prod.pop()
                rem = poly_rem(prod, self.f, p)
                self.mul[a][b] = pack([rem[i] if i < len(rem) else 0 for i in range(h)])
        self.neg = [next(b for b in range(q) if self.add[a][b] == 0) for a in range(q)]
        self.inv = [0] * q
        for a in range(1, q):
            self.inv[a] = next(b for b in range(1, q) if self.mul[a][b] == 1)

    def curve(self, d):
        """The q+1 parity-check columns: NRC of degree d in PG(d,q)."""
        pts = []
        for a in range(self.q):
            row, x = [], 1
            for _ in range(d + 1):
                row.append(x)
                x = self.mul[x][a]
            pts.append(tuple(row))
        pts.append(tuple([0] * d + [1]))
        return pts

    def rank(self, rows):
        rows = [list(r) for r in rows]
        cols = len(rows[0]) if rows else 0
        piv = 0
        for c in range(cols):
            sel = next((i for i in range(piv, len(rows)) if rows[i][c]), None)
            if sel is None:
                continue
            rows[piv], rows[sel] = rows[sel], rows[piv]
            iv = self.inv[rows[piv][c]]
            rows[piv] = [self.mul[x][iv] for x in rows[piv]]
            for i in range(len(rows)):
                if i != piv and rows[i][c]:
                    fac = rows[i][c]
                    rows[i] = [
                        self.add[rows[i][j]][self.neg[self.mul[fac][rows[piv][j]]]]
                        for j in range(cols)
                    ]
            piv += 1
            if piv == len(rows):
                break
        return piv


def coset_weight(gf, curve, s, dmax):
    """Definition-level weight: least |T| with s in span{curve[t] : t in T}."""
    for j in range(1, dmax + 2):
        for T in itertools.combinations(range(len(curve)), j):
            base = [curve[t] for t in T]
            if gf.rank(base) == gf.rank(base + [list(s)]):
                return j, T
    return dmax + 2, None


def projective_points(gf, d):
    q = gf.q
    for lead in range(d + 1):
        for tail in itertools.product(range(q), repeat=d - lead):
            yield tuple([0] * lead + [1] + list(tail))


def cmd_census(q, r):
    d = r - 1
    gf = GF(q)
    curve = gf.curve(d)
    hist = {}
    for s in projective_points(gf, d):
        w, _ = coset_weight(gf, curve, s, d)
        hist[w] = hist.get(w, 0) + 1
    rho = max(hist)
    print(
        json.dumps(
            {
                "method": "definition/rank",
                "q": q,
                "r": r,
                "d": d,
                "defining_poly": gf.f,
                "projective_points": sum(hist.values()),
                "covering_radius": rho,
                "deep_hole_projective_points": hist[rho],
                "weight_histogram": {str(k): v for k, v in sorted(hist.items())},
            }
        )
    )


def cmd_verify(q, r, path):
    d = r - 1
    data = json.load(open(path))
    assert data["q"] == q and data["r"] == r
    gf = GF(q, poly=data["defining_poly"])
    curve = gf.curve(d)
    rho = data["covering_radius"]
    persistent = q * (q + 1) ** 2 // 2
    total = 0
    bad = []
    for rec in data["orbits"]:
        s = tuple(rec["rep"])
        w, _ = coset_weight(gf, curve, s, d)
        agree = w == rec["w"]
        if not agree:
            bad.append((s, rec["w"], w))
        if rec["w"] == rho:
            total += rec["size"]
        # persistence test: consecutive three-row Hankel of rank <= 2
        cat = [[s[i + j] for j in range(d - 1)] for i in range(3)]
        rec["cat2_rank"] = gf.rank(cat)
    print(
        json.dumps(
            {
                "method": "definition/rank",
                "q": q,
                "r": r,
                "defining_poly": gf.f,
                "representatives_checked": len(data["orbits"]),
                "weight_disagreements": bad,
                "listed_deep_orbit_size_sum": total,
                "driver_deep_points": data["deep_hole_projective_points"],
                "persistent_locus_size": persistent,
                "deep_rep_cat2_ranks": sorted(
                    {rec["cat2_rank"] for rec in data["orbits"] if rec["w"] == rho}
                ),
            }
        )
    )


if __name__ == "__main__":
    if sys.argv[1] == "census":
        cmd_census(int(sys.argv[2]), int(sys.argv[3]))
    elif sys.argv[1] == "verify":
        cmd_verify(int(sys.argv[2]), int(sys.argv[3]), sys.argv[4])
    else:
        raise SystemExit(__doc__)
