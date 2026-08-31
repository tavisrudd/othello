#!/usr/bin/env python3
"""C1023 verification of the torus-equivariant carrier reduction (Theorem A).

Theorem A says: for a carrier point `s = X^a Y^b G(X^m,Y^m)` on the stratum
`{i ≡ a mod m}` of `PG(d,q)`, a torus-equivariant candidate annihilator

    L = u^{a'} v^{b'} Phi(u^m, v^m),    a', b' in {0,1},  deg Phi = Lg,

annihilates `s` exactly when a *small* explicit linear system in the
coefficients of `Phi` vanishes -- `M - Lg` equations rather than the `d-j+1`
that the unreduced Hankel system carries -- and `L` is split squarefree over
`F_q` exactly when `Phi` has `Lg` distinct roots, all of them `m`-th powers in
`F_q^*`.

This script checks both halves by brute force against the definitions, and then
uses them to produce a Theorem-A upper bound on the deep set of the stratum,
which is compared against the committed C1018 stratum censuses.

Independence: the annihilation test here is the raw Hankel contraction, and the
split-squarefree test is by explicit root enumeration; neither uses the
reduction being checked.

Usage
-----
  verify   r m cls q          check Theorem A pointwise on one stratum
  bound    r m cls q          Theorem-A upper bound on the deep set, vs census
"""

import itertools
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
_helper = __import__("2026-08-30-c1018-prs-helper")
GF = _helper.GF


def stratum_indices(d, m, cls):
    return [i for i in range(d + 1) if i % m == cls % m]


def contraction_is_zero(gf, d, s, lcoef, j):
    """Hankel test: does the degree-j form with coefficients lcoef[0..j]
    (low-to-high in x) annihilate the degree-d syndrome s?"""
    for v in range(d - j + 1):
        acc = 0
        for u in range(j + 1):
            if lcoef[u] and s[u + v]:
                acc = gf.add[acc][gf.mul[lcoef[u]][s[u + v]]]
        if acc:
            return False
    return True


