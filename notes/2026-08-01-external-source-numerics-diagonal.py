#!/usr/bin/env python3
"""Independent replay of the diagonal-rigidity note's section 6 numerics.

Deterministic: canonical enumeration only, no randomness.

Emits a canonical JSON certificate on stdout, or with --check verifies the
tracked certificate byte-for-byte and leaves the worktree unchanged.

Replay from the repository root:
    python3 notes/2026-08-01-external-source-numerics-diagonal.py \
        > notes/2026-08-01-external-source-numerics-diagonal.json
    python3 notes/2026-08-01-external-source-numerics-diagonal.py --check

Certifies, for each code below: its weight set, minimum distance, dual minimum
distance, uniformity, the dimension of its third Schur power, the annihilator of
that Schur power, and the Smith normal form invariant factors of its lift
lattice (the Z-span of the 0/1 lifts of its codewords).

Does NOT certify any statement about codes other than those enumerated here, nor
anything about non-diagonal symmetries.
"""
import json
import sys
from math import gcd

# --- codes under test, by explicit generator rows (bit i = coordinate i) -----
# Reed-Muller order one on four variables, and the systematic [7,4] Hamming
# code.  The Hamming rows must be rank 4: the four cyclic shifts 1110100,
# 0111010, 0011101, 1001110 are rank 3 (the fourth is the sum of the first two)
# and generate the [7,3] simplex code instead.  That variant is included
# explicitly so the distinction is certified rather than left as a trap.


def rm14_rows():
    n = 16
    rows = [(1 << n) - 1]
    for i in range(4):
        rows.append(sum(((p >> i) & 1) << (n - 1 - p) for p in range(n)))
    return n, rows


CODES = {
    "RM(1,4)": rm14_rows(),
    "Hamming[7,4]": (7, [0b1000011, 0b0100101, 0b0010110, 0b0001111]),
    "Simplex[7,3]": (7, [0b1110100, 0b0111010, 0b0011101]),
}


def wt(x):
    return bin(x).count("1")


def span(rows):
    out = [0]
    for g in rows:
        out += [s ^ g for s in out]
    return sorted(set(out))


def rank_f2(vecs):
    basis, piv = [], []
    for v in vecs:
        for p, b in zip(piv, basis):
            if v >> p & 1:
                v ^= b
        if v:
            piv.append(v.bit_length() - 1)
            basis.append(v)
    return len(basis)


def dual_distance(code, n):
    best = n + 1
    for u in range(1, 1 << n):
        if all(wt(u & c) % 2 == 0 for c in code):
            best = min(best, wt(u))
    return best


def schur_cube(code):
    prods = set()
    for a in code:
        for b in code:
            ab = a & b
            for c in code:
                prods.add(ab & c)
    return sorted(prods)


def annihilator(prods, n):
    return [u for u in range(1, 1 << n) if all(wt(u & v) % 2 == 0 for v in prods)]


def smith_invariant_factors(rows, ncols):
    """Invariant factors of the integer lattice spanned by `rows`, by exact
    integer row/column reduction with a smallest-pivot rule."""
    M = [r[:] for r in rows]
    m, divs, r, c = len(M), [], 0, 0
    while r < m and c < ncols:
        best = piv = None
        for i in range(r, m):
            for j in range(c, ncols):
                if M[i][j] and (best is None or abs(M[i][j]) < best):
                    best, piv = abs(M[i][j]), (i, j)
        if piv is None:
            break
        while True:
            i, j = piv
            M[r], M[i] = M[i], M[r]
            for row in M:
                row[c], row[j] = row[j], row[c]
            p = M[r][c]
            clean = True
            for i in range(r + 1, m):
                if M[i][c] % p:
                    q = M[i][c] // p
                    M[i] = [a - q * b for a, b in zip(M[i], M[r])]
                    clean = False
            for j in range(c + 1, ncols):
                if M[r][j] % p:
                    q = M[r][j] // p
                    for row in M:
                        row[j] -= q * row[c]
                    clean = False
            if clean:
                break
            best = piv = None
            for i in range(r, m):
                for j in range(c, ncols):
                    if M[i][j] and (best is None or abs(M[i][j]) < best):
                        best, piv = abs(M[i][j]), (i, j)
        p = M[r][c]
        for i in range(r + 1, m):
            q = M[i][c] // p
            M[i] = [a - q * b for a, b in zip(M[i], M[r])]
        for j in range(c + 1, ncols):
            q = M[r][j] // p
            for row in M:
                row[j] -= q * row[c]
        divs.append(abs(p))
        r, c = r + 1, c + 1
    for i in range(len(divs) - 1):
        for j in range(i + 1, len(divs)):
            g = gcd(divs[i], divs[j])
            divs[i], divs[j] = g, divs[i] * divs[j] // g
    return divs


