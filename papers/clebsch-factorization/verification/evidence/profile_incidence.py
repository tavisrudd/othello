#!/usr/bin/env python3
r"""Derive the six H3 depth profiles from K\G/H orbit marks.

The derivation evaluates one matching representative per double coset.  A final
equivariance check evaluates all 22 matchings only as a replay/falsifier.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
SCOUT_PATH = HERE / "matching_orbit_scout.json"
MATCHING_CERT_PATH = HERE / "matching_module.json"
MATCHING_PATH = HERE / "matching_module.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


MATCHING = load_module("profile_matching", MATCHING_PATH)


def normalize_projective(vector, prime):
    pivot = next(value for value in vector if value % prime)
    scale = pow(pivot, -1, prime)
    return tuple(value * scale % prime for value in vector)


def orbit_partition(group, objects, action):
    index = {value: position for position, value in enumerate(objects)}
    unseen = set(range(len(objects)))
    parts = []
    while unseen:
        representative = min(unseen)
        part = {index[action(element, objects[representative])] for element in group}
        unseen -= part
        parts.append(part)
    return sorted(parts, key=lambda part: (min(part), len(part)))


def matrix_sha256(matrix):
    payload = json.dumps(matrix, separators=(",", ":"), sort_keys=True).encode()
    return hashlib.sha256(payload).hexdigest()


def build_certificate():
    prime = 11
    scout = json.loads(SCOUT_PATH.read_text())
    matching_certificate = json.loads(MATCHING_CERT_PATH.read_text())
    scout_h3 = next(record for record in scout["types"] if record["type"] == "H3")
    matching_h3 = next(record for record in matching_certificate["types"] if record["type"] == "H3")
    frozen_bridge = matching_h3["outer_sheet_sign"]["duality_depth_fourier_bridge"]

    conic, parameters = MATCHING.COXETER.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = MATCHING.full_pgl(prime, parameters)
    parent_group = MATCHING.h3_group(prime, conic)
    base_matching = tuple(tuple(pair) for pair in scout_h3["coxeter_invariant_matching"])
    matchings = sorted({MATCHING.matching_image(element, base_matching) for element in full_group})
    matching_index = {matching: index for index, matching in enumerate(matchings)}
    assert len(full_group) == 1320 and len(psl_group) == 660
    assert len(parent_group) == 60 and len(matchings) == 22

    standard_to_h3 = frozen_bridge["standard_to_h3_projectivity"]
    h3_to_standard = MATCHING.matrix_inverse(standard_to_h3, prime)
    a5_data = MATCHING.DUALITY.load_a5_data()
    plus_group, labels, plus_relations = MATCHING.DUALITY.scheme(a5_data, 8)
    minus_group, minus_labels, minus_relations = MATCHING.DUALITY.scheme(a5_data, 4)
    assert labels == minus_labels
    intersection_group = plus_group & minus_group
    assert len(intersection_group) == 12

    common_relations = MATCHING.DUALITY.orbits(
        a5_data, MATCHING.DUALITY.linear_group(intersection_group), a5_data.all_vectors(prime)
    )
    common_metadata = []
    for relation in common_relations:
        plus_index = next(index for index, target in enumerate(plus_relations) if relation <= target)
        minus_index = next(index for index, target in enumerate(minus_relations) if relation <= target)
        common_metadata.append((plus_index, minus_index, min(relation), relation))
    common_metadata.sort(key=lambda item: item[:3])
    common_relations = [item[3] for item in common_metadata]
    relation_permutation = []
    for relation in common_relations:
        image = {a5_data.mat_vec(MATCHING.DUALITY.J, vector, prime) for vector in relation}
        relation_permutation.append(
            next(index for index, target in enumerate(common_relations) if image == target)
        )
    odd_pairs = [
        (index, image) for index, image in enumerate(relation_permutation) if index < image
    ]
    assert odd_pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]
    projective_relations = [
        sorted(
            {
                a5_data.normalize(vector, prime)
                for vector in relation
                if vector != (0, 0, 0)
            }
        )
        for relation in common_relations
    ]

    conic_index = {point: index for index, point in enumerate(conic)}

    def h3_matrix_point_action(matrix):
        permutation = []
        for h3_point in conic:
            moved_h3 = a5_data.mat_vec(matrix, h3_point, prime)
            permutation.append(conic_index[normalize_projective(moved_h3, prime)])
        return tuple(permutation)

    k_actions = {h3_matrix_point_action(matrix) for matrix in intersection_group}
    assert len(k_actions) == 12 and k_actions <= parent_group
    k_orbits = orbit_partition(k_actions, matchings, MATCHING.matching_image)
    assert sorted(map(len, k_orbits)) == [1, 1, 4, 4, 6, 6]

    plus_sheet = {MATCHING.matching_image(element, base_matching) for element in psl_group}
    minus_sheet = set(matchings) - plus_sheet
    assert len(plus_sheet) == len(minus_sheet) == 11

    j_action = h3_matrix_point_action(MATCHING.DUALITY.J)
    assert all(
        MATCHING.matching_image(j_action, matching) in minus_sheet for matching in plus_sheet
    )

    def secant_line(pair):
        (s_i, t_i), (s_j, t_j) = (endpoints[index] for index in pair)
        return (
            t_i * t_j % prime,
            -(s_i * t_j + t_i * s_j) % prime,
            s_i * s_j % prime,
        )

    def product_zero(matching, h3_point):
        standard_point = MATCHING.matrix_vector(h3_to_standard, h3_point, prime)
        return any(
            sum(a * b for a, b in zip(secant_line(pair), standard_point)) % prime == 0
            for pair in matching
        )

    def depth_record(matching):
        zero_counts = [
            sum(product_zero(matching, point) for point in relation)
            for relation in projective_relations
        ]
        profile = tuple(zero_counts[left] - zero_counts[right] for left, right in odd_pairs)
        return zero_counts, profile

    representatives = []
    profile_by_orbit = {}
    for part in k_orbits:
        representative_index = min(part)
        representative = matchings[representative_index]
        zero_counts, profile = depth_record(representative)
        sheet = 0 if representative in plus_sheet else 1
        stabilizer = {
            action
            for action in k_actions
            if MATCHING.matching_image(action, representative) == representative
        }
        stabilizer_orders = sorted({MATCHING.permutation_order(element) for element in stabilizer})
        profile_by_orbit[frozenset(part)] = profile
        representatives.append(
            {
                "matching_indices": sorted(part),
                "representative_index": representative_index,
                "representative_matching": [list(pair) for pair in representative],
                "sheet": sheet,
                "orbit_size": len(part),
                "stabilizer_order": len(stabilizer),
                "stabilizer_element_orders": stabilizer_orders,
                "double_coset_size": len(part) * len(parent_group),
                "relation_zero_counts": zero_counts,
                "depth_profile": list(profile),
            }
        )

    # This is the full replay/falsifier, deliberately separated from the six-representative proof.
    full_profiles = [depth_record(matching)[1] for matching in matchings]
    for part in k_orbits:
        assert len({full_profiles[index] for index in part}) == 1
    assert len(set(full_profiles)) == 6
    assert all(
        full_profiles[matching_index[MATCHING.matching_image(j_action, matching)]]
        == tuple(-value for value in full_profiles[index])
        for index, matching in enumerate(matchings)
    )

    plus_parts = [part for part in k_orbits if matchings[min(part)] in plus_sheet]
    plus_parts.sort(key=lambda part: len(part))
    assert [len(part) for part in plus_parts] == [1, 4, 6]
    positive_profiles = [profile_by_orbit[frozenset(part)] for part in plus_parts]
    weights = [1, 4, 6]
    weighted_linear_sum = [
        sum(weight * profile[column] for weight, profile in zip(weights, positive_profiles))
        for column in range(4)
    ]
    assert weighted_linear_sum == [0, 0, 0, 0]
    plane_equations = MATCHING.nullspace([list(profile) for profile in positive_profiles], prime)
    assert plane_equations == [[2, 2, 1, 0], [9, 8, 0, 1]]

    pushed_moments = []
    for degree in (1, 2, 3):
        moment = [0] * len(MATCHING.symmetric_power([0] * 4, degree, prime))
        for weight, profile in zip(weights, positive_profiles):
            positive_power = MATCHING.symmetric_power([value % prime for value in profile], degree, prime)
            negative_power = MATCHING.symmetric_power([(-value) % prime for value in profile], degree, prime)
            moment = [
                (old + weight * (positive - negative)) % prime
                for old, positive, negative in zip(moment, positive_power, negative_power)
            ]
        pushed_moments.append(
            {
                "degree": degree,
                "nonzero": any(moment),
                "coordinates": moment,
                "sha256": matrix_sha256(moment),
            }
        )
    assert [record["nonzero"] for record in pushed_moments] == [False, False, True]
    cubic_first_coordinate_witness = (
        2 * sum(weight * profile[0] ** 3 for weight, profile in zip(weights, positive_profiles))
    ) % prime
    assert cubic_first_coordinate_witness == pushed_moments[2]["coordinates"][0] != 0

    def fixed_points(action, sheet):
        return sum(MATCHING.matching_image(action, matching) == matching for matching in sheet)

    marks = {}
    for action in k_actions:
        order = MATCHING.permutation_order(action)
        marks.setdefault(order, set()).add(fixed_points(action, plus_sheet))
    assert marks == {1: {11}, 2: {3}, 3: {2}}

    h_orbits = orbit_partition(parent_group, matchings, MATCHING.matching_image)
    h_profile_counts = [len({full_profiles[index] for index in part}) for part in h_orbits]
    assert any(count > 1 for count in h_profile_counts)

    certificate = {
        "schema": "profile-double-coset-hecke-v1",
        "field": 11,
        "groups": {
            "G": {"name": "PGL2(11)", "order": len(full_group)},
            "G_plus": {"name": "PSL2(11)", "order": len(psl_group)},
            "H": {"name": "A5", "order": len(parent_group)},
            "K": {"name": "A4", "order": len(k_actions)},
        },
        "double_cosets": {
            "space": "K\\G/H",
            "count": len(k_orbits),
            "orbit_sizes": sorted(map(len, k_orbits)),
            "representatives": representatives,
            "plus_sheet_permutation_character_on_K_orders_1_2_3": [11, 3, 2],
            "mark_decomposition": [
                {"K_set": "K/K", "multiplicity": 1, "marks_on_orders_1_2_3": [1, 1, 1]},
                {"K_set": "K/C3", "multiplicity": 1, "marks_on_orders_1_2_3": [4, 0, 1]},
                {"K_set": "K/C2", "multiplicity": 1, "marks_on_orders_1_2_3": [6, 2, 0]},
            ],
            "j_pairs_the_three_orbits": True,
        },
        "depth_map": {
            "derivation_matching_evaluations": 6,
            "full_replay_matching_evaluations": 22,
            "positive_profiles_in_weight_order": [list(profile) for profile in positive_profiles],
            "weights": weights,
            "weighted_linear_relation_over_integers": weighted_linear_sum,
            "profile_plane_equations_mod_11": plane_equations,
            "linear_rank_mod_11": MATCHING.rank(
                [list(profile) for profile in positive_profiles], prime
            ),
            "separates_all_six_double_cosets": len(set(full_profiles)) == 6,
            "bi_hecke_module_dimension": len(k_orbits),
            "linear_kernel_dimension": len(k_orbits)
            - MATCHING.rank([list(profile) for profile in full_profiles], prime),
            "is_H_biinvariant_or_zonal_spherical": False,
            "H_orbit_sizes": sorted(map(len, h_orbits)),
            "distinct_profile_counts_on_H_orbits": h_profile_counts,
            "is_K_H_biinvariant_matrix_coefficient_data": True,
        },
        "compressed_trade": {
            "j_negates_profiles": True,
            "moments": pushed_moments,
            "cubic_first_coordinate_witness_mod_11": cubic_first_coordinate_witness,
            "conceptual_reason": {
                "degree_1": "twice the 1,4,6 weighted barycentre, which is zero",
                "degree_2": "opposite profiles cancel in every even signed moment",
                "degree_3": "twice the weighted odd cube; its first coordinate is nonzero",
            },
        },
        "inputs": {
            SCOUT_PATH.name: hashlib.sha256(SCOUT_PATH.read_bytes()).hexdigest(),
            MATCHING_CERT_PATH.name: hashlib.sha256(MATCHING_CERT_PATH.read_bytes()).hexdigest(),
            MATCHING_PATH.name: hashlib.sha256(MATCHING_PATH.read_bytes()).hexdigest(),
            MATCHING.DUALITY_PATH.name: hashlib.sha256(MATCHING.DUALITY_PATH.read_bytes()).hexdigest(),
            MATCHING.DUALITY_CERT_PATH.name: hashlib.sha256(MATCHING.DUALITY_CERT_PATH.read_bytes()).hexdigest(),
        },
        "verdict": "CONCEPTUAL DOUBLE-COSET DERIVATION; MIXED BI-HECKE RANK-TWO DEPTH MAP; CUBIC-FIRST PUSHFORWARD",
    }
    return certificate


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    content = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(content)
        print(f"wrote {OUTPUT.name} ({len(content)} bytes)")
        return
    assert OUTPUT.read_bytes() == content, f"stale certificate: run {Path(__file__).name} --write"
    print("profile-incidence certificate OK")


if __name__ == "__main__":
    main()
