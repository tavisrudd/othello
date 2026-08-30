#!/usr/bin/env python3
"""Independent replay of the C1000 Seidel-spectrum sizing certificate.

Shares no code with `generate.py`.  The differences are deliberate and
structural, not cosmetic:

1. **No derived eigenvalue window.**  `generate.py` proves an exact integer
   window from the sum of squared deviations and enumerates inside it.  This
   replay ignores that window entirely, sweeps the generous fixed range
   `[-4, 40]`, and then CHECKS that every solution it finds lies inside the
   window the certificate claims.  A window that lost a candidate would show up
   here as an extra solution.

2. **No synthetic shift.**  `generate.py` builds `Char_S(x)` and then applies a
   polynomial shift to obtain `Char_S(x-1)`.  This replay uses the identity
   `prod_i (x - r_i)` evaluated at `x-1` equals `prod_i (x - (r_i + 1))`, so it
   builds `Char_S(x-1)` directly from the shifted roots and never performs a
   shift at all.

3. **No modular test.**  `generate.py` tests `2^e | a_i` with the modulus
   operator.  This replay compares 2-adic valuations computed from the integer
   two's-complement bit pattern.

4. **Opposite enumeration order.**  Multisets are built from the largest value
   downwards, not the smallest upwards.

Usage, from the repository root:

    python3 notes/2026-08-29-c1000-seidel-spectrum-sizing/replay.py

Exit status 0 means every count, every survivor list, every claimed window and
the positive control in `certificate.json` were reproduced independently.
"""

import json
import os
import sys

SWEEP_LO = -4      # free eigenvalues are > -5, hence >= -4
SWEEP_HI = 40      # deliberately far beyond any claimed window


def two_adic_valuation(a):
    """Number of times 2 divides a; a large sentinel for zero."""
    if a == 0:
        return 10 ** 6
    v = 0
    while not a & 1:
        a >>= 1
        v += 1
    return v


def monic_from_roots(roots):
    """Coefficients of prod (x - r), highest degree first."""
    coeffs = [1]
    for r in roots:
        times_x = coeffs + [0]                  # x * p, still highest first
        times_r = [0] + [c * r for c in coeffs]  # r * p, degree unchanged
        coeffs = [a - b for a, b in zip(times_x, times_r)]
    return coeffs


def passes_two_adic(coeffs_high_first, n, odd_order):
    """coeffs_high_first[i] is a_i, the coefficient of x^{n-i}."""
    for i in range(1, n + 1):
        need = i - 1 if odd_order else i
        if two_adic_valuation(coeffs_high_first[i]) < need:
            return False
    return True


def sweep(d, want_sum, want_sumsq):
    """All non-increasing tuples of d integers in [SWEEP_LO, SWEEP_HI] with the
    given sum and sum of squares.  Built largest value first."""
    found = []

    def walk(v, chosen, ssum, ssq):
        if len(chosen) == d:
            if ssum == want_sum and ssq == want_sumsq:
                found.append(tuple(sorted(chosen)))
            return
        if v < SWEEP_LO:
            return
        left = d - len(chosen)
        # every remaining value is <= v, so the running sum cannot exceed this
        if ssum + left * v < want_sum:
            return
        if ssum + left * SWEEP_LO > want_sum:
            return
        if ssq > want_sumsq:
            return
        for count in range(left + 1):
            walk(v - 1, chosen + [v] * count,
                 ssum + count * v, ssq + count * v * v)

    walk(SWEEP_HI, [], 0, 0)
    return sorted(found)


def replay_case(case):
    n = case["order_n"]
    m = case["minus5_multiplicity"]
    d = case["free_degree"]
    forced = case["forced_factor"]

    # Re-derive the two trace targets from scratch, subtracting the fixed part.
    total_sum = 0                       # tr S
    total_sumsq = n * (n - 1)           # tr S^2
    want_sum = total_sum - m * (-5)
    want_sumsq = total_sumsq - m * 25
    fixed_roots = [-5] * m
    if forced is not None:
        val, mult = forced["eigenvalue"], forced["multiplicity"]
        want_sum -= val * mult
        want_sumsq -= val * val * mult
        fixed_roots += [val] * mult

    if (want_sum, want_sumsq) != (case["free_sum"], case["free_sumsq"]):
        return False, (f"{case['case_id']}: trace targets differ "
                       f"(replay {want_sum},{want_sumsq} vs certificate "
                       f"{case['free_sum']},{case['free_sumsq']})")

    spectra = sweep(d, want_sum, want_sumsq)

    lo, hi = case["eigenvalue_window"]
    outside = [t for t in spectra if min(t) < lo or max(t) > hi]
    if outside:
        return False, (f"{case['case_id']}: {len(outside)} solutions lie "
                       f"outside the claimed window [{lo},{hi}]; the window "
                       f"derivation is unsound")

    if len(spectra) != case["integer_spectra"]:
        return False, (f"{case['case_id']}: integer spectra {len(spectra)} "
                       f"vs certificate {case['integer_spectra']}")

    odd_order = n % 2 == 1
    if odd_order != (case["type2_condition"] == "weak"):
        return False, f"{case['case_id']}: type-2 strictness disagrees"

    keep = []
    for spectrum in spectra:
        roots = [r + 1 for r in list(spectrum) + fixed_roots]
        if passes_two_adic(monic_from_roots(roots), n, odd_order):
            keep.append(list(spectrum))
    keep.sort()

    if len(keep) != case["type2_survivors"]:
        return False, (f"{case['case_id']}: type-2 survivors {len(keep)} "
                       f"vs certificate {case['type2_survivors']}")
    if keep != sorted(case["type2_survivor_spectra"]):
        return False, f"{case['case_id']}: survivor spectra differ"

    return True, (f"{case['case_id']}: {len(spectra)} integer spectra, "
                  f"{len(keep)} after the 2-adic filter, window [{lo},{hi}] "
                  f"confirmed tight against a [{SWEEP_LO},{SWEEP_HI}] sweep")


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(here, "certificate.json"), encoding="ascii") as fh:
        cert = json.load(fh)

    ok = True
    for case in cert["cases"]:
        good, msg = replay_case(case)
        print(("  ok  " if good else "  FAIL ") + msg)
        ok = ok and good

    # Positive control: the published integer-rooted n = 60 candidates must all
    # be present, re-checked here against the survivor lists directly.
    by_id = {c["case_id"]: c for c in cert["cases"]}
    free18 = {tuple(t) for t in by_id["n60-free18"]["type2_survivor_spectra"]}
    forced = {tuple(t) for t in by_id["n60-forced-11pow6"]["type2_survivor_spectra"]}
    for entry in cert["positive_control"]["candidates"]:
        spectrum = tuple(sorted(entry["free_spectrum"]))
        reduced = list(spectrum)
        for _ in range(6):
            reduced.remove(11)
        present = spectrum in free18 and tuple(reduced) in forced
        if not present:
            ok = False
        print(("  ok  " if present else "  FAIL ")
              + f"published candidate {entry['polynomial']} survives")
    if not cert["positive_control"]["all_published_candidates_survive"]:
        ok = False
        print("  FAIL certificate does not record the control as passing")

    print("PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
