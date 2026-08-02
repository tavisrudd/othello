#!/usr/bin/env python3
"""C774 red-team checks for the 2-uniform approximate-rigidity note.

Two independent probes, neither of which is in the existing external-numerics bundle
(`notes/2026-08-01-external-source-numerics.md`).

Probe 1 -- lift-lattice rank versus dual distance.
    Exhaustive over every binary linear code of length n <= 7 (all dimensions, all
    subspaces enumerated by reduced row echelon form): tests the equivalence

        rank_Q Lambda_C = n   <==>   d(C^perp) >= 3 ,

    where Lambda_C is the Z-span of the 0/1 integer lifts of the codewords of C.
    Combined with Theorem 1 of the diagonal-rigidity note (the diagonal symmetry group
    of the CSS coset state |C> is Hom(Z^n / Lambda_C, R/2piZ), so it is finite exactly
    when the lattice has full rank), this is the coding-theoretic content that
    Theorem A of the 2-uniform note implies on this class -- and it is sharp, whereas
    2-uniformity (min(d, d_perp) >= 3) is not.

Probe 2 -- Theorem B's smallness hypothesis is not decorative.
    On the 16-qubit RM(1,4) CSS coset state (which is 3-uniform, hence 2-uniform),
    the aligned local generators h_j = c Z violate the conclusion

        D <= sqrt(6q/5) * eps(U)

    for c around 1.5/16, at a defect of roughly 0.34.  The minimum product-Frobenius
    distance from U to the *entire* diagonal symmetry group of the state is computed
    exactly by enumerating that group (order 2^17), confirming the identity is the
    nearest diagonal exact symmetry, so no rebasing onto another exact symmetry
    rescues the bound within the diagonal sector.  The general-n closed form
    ratio(theta) = theta / (2 sin(theta/2)), theta = N c, shows the breakdown happens
    at a fixed value of sum_j ||h_j||_op ~ 1.46 for every length N = 2^m, i.e. at a
    defect that shrinks like N^{-1/2}.

Replay from the repository root:

    uv run --with numpy --with sympy python \
        notes/2026-08-01-c774-red-team-checks.py --check

`--check` recomputes everything and compares against the tracked certificate
`notes/2026-08-01-c774-red-team-checks.json`, exiting nonzero on any mismatch and
leaving the worktree unchanged.  Without `--check` the certificate is written to stdout.
"""

from __future__ import annotations

import argparse
import itertools
import json
import math
import pathlib
import sys
from fractions import Fraction

import numpy as np

CERT = pathlib.Path(__file__).with_suffix(".json")
ROUND = 10


# --------------------------------------------------------------------------- #
# Probe 1: lift lattice rank vs dual distance
# --------------------------------------------------------------------------- #


def rref_subspaces(n: int):
    """Yield every subspace of F_2^n exactly once, as a list of basis rows (ints)."""
    for k in range(0, n + 1):
        if k == 0:
            yield []
            continue
        for pivots in itertools.combinations(range(n), k):
            free = [
                [j for j in range(pivots[i] + 1, n) if j not in pivots] for i in range(k)
            ]
            slots = [len(f) for f in free]
            total = 1 << sum(slots)
            for mask in range(total):
                rows = []
                bit = 0
                for i in range(k):
                    r = 1 << (n - 1 - pivots[i])
                    for j in free[i]:
                        if (mask >> bit) & 1:
                            r |= 1 << (n - 1 - j)
                        bit += 1
                    rows.append(r)
                yield rows


def span(rows, n):
    """All codewords of the code spanned by `rows`, as ints."""
    out = [0]
    for r in rows:
        out += [c ^ r for c in out]
    return out


def bits(c, n):
    return [(c >> (n - 1 - j)) & 1 for j in range(n)]


def dual_min_distance(rows, n):
    """Minimum nonzero weight of C^perp; math.inf when C^perp = {0}."""
    # C^perp = null space of the generator matrix.
    best = math.inf
    dual_rows = nullspace_f2(rows, n)
    for c in span(dual_rows, n):
        if c:
            best = min(best, bin(c).count("1"))
    return best


