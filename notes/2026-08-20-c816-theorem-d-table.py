#!/usr/bin/env python3
"""C816 — certificate for the reduced Jacobian table displayed in Paper III.

The manuscript's rigidity theorem for the golden equality displays an
eight-by-five integer table, the reduced Jacobian on the fixed space of an
order-three symmetry.  That table is specific to two choices the manuscript
makes: the conference representative C displayed in its orientation-source
section, and the order-three element h = (0 2 4)(1 3 5) with signs
(+,-,-,-,-,+).  The C815 bundle
`notes/2026-08-05-c815-rank-14-weighted-jacobian.{py,json}` certifies the rank
statement and the order-three reduction for every order-three element; this
script certifies the displayed numbers themselves, against the manuscript's own
representative and in the manuscript's sign convention, so that a reader
checking the table has something to check it against.

Everything is exact integer and rational arithmetic over a deterministic
enumeration.  There is no randomness, no floating point, and no seed.

Replay from the repository root:

    python3 notes/2026-08-20-c816-theorem-d-table.py --write
    python3 notes/2026-08-20-c816-theorem-d-table.py --check

`--check` regenerates the certificate in memory, compares it byte for byte
against the tracked JSON, leaves the worktree unchanged, and exits nonzero on
any difference.

Trusted boundary: CPython integer and `fractions.Fraction` arithmetic, and
`itertools`.  The Pfaffian coefficients are computed twice by different routes,
the matching expansion and the signed complementary minor, and every
disagreement is counted.

What this certifies: that C is a conference matrix; that the coefficient of
x_S in Pf[D_x, C] equals 4 tau_S for all twenty triples, fixing the orientation
epsilon = +1; the closed forms for the partial derivatives; that the stabilizer
of C modulo the global sign has order sixty with the element-order profile of
the alternating group of degree five and with every permutation sign and
switching determinant +1; the character of the edge module; that h has order
three, that its fixed space is five-dimensional with the displayed orbit basis,
and that C has the displayed coordinates there; the eight reduced rows exactly
as displayed; that every row annihilates C; that the rank on the fixed space is
four; the value -5 of the displayed four-by-four minor; and that the conference
tangent space at C is five-dimensional, the conference system having rank
eleven in its sixteen variables.

What it does not certify: the constant-rank step, which is ordinary real
analysis; the representation-theoretic reduction from the fixed space back to
the full space, which is the proof's argument rather than a computation; and
anything at any other order.
"""

import argparse
import hashlib
import itertools
import json
import math
import os
import sys
from fractions import Fraction

N = 6
PAIRS = list(itertools.combinations(range(N), 2))
TRIPLES = list(itertools.combinations(range(N), 3))
IDX = {e: k for k, e in enumerate(PAIRS)}
TIDX = {S: k for k, S in enumerate(TRIPLES)}

# The conference representative displayed in the manuscript's orientation-source
# section, given by its upper-triangular entries in PAIRS order.
ENTRIES = {
    (0, 1): 1, (0, 2): 1, (0, 3): 1, (0, 4): -1, (0, 5): -1,
    (1, 2): -1, (1, 3): -1, (1, 4): -1, (1, 5): -1,
    (2, 3): 1, (2, 4): 1, (2, 5): -1,
    (3, 4): -1, (3, 5): 1,
    (4, 5): -1,
}

# The order-three symmetry the manuscript uses: h = (0 2 4)(1 3 5) with signs.
H_PERM = (2, 3, 4, 5, 0, 1)
H_SIGNS = (1, -1, -1, -1, -1, 1)


def matrix():
    A = [[0] * N for _ in range(N)]
    for (i, j), v in ENTRIES.items():
        A[i][j] = v
        A[j][i] = v
    return A


def perm_sign(seq):
    p = list(seq)
    s = 1
    for i in range(len(p)):
        while p[i] != i:
            j = p[i]
            p[i], p[j] = p[j], p[i]
            s = -s
    return s


def perfect_matchings(items):
    if not items:
        yield []
        return
    a = items[0]
    for k in range(1, len(items)):
        b = items[k]
        for tail in perfect_matchings(items[1:k] + items[k + 1:]):
            yield [(a, b)] + tail


EXPANSION = []
for _m in perfect_matchings(list(range(N))):
    _s = perm_sign([v for e in _m for v in e])
    _entries = []
    for _choice in itertools.product((0, 1), repeat=3):
        _sub = tuple(sorted(e[c] for e, c in zip(_m, _choice)))
        _sg = _s
        for _c in _choice:
            if _c:
                _sg = -_sg
        _entries.append((_sub, _sg))
    EXPANSION.append((_m, _entries))


