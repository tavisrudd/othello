#!/usr/bin/env python3
"""Exact-arithmetic replay of the hyperplane-section exclusions for complete caps.

Setting.  A is a complete k-cap in PG(d,q), d >= 3.  Write

    theta_j = 1 + q + ... + q^j  (theta_j = 0 for j < 0),
    N = C(k,2),  m = floor(k/2),  K = k - 2,
    Lambda_0 = N (q-1) - theta_d + k          (overlap loss of a complete cap),
    Q(s) = N - theta_{d-1} + q C(s,2) - K s.

Facts replayed (proved in the manuscript):

  (H) every hyperplane section size s satisfies 0 <= Q(s) <= Lambda_0, so the admissible sizes are
      S = { s : 0 <= Q(s) <= Lambda_0 }.
  (G) the hyperplane character equations: with b_s hyperplanes of section size s,
      sum b_s = theta_d,  sum s b_s = k theta_{d-1},  sum C(s,2) b_s = N theta_{d-2}.
  (M) for a secant l, the hyperplanes through l have w = s - 2 with
      #hyperplanes = t = theta_{d-2},  sum w = R = K theta_{d-3},
      sum C(w,2) = C_0 + D T_l,  C_0 = C(K,2) theta_{d-4},  D = q^{d-3},
      where T_l counts the coplanar four-subsets of A containing both points of l.
  (E) Lambda_0 >= sum_l phi_m(T_l), phi_m the secant-local envelope, and 0 <= T_l <= (q-1)(m-1).
  (F) Lambda_0 >= 2 T_l + 2 T_l^2 / K for every secant.

Tests, each a sufficient condition for "no complete k-cap in PG(d,q)":

  G  (global character infeasibility, applied when |S| <= 3): the three equations (G) restricted
     to S have no nonnegative integer solution.
  A  (secant degree infeasibility): no nonnegative integer vector (b_w), w in S - 2, has
     sum b_w = t and sum w b_w = R.
  A2 (secant congruence): every solution of the secant system violates sum b_w C(w,2) = C_0 (mod D)
     (checked exactly when |S| <= 3).
  B  (coverage budget): with beta the bracket lower bound on every T_l, N phi_m(beta) > Lambda_0.
  C  (concentration): beta exceeds the ceiling from (F) and the trivial ceiling (q-1)(m-1).

The one-sided variants replace S by S_+ = { s : Q(s) >= 0 } and report the resulting bracket
bound and budget; they use only the lower half of (H).

Usage:
  python3 verification/check_secant_hyperplane_defects.py check      # replay and compare
  python3 verification/check_secant_hyperplane_defects.py --update   # rewrite the certificate
Deterministic; exact integers and fractions only; standard library only.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import sys
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE / "secant-hyperplane-checks.json"
CERT_SHA = HERE / "secant-hyperplane-checks.sha256"

SCAN = {
    # dimension: (largest q, window of k above the counting bound)
    3: (128, 12),
    4: (64, 12),
    5: (16, 12),
    6: (9, 12),
}

NAMED = [(4, 7, 31), (4, 8, 37), (4, 16, 97), (6, 8, 293), (6, 9, 387)]


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
    return n * (n - 1) // 2 if n >= 2 else 0


def phi(m: int, T: int) -> Fraction:
    if m < 2:
        return Fraction(0)
    u, v = divmod(T, m - 1)
    return Fraction(u * (m - 1), m) + Fraction(v, v + 1)


def counting_bound(d: int, q: int) -> int:
    k = 2
    while comb2(k) * (q - 1) - theta(d, q) + k < 0:
        k += 1
    return k


def degree_feasible(zs: list[int], t: int, R: int) -> bool:
    """Exists integer b_z >= 0 with sum b_z = t and sum z b_z = R, z ranging over zs."""
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


def small_solutions(zs: list[int], t: int, R: int) -> list[tuple[int, ...]]:
    """All nonnegative integer solutions of sum b = t, sum z b = R for at most three values."""
    sols: list[tuple[int, ...]] = []
    if len(zs) == 1:
        if zs[0] * t == R:
            sols.append((t,))
    elif len(zs) == 2:
        z0, z1 = zs
        num = R - z0 * t
        if num % (z1 - z0) == 0 and 0 <= num // (z1 - z0) <= t:
            b1 = num // (z1 - z0)
            sols.append((t - b1, b1))
    elif len(zs) == 3:
        z0, z1, z2 = zs
        for b2 in range(t + 1):
            num = R - z0 * t - (z2 - z0) * b2
            if num < 0:
                break
            if num % (z1 - z0) == 0:
                b1 = num // (z1 - z0)
                if b1 + b2 <= t:
                    sols.append((t - b1 - b2, b1, b2))
    return sols


def global_character_feasible(S: list[int], d: int, q: int, k: int) -> dict | None:
    """Test G: exact when |S| <= 3; returns None when not applied."""
    if not 1 <= len(S) <= 3:
        return None
    N = comb2(k)
    e0, e1, e2 = theta(d, q), k * theta(d - 1, q), N * theta(d - 2, q)
    sols = small_solutions(S, e0, e1)
    good = [sol for sol in sols if sum(b * comb2(s) for b, s in zip(sol, S)) == e2]
    return {
        "sizes": S,
        "equations": [e0, e1, e2],
        "two_moment_solutions": len(sols),
        "three_moment_solutions": len(good),
        "feasible": bool(good),
        "solution": list(good[0]) if good else None,
    }


def bracket_bound(Z: list[int], t: int, R: int, C0: int, D: int) -> dict:
    mean = Fraction(R, t)
    below = [z for z in Z if z <= mean]
    above = [z for z in Z if z >= mean]
    if not (below and above):
        return {"a": None, "b": None, "tau0": None, "beta": 0}
    a, b = max(below), min(above)
    if a == b:
        tau = Fraction(t * comb2(a) - C0, D)
    else:
        tau = Fraction((a + b - 1) * R - a * b * t - 2 * C0, 2 * D)
    return {"a": a, "b": b, "tau0": str(tau), "beta": max(0, math.ceil(tau))}


def analyse(d: int, q: int, k: int) -> dict:
    N = comb2(k)
    m = k // 2
    K = k - 2
    L = N * (q - 1) - theta(d, q) + k
    rec = {"d": d, "q": q, "k": k, "Lambda0": L}
    if L < 0:
        rec["excluded_by"] = "counting"
        return rec
    thd1 = theta(d - 1, q)

    def Q(s: int) -> int:
        return N - thd1 + q * comb2(s) - K * s

    S = [s for s in range(0, k + 1) if 0 <= Q(s) <= L]
    S_plus = [s for s in range(0, k + 1) if Q(s) >= 0]
    Z = [s - 2 for s in S if s >= 2]
    Z_plus = [s - 2 for s in S_plus if s >= 2]
    t = theta(d - 2, q)
    R = K * theta(d - 3, q)
    C0 = comb2(K) * theta(d - 4, q)
    D = q ** (d - 3)
    rec.update({"S": S, "t": t, "R": R, "C0": C0, "D": D})

    # plane-pencil balancing bound (dimension-independent floor for beta)
    a_, b_ = divmod(K, t)
    pencil = t * comb2(a_) + a_ * b_

    # one-sided route: lower half of (H) only
    one = bracket_bound(Z_plus, t, R, C0, D)
    beta_plus = max(pencil, one["beta"])
    rec["one_sided"] = {
        "S_plus": S_plus if len(S_plus) <= 12 else [S_plus[0], "...", S_plus[-1], f"n={len(S_plus)}"],
        "bracket": one,
        "beta": beta_plus,
        "N_phi_beta": str(N * phi(m, beta_plus)),
        "budget_excludes": N * phi(m, beta_plus) > L,
    }

    g = global_character_feasible(S, d, q, k)
    if g is not None:
        rec["global"] = g
        if not g["feasible"]:
            rec["excluded_by"] = "G"
            # continue to record the secant-side data as well, then return
    if not degree_feasible(Z, t, R):
        rec.setdefault("excluded_by", "A")
        rec["secant_system_feasible"] = False
        return rec
    rec["secant_system_feasible"] = True
    exact = None
    if len(Z) <= 3:
        sols = small_solutions(Z, t, R)
        Ps = [sum(b * comb2(z) for b, z in zip(sol, Z)) for sol in sols]
        Ps = [P for P in Ps if (P - C0) % D == 0]
        exact = {"solutions": len(sols), "congruent": len(Ps)}
        rec["exact"] = exact
        if not Ps:
            rec.setdefault("excluded_by", "A2")
            return rec
        exact["P_min"] = min(Ps)
        exact["P_max"] = max(Ps)
    br = bracket_bound(Z, t, R, C0, D)
    rec["bracket"] = br
    beta = max(pencil, br["beta"])
    upper = (q - 1) * (m - 1)
    if exact is not None:
        beta = max(beta, -((C0 - exact["P_min"]) // D))
        upper = min(upper, (exact["P_max"] - C0) // D)
    UL = (math.isqrt(K * K + 2 * K * L) - K) // 2
    upper = min(upper, UL)
    rec.update({"beta": beta, "U": UL, "upper": upper, "N_phi_beta": str(N * phi(m, beta))})
    if "excluded_by" in rec:
        return rec
    if N * phi(m, beta) > L:
        rec["excluded_by"] = "B"
    elif beta > upper:
        rec["excluded_by"] = "C"
    else:
        rec["excluded_by"] = None
    return rec


def build() -> dict:
    summary = []
    detail = []
    for d, (qmax, window) in SCAN.items():
        for q in prime_powers(qmax):
            k0 = counting_bound(d, q)
            recs = [analyse(d, q, k) for k in range(k0, k0 + window + 1)]
            first = next((r["k"] for r in recs if r["excluded_by"] is None), None)
            excluded = [(r["k"], r["excluded_by"]) for r in recs if r["excluded_by"]]
            summary.append(
                {
                    "d": d,
                    "q": q,
                    "counting_bound": k0,
                    "first_surviving_k": first,
                    "excluded": excluded,
                    "gain": (first - k0) if first is not None else None,
                }
            )
            detail.extend(r for r in recs if r["excluded_by"] not in (None, "counting"))
    named = {f"PG({d},{q}) k={k}": analyse(d, q, k) for d, q, k in NAMED}
    for key, rec in named.items():
        assert rec["excluded_by"] in ("G", "A", "A2", "B"), (key, rec["excluded_by"])
        assert rec["one_sided"]["budget_excludes"], key
    gains_high = [s for s in summary if s["d"] >= 4 and s["gain"]]
    assert sorted((s["d"], s["q"]) for s in gains_high) == sorted((d, q) for d, q, _ in NAMED)
    assert all(s["gain"] == 1 for s in gains_high)
    return {
        "scan": {str(d): {"max_q": v[0], "window": v[1]} for d, v in SCAN.items()},
        "named_cases": named,
        "summary": summary,
        "excluded_rows": detail,
    }


def render(payload: dict) -> str:
    return json.dumps(payload, indent=1, sort_keys=True) + "\n"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("mode", nargs="?", default="check", choices=["check", "run"])
    ap.add_argument("--update", action="store_true")
    args = ap.parse_args()
    payload = build()
    text = render(payload)
    digest = hashlib.sha256(text.encode()).hexdigest()
    gains = [s for s in payload["summary"] if s["gain"]]
    print(f"cases={len(payload['summary'])} gains={len(gains)} sha256={digest}")
    for key, rec in payload["named_cases"].items():
        print(
            f"  {key}: Lambda0={rec['Lambda0']} S={rec['S']} excluded_by={rec['excluded_by']} "
            f"one_sided_beta={rec['one_sided']['beta']} "
            f"one_sided_budget={rec['one_sided']['N_phi_beta']}"
        )
    if args.update:
        CERT.write_text(text)
        CERT_SHA.write_text(f"{digest}  {CERT.name}\n")
        print(f"wrote {CERT.name}")
        return 0
    if args.mode == "check":
        if not CERT.exists() or CERT.read_text() != text:
            print("certificate mismatch or missing; rerun with --update after review", file=sys.stderr)
            return 1
        want = CERT_SHA.read_text().split()[0]
        if want != digest:
            print("sha256 mismatch", file=sys.stderr)
            return 1
        print("certificate matches")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
