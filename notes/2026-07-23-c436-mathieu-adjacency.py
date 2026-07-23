#!/usr/bin/env python3
"""Exact C436 stabilizer calculation for the two C379 K_12 factorizations."""

from __future__ import annotations

import argparse
import importlib.util
import json
from collections import deque
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-07-19-c379-clebsch-deep-hole-extension-replay.py"
OUTPUT = HERE / "2026-07-23-c436-mathieu-adjacency.json"


def load_c379():
    spec = importlib.util.spec_from_file_location("c379_replay", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    """Return left after right."""
    return tuple(left[right[index]] for index in range(len(left)))


def permutation_closure(generators: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
    degree = len(next(iter(generators)))
    identity = tuple(range(degree))
    result = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            product = compose(generator, current)
            if product not in result:
                result.add(product)
                queue.append(product)
    return result


def matrix_permutation(module, matrix, vertices, vertex_index):
    return tuple(vertex_index[module.normalize(module.mv(matrix, point))] for point in vertices)


def indexed_factorization(matchings, vertices):
    vertex_index = {point: index for index, point in enumerate(vertices)}
    factors = []
    for matching in matchings:
        factors.append(
            frozenset(
                tuple(sorted(vertex_index[point] for point in edge))
                for edge in matching
            )
        )
    return tuple(sorted(factors, key=lambda factor: tuple(sorted(factor))))


def factor_colours(factorization):
    colours = {}
    for factor_index, factor in enumerate(factorization):
        for edge in factor:
            colours[edge] = factor_index
    assert len(colours) == 66
    return colours


def full_factorization_stabilizer(factorization):
    """Enumerate all vertex permutations preserving the unlabelled factors.

    A partial vertex map forces a partial factor map through edge colours.
    Injectivity of both maps gives an exhaustive, rapidly pruned traversal of
    Sym(12), without assuming that an automorphism is projective.
    """
    colours = factor_colours(factorization)
    degree = 12
    automorphisms = set()

    for image_zero in range(degree):
        vertex_map = {0: image_zero}
        used_vertices = {image_zero}
        factor_map = {}
        used_factors = set()

        def extend(source):
            if source == degree:
                automorphisms.add(tuple(vertex_map[index] for index in range(degree)))
                return
            for target in range(degree):
                if target in used_vertices:
                    continue
                additions = []
                valid = True
                for old_source, old_target in vertex_map.items():
                    source_colour = colours[tuple(sorted((source, old_source)))]
                    target_colour = colours[tuple(sorted((target, old_target)))]
                    if source_colour in factor_map:
                        if factor_map[source_colour] != target_colour:
                            valid = False
                            break
                    elif target_colour in used_factors:
                        valid = False
                        break
                    else:
                        factor_map[source_colour] = target_colour
                        used_factors.add(target_colour)
                        additions.append((source_colour, target_colour))
                if valid:
                    vertex_map[source] = target
                    used_vertices.add(target)
                    extend(source + 1)
                    used_vertices.remove(target)
                    del vertex_map[source]
                for source_colour, target_colour in reversed(additions):
                    del factor_map[source_colour]
                    used_factors.remove(target_colour)

        extend(1)
    return automorphisms


def acts_on_factorization(permutation, factorization):
    image = {
        frozenset(
            tuple(sorted((permutation[left], permutation[right])))
            for left, right in factor
        )
        for factor in factorization
    }
    return image


def encode_factorization(factorization):
    return [[list(edge) for edge in sorted(factor)] for factor in factorization]


def compute():
    module = load_c379()
    plane = module.projective_points()
    conic = frozenset(point for point in plane if module.dot(point, point) == 0)
    plus = module.six_points(8)
    parent_group = module.a5(8)
    pgl_matrices = module.closure(list(parent_group) + [module.J])
    psl_matrices = module.closure(
        [module.commutator(matrix, module.J) for matrix in pgl_matrices]
    )
    arcs = {module.image(matrix, plus) for matrix in pgl_matrices}
    matchings = {
        arc: module.obstruction_matching(arc, conic)
        for arc in arcs
    }
    plus_sheet = {module.image(matrix, plus) for matrix in psl_matrices}
    minus_sheet = arcs - plus_sheet
    assert len(plus_sheet) == len(minus_sheet) == 11

    vertices = tuple(sorted(conic))
    vertex_index = {point: index for index, point in enumerate(vertices)}
    plus_factorization = indexed_factorization(
        [matchings[arc] for arc in plus_sheet], vertices
    )
    minus_factorization = indexed_factorization(
        [matchings[arc] for arc in minus_sheet], vertices
    )

    plus_stabilizer = full_factorization_stabilizer(plus_factorization)
    minus_stabilizer = full_factorization_stabilizer(minus_factorization)
    psl_permutations = {
        matrix_permutation(module, matrix, vertices, vertex_index)
        for matrix in psl_matrices
    }
    pgl_permutations = {
        matrix_permutation(module, matrix, vertices, vertex_index)
        for matrix in pgl_matrices
    }
    j_permutation = matrix_permutation(module, module.J, vertices, vertex_index)

    assert len(psl_permutations) == 660
    assert len(pgl_permutations) == 1320
    assert plus_stabilizer == minus_stabilizer == psl_permutations
    generated_sheet_stabilizers = permutation_closure(
        plus_stabilizer | minus_stabilizer
    )
    generated_with_j = permutation_closure(psl_permutations | {j_permutation})
    assert generated_sheet_stabilizers == psl_permutations
    assert generated_with_j == pgl_permutations
    assert j_permutation not in psl_permutations
    assert acts_on_factorization(j_permutation, plus_factorization) == set(
        minus_factorization
    )
    assert acts_on_factorization(j_permutation, minus_factorization) == set(
        plus_factorization
    )
    transporters_plus_to_minus = {
        compose(j_permutation, permutation)
        for permutation in plus_stabilizer
    }
    assert len(transporters_plus_to_minus) == 660
    assert all(
        acts_on_factorization(permutation, plus_factorization)
        == set(minus_factorization)
        for permutation in transporters_plus_to_minus
    )
    unordered_pair_stabilizer = plus_stabilizer | transporters_plus_to_minus
    assert unordered_pair_stabilizer == pgl_permutations

    return {
        "schema": "othello.c436.mathieu_adjacency.v1",
        "input": {
            "c379_replay": SOURCE.name,
            "field": 11,
            "vertex_set": "Q(F_11), in the frozen C379 normalized projective order",
        },
        "vertex_order": [list(point) for point in vertices],
        "plus_factorization": encode_factorization(plus_factorization),
        "minus_factorization": encode_factorization(minus_factorization),
        "full_sym12_stabilizer_enumeration": {
            "plus_order": len(plus_stabilizer),
            "minus_order": len(minus_stabilizer),
            "intersection_order": len(plus_stabilizer & minus_stabilizer),
            "generated_order": len(generated_sheet_stabilizers),
            "stabilizers_equal": plus_stabilizer == minus_stabilizer,
            "both_equal_recorded_psl2_11": plus_stabilizer == psl_permutations,
        },
        "recorded_j_point_and_edge_action": {
            "vertex_permutation": list(j_permutation),
            "maps_plus_factorization_to_minus": True,
            "maps_minus_factorization_to_plus": True,
            "lies_in_psl2_11": j_permutation in psl_permutations,
            "normalizes_psl2_11": {
                compose(compose(j_permutation, permutation), j_permutation)
                for permutation in psl_permutations
            }
            == psl_permutations,
            "generated_with_psl2_11_order": len(generated_with_j),
            "generated_with_psl2_11_equals_recorded_pgl2_11": (
                generated_with_j == pgl_permutations
            ),
            "full_sym12_transporter_coset_order": len(
                transporters_plus_to_minus
            ),
            "unordered_factorization_pair_stabilizer_order": len(
                unordered_pair_stabilizer
            ),
            "unordered_factorization_pair_stabilizer_equals_recorded_pgl2_11": (
                unordered_pair_stabilizer == pgl_permutations
            ),
        },
        "verdict": {
            "two_sheet_stabilizers_generate": "PSL_2(11)",
            "psl2_11_plus_recorded_j_generate": "PGL_2(11)",
            "reaches_M_12": False,
            "task_equivalence_holds": False,
            "reason": (
                "J exchanges the two structures but normalizes their common "
                "PSL_2(11) stabilizer; conjugating a stabilizer by J does not "
                "produce a second subgroup."
            ),
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    result = compute()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(encoded)
    else:
        assert OUTPUT.read_text() == encoded
    print(
        "C436 OK:",
        result["verdict"]["two_sheet_stabilizers_generate"],
        "; with J:",
        result["verdict"]["psl2_11_plus_recorded_j_generate"],
    )


if __name__ == "__main__":
    main()
