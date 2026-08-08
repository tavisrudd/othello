#!/usr/bin/env python3
"""Arc structure of the minimum words of the passant code of PG(2,13).

Independent exact recomputation, in plain Python integer arithmetic modulo 13, of four facts about
the weight-twelve words of the binary code whose parity checks are the passant lines of a conic in
PG(2,13):

1.  each of the four displayed orbit representatives is a codeword whose twelve internal points meet
    every passant line in zero or two points and every secant line in at most two points, so each is
    a twelve-arc of the plane;
2.  the three representatives with dihedral stabilizer each lie on a unique further conic, whose
    fourteen points are those twelve internal points together with two points of the base conic;
    the representative with symmetric stabilizer lies on no conic;
3.  fixing one internal point and choosing one further point on each of the seven passant lines
    through it, the requirement that no three chosen points be collinear leaves 10296 eight-point
    partial supports out of the 6^7 = 279936 unrestricted choices;
4.  optionally (--full-search, several minutes), the number of nodes visited by an exhaustive
    increasing-index search for weight-twelve codewords through the fixed point, using only the
    parity-deficit bound and no collinearity restriction, together with the number of codewords found.

Replay:  python3 notes/2026-08-07-c834-minimum-word-arc-structure.py
         python3 notes/2026-08-07-c834-minimum-word-arc-structure.py --full-search
It writes its results as JSON on standard output.  The four representatives are transcribed from the
Lean sources of the formal companion, where they are the definitions `representativeS4`,
`representativeDihedralA`, `representativeDihedralB` and `representativeDihedralC` of
`PassantCodeQ13.MinimumWords.Base`.

The plane is the projective plane of binary quadratic forms: a point is the coefficient triple
(x, y, z) of the symmetric matrix [[x, y], [y, z]], the base conic is its vanishing determinant
xz - y^2, and a point is internal exactly when that determinant is a nonzero nonsquare, that is
exactly when the quadratic form is irreducible.  A line is given by the same coordinates through the
pairing (l, p) |-> l0 p0 + l1 p1 + l2 p2, and is a passant, tangent or secant according as it carries
none, one or two points of the base conic.  Nothing here is a formal proof; the formal statements are
the Lean theorems named in the accompanying report.
"""

import argparse
import itertools
import json
from collections import Counter

Q = 13
SQUARES = {(a * a) % Q for a in range(1, Q)}


def normalize(triple):
    """Scale a nonzero homogeneous triple by the inverse of its first nonzero coordinate."""
    values = tuple(v % Q for v in triple)
    for value in values:
        if value:
            inverse = pow(value, Q - 2, Q)
            return tuple((c * inverse) % Q for c in values)
    raise ValueError("the zero triple is not a point")


POINTS = sorted({normalize(t) for t in itertools.product(range(Q), repeat=3) if any(t)})


def conic_value(point):
    """The base conic's quadratic form xz - y^2 at a point."""
    x, y, z = point
    return (x * z - y * y) % Q


def incident(line, point):
    return sum(a * b for a, b in zip(line, point)) % Q == 0


CONIC = [p for p in POINTS if conic_value(p) == 0]
INTERNAL = [p for p in POINTS if conic_value(p) and conic_value(p) not in SQUARES]
INDEX = {p: i for i, p in enumerate(INTERNAL)}
CONIC_COUNT = {line: sum(1 for p in CONIC if incident(line, p)) for line in POINTS}
PASSANT = [line for line in POINTS if CONIC_COUNT[line] == 0]
SECANT = [line for line in POINTS if CONIC_COUNT[line] == 2]

PASSANT_POINTS = [[INDEX[p] for p in INTERNAL if incident(line, p)] for line in PASSANT]
SECANT_POINTS = [[INDEX[p] for p in INTERNAL if incident(line, p)] for line in SECANT]

REPRESENTATIVES = {
    "symmetric": [(1, 0, 2), (1, 0, 5), (1, 1, 3), (1, 1, 6), (1, 2, 9), (1, 3, 4),
                  (1, 3, 7), (1, 6, 5), (1, 8, 7), (1, 11, 2), (1, 11, 12), (1, 12, 6)],
    "dihedralA": [(1, 0, 2), (1, 0, 5), (1, 1, 3), (1, 1, 6), (1, 2, 12), (1, 5, 5),
                  (1, 6, 2), (1, 6, 4), (1, 8, 4), (1, 8, 6), (1, 9, 9), (1, 12, 9)],
    "dihedralB": [(1, 0, 2), (1, 3, 2), (1, 4, 5), (1, 1, 8), (1, 4, 8), (1, 1, 7),
                  (1, 7, 12), (1, 3, 3), (1, 9, 11), (1, 10, 11), (1, 0, 5), (1, 8, 7)],
    "dihedralC": [(1, 0, 2), (1, 0, 7), (1, 1, 6), (1, 2, 11), (1, 3, 7), (1, 3, 11),
                  (1, 5, 1), (1, 5, 10), (1, 6, 4), (1, 7, 2), (1, 8, 1), (1, 8, 6)],
}


