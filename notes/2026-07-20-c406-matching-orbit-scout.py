#!/usr/bin/env python3
"""Exact Gate-1 matching-orbit scout for C406."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path


SCHEMA = "c406-matching-orbit-scout-v1"
HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
C399_PATH = HERE / "2026-07-20-c399-coxeter-number-conic-phase.py"
C379_PATH = HERE / "2026-07-19-c379-clebsch-deep-hole-extension-replay.py"
C379_JSON = HERE / "2026-07-19-c379-clebsch-deep-hole-extension.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C399 = load_module("c406_c399", C399_PATH)
C379 = load_module("c406_c379", C379_PATH)


def perfect_matchings(indices: tuple[int, ...]):
    if not indices:
        yield ()
        return
    first = indices[0]
    for position in range(1, len(indices)):
        second = indices[position]
        remainder = indices[1:position] + indices[position + 1 :]
        for matching in perfect_matchings(remainder):
            yield ((first, second),) + matching


def matching_image(permutation, matching):
    return tuple(
        sorted(tuple(sorted((permutation[left], permutation[right]))) for left, right in matching)
    )


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def inverse(permutation):
    result = [0] * len(permutation)
    for index, image in enumerate(permutation):
        result[image] = index
    return tuple(result)


def full_pgl(prime, parameters):
    parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
    normalized = set()
    for entries in itertools.product(range(prime), repeat=4):
        a, b, c, d = entries
        if (a * d - b * c) % prime == 0:
            continue
        pivot = next(value for value in entries if value)
        scale = pow(pivot, -1, prime)
        normalized.add(tuple(value * scale % prime for value in entries))
    actions = {
        tuple(
            parameter_index[
                C399.normalize_pair((a * left + b * right, c * left + d * right), prime)
            ]
            for left, right in parameters
        ): (a * d - b * c) % prime
        for a, b, c, d in normalized
    }
    group = set(actions)
    squares = {value * value % prime for value in range(1, prime)}
    psl = {permutation for permutation, determinant in actions.items() if determinant in squares}
    assert len(group) == prime * (prime * prime - 1)
    assert len(psl) * 2 == len(group)
    return group, psl


def coxeter_group(name, prime, conic):
    point_index = {point: index for index, point in enumerate(conic)}
    if name in ("A3", "B3"):
        matrices = [C399.reflection_matrix(root, prime) for root in C399.arrangements()[name]]
        generators = [
            tuple(
                point_index[
                    C399.normalize_mod(C399.matrix_vector(matrix, point, prime), prime)
                ]
                for point in conic
            )
            for matrix in matrices
        ]
        return C399.generated_permutation_group(generators)
    matrices = C379.a5(8)
    return {
        tuple(
            point_index[C399.normalize_mod(C379.mv(matrix, point), prime)] for point in conic
        )
        for matrix in matrices
    }


def conjugate(permutation, subgroup):
    inv = inverse(permutation)
    return frozenset(compose(compose(permutation, element), inv) for element in subgroup)


def multiply_forms(left, right, prime):
    result = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            result[i + j] = (result[i + j] + a * b) % prime
    return tuple(result)


def restricted_matching_product(matching, endpoints, prime):
    result = (1,)
    for left, right in matching:
        a, b = endpoints[left]
        c, d = endpoints[right]
        result = multiply_forms(result, (b * d, -(a * d + b * c), a * c), prime)
    return result


def encode_matching(matching):
    return [list(pair) for pair in matching]


def type_certificate(name, prime, expected_orbit):
    conic, parameters = C399.conic_parameterization(prime)
    endpoints = tuple([(1, value) for value in range(prime)] + [(0, 1)])
    assert tuple(parameters) == endpoints
    full_group, psl_group = full_pgl(prime, parameters)
    parent_group = coxeter_group(name, prime, conic)
    expected_parent_order = 60 if name == "H3" else 24
    assert len(parent_group) == expected_parent_order and parent_group <= full_group

    matchings = tuple(perfect_matchings(tuple(range(prime + 1))))
    unseen = set(matchings)
    orbit_records = []
    target_orbit = None
    while unseen:
        representative = min(unseen)
        orbit = {matching_image(element, representative) for element in full_group}
        unseen -= orbit
        stabilizer_order = len(full_group) // len(orbit)
        orbit_records.append(
            {
                "orbit_size": len(orbit),
                "stabilizer_order": stabilizer_order,
                "representative": encode_matching(representative),
            }
        )
        if len(orbit) == expected_orbit and stabilizer_order == expected_parent_order:
            assert target_orbit is None
            target_orbit = orbit
    assert target_orbit is not None

    fixed = [
        matching
        for matching in matchings
        if all(matching_image(element, matching) == matching for element in parent_group)
    ]
    assert len(fixed) == 1
    parent_matching = fixed[0]
    stabilizer = {
        element
        for element in full_group
        if matching_image(element, parent_matching) == parent_matching
    }
    normalizer = {
        element for element in full_group if conjugate(element, parent_group) == parent_group
    }
    assert stabilizer == parent_group == normalizer
    assert {matching_image(element, parent_matching) for element in full_group} == target_orbit

    unseen_target = set(target_orbit)
    psl_sheets = []
    all_edges = {tuple(pair) for pair in itertools.combinations(range(prime + 1), 2)}
    while unseen_target:
        representative = min(unseen_target)
        sheet = {matching_image(element, representative) for element in psl_group}
        unseen_target -= sheet
        edge_counts = Counter(edge for matching in sheet for edge in matching)
        assert set(edge_counts) == all_edges and set(edge_counts.values()) == {1}
        psl_sheets.append(sheet)
    expected_sheet_count = 1 if name == "A3" else 2
    assert len(psl_sheets) == expected_sheet_count
    assert sorted(map(len, psl_sheets)) == [prime] * expected_sheet_count
    full_edge_counts = Counter(edge for matching in target_orbit for edge in matching)
    assert set(full_edge_counts) == all_edges
    assert set(full_edge_counts.values()) == {expected_sheet_count}

    subgroup_to_matching = {}
    for element in full_group:
        child_group = conjugate(element, parent_group)
        child_matching = matching_image(element, parent_matching)
        if child_group in subgroup_to_matching:
            assert subgroup_to_matching[child_group] == child_matching
        subgroup_to_matching[child_group] = child_matching
    assert len(subgroup_to_matching) == expected_orbit
    assert len(set(subgroup_to_matching.values())) == expected_orbit

    frobenius = [0] * (prime + 2)
    frobenius[1] = 1
    frobenius[prime] = prime - 1
    product_histogram = Counter(
        restricted_matching_product(matching, endpoints, prime) for matching in matchings
    )
    assert product_histogram == Counter({tuple(frobenius): len(matchings)})

    h3_frozen_match = None
    if name == "H3":
        frozen = json.loads(C379_JSON.read_text())
        point_index = {point: index for index, point in enumerate(conic)}
        h3_frozen_match = tuple(
            sorted(
                tuple(sorted(point_index[tuple(point)] for point in pair))
            for pair in frozen["decorated_transform"]["tau8_matching"]
            )
        )
        assert h3_frozen_match == parent_matching

    return {
        "type": name,
        "field_order": prime,
        "conic_points": [list(point) for point in conic],
        "p1_endpoints": [list(point) for point in endpoints],
        "perfect_matching_count": len(matchings),
        "full_pgl_order": len(full_group),
        "coxeter_parent_order": len(parent_group),
        "coxeter_parent_normalizer_order": len(normalizer),
        "coxeter_invariant_matching_count": len(fixed),
        "coxeter_invariant_matching": encode_matching(parent_matching),
        "target_orbit_size": len(target_orbit),
        "psl_order": len(psl_group),
        "psl_target_orbit_sizes": sorted(map(len, psl_sheets)),
        "psl_orbits_are_one_factorizations": True,
        "target_orbit_edge_multiplicity": expected_sheet_count,
        "outer_coset_exchanges_sheets": expected_sheet_count == 2,
        "conjugate_parent_subgroup_count": len(subgroup_to_matching),
        "parent_subgroup_to_matching_is_bijective": True,
        "matching_stabilizer_equals_parent_subgroup": True,
        "all_orbits": sorted(orbit_records, key=lambda item: (item["orbit_size"], item["representative"])),
        "factorization_products_checked": len(matchings),
        "common_restricted_form": frobenius,
        "common_form_is_s_q_t_minus_s_t_q": True,
        "matches_frozen_c379_obstruction_matching": h3_frozen_match == parent_matching
        if h3_frozen_match is not None
        else None,
    }


def build_certificate():
    types = [
        type_certificate("A3", 5, 5),
        type_certificate("B3", 7, 14),
        type_certificate("H3", 11, 22),
    ]
    assert [item["perfect_matching_count"] for item in types] == [15, 105, 10395]
    return {
        "schema": SCHEMA,
        "verdict": "GATE_1_PASS_UNIFORM_MATCHING_INTERFACE_MODULE_UNDECIDED",
        "types": types,
        "gate_1_summary": {
            "unique_target_orbits": True,
            "uniform_child_side_construction": "unique Coxeter-parent-invariant perfect matching",
            "orbit_alone_adds_structure_beyond_parent_subgroup": False,
            "reason": (
                "For every type the matching stabilizer and the parent normalizer are exactly the "
                "same classical S4/S4/A5 subgroup, so the 5/14/22 matching orbit alone is the "
                "same homogeneous parent-marker space PGL2(q)/G_T with a renamed point. This "
                "does not decide the restricted augmentation module required by Gate 2."
            ),
            "gate_2_authorized_by_gate_1": True,
            "gate_2_executed": False,
        },
        "inputs": {
            path.name: {
                "bytes": path.stat().st_size,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
            for path in (C399_PATH, C379_PATH, C379_JSON)
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    else:
        if not OUTPUT.exists() or OUTPUT.read_text() != rendered:
            raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
        print("C406 Gate 1 certificate OK")


if __name__ == "__main__":
    main()
