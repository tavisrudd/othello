#!/usr/bin/env python3
"""Exact character-weighted collision audit for the 44 q=53 C756 stars."""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-08-09-c756-aligned-node-clique.py"
BASE_CERTIFICATE = HERE / "2026-08-09-c756-aligned-node-clique.json"
BASE_SHA256 = "bf3c2fe00f9b09e2889532da697f9ef09d9ecffdfac2785d232541f164b79bbb"
BASE_CERTIFICATE_SHA256 = (
    "2b49dd98d42fe5686a646ffb4bb42505624cc11e821fdf9eb7b0975068e53422"
)


def load_base():
    if hashlib.sha256(BASE_PATH.read_bytes()).hexdigest() != BASE_SHA256:
        raise SystemExit("base script hash mismatch")
    if (
        hashlib.sha256(BASE_CERTIFICATE.read_bytes()).hexdigest()
        != BASE_CERTIFICATE_SHA256
    ):
        raise SystemExit("base certificate hash mismatch")
    specification = importlib.util.spec_from_file_location("c756_collision_base", BASE_PATH)
    if specification is None or specification.loader is None:
        raise SystemExit(f"cannot load {BASE_PATH}")
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


BASE = load_base()
Q = BASE.Q


def linear_coefficients(direction: int) -> tuple[int, int]:
    alpha = BASE.ALPHA0 * BASE.TORUS[direction]
    return 2 * alpha.a % Q, 2 * BASE.NONSQUARE * alpha.b % Q


def affine_nodes(chosen):
    nodes = []
    labels = []
    for i, left in enumerate(chosen):
        a_i, b_i = linear_coefficients(left.direction)
        for j, right in enumerate(chosen[:i]):
            a_j, b_j = linear_coefficients(right.direction)
            determinant = (a_i * b_j - a_j * b_i) % Q
            inverse = pow(determinant, -1, Q)
            nodes.append(
                (
                    (-left.s * b_j + right.s * b_i) * inverse % Q,
                    (-a_i * right.s + a_j * left.s) * inverse % Q,
                )
            )
            labels.append((i, j))
    if len(nodes) != 55:
        raise AssertionError(len(nodes))
    return nodes, dict(zip(labels, nodes))


def internal_direction(point, other) -> int | None:
    dx = (other[0] - point[0]) % Q
    dy = (other[1] - point[1]) % Q
    matches = [
        direction
        for direction in range(len(BASE.TORUS))
        if sum(
            coefficient * difference
            for coefficient, difference in zip(
                linear_coefficients(direction), (dx, dy)
            )
        )
        % Q
        == 0
    ]
    if len(matches) > 1:
        raise AssertionError(matches)
    return matches[0] if matches else None


def collision_energies(nodes):
    result = {}
    for direction in range(len(BASE.TORUS)):
        a, b = linear_coefficients(direction)
        fibres = Counter((a * x + b * y) % Q for x, y in nodes)
        result[direction] = sum(n * (n - 1) // 2 for n in fibres.values())
    return result


def analyze(record):
    chosen = [BASE.Vertex(*pair) for pair in record["vertices"]]
    nodes, by_edge = affine_nodes(chosen)
    used = {vertex.direction for vertex in chosen}
    missing = set(range(len(BASE.TORUS))) - used
    energies = collision_energies(nodes)

    shared_pairs = 0
    for line in range(11):
        incident = [edge for edge in by_edge if line in edge]
        for left, right in itertools.combinations(incident, 2):
            direction = internal_direction(by_edge[left], by_edge[right])
            if direction != chosen[line].direction:
                raise AssertionError((line, left, right, direction))
            shared_pairs += 1

    diagonal_histogram = Counter()
    disjoint_internal = 0
    disjoint_arrangement = 0
    for i, j, k, ell in itertools.combinations(range(11), 4):
        pairings = (
            ((j, i), (ell, k)),
            ((k, i), (ell, j)),
            ((ell, i), (k, j)),
        )
        internal_count = 0
        for left, right in pairings:
            direction = internal_direction(by_edge[left], by_edge[right])
            if direction is not None:
                internal_count += 1
                disjoint_internal += 1
                disjoint_arrangement += int(direction in used)
        diagonal_histogram[internal_count] += 1

    missing_energy = sum(energies[direction] for direction in missing)
    arrangement_energy = sum(energies[direction] for direction in used)
    internal_energy = sum(energies.values())
    if shared_pairs != 11 * 45:
        raise AssertionError(shared_pairs)
    if internal_energy != shared_pairs + disjoint_internal:
        raise AssertionError((internal_energy, shared_pairs, disjoint_internal))
    if missing_energy != disjoint_internal - disjoint_arrangement:
        raise AssertionError((missing_energy, disjoint_internal, disjoint_arrangement))

    return {
        "missing_center_energy": missing_energy,
        "arrangement_center_energy": arrangement_energy,
        "all_internal_center_energy": internal_energy,
        "shared_line_pairs": shared_pairs,
        "disjoint_edge_pairs": 3 * len(list(itertools.combinations(range(11), 4))),
        "disjoint_internal": disjoint_internal,
        "disjoint_external": 990 - disjoint_internal,
        "disjoint_character_sum": 2 * disjoint_internal - 990,
        "disjoint_internal_at_arrangement_centers": disjoint_arrangement,
        "disjoint_internal_at_missing_centers": disjoint_internal
        - disjoint_arrangement,
        "arrangement_energy_multiset": sorted(energies[d] for d in used),
        "missing_energy_multiset": sorted(energies[d] for d in missing),
        "four_line_internal_diagonal_histogram": [
            {"internal_diagonals": count, "four_subsets": diagonal_histogram[count]}
            for count in range(4)
        ],
    }


def exact_output():
    certificate = json.loads(BASE_CERTIFICATE.read_text())
    case = next(
        case
        for case in certificate["cases"]
        if case["name"] == "trace_zero_offset"
    )
    records = case["normalized_direction_zero_candidates"]
    profiles = Counter(
        json.dumps(analyze(record), sort_keys=True, separators=(",", ":"))
        for record in records
    )
    if len(profiles) != 1:
        raise AssertionError(f"nonuniform collision profiles: {len(profiles)}")
    profile, multiplicity = next(iter(profiles.items()))
    return {
        "schema": "c756-star-collision-character-v1",
        "q": Q,
        "normalized_star_count": len(records),
        "dihedral_orbit_count": int(case["dihedral_orbit_count"]),
        "dihedral_normalized_hit_counts": sorted(
            int(orbit["normalized_direction_zero_hits"])
            for orbit in case["dihedral_orbits"]
        ),
        "common_profile_multiplicity": multiplicity,
        "common_profile": json.loads(profile),
        "base_script": BASE_PATH.name,
        "base_script_sha256": BASE_SHA256,
        "base_certificate": BASE_CERTIFICATE.name,
        "base_certificate_sha256": BASE_CERTIFICATE_SHA256,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--check", type=Path)
    parser.add_argument("--output", type=Path)
    arguments = parser.parse_args()
    if arguments.exact == (arguments.check is not None):
        parser.error("select exactly one of --exact or --check FILE")
    rendered = json.dumps(exact_output(), indent=2, sort_keys=True) + "\n"
    if arguments.check is not None:
        if rendered != arguments.check.read_text():
            raise SystemExit(f"certificate mismatch: {arguments.check}")
        print(f"certificate ok: {arguments.check}")
    elif arguments.output is not None:
        arguments.output.write_text(rendered)
        print(f"wrote {arguments.output}")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
