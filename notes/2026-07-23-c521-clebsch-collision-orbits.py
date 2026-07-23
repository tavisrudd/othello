#!/usr/bin/env python3
"""Exact PGL_2(11)-orbit explanation of C521's collision multiplicities."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import tempfile
from collections import Counter
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-23-c521-clebsch-collision-orbits"
SCHEMA = "c521-clebsch-collision-orbits-v1"
C398 = HERE / "2026-07-20-c398-conic-deep-hole-classification.py"
C474 = HERE / "2026-07-22-c474-reed-solomon-decorated-deep-holes.py"
C478 = HERE / "2026-07-22-c478-exceptional-family-controls.py"
C490 = HERE / "2026-07-22-c490-small-field-base-size-closure.json"
OUTPUT = HERE / f"{STEM}.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def permutation_inverse(permutation):
    answer = [None] * len(permutation)
    for index, image in enumerate(permutation):
        answer[image] = index
    assert all(value is not None for value in answer)
    return tuple(answer)


def permutation_cycles(permutation):
    seen = set()
    cycles = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        current = start
        size = 0
        while current not in seen:
            seen.add(current)
            size += 1
            current = permutation[current]
        if size > 1:
            cycles.append(size)
    return tuple(sorted(cycles, reverse=True))


def transform_instance(instance, action, permutations, permutation_index):
    left, right, transporter_index = instance
    transporter = permutations[transporter_index]
    left_image = action["parent"][left]
    right_image = action["parent"][right]
    left_labels = action["labels"][left]
    right_labels = action["labels"][right]
    left_inverse = permutation_inverse(left_labels)
    transported = tuple(
        right_labels[transporter[left_inverse[new_left]]]
        for new_left in range(6)
    )
    if left_image < right_image:
        return left_image, right_image, permutation_index[transported]
    return right_image, left_image, permutation_index[permutation_inverse(transported)]


def build() -> dict:
    c398 = load_module("c521_c398", C398)
    c474 = load_module("c521_c474", C474)
    c478 = load_module("c521_c478", C478)
    source = json.loads(C490.read_text())
    fibre = next(
        fibre
        for field_record in source["fields"] if field_record["q"] == 11
        for fibre in field_record["fibres"] if fibre["child_size"] == 12
    )
    field = c398.FiniteField(11)
    child = tuple(tuple(point) for point in fibre["child"])
    parents = tuple(tuple(tuple(point) for point in parent) for parent in fibre["parents"])
    assert len(child) == 12 and len(parents) == 22
    assert all(tuple(sorted(parent)) == parent for parent in parents)
    parent_index = {parent: index for index, parent in enumerate(parents)}
    deletion_signatures = tuple(
        c474.deletion_signature(c398, field, parent, child) for parent in parents
    )
    assert all(sorted(map(len, signature)) == [2] * 6 for signature in deletion_signatures)
    signatures = tuple(sorted(set(deletion_signatures)))
    assert len(signatures) == 22
    blocks, _ = c474.signature_incidence(signatures)
    relation = c474.bipartite_relation(signatures, blocks, 3)
    assert relation is not None and sorted(map(len, relation["parts"])) == [11, 11]
    signature_sheet = {
        signatures[index]: sheet
        for sheet, part in enumerate(relation["parts"])
        for index in part
    }

    permutations = tuple(c478.SUPPORT_PERMUTATIONS)
    permutation_index = {permutation: index for index, permutation in enumerate(permutations)}
    identity = permutation_index[tuple(range(6))]
    atlas_cache = tuple(
        tuple(
            tuple(c478.atlas(c398, field, parent, centre, permutation) for centre in child)
            for permutation in permutations
        )
        for parent in parents
    )

    masks = {}
    multiplicities = Counter()
    for left, right in combinations(range(len(parents)), 2):
        left_values = atlas_cache[left][identity]
        for transporter_index, right_values in enumerate(atlas_cache[right]):
            mask = sum(
                1 << index
                for index, (a, b) in enumerate(zip(left_values, right_values))
                if a != b
            )
            instance = (left, right, transporter_index)
            masks[instance] = mask
            multiplicities[mask] += 1
    expected_multiplicities = {
        int(mask): count
        for mask, count in fibre["disagreement_mask_multiplicities"].items()
    }
    assert multiplicities == expected_multiplicities
    assert len(masks) == 166320

    transformations = c474.locus_stabilizer(c398, field, child)
    assert len(transformations) == 1320
    child_index = {point: index for index, point in enumerate(child)}
    actions = []
    for transformation in transformations:
        parent_action = []
        label_actions = []
        for parent in parents:
            images = tuple(c474.apply_semilinear(c398, field, transformation, point) for point in parent)
            sorted_images = tuple(sorted(images))
            parent_action.append(parent_index[sorted_images])
            image_index = {point: index for index, point in enumerate(sorted_images)}
            label_actions.append(tuple(image_index[point] for point in images))
        child_action = tuple(
            child_index[c474.apply_semilinear(c398, field, transformation, point)]
            for point in child
        )
        actions.append({
            "parent": tuple(parent_action),
            "labels": tuple(label_actions),
            "child": child_action,
        })
    assert len({action["parent"] for action in actions}) == 1320

    target_instances = {
        instance for instance, mask in masks.items()
        if mask.bit_count() in (10, 11)
    }
    assert len(target_instances) == 7590
    unseen = set(target_instances)
    orbit_records = []
    while unseen:
        representative = min(unseen)
        orbit = {
            transform_instance(representative, action, permutations, permutation_index)
            for action in actions
        }
        assert orbit <= target_instances
        unseen -= orbit
        stabilizer = [
            action
            for action in actions
            if transform_instance(representative, action, permutations, permutation_index) == representative
        ]
        assert len(orbit) * len(stabilizer) == len(actions)
        mask = masks[representative]
        agreement = tuple(index for index in range(12) if not (mask >> index) & 1)
        for action in actions:
            image = transform_instance(representative, action, permutations, permutation_index)
            transported_mask = sum(
                1 << action["child"][index]
                for index in range(12) if (mask >> index) & 1
            )
            assert masks[image] == transported_mask
        assert all(
            {action["child"][index] for index in agreement} == set(agreement)
            for action in stabilizer
        )
        shared_deletion_edges = tuple(sorted(
            set(deletion_signatures[representative[0]])
            & set(deletion_signatures[representative[1]])
        ))
        agreement_is_unique_shared_deletion_edge = shared_deletion_edges == (agreement,)
        parents_are_cross_sheet = (
            signature_sheet[deletion_signatures[representative[0]]]
            != signature_sheet[deletion_signatures[representative[1]]]
        )
        if len(stabilizer) == 20:
            assert all(
                tuple(index for index in range(12) if not (masks[instance] >> index) & 1)
                in (
                    set(deletion_signatures[instance[0]])
                    & set(deletion_signatures[instance[1]])
                )
                and len(
                    set(deletion_signatures[instance[0]])
                    & set(deletion_signatures[instance[1]])
                ) == 1
                for instance in orbit
            )
            assert all(
                signature_sheet[deletion_signatures[instance[0]]]
                != signature_sheet[deletion_signatures[instance[1]]]
                for instance in orbit
            )
        orbit_records.append({
            "agreement_size": len(agreement),
            "representative": {
                "left_parent": representative[0],
                "right_parent": representative[1],
                "transporter_index": representative[2],
                "agreement_indices": list(agreement),
            },
            "orbit_size": len(orbit),
            "stabilizer_order": len(stabilizer),
            "stabilizer_child_cycle_profiles": {
                str(profile): count
                for profile, count in sorted(Counter(
                    permutation_cycles(action["child"]) for action in stabilizer
                ).items())
            },
            "shared_deletion_edges": [list(edge) for edge in shared_deletion_edges],
            "agreement_is_unique_shared_deletion_edge": agreement_is_unique_shared_deletion_edge,
            "parents_are_cross_sheet": parents_are_cross_sheet,
        })
    orbit_records.sort(key=lambda record: (
        record["agreement_size"],
        -record["orbit_size"],
        record["representative"]["left_parent"],
        record["representative"]["right_parent"],
        record["representative"]["transporter_index"],
    ))

    agreement_one = [record for record in orbit_records if record["agreement_size"] == 1]
    agreement_two = [record for record in orbit_records if record["agreement_size"] == 2]
    assert [(record["orbit_size"], record["stabilizer_order"]) for record in agreement_one] == [
        (1320, 1),
    ]
    agreement_two_profile = Counter(
        (record["orbit_size"], record["stabilizer_order"]) for record in agreement_two
    )
    assert agreement_two_profile == Counter({
        (660, 2): 8,
        (330, 4): 2,
        (132, 10): 2,
        (66, 20): 1,
    }), (
        agreement_two_profile
    )
    canonical_edge_orbits = [
        record for record in agreement_two if record["stabilizer_order"] == 20
    ]
    assert len(canonical_edge_orbits) == 1
    assert canonical_edge_orbits[0]["agreement_is_unique_shared_deletion_edge"]
    assert canonical_edge_orbits[0]["parents_are_cross_sheet"]

    point_stabilizer_order = 1320 // 12
    pair_stabilizer_order = 1320 // 66
    pair_fibre_contributions = sorted(
        pair_stabilizer_order // record["stabilizer_order"]
        for record in agreement_two
    )
    assert point_stabilizer_order == 110
    assert pair_stabilizer_order == 20
    assert pair_fibre_contributions == [1, 2, 2, 5, 5] + [10] * 8
    assert sum(pair_fibre_contributions) == 95

    return {
        "schema": SCHEMA,
        "task": "C521",
        "inputs": {
            path.name: {"bytes": path.stat().st_size, "sha256": sha256(path)}
            for path in (C398, C474, C478, C490)
        },
        "group": {
            "name": "PGL_2(11)",
            "order": 1320,
            "child_degree": 12,
            "parent_degree": 22,
            "point_stabilizer_order": point_stabilizer_order,
            "unordered_pair_stabilizer_order": pair_stabilizer_order,
        },
        "comparison_instances": {
            "total": len(masks),
            "agreement_one_total": len(agreement_one) * 1320,
            "agreement_two_total": sum(record["orbit_size"] for record in agreement_two),
        },
        "agreement_one_orbits": agreement_one,
        "agreement_two_orbits": agreement_two,
        "pair_fibre_contributions": pair_fibre_contributions,
        "pair_fibre_total": sum(pair_fibre_contributions),
    }


def render(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = render(build())
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUTPUT.name
            candidate.write_bytes(payload)
            assert OUTPUT.read_bytes() == candidate.read_bytes()
        print(f"ok {OUTPUT.name} {len(payload)} bytes {hashlib.sha256(payload).hexdigest()}")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.name} {len(payload)} bytes {hashlib.sha256(payload).hexdigest()}")


if __name__ == "__main__":
    main()
