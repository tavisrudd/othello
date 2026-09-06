#!/usr/bin/env python3
"""Exact-arithmetic scan for hyperplane-section exclusions of complete caps.

Setting.  A is a complete k-cap in PG(d,q), d >= 3.  Write

    theta_j = 1 + q + ... + q^j  (theta_j = 0 for j < 0),
    N = C(k,2),  m = floor(k/2),  K = k - 2,
    L = N (q-1) - theta_d + k               (total secant overlap loss; >= 0 iff the
                                             counting bound k(k-1)(q-1)/2 >= theta_d - k holds),
    Q(s) = N - theta_{d-1} + q C(s,2) - (k-2) s.

Facts used (proofs in notes/2026-09-06-astra-cap-hyperplane-memo.md, Part 2):

  (P1) every hyperplane H satisfies 0 <= Q(|A ∩ H|) <= L, so the admissible section sizes are
       S_L = { s : 0 <= Q(s) <= L }.
  (P2) for a secant l, the hyperplanes through l have sizes w_H = |A ∩ H| - 2 with
       #H = t = theta_{d-2},  sum w_H = R = K theta_{d-3},
       sum C(w_H,2) = C_0 + D T_l,  C_0 = C(K,2) theta_{d-4},  D = q^{d-3},
       where T_l counts coplanar four-subsets of A containing both points of l.
  (P4) L >= sum_l phi_m(T_l) with phi_m the filled envelope, and 0 <= T_l <= (q-1)(m-1).
  (P5) L >= 2 T_l + 2 T_l^2 / K for every secant.

Tests, each a sufficient condition for "no complete k-cap in PG(d,q)":

  A  (degree infeasibility): no nonnegative integer vector (b_z)_{z in Z_L}, Z_L = {s-2 : s in S_L,
     s >= 2}, has sum b_z = t and sum z b_z = R.
  B  (coverage budget): with beta the closed-form lower bound on every T_l from the bracketing
     values a < b of R/t in Z_L (memo eq. 13), N phi_m(beta) > L.
  C  (concentration): beta > U_L = floor((sqrt(K^2 + 2 K L) - K)/2).

Test A is decided exactly by a bounded dynamic programme over the gaps z - z_min.  Tests B and C
use only the closed-form beta, so they are weaker than the exact integer optimum in the memo's
Theorem 3; a surviving case here may still be excluded by that optimum.

Usage: python3 notes/scripts/c1076_cap_exclusion_scan.py [--out-json PATH] [--out-md PATH]
Deterministic; exact integers and fractions only.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from fractions import Fraction

SCAN = {
    # dimension: (max q, window of k above the counting bound)
    3: (128, 12),
    4: (64, 12),
    5: (16, 12),
    6: (9, 12),
}


def prime_powers(limit: int) -> list[int]:
    out = []
    for n in range(2, limit + 1):
        p = min(f for f in range(2, n + 1) if n % f == 0)
        v = n
        while v % p == 0:
            v //= p
        if v == 1:
            out.append(n)
    return out


def theta(j: int, q: int) -> int:
    return sum(q**i for i in range(j + 1)) if j >= 0 else 0


def comb2(n: int) -> int:
    return n * (n - 1) // 2


def phi(m: int, T: int) -> Fraction:
    if m < 2:
        return Fraction(0)
    u, v = divmod(T, m - 1)
    return Fraction(u * (m - 1), m) + Fraction(v, v + 1)


def isqrt_floor(n: int) -> int:
    return math.isqrt(n)


def counting_bound(d: int, q: int) -> int:
    k = 2
    while comb2(k) * (q - 1) - theta(d, q) + k < 0:
        k += 1
    return k


def degree_feasible(zs: list[int], t: int, R: int) -> bool:
    """Exists b_z >= 0 integers with sum b_z = t, sum z b_z = R over z in zs."""
    if not zs:
        return False
    zmin = min(zs)
    target = R - zmin * t
    if target < 0:
        return False
    gaps = sorted({z - zmin for z in zs if z != zmin})
    if not gaps:
        return target == 0
    INF = t + 1
    best = [INF] * (target + 1)
    best[0] = 0
    for r in range(1, target + 1):
        b = INF
        for g in gaps:
            if g <= r and best[r - g] + 1 < b:
                b = best[r - g] + 1
        best[r] = b
    return best[target] <= t


def analyse(d: int, q: int, k: int) -> dict:
    N = comb2(k)
    m = k // 2
    K = k - 2
    L = N * (q - 1) - theta(d, q) + k
    rec = {"d": d, "q": q, "k": k, "L": L}
    if L < 0:
        rec["excluded_by"] = "counting"
        return rec
    thd1 = theta(d - 1, q)

    def Q(s: int) -> int:
        return N - thd1 + q * comb2(s) - K * s

    S = [s for s in range(0, k + 1) if 0 <= Q(s) <= L]
    Z = [s - 2 for s in S if s >= 2]
    t = theta(d - 2, q)
    R = K * theta(d - 3, q)
    C0 = comb2(K) * theta(d - 4, q)
    D = q ** (d - 3)
    rec.update({"S_L": S, "t": t, "R": R, "C0": C0, "D": D})
    if not degree_feasible(Z, t, R):
        rec["excluded_by"] = "A"
        return rec
    # exact enumeration of the degree system when it has at most one free parameter
    exact = None
    if len(Z) <= 3:
        sols = []
        if len(Z) == 1:
            if Z[0] * t == R:
                sols.append((t,))
        elif len(Z) == 2:
            z0, z1 = Z
            num = R - z0 * t
            if num % (z1 - z0) == 0 and 0 <= num // (z1 - z0) <= t:
                b1 = num // (z1 - z0)
                sols.append((t - b1, b1))
        else:
            z0, z1, z2 = Z
            for b2 in range(t + 1):
                num = R - z0 * t - (z2 - z0) * b2
                if num < 0:
                    break
                if num % (z1 - z0) == 0:
                    b1 = num // (z1 - z0)
                    if b1 + b2 <= t:
                        sols.append((t - b1 - b2, b1, b2))
        Ps = [sum(b * comb2(z) for b, z in zip(sol, Z)) for sol in sols]
        Ps = [P for P in Ps if (P - C0) % D == 0]
        exact = {"solutions": len(sols), "congruent": len(Ps)}
        rec["exact"] = exact
        if not Ps:
            rec["excluded_by"] = "A2"
            return rec
        exact["P_min"] = min(Ps)
        exact["P_max"] = max(Ps)
    # closed-form beta from bracketing values of R/t in Z
    mean = Fraction(R, t)
    below = [z for z in Z if z <= mean]
    above = [z for z in Z if z >= mean]
    beta = 0
    # plane-pencil balancing bound
    tp = theta(d - 2, q)
    a_, b_ = divmod(K, tp)
    beta = max(beta, tp * comb2(a_) + a_ * b_)
    if below and above:
        a = max(below)
        b = min(above)
        if a == b:
            tau = Fraction(t * comb2(a) - C0, D)
        else:
            tau = Fraction((a + b - 1) * R - a * b * t - 2 * C0, 2 * D)
        beta = max(beta, math.ceil(tau))
    beta = max(beta, 0)
    upper = (q - 1) * (m - 1)
    if exact is not None:
        beta = max(beta, -((C0 - exact["P_min"]) // D))  # ceil((P_min - C0)/D)
        upper = min(upper, (exact["P_max"] - C0) // D)
    rec["beta"] = beta
    UL = (isqrt_floor(K * K + 2 * K * L) - K) // 2
    rec["U_L"] = UL
    upper = min(upper, UL)
    rec["upper"] = upper
    budget = N * phi(m, beta)
    rec["N_phi_beta"] = str(budget)
    if budget > L:
        rec["excluded_by"] = "B"
    elif beta > upper:
        rec["excluded_by"] = "C"
    else:
        rec["excluded_by"] = None
    return rec


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out-json", default="notes/2026-09-06-c1076-cap-exclusion-scan.json")
    ap.add_argument("--out-md", default=None)
    args = ap.parse_args()

    rows = []
    summary = []
    for d, (qmax, window) in SCAN.items():
        for q in prime_powers(qmax):
            k0 = counting_bound(d, q)
            recs = [analyse(d, q, k) for k in range(k0, k0 + window + 1)]
            rows.extend(recs)
            first_surviving = next((r["k"] for r in recs if r["excluded_by"] is None), None)
            excluded = [(r["k"], r["excluded_by"]) for r in recs if r["excluded_by"]]
            summary.append(
                {
                    "d": d,
                    "q": q,
                    "counting_bound": k0,
                    "first_surviving_k": first_surviving,
                    "excluded": excluded,
                    "gain": (first_surviving - k0) if first_surviving is not None else None,
                }
            )

    # the memo's three exclusions must reproduce
    memo = {(4, 7, 31): "A", (4, 8, 37): "A", (4, 16, 97): "A"}
    for (d, q, k), want in memo.items():
        got = analyse(d, q, k)["excluded_by"]
        assert got == want, (d, q, k, got)

    payload = {"scan": SCAN, "summary": summary, "rows": rows}
    text = json.dumps(payload, indent=1, sort_keys=True)
    with open(args.out_json, "w") as fh:
        fh.write(text)
    digest = hashlib.sha256(text.encode()).hexdigest()
    print(f"wrote {args.out_json} sha256={digest} rows={len(rows)}")
    gains = [s for s in summary if s["gain"]]
    print(f"cases with a gain over the counting bound: {len(gains)} of {len(summary)}")
    if args.out_md:
        lines = ["| d | q | counting bound | first surviving k | gain | excluded (k: test) |",
                 "|--:|--:|---------------:|------------------:|-----:|:-------------------|"]
        for s in summary:
            ex = ", ".join(f"{k}:{w}" for k, w in s["excluded"] if w != "counting")
            lines.append(
                f"| {s['d']} | {s['q']} | {s['counting_bound']} | {s['first_surviving_k']} | "
                f"{s['gain']} | {ex} |"
            )
        with open(args.out_md, "w") as fh:
            fh.write("\n".join(lines) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
