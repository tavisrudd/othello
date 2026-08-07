#!/usr/bin/env python3
"""C834 — structural closure of the row-uniqueness layer of the Paper IV package.

Independent replay of every claim in
``notes/2026-08-07-c834-row-uniqueness-structural-proof.md``.

Model.  ``q = 13``; the conic is ``C : y^2 - xz = 0`` in ``PG(2,13)`` with polar form
``B((x,y,z),(u,v,w)) = (2yv - xw - zu)/2`` and ``Delta(P) = B(P,P) = y^2 - xz``.
A point is *internal* when ``Delta`` is a nonsquare, a line ``[A,B,C]`` is *passant*
when ``B^2 - 4AC`` is a nonsquare.  Two internal points are *joined* when the line
through them is passant.  ``H`` is the family of supports of the weight-twelve words
of ``K = ker_{F2} M``, ``M`` the internal-point/passant incidence matrix.  A triple of
internal points is *admissible* when it is pairwise joined and no member of ``H``
contains all three.

The two rational invariants of the report are

    rho(P,Q)     = 4 B(P,Q)^2 / (Delta(P) Delta(Q))
    pi(P,Q,R)    = -8 B(P,Q) B(P,R) B(Q,R) / (Delta(P) Delta(Q) Delta(R))

Usage
-----
    python3 notes/2026-08-07-c834-admissible-quadruple-gram.py            # write JSON
    python3 notes/2026-08-07-c834-admissible-quadruple-gram.py --check    # verify tracked JSON

Run from the repository root.  No dependencies outside the standard library.
"""

from __future__ import annotations

import hashlib
import json
import os
import sys
from collections import Counter
from itertools import combinations

Q = 13
SQUARES = frozenset(v * v % Q for v in range(1, Q))
NONSQUARES = frozenset(range(1, Q)) - SQUARES
OUTPUT = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                      "2026-08-07-c834-admissible-quadruple-gram.json")

# The two admissible non-collinear invariant classes, as (sorted rho triple, pi).
ADMISSIBLE_CLASSES = ((((10, 10, 10)), 8), (((10, 12, 12)), 7))

# The two rho profiles an admissible non-collinear triple can carry.  Using these in place of
# the finer classes above loses nothing in the quadruple argument, so pi never enters it.
ADMISSIBLE_PROFILES = ((10, 10, 10), (10, 12, 12))


# --------------------------------------------------------------------------
# projective model
# --------------------------------------------------------------------------
def projective_triples() -> list[tuple[int, int, int]]:
    return ([(1, y, z) for y in range(Q) for z in range(Q)]
            + [(0, 1, z) for z in range(Q)]
            + [(0, 0, 1)])


def delta(p: tuple[int, int, int]) -> int:
    return (p[1] * p[1] - p[0] * p[2]) % Q


def polar(p: tuple[int, int, int], r: tuple[int, int, int]) -> int:
    """B(P,R) with B(P,P) = Delta(P)."""
    return (2 * p[1] * r[1] - p[0] * r[2] - p[2] * r[0]) * pow(2, -1, Q) % Q


def internal_points() -> list[tuple[int, int, int]]:
    return [p for p in projective_triples() if delta(p) in NONSQUARES]


def passant_lines() -> list[tuple[int, int, int]]:
    return [l for l in projective_triples()
            if (l[1] * l[1] - 4 * l[0] * l[2]) % Q in NONSQUARES]


def secant_lines() -> list[tuple[int, int, int]]:
    return [l for l in projective_triples()
            if (l[1] * l[1] - 4 * l[0] * l[2]) % Q in SQUARES]


def on(line: tuple[int, int, int], p: tuple[int, int, int]) -> bool:
    return (line[0] * p[0] + line[1] * p[1] + line[2] * p[2]) % Q == 0


def collinear(a, b, c) -> bool:
    return (a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])) % Q == 0