def analyse(name, n, rows):
    code = span(rows)
    nonzero = [c for c in code if c]
    prods = schur_cube(code)
    ann = annihilator(prods, n)
    lifts = [[(c >> (n - 1 - k)) & 1 for k in range(n)] for c in nonzero]
    divs = smith_invariant_factors(lifts, n)

    # --- independent cross-checks, theory-level, not a second SNF routine ----
    # 1. an invariant factor divisible by 8 exists  <=>  the all-ones vector is
    #    an order-8 diagonal symmetry  <=>  every weight is divisible by 8.
    triply_even = all(wt(c) % 8 == 0 for c in code)
    has8 = any(d % 8 == 0 for d in divs)
    # 2. the annihilator of the Schur cube must contain the all-ones vector
    #    exactly when the code is triply even (necessary condition, Theorem 3).
    allones = (1 << n) - 1
    ann_has_allones = allones in ann
    # 3. number of invariant factors equals the Q-rank of the lift lattice.
    rank_ok = len(divs) == len([d for d in divs if d])

    return {
        "name": name,
        "length": n,
        "dimension": rank_f2(rows),
        "weights": sorted({wt(c) for c in code}),
        "min_distance": min(wt(c) for c in nonzero),
        "dual_min_distance": dual_distance(code, n),
        "uniformity": min(min(wt(c) for c in nonzero), dual_distance(code, n)) - 1,
        "schur_cube_dim": rank_f2(prods),
        "schur_cube_full": rank_f2(prods) == n,
        "annihilator_size": len(ann),
        "annihilator_vectors": [format(a, "0%db" % n) for a in sorted(ann)],
        "smith_invariant_factors": sorted(divs),
        "all_factors_clifford": all(d in (1, 2, 4) for d in divs),
        "crosscheck_triply_even": triply_even,
        "crosscheck_has_factor_8": has8,
        "crosscheck_triply_even_iff_factor8": triply_even == has8,
        "crosscheck_annihilator_contains_allones": ann_has_allones,
        "crosscheck_allones_iff_triply_even": ann_has_allones == triply_even,
        "crosscheck_rank_consistent": rank_ok,
    }


def build():
    return {
        "schema": "external-source-numerics-diagonal/1",
        "source_note": "notes/2026-08-01-external-session-notes/"
                       "diagonal_rigidity_phase_boundary.md section 6",
        "codes": [analyse(k, n, rows) for k, (n, rows) in sorted(CODES.items())],
    }


def main():
    doc = build()
    text = json.dumps(doc, indent=2, sort_keys=True) + "\n"
    if "--check" in sys.argv:
        path = __file__.replace(".py", ".json")
        with open(path) as fh:
            tracked = fh.read()
        if tracked != text:
            print("MISMATCH against tracked certificate", file=sys.stderr)
            sys.exit(1)
        bad = [c["name"] for c in doc["codes"]
               if not (c["crosscheck_triply_even_iff_factor8"]
                       and c["crosscheck_allones_iff_triply_even"]
                       and c["crosscheck_rank_consistent"])]
        if bad:
            print(f"CROSS-CHECK FAILED for {bad}", file=sys.stderr)
            sys.exit(1)
        print("OK: certificate matches and all cross-checks pass")
        return
    sys.stdout.write(text)


if __name__ == "__main__":
    main()
