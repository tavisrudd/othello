#!/usr/bin/env python3
"""Exact automorphism and chirality certificate for C373's q=11 scheme."""

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
OUTPUT = ROOT / "2026-07-19-c373-clebsch-scheme-automorphisms.json"
C341_PATH = ROOT / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"


def load_c341():
    assert hashlib.sha256(C341_PATH.read_bytes()).hexdigest() == C341_SHA256
    spec = importlib.util.spec_from_file_location("c341_for_c373", C341_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def split_singleton(cells: list[list[int]], point: int) -> list[list[int]]:
    result: list[list[int]] = []
    for cell in cells:
        if point not in cell:
            result.append(cell)
        else:
            result.append([point])
            remainder = [entry for entry in cell if entry != point]
            if remainder:
                result.append(remainder)
    return result


def equitable_refinement(
    color_rows: list[bytes], cells: list[list[int]], individualized: tuple[int, ...]
) -> list[list[int]]:
    """Refine by all color-to-cell neighbor counts, preserving old cell labels."""
    vertex_count = len(color_rows)
    cells = [sorted(cell) for cell in cells]
    for point in individualized:
        cells = split_singleton(cells, point)

    while len(cells) < vertex_count:
        cell_of = [0] * vertex_count
        for cell_index, cell in enumerate(cells):
            for point in cell:
                cell_of[point] = cell_index

        buckets: dict[tuple[object, ...], list[int]] = {}
        for old_cell, cell in enumerate(cells):
            for point in cell:
                counts = [[0] * 8 for _ in cells]
                for neighbor, color in enumerate(color_rows[point]):
                    counts[cell_of[neighbor]][color] += 1
                signature = (old_cell, tuple(tuple(row) for row in counts))
                buckets.setdefault(signature, []).append(point)

        refined = [sorted(buckets[key]) for key in sorted(buckets)]
        if len(refined) == len(cells):
            return refined
        cells = refined
    return cells


def cell_profile(cells: list[list[int]]) -> dict[str, object]:
    histogram = Counter(map(len, cells))
    return {
        "cell_count": len(cells),
        "cell_size_histogram": {str(size): histogram[size] for size in sorted(histogram)},
        "largest_cell": max(map(len, cells)),
        "vertex_count": sum(map(len, cells)),
    }


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def inverse_permutation(permutation: tuple[int, ...]) -> tuple[int, ...]:
    inverse = [0] * len(permutation)
    for index, image in enumerate(permutation):
        inverse[image] = index
    return tuple(inverse)


def set_orbits(group: set[tuple[int, ...]], size: int) -> list[set[tuple[int, ...]]]:
    unseen = set(itertools.combinations(range(6), size))
    orbits: list[set[tuple[int, ...]]] = []
    while unseen:
        seed = min(unseen)
        orbit = {
            tuple(sorted(permutation[index] for index in seed)) for permutation in group
        }
        unseen -= orbit
        orbits.append(orbit)
    return sorted(orbits, key=lambda orbit: min(orbit))


def column_components(
    column_neighbors: set[int], color_rows: list[bytes]
) -> list[list[int]]:
    unseen = set(column_neighbors)
    components: list[list[int]] = []
    while unseen:
        seed = min(unseen)
        component = {seed}
        queue = deque([seed])
        while queue:
            point = queue.popleft()
            new = {other for other in unseen if color_rows[point][other] == 1}
            unseen -= new
            component |= new
            queue.extend(new)
        components.append(sorted(component))
    return sorted(components)


def certificate() -> dict[str, object]:
    c341 = load_c341()
    q, tau = 11, 8
    roots = c341.h3_roots(q, tau)
    columns = c341.six_points(q, tau)
    projective_group = c341.reflection_group(q, roots)
    labelled = c341.label_orbits(
        c341.vector_orbits(projective_group, q), roots, columns, q
    )
    labels = [label for label, _ in labelled]
    classes = [orbit for _, orbit in labelled]
    class_of = {vector: index for index, orbit in enumerate(classes) for vector in orbit}
    vectors = c341.all_vectors(q)
    vector_index = {vector: index for index, vector in enumerate(vectors)}

    color_rows = [
        bytes(
            class_of[
                tuple((right[coordinate] - left[coordinate]) % q for coordinate in range(3))
            ]
            for right in vectors
        )
        for left in vectors
    ]
    assert all(color_rows[x][y] == color_rows[y][x] for x in range(1331) for y in range(1331))
    column_graph_rows = [
        bytes(0 if x == y else 1 if color_rows[x][y] == 1 else 2 for y in range(1331))
        for x in range(1331)
    ]

    # Full algebraic automorphism group: exhaust all 7! permutations fixing the diagonal color.
    tensor = c341.intersection_tensor(classes, q)
    algebraic_automorphisms: list[tuple[int, ...]] = []
    for tail in itertools.permutations(range(1, 8)):
        permutation = (0,) + tail
        if all(
            tensor[permutation[k]][permutation[i]][permutation[j]] == tensor[k][i][j]
            for k in range(8)
            for i in range(8)
            for j in range(8)
        ):
            algebraic_automorphisms.append(permutation)
    assert algebraic_automorphisms == [tuple(range(8))]

    # Individualization/refinement gives a rigorous upper bound on the vertex group.
    zero_index = vector_index[(0, 0, 0)]
    column_base = min(classes[1])
    column_base_index = vector_index[column_base]
    second_base = (1, 0, 9)
    second_base_index = vector_index[second_base]
    cells0 = equitable_refinement(color_rows, [list(range(1331))], (zero_index,))
    column_cell_size = next(len(cell) for cell in cells0 if column_base_index in cell)
    cells1 = equitable_refinement(color_rows, cells0, (column_base_index,))
    second_cell_size = next(len(cell) for cell in cells1 if second_base_index in cell)
    cells2 = equitable_refinement(color_rows, cells1, (second_base_index,))
    assert column_cell_size == 60 and second_cell_size == 10
    assert len(cells2) == 1331 and all(len(cell) == 1 for cell in cells2)
    refinement_upper_bound = 1331 * column_cell_size * second_cell_size

    # The canonically distinguished valency-60 column graph alone gives the same sharp bound.
    graph_cells0 = equitable_refinement(
        column_graph_rows, [list(range(1331))], (zero_index,)
    )
    graph_column_cell_size = next(
        len(cell) for cell in graph_cells0 if column_base_index in cell
    )
    graph_cells1 = equitable_refinement(
        column_graph_rows, graph_cells0, (column_base_index,)
    )
    graph_second_cell_size = next(
        len(cell) for cell in graph_cells1 if second_base_index in cell
    )
    graph_cells2 = equitable_refinement(
        column_graph_rows, graph_cells1, (second_base_index,)
    )
    assert graph_column_cell_size == 60 and graph_second_cell_size == 10
    assert len(graph_cells2) == 1331 and all(len(cell) == 1 for cell in graph_cells2)
    assert 1331 * graph_column_cell_size * graph_second_cell_size == refinement_upper_bound

    # The known affine group attains the bound and preserves every relation color.
    linear_group = {
        tuple(tuple(scale * value % q for value in row) for row in matrix)
        for matrix in projective_group
        for scale in range(1, q)
    }
    assert len(projective_group) == 60 and len(linear_group) == 600
    for matrix in linear_group:
        assert all(
            class_of[c341.mat_vec(matrix, vector, q)] == class_of[vector]
            for vector in vectors
        )
    stabilizer1 = {
        matrix for matrix in linear_group if c341.mat_vec(matrix, column_base, q) == column_base
    }
    stabilizer2 = {
        matrix for matrix in stabilizer1 if c341.mat_vec(matrix, second_base, q) == second_base
    }
    assert len(stabilizer1) == 10 and len(stabilizer2) == 1
    assert len({c341.mat_vec(matrix, column_base, q) for matrix in linear_group}) == 60
    assert len({c341.mat_vec(matrix, second_base, q) for matrix in stabilizer1}) == 10
    affine_group_order = q**3 * len(linear_group)
    assert affine_group_order == refinement_upper_bound == 798600
    assert affine_group_order // q**3 == 600 and 600 % q != 0

    # The column neighborhood intrinsically splits into the six scalar-line blocks.
    column_neighbor_indices = {vector_index[vector] for vector in classes[1]}
    components = column_components(column_neighbor_indices, color_rows)
    expected_components = {
        frozenset(
            vector_index[tuple(scale * coordinate % q for coordinate in column)]
            for scale in range(1, q)
        )
        for column in columns
    }
    assert {frozenset(component) for component in components} == expected_components
    assert sorted(map(len, components)) == [10] * 6

    ordered_columns = sorted(columns)
    column_index = {column: index for index, column in enumerate(ordered_columns)}
    induced_a5 = {
        tuple(
            column_index[c341.normalize(c341.mat_vec(matrix, column, q), q)]
            for column in ordered_columns
        )
        for matrix in projective_group
    }
    assert len(induced_a5) == 60
    triple_orbits = set_orbits(induced_a5, 3)
    assert sorted(map(len, triple_orbits)) == [10, 10]

    # Exhaust S6: the abstract normalizer is S5, and its outer coset exchanges chirality.
    s6 = set(itertools.permutations(range(6)))
    normalizer = set()
    for permutation in s6:
        inverse = inverse_permutation(permutation)
        conjugate = {
            compose(compose(permutation, group_element), inverse)
            for group_element in induced_a5
        }
        if conjugate == induced_a5:
            normalizer.add(permutation)
    outer_coset = normalizer - induced_a5
    assert len(normalizer) == 120 and len(outer_coset) == 60
    chirality_class = {triple: index for index, orbit in enumerate(triple_orbits) for triple in orbit}
    assert all(
        {
            chirality_class[tuple(sorted(permutation[index] for index in triple))]
            for triple in triple_orbits[0]
        }
        == {1}
        for permutation in outer_coset
    )

    return {
        "schema": "c373-clebsch-scheme-automorphisms-v1",
        "inputs": {
            "c341_checker_sha256": C341_SHA256,
            "field_order": q,
            "relation_labels": labels,
        },
        "algebraic_automorphism_group": {
            "candidate_relation_permutations_checked": 5040,
            "order": len(algebraic_automorphisms),
            "permutations": [list(permutation) for permutation in algebraic_automorphisms],
        },
        "color_preserving_vertex_group": {
            "affine_group_order": affine_group_order,
            "linear_point_stabilizer_order": len(linear_group),
            "projective_factor_order": len(projective_group),
            "scalar_kernel_order": q - 1,
            "structure": "F_11^3 semidirect (F_11^* x A5)",
            "base_vectors": [[0, 0, 0], list(column_base), list(second_base)],
            "successive_upper_bound_factors": [1331, column_cell_size, second_cell_size],
            "successive_known_stabilizer_orders": [affine_group_order, 600, 10, 1],
            "refinement_profiles": [
                cell_profile(cells0),
                cell_profile(cells1),
                cell_profile(cells2),
            ],
        },
        "column_graph_alone": {
            "automorphism_group_order": affine_group_order,
            "equals_full_scheme_automorphism_group": True,
            "successive_upper_bound_factors": [
                1331,
                graph_column_cell_size,
                graph_second_cell_size,
            ],
            "refinement_profiles": [
                cell_profile(graph_cells0),
                cell_profile(graph_cells1),
                cell_profile(graph_cells2),
            ],
        },
        "intrinsic_chirality": {
            "column_neighbor_component_sizes": sorted(map(len, components)),
            "induced_group_on_six_blocks_order": len(induced_a5),
            "three_subset_orbit_sizes": sorted(map(len, triple_orbits)),
            "normalizer_in_S6_order": len(normalizer),
            "outer_coset_size": len(outer_coset),
            "outer_coset_exchanges_both_classes": True,
            "outer_coset_lifts_to_scheme_automorphisms": False,
            "verdict": "the unmarked colored scheme intrinsically recovers the unordered 10+10 chirality torsor",
        },
        "structural_corollaries": {
            "affine_group_is_2_closed": True,
            "column_graph_is_normal_cayley": True,
            "translation_group": "elementary abelian of order 11^3",
            "translation_group_is_unique_normal_sylow_11": True,
            "affine_addition_recovered_up_to_origin": True,
        },
        "trusted_boundary": {
            "edge_color_entries_checked": 1331 * 1331,
            "relation_tensor_entries_checked_per_candidate": 8**3,
            "s6_permutations_checked": 720,
            "method": "exact finite-field enumeration and equitable color refinement",
        },
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = canonical_bytes(certificate())
    if args.check:
        assert OUTPUT.read_bytes() == encoded
        print(f"verified {OUTPUT.name} ({len(encoded)} bytes)")
    else:
        OUTPUT.write_bytes(encoded)
        print(f"wrote {OUTPUT.name} ({len(encoded)} bytes)")


if __name__ == "__main__":
    main()
