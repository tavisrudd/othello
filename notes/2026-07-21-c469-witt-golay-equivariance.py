#!/usr/bin/env python3
"""Generate the exact C469 PSL(2,11) orbit certificate."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from collections import Counter, deque
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
NOTES = ROOT / "notes"
OUT = NOTES / "2026-07-21-c469-witt-golay-equivariance.json"
INPUT_HASHES = {
    "notes/2026-07-21-c450-weil-cross-sheet.json":
        "a6fc2d854732011c82b6b5c1440b407b64041bd31f4bac59adec15c1f127353f",
    "notes/2026-07-21-c452-qr-barker.json":
        "6f5829b2de929bfa40f5c6c657896e58fd26f9c2157bde89b7387757b4f887c2",
    "notes/2026-07-21-c464-perfect-code-spans.json":
        "5d2aa612ebab289845af1e244d26c9dd55ff9b57393b61276a51d18cb737115b",
}
Q = 11
P = 3


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def verify_inputs() -> dict[str, dict[str, object]]:
    answer = {}
    for name, expected in INPUT_HASHES.items():
        path = ROOT / name
        actual = sha256(path)
        if actual != expected:
            raise RuntimeError(f"input hash drift for {name}: {actual} != {expected}")
        answer[name] = {"bytes": path.stat().st_size, "sha256": actual}
    return answer


def normalize_matrix(g: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    values = tuple(x % Q for x in g)
    first = next(x for x in values if x)
    inverse = pow(first, -1, Q)
    return tuple(x * inverse % Q for x in values)


def determinant(g: tuple[int, int, int, int]) -> int:
    a, b, c, d = g
    return (a * d - b * c) % Q


def multiply(g, h):
    a, b, c, d = g
    e, f, i, j = h
    return normalize_matrix((a * e + b * i, a * f + b * j,
                             c * e + d * i, c * f + d * j))


def inverse_matrix(g):
    a, b, c, d = g
    return normalize_matrix((d, -b, -c, a))


def act_point(g, x: int) -> int:
    a, b, c, d = g
    if x == Q:
        return Q if c == 0 else a * pow(c, -1, Q) % Q
    denominator = (c * x + d) % Q
    return Q if denominator == 0 else (a * x + b) * pow(denominator, -1, Q) % Q


def point_permutation(g):
    return tuple(act_point(g, x) for x in range(Q + 1))


def canon_matching(matching):
    return tuple(sorted(tuple(sorted((int(a), int(b)))) for a, b in matching))


def act_matching(permutation, matching):
    return canon_matching((permutation[a], permutation[b]) for a, b in matching)


def induced_matching_permutation(permutation, objects):
    index = {obj: i for i, obj in enumerate(objects)}
    return tuple(index[act_matching(permutation, obj)] for obj in objects)


def act_subset(permutation, subset):
    return tuple(sorted(permutation[i] for i in subset))


def act_edge(permutation, edge):
    return tuple(sorted((permutation[edge[0]], permutation[edge[1]])))


def act_pair(row_permutation, column_permutation, pair):
    return row_permutation[pair[0]], column_permutation[pair[1]]


def act_word(permutation, word):
    target = [0] * len(word)
    for old, value in enumerate(word):
        target[permutation[old]] = value
    first = next(value for value in target if value)
    inverse = pow(first, -1, P)
    return tuple(value * inverse % P for value in target)


def permutation_order(permutation):
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


def subgroup_orbits(member_ids, permutations):
    unseen = set(range(len(permutations[0])))
    sizes = []
    while unseen:
        base = min(unseen)
        orbit = {permutations[k][base] for k in member_ids}
        unseen -= orbit
        sizes.append(len(orbit))
    return sorted(sizes)


def object_orbits(objects, elements, action):
    unseen = set(objects)
    answer = []
    while unseen:
        base = min(unseen)
        orbit = {action(element, base) for element in elements}
        unseen -= orbit
        answer.append(sorted(orbit))
    return sorted(answer, key=lambda orbit: (len(orbit), orbit))


def stabilizer_ids(elements, action, obj):
    return [k for k, element in enumerate(elements) if action(element, obj) == obj]


def order_histogram(member_ids, point_permutations):
    return {str(order): count for order, count in
            sorted(Counter(permutation_order(point_permutations[k]) for k in member_ids).items())}


def enumerate_code(generator):
    for coefficients in itertools.product(range(P), repeat=len(generator)):
        yield tuple(sum(coefficients[row] * generator[row][column]
                        for row in range(len(generator))) % P
                    for column in range(len(generator[0])))


def projectivize(word):
    first = next(value for value in word if value)
    inverse = pow(first, -1, P)
    return tuple(value * inverse % P for value in word)


def build() -> dict[str, object]:
    inputs = verify_inputs()
    c450 = json.loads((NOTES / "2026-07-21-c450-weil-cross-sheet.json").read_text())
    c452 = json.loads((NOTES / "2026-07-21-c452-qr-barker.json").read_text())
    c464 = json.loads((NOTES / "2026-07-21-c464-perfect-code-spans.json").read_text())
    c452_case = next(case for case in c452["cases"] if case["q"] == Q)
    c464_case = next(case for case in c464["cases"] if case["q"] == Q)
    c450_case = next(case for case in c450["finite_actions"] if case["q"] == Q)

    sheets = [[canon_matching(matching) for matching in sheet]
              for sheet in c452_case["sheets"]]
    if sheets != [[canon_matching(matching) for matching in sheet]
                  for sheet in c452_case["sheets"]]:
        raise AssertionError("noncanonical matching input")
    sheet_indices = [{matching: i for i, matching in enumerate(sheet)} for sheet in sheets]

    squares = {x * x % Q for x in range(1, Q)}
    matrices = sorted({normalize_matrix(g) for g in itertools.product(range(Q), repeat=4)
                       if determinant(g)})
    psl = [g for g in matrices if determinant(g) in squares]
    if len(matrices) != 1320 or len(psl) != 660:
        raise AssertionError("PGL/PSL order failure")
    matrix_index = {g: i for i, g in enumerate(psl)}

    elements = []
    for g in psl:
        points = point_permutation(g)
        sheet_permutations = [induced_matching_permutation(points, sheet) for sheet in sheets]
        elements.append({"matrix": g, "points": points,
                         "rows": sheet_permutations[0], "coordinates": sheet_permutations[1]})

    generator_matrices = {
        "translation_T": normalize_matrix((1, 1, 0, 1)),
        "inversion_S": normalize_matrix((0, -1, 1, 0)),
    }
    generator_ids = {name: matrix_index[g] for name, g in generator_matrices.items()}
    generated = {normalize_matrix((1, 0, 0, 1))}
    queue = deque(generated)
    while queue:
        current = queue.popleft()
        for generator in generator_matrices.values():
            target = multiply(generator, current)
            if target not in generated:
                generated.add(target)
                queue.append(target)
    if generated != set(psl):
        raise AssertionError("S,T do not generate the frozen PSL(2,11)")

    incidence = c464_case["relations"]["disjoint"]["incidence_matrix"]
    direct_incidence = [[int(not (set(left) & set(right))) for right in sheets[1]]
                        for left in sheets[0]]
    if incidence != direct_incidence or incidence != c452_case["cross_disjointness_matrix"]:
        raise AssertionError("C450/C452/C464 incidence convention mismatch")

    selected = [tuple(i for i, value in enumerate(row) if value) for row in incidence]
    selected_index = {support: i for i, support in enumerate(selected)}
    if not all(act_subset(element["coordinates"], selected[row]) ==
               selected[element["rows"][row]]
               for element in elements for row in range(Q)):
        raise AssertionError("selected-support equivariance failed")

    edge_records = c464_case["third_order_minimum_support_structure"][
        "k11_edge_to_residual_support"]
    edge_support = {tuple(record["row_pair"]): tuple(record["residual_support"])
                    for record in edge_records}
    edges = sorted(edge_support)
    if len(edges) != 55 or not all(
        act_subset(element["coordinates"], edge_support[edge]) ==
        edge_support[act_edge(element["rows"], edge)]
        for element in elements for edge in edges
    ):
        raise AssertionError("residual edge/support equivariance failed")

    relation_pairs = [(row, column) for row in range(Q) for column in range(Q)
                      if incidence[row][column]]
    if len(relation_pairs) != c450_case["relations"]["disjoint"]["support_size"] != 0:
        raise AssertionError("C450 disjoint relation size mismatch")

    edge_action = lambda element, edge: act_edge(element["rows"], edge)
    pair_action = lambda element, pair: act_pair(element["rows"], element["coordinates"], pair)
    selected_action = lambda element, support: act_subset(element["coordinates"], support)
    point_action = lambda element, point: element["points"][point]
    edge_anchor = edges[0]
    edge_stabilizer = stabilizer_ids(elements, edge_action, edge_anchor)
    pair_stabilizers = {pair: stabilizer_ids(elements, pair_action, pair)
                        for pair in relation_pairs}
    exact_pair_hits = [pair for pair, stabilizer in pair_stabilizers.items()
                       if stabilizer == edge_stabilizer]

    source_partition = {
        "sheet_0": subgroup_orbits(edge_stabilizer, [element["rows"] for element in elements]),
        "sheet_1": subgroup_orbits(edge_stabilizer,
                                    [element["coordinates"] for element in elements]),
    }
    pair_anchor = relation_pairs[0]
    pair_stabilizer = pair_stabilizers[pair_anchor]
    target_partition = {
        "sheet_0": subgroup_orbits(pair_stabilizer, [element["rows"] for element in elements]),
        "sheet_1": subgroup_orbits(pair_stabilizer,
                                    [element["coordinates"] for element in elements]),
    }
    if exact_pair_hits or source_partition == target_partition:
        raise AssertionError("expected inequivalent order-12 stabilizers were not separated")

    # Test the frozen nonsquare outer element as a possible rescue of the 55-set bridge.
    outer = normalize_matrix((1, 10, 1, 1))
    outer_inverse = inverse_matrix(outer)
    alpha = {k: matrix_index[multiply(multiply(outer, g), outer_inverse)]
             for k, g in enumerate(psl)}
    twisted_edge_stabilizer = sorted(alpha[k] for k in edge_stabilizer)
    twisted_hits = [pair for pair, stabilizer in pair_stabilizers.items()
                    if stabilizer == twisted_edge_stabilizer]

    generator_matrix = c464_case["relations"]["disjoint"]["generator_matrix_rref"]
    codewords = list(enumerate_code(generator_matrix))
    full_words = sorted({projectivize(word) for word in codewords if all(word)})
    if len(full_words) != 12:
        raise AssertionError("full-support projective census drift")
    full_word_index = {word: i for i, word in enumerate(full_words)}
    if not all(act_word(element["coordinates"], word) in full_word_index
               for element in elements for word in full_words):
        raise AssertionError("full-support words are not PSL-invariant")
    word_action = lambda element, word: act_word(element["coordinates"], word)
    word_orbits = object_orbits(full_words, elements, word_action)
    if sorted(map(len, word_orbits)) != [1, 11]:
        raise AssertionError("full-support orbit decomposition is not 1+11")
    fixed_word = word_orbits[0][0]
    moving_word_anchor = word_orbits[1][0]
    fixed_word_stabilizer = stabilizer_ids(elements, word_action, fixed_word)
    moving_word_stabilizer = stabilizer_ids(elements, word_action, moving_word_anchor)

    selected_stabilizers = {
        support: stabilizer_ids(elements, selected_action, support) for support in selected
    }
    selected_hits = [support for support, stabilizer in selected_stabilizers.items()
                     if stabilizer == moving_word_stabilizer]
    if len(selected_hits) != 1:
        raise AssertionError("moving full-word orbit lacks a unique selected-block anchor")
    selected_word_anchor = selected_hits[0]
    word_to_selected = {}
    for element in elements:
        word = word_action(element, moving_word_anchor)
        support = selected_action(element, selected_word_anchor)
        previous = word_to_selected.setdefault(word, support)
        if previous != support:
            raise AssertionError("word/selected-block map is not well defined")
    if len(word_to_selected) != 11:
        raise AssertionError("word/selected-block map is not bijective")
    affine_word_formula = {
        projectivize(tuple((1 + value) % P for value in incidence[row])): selected[row]
        for row in range(Q)
    }
    if affine_word_formula != word_to_selected:
        raise AssertionError("[1+row_i] does not give the moving full-support orbit")
    minority_formula = {}
    for word, support in word_to_selected.items():
        symbol_supports = {
            symbol: tuple(i for i, value in enumerate(word) if value == symbol)
            for symbol in (1, 2)
        }
        minority_symbol = min(symbol_supports, key=lambda symbol: len(symbol_supports[symbol]))
        if len(symbol_supports[minority_symbol]) != 5 or symbol_supports[minority_symbol] != support:
            raise AssertionError("minority-symbol support does not recover the selected block")
        minority_formula[word] = minority_symbol

    point_stabilizer = stabilizer_ids(elements, point_action, 0)
    if len(point_stabilizer) != 55:
        raise AssertionError("natural P1 stabilizer order drift")

    projective_by_weight = {}
    for word in codewords:
        if not any(word):
            continue
        weight = sum(value != 0 for value in word)
        projective_by_weight.setdefault(weight, set()).add(projectivize(word))
    consistency = {}
    for weight in (5, 6, 8, 9):
        words = sorted(projective_by_weight[weight])
        supports = sorted({tuple(i for i, value in enumerate(word) if value) for word in words})
        orbits = object_orbits(supports, elements,
                               lambda element, support: act_subset(element["coordinates"], support))
        consistency[str(weight)] = {
            "projective_word_count": len(words),
            "support_count": len(supports),
            "support_orbit_sizes": sorted(map(len, orbits)),
            "all_generator_images_remain_in_family": all(
                act_subset(elements[generator_id]["coordinates"], support) in set(supports)
                for generator_id in generator_ids.values() for support in supports),
        }

    full_representatives = [tuple([1] * Q)] + [
        tuple((1 + value) % P for value in incidence[row]) for row in range(Q)
    ]
    if {projectivize(word) for word in full_representatives} != set(full_words):
        raise AssertionError("affine representatives do not exhaust the 12 full-support points")
    secants = []
    secant_weight5 = set()
    secant_weight6 = set()
    for left, right in itertools.combinations(range(12), 2):
        a, b = full_representatives[left], full_representatives[right]
        interior = [
            projectivize(tuple((x + y) % P for x, y in zip(a, b))),
            projectivize(tuple((x - y) % P for x, y in zip(a, b))),
        ]
        by_weight = {sum(value != 0 for value in word): word for word in interior}
        if set(by_weight) != {5, 6}:
            raise AssertionError("a full-support secant does not contain weights 5 and 6")
        weight5_support = tuple(i for i, value in enumerate(by_weight[5]) if value)
        weight6_support = tuple(i for i, value in enumerate(by_weight[6]) if value)
        expected = selected[right - 1] if left == 0 else edge_support[(left - 1, right - 1)]
        if weight5_support != expected or set(weight5_support) | set(weight6_support) != set(range(Q)):
            raise AssertionError("secant/Witt support dictionary failed")
        secant_weight5.add(by_weight[5])
        secant_weight6.add(by_weight[6])
        secants.append({
            "point_pair": [left, right],
            "pair_type": "fixed_to_moving" if left == 0 else "moving_to_moving",
            "weight_5_projective_word": list(by_weight[5]),
            "weight_5_support": list(weight5_support),
            "weight_6_projective_word": list(by_weight[6]),
            "weight_6_support": list(weight6_support),
        })
    if secant_weight5 != projective_by_weight[5] or secant_weight6 != projective_by_weight[6]:
        raise AssertionError("the 66 secants do not exhaust weights 5 and 6")

    extended_generator = [row + [(-sum(row)) % P] for row in generator_matrix]
    extended_codewords = list(enumerate_code(extended_generator))
    extended_distribution = Counter(sum(value != 0 for value in word)
                                    for word in extended_codewords)
    if extended_distribution != {0: 1, 6: 264, 9: 440, 12: 24}:
        raise AssertionError("extended weight distribution drift")
    if not all(sum(x * y for x, y in zip(left, right)) % P == 0
               for left in extended_generator for right in extended_generator):
        raise AssertionError("parity extension is not self-orthogonal")
    extended_representatives = [
        word + ((-sum(word)) % P,) for word in full_representatives
    ]
    if not all(all(word) for word in extended_representatives):
        raise AssertionError("a full-support representative did not extend to weight 12")
    hadamard = [[1 if value == 1 else -1 for value in word]
                for word in extended_representatives]
    hadamard_gram = [[sum(x * y for x, y in zip(left, right))
                      for right in hadamard] for left in hadamard]
    if hadamard_gram != [[12 if i == j else 0 for j in range(12)] for i in range(12)]:
        raise AssertionError("extended full-support representatives are not Hadamard rows")
    extended_projective_by_weight = {}
    for word in extended_codewords:
        if any(word):
            extended_projective_by_weight.setdefault(
                sum(value != 0 for value in word), set()).add(projectivize(word))
    if {projectivize(word) for word in extended_representatives} != \
            extended_projective_by_weight[12]:
        raise AssertionError("Hadamard rows do not exhaust projective weight-12 words")
    extended_secant_minimum = set()
    for left, right in itertools.combinations(range(12), 2):
        a, b = extended_representatives[left], extended_representatives[right]
        for word in (
            projectivize(tuple((x + y) % P for x, y in zip(a, b))),
            projectivize(tuple((x - y) % P for x, y in zip(a, b))),
        ):
            if sum(value != 0 for value in word) != 6:
                raise AssertionError("extended Hadamard secant has nonminimum interior point")
            extended_secant_minimum.add(word)
    if extended_secant_minimum != extended_projective_by_weight[6]:
        raise AssertionError("Hadamard secants do not exhaust extended minimum words")

    generator_actions = {}
    edge_index = {edge: i for i, edge in enumerate(edges)}
    pair_index = {pair: i for i, pair in enumerate(relation_pairs)}
    for name, generator_id in generator_ids.items():
        element = elements[generator_id]
        generator_actions[name] = {
            "matrix": list(element["matrix"]),
            "on_P1": list(element["points"]),
            "on_selected_rows": list(element["rows"]),
            "on_code_coordinates": list(element["coordinates"]),
            "on_residual_edges": [edge_index[edge_action(element, edge)] for edge in edges],
            "on_C450_disjoint_pairs": [pair_index[pair_action(element, pair)]
                                        for pair in relation_pairs],
            "on_full_support_projective_words": [full_word_index[word_action(element, word)]
                                                   for word in full_words],
        }

    return {
        "schema": "c469-witt-golay-equivariance-v1",
        "task": "C469",
        "verdict": {
            "selected_weight_five_G_over_A5": "proved",
            "residual_edges_to_C450_disjoint_G_over_A4": "dead: residual edges have D12 stabilizer, while C450 disjoint pairs have A4 stabilizer",
            "full_support_words_G_over_11_colon_5": "dead: the orbit decomposition is 1+11, not 12",
            "replacement": "full-support projective words = 1 + G/A5; residual supports form G/D12, not G/A4",
        },
        "inputs": inputs,
        "group": {
            "name": "PSL_2(11)",
            "order": len(elements),
            "PGL_2_11_order": len(matrices),
            "point_convention": "0,...,10,infinity=11",
            "matrix_convention": "first-nonzero-entry normalized projective 2x2 matrices",
            "action_convention": "permutations list old index -> new index",
            "generators_generate_all_660_elements": True,
            "generator_actions": generator_actions,
        },
        "object_orders": {
            "selected_supports": [list(support) for support in selected],
            "residual_edges": [list(edge) for edge in edges],
            "C450_disjoint_pairs": [list(pair) for pair in relation_pairs],
            "full_support_projective_words": [list(word) for word in full_words],
        },
        "selected_weight_five_orbit": {
            "disposition": "proved",
            "orbit_size": 11,
            "anchor_row": selected_index[selected[0]],
            "anchor_support": list(selected[0]),
            "stabilizer_order": len(selected_stabilizers[selected[0]]),
            "stabilizer_member_ids": selected_stabilizers[selected[0]],
            "stabilizer_element_order_histogram": order_histogram(
                selected_stabilizers[selected[0]], [element["points"] for element in elements]),
            "stabilizer_type": "A5",
            "all_660_elements_equivariant": True,
            "witt_restriction_statement": "the 66 minimum supports restrict as the proved 11-orbit plus the proved residual 55-orbit; only the proposed identification of that 55-orbit with C450 is dead",
        },
        "residual_55_comparison": {
            "disposition": "dead for literal PSL2(11)-equivariance",
            "source_anchor_edge": list(edge_anchor),
            "source_anchor_support": list(edge_support[edge_anchor]),
            "source_stabilizer_order": len(edge_stabilizer),
            "source_stabilizer_member_ids": edge_stabilizer,
            "source_stabilizer_element_order_histogram": order_histogram(
                edge_stabilizer, [element["points"] for element in elements]),
            "source_stabilizer_orbits_on_sheets": source_partition,
            "target_anchor_pair": list(pair_anchor),
            "target_stabilizer_order": len(pair_stabilizer),
            "target_stabilizer_member_ids": pair_stabilizer,
            "target_stabilizer_element_order_histogram": order_histogram(
                pair_stabilizer, [element["points"] for element in elements]),
            "target_stabilizer_orbits_on_sheets": target_partition,
            "source_stabilizer_type": "D12 (dihedral group of order 12)",
            "target_stabilizer_type": "A4",
            "exhaustive_target_stabilizers_compared": len(pair_stabilizers),
            "exact_stabilizer_matches": len(exact_pair_hits),
            "decisive_obstruction": "the order spectra D12: 1,2^7,3^2,6^2 and A4: 1,2^3,3^8 differ; the sheet-orbit partitions 2+3+6 versus 1+4+6 give a second obstruction",
            "frozen_outer_twist_control": {
                "outer_matrix_Rz": list(outer),
                "determinant_squareclass": determinant(outer),
                "target_stabilizer_matches_after_twisting_source": len(twisted_hits),
                "disposition": "dead: this outer automorphism does not rescue the bridge",
            },
        },
        "full_support_projective_words": {
            "disposition": "dead for G/(C11:C5); proved replacement 1+G/A5",
            "projective_word_count": len(full_words),
            "orbit_sizes": sorted(map(len, word_orbits)),
            "fixed_word": list(fixed_word),
            "fixed_word_stabilizer_order": len(fixed_word_stabilizer),
            "moving_anchor_word": list(moving_word_anchor),
            "moving_stabilizer_order": len(moving_word_stabilizer),
            "moving_stabilizer_member_ids": moving_word_stabilizer,
            "moving_stabilizer_element_order_histogram": order_histogram(
                moving_word_stabilizer, [element["points"] for element in elements]),
            "moving_stabilizer_type": "A5",
            "natural_P1_point_stabilizer_order": len(point_stabilizer),
            "natural_P1_point_stabilizer_element_order_histogram": order_histogram(
                point_stabilizer, [element["points"] for element in elements]),
            "selected_block_anchor": list(selected_word_anchor),
            "moving_word_to_selected_block": [
                {"word": list(word), "minority_symbol": minority_formula[word],
                 "selected_support": list(word_to_selected[word])}
                for word in sorted(word_to_selected)
            ],
            "affine_row_formula": "the moving orbit is exactly {[1 + r_i] : i=0,...,10}, with projective scalar classes over F_3",
            "affine_row_formula_table": [
                {"row": row,
                 "projective_word": list(projectivize(tuple((1 + value) % P
                                                             for value in incidence[row]))),
                 "selected_support": list(selected[row])}
                for row in range(Q)
            ],
            "intrinsic_map_formula": "for each nonconstant projective full-support word, the positions of its minority nonzero symbol form the associated selected Witt block",
            "all_660_elements_equivariant": True,
        },
        "second_order_secant_closure": {
            "disposition": "proved",
            "full_support_point_orbits": [1, 11],
            "secant_count": len(secants),
            "secant_orbit_sizes": [11, 55],
            "fixed_to_moving_secants": 11,
            "moving_to_moving_secants": 55,
            "weight_5_points_exhausted": len(secant_weight5),
            "weight_6_points_exhausted": len(secant_weight6),
            "affine_identities": {
                "fixed_to_moving": "the line through [1] and [1+r_i] contains [r_i] and its weight-6 complement",
                "moving_to_moving": "[1+r_i]+[1+r_j]=-[1-r_i-r_j], giving the residual weight-5 point; the fourth point is its weight-6 complement",
            },
            "secants": secants,
        },
        "third_order_unpunctured_hadamard_model": {
            "disposition": "proved without a larger automorphism-group claim",
            "extension_rule": "append c_12=-sum(c_1,...,c_11) over F_3",
            "parameters": {"length": 12, "dimension": 6, "minimum_distance": 6},
            "self_dual": True,
            "weight_distribution": {str(weight): count for weight, count in
                                    sorted(extended_distribution.items())},
            "projective_weight_12_count": len(extended_projective_by_weight[12]),
            "projective_weight_6_count": len(extended_projective_by_weight[6]),
            "hadamard_sign_rule": "1 -> +1, 2 -> -1",
            "hadamard_matrix": hadamard,
            "hadamard_gram": hadamard_gram,
            "all_12_weight_12_points_are_hadamard_rows": True,
            "all_132_projective_weight_6_points_are_secant_interior_points": True,
            "larger_M11_or_M12_symmetry_claimed": False,
        },
        "cheap_consistency_controls": consistency,
        "scope": {
            "larger_automorphism_group_claimed": False,
            "M11_claimed": False,
            "PSL2_11_only": True,
            "weights_6_8_9_used_only_as_invariance_and_orbit_size_controls": True,
        },
    }


def canonical_bytes(payload) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(build())
    if args.check:
        if not OUT.exists() or OUT.read_bytes() != data:
            raise SystemExit("C469 certificate is stale; regenerate without --check")
        print("C469 certificate check: PASS")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(data)} bytes)")


if __name__ == "__main__":
    main()