# --------------------------------------------------------------------------
# minimum supports: two independent constructions
# --------------------------------------------------------------------------
def parity_search_supports(pencil, rows, start: int) -> set[frozenset[int]]:
    """All zero-syndrome twelve-sets through ``start``.

    A word of ``K`` meets every passant evenly, so the search branches on a passant
    already carrying exactly one chosen point and never enumerates twelve-subsets.
    """
    found: set[frozenset[int]] = set()
    counts = [0] * len(rows)
    chosen: list[int] = []

    def push(point: int) -> bool:
        for k, line in enumerate(pencil[point]):
            counts[line] += 1
            if counts[line] > 2:
                for line2 in pencil[point][:k + 1]:
                    counts[line2] -= 1
                return False
        chosen.append(point)
        return True

    def pop(point: int) -> None:
        chosen.pop()
        for line in pencil[point]:
            counts[line] -= 1

    def rec() -> None:
        deficient = [l for l in range(len(rows)) if counts[l] == 1]
        if not deficient:
            if len(chosen) == 12:
                found.add(frozenset(chosen))
            return
        if len(chosen) >= 12:
            return
        best: list[int] | None = None
        for line in deficient:
            pool = [p for p in rows[line]
                    if p not in chosen and all(counts[m] < 2 for m in pencil[p])]
            if best is None or len(pool) < len(best):
                best = pool
                if not pool:
                    return
        for point in best:
            if push(point):
                rec()
                pop(point)

    push(start)
    rec()
    return found


def bitangent_supports(points, index) -> set[frozenset[int]]:
    """Toric supports built structurally: ``Gamma = C - nu L^2`` for ``L`` secant.

    ``nu`` is a nonsquare, which makes every off-chord point of ``Gamma`` internal,
    and ``nu * disc(L) - 1`` is a nonsquare, which is ``det(Gamma)`` up to a square
    and says that no tangent of ``Gamma`` is a passant of ``C``.
    """
    out: set[frozenset[int]] = set()
    for line in secant_lines():
        disc = (line[1] * line[1] - 4 * line[0] * line[2]) % Q
        good_nu = [n for n in NONSQUARES if (n * disc - 1) % Q in NONSQUARES]
        assert len(good_nu) == 3, (line, good_nu)
        for nu in good_nu:
            support = set()
            for p in projective_triples():
                value = (line[0] * p[0] + line[1] * p[1] + line[2] * p[2]) % Q
                if (delta(p) - nu * value * value) % Q == 0 and value != 0:
                    support.add(index[p])
            if len(support) == 12:
                out.add(frozenset(support))
    return out


# --------------------------------------------------------------------------
# the pure F13 quadruple argument
# --------------------------------------------------------------------------
GVALUES = tuple(sorted(g for g in range(1, Q) if g * g % Q in (9, 10, 12)))


def gram_det3(a: int, b: int, c: int) -> int:
    """det of [[2,-a,-b],[-a,2,-c],[-b,-c,2]]; a,b,c the three normalized traces."""
    return (8 - 2 * (a * a + b * b + c * c) - 2 * a * b * c) % Q


def gram_det4(g: dict[tuple[int, int], int]) -> int:
    m = [[2 if i == j else -g[(min(i, j), max(i, j))] % Q for j in range(4)]
         for i in range(4)]

    def det(block):
        n = len(block)
        if n == 1:
            return block[0][0] % Q
        total = 0
        for j in range(n):
            minor = [row[:j] + row[j + 1:] for row in block[1:]]
            total += (-1) ** j * block[0][j] * det(minor)
        return total % Q

    return det(m)


def pattern_admissible(a: int, b: int, c: int) -> bool:
    """Necessary condition on a pairwise-joined triple with normalized traces a,b,c.

    Only the multiset of ``rho`` values is used: this is the weaker of the two conditions
    certified below, and it is the one the quadruple argument needs.
    """
    if gram_det3(a, b, c) == 0:
        return True
    return tuple(sorted((a * a % Q, b * b % Q, c * c % Q))) in ADMISSIBLE_PROFILES