def nullspace_f2(rows, n):
    """Basis of the F_2 null space of the matrix whose rows are `rows` (as ints)."""
    mat = list(rows)
    pivots = {}
    r = 0
    for col in range(n):
        bitmask = 1 << (n - 1 - col)
        piv = None
        for i in range(r, len(mat)):
            if mat[i] & bitmask:
                piv = i
                break
        if piv is None:
            continue
        mat[r], mat[piv] = mat[piv], mat[r]
        for i in range(len(mat)):
            if i != r and (mat[i] & bitmask):
                mat[i] ^= mat[r]
        pivots[col] = r
        r += 1
    free_cols = [c for c in range(n) if c not in pivots]
    basis = []
    for fc in free_cols:
        v = 1 << (n - 1 - fc)
        for pc, ri in pivots.items():
            if (mat[ri] >> (n - 1 - fc)) & 1:
                v |= 1 << (n - 1 - pc)
        basis.append(v)
    return basis


def rational_rank(vectors, n):
    """Exact rank over Q of a list of integer vectors, with early exit at n."""
    basis: list[list[Fraction]] = []
    pivot_cols: list[int] = []
    for v in vectors:
        row = [Fraction(x) for x in v]
        for b, pc in zip(basis, pivot_cols):
            if row[pc]:
                f = row[pc]
                row = [a - f * c for a, c in zip(row, b)]
        pc = next((j for j in range(n) if row[j]), None)
        if pc is None:
            continue
        f = row[pc]
        row = [a / f for a in row]
        basis.append(row)
        pivot_cols.append(pc)
        if len(basis) == n:
            return n
    return len(basis)


def probe_lattice(max_n: int = 7):
    results = {}
    for n in range(1, max_n + 1):
        codes = 0
        agree = 0
        witnesses = []
        for rows in rref_subspaces(n):
            codes += 1
            words = span(rows, n)
            rk = rational_rank([bits(c, n) for c in words], n)
            dperp = dual_min_distance(rows, n)
            lhs = rk == n
            rhs = dperp >= 3
            if lhs == rhs:
                agree += 1
            else:
                witnesses.append({"rows": rows, "rank": rk, "d_perp": dperp})
        results[str(n)] = {
            "codes": codes,
            "agree": agree,
            "counterexamples": witnesses,
        }
    return results


# --------------------------------------------------------------------------- #
# Probe 2: Theorem B counterexample on the RM(1,4) coset state
# --------------------------------------------------------------------------- #

N_RM = 16
Q = 2


def rm1_4_generators():
    """Generator rows of RM(1,4) as length-16 0/1 lists: all-ones + 4 coordinate maps."""
    rows = [[1] * N_RM]
    for b in range(4):
        rows.append([(i >> b) & 1 for i in range(N_RM)])
    return rows


def rm1_4_codewords():
    rows = rm1_4_generators()
    words = [[0] * N_RM]
    for r in rows:
        words = words + [[(a ^ b) for a, b in zip(w, r)] for w in words]
    # dedupe
    seen = {}
    for w in words:
        seen[tuple(w)] = None
    return [list(t) for t in seen]


def coset_state(words):
    psi = np.zeros(1 << N_RM, dtype=complex)
    for w in words:
        idx = 0
        for b in w:
            idx = (idx << 1) | b
        psi[idx] = 1.0
    psi /= np.linalg.norm(psi)
    return psi


def pair_marginal_max_deviation(psi):
    """max_{j<k} || rho_jk - I/4 ||_F over all pairs, computed by reshaping."""
    t = psi.reshape([2] * N_RM)
    worst = 0.0
    ident = np.eye(4) / 4.0
    for j, k in itertools.combinations(range(N_RM), 2):
        perm = [j, k] + [a for a in range(N_RM) if a not in (j, k)]
        m = np.transpose(t, perm).reshape(4, -1)
        rho = m @ m.conj().T
        worst = max(worst, float(np.linalg.norm(rho - ident)))
    return worst


def theorem_b_ratio_closed_form(c):
    """Exact ratio D / (sqrt(q) eps) for h_j = c Z on the RM(1,4) coset state."""
    overlap = (30.0 + 2.0 * math.cos(N_RM * c)) / 32.0
    eps = math.sqrt(max(0.0, 2.0 - 2.0 * abs(overlap)))
    d_gen = c * math.sqrt(2.0 * N_RM)
    return d_gen, eps, d_gen / (math.sqrt(Q) * eps)


