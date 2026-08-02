#!/usr/bin/env python3
"""C756 Route F: verify the moment digit tower and the composition normal form.

Claims verified exactly, per candidate, over the bounded prime fields
q in {5, 7, 11, 19, 23} in the canonical minimizing orientation:

  * level profile: for r = 1..t+1 (t = (q+1)/2), whether every signed power
    sum P_e = sum_z x(z) z^e with e = j + q(r-j), 0 <= j <= r, vanishes;
  * the first failing level equals the uniform pi-adic valuation of the
    Fourier transform x^ recorded by the 2026-08-02 census (recomputed here
    directly at the first support frequency, not read from the census file);
  * for the two q=5 frames: levels 1..t all pass and level t+1 fails, so the
    valuation is exactly t+1; the monic polynomial H = prod (X - z_i) has
    every coefficient rational except the constant term; with R = H + gamma
    (gamma the irrational constant), R is rational of degree t+1, gamma is a
    quadratic point, the fiber R^{-1}(gamma) is exactly Z with distinct
    roots, and the master polynomial satisfies
    G = prod f_i = (R - gamma)(R - gamma^q) coefficientwise.

The theorems these computations certify are proved in
2026-08-02-c756-digit-tower-composition.md.
"""

from __future__ import annotations

import argparse
from hashlib import sha256
from importlib.util import module_from_spec, spec_from_file_location
import json
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-08-02-c756-sparse-paley-trade-profile.py"
OUTPUT = HERE / "2026-08-02-c756-digit-tower-composition.json"
FIELDS = (5, 7, 11, 19, 23)

spec = spec_from_file_location("c756_profile", SOURCE)
profile = module_from_spec(spec)
spec.loader.exec_module(profile)


def signed_power_sum(Z, field, e):
    """P_e = s_e - s_e^q for s_e = sum over the oriented representatives."""
    total = (0, 0)
    for z in Z:
        total = field["add"](total, field["fpow"](z, e))
    return field["sub"](total, field["conj"](total))


def level_profile(Z, field, q):
    t = (q + 1) // 2
    passes = {}
    for r in range(1, t + 2):
        values = [signed_power_sum(Z, field, j + q * (r - j)) for j in range(r + 1)]
        passes[r] = all(value == (0, 0) for value in values)
    first_fail = next((r for r in range(1, t + 2) if not passes[r]), None)
    assert first_fail is not None
    return passes, first_fail


def direct_valuation(Z, field, q):
    """v_pi of x^ at the first support frequency, recomputed from scratch."""
    eps = field["eps"]
    conj = field["conj"]
    signed = {z: 1 for z in Z}
    signed.update({conj(z): -1 for z in Z})
    digit_matrix = [
        [comb(i, j) * (-1) ** j for i in range(q - 1)] for j in range(q - 1)
    ]
    for w in ((a, b) for a in range(q) for b in range(q)):
        vector = [0] * q
        for z, sign in signed.items():
            vector[(2 * (w[0] * z[0] + eps * w[1] * z[1])) % q] += sign
        reduced = profile.reduce_cyclotomic(vector, q)
        if reduced != tuple([0] * (q - 1)):
            return profile.pi_valuation(reduced, q, digit_matrix)
    raise AssertionError("x^ vanished at every frequency")


def poly_mul_linear(coeffs, root, field):
    """Multiply a monic coefficient list by (X - root)."""
    out = [(0, 0)] * (len(coeffs) + 1)
    for i, c in enumerate(coeffs):
        out[i] = field["add"](out[i], c)
        out[i + 1] = field["sub"](out[i + 1], field["mul"](c, root))
    return out


def frame_composition(Z, field, q):
    add, sub, mul, conj = field["add"], field["sub"], field["mul"], field["conj"]
    H = [(1, 0)]
    for z in Z:
        H = poly_mul_linear(H, z, field)
    irrational = [i for i, c in enumerate(H) if c[1] != 0]
    assert irrational == [len(H) - 1]
    gamma = sub((0, 0), H[-1])
    assert gamma[1] != 0
    R = H[:]
    R[-1] = add(R[-1], gamma)
    assert all(c[1] == 0 for c in R)
    assert len(set(Z)) == len(Z) == (q + 3) // 2
    G = [(1, 0)]
    for z in Z:
        G = poly_mul_linear(G, z, field)
        G = poly_mul_linear(G, conj(z), field)
    R_squared = [(0, 0)] * (2 * len(R) - 1)
    for i, a in enumerate(R):
        for j, b in enumerate(R):
            R_squared[i + j] = add(R_squared[i + j], mul(a, b))
    composed = R_squared[:]
    trace_gamma = add(gamma, conj(gamma))
    norm_gamma = mul(gamma, conj(gamma))
    for i, c in enumerate(R):
        composed[i + len(R) - 1] = sub(composed[i + len(R) - 1], mul(trace_gamma, c))
    composed[-1] = add(composed[-1], norm_gamma)
    assert composed == G
    return {
        "oriented_fiber": [list(z) for z in Z],
        "R_coefficients_descending": [c[0] for c in R],
        "gamma": list(gamma),
        "master_polynomial_composition_verified": True,
    }


def field_row(q):
    candidates, field = profile.source.saturated_candidates(q)
    chi_table = {
        (a, b): field["chi2"]((a, b)) for a in range(q) for b in range(q)
    }
    t = (q + 1) // 2
    rows = []
    frames = []
    for candidate in candidates:
        violations, bits, Z = profile.canonical_orientation(
            candidate, field, chi_table, q
        )
        passes, first_fail = level_profile(Z, field, q)
        valuation = direct_valuation(Z, field, q)
        assert valuation == first_fail
        rows.append({
            "coherence_violations_min": violations,
            "level_pass": {str(r): passes[r] for r in sorted(passes)},
            "first_failing_level": first_fail,
            "direct_pi_valuation": valuation,
        })
        if violations == 0:
            assert q == 5
            assert first_fail == t + 1
            frames.append(frame_composition(Z, field, q))
    assert all(
        (row["coherence_violations_min"] == 0) == (row["first_failing_level"] == t + 1)
        for row in rows
    ) or q != 5
    return {
        "q": q,
        "t": t,
        "candidate_count": len(candidates),
        "first_failing_level_counts": {
            str(level): sum(row["first_failing_level"] == level for row in rows)
            for level in sorted({row["first_failing_level"] for row in rows})
        },
        "valuation_equals_first_failing_level": all(
            row["direct_pi_valuation"] == row["first_failing_level"] for row in rows
        ),
        "candidates": rows,
        "frames": frames or None,
    }


def generate():
    return {
        "schema": "c756-digit-tower-composition-v1",
        "scope": (
            "every normalized pairwise-resultant-character candidate in the "
            "bounded prime fields q in {5,7,11,19,23}, canonical minimizing "
            "orientation"
        ),
        "claims": [
            "level r fails first exactly at the uniform pi-adic valuation",
            "the q=5 frames pass all levels 1..t and fail level t+1",
            "each frame is the fiber R^{-1}(gamma) of a rational polynomial "
            "R of degree (q+3)/2 over a quadratic point gamma, and "
            "G = (R-gamma)(R-gamma^q)",
        ],
        "inputs": {SOURCE.name: sha256(SOURCE.read_bytes()).hexdigest()},
        "rows": [field_row(q) for q in FIELDS],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write and --check")
    rendered = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
    else:
        assert OUTPUT.read_text() == rendered
        print(f"verified {OUTPUT}")


if __name__ == "__main__":
    main()
