"""C880 item 5 — arithmetic guard for the hand proofs in
`notes/2026-08-11-c880-item5-conference-promise.md`.

This script is a check, not evidence.  Every claim in that report is proved by
hand; this only guards against an algebra slip in the four identities below.

  (I)   |A(S)| = ((n-6)*C(n,3) + sum_p m(p)^2)/16, m(p) = n-2-2a(p),
        and its spectral form C(n,4)/4 + (tr(S^4) - n(n-1)(2n-3))/32
                                                          (Corollary 3, 6)
  (II)  min |A| over all two-graphs is attained exactly at m == 0,
        i.e. exactly at the conference two-graphs                (Theorem 4)
  (III) the twelve six-point minimisers are the twelve labelled conference
        two-graphs, matching the enumeration in
        `notes/2026-08-07-c880-alignment-separation.md`          (Corollary 5)
  (IV)  lambda_3 == (n-6)/4 for the Paley conference two-graph on ten points,
        so its aligned family is a 3-(10,4,1) design           (Corollary 7)

Replay:
  uv run --with numpy python notes/2026-08-11-c880-item5-structure-check.py
"""

import itertools
from math import comb

import numpy as np


def seidel_from_descendant(n, mask):
    """Two-graph on {0..n-1} given by its descendant graph at 0 (vertex 0 isolated).

    Seidel convention: zero diagonal, -1 on edges, +1 on non-edges.
    """
    S = np.ones((n, n), dtype=np.int64)
    np.fill_diagonal(S, 0)
    for b, (i, j) in enumerate(itertools.combinations(range(1, n), 2)):
        if mask >> b & 1:
            S[i, j] = S[j, i] = -1
    return S


def aligned_sets(S, n):
    """The 4-sets on which sigma(xyz) = S_xy S_yz S_zx is constant."""
    out = []
    for Q in itertools.combinations(range(n), 4):
        sig = [S[a, b] * S[b, c] * S[a, c] for a, b, c in itertools.combinations(Q, 3)]
        if abs(sum(sig)) == 4:
            out.append(Q)
    return out


def aligned_count_by_pair_degrees(S, n):
    """Corollary 3: |A| = ((n-6)C(n,3) + sum_p m(p)^2)/16, m(p) = n-2-2a(p)."""
    total = 0
    for x, y in itertools.combinations(range(n), 2):
        coherent = sum(1 for w in range(n)
                       if w not in (x, y) and S[x, y] * S[y, w] * S[w, x] == -1)
        total += (n - 2 - 2 * coherent) ** 2
    num = (n - 6) * comb(n, 3) + total
    assert num % 16 == 0, (n, total)
    return num // 16


def aligned_count_by_trace(S, n):
    t4 = int(np.trace(np.linalg.matrix_power(S, 4)))
    num = 8 * comb(n, 4) + t4 - n * (n - 1) * (2 * n - 3)
    assert num % 32 == 0, (n, t4)
    return num // 32, t4


def paley_conference_two_graph():
    """The conference two-graph on ten points, from the Paley matrix over GF(9)."""
    els = [(a, b) for a in range(3) for b in range(3)]  # F_3[x]/(x^2+1)
    mul = lambda u, v: ((u[0] * v[0] - u[1] * v[1]) % 3, (u[0] * v[1] + u[1] * v[0]) % 3)
    sub = lambda u, v: ((u[0] - v[0]) % 3, (u[1] - v[1]) % 3)
    squares = {mul(e, e) for e in els if e != (0, 0)}
    n = 10
    S = np.ones((n, n), dtype=np.int64)
    np.fill_diagonal(S, 0)
    for i in range(9):
        for j in range(9):
            if i != j:
                S[i, j] = 1 if sub(els[i], els[j]) in squares else -1
    return S, n


print("== (I) pair-degree law and its spectral form, exhaustive ==")
for n in (5, 6, 7):
    bad_pair = bad_trace = 0
    for mask in range(1 << comb(n - 1, 2)):
        S = seidel_from_descendant(n, mask)
        direct = len(aligned_sets(S, n))
        bad_pair += aligned_count_by_pair_degrees(S, n) != direct
        bad_trace += aligned_count_by_trace(S, n)[0] != direct
    print(f"  n={n}: {1 << comb(n - 1, 2)} two-graphs,"
          f" pair-degree mismatches={bad_pair}, trace mismatches={bad_trace}")

print("== (II)+(III) minimisers of the aligned family ==")
for n in (5, 6, 7, 8):
    best, count, conference = None, 0, 0
    for mask in range(1 << comb(n - 1, 2)):
        S = seidel_from_descendant(n, mask)
        val, _ = aligned_count_by_trace(S, n)
        if best is None or val < best:
            best, count, conference = val, 0, 0
        if val == best:
            count += 1
            if np.array_equal(S @ S, (n - 1) * np.eye(n, dtype=np.int64)):
                conference += 1
    bound = n * (n - 1) * (n - 2) * (n - 6) / 96
    print(f"  n={n}: min|A|={best}  spectral bound={bound:g}  minimisers={count}"
          f"  of which conference={conference}")

print("== (V) signed split of the aligned family, exhaustive ==")
for n in (6, 7):
    bad = 0
    for mask in range(1 << comb(n - 1, 2)):
        S = seidel_from_descendant(n, mask)
        defect_sum = sum(
            sum(S[x, y] * S[y, w] * S[w, x] for w in range(n) if w not in (x, y))
            for x, y in itertools.combinations(range(n), 2)
        )
        plus = minus = 0
        for Q in itertools.combinations(range(n), 4):
            s = sum(S[a, b] * S[b, c] * S[a, c]
                    for a, b, c in itertools.combinations(Q, 3))
            plus += s == 4
            minus += s == -4
        half = aligned_count_by_pair_degrees(S, n) / 2
        skew = (n - 3) * defect_sum / 24
        bad += (plus, minus) != (round(half + skew), round(half - skew))
    print(f"  n={n}: signed-split mismatches={bad}")

print("== (VI) integrality bound off the residue n = 2 mod 4 ==")
for n in (7, 8, 9):
    extra = comb(n, 2) if n % 2 else 4
    print(f"  n={n}: plain bound={n * (n - 1) * (n - 2) * (n - 6) / 96:.2f}"
          f"  integrality bound={((n - 6) * comb(n, 3) + extra) / 16:.2f}")

print("== (IV) Paley conference two-graph on ten points ==")
S, n = paley_conference_two_graph()
A = aligned_sets(S, n)
lam3 = {t: 0 for t in itertools.combinations(range(n), 3)}
for Q in A:
    for t in itertools.combinations(Q, 3):
        lam3[t] += 1
print(f"  S^2 = (n-1)I: {np.array_equal(S @ S, (n - 1) * np.eye(n, dtype=np.int64))}")
print(f"  |A|={len(A)}  spectral prediction={n * (n - 1) * (n - 2) * (n - 6) // 96}"
      f"  lambda_3 values={sorted(set(lam3.values()))}")
profile = {}
for F in itertools.combinations(range(n), 5):
    k = sum(1 for Q in itertools.combinations(F, 4) if Q in set(A))
    profile[k] = profile.get(k, 0) + 1
print(f"  five-set profile (aligned 4-subsets per 5-set): {dict(sorted(profile.items()))}")