def theorem_b_ratio_statevector(psi, c):
    """Same quantities from the explicit 65536-amplitude state vector."""
    # diag phase of exp(i c Z) on |x_j>: e^{+ic} if x_j = 0 else e^{-ic}
    idx = np.arange(1 << N_RM)
    popcount = np.zeros(1 << N_RM, dtype=np.int64)
    for b in range(N_RM):
        popcount += (idx >> b) & 1
    phase = np.exp(1j * c * (N_RM - 2 * popcount))
    upsi = phase * psi
    overlap = complex(np.vdot(psi, upsi))
    eps_overlap = math.sqrt(max(0.0, 2.0 - 2.0 * abs(overlap)))
    theta = math.atan2(overlap.imag, overlap.real)
    eps_direct = float(np.linalg.norm(upsi - np.exp(1j * theta) * psi))
    d_gen = c * math.sqrt(2.0 * N_RM)
    return d_gen, eps_overlap, eps_direct, d_gen / (math.sqrt(Q) * eps_overlap)


def smith_with_left_transform(a):
    """Smith normal form of an integer matrix, returning (S, divisors) with
    S * a * T = diag(divisors) for some unimodular T, S unimodular."""
    m = [row[:] for row in a]
    rows, cols = len(m), len(m[0])
    s = [[1 if i == j else 0 for j in range(rows)] for i in range(rows)]

    def row_op(i, j, f):  # row_i -= f * row_j
        for k in range(cols):
            m[i][k] -= f * m[j][k]
        for k in range(rows):
            s[i][k] -= f * s[j][k]

    def col_op(i, j, f):  # col_i -= f * col_j
        for k in range(rows):
            m[k][i] -= f * m[k][j]

    def swap_rows(i, j):
        m[i], m[j] = m[j], m[i]
        s[i], s[j] = s[j], s[i]

    def swap_cols(i, j):
        for k in range(rows):
            m[k][i], m[k][j] = m[k][j], m[k][i]

    t = 0
    while t < min(rows, cols):
        # find a pivot
        piv = None
        best = None
        for i in range(t, rows):
            for j in range(t, cols):
                if m[i][j] and (best is None or abs(m[i][j]) < best):
                    best = abs(m[i][j])
                    piv = (i, j)
        if piv is None:
            break
        swap_rows(t, piv[0])
        swap_cols(t, piv[1])
        while True:
            changed = False
            for i in range(t + 1, rows):
                if m[i][t]:
                    row_op(i, t, m[i][t] // m[t][t])
                    if m[i][t]:
                        swap_rows(t, i)
                        changed = True
            for j in range(t + 1, cols):
                if m[t][j]:
                    col_op(j, t, m[t][j] // m[t][t])
                    if m[t][j]:
                        swap_cols(t, j)
                        changed = True
            if not changed and all(m[i][t] == 0 for i in range(t + 1, rows)):
                if all(m[t][j] == 0 for j in range(t + 1, cols)):
                    break
        if m[t][t] < 0:
            row_op(t, t, 2)  # negate row t
        t += 1
    divisors = [m[i][i] for i in range(min(rows, cols))]
    return s, divisors


def invariant_factors(diag):
    """Normalize a diagonal multiset to the divisibility chain (the true SNF)."""
    d = sorted(abs(int(x)) for x in diag)
    changed = True
    while changed:
        changed = False
        for i in range(len(d) - 1):
            a, b = d[i], d[i + 1]
            if a == 0 or b % a == 0:
                continue
            g = math.gcd(a, b)
            d[i], d[i + 1] = g, a * b // g
            changed = True
        d.sort()
    return d


def diagonal_symmetry_min_distance(words, c):
    """Exact min product-Frobenius distance from U = (x)_j e^{icZ} to the whole
    diagonal symmetry group A of the coset state, by enumerating A."""
    lift_cols = [w for w in words if any(w)]
    a = [[lift_cols[j][i] for j in range(len(lift_cols))] for i in range(N_RM)]
    s, divisors = smith_with_left_transform(a)
    divisors = [abs(int(x)) for x in divisors]
    assert all(d != 0 for d in divisors), f"lattice not full rank: {divisors}"
    # Column lattice L = S^{-1} diag(d) Z^n  =>  L* = S^T diag(1/d) Z^n,
    # and L*/Z^n has representatives S^T diag(1/d) k, 0 <= k_i < d_i.
    st = np.array(s, dtype=float).T
    dual_gen = st / np.array(divisors, dtype=float)[None, :]
    ks = np.array(
        list(itertools.product(*[range(d) for d in divisors])), dtype=float
    )
    w = ks @ dual_gen.T
    alpha_u = -2.0 * c  # e^{icZ} = e^{ic} diag(1, e^{-2ic})
    delta = alpha_u - 2.0 * math.pi * w
    delta = (delta + math.pi) % (2.0 * math.pi) - math.pi
    dist = np.sqrt(np.sum(delta**2, axis=1) / 2.0)
    idx = int(np.argmin(dist))
    return float(dist[idx]), [int(x) for x in ks[idx]], invariant_factors(divisors)


# --------------------------------------------------------------------------- #


def build():
    cert = {}
    cert["probe1_lattice_rank_vs_dual_distance"] = probe_lattice(7)

    words = rm1_4_codewords()
    weights = sorted({sum(w) for w in words})
    psi = coset_state(words)
    cert["probe2_state"] = {
        "code": "RM(1,4)",
        "length": N_RM,
        "codewords": len(words),
        "weights": weights,
        "max_pair_marginal_deviation": round(pair_marginal_max_deviation(psi), ROUND),
    }

    rows = []
    for c in (0.03125, 0.05, 0.0625, 0.09375, 0.1):
        d_cf, eps_cf, ratio_cf = theorem_b_ratio_closed_form(c)
        d_sv, eps_ov, eps_dir, ratio_sv = theorem_b_ratio_statevector(psi, c)
        rows.append(
            {
                "c": c,
                "sum_op_norms": round(N_RM * c, ROUND),
                "D": round(d_cf, ROUND),
                "eps": round(eps_cf, ROUND),
                "eps_statevector_overlap": round(eps_ov, ROUND),
                "eps_statevector_direct": round(eps_dir, ROUND),
                "ratio_closed_form": round(ratio_cf, ROUND),
                "ratio_statevector": round(ratio_sv, ROUND),
                "violates_theorem_B": bool(ratio_cf > math.sqrt(6.0 / 5.0)),
                "satisfies_hypothesis": bool(N_RM * c <= 0.5),
            }
        )
    cert["probe2_theorem_b_scan"] = rows
    cert["probe2_constant"] = round(math.sqrt(6.0 / 5.0), ROUND)

    # Breakdown threshold of ratio(theta) = theta / (2 sin(theta/2)).
    lo, hi = 0.001, 3.0
    target = math.sqrt(6.0 / 5.0)
    for _ in range(200):
        mid = 0.5 * (lo + hi)
        if mid / (2.0 * math.sin(mid / 2.0)) < target:
            lo = mid
        else:
            hi = mid
    cert["probe2_breakdown_theta"] = round(0.5 * (lo + hi), 6)

    c_star = 0.09375
    best, argbest, divisors = diagonal_symmetry_min_distance(words, c_star)
    d_cf, eps_cf, ratio_cf = theorem_b_ratio_closed_form(c_star)
    cert["probe2_nearest_diagonal_symmetry"] = {
        "c": c_star,
        "invariant_factors": divisors,
        "group_order": int(np.prod([float(x) for x in divisors])),
        "distance_to_identity": round(d_cf, ROUND),
        "min_distance_over_diagonal_symmetry_group": round(best, ROUND),
        "identity_is_nearest": bool(abs(best - d_cf) < 1e-9),
        "argmin_is_zero": all(x == 0 for x in argbest),
    }
    return cert


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()
    cert = build()
    if args.check:
        want = json.loads(CERT.read_text())
        if want != cert:
            print("MISMATCH against tracked certificate", file=sys.stderr)
            for key in sorted(set(want) | set(cert)):
                if want.get(key) != cert.get(key):
                    print(f"  differs: {key}", file=sys.stderr)
            sys.exit(1)
        print("OK: certificate reproduced")
        return
    print(json.dumps(cert, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
