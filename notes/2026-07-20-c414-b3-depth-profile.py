#!/usr/bin/env python3
"""C414: exact B3 seam sections and oriented zero-depth profiles."""

from __future__ import annotations

import argparse
import functools
import hashlib
import importlib.util
import itertools
import json
import sys
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
C341_PATH = HERE / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
C406_SHA256 = "a1fef3680a7d12d64a1c483e7032cbaa3a1f575883b2bd8b964d58aa8ac38d51"
SEAM_PATH = HERE / "2026-07-20-c414-b3-seam-preflight.json"
SEAM_SHA256 = "64cd62069d20a35d320e426f7181c9fa44fef1c6bb201ae930c7d02f8ac63af4"
C411_PATH = HERE / "2026-07-20-c411-double-coset-hecke.json"
C411_SHA256 = "23f0a100356f0a369f00d81011e8d8d6b9d867b9de45a7b0625fc2889323b014"


def load_module(name: str, path: Path, expected_sha256: str):
    assert hashlib.sha256(path.read_bytes()).hexdigest() == expected_sha256
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def sha256(value: object) -> str:
    return hashlib.sha256(
        json.dumps(value, separators=(",", ":"), sort_keys=True).encode()
    ).hexdigest()


def determinant(matrix, prime: int) -> int:
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % prime


def canonical_so3_lift(c341, conic, permutation, prime: int):
    identity = tuple(tuple(int(i == j) for j in range(3)) for i in range(3))
    matrix = c341.frame_map(
        conic[:4], [conic[permutation[index]] for index in range(4)], prime
    )
    gram = c341.mat_mul(tuple(zip(*matrix)), matrix, prime)
    multiplier = gram[0][0]
    assert gram == tuple(
        tuple(multiplier * int(i == j) % prime for j in range(3)) for i in range(3)
    )
    scalar = multiplier * pow(determinant(matrix, prime), -1, prime) % prime
    lift = tuple(tuple(scalar * entry % prime for entry in row) for row in matrix)
    assert determinant(lift, prime) == 1
    assert c341.mat_mul(tuple(zip(*lift)), lift, prime) == identity
    return lift


def conjugate(c406, element, group):
    inverse = c406.inverse(element)
    return frozenset(c406.compose(c406.compose(element, member), inverse) for member in group)


def perfect_matchings(vertices):
    if not vertices:
        return [()]
    first = vertices[0]
    result = []
    for index in range(1, len(vertices)):
        second = vertices[index]
        remainder = vertices[1:index] + vertices[index + 1 :]
        for tail in perfect_matchings(remainder):
            result.append(tuple(sorted(((first, second),) + tail)))
    return result


def fixed_matching(c406, group, size: int):
    fixed = [
        matching
        for matching in perfect_matchings(tuple(range(size)))
        if all(c406.matching_image(element, matching) == matching for element in group)
    ]
    assert len(fixed) == 1
    return fixed[0]


def projective_points(c341, prime: int):
    return sorted(
        {
            c341.normalize(vector, prime)
            for vector in itertools.product(range(prime), repeat=3)
            if vector != (0, 0, 0)
        }
    )


def orbit_partition(group, objects, action):
    index = {value: position for position, value in enumerate(objects)}
    unseen = set(range(len(objects)))
    parts = []
    while unseen:
        seed = min(unseen)
        part = {index[action(element, objects[seed])] for element in group}
        unseen -= part
        parts.append(part)
    return sorted(parts, key=lambda part: (len(part), min(part)))


def polynomial_vector(c406, polynomial, degree: int):
    return [polynomial.get(exponent, 0) for exponent in c406.homogeneous_basis(degree)]


def subtract_polynomials(left, right, prime: int):
    exponents = set(left) | set(right)
    return {
        exponent: value
        for exponent in exponents
        for value in [(left.get(exponent, 0) - right.get(exponent, 0)) % prime]
        if value
    }


def secant_lines(endpoints, matching, prime: int):
    result = []
    for left, right in matching:
        (s_i, t_i), (s_j, t_j) = endpoints[left], endpoints[right]
        result.append(
            (
                t_i * t_j % prime,
                -(s_i * t_j + t_i * s_j) % prime,
                s_i * s_j % prime,
            )
        )
    return result


def zero_on_product(lines, point, prime: int) -> bool:
    return any(sum(a * b for a, b in zip(line, point)) % prime == 0 for line in lines)


def symmetric_power(vector, degree: int, prime: int):
    return [
        functools.reduce(lambda value, index: value * vector[index] % prime, indices, 1)
        for indices in itertools.combinations_with_replacement(range(len(vector)), degree)
    ]


