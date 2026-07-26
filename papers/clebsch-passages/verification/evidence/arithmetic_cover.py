#!/usr/bin/env python3
"""Compact exact certificate for the C652 arithmetic and Mathieu carriers."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import deque
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
UPSTREAM = ROOT / "notes/2026-07-22-c470-golay-hadamard-automorphisms.json"
OUTPUT = HERE / "arithmetic_cover.json"
Q = 11
N = 12


def mat_mul(a, b, q=Q):
    return [[sum(a[i][k] * b[k][j] for k in range(3)) % q
             for j in range(3)] for i in range(3)]


def mat_vec(a, v, q=Q):
    return tuple(sum(a[i][j] * v[j] for j in range(3)) % q
                 for i in range(3))


def det(a, q=Q):
    return (
        a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
        - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
        + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0])
    ) % q


def inverse_matrix(a, q=Q):
    d = det(a, q)
    assert d
    cof = [
        [
            (a[(j + 1) % 3][(i + 1) % 3] * a[(j + 2) % 3][(i + 2) % 3]
             - a[(j + 1) % 3][(i + 2) % 3] * a[(j + 2) % 3][(i + 1) % 3])
            % q
            for j in range(3)
        ]
        for i in range(3)
    ]
    scale = pow(d, -1, q)
    answer = [[scale * cof[i][j] % q for j in range(3)] for i in range(3)]
    assert mat_mul(a, answer, q) == [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    return answer


def projective(v, q=Q):
    pivot = next(x for x in v if x % q)
    scale = pow(pivot, -1, q)
    return tuple(scale * x % q for x in v)


def axes(t):
    return {
        projective(v)
        for v in (
            (0, t, 1), (0, t, -1), (1, 0, t),
            (-1, 0, t), (t, -1, 0), (-t, -1, 0),
        )
    }


def image(matrix, points):
    return {projective(mat_vec(matrix, point)) for point in points}


def compose(left, right):
    return bytes(left[right[i]] for i in range(N))


def inverse_permutation(permutation):
    answer = bytearray(N)
    for old, new in enumerate(permutation):
        answer[new] = old
    return bytes(answer)


def conjugate(element, by):
    return compose(inverse_permutation(by), compose(element, by))


def generated_group(generators):
    generators = tuple(generators)
    identity = bytes(range(N))
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return group


def as_permutations(rows):
    return tuple(bytes(row) for row in rows)


def build_certificate():
    roots = [t for t in range(Q) if (t * t - t - 1) % Q == 0]
    assert roots == [4, 8]
    i4, i8 = axes(4), axes(8)
    arc = {
        projective(v)
        for v in ((1, 10, 0), (1, 9, 1), (1, 4, 7),
                  (1, 8, 5), (0, 1, 4), (1, 1, 7))
    }
    m4 = [[1, 4, 7], [5, 10, 3], [1, 8, 1]]
    m8 = [[4, 5, 5], [9, 10, 7], [4, 7, 10]]
    r = [[1, 0, 0], [0, 0, -1], [0, 1, 0]]
    r = [[x % Q for x in row] for row in r]
    scalar_r = [[3 * x % Q for x in row] for row in r]
    assert image(m4, i4) == arc
    assert image(m8, i8) == arc
    assert det(m4) == 1 and det(m8) == 9
    assert mat_mul(inverse_matrix(m8), m4) == scalar_r
    assert image(r, i4) == i8 and image(r, i8) == i4
    r2 = mat_mul(r, r)
    assert r2 == [[1, 0, 0], [0, 10, 0], [0, 0, 10]]
    assert mat_mul(r2, r2) == [[1, 0, 0], [0, 1, 0], [0, 0, 1]]

    # Reflection formula s_v(x)=x-2<x,v>/<v,v>v.
    def reflection(v):
        norm = sum(x * x for x in v) % Q
        scale = 2 * pow(norm, -1, Q) % Q
        return [[((1 if i == j else 0) - scale * v[i] * v[j]) % Q
                 for j in range(3)] for i in range(3)]

    s_e2 = reflection((0, 1, 0))
    s_e2_minus_e3 = reflection((0, 1, -1))
    assert mat_mul(s_e2, s_e2_minus_e3) == r
    squares = {x * x % Q for x in range(1, Q)}
    assert 2 not in squares

    upstream_bytes = UPSTREAM.read_bytes()
    upstream = json.loads(upstream_bytes)
    coordinate = upstream["coordinate_and_design_groups"]
    parents = upstream["two_M11_parents_and_frozen_intersection"]
    row = upstream["hadamard_row_action"]

    pure_generators = as_permutations(
        coordinate["pure_coordinate_code_group"]["generators_old_to_new_zero_based"]
    )
    puncture_generators = as_permutations(parents["parity_stabilizer_generators"])
    frozen_generators = as_permutations(parents["frozen_generators"])
    pure = generated_group(pure_generators)
    puncture = generated_group(puncture_generators)
    frozen = generated_group(frozen_generators)
    join = generated_group(pure_generators + puncture_generators)
    assert len(pure) == len(puncture) == 7920
    assert pure & puncture == frozen
    assert len(frozen) == 660
    assert len(join) == 95040

    outer_pure = generated_group(
        as_permutations(row["outer_image_pure_M11_generators"])
    )
    outer_puncture = generated_group(
        as_permutations(row["outer_image_puncture_M11_generators"])
    )
    pure_to_puncture = inverse_permutation(
        bytes(row["pure_to_puncture_class_conjugator"])
    )
    puncture_to_pure = inverse_permutation(
        bytes(row["puncture_to_pure_class_conjugator"])
    )
    assert {conjugate(g, pure_to_puncture) for g in outer_pure} == puncture
    assert {conjugate(g, puncture_to_pure) for g in outer_puncture} == pure
    assert row["aligned_automorphism_is_inner"] is False
    assert row["outer_maps_pure_M11_class_to_puncture_M11_class"] is True
    assert row["outer_maps_puncture_M11_class_to_pure_M11_class"] is True

    return {
        "schema": "c652-arithmetic-cover-v1",
        "arithmetic": {
            "golden_polynomial_modulus": Q,
            "roots": roots,
            "comparison": {
                "M4_maps_I4_to_A": True,
                "M8_maps_I8_to_A": True,
                "determinants": [1, 9],
                "M8_inverse_M4_equals_3R": True,
            },
            "exchanger": {
                "R_maps_I4_to_I8": True,
                "R_maps_I8_to_I4": True,
                "order": 4,
                "spinor_representative": 2,
                "spinor_representative_is_nonsquare": True,
            },
        },
        "mathieu": {
            "upstream_certificate": str(UPSTREAM.relative_to(ROOT)),
            "upstream_sha256": hashlib.sha256(upstream_bytes).hexdigest(),
            "parent_orders": [len(pure), len(puncture)],
            "intersection_order": len(frozen),
            "intersection_equals_frozen_PSL2_11_carrier": True,
            "join_order": len(join),
            "hadamard_exchange_maps_parent_classes": ["pure", "puncture"],
            "hadamard_exchange_is_noninner": True,
        },
        "marked_compatibility": {
            "marking": "I4 <-> pure-coordinate M11",
            "forced_partner": "I8 <-> puncture-stabilizer M11",
            "unmarked_equivariant_bijection_count": 2,
            "canonical_unmarked_identification_claimed": False,
        },
        "scope": {
            "certificate_checks": [
                "explicit projective substitutions and matrix identities",
                "reflection factorization and nonsquare class modulo 11",
                "orders, intersection, and join of explicit permutation carriers",
                "explicit Hadamard outer images exchange the two parent classes",
            ],
            "human_proof_checks": [
                "golden fibre and six-arc argument",
                "A4 intersection",
                "SO3/Omega3 identification with PGL2/PSL2",
                "marked C2-torsor lemma",
            ],
        },
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUTPUT.read_text() == rendered
        print("C652 arithmetic-cover certificate: PASS")
    else:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
