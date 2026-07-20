#!/usr/bin/env python3
"""Independent reconstruction replay for the C413 certificate."""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from collections import Counter
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = json.loads((HERE / "2026-07-20-c413-intrinsic-rank16-recovery.json").read_text())


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


C = load("c413_independent_c378", HERE / "2026-07-19-c378-clebsch-common-duality-replay.py")
H = load("c413_independent_c411", HERE / "2026-07-20-c411-double-coset-hecke-replay.py")
R = H.R
Q = 11


def canonical_bytes(value):
    return (json.dumps(value, sort_keys=True, separators=(",", ":")) + "\n").encode()


def intersection_tensor(classes):
    answer = []
    for target in classes:
        z = min(target)
        slab = []
        for left in classes:
            row = []
            for right in classes:
                row.append(sum(tuple((z[i] - x[i]) % Q for i in range(3)) in right for x in left))
            slab.append(row)
        answer.append(slab)
    return answer


def relation_partition(tensor, valencies):
    classes = [frozenset(i for i, x in enumerate(valencies) if x == value) for value in sorted(set(valencies))]
    classes = [frozenset({0}) if 0 in part else part for part in classes] + [
        part - {0} for part in classes if 0 in part and len(part) > 1
    ]
    classes = sorted((part for part in classes if part), key=lambda part: (len(part), min(part)))
    for _ in range(16):
        color = {x: a for a, part in enumerate(classes) for x in part}
        sig = []
        for k in range(16):
            sig.append(
                (
                    color[k],
                    tuple(
                        tuple(sorted(tensor[k][i][j] for i in left for j in right))
                        for left in classes
                        for right in classes
                    ),
                )
            )
        new = [frozenset(i for i, item in enumerate(sig) if item == target) for target in set(sig)]
        new = sorted(new, key=lambda part: (len(part), min(part)))
        if set(new) == set(classes):
            return classes
        classes = new
    raise AssertionError("relation refinement did not stabilize")


def reconstruct_rank16():
    plus_group, minus_group = C.a5(8), C.a5(4)
    plus = C.orbits(C.linear(plus_group))
    minus = C.orbits(C.linear(minus_group))
    plus.sort(key=lambda orbit: (len(orbit), min(orbit)))
    minus.sort(key=lambda orbit: (len(orbit), min(orbit)))
    common = C.orbits(C.linear(plus_group & minus_group))
    metadata = []
    for orbit in common:
        pi = next(i for i, relation in enumerate(plus) if orbit <= relation)
        mi = next(i for i, relation in enumerate(minus) if orbit <= relation)
        metadata.append((pi, mi, min(orbit), orbit))
    metadata.sort(key=lambda item: item[:3])
    common = [item[3] for item in metadata]
    tensor = intersection_tensor(common)
    valencies = [len(orbit) for orbit in common]
    classes = relation_partition(tensor, valencies)
    assert [sorted(part) for part in classes] == CERT["intrinsic_relation_recovery"]["stable_intersection_tensor_classes"]

    pairs = [tuple(sorted(part)) for part in classes if len(part) == 2]
    automorphisms = []
    for mask in range(16):
        permutation = list(range(16))
        for bit, (left, right) in enumerate(pairs):
            if (mask >> bit) & 1:
                permutation[left], permutation[right] = right, left
        if all(
            tensor[k][i][j] == tensor[permutation[k]][permutation[i]][permutation[j]]
            for k, i, j in itertools.product(range(16), repeat=3)
        ):
            automorphisms.append(permutation)
    assert automorphisms == CERT["intrinsic_relation_recovery"]["algebraic_automorphisms"]

    eigenmatrix = C.fourier(common)
    for fusion in CERT["intrinsic_rank8_fusions"]["fusion_partitions"]:
        signatures = {
            tuple(sum(eigenmatrix[row][i] for i in block) for block in fusion) for row in range(16)
        }
        assert len(signatures) == 8
    known = {
        tuple(sorted(tuple(i for i, relation in enumerate(common) if relation <= target) for target in family))
        for family in (plus, minus)
    }
    claimed = {
        tuple(tuple(block) for block in fusion)
        for fusion in CERT["intrinsic_rank8_fusions"]["fusion_partitions"]
    }
    assert claimed == known


def reconstruct_tomography():
    source = next(record for record in H.SCOUT["types"] if record["type"] == "H3")
    endpoints = [tuple(point) for point in source["p1_endpoints"]]
    base = tuple(tuple(pair) for pair in source["coxeter_invariant_matching"])
    _, pgl, _ = R.mobius_groups(Q)
    matchings = sorted({R.image_matching(element, base) for element in pgl})
    index = {matching: i for i, matching in enumerate(matchings)}

    projective = sorted(
        {H.normalize(vector, Q) for vector in itertools.product(range(Q), repeat=3) if vector != (0, 0, 0)}
    )
    conic = [point for point in projective if sum(x * x for x in point) % Q == 0]
    base_point = conic[0]
    pencil = [line for line in projective if sum(a * b for a, b in zip(line, base_point)) % Q == 0]
    first = pencil[0]
    second = next(line for line in pencil[1:] if H.cross(first, line, Q) != (0, 0, 0))
    parameterized = []
    for left, right in endpoints:
        line = H.normalize(tuple((left * first[i] + right * second[i]) % Q for i in range(3)), Q)
        incident = [point for point in conic if sum(a * b for a, b in zip(line, point)) % Q == 0]
        parameterized.append(base_point if len(incident) == 1 else next(x for x in incident if x != base_point))

    conic_index = {point: i for i, point in enumerate(parameterized)}
    k_group = C.a5(8) & C.a5(4)
    k_actions = {
        tuple(conic_index[H.normalize(C.mv(matrix, point), Q)] for point in parameterized)
        for matrix in k_group
    }

    unseen = set(range(22))
    parts = []
    while unseen:
        seed = min(unseen)
        part = {index[R.image_matching(action, matchings[seed])] for action in k_actions}
        unseen -= part
        parts.append(part)
    base_partition = tuple(sorted(tuple(sorted(part)) for part in parts))

    def permutation(element):
        return tuple(index[R.image_matching(element, matching)] for matching in matchings)

    def move(partition, action):
        return tuple(sorted(tuple(sorted(action[i] for i in part)) for part in partition))

    actions = [permutation(element) for element in pgl]
    views = sorted({move(base_partition, action) for action in actions})
    labels = []
    for view in views:
        row = [0] * 22
        for label, part in enumerate(view):
            for point in part:
                row[point] = label
        labels.append(tuple(row))

    def count(indices):
        return len({tuple(labels[j][point] for j in indices) for point in range(22)})

    pairs = Counter(count(pair) for pair in itertools.combinations(range(55), 2))
    triples = Counter(count(triple) for triple in itertools.combinations(range(55), 3))
    target = CERT["conjugate_view_tomography"]
    assert len(views) == target["distinct_conjugate_views"] == 55
    assert dict(sorted(pairs.items())) == {int(k): v for k, v in target["pair_cell_count_spectrum"].items()}
    assert dict(sorted(triples.items())) == {int(k): v for k, v in target["triple_cell_count_spectrum"].items()}
    assert triples[22] == target["separating_triple_count"]
    assert hashlib.sha256(canonical_bytes(views)).hexdigest() == target["all_views_sha256"]


def main():
    reconstruct_rank16()
    reconstruct_tomography()
    print("C413 independent rank-16/tomography replay OK")


if __name__ == "__main__":
    main()