def pfaffian_coefficients(A):
    out = [0] * len(TRIPLES)
    for m, entries in EXPANSION:
        w = 1
        for i, j in m:
            w *= A[i][j]
        if w == 0:
            continue
        for sub, sg in entries:
            out[TIDX[sub]] += sg * w
    return out


def det3(A, rows, cols):
    r0, r1, r2 = rows
    c0, c1, c2 = cols
    return (
        A[r0][c0] * (A[r1][c1] * A[r2][c2] - A[r1][c2] * A[r2][c1])
        - A[r0][c1] * (A[r1][c0] * A[r2][c2] - A[r1][c2] * A[r2][c0])
        + A[r0][c2] * (A[r1][c0] * A[r2][c1] - A[r1][c1] * A[r2][c0])
    )


def complementary_minor(A, S):
    Sc = tuple(k for k in range(N) if k not in S)
    return det3(A, Sc, S)


def triangle(A, S):
    i, j, k = S
    return A[i][j] * A[j][k] * A[k][i]


def equations(A, eps=1):
    pf = pfaffian_coefficients(A)
    return [pf[TIDX[S]] - 4 * eps * triangle(A, S) for S in TRIPLES]


def set_edge(A, e, val):
    B = [row[:] for row in A]
    i, j = e
    B[i][j] = val
    B[j][i] = val
    return B


def jacobian(A):
    """Exact Jacobian by the multilinear difference rule."""
    J = [[0] * len(PAIRS) for _ in range(len(TRIPLES))]
    for c, e in enumerate(PAIRS):
        hi = equations(set_edge(A, e, 1))
        lo = equations(set_edge(A, e, 0))
        for r in range(len(TRIPLES)):
            J[r][c] = hi[r] - lo[r]
    return J


def stabilizer(A):
    """Signed permutations fixing A, one representative per global-sign coset."""
    out = []
    for perm in itertools.permutations(range(N)):
        for mask in range(1 << (N - 1)):
            e = (1,) + tuple(1 if (mask >> i) & 1 == 0 else -1 for i in range(N - 1))
            if all(e[perm[i]] * e[perm[j]] * A[i][j] == A[perm[i]][perm[j]] for (i, j) in PAIRS):
                out.append((perm, e))
    return out


IDENT = (tuple(range(N)), (1,) * N)


def compose(g, h):
    (p1, e1), (p2, e2) = g, h
    p = tuple(p1[p2[i]] for i in range(N))
    e = tuple(e1[p2[i]] * e2[i] for i in range(N))
    if e[0] != 1:
        e = tuple(-x for x in e)
    return (p, e)


def group_order(g):
    x, k = g, 1
    while x != IDENT:
        x = compose(g, x)
        k += 1
    return k


def rank(rows, ncols):
    M = [[Fraction(x) for x in r] for r in rows]
    r = 0
    for c in range(ncols):
        piv = None
        for i in range(r, len(M)):
            if M[i][c] != 0:
                piv = i
                break
        if piv is None:
            continue
        M[r], M[piv] = M[piv], M[r]
        for i in range(len(M)):
            if i != r and M[i][c] != 0:
                f = M[i][c] / M[r][c]
                M[i] = [M[i][k] - f * M[r][k] for k in range(ncols)]
        r += 1
    return r


def det_n(M):
    n = len(M)
    total = 0
    for p in itertools.permutations(range(n)):
        term = perm_sign(list(p))
        for i in range(n):
            term *= M[i][p[i]]
        total += term
    return total


def fixed_basis():
    seen, basis = set(), []
    for e in PAIRS:
        if e in seen:
            continue
        orbit, cur, sg = [], e, 1
        while True:
            orbit.append((cur, sg))
            seen.add(cur)
            i, j = cur
            ni, nj = H_PERM[i], H_PERM[j]
            sg = sg * H_SIGNS[ni] * H_SIGNS[nj]
            cur = (min(ni, nj), max(ni, nj))
            if cur == e:
                break
        if sg != 1:
            continue
        v = [0] * len(PAIRS)
        for ee, s in orbit:
            v[IDX[ee]] = s
        basis.append(v)
    return basis


def conference_tangent_rank(A):
    """Rank of the linearization of A^2 = lambda I in its sixteen variables."""
    rows = []
    for i in range(N):
        for j in range(i, N):
            row = [0] * (len(PAIRS) + 1)
            for c, (a, b) in enumerate(PAIRS):
                v = 0
                for k in range(N):
                    xkj = 1 if (k, j) in ((a, b), (b, a)) else 0
                    xik = 1 if (i, k) in ((a, b), (b, a)) else 0
                    v += A[i][k] * xkj + xik * A[k][j]
                row[c] = v
            if i == j:
                row[len(PAIRS)] = -1
            rows.append(row)
    return rank(rows, len(PAIRS) + 1)


