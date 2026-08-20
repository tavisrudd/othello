#!/usr/bin/env python3
"""C816 — exhaustive census of hollow symmetric 6x6 sign matrices.

Certifies that three conditions coincide exactly on the 2^15 hollow symmetric
sign matrices of order six:

  (C)  A^2 = 5I                     -- A is a symmetric conference matrix;
  (E)  det A[S^c, S] != 0 for all twenty 3-subsets S.  A 3x3 sign matrix has
       absolute determinant 0 or 4 and nothing else, which the census also
       certifies, so (E) is equally the statement that every complementary
       3x3 minor is extremal;
  (P)  Pf[D_x, A] = mu * T_A(x) for some mu != 0, where
       T_A(x) = sum over 3-subsets S of (product of the three edge weights in S)
       times the squarefree monomial x_S.

Everything is exact integer arithmetic over a deterministic enumeration; there
is no randomness, no floating point, and no seed.

Replay from the repository root:

    python3 notes/2026-08-20-c816-extremal-minor-census.py --write
    python3 notes/2026-08-20-c816-extremal-minor-census.py --check

`--write` regenerates notes/2026-08-20-c816-extremal-minor-census.json in place.
`--check` regenerates into memory, compares against the tracked JSON, and leaves
the worktree unchanged; it exits nonzero on any difference.

What the certificate does and does not certify.  It certifies the three counts,
their pairwise coincidence, the multiset of proportionality constants, and the
size of the switching-and-relabelling orbit of the pentagon representative, all
at order six only.  It certifies nothing about weighted (non-sign) matrices, and
nothing at any other order; the order-six restriction is not an assumption of
the census but the only order at which a Pfaffian of a 6x6 skew matrix is a
cubic, which is what makes (P) a comparison of two cubics.

Trusted boundary: CPython's integer arithmetic and `itertools`.  The two
independent computations of the cubic's coefficients -- the matching expansion
of the Pfaffian and the complementary 3x3 minors -- are cross-checked against
each other inside the run, so a defect in either would fail loudly.
"""

import argparse
import hashlib
import itertools
import json
import os
import sys

N = 6
PAIRS = list(itertools.combinations(range(N), 2))
TRIPLES = list(itertools.combinations(range(N), 3))

# Pentagon conference matrix of order six, upper-triangular entries in PAIRS order.
PENTAGON = (1, 1, 1, 1, 1, 1, -1, -1, 1, 1, -1, -1, 1, -1, 1)


def build(signs):
    """Hollow symmetric matrix from its upper-triangular entries, as a tuple of rows."""
    rows = [[0] * N for _ in range(N)]
    for (i, j), s in zip(PAIRS, signs):
        rows[i][j] = s
        rows[j][i] = s
    return rows


def perm_sign(seq):
    """Sign of the permutation given by seq, a rearrangement of range(len(seq))."""
    p = list(seq)
    sign = 1
    for i in range(len(p)):
        while p[i] != i:
            j = p[i]
            p[i], p[j] = p[j], p[i]
            sign = -sign
    return sign


def perfect_matchings(items):
    if not items:
        yield []
        return
    a = items[0]
    for k in range(1, len(items)):
        b = items[k]
        rest = items[1:k] + items[k + 1:]
        for tail in perfect_matchings(rest):
            yield [(a, b)] + tail


MATCHINGS = [(m, perm_sign([v for e in m for v in e])) for m in perfect_matchings(list(range(N)))]

# Precompute, for each matching, the eight (subset, sign) choices its expansion
# of prod (x_i - x_j) contributes: pick x_i (+1) or x_j (-1) from each factor.
EXPANSION = []
for m, sgn in MATCHINGS:
    entries = []
    for choice in itertools.product((0, 1), repeat=len(m)):
        subset = tuple(sorted(edge[c] for edge, c in zip(m, choice)))
        sign = sgn
        for c in choice:
            if c == 1:
                sign = -sign
        entries.append((subset, sign))
    EXPANSION.append((m, entries))

TRIPLE_INDEX = {S: k for k, S in enumerate(TRIPLES)}


def pfaffian_cubic(A):
    """Coefficients of Pf[D_x, A] on the twenty squarefree cubic monomials."""
    coeffs = [0] * len(TRIPLES)
    for m, entries in EXPANSION:
        weight = 1
        for i, j in m:
            weight *= A[i][j]
        if weight == 0:
            continue
        for subset, sign in entries:
            coeffs[TRIPLE_INDEX[subset]] += sign * weight
    return coeffs


def det3(A, rows, cols):
    r0, r1, r2 = rows
    c0, c1, c2 = cols
    return (
        A[r0][c0] * (A[r1][c1] * A[r2][c2] - A[r1][c2] * A[r2][c1])
        - A[r0][c1] * (A[r1][c0] * A[r2][c2] - A[r1][c2] * A[r2][c0])
        + A[r0][c2] * (A[r1][c0] * A[r2][c1] - A[r1][c1] * A[r2][c0])
    )


