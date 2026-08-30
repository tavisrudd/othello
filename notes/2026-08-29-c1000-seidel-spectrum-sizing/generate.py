#!/usr/bin/env python3
"""C1000 — Seidel-spectrum sizing certificate for equiangular lines in R^18.

Lane: gem-mining.  Task: C1000 Stage 0.  Report:
`notes/2026-08-29-c1000-feasibility-spike.md`.

WHAT THIS CERTIFIES
-------------------
A set of `n` equiangular lines in `R^18` with `n > 2*18` has common angle
`arccos(1/5)`, and its Seidel matrix `S` (symmetric, zero diagonal, `+-1` off
the diagonal) has smallest eigenvalue `-5` with multiplicity at least `n-18`.
Write the spectrum as `(-5)^m` together with `18` FREE eigenvalues that are all
strictly greater than `-5`, where `m = n-18`.  Two trace identities then pin
the first two power sums of the free part exactly:

    tr S   = 0          =>  sum of free eigenvalues = 5*m
    tr S^2 = n(n-1)     =>  sum of their squares    = n(n-1) - 25*m

This generator enumerates, exactly and exhaustively, every multiset of 18
INTEGERS meeting those two identities and the bound `> -5`, and then applies
the 2-adic filter of Greaves-Syatriadi-Yatsyna: writing
`Char_S(x-1) = sum_i a_i x^{n-i}` with `a_0 = 1`, the polynomial is `type 2`
(`2^i | a_i` for all `i`) when `n` is even and `weakly type 2`
(`2^{i-1} | a_i` for `i >= 1`) when `n` is odd.

It reports the surviving count and the surviving spectra for `n = 60` (settled
in the literature: `N(18) <= 59`) and for the two open cases `n = 59` and
`n = 58`.

WHAT THIS DOES NOT CERTIFY
--------------------------
- It counts only spectra whose free part is entirely INTEGRAL.  Genuine
  candidates may carry irreducible totally real factors of higher degree; those
  are not enumerated here.
- It does not apply Cauchy interlacing, the `Deck(p)` construction, the
  `P_{n,e}` congruence filter, or any eigenspace-angle argument.  Every count
  below is therefore an upper bound on the integral sub-population of the true
  candidate list and says nothing about the non-integral part.
- It does not cover spectra in which `-5` has multiplicity STRICTLY GREATER
  than `n-18`.  That is a separate, smaller family.
- Surviving the filter is not existence.  No Seidel matrix is constructed and
  no equiangular line system is claimed.  The purpose of this bundle is to size
  the search, not to decide `N(18)`.

TRUSTED BOUNDARY
----------------
Python arbitrary-precision integer arithmetic, the two trace identities above,
and the type-2 statement as quoted.  No floating point is used anywhere in the
derivation: the eigenvalue window is derived by an exact integer inequality.

REPLAY
------
From the repository root:

    python3 notes/2026-08-29-c1000-seidel-spectrum-sizing/generate.py --check
    python3 notes/2026-08-29-c1000-seidel-spectrum-sizing/replay.py

`--check` regenerates everything in memory and compares byte-for-byte against
the tracked `certificate.json`, leaving the worktree unchanged.  `replay.py`
shares no code with this file.
"""

import argparse
import hashlib
import json
import math
import os
import sys

SCHEMA = "c1000-seidel-spectrum-sizing/1"
DIM = 18  # the ambient dimension R^18

# The four integer-rooted candidate characteristic polynomials named explicitly
# in the published n = 60 analysis (Greaves & Syatriadi, arXiv:2206.04267v2),
# given as the multiset of the 18 free eigenvalues after removing (x+5)^42.
# Used as the positive control: this generator's necessary conditions are
# strictly weaker than the published pipeline's, so all four MUST survive.
PUBLISHED_N60_INTEGER_CANDIDATES = {
    "(x+5)^42 (x-9)^3 (x-11)^6 (x-13)^9": (9,) * 3 + (11,) * 6 + (13,) * 9,
    "(x+5)^42 (x-11)^14 (x-13)^3 (x-17)": (11,) * 14 + (13,) * 3 + (17,),
    "(x+5)^42 (x-9)^2 (x-11)^9 (x-13)^6 (x-15)": (
        (9,) * 2 + (11,) * 9 + (13,) * 6 + (15,)
    ),
    "(x+5)^42 (x-11)^15 (x-15)^3": (11,) * 15 + (15,) * 3,
}


# --------------------------------------------------------------------------
# exact spectral bookkeeping
# --------------------------------------------------------------------------

