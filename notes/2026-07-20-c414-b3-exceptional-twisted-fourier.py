#!/usr/bin/env python3
"""Exact q=7 twisted-Fourier blocks on both B3 common-seam types."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-20-c414-b3-exceptional-twisted-fourier.json"
C341_PATH = ROOT / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"
C406_PATH = ROOT / "2026-07-20-c406-matching-orbit-scout.py"
C406_SHA256 = "be5e860b69a0875dfef29cde0907a6952470d43a497dd1dc40f7e6b60c202332"
HELPER_PATH = ROOT / "2026-07-20-c414-exceptional-twisted-fourier.py"
HELPER_SHA256 = "7ef5dfffb7231c56cd2cd32bb29ba206876e12531596d79a2e38dd94824c4fbe"
SEAM_PATH = ROOT / "2026-07-20-c414-b3-seam-preflight.json"
SEAM_SHA256 = "64cd62069d20a35d320e426f7181c9fa44fef1c6bb201ae930c7d02f8ac63af4"
Q = 7
ORDER = 6
GENERATOR = 3
IDENTITY = ((1, 0, 0), (0, 1, 0), (0, 0, 1))


def load_module(name, path, expected_sha256):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def configure_helper(helper):
    helper.Q = Q
    helper.ORDER = ORDER
    helper.GENERATOR = GENERATOR
    helper.PHI10 = (1, -1, 1)
    helper.DEGREE = 2
    helper.ZERO = (0, 0)
    helper.ONE = (1, 0)
    helper.ROOTS = tuple(
        helper.reduce_poly([0] * exponent + [1]) for exponent in range(ORDER)
    )


def determinant(matrix):
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % Q


def canonical_so3_lift(c341, conic, permutation):
    matrix = c341.frame_map(conic[:4], [conic[permutation[index]] for index in range(4)], Q)
    assert all(
        c341.normalize(c341.mat_vec(matrix, conic[index], Q), Q) == conic[permutation[index]]
        for index in range(Q + 1)
    )
    gram = c341.mat_mul(tuple(zip(*matrix)), matrix, Q)
    multiplier = gram[0][0]
    assert gram == tuple(
        tuple(multiplier * int(i == j) % Q for j in range(3)) for i in range(3)
    )
    scalar = multiplier * pow(determinant(matrix), -1, Q) % Q
    lift = tuple(tuple(scalar * entry % Q for entry in row) for row in matrix)
    assert determinant(lift) == 1
    assert c341.mat_mul(tuple(zip(*lift)), lift, Q) == IDENTITY
    return lift


def permutation_order(c406, permutation):
    identity = tuple(range(Q + 1))
    power = identity
    for order in range(1, 25):
        power = c406.compose(permutation, power)
        if power == identity:
            return order
    raise AssertionError


def matching_fixed_by(c406, group):
    fixed = [
        matching
        for matching in c406.perfect_matchings(tuple(range(Q + 1)))
        if all(c406.matching_image(element, matching) == matching for element in group)
    ]
    assert len(fixed) == 1
    return fixed[0]


def scalar_weight_record(helper, records, killed, actions, even, odd, weight):
    return {
        "weight": weight,
        "twisted_invariant_dimension": len(records),
        "surviving_orbit_sizes": sorted(len(record["orbit"]) for record in records),
        "killed_orbit_sizes": sorted(record["orbit_size"] for record in killed),
        "J_even_dimension": len(even),
        "J_odd_dimension": len(odd),
        "section_basis_sha256": helper.section_hash(records),
        "J_monomial_action": [list(action) for action in actions],
    }


def build():
    c341 = load_module("c341_for_c414_b3_fourier", C341_PATH, C341_SHA256)
    c406 = load_module("c406_for_c414_b3_fourier", C406_PATH, C406_SHA256)
    helper = load_module("c414_t1_helpers_for_b3", HELPER_PATH, HELPER_SHA256)
    configure_helper(helper)
    seam_certificate = json.loads(SEAM_PATH.read_text())
    assert hashlib.sha256(SEAM_PATH.read_bytes()).hexdigest() == SEAM_SHA256
    assert seam_certificate["schema"] == "c414-b3-seam-preflight-v1"

    conic, parameters = c406.C399.conic_parameterization(Q)
    full_group, psl_group = c406.full_pgl(Q, parameters)
    parent = c406.coxeter_group("B3", Q, conic)
    opposite = {c406.conjugate(element, parent) for element in full_group - psl_group}
    assert len(opposite) == 7
    points = helper.projective_points(c341)
    point_index = {point: index for index, point in enumerate(points)}
    log_table = helper.logs()
    identity_permutation = tuple(range(Q + 1))

    seam_records = []
    for other in sorted(opposite, key=lambda group: sorted(group)):
        common_permutations = set(parent) & set(other)
        common_order = len(common_permutations)
        seam_type = "S3" if common_order == 6 else "D8" if common_order == 8 else None
        assert seam_type is not None
        common = {canonical_so3_lift(c341, conic, element) for element in common_permutations}
        assert len(common) == common_order
        assert {
            c341.mat_mul(left, right, Q) for left in common for right in common
        } == common

        swaps = [
            element
            for element in full_group - psl_group
            if c406.conjugate(element, parent) == other
            and c406.conjugate(element, other) == frozenset(parent)
        ]
        involutions = sorted(
            element
            for element in swaps
            if c406.compose(element, element) == identity_permutation
        )
        assert len(involutions) == 4
        assert Counter(permutation_order(c406, element) for element in swaps) == (
            {2: 4, 6: 2} if seam_type == "S3" else {2: 4, 8: 4}
        )

        by_weight = {}
        for weight in (-1, 1, 2, 4):
            records, killed = helper.invariant_sections(
                c341, common, points, point_index, weight, log_table
            )
            helper.verify_invariance(
                c341, common, points, point_index, records, weight, log_table
            )
            parity_dimensions = set()
            chosen = None
            for involution in involutions:
                helper.J = canonical_so3_lift(c341, conic, involution)
                actions = helper.involution_action(
                    c341, points, point_index, records, weight, log_table
                )
                even = helper.parity_basis(actions, 1)
                odd = helper.parity_basis(actions, -1)
                parity_dimensions.add((len(even), len(odd)))
                if involution == involutions[0]:
                    chosen = (actions, even, odd)
            assert len(parity_dimensions) == 1 and chosen is not None
            actions, even, odd = chosen
            by_weight[weight] = {
                "records": records,
                "killed": killed,
                "actions": actions,
                "even": even,
                "odd": odd,
            }

        expected = (
            {-1: (6, 1, 5), 1: (6, 1, 5), 2: (14, 10, 4), 4: (14, 10, 4)}
            if seam_type == "S3"
            else {-1: (3, 0, 3), 1: (3, 0, 3), 2: (13, 9, 4), 4: (13, 9, 4)}
        )
        for weight, dimensions in expected.items():
            data = by_weight[weight]
            assert (len(data["records"]), len(data["even"]), len(data["odd"])) == dimensions

        helper.J = canonical_so3_lift(c341, conic, involutions[0])
        source = by_weight[2]
        target = by_weight[4]
        forward = helper.fourier_matrix(
            c341, points, point_index, source["records"], target["records"], 2, log_table
        )
        reverse = helper.fourier_matrix(
            c341, points, point_index, target["records"], source["records"], 4, log_table
        )
        full_identity = [
            [helper.scale(Q * Q * int(i == j), helper.ONE) for j in range(len(source["records"]))]
            for i in range(len(source["records"]))
        ]
        assert helper.matrix_product(reverse, forward) == full_identity
        forward_odd = helper.restrict_matrix(forward, source["odd"], target["odd"])
        reverse_odd = helper.restrict_matrix(reverse, target["odd"], source["odd"])
        odd_identity = [
            [helper.scale(Q * Q * int(i == j), helper.ONE) for j in range(4)]
            for i in range(4)
        ]
        assert helper.matrix_product(reverse_odd, forward_odd) == odd_identity

        other_matching = matching_fixed_by(c406, other)
        seam_records.append(
            {
                "seam_type": seam_type,
                "common_group_order": common_order,
                "other_matching": [list(edge) for edge in other_matching],
                "pair_exchange_elements": len(swaps),
                "pair_exchange_element_order_counts": dict(
                    sorted(Counter(permutation_order(c406, element) for element in swaps).items())
                ),
                "involutive_pair_exchanges": len(involutions),
                "weight_records": [
                    scalar_weight_record(
                        helper,
                        by_weight[weight]["records"],
                        by_weight[weight]["killed"],
                        by_weight[weight]["actions"],
                        by_weight[weight]["even"],
                        by_weight[weight]["odd"],
                        weight,
                    )
                    for weight in (-1, 1, 2, 4)
                ],
                "factorization_odd_block": {
                    "source_weight": 2,
                    "target_weight": 4,
                    "dimension": 4,
                    "forward": forward_odd,
                    "reverse": reverse_odd,
                    "reverse_times_forward": "49 I_4",
                },
            }
        )

    assert Counter(record["seam_type"] for record in seam_records) == {"S3": 4, "D8": 3}
    return {
        "schema": "c414-b3-exceptional-twisted-fourier-v1",
        "field": Q,
        "multiplicative_generator": GENERATOR,
        "cyclotomic_basis": "1,zeta_6",
        "cyclotomic_polynomial_low_to_high": [1, -1, 1],
        "projective_line_count": len(points),
        "canonical_linearization": "unique determinant-one orthogonal lift PGL2(7) -> SO3(7)",
        "seams": sorted(
            seam_records,
            key=lambda record: (record["common_group_order"], record["other_matching"]),
        ),
        "all_seven_seams_and_all_four_involutive_pair_exchanges_have_factorization_J_odd_dimension_four": True,
        "all_stored_factorization_odd_blocks_have_reverse_composition_49_I": True,
        "verdict": (
            "THEOREM; BOTH THE S3 AND D8 B3 SEAMS HAVE A FOUR-DIMENSIONAL J-ODD "
            "WEIGHT-2/4 SECTOR EXCHANGED INVERTIBLY BY THE EXACT TWISTED FOURIER TRANSFORM"
        ),
        "boundary": (
            "The representation-theoretic portability gate passes for both seam types, but this "
            "does not select a seam, identify quotient and secant-product sections, construct the "
            "oriented depth profile, compare to H3 coordinates, or establish novelty."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = (json.dumps(build(), indent=2, sort_keys=True) + "\n").encode()
    if args.write:
        OUTPUT.write_bytes(payload)
    else:
        assert OUTPUT.read_bytes() == payload
    print("C414 q=7 B3 exceptional twisted Fourier certificate OK")


if __name__ == "__main__":
    main()
