#!/usr/bin/env python3
"""Exact C378 certificate for golden symmetry completion and signed Fourier refinement."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-19-c378-clebsch-common-duality.json"
C341_PATH = ROOT / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"
Q = 11
J = ((1, 0, 0), (0, 0, 10), (0, 10, 0))
IDENTITY = ((1, 0, 0), (0, 1, 0), (0, 0, 1))


def load_c341():
    assert hashlib.sha256(C341_PATH.read_bytes()).hexdigest() == C341_SHA256
    spec = importlib.util.spec_from_file_location("c341_for_c378", C341_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def canonical_bytes(data: object) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def closure(c341, generators):
    group = {IDENTITY}
    queue = [IDENTITY]
    while queue:
        left = queue.pop()
        for right in generators:
            child = c341.mat_normalize(c341.mat_mul(left, right, Q), Q)
            if child not in group:
                group.add(child)
                queue.append(child)
    return group


def linear_group(projective_group):
    return {
        tuple(tuple(scale * entry % Q for entry in row) for row in matrix)
        for matrix in projective_group
        for scale in range(1, Q)
    }


def orbits(c341, group, points):
    unseen = set(points)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {c341.mat_vec(matrix, seed, Q) for matrix in group}
        unseen -= orbit
        answer.append(orbit)
    return answer


def projective_orbits(c341, group):
    points = {(0, 0, 0)} | {
        c341.normalize(vector, Q)
        for vector in c341.all_vectors(Q)
        if vector != (0, 0, 0)
    }
    unseen = set(points)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {
            seed if seed == (0, 0, 0) else c341.normalize(c341.mat_vec(matrix, seed, Q), Q)
            for matrix in group
        }
        unseen -= orbit
        answer.append(orbit)
    return answer


def scheme(c341, tau):
    roots = c341.h3_roots(Q, tau)
    columns = c341.six_points(Q, tau)
    group = c341.reflection_group(Q, roots)
    labelled = c341.label_orbits(c341.vector_orbits(group, Q), roots, columns, Q)
    return group, [label for label, _ in labelled], [orbit for _, orbit in labelled]


def fourier_matrix(c341, classes):
    answer = []
    for character_class in classes:
        character = min(character_class)
        row = []
        for relation in classes:
            if relation == {(0, 0, 0)}:
                row.append(1)
                continue
            lines = {c341.normalize(vector, Q) for vector in relation}
            zero_lines = sum(c341.dot(character, line, Q) == 0 for line in lines)
            row.append(Q * zero_lines - len(lines))
        answer.append(row)
    return answer


def coherent_refine(cells, vectors):
    old_class = {vector: index for index, cell in enumerate(cells) for vector in cell}
    signatures = {vector: [old_class[vector]] for vector in vectors}
    for left in cells:
        for right in cells:
            counts = {}
            for x in left:
                for y in right:
                    total = tuple((x[d] + y[d]) % Q for d in range(3))
                    counts[total] = counts.get(total, 0) + 1
            for vector in vectors:
                signatures[vector].append(counts.get(vector, 0))
    groups = {}
    for vector in vectors:
        groups.setdefault(tuple(signatures[vector]), set()).add(vector)
    return list(groups.values())


def vector_product(left, right, tensor):
    rank = len(left)
    return [
        sum(left[i] * right[j] * tensor[k][i][j] for i in range(rank) for j in range(rank))
        for k in range(rank)
    ]


def certificate():
    c341 = load_c341()
    plus_group, labels, plus = scheme(c341, 8)
    minus_group, minus_labels, minus = scheme(c341, 4)
    assert labels == minus_labels

    # C377's integral outer map is orthogonal and conjugates the two A5 fibres.
    assert c341.mat_mul(tuple(zip(*J)), J, Q) == IDENTITY
    conjugate_group = {
        c341.mat_normalize(c341.mat_mul(c341.mat_mul(J, matrix, Q), J, Q), Q)
        for matrix in plus_group
    }
    assert conjugate_group == minus_group
    class_map = []
    for relation in plus:
        image = {c341.mat_vec(J, vector, Q) for vector in relation}
        class_map.append(next(index for index, target in enumerate(minus) if image == target))
    assert class_map == [0, 1, 2, 3, 4, 5, 7, 6]

    # The golden closure has the order and orbit partition of the full conic stabilizer.
    golden_group = closure(c341, list(plus_group) + [J])
    assert len(golden_group) == Q * (Q * Q - 1) == 1320
    conic = {
        c341.normalize(vector, Q)
        for vector in c341.all_vectors(Q)
        if vector != (0, 0, 0) and c341.dot(vector, vector, Q) == 0
    }
    assert len(conic) == Q + 1
    assert all(
        {c341.normalize(c341.mat_vec(matrix, point, Q), Q) for point in conic} == conic
        for matrix in golden_group
    )
    projective_sizes = sorted(len(orbit) for orbit in projective_orbits(c341, golden_group))
    affine_orbits = orbits(c341, linear_group(golden_group), c341.all_vectors(Q))
    affine_orbits.sort(key=lambda orbit: (len(orbit), min(orbit)))
    assert projective_sizes == [1, 12, 55, 66]
    assert [len(orbit) for orbit in affine_orbits] == [1, 120, 550, 660]
    orthogonal_fusion = [plus[0], plus[3], plus[1] | plus[5] | plus[6], plus[2] | plus[4] | plus[7]]
    assert {frozenset(orbit) for orbit in affine_orbits} == {frozenset(orbit) for orbit in orthogonal_fusion}

    # The common refinement of the two fissions closes in one step to the scalar-A4 scheme.
    intersection_group = plus_group & minus_group
    assert len(intersection_group) == 12
    scalar_intersection = linear_group(intersection_group)
    common = orbits(c341, scalar_intersection, c341.all_vectors(Q))
    metadata = []
    for orbit in common:
        plus_index = next(index for index, relation in enumerate(plus) if orbit <= relation)
        minus_index = next(index for index, relation in enumerate(minus) if orbit <= relation)
        metadata.append((plus_index, minus_index, min(orbit), orbit))
    metadata.sort(key=lambda item: item[:3])
    common = [item[3] for item in metadata]
    assert [len(orbit) for orbit in common] == [1, 60, 40, 60, 120, 30, 120, 60, 120, 120, 60, 120, 120, 60, 120, 120]

    raw_intersections = [left & right for left in plus for right in minus if left & right]
    assert len(raw_intersections) == 15
    refined = coherent_refine(raw_intersections, c341.all_vectors(Q))
    assert {frozenset(cell) for cell in refined} == {frozenset(cell) for cell in common}
    refined_again = coherent_refine(common, c341.all_vectors(Q))
    assert {frozenset(cell) for cell in refined_again} == {frozenset(cell) for cell in common}

    tensor = c341.intersection_tensor(common, Q)
    valencies = [len(orbit) for orbit in common]
    c341.check_tensor(tensor, valencies)
    eigenmatrix = fourier_matrix(c341, common)
    assert all(
        sum(eigenmatrix[i][k] * eigenmatrix[k][j] for k in range(16)) == Q ** 3 * (i == j)
        for i in range(16) for j in range(16)
    )
    assert all(
        sum(tensor[k][i][j] * eigenmatrix[row][k] for k in range(16))
        == eigenmatrix[row][i] * eigenmatrix[row][j]
        for row, i, j in itertools.product(range(16), repeat=3)
    )

    j_permutation = []
    for relation in common:
        image = {c341.mat_vec(J, vector, Q) for vector in relation}
        j_permutation.append(next(index for index, target in enumerate(common) if image == target))
    assert j_permutation == [0, 10, 2, 13, 4, 5, 14, 7, 8, 11, 1, 9, 12, 3, 6, 15]
    odd_pairs = [(index, image) for index, image in enumerate(j_permutation) if index < image]
    assert odd_pairs == [(1, 10), (3, 13), (6, 14), (9, 11)]

    even_basis = []
    odd_basis = []
    visited = set()
    for index, image in enumerate(j_permutation):
        if index in visited:
            continue
        visited |= {index, image}
        vector = [0] * 16
        vector[index] = 1
        vector[image] = 1
        even_basis.append(vector)
        if index != image:
            vector = [0] * 16
            vector[index] = 1
            vector[image] = -1
            odd_basis.append(vector)
    assert len(even_basis) == 12 and len(odd_basis) == 4

    def has_parity(vector, expected):
        image = [vector[j_permutation[index]] for index in range(16)]
        target = vector if expected == 0 else [-value for value in vector]
        return image == target

    for left_parity, left_basis in enumerate((even_basis, odd_basis)):
        for right_parity, right_basis in enumerate((even_basis, odd_basis)):
            for left in left_basis:
                for right in right_basis:
                    expected = left_parity ^ right_parity
                    assert has_parity(vector_product(left, right, tensor), expected)
                    assert has_parity([x * y for x, y in zip(left, right)], expected)

    odd_fourier = [
        [eigenmatrix[row][left] - eigenmatrix[row][right] for left, right in odd_pairs]
        for row, _ in odd_pairs
    ]
    assert odd_fourier == [[-11, 0, 44, -22], [0, -11, 22, 44], [22, 11, 11, 0], [-11, 22, 0, 11]]
    assert all(
        sum(odd_fourier[i][k] * odd_fourier[k][j] for k in range(4)) == Q ** 3 * (i == j)
        for i in range(4) for j in range(4)
    )

    return {
        "schema": "c378-clebsch-common-duality-v1",
        "field": Q,
        "golden_map_J": [list(row) for row in J],
        "a5_projective_order": len(plus_group),
        "golden_closure_projective_order": len(golden_group),
        "full_conic_stabilizer_order_formula": "q(q^2-1)",
        "conic_projective_point_count": len(conic),
        "golden_closure_projective_orbit_sizes_including_zero": projective_sizes,
        "golden_closure_affine_orbit_sizes": [len(orbit) for orbit in affine_orbits],
        "c372_rank_four_fusion_blocks": [[0], [3], [1, 5, 6], [2, 4, 7]],
        "golden_closure_equals_c372_rank_four_fusion": True,
        "plus_to_minus_relation_permutation_under_J": class_map,
        "a5_intersection_projective_order": len(intersection_group),
        "common_coherent_refinement_rank": len(common),
        "common_relation_metadata": [
            {"plus_relation": left, "minus_relation": right, "representative": list(rep), "size": len(orbit)}
            for (left, right, rep, orbit) in metadata
        ],
        "common_refinement_valencies": valencies,
        "common_refinement_first_eigenmatrix": eigenmatrix,
        "common_refinement_formally_and_fourier_self_dual": True,
        "common_refinement_intersection_tensor_sha256": hashlib.sha256(canonical_bytes(tensor)).hexdigest(),
        "J_relation_permutation": j_permutation,
        "J_even_dimension": len(even_basis),
        "J_odd_relation_pairs": [list(pair) for pair in odd_pairs],
        "J_odd_dimension": len(odd_basis),
        "ordinary_and_entrywise_Z2_grading_verified": True,
        "odd_fourier_matrix": odd_fourier,
        "odd_fourier_matrix_square": "1331 I_4",
        "trusted_input": {"c341_checker": C341_PATH.name, "c341_checker_sha256": C341_SHA256},
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(certificate())
    if args.write:
        OUTPUT.write_bytes(data)
    if args.check:
        assert OUTPUT.read_bytes() == data
    if not args.write and not args.check:
        print(data.decode(), end="")
    print(f"sha256={hashlib.sha256(data).hexdigest()} bytes={len(data)}")


if __name__ == "__main__":
    main()