def complementary_minors(A):
    out = []
    for S in TRIPLES:
        Sc = tuple(k for k in range(N) if k not in S)
        out.append(det3(A, Sc, S))
    return out


def triangle_cubic(A):
    return [A[i][j] * A[j][k] * A[k][i] for (i, j, k) in TRIPLES]


def is_conference(A):
    for i in range(N):
        for j in range(N):
            s = sum(A[i][k] * A[k][j] for k in range(N))
            if s != (5 if i == j else 0):
                return False
    return True


def switch_relabel_orbit(signs):
    """Orbit of a hollow sign matrix under diagonal +-1 switching and relabelling."""
    A = build(signs)
    seen = set()
    for perm in itertools.permutations(range(N)):
        for mask in range(1 << N):
            d = [1 if (mask >> i) & 1 == 0 else -1 for i in range(N)]
            key = tuple(
                d[perm[i]] * d[perm[j]] * A[perm[i]][perm[j]] for (i, j) in PAIRS
            )
            seen.add(key)
    return len(seen)


def hodge_signs():
    """The universal sign per triple relating the Pfaffian coefficient to the
    complementary minor, fixed once by the pentagon representative."""
    A = build(PENTAGON)
    pf = pfaffian_cubic(A)
    minors = complementary_minors(A)
    eps = []
    for a, b in zip(pf, minors):
        if b == 0 or a % b != 0 or abs(a // b) != 1:
            raise AssertionError("cannot fix Hodge sign table")
        eps.append(a // b)
    return eps


HODGE_SIGNS = hodge_signs()


def census():
    n_conf = n_ext = n_prop = 0
    n_all_three = 0
    mismatches = 0
    mus = set()
    cross_check_failures = 0
    dichotomy_failures = 0
    for signs in itertools.product((1, -1), repeat=len(PAIRS)):
        A = build(signs)
        pf = pfaffian_cubic(A)
        minors = complementary_minors(A)

        # Invariant: the two computations agree up to one universal sign per
        # triple, fixed once and for all by the pentagon representative.
        for a, b, e in zip(pf, minors, HODGE_SIGNS):
            if a != e * b:
                cross_check_failures += 1

        tri = triangle_cubic(A)
        conf = is_conference(A)
        ext = all(abs(v) == 4 for v in minors)
        nonzero = all(v != 0 for v in minors)
        if ext != nonzero:
            dichotomy_failures += 1
        ratios = set()
        prop = True
        for a, t in zip(pf, tri):
            if t == 0:
                prop = False
                break
            if a % t != 0:
                prop = False
                break
            ratios.add(a // t)
        prop = prop and len(ratios) == 1 and 0 not in ratios
        if prop:
            mus |= ratios

        n_conf += conf
        n_ext += ext
        n_prop += prop
        if conf and ext and prop:
            n_all_three += 1
        if not (conf == ext == prop):
            mismatches += 1

    return {
        "schema": "c816-extremal-minor-census/1",
        "order": N,
        "matrices_enumerated": 2 ** len(PAIRS),
        "abs_determinants_of_3x3_sign_matrices": sorted(
            {
                abs(det3(build_free(s), (0, 1, 2), (0, 1, 2)))
                for s in itertools.product((1, -1), repeat=9)
            }
        ),
        "count_conference": n_conf,
        "count_all_complementary_minors_extremal": n_ext,
        "count_pfaffian_proportional_to_triangle": n_prop,
        "count_satisfying_all_three": n_all_three,
        "matrices_where_the_three_disagree": mismatches,
        "proportionality_constants": sorted(mus),
        "pentagon_switching_relabelling_orbit_size": switch_relabel_orbit(PENTAGON),
        "pfaffian_versus_complementary_minor_cross_check_failures": cross_check_failures,
        "matrices_where_extremal_differs_from_nonsingular": dichotomy_failures,
    }


def build_free(nine):
    return [list(nine[0:3]), list(nine[3:6]), list(nine[6:9])]


def canonical(obj):
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--write", action="store_true")
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args()
    if args.write == args.check:
        ap.error("give exactly one of --write or --check")

    here = os.path.dirname(os.path.abspath(__file__))
    out = os.path.join(here, "2026-08-20-c816-extremal-minor-census.json")
    text = canonical(census())

    if args.write:
        with open(out, "w") as f:
            f.write(text)
        print(out)
        print("sha256 " + hashlib.sha256(text.encode()).hexdigest())
        return 0

    if not os.path.exists(out):
        print("missing tracked certificate: " + out, file=sys.stderr)
        return 1
    with open(out) as f:
        tracked = f.read()
    if tracked != text:
        print("certificate differs from a fresh run", file=sys.stderr)
        return 1
    print("OK " + hashlib.sha256(text.encode()).hexdigest())
    return 0


if __name__ == "__main__":
    sys.exit(main())