def quadruple_search() -> tuple[int, dict[str, int], dict[str, int]]:
    """Exhaust every sign/value pattern of six normalized traces."""
    solutions = 0
    collinear_triples = Counter()
    ranks = Counter()
    for g01 in GVALUES:
        for g02 in GVALUES:
            if not any(pattern_admissible(g01, g02, t) for t in GVALUES):
                continue
            for g12 in GVALUES:
                if not pattern_admissible(g01, g02, g12):
                    continue
                for g03 in GVALUES:
                    for g13 in GVALUES:
                        if not pattern_admissible(g01, g03, g13):
                            continue
                        for g23 in GVALUES:
                            if not pattern_admissible(g02, g03, g23):
                                continue
                            if not pattern_admissible(g12, g13, g23):
                                continue
                            g = {(0, 1): g01, (0, 2): g02, (0, 3): g03,
                                 (1, 2): g12, (1, 3): g13, (2, 3): g23}
                            if gram_det4(g) != 0:
                                continue
                            solutions += 1
                            collinear_triples[sum(
                                1 for t in ((g01, g02, g12), (g01, g03, g13),
                                            (g02, g03, g23), (g12, g13, g23))
                                if gram_det3(*t) == 0)] += 1
                            ranks[matrix_rank([
                                [2 if i == j else -g[(min(i, j), max(i, j))] % Q
                                 for j in range(4)] for i in range(4)])] += 1
    return solutions, dict(collinear_triples), dict(ranks)


def square_roots(value: int) -> list[int]:
    return [t for t in range(Q) if t * t % Q == value % Q]


def trace_patterns(rho_ab: int, rho_ac: int, rho_bc: int, pi: int) -> list[tuple[int, int, int]]:
    """The normalized-trace patterns of a triple with the given invariants."""
    return [(a, b, c)
            for a in square_roots(rho_ab)
            for b in square_roots(rho_ac)
            for c in square_roots(rho_bc)
            if a * b * c % Q == pi % Q]


def bitangent_witness(a: int, b: int, c: int) -> bool:
    """Does this trace pattern name a bitangent conic through the triple that is a support?

    ``D`` is twice the normalized Gram determinant and vanishes exactly on collinear triples;
    ``F`` is the discriminant of the candidate chord, normalized by ``D`` and the first point's
    ``Delta``.  The chord must be a secant, which is ``F * D`` a nonsquare, and the bitangent
    conic must have no passant among its tangents, which is ``(4F - D) * D`` a nonsquare.
    """
    squares = (a * a + b * b + c * c) % Q
    d = (4 - squares - a * b * c) % Q
    if d == 0:
        return False
    f = (3 - squares * pow(4, -1, Q) + a + b + c
         + (a * b + a * c + b * c) * pow(2, -1, Q)) % Q
    return (f * d % Q) in NONSQUARES and ((4 * f - d) * d % Q) in NONSQUARES


def matrix_rank(rows: list[list[int]]) -> int:
    m = [r[:] for r in rows]
    rank = 0
    for col in range(len(m[0])):
        pivot = next((r for r in range(rank, len(m)) if m[r][col] % Q), None)
        if pivot is None:
            continue
        m[rank], m[pivot] = m[pivot], m[rank]
        inverse = pow(m[rank][col], -1, Q)
        m[rank] = [v * inverse % Q for v in m[rank]]
        for r in range(len(m)):
            if r != rank and m[r][col] % Q:
                factor = m[r][col]
                m[r] = [(m[r][k] - factor * m[rank][k]) % Q for k in range(len(m[0]))]
        rank += 1
    return rank