def canonical_profile_signature(pair_sizes, weights, profiles):
    """Canonicalize coordinate order/orientation and equal-weight orbit labels."""
    dimension = len(pair_sizes)
    candidates = []
    for permutation in itertools.permutations(range(dimension)):
        permuted_sizes = tuple(pair_sizes[index] for index in permutation)
        for signs in itertools.product((-1, 1), repeat=dimension):
            rows = sorted(
                (
                    weight,
                    tuple(
                        signs[column] * profile[permutation[column]]
                        for column in range(dimension)
                    ),
                )
                for weight, profile in zip(weights, profiles)
            )
            candidates.append((permuted_sizes, tuple(rows)))
    return min(candidates)


def a3_control(c406):
    prime = 5
    conic, parameters = c406.C399.conic_parameterization(prime)
    full_group, psl_group = c406.full_pgl(prime, parameters)
    parent = c406.coxeter_group("A3", prime, conic)
    matching = fixed_matching(c406, parent, prime + 1)
    full_orbit = {c406.matching_image(element, matching) for element in full_group}
    psl_orbit = {c406.matching_image(element, matching) for element in psl_group}
    assert len(parent) == 24 and not parent <= psl_group
    assert full_orbit == psl_orbit and len(full_orbit) == 5
    return {
        "field": prime,
        "parent": "S4",
        "parent_order": len(parent),
        "parent_contained_in_psl": False,
        "full_parent_orbit_size": len(full_orbit),
        "psl_parent_orbit_size": len(psl_orbit),
        "has_external_sheet_orientation": False,
        "reason": "the S4 parent meets the outer determinant coset, so PSL2(5) stays transitive",
    }


