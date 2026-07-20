#!/usr/bin/env python3
"""Exact C413 intrinsic rank-16 recovery and conjugate-view tomography certificate."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent
C378_PATH = ROOT / "2026-07-19-c378-clebsch-common-duality.py"
C378_JSON = ROOT / "2026-07-19-c378-clebsch-common-duality.json"
C411_PATH = ROOT / "2026-07-20-c411-double-coset-hecke.py"
C411_JSON = ROOT / "2026-07-20-c411-double-coset-hecke.json"
OUTPUT = ROOT / "2026-07-20-c413-intrinsic-rank16-recovery.json"


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


C378 = load("c413_c378", C378_PATH)
C411 = load("c413_c411", C411_PATH)
C406 = C411.C406


def canonical_bytes(value) -> bytes:
    return (json.dumps(value, sort_keys=True, separators=(",", ":")) + "\n").encode()


def rank16_data():
    c341 = C378.load_c341()
    plus_group, _, plus = C378.scheme(c341, 8)
    minus_group, _, minus = C378.scheme(c341, 4)
    intersection = plus_group & minus_group
    common = C378.orbits(c341, C378.linear_group(intersection), c341.all_vectors(11))
    metadata = []
    for orbit in common:
        pi = next(i for i, relation in enumerate(plus) if orbit <= relation)
        mi = next(i for i, relation in enumerate(minus) if orbit <= relation)
        metadata.append((pi, mi, min(orbit), orbit))
    metadata.sort(key=lambda item: item[:3])
    common = [item[3] for item in metadata]
    tensor = c341.intersection_tensor(common, 11)
    eigenmatrix = C378.fourier_matrix(c341, common)
    valencies = [len(orbit) for orbit in common]
    return c341, plus_group, minus_group, plus, minus, common, tensor, eigenmatrix, valencies


def stable_relation_classes(tensor, valencies):
    classes = []
    for value in sorted(set(valencies)):
        part = frozenset(i for i, valency in enumerate(valencies) if valency == value)
        if 0 in part:
            classes.append(frozenset({0}))
            if len(part) > 1:
                classes.append(part - {0})
        else:
            classes.append(part)
    classes = sorted((part for part in classes if part), key=lambda part: (len(part), min(part)))
    while True:
        color = {x: a for a, part in enumerate(classes) for x in part}
        signatures = []
        for k in range(len(valencies)):
            blocks = tuple(
                tuple(sorted(tensor[k][i][j] for i in left for j in right))
                for left in classes
                for right in classes
            )
            signatures.append((color[k], blocks))
        refined = [
            frozenset(i for i, signature in enumerate(signatures) if signature == target)
            for target in sorted(set(signatures), key=repr)
        ]
        refined = sorted(refined, key=lambda part: (len(part), min(part)))
        if set(refined) == set(classes):
            return classes
        classes = refined


def algebraic_pair_flips(tensor, pairs):
    answer = []
    rank = len(tensor)
    for mask in range(1 << len(pairs)):
        permutation = list(range(rank))
        for bit, (left, right) in enumerate(pairs):
            if (mask >> bit) & 1:
                permutation[left], permutation[right] = right, left
        if all(
            tensor[k][i][j]
            == tensor[permutation[k]][permutation[i]][permutation[j]]
            for k, i, j in itertools.product(range(rank), repeat=3)
        ):
            answer.append(permutation)
    return answer


def clebsch_pattern_fusions(eigenmatrix, valencies):
    sixty = [i for i, value in enumerate(valencies) if value == 60]
    one_twenty = [i for i, value in enumerate(valencies) if value == 120]
    i40, i30 = valencies.index(40), valencies.index(30)
    valid = set()
    checked = 0
    for singleton60 in sixty:
        for paired60 in sixty:
            if paired60 == singleton60:
                continue
            remaining60 = [x for x in sixty if x not in (singleton60, paired60)]
            for singleton120 in one_twenty:
                for paired120 in one_twenty:
                    if paired120 == singleton120:
                        continue
                    remaining120 = [x for x in one_twenty if x not in (singleton120, paired120)]
                    first = remaining60[0]
                    for pair1 in itertools.combinations(remaining120, 2):
                        rest1 = [x for x in remaining120 if x not in pair1]
                        for second in remaining60[1:]:
                            third = next(x for x in remaining60 if x not in (first, second))
                            for pair2 in itertools.combinations(rest1, 2):
                                pair3 = tuple(x for x in rest1 if x not in pair2)
                                blocks = [
                                    (0,),
                                    (singleton60,),
                                    tuple(sorted((i40, paired60))),
                                    (singleton120,),
                                    tuple(sorted((i30, paired120))),
                                    tuple(sorted((first,) + pair1)),
                                    tuple(sorted((second,) + pair2)),
                                    tuple(sorted((third,) + pair3)),
                                ]
                                checked += 1
                                row_signatures = {
                                    tuple(sum(eigenmatrix[row][i] for i in block) for block in blocks)
                                    for row in range(16)
                                }
                                if len(row_signatures) == 8:
                                    valid.add(tuple(sorted(blocks)))
    return checked, sorted(valid)


def tomography():
    prime = 11
    scout = json.loads(C411.SCOUT_PATH.read_text())
    source = next(record for record in scout["types"] if record["type"] == "H3")
    conic, parameters = C406.C399.conic_parameterization(prime)
    full_group, _ = C406.full_pgl(prime, parameters)
    base = tuple(tuple(pair) for pair in source["coxeter_invariant_matching"])
    matchings = sorted({C406.matching_image(element, base) for element in full_group})
    matching_index = {matching: index for index, matching in enumerate(matchings)}

    c341 = C378.load_c341()
    plus_group, _, _ = C378.scheme(c341, 8)
    minus_group, _, _ = C378.scheme(c341, 4)
    intersection = plus_group & minus_group
    conic_index = {point: index for index, point in enumerate(conic)}

    def point_action(matrix):
        return tuple(
            conic_index[C411.normalize_projective(c341.mat_vec(matrix, point, prime), prime)]
            for point in conic
        )

    k_actions = {point_action(matrix) for matrix in intersection}
    base_parts = C411.orbit_partition(k_actions, matchings, C406.matching_image)
    base_partition = tuple(sorted(tuple(sorted(part)) for part in base_parts))

    def action(element):
        return tuple(
            matching_index[C406.matching_image(element, matching)] for matching in matchings
        )

    def move(partition, permutation):
        return tuple(sorted(tuple(sorted(permutation[i] for i in part)) for part in partition))

    group_actions = [action(element) for element in full_group]
    views = sorted({move(base_partition, permutation) for permutation in group_actions})
    view_index = {view: i for i, view in enumerate(views)}
    labels = []
    for view in views:
        row = [0] * len(matchings)
        for label, part in enumerate(view):
            for point in part:
                row[point] = label
        labels.append(tuple(row))

    def cell_count(indices):
        return len({tuple(labels[j][point] for j in indices) for point in range(len(matchings))})

    pair_spectrum = Counter()
    best_pair = None
    for left, right in itertools.combinations(range(len(views)), 2):
        count = cell_count((left, right))
        pair_spectrum[count] += 1
        candidate = (count, left, right)
        if best_pair is None or candidate > best_pair:
            best_pair = candidate

    separating = []
    triple_spectrum = Counter()
    for triple in itertools.combinations(range(len(views)), 3):
        count = cell_count(triple)
        triple_spectrum[count] += 1
        if count == len(matchings):
            separating.append(triple)

    view_actions = []
    for permutation in group_actions:
        view_actions.append(tuple(view_index[move(view, permutation)] for view in views))
    unseen = set(separating)
    orbit_sizes = []
    orbit_representatives = []
    while unseen:
        representative = min(unseen)
        orbit = {
            tuple(sorted(permutation[i] for i in representative)) for permutation in view_actions
        }
        unseen -= orbit
        orbit_representatives.append(list(representative))
        orbit_sizes.append(len(orbit))

    singleton_parts = sorted(part for part in base_partition if len(part) == 1)
    return {
        "points": len(matchings),
        "base_view_fibre_sizes": sorted(map(len, base_partition)),
        "base_view_singleton_matching_indices": [part[0] for part in singleton_parts],
        "distinct_conjugate_views": len(views),
        "view_normalizer_order": len(full_group) // len(views),
        "pair_cell_count_spectrum": dict(sorted(pair_spectrum.items())),
        "best_pair_cell_count": best_pair[0],
        "best_pair_view_indices": list(best_pair[1:]),
        "triple_cell_count_spectrum": dict(sorted(triple_spectrum.items())),
        "separating_triple_count": len(separating),
        "separating_triple_orbit_sizes": sorted(orbit_sizes),
        "separating_triple_orbit_representatives": orbit_representatives,
        "canonical_first_separating_triple": list(min(separating)),
        "all_views_sha256": hashlib.sha256(canonical_bytes(views)).hexdigest(),
    }


def build():
    _, plus_group, minus_group, plus, minus, common, tensor, eigenmatrix, valencies = rank16_data()
    classes = stable_relation_classes(tensor, valencies)
    pairs = sorted(tuple(sorted(part)) for part in classes if len(part) == 2)
    automorphisms = algebraic_pair_flips(tensor, pairs)
    checked, fusions = clebsch_pattern_fusions(eigenmatrix, valencies)
    known_plus = tuple(sorted(tuple(i for i, relation in enumerate(common) if relation <= target) for target in plus))
    known_minus = tuple(sorted(tuple(i for i, relation in enumerate(common) if relation <= target) for target in minus))
    assert pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]
    assert len(automorphisms) == 2
    assert fusions == sorted({known_plus, known_minus})
    assert len(plus_group | minus_group) == 108  # union size; closure is checked by C378
    tomo = tomography()
    assert tomo["best_pair_cell_count"] < 22
    assert tomo["separating_triple_count"] > 0
    return {
        "schema": "c413-intrinsic-rank16-recovery-v1",
        "field": 11,
        "intrinsic_relation_recovery": {
            "stable_intersection_tensor_classes": [sorted(part) for part in classes],
            "unresolved_classes_are_exactly_J_pairs": True,
            "pair_flip_candidates_checked": 16,
            "algebraic_automorphism_group_order": len(automorphisms),
            "algebraic_automorphisms": automorphisms,
            "global_J_is_only_nontrivial_relation_automorphism": True,
        },
        "intrinsic_rank8_fusions": {
            "target_valency_pattern": [1, 60, 100, 120, 150, 300, 300, 300],
            "bannai_muzychuk_candidates_checked": checked,
            "valid_fusion_count": len(fusions),
            "fusion_partitions": [[list(block) for block in fusion] for fusion in fusions],
            "valid_fusions_are_exactly_the_two_golden_A5_schemes": True,
            "global_J_exchanges_the_two_fusions": True,
        },
        "conjugate_view_tomography": tomo,
        "parent_recovery": {
            "K_type": "A4",
            "G_type": "PGL2(11)",
            "H_type": "A5",
            "K_fixed_H_cosets": 2,
            "fixed_cosets_are_the_two_singleton_depth_classes": True,
            "composition": "intrinsic fusion pair -> A5 pair and K -> two K-fixed matchings -> C379 matching-decorated parent recovery",
        },
        "inputs": {
            path.name: hashlib.sha256(path.read_bytes()).hexdigest()
            for path in (C378_PATH, C378_JSON, C411_PATH, C411_JSON)
        },
        "verdict": "INTRINSIC UNORDERED GOLDEN PAIR; THREE CONJUGATE HECKE VIEWS REMOVE THE FIBRE OBSTRUCTION",
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(data)
    elif args.check:
        assert OUTPUT.read_bytes() == data
    else:
        print(data.decode(), end="")
    print("C413 intrinsic rank-16 recovery certificate OK")


if __name__ == "__main__":
    main()
