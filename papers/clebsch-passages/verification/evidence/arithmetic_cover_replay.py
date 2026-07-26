#!/usr/bin/env python3
"""Independent replay of the C652 arithmetic-cover certificate.

This file imports no code from arithmetic_cover.py.  It recomputes the
projective identities and enumerates the four relevant permutation groups
from the frozen C470 carrier data.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
CERTIFICATE = HERE / "arithmetic_cover.json"
UPSTREAM = ROOT / "notes/2026-07-22-c470-golay-hadamard-automorphisms.json"
Q = 11


def canonical(point):
    first = next(value % Q for value in point if value % Q)
    unit = pow(first, -1, Q)
    return tuple(value * unit % Q for value in point)


def apply(matrix, point):
    return canonical([
        sum(row[j] * point[j] for j in range(3)) % Q for row in matrix
    ])


def product(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(3)) % Q for j in range(3)]
        for i in range(3)
    ]


def projective_set(t):
    return {
        canonical(point)
        for point in (
            (0, t, 1), (0, t, -1), (1, 0, t),
            (-1, 0, t), (t, -1, 0), (-t, -1, 0),
        )
    }


def perm_product(a, b):
    return tuple(a[b[index]] for index in range(12))


def perm_inverse(a):
    answer = [0] * 12
    for old, new in enumerate(a):
        answer[new] = old
    return tuple(answer)


def closure(generators):
    generators = tuple(tuple(g) for g in generators)
    identity = tuple(range(12))
    seen = {identity}
    frontier = [identity]
    for element in frontier:
        for generator in generators:
            candidate = perm_product(element, generator)
            if candidate not in seen:
                seen.add(candidate)
                frontier.append(candidate)
    return seen


def conjugated(group, by):
    inverse = perm_inverse(by)
    return {
        perm_product(inverse, perm_product(element, by)) for element in group
    }


def main():
    recorded = json.loads(CERTIFICATE.read_text())
    upstream_bytes = UPSTREAM.read_bytes()
    upstream = json.loads(upstream_bytes)
    assert recorded["mathieu"]["upstream_sha256"] == hashlib.sha256(
        upstream_bytes
    ).hexdigest()

    roots = [value for value in range(Q)
             if (value * value - value - 1) % Q == 0]
    assert roots == recorded["arithmetic"]["roots"] == [4, 8]
    i4, i8 = projective_set(4), projective_set(8)
    arc = {
        canonical(point)
        for point in ((1, 10, 0), (1, 9, 1), (1, 4, 7),
                      (1, 8, 5), (0, 1, 4), (1, 1, 7))
    }
    m4 = ((1, 4, 7), (5, 10, 3), (1, 8, 1))
    m8_inverse = ((2, 2, 2), (9, 1, 8), (5, 4, 8))
    m4_image = {apply(m4, point) for point in i4}
    m8 = ((4, 5, 5), (9, 10, 7), (4, 7, 10))
    m8_image = {apply(m8, point) for point in i8}
    assert m4_image == m8_image == arc
    r = ((1, 0, 0), (0, 0, 10), (0, 1, 0))
    assert {apply(r, point) for point in i4} == i8
    assert {apply(r, point) for point in i8} == i4
    assert product(m8_inverse, m4) == [
        [3 * value % Q for value in row] for row in r
    ]
    assert product(product(r, r), product(r, r)) == [
        [1, 0, 0], [0, 1, 0], [0, 0, 1]
    ]
    assert 2 not in {value * value % Q for value in range(1, Q)}

    coordinate = upstream["coordinate_and_design_groups"]
    parents = upstream["two_M11_parents_and_frozen_intersection"]
    row = upstream["hadamard_row_action"]
    pure_generators = coordinate["pure_coordinate_code_group"][
        "generators_old_to_new_zero_based"
    ]
    puncture_generators = parents["parity_stabilizer_generators"]
    pure = closure(pure_generators)
    puncture = closure(puncture_generators)
    frozen = closure(parents["frozen_generators"])
    joined = closure(pure_generators + puncture_generators)
    assert (len(pure), len(puncture), len(pure & puncture), len(joined)) == (
        7920, 7920, 660, 95040
    )
    assert pure & puncture == frozen

    outer_pure = closure(row["outer_image_pure_M11_generators"])
    outer_puncture = closure(row["outer_image_puncture_M11_generators"])
    # C470 records GAP right-action conjugators; invert them for this
    # old-to-new tuple convention.
    cp = perm_inverse(tuple(row["pure_to_puncture_class_conjugator"]))
    pc = perm_inverse(tuple(row["puncture_to_pure_class_conjugator"]))
    assert conjugated(outer_pure, cp) == puncture
    assert conjugated(outer_puncture, pc) == pure

    assert recorded["marked_compatibility"] == {
        "canonical_unmarked_identification_claimed": False,
        "forced_partner": "I8 <-> puncture-stabilizer M11",
        "marking": "I4 <-> pure-coordinate M11",
        "unmarked_equivariant_bijection_count": 2,
    }
    print("C652 independent arithmetic-cover replay: PASS")


if __name__ == "__main__":
    main()