def conic_through(points):
    """A basis of the space of conics vanishing on the given points, and its rank."""
    monomials = [[x * x % Q, y * y % Q, z * z % Q, 2 * x * y % Q, 2 * x * z % Q, 2 * y * z % Q]
                 for (x, y, z) in points]
    rows = [row[:] for row in monomials]
    pivots, rank = [], 0
    for column in range(6):
        pivot = next((r for r in range(rank, len(rows)) if rows[r][column]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inverse = pow(rows[rank][column], Q - 2, Q)
        rows[rank] = [v * inverse % Q for v in rows[rank]]
        for r in range(len(rows)):
            if r != rank and rows[r][column]:
                factor = rows[r][column]
                rows[r] = [(a - factor * b) % Q for a, b in zip(rows[r], rows[rank])]
        pivots.append(column)
        rank += 1
    kernel = []
    for free in (c for c in range(6) if c not in pivots):
        vector = [0] * 6
        vector[free] = 1
        for r, pivot in enumerate(pivots):
            vector[pivot] = (-rows[r][free]) % Q
        kernel.append(vector)
    return rank, kernel


def describe_representative(coordinates):
    support = {INDEX[normalize(t)] for t in coordinates}
    assert len(support) == 12
    passant_profile = Counter(len(support.intersection(row)) for row in PASSANT_POINTS)
    secant_profile = Counter(len(support.intersection(row)) for row in SECANT_POINTS)
    rank, kernel = conic_through([INTERNAL[i] for i in sorted(support)])
    record = {
        "is_codeword": all(count % 2 == 0 for count in
                           (len(support.intersection(row)) for row in PASSANT_POINTS)),
        "passant_intersection_profile": {str(k): v for k, v in sorted(passant_profile.items())},
        "secant_intersection_profile": {str(k): v for k, v in sorted(secant_profile.items())},
        "conic_system_rank": rank,
    }
    if kernel:
        a, b, c, f, g, h = kernel[0]
        form = lambda p: (a * p[0] ** 2 + b * p[1] ** 2 + c * p[2] ** 2
                          + 2 * f * p[0] * p[1] + 2 * g * p[0] * p[2] + 2 * h * p[1] * p[2]) % Q
        on_conic = [p for p in POINTS if form(p) == 0]
        split = Counter("base conic" if conic_value(p) == 0
                        else ("internal" if p in INDEX else "external") for p in on_conic)
        record["containing_conic_coefficients"] = kernel[0]
        record["containing_conic_point_count"] = len(on_conic)
        record["containing_conic_point_split"] = dict(sorted(split.items()))
    return record


def fibre_search(base=0):
    """Count the arc-restricted choices of one further point on each passant through a point."""
    base_point = INTERNAL[base]
    fibres = [sorted(set(row) - {base})
              for line, row in zip(PASSANT, PASSANT_POINTS) if incident(line, base_point)]
    assert len(fibres) == 7 and all(len(f) == 6 for f in fibres)
    join = {}
    for i, j in itertools.combinations(range(78), 2):
        p, r = INTERNAL[i], INTERNAL[j]
        join[(i, j)] = join[(j, i)] = normalize((p[1] * r[2] - p[2] * r[1],
                                                p[2] * r[0] - p[0] * r[2],
                                                p[0] * r[1] - p[1] * r[0]))
    nodes = [0] * 8
    leaves = 0

    def extend(level, chosen):
        nonlocal leaves
        nodes[level] += 1
        if level == 7:
            leaves += 1
            return
        for candidate in fibres[level]:
            if all(not incident(join[(a, b)], INTERNAL[candidate])
                   for a, b in itertools.combinations(chosen, 2)):
                extend(level + 1, chosen + [candidate])

    extend(0, [base])
    return {"nodes_per_level": nodes, "eight_point_partial_supports": leaves,
            "unrestricted_choices": 6 ** 7}


def full_search(base=0):
    """Exhaustive increasing-index search with only the parity-deficit bound."""
    syndrome = []
    for i in range(78):
        bits = 0
        for k, line in enumerate(PASSANT):
            if incident(line, INTERNAL[i]):
                bits |= 1 << k
        syndrome.append(bits)
    available = [0] * 78
    for i in range(78):
        for k in range(78):
            if (syndrome[i] >> k) & 1:
                available[k] |= 1 << i
    full = (1 << 78) - 1
    nodes = 0
    solutions = 0

    def extend(start, parity, count):
        nonlocal nodes, solutions
        nodes += 1
        if count == 12:
            if parity == 0:
                solutions += 1
            return
        remaining = 12 - count
        if bin(parity).count("1") > 7 * remaining:
            return
        pool = (full >> start) << start
        rest = parity
        while rest:
            line = (rest & -rest).bit_length() - 1
            rest &= rest - 1
            if available[line] & pool == 0:
                return
        for i in range(start, 78 - remaining + 1):
            extend(i + 1, parity ^ syndrome[i], count + 1)

    extend(base + 1, syndrome[base], 1)
    return {"nodes": nodes, "weight_twelve_codewords_through_the_point": solutions}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--full-search", action="store_true",
                        help="also run the exhaustive collinearity-free search (several minutes)")
    arguments = parser.parse_args()
    certificate = {
        "conic_points": len(CONIC),
        "internal_points": len(INTERNAL),
        "passant_lines": len(PASSANT),
        "secant_lines": len(SECANT),
        "internal_points_per_passant": sorted({len(row) for row in PASSANT_POINTS}),
        "internal_points_per_secant": sorted({len(row) for row in SECANT_POINTS}),
        "representatives": {name: describe_representative(coordinates)
                            for name, coordinates in REPRESENTATIVES.items()},
        "arc_restricted_fibre_search": fibre_search(),
    }
    if arguments.full_search:
        certificate["collinearity_free_search"] = full_search()
    print(json.dumps(certificate, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