def free_part(n, forced=None):
    """Free eigenvalue count, required sum and required sum of squares.

    `forced` is an optional (value, multiplicity) pair for an auxiliary integer
    eigenvalue whose multiplicity is forced by a Lemmens-Seidel refinement.
    """
    m = n - DIM                       # multiplicity of -5
    d = DIM
    s = 5 * m                         # tr S = 0
    q = n * (n - 1) - 25 * m          # tr S^2 = n(n-1)
    if forced is not None:
        val, mult = forced
        d -= mult
        s -= val * mult
        q -= val * val * mult
    return m, d, s, q


def eigenvalue_window(d, s, q):
    """Exact integer window for a single free eigenvalue.  No floating point.

    Every free eigenvalue x satisfies (x - s/d)^2 <= ssd, where
    ssd = q - s^2/d is the total sum of squared deviations from the mean,
    because the other d-1 squared deviations are nonnegative.  Clearing
    denominators gives the integer inequality

        (d*x - s)^2 <= d*(d*q - s*s).

    Free eigenvalues are strictly greater than -5, hence at least -4.
    """
    bound = d * (d * q - s * s)
    if bound < 0:
        return None
    # |d*x - s| is a nonnegative integer, so it is at most isqrt(bound).
    radius = math.isqrt(bound)
    lo = -((-(s - radius)) // d)          # ceiling division
    hi = (s + radius) // d                # floor division
    return (max(-4, lo), hi)


def enumerate_integer_spectra(d, s, q, lo, hi):
    """Every multiset of d integers in [lo,hi] with sum s and sum of squares q.

    Deterministic: values are consumed in increasing order, so each multiset is
    produced exactly once as a non-decreasing tuple.
    """
    out = []

    def rec(v, k, ps, pq, acc):
        if k == d:
            if ps == s and pq == q:
                out.append(acc)
            return
        if v > hi:
            return
        rem = d - k
        # every remaining value is >= v, so the sum of squares can only grow
        if pq + rem * v * v > q:
            return
        # and every remaining value is <= hi
        if ps + rem * hi < s:
            return
        for j in range(rem + 1):
            npq = pq + j * v * v
            if npq > q:
                break
            rec(v + 1, k + j, ps + j * v, npq, acc + (v,) * j)

    rec(lo, 0, 0, 0, ())
    out.sort()
    return out


# --------------------------------------------------------------------------
# characteristic polynomial and the 2-adic type-2 filter
# --------------------------------------------------------------------------

def poly_from_roots(roots):
    """Monic polynomial with the given roots, coefficients low degree first."""
    p = [1]
    for r in roots:
        nxt = [0] * (len(p) + 1)
        for i, a in enumerate(p):
            nxt[i] -= a * r
            nxt[i + 1] += a
        p = nxt
    return p


def shift_by_minus_one(p):
    """q(x) = p(x-1), both given low degree first, by repeated synthetic shift."""
    q = [0] * len(p)
    acc = [1]                     # (x-1)^k, built incrementally
    for k, a in enumerate(p):
        if a:
            for i, b in enumerate(acc):
                q[i] += a * b
        nxt = [0] * (len(acc) + 1)
        for i, b in enumerate(acc):
            nxt[i] -= b
            nxt[i + 1] += b
        acc = nxt
    return q


def is_type2(p, n, weak):
    """p has degree n, low degree first; a_i is the coefficient of x^{n-i}."""
    for i in range(1, n + 1):
        e = i - 1 if weak else i
        if e and p[n - i] % (1 << e):
            return False
    return True


def type2_survivors(n, m, free, forced):
    """Filter integer free spectra by the 2-adic condition on Char_S(x-1)."""
    weak = n % 2 == 1
    extra = () if forced is None else (forced[0],) * forced[1]
    keep = []
    for spectrum in free:
        roots = (-5,) * m + spectrum + extra
        if is_type2(shift_by_minus_one(poly_from_roots(roots)), n, weak):
            keep.append(spectrum)
    return keep


# --------------------------------------------------------------------------
# certificate construction
# --------------------------------------------------------------------------

CASES = [
    ("n60-free18", 60, None),
    ("n59-free18", 59, None),
    ("n58-free18", 58, None),
    ("n60-forced-11pow6", 60, (11, 6)),
]


def build():
    cases = []
    for case_id, n, forced in CASES:
        m, d, s, q = free_part(n, forced)
        lo, hi = eigenvalue_window(d, s, q)
        spectra = enumerate_integer_spectra(d, s, q, lo, hi)
        keep = type2_survivors(n, m, spectra, forced)
        cases.append({
            "case_id": case_id,
            "order_n": n,
            "minus5_multiplicity": m,
            "forced_factor": (None if forced is None
                              else {"eigenvalue": forced[0],
                                    "multiplicity": forced[1]}),
            "free_degree": d,
            "free_sum": s,
            "free_sumsq": q,
            # sum of squared deviations from the mean, as an exact fraction
            "ssd_numerator": d * q - s * s,
            "ssd_denominator": d,
            "eigenvalue_window": [lo, hi],
            "integer_spectra": len(spectra),
            "type2_survivors": len(keep),
            "type2_survivor_spectra": [list(t) for t in keep],
            "type2_condition": "weak" if n % 2 else "strict",
        })

    by_id = {c["case_id"]: c for c in cases}
    control = []
    survivors_free18 = {tuple(t) for t in by_id["n60-free18"]["type2_survivor_spectra"]}
    survivors_forced = {tuple(t) for t in by_id["n60-forced-11pow6"]["type2_survivor_spectra"]}
    for name, spectrum in sorted(PUBLISHED_N60_INTEGER_CANDIDATES.items()):
        srt = tuple(sorted(spectrum))
        # the forced case stores the free part after removing (x-11)^6
        red = list(srt)
        for _ in range(6):
            red.remove(11)
        control.append({
            "polynomial": name,
            "free_spectrum": list(srt),
            "in_n60_free18_survivors": srt in survivors_free18,
            "in_n60_forced_survivors": tuple(red) in survivors_forced,
        })
    control_ok = all(c["in_n60_free18_survivors"] and c["in_n60_forced_survivors"]
                     for c in control)

    return {
        "schema": SCHEMA,
        "task": "C1000",
        "lane": "gem-mining",
        "report": "notes/2026-08-29-c1000-feasibility-spike.md",
        "ambient_dimension": DIM,
        "angle": "arccos(1/5)",
        "certifies": (
            "For each listed order n, the complete count and list of multisets "
            "of 18 integers greater than -5 that satisfy tr S = 0 and "
            "tr S^2 = n(n-1) for a Seidel matrix whose smallest eigenvalue is "
            "-5 with multiplicity exactly n-18, both before and after the "
            "2-adic type-2 filter on Char_S(x-1)."
        ),
        "does_not_certify": [
            "candidate spectra carrying irreducible totally real factors of degree > 1",
            "Cauchy interlacing, the Deck(p) construction, the P_{n,e} congruence filter, or eigenspace-angle arguments",
            "spectra in which -5 has multiplicity strictly greater than n-18",
            "existence of any Seidel matrix or equiangular line system",
        ],
        "trusted_boundary": (
            "Python arbitrary-precision integer arithmetic; the two trace "
            "identities; the type-2 statement of Greaves-Syatriadi-Yatsyna. "
            "No floating point is used."
        ),
        "positive_control": {
            "source": "Greaves & Syatriadi, arXiv:2206.04267v2, the integer-rooted members of the published complete 44-candidate list for n = 60",
            "all_published_candidates_survive": control_ok,
            "candidates": control,
        },
        "cases": cases,
    }


def canonical(obj):
    return json.dumps(obj, indent=2, sort_keys=True, ensure_ascii=True) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true",
                    help="regenerate in memory and compare against the tracked "
                         "certificate.json without touching the worktree")
    args = ap.parse_args()

    here = os.path.dirname(os.path.abspath(__file__))
    target = os.path.join(here, "certificate.json")
    text = canonical(build())

    if args.check:
        if not os.path.exists(target):
            print(f"FAIL: {target} is missing", file=sys.stderr)
            return 1
        with open(target, "r", encoding="ascii") as fh:
            tracked = fh.read()
        if tracked != text:
            print("FAIL: regenerated certificate differs from the tracked file",
                  file=sys.stderr)
            print(f"  tracked    sha256 {hashlib.sha256(tracked.encode()).hexdigest()}",
                  file=sys.stderr)
            print(f"  regenerated sha256 {hashlib.sha256(text.encode()).hexdigest()}",
                  file=sys.stderr)
            return 1
        print(f"PASS: certificate.json reproduced exactly "
              f"(sha256 {hashlib.sha256(text.encode()).hexdigest()})")
        return 0

    with open(target, "w", encoding="ascii") as fh:
        fh.write(text)
    print(f"wrote {target}")
    print(f"sha256 {hashlib.sha256(text.encode()).hexdigest()}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