def certificate():
    A = matrix()

    square = [[sum(A[i][k] * A[k][j] for k in range(N)) for j in range(N)] for i in range(N)]
    is_conference = all(square[i][j] == (5 if i == j else 0) for i in range(N) for j in range(N))

    pf = pfaffian_coefficients(A)
    cross_failures = 0
    for S in TRIPLES:
        Sc = tuple(k for k in range(N) if k not in S)
        if pf[TIDX[S]] != perm_sign(list(Sc) + list(S)) * complementary_minor(A, S):
            cross_failures += 1
    ratios = sorted({pf[TIDX[S]] // triangle(A, S) for S in TRIPLES})

    J = jacobian(A)
    vec = [A[i][j] for (i, j) in PAIRS]
    euler_failures = sum(
        1 for r in range(len(TRIPLES))
        if sum(J[r][c] * vec[c] for c in range(len(PAIRS))) != 0
    )

    closed_form_failures = 0
    for r, S in enumerate(TRIPLES):
        for c, e in enumerate(PAIRS):
            inside = e[0] in S and e[1] in S
            crossing = (e[0] in S) != (e[1] in S)
            if not inside and not crossing and J[r][c] != 0:
                closed_form_failures += 1
            if inside:
                k = [x for x in S if x not in e][0]
                if J[r][c] != -4 * A[e[0]][k] * A[e[1]][k]:
                    closed_form_failures += 1

    stab = stabilizer(A)
    order_profile = {}
    for g in stab:
        order_profile[group_order(g)] = order_profile.get(group_order(g), 0) + 1
    signs_all_plus = all(
        perm_sign(list(perm)) == 1 and math.prod(e) == 1 for perm, e in stab
    )
    character = {}
    for g in stab:
        perm, e = g
        t = 0
        for (i, j) in PAIRS:
            ni, nj = perm[i], perm[j]
            if (min(ni, nj), max(ni, nj)) == (i, j):
                t += e[ni] * e[nj]
        character.setdefault(group_order(g), set()).add(t)
    character = {k: sorted(v) for k, v in sorted(character.items())}

    basis = fixed_basis()
    basis_desc = [
        sorted((list(PAIRS[k]), v[k]) for k in range(len(PAIRS)) if v[k])
        for v in basis
    ]
    coords = []
    for v in basis:
        k = next(i for i in range(len(PAIRS)) if v[i])
        coords.append(vec[k] * v[k])

    reduced = {}
    for r, S in enumerate(TRIPLES):
        row = tuple(sum(J[r][c] * v[c] for c in range(len(PAIRS))) for v in basis)
        g = 0
        for x in row:
            g = math.gcd(g, abs(x))
        red = tuple(x // g for x in row) if g else row
        reduced.setdefault(red, []).append("".join(map(str, S)))
    table = sorted(
        ([",".join(sorted(v)), list(k)] for k, v in reduced.items()),
        key=lambda kv: kv[0],
    )
    table_rows = [r[1] for r in table]
    kernel_failures = sum(
        1 for r in table_rows if sum(r[i] * coords[i] for i in range(len(coords))) != 0
    )

    minor_rows = [dict((r[0], r[1]) for r in table)[k] for k in
                  ("012,045,234", "013,145,235", "015,123,345", "024")]
    minor = det_n([row[:4] for row in minor_rows])

    return {
        "schema": "c816-theorem-d-table/1",
        "representative_upper_triangle": [[list(e), v] for e, v in sorted(ENTRIES.items())],
        "representative_is_conference": is_conference,
        "pfaffian_over_triangle_ratios": ratios,
        "pfaffian_versus_complementary_minor_failures": cross_failures,
        "euler_relation_failures": euler_failures,
        "derivative_closed_form_failures": closed_form_failures,
        "stabilizer_order_mod_global_sign": len(stab),
        "stabilizer_element_order_profile": dict(sorted(order_profile.items())),
        "stabilizer_all_signs_and_determinants_plus": signs_all_plus,
        "edge_module_character_by_element_order": character,
        "h_order": group_order((H_PERM, H_SIGNS)),
        "fixed_space_dimension": len(basis),
        "fixed_space_orbit_basis": basis_desc,
        "representative_in_orbit_basis": coords,
        "reduced_table": table,
        "reduced_table_row_count": len(table),
        "reduced_table_kernel_failures": kernel_failures,
        "reduced_table_rank": rank(table_rows, len(basis)),
        "displayed_four_by_four_minor": minor,
        "conference_system_rank": conference_tangent_rank(A),
        "conference_tangent_dimension": len(PAIRS) + 1 - conference_tangent_rank(A),
    }


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
    out = os.path.join(here, "2026-08-20-c816-theorem-d-table.json")
    text = canonical(certificate())

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
