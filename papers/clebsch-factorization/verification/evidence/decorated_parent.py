#!/usr/bin/env python3
"""Exact decorated-parent certificate for the q=11 deep-hole extension and marked fibre."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from collections import Counter, deque
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "decorated_parent.json"
A5_DATA_PATH = ROOT / "a5_subgroup_decoder.py"
A5_DATA_SHA256 = "58323770acf22c7005f381b34c601e4214c62f06d063d01dbd68cdc533f659b5"
Q = 11
I = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
J = ((1, 0, 0), (0, 0, 10), (0, 10, 0))


def load_a5_data():
    assert hashlib.sha256(A5_DATA_PATH.read_bytes()).hexdigest() == A5_DATA_SHA256
    spec = importlib.util.spec_from_file_location("a5_data_for_decorated", A5_DATA_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def canonical_bytes(data: object) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def inv(value: int) -> int:
    assert value % Q
    return pow(value % Q, Q - 2, Q)


def normalize(vector):
    reduced = tuple(value % Q for value in vector)
    pivot = next(value for value in reduced if value)
    scale = inv(pivot)
    return tuple(value * scale % Q for value in reduced)


def rref(rows):
    matrix = [[value % Q for value in row] for row in rows]
    pivots = []
    pivot_row = 0
    if not matrix:
        return matrix, pivots
    for column in range(len(matrix[0])):
        choice = next((row for row in range(pivot_row, len(matrix)) if matrix[row][column]), None)
        if choice is None:
            continue
        matrix[pivot_row], matrix[choice] = matrix[choice], matrix[pivot_row]
        scale = inv(matrix[pivot_row][column])
        matrix[pivot_row] = [scale * value % Q for value in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row != pivot_row and matrix[row][column]:
                multiple = matrix[row][column]
                matrix[row] = [
                    (value - multiple * pivot) % Q
                    for value, pivot in zip(matrix[row], matrix[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return matrix[:pivot_row], pivots


def rank(rows):
    return len(rref(rows)[1])


def nullspace(rows, width):
    reduced, pivots = rref(rows)
    answer = []
    for free in range(width):
        if free in pivots:
            continue
        vector = [0] * width
        vector[free] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free] % Q
        answer.append(tuple(vector))
    return answer


def determinant(columns):
    a, b, c = columns
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - b[0] * (a[1] * c[2] - a[2] * c[1])
        + c[0] * (a[1] * b[2] - a[2] * b[1])
    ) % Q


def cross(left, right):
    return normalize(
        (
            left[1] * right[2] - left[2] * right[1],
            left[2] * right[0] - left[0] * right[2],
            left[0] * right[1] - left[1] * right[0],
        )
    )


def dot(left, right):
    return sum(a * b for a, b in zip(left, right)) % Q


def projective_points(a5_data):
    return sorted(
        {
            normalize(vector)
            for vector in a5_data.all_vectors(Q)
            if vector != (0, 0, 0)
        }
    )


def secant_data(points, plane):
    lines = {cross(left, right) for left, right in itertools.combinations(points, 2)}
    covered = {point for point in plane if any(dot(line, point) == 0 for line in lines)}
    return lines, covered


def conic_row(point):
    x, y, z = point
    return (x * x % Q, y * y % Q, z * z % Q, x * y % Q, x * z % Q, y * z % Q)


def conic_through(points):
    kernel = nullspace([conic_row(point) for point in points], 6)
    return None if not kernel else normalize(kernel[0])


def evaluate_conic(coefficients, point):
    return dot(coefficients, conic_row(point))


def obstruction_matching(parent, child_conic):
    pairs = set()
    for omitted in parent:
        coefficients = conic_through(sorted(parent - {omitted}))
        assert coefficients is not None
        pair = frozenset(point for point in child_conic if evaluate_conic(coefficients, point) == 0)
        assert len(pair) == 2
        pairs.add(pair)
    assert len(pairs) == 6
    assert set().union(*map(set, pairs)) == set(child_conic)
    return frozenset(pairs)


def matching_key(matching):
    return tuple(sorted(tuple(sorted(pair)) for pair in matching))


def matching_json(matching):
    return [[list(point) for point in pair] for pair in matching_key(matching)]


def matching_image(matrix, matching):
    return frozenset(
        frozenset(normalize(mat_vec(matrix, point)) for point in pair) for pair in matching
    )


def code_minimum_distance(generator):
    dimension = len(generator)
    length = len(generator[0])
    minimum = length + 1
    count = 0
    for coefficients in itertools.product(range(Q), repeat=dimension):
        if not any(coefficients):
            continue
        word = [sum(coefficients[i] * generator[i][j] for i in range(dimension)) % Q for j in range(length)]
        weight = sum(value != 0 for value in word)
        if weight < minimum:
            minimum, count = weight, 1
        elif weight == minimum:
            count += 1
    return minimum, count


def mat_mul(left, right):
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(3)) % Q for j in range(3))
        for i in range(3)
    )


def mat_vec(matrix, vector):
    return tuple(dot(row, vector) for row in matrix)


def mat_normalize(matrix):
    scale = inv(next(value for row in matrix for value in row if value))
    return tuple(tuple(scale * value % Q for value in row) for row in matrix)


def closure(generators):
    group = {I}
    queue = deque([I])
    while queue:
        left = queue.popleft()
        for right in generators:
            child = mat_normalize(mat_mul(left, right))
            if child not in group:
                group.add(child)
                queue.append(child)
    return group


def image(matrix, points):
    return frozenset(normalize(mat_vec(matrix, point)) for point in points)


def conjugate(matrix, group):
    # All matrices used here are orthogonal, so transpose is a projective inverse.
    transpose = tuple(zip(*matrix))
    return frozenset(mat_normalize(mat_mul(mat_mul(matrix, element), transpose)) for element in group)


def certificate():
    a5_data = load_a5_data()
    plane = projective_points(a5_data)
    plus = frozenset(normalize(point) for point in a5_data.six_points(Q, 8))
    minus = frozenset(normalize(point) for point in a5_data.six_points(Q, 4))
    conic = frozenset(point for point in plane if dot(point, point) == 0)
    assert len(plane) == 133 and len(plus) == len(minus) == 6 and len(conic) == 12

    plus_lines, plus_covered = secant_data(plus, plane)
    assert len(plus_lines) == 15 and frozenset(plane) - plus_covered == conic

    extensions = []
    for point in sorted(conic):
        seven = sorted(plus | {point})
        assert len(seven) == 7
        assert all(determinant(triple) for triple in itertools.combinations(seven, 3))
        parity_check = [[point[column] for point in seven] for column in range(3)]
        kernel = nullspace(parity_check, 7)
        assert len(kernel) == 4
        kernel_distance, kernel_minwords = code_minimum_distance(kernel)
        dual_distance, dual_minwords = code_minimum_distance(parity_check)
        assert (kernel_distance, dual_distance) == (4, 5)

        bad_sixes = []
        for omitted in range(7):
            selected = [candidate for index, candidate in enumerate(seven) if index != omitted]
            if rank([conic_row(candidate) for candidate in selected]) < 6:
                coefficients = conic_through(selected[:5])
                assert coefficients is not None
                assert all(evaluate_conic(coefficients, candidate) == 0 for candidate in selected)
                bad_sixes.append({"omitted_point": list(seven[omitted]), "conic": list(coefficients)})
        assert len(bad_sixes) == 1
        assert bad_sixes[0]["omitted_point"] != list(point)
        extensions.append(
            {
                "point": list(point),
                "kernel_basis": [list(row) for row in kernel],
                "kernel_parameters": [7, 4, kernel_distance],
                "kernel_minimum_word_count": kernel_minwords,
                "dual_parameters": [7, 3, dual_distance],
                "dual_minimum_word_count": dual_minwords,
                "bad_six_subsets": bad_sixes,
            }
        )

    five_point_conics = []
    for omitted in sorted(plus):
        selected = sorted(plus - {omitted})
        coefficients = conic_through(selected)
        assert coefficients is not None
        intersection = sorted(point for point in conic if evaluate_conic(coefficients, point) == 0)
        assert len(intersection) == 2
        five_point_conics.append(
            {"omitted_parent_point": list(omitted), "conic": list(coefficients), "deep_points": [list(p) for p in intersection]}
        )
    assert sorted(point for item in five_point_conics for point in item["deep_points"]) == [list(p) for p in sorted(conic)]

    child_lines, child_covered = secant_data(conic, plane)
    assert len(child_lines) == 66 and child_covered == set(plane)

    roots = a5_data.h3_roots(Q, 8)
    plus_group = {mat_normalize(matrix) for matrix in a5_data.reflection_group(Q, roots)}
    assert len(plus_group) == 60
    full_group = closure(list(plus_group) + [J])
    assert len(full_group) == 1320
    assert all(image(matrix, conic) == conic for matrix in full_group)

    normalizer = [matrix for matrix in full_group if conjugate(matrix, plus_group) == frozenset(plus_group)]
    assert len(normalizer) == 60
    conjugate_groups = {conjugate(matrix, plus_group) for matrix in full_group}
    parent_arcs = {image(matrix, plus) for matrix in full_group}
    assert len(conjugate_groups) == len(parent_arcs) == 22
    assert all(len(secant_data(parent, plane)[0]) == 15 for parent in parent_arcs)
    assert all(frozenset(plane) - secant_data(parent, plane)[1] == conic for parent in parent_arcs)

    parent_matchings = {parent: obstruction_matching(parent, conic) for parent in parent_arcs}
    matchings = set(parent_matchings.values())
    assert len(matchings) == len(parent_arcs) == 22
    plus_matching = parent_matchings[plus]
    minus_matching = parent_matchings[minus]
    matching_stabilizer = [
        matrix
        for matrix in full_group
        if frozenset(frozenset(normalize(mat_vec(matrix, point)) for point in pair) for pair in plus_matching)
        == plus_matching
    ]
    assert set(matching_stabilizer) == plus_group
    assert matching_image(J, plus_matching) == minus_matching
    assert all(
        parent_matchings[image(matrix, parent)] == matching_image(matrix, matching)
        for matrix in full_group
        for parent, matching in parent_matchings.items()
    )

    # The index-two subgroup generated by the parent A5 and its J-conjugate is PSL_2(11).
    # Its two orbits on the 22 parents produce two one-factorizations of K_12.
    psl_group = closure(list(plus_group) + list(conjugate(J, plus_group)))
    assert len(psl_group) == 660 and psl_group < full_group and J not in psl_group
    unseen_psl = set(parent_arcs)
    parent_sheets = []
    while unseen_psl:
        representative = min(unseen_psl, key=lambda arc: tuple(sorted(arc)))
        sheet = frozenset(image(matrix, representative) for matrix in psl_group)
        unseen_psl -= sheet
        parent_sheets.append(sheet)
    assert sorted(map(len, parent_sheets)) == [11, 11]
    plus_sheet = next(sheet for sheet in parent_sheets if plus in sheet)
    minus_sheet = next(sheet for sheet in parent_sheets if minus in sheet)
    assert plus_sheet != minus_sheet
    assert frozenset(image(J, parent) for parent in plus_sheet) == minus_sheet

    plus_factorization = sorted((parent_matchings[parent] for parent in plus_sheet), key=matching_key)
    minus_factorization = sorted((parent_matchings[parent] for parent in minus_sheet), key=matching_key)
    child_edges = frozenset(frozenset(edge) for edge in itertools.combinations(conic, 2))
    assert len(child_edges) == 66
    factorization_spectra = []
    for factorization in (plus_factorization, minus_factorization):
        edge_multiplicities = Counter(edge for matching in factorization for edge in matching)
        assert frozenset(edge_multiplicities) == child_edges
        assert set(edge_multiplicities.values()) == {1}
        factorization_spectra.append(dict(sorted(Counter(edge_multiplicities.values()).items())))
    assert {matching_image(J, matching) for matching in plus_factorization} == set(minus_factorization)

    cross_intersections = [
        [len(left & right) for right in minus_factorization] for left in plus_factorization
    ]
    intersection_histogram = Counter(value for row in cross_intersections for value in row)
    assert intersection_histogram == Counter({1: 66, 0: 55})
    share_edge_incidence = [[int(value == 1) for value in row] for row in cross_intersections]
    assert {sum(row) for row in share_edge_incidence} == {6}
    assert {
        sum(share_edge_incidence[row][column] for row in range(11)) for column in range(11)
    } == {6}
    assert {
        sum(a * b for a, b in zip(share_edge_incidence[i], share_edge_incidence[j]))
        for i, j in itertools.combinations(range(11), 2)
    } == {3}
    disjoint_incidence = [[1 - value for value in row] for row in share_edge_incidence]
    assert {sum(row) for row in disjoint_incidence} == {5}
    assert {
        sum(disjoint_incidence[row][column] for row in range(11)) for column in range(11)
    } == {5}
    assert {
        sum(a * b for a, b in zip(disjoint_incidence[i], disjoint_incidence[j]))
        for i, j in itertools.combinations(range(11), 2)
    } == {2}

    unseen = set(parent_arcs)
    orbit_metadata = []
    while unseen:
        representative = min(unseen, key=lambda arc: tuple(sorted(arc)))
        orbit = {image(matrix, representative) for matrix in plus_group}
        unseen -= orbit
        orbit_metadata.append(
            {
                "size": len(orbit),
                "representative": [list(point) for point in sorted(representative)],
                "contains_tau8_parent": plus in orbit,
                "contains_tau4_parent": minus in orbit,
            }
        )
    orbit_metadata.sort(key=lambda item: (item["size"], item["representative"]))
    assert [item["size"] for item in orbit_metadata] == [1, 5, 6, 10]
    assert next(item["size"] for item in orbit_metadata if item["contains_tau8_parent"]) == 1
    assert next(item["size"] for item in orbit_metadata if item["contains_tau4_parent"]) == 5

    return {
        "schema": "othello.decorated.clebsch_deep_hole_extension.v2",
        "field": Q,
        "trusted_input": {"a5_data_checker": A5_DATA_PATH.name, "sha256": A5_DATA_SHA256},
        "tau8_parent": [list(point) for point in sorted(plus)],
        "tau4_parent": [list(point) for point in sorted(minus)],
        "deep_hole_conic": [list(point) for point in sorted(conic)],
        "extension_count": len(extensions),
        "extensions": extensions,
        "five_point_conic_pairing": five_point_conics,
        "all_extensions_are_seven_arcs": True,
        "all_extensions_fail_degree_two_del_pezzo_general_position": True,
        "second_transform": {
            "input_point_count": len(conic),
            "distinct_secants": len(child_lines),
            "covered_projective_points": len(child_covered),
            "output_point_count": len(set(plane) - child_covered),
        },
        "decorated_transform": {
            "parent_count": len(parent_arcs),
            "distinct_obstruction_matching_count": len(matchings),
            "injective_on_conjugate_a5_parent_locus": True,
            "matching_stabilizer_order": len(matching_stabilizer),
            "tau8_matching": matching_json(plus_matching),
            "tau4_matching": matching_json(minus_matching),
            "golden_J_exchanges_matchings": True,
            "pgl_equivariant": True,
        },
        "one_factorization_biplane": {
            "psl_subgroup_order": len(psl_group),
            "pgl_over_psl_index": len(full_group) // len(psl_group),
            "parent_sheet_sizes": [len(plus_sheet), len(minus_sheet)],
            "matching_sheet_sizes": [len(plus_factorization), len(minus_factorization)],
            "child_edge_count": len(child_edges),
            "edge_multiplicity_spectra": [
                {str(multiplicity): count for multiplicity, count in spectrum.items()}
                for spectrum in factorization_spectra
            ],
            "tau8_sheet_matchings": [matching_json(matching) for matching in plus_factorization],
            "tau4_sheet_matchings": [matching_json(matching) for matching in minus_factorization],
            "golden_J_exchanges_sheets": True,
            "cross_matching_intersection_histogram": {
                str(intersection): count for intersection, count in sorted(intersection_histogram.items())
            },
            "share_edge_design_parameters": [11, 6, 3],
            "disjointness_biplane_parameters": [11, 5, 2],
            "share_edge_incidence_matrix": share_edge_incidence,
        },
        "marked_fibre": {
            "full_child_stabilizer_order": len(full_group),
            "fixed_a5_order": len(plus_group),
            "fixed_a5_normalizer_order": len(normalizer),
            "conjugate_a5_parent_count": len(parent_arcs),
            "same_fibre_fixed_a5_orbits": orbit_metadata,
            "same_fibre_fixed_a5_orbit_sizes": [item["size"] for item in orbit_metadata],
            "golden_pair_is_complete": False,
        },
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = certificate()
    encoded = canonical_bytes(data)
    if args.write:
        OUTPUT.write_bytes(encoded)
        print(f"wrote {OUTPUT.name}")
    elif args.check:
        assert OUTPUT.read_bytes() == encoded
        print("decorated-parent certificate passed: 12 MDS extensions; 12 A1 roots; D^2 empty; 22 matchings = two K12 one-factorizations; biplane 2-(11,5,2)")
    else:
        sys.stdout.buffer.write(encoded)


if __name__ == "__main__":
    main()