# --------------------------------------------------------------------------
# the certificate
# --------------------------------------------------------------------------
def compute() -> dict:
    points = internal_points()
    passants = passant_lines()
    index = {p: i for i, p in enumerate(points)}
    assert len(points) == 78 and len(passants) == 78

    rows = [[index[p] for p in points if on(l, p)] for l in passants]
    assert all(len(r) == 7 for r in rows)
    pencil = [[] for _ in points]
    for li, row in enumerate(rows):
        for i in row:
            pencil[i].append(li)
    assert all(len(v) == 7 for v in pencil)

    join_line = [[-1] * 78 for _ in range(78)]
    for li, row in enumerate(rows):
        for i, j in combinations(row, 2):
            join_line[i][j] = join_line[j][i] = li
    degrees = {sum(1 for j in range(78) if join_line[i][j] >= 0) for i in range(78)}

    # --- supports, two ways ---
    supports: set[frozenset[int]] = set()
    covered: set[int] = set()
    while len(covered) < 78:
        seed = min(set(range(78)) - covered)
        supports |= parity_search_supports(pencil, rows, seed)
        covered.add(seed)
    supports = {frozenset(s) for s in supports}
    toric = bitangent_supports(points, index)
    assert toric <= supports
    support_list = [set(s) for s in sorted(map(sorted, supports))]

    # every support is a twelve-arc of the plane
    arc_violations = sum(
        1 for s in support_list
        for a, b, c in combinations(sorted(s), 3)
        if collinear(points[a], points[b], points[c]))

    # --- invariants ---
    def rho(i: int, j: int) -> int:
        return (4 * polar(points[i], points[j]) ** 2
                * pow(delta(points[i]) * delta(points[j]), -1, Q)) % Q

    def pi(i: int, j: int, k: int) -> int:
        num = -8 * polar(points[i], points[j]) * polar(points[i], points[k]) \
            * polar(points[j], points[k])
        den = delta(points[i]) * delta(points[j]) * delta(points[k])
        return num * pow(den, -1, Q) % Q

    rho_values = Counter()
    join_by_rho = Counter()
    for i, j in combinations(range(78), 2):
        r = rho(i, j)
        rho_values[r] += 1
        join_by_rho[(r, join_line[i][j] >= 0)] += 1

    # --- triple classification ---
    triple_table = Counter()
    extension_table = Counter()
    concurrence: dict[tuple[int, int, int], int] = {}

    def conc(t: tuple[int, int, int]) -> int:
        key = tuple(sorted(t))
        if key not in concurrence:
            concurrence[key] = sum(1 for s in support_list if key[0] in s
                                   and key[1] in s and key[2] in s)
        return concurrence[key]

    joined_triples = []
    for a, b, c in combinations(range(78), 3):
        if join_line[a][b] < 0 or join_line[a][c] < 0 or join_line[b][c] < 0:
            continue
        joined_triples.append((a, b, c))
        profile = tuple(sorted((rho(a, b), rho(a, c), rho(b, c))))
        p = pi(a, b, c)
        is_collinear = join_line[a][b] == join_line[a][c]
        # invariant identity: collinear  <=>  sum(rho) + pi = 4
        assert is_collinear == ((sum(profile) + p) % Q == 4 % Q), (a, b, c)
        triple_table[(is_collinear, profile, p, conc((a, b, c)))] += 1

    # criterion: admissible  <=>  collinear or (profile, pi) in the two classes; and the
    # weaker profile-only form, which is what the quadruple argument consumes.
    criterion_failures = 0
    profile_criterion_failures = 0
    for a, b, c in joined_triples:
        profile = tuple(sorted((rho(a, b), rho(a, c), rho(b, c))))
        is_collinear = join_line[a][b] == join_line[a][c]
        admissible = conc((a, b, c)) == 0
        if (is_collinear or (profile, pi(a, b, c)) in ADMISSIBLE_CLASSES) != admissible:
            criterion_failures += 1
        if admissible and not (is_collinear or profile in ADMISSIBLE_PROFILES):
            profile_criterion_failures += 1

    # the bitangent-conic witness predicate reproduces the conic-support count exactly
    witness_failures = 0
    witness_by_class: dict[tuple[tuple[int, ...], int], int] = {}
    for a, b, c in joined_triples:
        if join_line[a][b] == join_line[a][c]:
            continue
        profile = tuple(sorted((rho(a, b), rho(a, c), rho(b, c))))
        p = pi(a, b, c)
        patterns = trace_patterns(rho(a, b), rho(a, c), rho(b, c), p)
        assert len(patterns) == 4, (a, b, c)
        predicted = sum(1 for pattern in patterns if bitangent_witness(*pattern))
        actual = sum(1 for s in toric if a in s and b in s and c in s)
        if predicted != actual:
            witness_failures += 1
        witness_by_class[(profile, p)] = predicted

    # --- the ledger's two halves, measured ---
    for a, b, c in joined_triples:
        if conc((a, b, c)):
            continue
        is_collinear = join_line[a][b] == join_line[a][c]
        pool = [d for d in range(78)
                if d not in (a, b, c)
                and join_line[a][d] >= 0 and join_line[b][d] >= 0 and join_line[c][d] >= 0
                and not conc((a, b, d)) and not conc((a, c, d)) and not conc((b, c, d))]
        if is_collinear:
            line = set(rows[join_line[a][b]]) - {a, b, c}
            extension_table[("collinear", len(pool), set(pool) == line)] += 1
        else:
            extension_table[("non-collinear", len(pool), True)] += 1

    solutions, collinear_counts, ranks = quadruple_search()

    return {
        "schema": "c834-admissible-quadruple-gram/1",
        "field": Q,
        "conic": "y^2 - x z",
        "internal_points": len(points),
        "passant_lines": len(passants),
        "internal_points_per_passant": sorted({len(r) for r in rows}),
        "join_graph_degrees": sorted(degrees),
        "minimum_supports": len(support_list),
        "toric_supports_from_bitangent_pencil": len(toric),
        "collinear_triples_inside_supports": arc_violations,
        "rho_value_counts": {str(k): v for k, v in sorted(rho_values.items())},
        "rho_join_counts": {f"{k[0]}/{k[1]}": v for k, v in sorted(join_by_rho.items())},
        "pairwise_joined_triples": len(joined_triples),
        "triple_classes": [
            {"collinear": k[0], "rho_profile": list(k[1]), "pi": k[2],
             "concurrence": k[3], "count": v}
            for k, v in sorted(triple_table.items(), key=lambda kv: (not kv[0][0], kv[0][1], kv[0][2]))
        ],
        "criterion_failures": criterion_failures,
        "profile_criterion_failures": profile_criterion_failures,
        "bitangent_witness_failures": witness_failures,
        "bitangent_witnesses_by_class": {
            f"{list(k[0])}/{k[1]}": v for k, v in sorted(witness_by_class.items())
        },
        "extension_classes": [
            {"kind": k[0], "pool_size": k[1], "pool_is_rest_of_line": k[2], "count": v}
            for k, v in sorted(extension_table.items(), key=str)
        ],
        "quadruple_search": {
            "trace_values": list(GVALUES),
            "patterns_searched": len(GVALUES) ** 6,
            "solutions": solutions,
            "collinear_triples_per_solution": {str(k): v for k, v in sorted(collinear_counts.items())},
            "gram_ranks": {str(k): v for k, v in sorted(ranks.items())},
        },
    }


def canonical(document: dict) -> str:
    return json.dumps(document, indent=2, sort_keys=True) + "\n"


def main() -> None:
    document = compute()
    text = canonical(document)
    if "--check" in sys.argv:
        with open(OUTPUT, encoding="utf-8") as handle:
            tracked = handle.read()
        if tracked != text:
            print("MISMATCH against tracked certificate", file=sys.stderr)
            sys.exit(1)
        print("certificate matches;", "sha256", hashlib.sha256(text.encode()).hexdigest())
        return
    with open(OUTPUT, "w", encoding="utf-8") as handle:
        handle.write(text)
    print("wrote", OUTPUT)
    print("sha256", hashlib.sha256(text.encode()).hexdigest())


if __name__ == "__main__":
    main()
