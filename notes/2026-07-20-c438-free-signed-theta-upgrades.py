#!/usr/bin/env python3
"""Exact free upgrades from C438's common 36-point even-theta host."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
STEM = "2026-07-20-c438-free-signed-theta-upgrades"
OUT = ROOT / "notes" / f"{STEM}.json"
PREVIOUS = ROOT / "notes" / "2026-07-20-c438-continuation-mathieu-gate.json"
PREVIOUS_SHA256 = "4f9d6ff70ab80bcf51dfc3aee609f6eff58a9ec2d3541f5b61dac99286f5c8ec"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def inverse_permutation(permutation):
    return tuple(permutation.index(i) for i in range(len(permutation)))


def permutation_order(permutation):
    value = tuple(range(len(permutation)))
    for order in range(1, 1000):
        value = compose(permutation, value)
        if value == tuple(range(len(permutation))):
            return order
    raise AssertionError("order bound")


def projective_linear_group(prime: int, special: bool):
    infinity = prime

    def inv(x):
        return pow(x, -1, prime)

    def canonical(matrix):
        for entry in matrix:
            if entry:
                scale = inv(entry)
                return tuple(scale * x % prime for x in matrix)
        raise ValueError("zero matrix")

    def determinant(matrix):
        a, b, c, d = matrix
        return (a * d - b * c) % prime

    def mobius(matrix, x):
        a, b, c, d = matrix
        if x == infinity:
            return infinity if c == 0 else a * inv(c) % prime
        denominator = (c * x + d) % prime
        return infinity if denominator == 0 else (a * x + b) * inv(denominator) % prime

    squares = {x * x % prime for x in range(1, prime)}
    matrices = set()
    for entries in itertools.product(range(prime), repeat=4):
        det = determinant(entries)
        if det and (not special or det in squares):
            matrices.add(canonical(entries))
    permutations = {tuple(mobius(matrix, x) for x in range(prime + 1)) for matrix in matrices}
    expected = prime * (prime * prime - 1) // (2 if special else 1)
    assert len(permutations) == expected
    return permutations


def theta_points():
    def representative(mask):
        return min(mask, mask ^ 255)

    points = {
        representative(mask)
        for mask in range(256)
        if mask.bit_count() % 2 == 0 and (mask.bit_count() // 2) % 2 == 0
    }
    assert len(points) == 36
    return tuple(sorted(points)), representative


THETA, REPRESENTATIVE = theta_points()


def theta_action(permutation, mask):
    image = 0
    for index in range(8):
        if (mask >> index) & 1:
            image |= 1 << permutation[index]
    return REPRESENTATIVE(image)


def group_orbits(group, points=THETA):
    unseen = set(points)
    answer = []
    while unseen:
        seed = next(iter(unseen))
        orbit = {theta_action(permutation, seed) for permutation in group}
        unseen -= orbit
        answer.append(frozenset(orbit))
    return sorted(answer, key=lambda orbit: (len(orbit), min(orbit)))


def signed_vector(positive, negative):
    return tuple(int(point in positive) - int(point in negative) for point in THETA)


def vector_action(permutation, vector):
    index = {point: i for i, point in enumerate(THETA)}
    answer = [0] * len(THETA)
    for i, point in enumerate(THETA):
        answer[index[theta_action(permutation, point)]] = vector[i]
    return tuple(answer)


def projector_checks(vector, characteristic):
    norm = sum(value * value for value in vector)
    denominator = norm % characteristic
    inverse = pow(denominator, -1, characteristic)
    matrix = tuple(
        tuple((inverse * left * right) % characteristic for right in vector) for left in vector
    )

    def multiply(left, right):
        return tuple(
            tuple(
                sum(left[i][k] * right[k][j] for k in range(len(vector))) % characteristic
                for j in range(len(vector))
            )
            for i in range(len(vector))
        )

    assert multiply(matrix, matrix) == matrix
    assert sum(matrix[i][i] for i in range(len(vector))) % characteristic == 1
    nonzero_rows = [row for row in matrix if any(row)]
    pivot = nonzero_rows[0]
    pivot_index = next(i for i, value in enumerate(pivot) if value)
    for row in nonzero_rows:
        scale = row[pivot_index] * pow(pivot[pivot_index], -1, characteristic) % characteristic
        assert row == tuple(scale * value % characteristic for value in pivot)
    return {
        "integer_norm": norm,
        "denominator_mod_characteristic": denominator,
        "denominator_inverse": inverse,
        "idempotent": True,
        "trace": 1,
        "rank": 1,
    }


def q9_upgrade():
    psl = projective_linear_group(7, special=True)
    pgl = projective_linear_group(7, special=False)
    infinity = 7
    frobenius_group = {g for g in pgl if g[infinity] == infinity}
    parent = {g for g in psl if g[infinity] == infinity}
    assert (len(psl), len(pgl), len(parent), len(frobenius_group)) == (168, 336, 21, 42)
    psl_orbits = group_orbits(psl)
    parent_orbits = group_orbits(parent)
    assert [len(orbit) for orbit in psl_orbits] == [1, 7, 7, 21]
    assert psl_orbits == parent_orbits
    sevens = [orbit for orbit in psl_orbits if len(orbit) == 7]
    vector = signed_vector(sevens[0], sevens[1])
    assert all(vector_action(g, vector) == vector for g in psl)
    outers = frobenius_group - parent
    assert len(outers) == 21
    assert all(vector_action(g, vector) == tuple(-x for x in vector) for g in outers)
    projective = projector_checks(vector, 3)
    return {
        "groups": {"PSL2_7": 168, "parent_7_colon_3": 21, "outer_extension": 42},
        "theta_orbits_PSL2_7": [1, 7, 7, 21],
        "theta_orbits_parent_7_colon_3": [1, 7, 7, 21],
        "signed_support": [7, 7],
        "outer_action_on_signed_vector": -1,
        "projector_over_characteristic_3": projective,
        "homogeneous_counts": {
            "theta_classes": 6048 // 168,
            "aronhold_marks": 6048 // 21,
            "marks_per_theta_class": 168 // 21,
            "distinct_signed_rows_on_288_marks": 6048 // 168,
            "signed_row_multiplicity": 168 // 21,
        },
        "information_boundary": "the signed row descends to the 36 theta classes; the eight Aronhold marks over one class give the same row",
    }, vector


def q11_upgrade():
    a5_six = projective_linear_group(5, special=True)
    s5_six = projective_linear_group(5, special=False)
    a5 = {permutation + (6, 7) for permutation in a5_six}
    s5 = {permutation + (6, 7) for permutation in s5_six}
    assert (len(a5), len(s5)) == (60, 120)
    a5_orbits = group_orbits(a5)
    assert [len(orbit) for orbit in a5_orbits] == [1, 10, 10, 15]
    tens = [orbit for orbit in a5_orbits if len(orbit) == 10]
    vector = signed_vector(tens[0], tens[1])
    assert all(vector_action(g, vector) == vector for g in a5)
    s5_outer = s5 - a5
    assert all(vector_action(g, vector) == tuple(-x for x in vector) for g in s5_outer)

    fixed_pair_swap = tuple(range(6)) + (7, 6)
    assert vector_action(fixed_pair_swap, vector) == tuple(-x for x in vector)
    normalizer = []
    for permutation in itertools.permutations(range(8)):
        inverse = inverse_permutation(permutation)
        conjugate = {compose(compose(permutation, g), inverse) for g in a5}
        if conjugate == a5:
            normalizer.append(permutation)
    centralizer = [
        permutation
        for permutation in normalizer
        if all(compose(permutation, g) == compose(g, permutation) for g in a5)
    ]
    assert len(normalizer) == 240 and len(centralizer) == 2
    orbit_permutations = Counter()
    for permutation in normalizer:
        induced = tuple(
            next(j for j, other in enumerate(a5_orbits) if {theta_action(permutation, x) for x in orbit} == other)
            for orbit in a5_orbits
        )
        orbit_permutations[induced] += 1
    assert sorted(orbit_permutations.values()) == [120, 120]

    # Stabilize infinity in the six-point action.  Its C5 quotient kernel fixes
    # the two edge endpoints; the other D10 coset swaps them.
    infinity = 5
    d10_six = {g for g in a5_six if g[infinity] == infinity}
    assert len(d10_six) == 10
    c5_six = {g for g in d10_six if permutation_order(g) in (1, 5)}
    assert len(c5_six) == 5
    twisted_d10 = {
        g + ((6, 7) if g in c5_six else (7, 6))
        for g in d10_six
    }
    twisted_orbits = group_orbits(twisted_d10)
    assert [len(orbit) for orbit in twisted_orbits] == [1, 5, 5, 5, 10, 10]
    assert all(vector_action(g, vector) == vector for g in twisted_d10 if g[:6] in c5_six)
    assert all(
        vector_action(g, vector) == tuple(-x for x in vector)
        for g in twisted_d10
        if g[:6] not in c5_six
    )
    intersections = [[len(left & right) for right in twisted_orbits] for left in a5_orbits]
    assert intersections == [
        [1, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 5, 5],
        [0, 0, 0, 0, 5, 5],
        [0, 5, 5, 5, 0, 0],
    ]
    projective = projector_checks(vector, 11)
    return {
        "groups": {
            "A5": 60,
            "S5": 120,
            "D10": 10,
            "C5": 5,
            "normalizer_in_S8": len(normalizer),
            "centralizer_in_S8": len(centralizer),
            "normalizer_quotient_over_A5": len(normalizer) // 60,
            "normalizer_quotient_structure": "C2 x C2",
        },
        "theta_orbits_A5": [1, 10, 10, 15],
        "theta_orbits_edge_twisted_D10": [1, 5, 5, 5, 10, 10],
        "A5_by_twisted_D10_intersection_matrix": intersections,
        "signed_support": [10, 10],
        "golden_S5_outer_action_on_signed_vector": -1,
        "edge_endpoint_swap_action_on_signed_vector": -1,
        "product_of_two_outer_involutions_on_signed_vector": 1,
        "normalizer_orbit_permutation_counts": {str(key): value for key, value in sorted(orbit_permutations.items())},
        "projector_over_characteristic_11": projective,
        "homogeneous_counts": {
            "parents": 1320 // 60,
            "unpointed_parent_edges": 1320 // 10,
            "pointed_parent_edges": 1320 // 5,
            "pointed_orientations_per_edge": 2,
            "theta_points_per_local_edge_fibre": 36,
            "total_unpointed_edge_theta_points": (1320 // 10) * 36,
        },
        "descent": {
            "signed_vector_defined_on": "264 pointed parent-edge flags",
            "rank_one_projector_defined_on": "132 unpointed parent-edge flags",
            "deck_involution": "D10/C5 swaps endpoints and negates the signed vector",
            "projector_is_deck_invariant": True,
        },
    }, vector


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    assert digest(PREVIOUS) == PREVIOUS_SHA256
    q9, vector9 = q9_upgrade()
    q11, vector11 = q11_upgrade()
    assert sum(x * x for x in vector9) == 14
    assert sum(x * x for x in vector11) == 20
    result = {
        "schema": "c438-free-signed-theta-upgrades-v1",
        "trusted_input": {"path": str(PREVIOUS.relative_to(ROOT)), "sha256": PREVIOUS_SHA256},
        "common_theta_host": {
            "model": "q=0 classes in even subsets of 8 modulo complementation",
            "size": len(THETA),
            "nonbase_tetrad_classes": len(THETA) - 1,
        },
        "q9": q9,
        "q11": q11,
        "common_transform_law": {
            "signed_vectors": "v_m = indicator(orbit_plus) - indicator(orbit_minus)",
            "projectors": "P_m = v_m v_m^T / (v_m^T v_m)",
            "q9_norm": 14,
            "q11_norm": 20,
            "outer_or_deck_action": "v_m -> -v_m",
            "descended_action": "P_m -> P_m",
            "anti_invariant_dimension_inside_inner_invariants": 1,
            "portable_result": "the common bridge is a rank-one signed local system/projector, not an identification of the full Hecke schemes",
        },
        "information_verdict": {
            "q9": "the sign detects Frobenius orientation but does not distinguish the eight Aronhold marks over a fixed theta class",
            "q11": "the sign distinguishes the two pointed endpoints; forgetting the endpoint retains exactly the rank-one projector",
            "bridge": "both sides retain the same outer-anti line and invariant projector, but parent recovery still requires their existing decorations",
        },
    }
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered
        print(f"checked {OUT.relative_to(ROOT)}")
    else:
        OUT.write_text(rendered)
        print(f"wrote {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