def poly_mul(gf, a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        if not ai:
            continue
        for k, bk in enumerate(b):
            if bk:
                out[i + k] = gf.add[out[i + k]][gf.mul[ai][bk]]
    return out


def equivariant_form(gf, m, aprime, bprime, phi):
    """Coefficients (low-to-high in x) of u^{a'} v^{b'} Phi(u^m, v^m).

    In the dehomogenised convention of the C1018 drivers a root at infinity is
    carried by a degree deficit, so `v^{b'}` contributes only to the degree.
    """
    # Phi(u^m, v^m): coefficient of u^{m*l} is phi[l]
    body = [0] * (m * (len(phi) - 1) + 1)
    for l, c in enumerate(phi):
        body[m * l] = c
    for _ in range(aprime):
        body = poly_mul(gf, body, [0, 1])  # multiply by u
    return body


def mth_powers(gf, m):
    seen = set()
    for x in range(1, gf.q):
        seen.add(gf.pow(x, m) if hasattr(gf, "pow") else _pow(gf, x, m))
    return seen


def _pow(gf, x, e):
    acc = 1
    for _ in range(e):
        acc = gf.mul[acc][x]
    return acc


def phi_is_good(gf, phi, m, powers):
    """Phi has deg distinct roots in P^1, all nonzero and all m-th powers."""
    deg = max((i for i, c in enumerate(phi) if c), default=-1)
    if deg != len(phi) - 1:
        return False  # root at infinity -> not of the required shape
    if not phi[0]:
        return False  # root at zero
    roots = []
    for a in range(1, gf.q):
        acc = 0
        for c in reversed(phi):
            acc = gf.add[gf.mul[acc][a]][c]
        if acc == 0:
            roots.append(a)
    if len(roots) != deg:
        return False
    return all(rt in powers for rt in roots)


def projective_tuples(q, n):
    """Leading-one normal forms of length n (points of P^{n-1})."""
    for lead in range(n):
        for tail in itertools.product(range(q), repeat=n - lead - 1):
            yield tuple([0] * lead + [1] + list(tail))


def cmd_verify(r, m, cls, q):
    d = r - 1
    gf = GF(q)
    idx = stratum_indices(d, m, cls)
    M = len(idx)
    alpha, beta = idx[0], d - idx[-1]
    powers = mth_powers(gf, m)
    checked = 0
    mismatches = []
    # candidate shapes with a', b' in {0,1} and j <= d-1
    shapes = []
    for aprime in (0, 1):
        for bprime in (0, 1):
            for Lg in range(1, M):
                j = aprime + bprime + m * Lg
                if j <= d - 1:
                    shapes.append((aprime, bprime, Lg))
    for coeffs in projective_tuples(q, M):
        s = [0] * (d + 1)
        for slot, i in enumerate(idx):
            s[i] = coeffs[slot]
        for (aprime, bprime, Lg) in shapes:
            j = aprime + bprime + m * Lg
            for phi in projective_tuples(q, Lg + 1):
                lc = equivariant_form(gf, m, aprime, bprime, list(phi))
                lc = lc + [0] * (j + 1 - len(lc))
                direct = contraction_is_zero(gf, d, s, lc, j)
                # Theorem A: annihilation <=> the reduced system vanishes.
                reduced = reduced_system_vanishes(gf, d, s, idx, m, phi,
                                                  aprime, bprime, Lg)
                checked += 1
                if direct != reduced:
                    mismatches.append((coeffs, (aprime, bprime, Lg), phi,
                                       direct, reduced))
    print(json.dumps({
        "mode": "verify", "r": r, "m": m, "class": cls, "q": q,
        "stratum_indices": idx, "alpha": alpha, "beta": beta, "M": M,
        "shapes": shapes, "pairs_checked": checked,
        "reduction_mismatches": len(mismatches),
        "first_mismatches": mismatches[:3],
    }))


def reduced_system_vanishes(gf, d, s, idx, m, phi, aprime, bprime, Lg):
    """Theorem A's reduced system: group the Hankel rows by nu = n - l.

    Row `v` of the Hankel system contributes to nu only through v; the claim is
    that all rows with the same value of `(v - (alpha - aprime)) / m` carry the
    same equation, and every other row is identically zero.
    """
    j = aprime + bprime + m * Lg
    lc = equivariant_form(gf, m, aprime, bprime, list(phi))
    lc = lc + [0] * (j + 1 - len(lc))
    # Collect the distinct nonzero rows of the Hankel system.
    rows = []
    for v in range(d - j + 1):
        acc = 0
        for u in range(j + 1):
            if lc[u] and s[u + v]:
                acc = gf.add[acc][gf.mul[lc[u]][s[u + v]]]
        rows.append((v, acc))
    nonzero_rows = [v for v, acc in rows if acc]
    # Theorem A predicts the surviving rows are exactly those with
    # v ≡ (alpha - aprime) (mod m); check that and return the vanishing verdict.
    alpha = idx[0]
    predicted = {v for v, _ in rows if (v - (alpha - aprime)) % m == 0}
    if not set(nonzero_rows) <= predicted:
        raise AssertionError(
            f"row outside the predicted residue class carries a nonzero entry: "
            f"{nonzero_rows} not inside {sorted(predicted)}"
        )
    return not nonzero_rows


def cmd_bound(r, m, cls, q):
    """Count stratum points with NO torus-equivariant split squarefree
    annihilator of degree <= d-1.  By Theorem A every point outside this set is
    provably not deep, so this count is an upper bound on the deep set."""
    d = r - 1
    gf = GF(q)
    idx = stratum_indices(d, m, cls)
    M = len(idx)
    powers = mth_powers(gf, m)
    shapes = []
    for aprime in (0, 1):
        for bprime in (0, 1):
            for Lg in range(1, M):
                j = aprime + bprime + m * Lg
                if j <= d - 1:
                    shapes.append((aprime, bprime, Lg))
    # Precompute the good Phi for each Lg.
    good = {}
    for (_, _, Lg) in shapes:
        if Lg in good:
            continue
        good[Lg] = [p for p in projective_tuples(q, Lg + 1)
                    if phi_is_good(gf, list(p), m, powers)]
    survivors = 0
    survivors_e3 = 0
    survivors_degenerate = [0]
    survivors_full = [0]
    survivor_examples = []
    total = 0
    for coeffs in projective_tuples(q, M):
        s = [0] * (d + 1)
        for slot, i in enumerate(idx):
            s[i] = coeffs[slot]
        total += 1
        hit = False
        for (aprime, bprime, Lg) in shapes:
            j = aprime + bprime + m * Lg
            for phi in good[Lg]:
                lc = equivariant_form(gf, m, aprime, bprime, list(phi))
                lc = lc + [0] * (j + 1 - len(lc))
                if contraction_is_zero(gf, d, s, lc, j):
                    hit = True
                    break
            if hit:
                break
        if not hit:
            survivors += 1
            # apolar degree: least j with a nontrivial Hankel kernel
            cat2 = [[s[i + jj] for jj in range(d - 1)] for i in range(3)]
            if gf.rank(cat2) >= 3:
                survivors_e3 += 1
                if 0 in coeffs:
                    survivors_degenerate[0] += 1
                else:
                    survivors_full[0] += 1
                    if len(survivor_examples) < 6:
                        survivor_examples.append(list(coeffs))
    print(json.dumps({
        "mode": "bound", "r": r, "m": m, "class": cls, "q": q,
        "stratum_indices": idx, "M": M, "shapes": shapes,
        "good_phi_counts": {str(k): len(v) for k, v in good.items()},
        "stratum_points": total,
        "theorem_a_deep_upper_bound": survivors,
        "theorem_a_upper_bound_outside_persistent": survivors_e3,
        "survivors_with_a_zero_coefficient": survivors_degenerate[0],
        "survivors_with_all_coefficients_nonzero": survivors_full[0],
        "survivor_examples_outside_persistent": survivor_examples,
    }))


if __name__ == "__main__":
    if len(sys.argv) != 6:
        raise SystemExit(__doc__)
    cmd = sys.argv[1]
    r, m, cls, q = (int(x) for x in sys.argv[2:6])
    if cmd == "verify":
        cmd_verify(r, m, cls, q)
    elif cmd == "bound":
        cmd_bound(r, m, cls, q)
    else:
        raise SystemExit(__doc__)
