#!/usr/bin/env python3
"""C756 intercept-subresultant probe: generic (no-covering) checks.

Certifies, without any covering condition, the root-side formula for the
first subresultant of H(U,T) = prod_i (U - r_i(T)), r_i = y_i - x_i T, and
dH/dU with respect to U:

    S_1(U,T) = c_n * sum_m (U - r_m) * prod_{i<j, m not in {i,j}} (r_i-r_j)^2

(the classical first-subdiscriminant / Sylvester double-sum formula), and
measures the generic T-degrees of the two coefficients of S_1 plus the
generic triviality of gcd(S_{1,1}, S_{1,0}) and gcd(S_{1,1}, D_P), where
D_P = prod_{i<j} (r_i - r_j).

* n = 3: fully symbolic over ZZ[x_i, y_i] via sympy's subresultant PRS.
* n = 5, 6, 7, 10: exact arithmetic at seeded random integer points in
  general position, reduced modulo the prime P0 = 2^61 - 1, using the
  subresultant PRS implementation shared with the covering script.
  Degrees can only drop and gcds only grow under specialization and
  reduction, so the measured degree (n-1)(n-2) (which is also the a priori
  determinant upper bound) and the measured trivial gcds certify the
  generic characteristic-zero values.

Deterministic: fixed seed 20260801.

Replay:
  uv run --with sympy notes/2026-08-01-c756-intercept-subresultant-generic.py \
      > notes/2026-08-01-c756-intercept-subresultant-generic.json
"""

import importlib.util
import json
import pathlib
import random
import sys

import sympy as sp

HERE = pathlib.Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location(
    "cover", HERE / "2026-08-01-c756-intercept-subresultant-cover.py")
cover = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cover)

P0 = (1 << 61) - 1  # prime

U, T = sp.symbols("U T")


def symbolic_case(n):
    xs = sp.symbols(f"x1:{n + 1}")
    ys = sp.symbols(f"y1:{n + 1}")
    r = [ys[i] - xs[i] * T for i in range(n)]
    f = sp.expand(sp.prod([U - ri for ri in r]))
    fp = sp.diff(f, U)
    prs = sp.subresultants(f, fp, U)
    S1 = None
    for m in prs:
        if sp.degree(m, U) == 1:
            S1 = sp.expand(m)
    assert S1 is not None
    F = 0
    for m in range(n):
        Am = sp.prod([(r[i] - r[j]) ** 2
                      for i in range(n) for j in range(i + 1, n)
                      if m not in (i, j)])
        F += (U - r[m]) * Am
    ratio = sp.cancel(S1 / sp.expand(F))
    assert not ratio.free_symbols, "S1/F not constant"
    S11 = sp.Poly(S1, U).coeff_monomial(U)
    return {"n": n, "mode": "symbolic", "formula_ratio": str(ratio),
            "deg_T_S11": int(sp.degree(sp.expand(S11), T)),
            "expected_deg_T_S11": (n - 1) * (n - 2)}


def random_case(n, rng):
    p = P0
    while True:
        xs = rng.sample(range(-10**6, 10**6), n)
        ys = [rng.randrange(-10**6, 10**6) for _ in range(n)]
        ok = True
        for a in range(n):
            for b in range(a + 1, n):
                for c in range(b + 1, n):
                    if (xs[b] - xs[a]) * (ys[c] - ys[a]) == \
                       (xs[c] - xs[a]) * (ys[b] - ys[a]):
                        ok = False
        if ok:
            break
    r = [cover.pnorm([ys[i], -xs[i]], p) for i in range(n)]
    f = [[1]]
    for ri in r:
        new = [[] for _ in range(len(f) + 1)]
        for k, c in enumerate(f):
            new[k + 1] = cover.padd(new[k + 1], c, p)
            new[k] = cover.psub(new[k], cover.pmul(c, ri, p), p)
        f = cover.unorm(new)
    fp = cover.unorm([cover.pscale(f[k], k, p) for k in range(1, len(f))])
    prs, degseq = cover.subresultant_prs(f, fp, p)
    S1 = None
    for m in prs:
        if cover.udeg(m) == 1:
            S1 = m
    assert S1 is not None
    S10, S11 = S1[0], S1[1]

    # formula comparison
    F1, F0 = [], []
    D = [1]
    from itertools import combinations
    for i, j in combinations(range(n), 2):
        D = cover.pmul(D, cover.psub(r[i], r[j], p), p)
    for m in range(n):
        Am = [1]
        for i, j in combinations(range(n), 2):
            if m in (i, j):
                continue
            d = cover.psub(r[i], r[j], p)
            Am = cover.pmul(Am, cover.pmul(d, d, p), p)
        F1 = cover.padd(F1, Am, p)
        F0 = cover.psub(F0, cover.pmul(r[m], Am, p), p)
    qq, rr = cover.pdivmod(S11, F1, p)
    ratio_const = (not rr) and cover.pdeg(qq) == 0
    assert ratio_const
    c = qq[0]
    assert S10 == cover.pscale(F0, c, p), "S10 != c*F0"

    g1 = cover.pgcd(S11, S10, p)
    g2 = cover.pgcd(S11, D, p)
    return {"n": n, "mode": f"random specialization mod 2^61-1",
            "points": list(zip(xs, ys)),
            "prs_degree_sequence": degseq,
            "formula_matches_up_to_constant": True,
            "deg_T_S11": cover.pdeg(S11),
            "deg_T_S10": cover.pdeg(S10),
            "expected_deg_T_S11": (n - 1) * (n - 2),
            "deg_gcd_S11_S10": cover.pdeg(g1),
            "deg_gcd_S11_D": cover.pdeg(g2)}


def main():
    out = {"script": "2026-08-01-c756-intercept-subresultant-generic.py",
           "seed": 20260801, "prime": "2^61-1", "cases": []}
    rng = random.Random(20260801)
    res = symbolic_case(3)
    out["cases"].append(res)
    print(f"# n=3 symbolic ratio={res['formula_ratio']} "
          f"degS11={res['deg_T_S11']}", file=sys.stderr)
    for n in (5, 6, 7, 10):
        res = random_case(n, rng)
        out["cases"].append(res)
        print(f"# n={n} random degS11={res['deg_T_S11']} "
              f"(expected {res['expected_deg_T_S11']}) "
              f"gcd(S11,S10)={res['deg_gcd_S11_S10']} "
              f"gcd(S11,D)={res['deg_gcd_S11_D']}", file=sys.stderr)
    json.dump(out, sys.stdout, indent=1, default=str)
    print()


if __name__ == "__main__":
    main()
