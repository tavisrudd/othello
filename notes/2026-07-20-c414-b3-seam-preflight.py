#!/usr/bin/env python3
"""Exact q=7 preflight for the outer-conjugate B3 parent seam."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-20-c414-b3-seam-preflight.json"
C406_PATH = ROOT / "2026-07-20-c406-matching-orbit-scout.py"
C406_SHA256 = "be5e860b69a0875dfef29cde0907a6952470d43a497dd1dc40f7e6b60c202332"
Q = 7


def load_c406():
    assert hashlib.sha256(C406_PATH.read_bytes()).hexdigest() == C406_SHA256
    spec = importlib.util.spec_from_file_location("c406_for_c414_b3", C406_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def permutation_order(c406, permutation):
    identity = tuple(range(len(permutation)))
    power = identity
    for order in range(1, 25):
        power = c406.compose(permutation, power)
        if power == identity:
            return order
    raise AssertionError


def fixed_matching(c406, group):
    matchings = c406.perfect_matchings(tuple(range(Q + 1)))
    fixed = [
        matching
        for matching in matchings
        if all(c406.matching_image(element, matching) == matching for element in group)
    ]
    assert len(fixed) == 1
    return fixed[0]


def point_orbit_sizes(group):
    unseen = set(range(Q + 1))
    sizes = []
    while unseen:
        seed = min(unseen)
        orbit = {element[seed] for element in group}
        unseen -= orbit
        sizes.append(len(orbit))
    return sorted(sizes)


def build():
    c406 = load_c406()
    conic, parameters = c406.C399.conic_parameterization(Q)
    full_group, psl_group = c406.full_pgl(Q, parameters)
    parent = c406.coxeter_group("B3", Q, conic)
    assert len(full_group) == 336 and len(psl_group) == 168
    assert len(parent) == 24 and parent <= psl_group
    base_matching = fixed_matching(c406, parent)

    same_sheet = {c406.conjugate(element, parent) for element in psl_group}
    opposite_sheet = {c406.conjugate(element, parent) for element in full_group - psl_group}
    assert len(same_sheet) == len(opposite_sheet) == 7
    assert not (same_sheet & opposite_sheet)

    records = []
    for other in opposite_sheet:
        common = set(parent) & set(other)
        other_matching = fixed_matching(c406, other)
        order_counts = Counter(permutation_order(c406, element) for element in common)
        common_order = len(common)
        common_type = "S3" if common_order == 6 else "D8" if common_order == 8 else None
        assert common_type is not None
        expected_orders = {1: 1, 2: 3, 3: 2} if common_type == "S3" else {1: 1, 2: 5, 4: 2}
        assert dict(sorted(order_counts.items())) == expected_orders
        shared_edges = len(set(base_matching) & set(other_matching))
        assert shared_edges == (1 if common_type == "S3" else 0)
        endpoint_orbits = point_orbit_sizes(common)
        assert endpoint_orbits == ([2, 6] if common_type == "S3" else [8])
        records.append(
            {
                "common_group_order": common_order,
                "common_group_type": common_type,
                "common_group_element_order_counts": dict(sorted(order_counts.items())),
                "shared_matching_edges": shared_edges,
                "common_group_endpoint_orbit_sizes": endpoint_orbits,
                "other_matching": [list(edge) for edge in other_matching],
            }
        )

    type_counts = Counter(record["common_group_type"] for record in records)
    assert type_counts == {"S3": 4, "D8": 3}

    unseen = set(opposite_sheet)
    parent_orbits = []
    while unseen:
        seed = min(unseen, key=lambda group: sorted(group))
        orbit = {c406.conjugate(element, seed) for element in parent}
        unseen -= orbit
        intersection_order = len(set(parent) & set(seed))
        parent_orbits.append(
            {
                "orbit_size": len(orbit),
                "common_group_order": intersection_order,
                "common_group_type": "S3" if intersection_order == 6 else "D8",
            }
        )
    assert sorted((record["orbit_size"], record["common_group_order"]) for record in parent_orbits) == [
        (3, 8),
        (4, 6),
    ]

    return {
        "schema": "c414-b3-seam-preflight-v1",
        "field": Q,
        "full_conic_group": "PGL2(7)",
        "full_conic_group_order": len(full_group),
        "determinant_square_subgroup": "PSL2(7)",
        "determinant_square_subgroup_order": len(psl_group),
        "base_parent_group": "S4",
        "base_parent_group_order": len(parent),
        "base_parent_is_contained_in_psl": True,
        "base_matching": [list(edge) for edge in base_matching],
        "same_sheet_parent_count": len(same_sheet),
        "opposite_sheet_parent_count": len(opposite_sheet),
        "opposite_seams": sorted(
            records,
            key=lambda record: (
                record["common_group_order"],
                record["other_matching"],
            ),
        ),
        "opposite_seam_type_counts": dict(sorted(type_counts.items())),
        "base_parent_orbits_on_opposite_sheet": sorted(
            parent_orbits, key=lambda record: record["orbit_size"]
        ),
        "verdict": (
            "THEOREM; THE SEVEN OUTER-SHEET S4 PARENTS SPLIT INTRINSICALLY INTO FOUR "
            "S3 SEAMS SHARING ONE MATCHING EDGE AND THREE D8 SEAMS SHARING NONE"
        ),
        "boundary": (
            "The phrase 'the two outer-conjugate S4 parents' does not specify a unique B3 "
            "common refinement. A portable B3/H3 theorem must select a seam type by an extra "
            "geometric predicate or prove compatible statements for both types. No twisted "
            "Fourier block, depth profile, matching-section identity, or novelty is certified."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(payload)
    else:
        assert OUTPUT.read_bytes() == payload
    print("C414 q=7 B3 seam preflight certificate OK")


if __name__ == "__main__":
    main()