def build_seam(c341, c406, conic, endpoints, full_group, psl_group, parent, other):
    prime = 7
    identity = tuple(range(prime + 1))
    standard_conic = [
        (left * left % prime, left * right % prime, right * right % prime)
        for left, right in endpoints
    ]
    standard_to_coxeter = c341.frame_map(standard_conic[:4], conic[:4], prime)
    assert all(
        c341.normalize(c341.mat_vec(standard_to_coxeter, point, prime), prime) == target
        for point, target in zip(standard_conic, conic)
    )
    coxeter_to_standard = c406.matrix_inverse(standard_to_coxeter, prime)
    common_permutations = set(parent) & set(other)
    seam_type = {6: "S3", 8: "D8"}[len(common_permutations)]
    swaps = sorted(
        element
        for element in full_group - psl_group
        if conjugate(c406, element, parent) == other
        and conjugate(c406, element, other) == frozenset(parent)
        and c406.compose(element, element) == identity
    )
    assert len(swaps) == 4

    base_matching = fixed_matching(c406, parent, prime + 1)
    other_matching = fixed_matching(c406, other, prime + 1)
    matchings = sorted({c406.matching_image(element, base_matching) for element in full_group})
    matching_index = {matching: index for index, matching in enumerate(matchings)}
    plus_sheet = {c406.matching_image(element, base_matching) for element in psl_group}
    minus_sheet = set(matchings) - plus_sheet
    assert len(matchings) == 14 and len(plus_sheet) == len(minus_sheet) == 7

    points = projective_points(c341, prime)
    point_index = {point: index for index, point in enumerate(points)}
    products = {
        matching: c406.matching_product(matching, endpoints, prime) for matching in matchings
    }
    product_vectors = [polynomial_vector(c406, products[matching], 4) for matching in matchings]
    quotient_vectors = []
    for matching in matchings:
        difference = subtract_polynomials(products[matching], products[base_matching], prime)
        quotient_vectors.append(c406.quotient_by_conic(difference, 2, prime))

    exchange_records = []
    for exchange in swaps:
        common = {
            canonical_so3_lift(c341, conic, element, prime)
            for element in common_permutations
        }
        exchange_lift = canonical_so3_lift(c341, conic, exchange, prime)

        def point_action(matrix, point):
            return c341.normalize(c341.mat_vec(matrix, point, prime), prime)

        point_orbits = orbit_partition(common, points, point_action)
        point_orbit_index = {
            point_index[points[position]]: orbit_index
            for orbit_index, part in enumerate(point_orbits)
            for position in part
        }
        orbit_permutation = []
        for part in point_orbits:
            representative = points[min(part)]
            image = point_action(exchange_lift, representative)
            orbit_permutation.append(point_orbit_index[point_index[image]])
        assert all(orbit_permutation[orbit_permutation[index]] == index for index in range(len(point_orbits)))
        odd_pairs = [
            (index, image)
            for index, image in enumerate(orbit_permutation)
            if index < image
        ]
        fixed_orbits = [
            index for index, image in enumerate(orbit_permutation) if index == image
        ]

        def depth_profile(matching):
            lines = secant_lines(endpoints, matching, prime)
            zero_counts = [
                sum(
                    zero_on_product(
                        lines,
                        c406.matrix_vector(coxeter_to_standard, points[position], prime),
                        prime,
                    )
                    for position in part
                )
                for part in point_orbits
            ]
            profile = tuple(zero_counts[left] - zero_counts[right] for left, right in odd_pairs)
            return zero_counts, profile

        matching_orbits = orbit_partition(
            common_permutations, matchings, c406.matching_image
        )
        profiles = [depth_profile(matching)[1] for matching in matchings]
        assert all(len({profiles[index] for index in part}) == 1 for part in matching_orbits)
        exchange_matching_action = tuple(
            matching_index[c406.matching_image(exchange, matching)] for matching in matchings
        )
        assert all(
            profiles[exchange_matching_action[index]] == tuple(-value for value in profile)
            for index, profile in enumerate(profiles)
        )

        plus_parts = [part for part in matching_orbits if matchings[min(part)] in plus_sheet]
        minus_parts = [part for part in matching_orbits if matchings[min(part)] in minus_sheet]
        plus_parts.sort(key=lambda part: (len(part), min(part)))
        minus_parts.sort(key=lambda part: (len(part), min(part)))
        positive_profiles = [profiles[min(part)] for part in plus_parts]
        weights = [len(part) for part in plus_parts]
        weighted_barycentre = [
            sum(weight * profile[column] for weight, profile in zip(weights, positive_profiles))
            for column in range(len(odd_pairs))
        ]
        plane_equations = c406.nullspace(
            [[value % prime for value in profile] for profile in positive_profiles], prime
        )

        moments = []
        for degree in (1, 2, 3):
            coordinate_count = len(symmetric_power(positive_profiles[0], degree, prime))
            moment = [0] * coordinate_count
            for weight, profile in zip(weights, positive_profiles):
                positive = symmetric_power(tuple(value % prime for value in profile), degree, prime)
                negative = symmetric_power(tuple((-value) % prime for value in profile), degree, prime)
                moment = [
                    (old + weight * (left - right)) % prime
                    for old, left, right in zip(moment, positive, negative)
                ]
            moments.append(
                {
                    "degree": degree,
                    "nonzero": any(moment),
                    "coordinate_count": len(moment),
                    "sha256": sha256(moment),
                }
            )

        odd_product_vectors = []
        odd_quotient_vectors = []
        for matching in sorted(plus_sheet):
            mate = c406.matching_image(exchange, matching)
            odd_product = subtract_polynomials(products[matching], products[mate], prime)
            odd_product_vectors.append(polynomial_vector(c406, odd_product, 4))
            odd_quotient_vectors.append(c406.quotient_by_conic(odd_product, 2, prime))

        profile_rank = c406.rank(
            [[value % prime for value in profile] for profile in profiles], prime
        )
        odd_product_rank = c406.rank(odd_product_vectors, prime)
        odd_quotient_rank = c406.rank(odd_quotient_vectors, prime)
        assert len(odd_pairs) == 4
        assert len(matching_orbits) == 6 and len(plus_parts) == len(minus_parts) == 3
        assert len(set(profiles)) == 6 and profile_rank == 2
        assert weighted_barycentre == [0, 0, 0, 0]
        assert [record["nonzero"] for record in moments] == [False, False, True]
        assert odd_product_rank == odd_quotient_rank == 4
        pair_sizes = [len(point_orbits[left]) for left, _right in odd_pairs]
        canonical_signature = canonical_profile_signature(
            pair_sizes, weights, positive_profiles
        )

        representative_records = []
        for part in matching_orbits:
            representative_index = min(part)
            zero_counts, profile = depth_profile(matchings[representative_index])
            representative_records.append(
                {
                    "matching_indices": sorted(part),
                    "orbit_size": len(part),
                    "sheet": "plus" if matchings[representative_index] in plus_sheet else "minus",
                    "zero_counts": zero_counts,
                    "depth_profile": list(profile),
                }
            )

        exchange_records.append(
            {
                "exchange_permutation": list(exchange),
                "point_orbit_sizes": [len(part) for part in point_orbits],
                "J_fixed_point_orbit_sizes": [len(point_orbits[index]) for index in fixed_orbits],
                "J_odd_point_orbit_pairs": [
                    [len(point_orbits[left]), len(point_orbits[right])] for left, right in odd_pairs
                ],
                "odd_profile_coordinate_count": len(odd_pairs),
                "matching_double_coset_orbit_sizes": [len(part) for part in matching_orbits],
                "plus_orbit_sizes": weights,
                "minus_orbit_sizes": [len(part) for part in minus_parts],
                "representatives": representative_records,
                "distinct_profile_count": len(set(profiles)),
                "profile_linear_rank_mod_7": c406.rank(
                    [[value % prime for value in profile] for profile in profiles], prime
                ),
                "weighted_positive_barycentre_over_integers": weighted_barycentre,
                "positive_profile_plane_equations_mod_7": plane_equations,
                "canonical_weighted_profile_signature": canonical_signature,
                "canonical_weighted_profile_signature_sha256": sha256(canonical_signature),
                "signed_profile_moments_mod_7": moments,
                "odd_product_section_rank_mod_7": odd_product_rank,
                "odd_product_section_matrix_sha256": sha256(odd_product_vectors),
                "odd_quotient_section_rank_mod_7": odd_quotient_rank,
                "odd_quotient_section_matrix_sha256": sha256(odd_quotient_vectors),
                "odd_product_sections_are_Q_multiples": True,
                "profile_sha256": sha256(profiles),
            }
        )

    invariant_summaries = {
        json.dumps(
            {
                key: record[key]
                for key in (
                    "point_orbit_sizes",
                    "J_fixed_point_orbit_sizes",
                    "J_odd_point_orbit_pairs",
                    "matching_double_coset_orbit_sizes",
                    "plus_orbit_sizes",
                    "minus_orbit_sizes",
                    "distinct_profile_count",
                    "profile_linear_rank_mod_7",
                    "weighted_positive_barycentre_over_integers",
                    "positive_profile_plane_equations_mod_7",
                    "canonical_weighted_profile_signature_sha256",
                    "signed_profile_moments_mod_7",
                    "odd_product_section_rank_mod_7",
                    "odd_quotient_section_rank_mod_7",
                )
            },
            sort_keys=True,
        )
        for record in exchange_records
    }
    profile_classes = {record["profile_sha256"] for record in exchange_records}
    assert len(invariant_summaries) == len(profile_classes) == 1
    return {
        "seam_type": seam_type,
        "common_group_order": len(common_permutations),
        "shared_matching_edges": len(set(base_matching) & set(other_matching)),
        "pair_exchange_count": len(exchange_records),
        "pair_exchange_invariant_summary_count": len(invariant_summaries),
        "pair_exchange_profile_class_count": len(profile_classes),
        "derivation_matching_evaluations": 6,
        "full_replay_matching_evaluations_per_exchange": 14,
        "full_product_section_rank_mod_7": c406.rank(product_vectors, prime),
        "relative_quotient_section_rank_mod_7": c406.rank(quotient_vectors, prime),
        "exchange_records": exchange_records,
    }


