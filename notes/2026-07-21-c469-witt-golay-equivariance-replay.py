#!/usr/bin/env python3
"""Independent replay of the C469 orbit certificate.

This file imports no C469 generator code.  It generates PSL(2,11) by a
breadth-first word enumeration in S,T rather than enumerating PGL matrices.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import math
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
CERTIFICATE = NOTES / "2026-07-21-c469-witt-golay-equivariance.json"
Q = 11
P = 3


def norm(g):
    values = tuple(x % Q for x in g)
    inverse = pow(next(x for x in values if x), -1, Q)
    return tuple(x * inverse % Q for x in values)


def mul(g, h):
    a, b, c, d = g
    e, f, i, j = h
    return norm((a * e + b * i, a * f + b * j,
                 c * e + d * i, c * f + d * j))


def inv(g):
    a, b, c, d = g
    return norm((d, -b, -c, a))


def det(g):
    a, b, c, d = g
    return (a * d - b * c) % Q


def on_point(g, x):
    a, b, c, d = g
    if x == Q:
        return Q if c == 0 else a * pow(c, -1, Q) % Q
    denominator = (c * x + d) % Q
    return Q if denominator == 0 else (a * x + b) * pow(denominator, -1, Q) % Q


def canon_matching(matching):
    return tuple(sorted(tuple(sorted((int(a), int(b)))) for a, b in matching))


def move_matching(permutation, matching):
    return canon_matching((permutation[a], permutation[b]) for a, b in matching)


def induced(permutation, objects):
    index = {obj: i for i, obj in enumerate(objects)}
    return tuple(index[move_matching(permutation, obj)] for obj in objects)


def move_subset(permutation, subset):
    return tuple(sorted(permutation[x] for x in subset))


def move_edge(permutation, edge):
    return tuple(sorted((permutation[edge[0]], permutation[edge[1]])))


def move_word(permutation, word):
    target = [0] * len(word)
    for old, value in enumerate(word):
        target[permutation[old]] = value
    scale = pow(next(value for value in target if value), -1, P)
    return tuple(scale * value % P for value in target)


def order(permutation):
    seen = set()
    answer = 1
    for start in range(len(permutation)):
        if start in seen:
            continue
        current = start
        length = 0
        while current not in seen:
            seen.add(current)
            current = permutation[current]
            length += 1
        answer = math.lcm(answer, length)
    return answer


def stabilizer(group, action, obj):
    return [k for k, element in enumerate(group) if action(element, obj) == obj]


def subgroup_orbits(member_ids, permutations):
    unseen = set(range(len(permutations[0])))
    sizes = []
    while unseen:
        base = min(unseen)
        orbit = {permutations[k][base] for k in member_ids}
        unseen -= orbit
        sizes.append(len(orbit))
    return sorted(sizes)


def orbit_sizes(objects, group, action):
    unseen = set(objects)
    sizes = []
    while unseen:
        base = min(unseen)
        orbit = {action(element, base) for element in group}
        unseen -= orbit
        sizes.append(len(orbit))
    return sorted(sizes)


def enumerate_code(generator):
    for coefficients in itertools.product(range(P), repeat=len(generator)):
        yield tuple(sum(coefficients[row] * generator[row][column]
                        for row in range(len(generator))) % P
                    for column in range(len(generator[0])))


def projective(word):
    scale = pow(next(value for value in word if value), -1, P)
    return tuple(scale * value % P for value in word)


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    for name, record in certificate["inputs"].items():
        path = ROOT / name
        assert path.stat().st_size == record["bytes"]
        assert hashlib.sha256(path.read_bytes()).hexdigest() == record["sha256"]

    c452 = json.loads((NOTES / "2026-07-21-c452-qr-barker.json").read_text())
    c464 = json.loads((NOTES / "2026-07-21-c464-perfect-code-spans.json").read_text())
    c452_case = next(case for case in c452["cases"] if case["q"] == Q)
    c464_case = next(case for case in c464["cases"] if case["q"] == Q)
    sheets = [[canon_matching(matching) for matching in sheet]
              for sheet in c452_case["sheets"]]
    indices = [{matching: i for i, matching in enumerate(sheet)} for sheet in sheets]

    generators = [norm((1, 1, 0, 1)), norm((0, -1, 1, 0))]
    identity = norm((1, 0, 0, 1))
    generated = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            target = mul(generator, current)
            if target not in generated:
                generated.add(target)
                queue.append(target)
    matrices = sorted(generated)
    assert len(matrices) == 660
    assert {det(g) for g in matrices} <= {1, 3, 4, 5, 9}
    matrix_index = {g: i for i, g in enumerate(matrices)}

    group = []
    for matrix in matrices:
        points = tuple(on_point(matrix, x) for x in range(Q + 1))
        rows = induced(points, sheets[0])
        coordinates = induced(points, sheets[1])
        group.append((matrix, points, rows, coordinates))

    incidence = c464_case["relations"]["disjoint"]["incidence_matrix"]
    assert incidence == [[int(not (set(left) & set(right))) for right in sheets[1]]
                         for left in sheets[0]]
    selected = [tuple(i for i, value in enumerate(row) if value) for row in incidence]
    assert all(move_subset(element[3], selected[row]) == selected[element[2][row]]
               for element in group for row in range(Q))

    records = c464_case["third_order_minimum_support_structure"][
        "k11_edge_to_residual_support"]
    edge_support = {tuple(record["row_pair"]): tuple(record["residual_support"])
                    for record in records}
    edges = sorted(edge_support)
    assert all(move_subset(element[3], edge_support[edge]) ==
               edge_support[move_edge(element[2], edge)]
               for element in group for edge in edges)
    pairs = [(row, column) for row in range(Q) for column in range(Q)
             if incidence[row][column]]

    edge_action = lambda element, edge: move_edge(element[2], edge)
    pair_action = lambda element, pair: (element[2][pair[0]], element[3][pair[1]])
    edge_stabilizer = stabilizer(group, edge_action, edges[0])
    pair_stabilizers = {pair: stabilizer(group, pair_action, pair) for pair in pairs}
    assert len(edge_stabilizer) == 12
    assert all(len(stabilizer_ids) == 12 for stabilizer_ids in pair_stabilizers.values())
    assert not [pair for pair, stabilizer_ids in pair_stabilizers.items()
                if stabilizer_ids == edge_stabilizer]
    edge_histogram = Counter(order(group[k][1]) for k in edge_stabilizer)
    assert edge_histogram == {1: 1, 2: 7, 3: 2, 6: 2}
    source_partitions = {
        "sheet_0": subgroup_orbits(edge_stabilizer, [element[2] for element in group]),
        "sheet_1": subgroup_orbits(edge_stabilizer, [element[3] for element in group]),
    }
    target_stabilizer = pair_stabilizers[pairs[0]]
    assert Counter(order(group[k][1]) for k in target_stabilizer) == {1: 1, 2: 3, 3: 8}
    target_partitions = {
        "sheet_0": subgroup_orbits(target_stabilizer, [element[2] for element in group]),
        "sheet_1": subgroup_orbits(target_stabilizer, [element[3] for element in group]),
    }
    assert source_partitions == {"sheet_0": [2, 3, 6], "sheet_1": [2, 3, 6]}
    assert target_partitions == {"sheet_0": [1, 4, 6], "sheet_1": [1, 4, 6]}

    outer = norm((1, 10, 1, 1))
    outer_inverse = inv(outer)
    alpha_stabilizer = sorted(matrix_index[mul(mul(outer, matrices[k]), outer_inverse)]
                              for k in edge_stabilizer)
    assert not [pair for pair, stabilizer_ids in pair_stabilizers.items()
                if stabilizer_ids == alpha_stabilizer]

    generator_matrix = c464_case["relations"]["disjoint"]["generator_matrix_rref"]
    codewords = list(enumerate_code(generator_matrix))
    full_words = sorted({projective(word) for word in codewords if all(word)})
    word_action = lambda element, word: move_word(element[3], word)
    assert len(full_words) == 12
    assert orbit_sizes(full_words, group, word_action) == [1, 11]
    fixed = tuple([1] * Q)
    assert stabilizer(group, word_action, fixed) == list(range(660))
    moving = next(word for word in full_words if word != fixed)
    moving_stabilizer = stabilizer(group, word_action, moving)
    assert len(moving_stabilizer) == 60
    assert Counter(order(group[k][1]) for k in moving_stabilizer) == {
        1: 1, 2: 15, 3: 20, 5: 24,
    }
    point_stabilizer = stabilizer(group, lambda element, x: element[1][x], 0)
    assert len(point_stabilizer) == 55
    assert Counter(order(group[k][1]) for k in point_stabilizer) == {1: 1, 5: 44, 11: 10}

    selected_stabilizers = {
        support: stabilizer(group, lambda element, obj: move_subset(element[3], obj), support)
        for support in selected
    }
    selected_hits = [support for support, stabilizer_ids in selected_stabilizers.items()
                     if stabilizer_ids == moving_stabilizer]
    assert len(selected_hits) == 1
    block_anchor = selected_hits[0]
    correspondence = {}
    for element in group:
        word = word_action(element, moving)
        block = move_subset(element[3], block_anchor)
        assert correspondence.setdefault(word, block) == block
    assert len(correspondence) == 11
    affine_formula = {
        projective(tuple((1 + value) % P for value in incidence[row])): selected[row]
        for row in range(Q)
    }
    assert affine_formula == correspondence
    for word, block in correspondence.items():
        symbol_supports = [tuple(i for i, value in enumerate(word) if value == symbol)
                           for symbol in (1, 2)]
        assert sorted(map(len, symbol_supports)) == [5, 6]
        assert min(symbol_supports, key=len) == block

    projective_by_weight = {}
    for word in codewords:
        if any(word):
            projective_by_weight.setdefault(sum(value != 0 for value in word), set()).add(
                projective(word))
    support_controls = {}
    for weight in (5, 6, 8, 9):
        words = projective_by_weight[weight]
        supports = {tuple(i for i, value in enumerate(word) if value) for word in words}
        support_controls[str(weight)] = {
            "projective_word_count": len(words),
            "support_count": len(supports),
            "support_orbit_sizes": orbit_sizes(
                supports, group, lambda element, obj: move_subset(element[3], obj)),
            "all_generator_images_remain_in_family": all(
                move_subset(group[matrix_index[generator]][3], support) in supports
                for generator in generators for support in supports),
        }

    representatives = [fixed] + [
        tuple((1 + value) % P for value in incidence[row]) for row in range(Q)
    ]
    secant_weight5 = set()
    secant_weight6 = set()
    secant_types = Counter()
    for left, right in itertools.combinations(range(12), 2):
        a, b = representatives[left], representatives[right]
        interior = {
            sum(value != 0 for value in word): word
            for word in (
                projective(tuple((x + y) % P for x, y in zip(a, b))),
                projective(tuple((x - y) % P for x, y in zip(a, b))),
            )
        }
        assert set(interior) == {5, 6}
        support5 = tuple(i for i, value in enumerate(interior[5]) if value)
        support6 = tuple(i for i, value in enumerate(interior[6]) if value)
        expected = selected[right - 1] if left == 0 else edge_support[(left - 1, right - 1)]
        assert support5 == expected
        assert set(support5).isdisjoint(support6) and len(support5) + len(support6) == Q
        secant_weight5.add(interior[5])
        secant_weight6.add(interior[6])
        secant_types["fixed_to_moving" if left == 0 else "moving_to_moving"] += 1
    assert secant_types == {"fixed_to_moving": 11, "moving_to_moving": 55}
    assert secant_weight5 == projective_by_weight[5]
    assert secant_weight6 == projective_by_weight[6]

    extended_generator = [row + [(-sum(row)) % P] for row in generator_matrix]
    extended_words = list(enumerate_code(extended_generator))
    assert Counter(sum(value != 0 for value in word) for word in extended_words) == {
        0: 1, 6: 264, 9: 440, 12: 24,
    }
    assert all(sum(x * y for x, y in zip(left, right)) % P == 0
               for left in extended_generator for right in extended_generator)
    extended_representatives = [word + ((-sum(word)) % P,) for word in representatives]
    signs = [[1 if value == 1 else -1 for value in word]
             for word in extended_representatives]
    assert [[sum(x * y for x, y in zip(left, right)) for right in signs]
            for left in signs] == [[12 if i == j else 0 for j in range(12)]
                                   for i in range(12)]
    extended_projective = {}
    for word in extended_words:
        if any(word):
            extended_projective.setdefault(sum(value != 0 for value in word), set()).add(
                projective(word))
    assert {projective(word) for word in extended_representatives} == extended_projective[12]
    extended_secants = set()
    for left, right in itertools.combinations(range(12), 2):
        a, b = extended_representatives[left], extended_representatives[right]
        for word in (
            projective(tuple((x + y) % P for x, y in zip(a, b))),
            projective(tuple((x - y) % P for x, y in zip(a, b))),
        ):
            assert sum(value != 0 for value in word) == 6
            extended_secants.add(word)
    assert extended_secants == extended_projective[6]

    assert certificate["object_orders"]["selected_supports"] == [list(x) for x in selected]
    assert certificate["object_orders"]["residual_edges"] == [list(x) for x in edges]
    assert certificate["object_orders"]["C450_disjoint_pairs"] == [list(x) for x in pairs]
    assert certificate["object_orders"]["full_support_projective_words"] == [list(x) for x in full_words]
    assert certificate["residual_55_comparison"]["source_stabilizer_orbits_on_sheets"] == source_partitions
    assert certificate["residual_55_comparison"]["target_stabilizer_orbits_on_sheets"] == target_partitions
    assert certificate["full_support_projective_words"]["orbit_sizes"] == [1, 11]
    assert certificate["cheap_consistency_controls"] == support_controls
    secant_record = certificate["second_order_secant_closure"]
    assert secant_record["secant_count"] == 66
    assert secant_record["weight_5_points_exhausted"] == 66
    assert secant_record["weight_6_points_exhausted"] == 66
    hadamard_record = certificate["third_order_unpunctured_hadamard_model"]
    assert hadamard_record["weight_distribution"] == {"0": 1, "6": 264, "9": 440, "12": 24}
    assert hadamard_record["hadamard_matrix"] == signs

    for name, matrix in zip(("translation_T", "inversion_S"), generators):
        element = group[matrix_index[matrix]]
        record = certificate["group"]["generator_actions"][name]
        assert record["matrix"] == list(matrix)
        assert record["on_P1"] == list(element[1])
        assert record["on_selected_rows"] == list(element[2])
        assert record["on_code_coordinates"] == list(element[3])

    print("C469 independent replay: PASS")
    print("checked 660 group elements; orbits 11 + two inequivalent 55s; full words 1+11")


if __name__ == "__main__":
    main()
