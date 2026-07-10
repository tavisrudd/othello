#!/usr/bin/env python3
"""C74/R2-1: exact product-collision formula for C73 candidate secants.

For a candidate line through frame point F and conic candidate w, normalize
F -> 0 and w -> infinity.  If U is the image of the other four frame points,
the q-1 off-conic centers on the line are tau_a(t)=a/t.  Exactly the distinct
pair products {u_i*u_j} are illegal centers, so nlegal=q-|U^(2)| (including w).

Reads only the existing feat geometry via c73_secant_algebra.  P/N labels are
not consulted.
"""
from collections import Counter
from itertools import combinations
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import DATA, PRIME_FILES, analyze, inv, parse

INF = "oo"


def mobius_zero_inf(t, F, w, q):
    """A projectivity sending F to 0 and w to infinity (prime fields)."""
    if F == INF:
        assert w != INF and t != w
        if t == INF:
            return 0
        return inv(t - w, q)
    if w == INF:
        assert t != F
        if t == INF:
            return INF
        return (t - F) % q
    assert F != w and t != w
    if t == INF:
        return 1
    return ((t - F) * inv(t - w, q)) % q


def line_product_data(rec, key):
    q = rec["q"]
    F, w = key
    frame = ["0", INF] + rec["tframe"]
    frame = [0 if x == "0" else x for x in frame]
    F0 = 0 if F == "0" else F
    U = [mobius_zero_inf(t, F0, w, q) for t in frame if t != F0]
    assert len(U) == 4 and INF not in U and 0 not in U and len(set(U)) == 4
    products = Counter((a * b) % q for a, b in combinations(U, 2))
    d = len(products)
    return U, products, d


def run(q):
    recs = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
    dhist = Counter()
    minima = Counter()
    checked = 0
    for cls, rec in sorted(recs.items()):
        ds = {}
        for key, datum in rec["cand"].items():
            U, products, d = line_product_data(rec, key)
            assert datum["nlegal"] == q - d, (q, cls, key, U, products)
            assert d >= 4
            if d == 4:
                # The two repeated products are equivalent to U={a,-a,b,-b}.
                assert all((-u) % q in U for u in U)
                assert sorted(products.values()) == [1, 1, 2, 2]
            ds[key] = d
            dhist[d] += 1
            checked += 1
        dm = min(ds.values())
        involution_supply = sum(3 if d == 4 else 1 if d == 5 else 0
                                for d in ds.values())
        assert involution_supply == 15, (q, cls, Counter(ds.values()))
        argmin = [key for key, d in ds.items() if d == dm]
        maxima = [key for key, datum in rec["cand"].items()
                  if datum["nlegal"] == max(x["nlegal"] for x in rec["cand"].values())]
        assert sorted(argmin, key=str) == sorted(maxima, key=str)
        minima[(dm, len(argmin))] += 1
        print(f"CLASS q={q} cls={cls} dmin={dm} ties={len(argmin)} "
              f"involution-supply={involution_supply} keys={sorted(argmin,key=str)}")
    print(f"DONE q={q} classes={len(recs)} candidates={checked} d-hist={dict(sorted(dhist.items()))} "
          f"min/tie-hist={dict(sorted(minima.items()))}")


if __name__ == "__main__":
    for q in map(int, sys.argv[1:] or [11, 13, 17, 19]):
        run(q)