def build():
    c341 = load_module("c341_for_c414_depth", C341_PATH, C341_SHA256)
    c406 = load_module("c406_for_c414_depth", C406_PATH, C406_SHA256)
    seam_certificate = json.loads(SEAM_PATH.read_text())
    assert hashlib.sha256(SEAM_PATH.read_bytes()).hexdigest() == SEAM_SHA256
    assert seam_certificate["schema"] == "c414-b3-seam-preflight-v1"
    c411_certificate = json.loads(C411_PATH.read_text())
    assert hashlib.sha256(C411_PATH.read_bytes()).hexdigest() == C411_SHA256
    assert c411_certificate["schema"] == "c411-double-coset-hecke-v1"

    prime = 7
    conic, endpoints = c406.C399.conic_parameterization(prime)
    full_group, psl_group = c406.full_pgl(prime, endpoints)
    parent = c406.coxeter_group("B3", prime, conic)
    base_matching = fixed_matching(c406, parent, prime + 1)
    opposite = sorted(
        {conjugate(c406, element, parent) for element in full_group - psl_group},
        key=lambda group: sorted(group),
    )
    assert len(opposite) == 7
    records = [
        build_seam(c341, c406, conic, endpoints, full_group, psl_group, parent, other)
        for other in opposite
    ]
    assert Counter(record["seam_type"] for record in records) == {"S3": 4, "D8": 3}
    summaries_by_type = {}
    for seam_type in ("S3", "D8"):
        signatures = {
            record["exchange_records"][0]["canonical_weighted_profile_signature_sha256"]
            for record in records
            if record["seam_type"] == seam_type
        }
        assert len(signatures) == 1
        summaries_by_type[seam_type] = {
            "geometric_conjugacy_class_count": len(signatures),
            "canonical_weighted_profile_signature_sha256": next(iter(signatures)),
        }

    h3_depth = c411_certificate["depth_map"]
    h3_moments = c411_certificate["compressed_trade"]["moments"]
    assert h3_depth["weights"] == [1, 4, 6]
    assert h3_depth["linear_rank_mod_11"] == 2
    assert len(h3_depth["positive_profiles_in_weight_order"][0]) == 4
    assert [record["nonzero"] for record in h3_moments] == [False, False, True]

    return {
        "schema": "c414-b3-depth-profile-v1",
        "field": prime,
        "factorization_degrees": {"quotient": 2, "secant_product": 4},
        "base_parent": "S4",
        "base_matching": [list(edge) for edge in base_matching],
        "seam_type_counts": dict(sorted(Counter(record["seam_type"] for record in records).items())),
        "geometric_profile_class_by_seam_type": summaries_by_type,
        "seams": records,
        "a3_nonsplitting_control": a3_control(c406),
        "uniform_b3_h3_law": {
            "B3_S3": {
                "field": 7,
                "common_seam": "S3",
                "sheet_orbit_weights": [1, 3, 3],
                "odd_depth_coordinates": 4,
                "depth_rank": 2,
                "first_nonzero_signed_moment_degree": 3,
            },
            "B3_D8": {
                "field": 7,
                "common_seam": "D8",
                "sheet_orbit_weights": [1, 2, 4],
                "odd_depth_coordinates": 4,
                "depth_rank": 2,
                "first_nonzero_signed_moment_degree": 3,
            },
            "H3_A4": {
                "field": 11,
                "common_seam": "A4",
                "sheet_orbit_weights": [1, 4, 6],
                "odd_depth_coordinates": 4,
                "depth_rank": 2,
                "first_nonzero_signed_moment_degree": 3,
            },
            "conceptual_formula": (
                "each common seam has three matching orbits per determinant sheet; J pairs "
                "their four oriented line-orbit coordinates, the weighted sheet barycentre "
                "vanishes, all even signed moments cancel, and the cubic signed moment survives"
            ),
        },
        "inputs": {
            C341_PATH.name: C341_SHA256,
            C406_PATH.name: C406_SHA256,
            SEAM_PATH.name: SEAM_SHA256,
            C411_PATH.name: C411_SHA256,
        },
        "verdict": (
            "THEOREM; BOTH B3 SEAMS HAVE CANONICAL FOUR-COORDINATE, RANK-TWO, "
            "CUBIC-FIRST ORIENTED DEPTH PROFILES AND FOUR-DIMENSIONAL ODD "
            "QUOTIENT/PRODUCT SECTION SPACES; H3 HAS THE SAME LAW AND A3 DOES NOT SPLIT"
        ),
        "boundary": (
            "Both intrinsic B3 seam classes survive; the theorem does not select one. The "
            "depth profile is a nonlinear rank-two zero-locus compression of rank-four "
            "factorization sections, not a linear identification with the twisted Fourier "
            "block. No all-field, q=9, section-level Fourier, or novelty claim is certified."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--probe", action="store_true")
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    certificate = build()
    if args.probe:
        for seam_type in ("S3", "D8"):
            record = next(item for item in certificate["seams"] if item["seam_type"] == seam_type)
            exchange = record["exchange_records"][0]
            print(
                seam_type,
                "point_orbits=", exchange["point_orbit_sizes"],
                "odd_pairs=", exchange["J_odd_point_orbit_pairs"],
                "matching_orbits=", exchange["matching_double_coset_orbit_sizes"],
                "profiles=", exchange["distinct_profile_count"],
                "rank=", exchange["profile_linear_rank_mod_7"],
                "moments=", [item["nonzero"] for item in exchange["signed_profile_moments_mod_7"]],
                "sections=", (
                    exchange["odd_quotient_section_rank_mod_7"],
                    exchange["odd_product_section_rank_mod_7"],
                ),
            )
        print("profile_classes=", certificate["geometric_profile_class_by_seam_type"])
        return
    content = canonical_bytes(certificate)
    if args.write:
        OUTPUT.write_bytes(content)
        print(f"wrote {OUTPUT.name} ({len(content)} bytes)")
        return
    assert OUTPUT.read_bytes() == content
    print("C414 B3 depth-profile certificate OK")


if __name__ == "__main__":
    main()
