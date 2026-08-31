#!/usr/bin/env python3
"""Enumerate all K10 one-factorizations and test parity-pencil closure.

Run with ``uv run --with pynauty python``.  Canonical augmentation uses a
colored incidence graph whose color classes are vertices, factors, and edges.
"""

from __future__ import annotations

import argparse
from fractions import Fraction
import hashlib
import itertools
import json
import math
from pathlib import Path

import pynauty


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes/c1015_k10_factorization_closure.json"
MANIFEST = ROOT / "notes/c1015_k10_factorization_closure.sha256"
EDGES = tuple(itertools.combinations(range(10), 2))
EDGE_INDEX = {edge: index for index, edge in enumerate(EDGES)}
FULL_MASK = (1 << 45) - 1


def perfect_matchings(vertices):
    if not vertices:
        return ((),)
    first = vertices[0]
    answer = []
    for index, second in enumerate(vertices[1:]):
        rest = vertices[1 : index + 1] + vertices[index + 2 :]
        for tail in perfect_matchings(rest):
            answer.append(tuple(sorted(((first, second),) + tail)))
    return tuple(answer)


MATCHINGS = tuple(sorted(set(perfect_matchings(tuple(range(10))))))
MASKS = tuple(sum(1 << EDGE_INDEX[edge] for edge in matching) for matching in MATCHINGS)
STANDARD = MATCHINGS.index(((0, 1), (2, 3), (4, 5), (6, 7), (8, 9)))


def incidence_graph(state):
    factor_count = len(state)
    edge_count = 5 * factor_count
    factor_offset = 10
    edge_offset = factor_offset + factor_count
    adjacency = {vertex: set() for vertex in range(edge_offset + edge_count)}
    edge_number = 0
    for factor_number, matching_index in enumerate(state):
        factor_vertex = factor_offset + factor_number
        for left, right in MATCHINGS[matching_index]:
            edge_vertex = edge_offset + edge_number
            edge_number += 1
            for neighbor in (left, right, factor_vertex):
                adjacency[edge_vertex].add(neighbor)
                adjacency[neighbor].add(edge_vertex)
    return pynauty.Graph(
        number_of_vertices=len(adjacency),
        directed=False,
        adjacency_dict=adjacency,
        vertex_coloring=[
            set(range(10)),
            set(range(factor_offset, edge_offset)),
            set(range(edge_offset, edge_offset + edge_count)),
        ],
    )


def certificate(state):
    return pynauty.certificate(incidence_graph(state))


def enumerate_factorizations():
    levels = {1: 1}
    states = {(certificate((STANDARD,))): ((STANDARD,), MASKS[STANDARD])}
    for factor_count in range(2, 10):
        next_states = {}
        for state, used in states.values():
            first_uncovered = next(
                edge_number for edge_number in range(45) if not used & (1 << edge_number)
            )
            for matching_index, mask in enumerate(MASKS):
                if used & mask or not mask & (1 << first_uncovered):
                    continue
                extended = tuple(sorted(state + (matching_index,)))
                key = certificate(extended)
                next_states.setdefault(key, (extended, used | mask))
        states = next_states
        levels[factor_count] = len(states)
    assert all(used == FULL_MASK for _, used in states.values())
    assert len(states) == 396
    return levels, tuple(sorted(state for state, _ in states.values()))


def cycle_distances(first, second, base):
    adjacency = {vertex: [] for vertex in range(10)}
    for left, right in first + second:
        adjacency[left].append(right)
        adjacency[right].append(left)
    distances = {base: 0}
    queue = [base]
    while queue:
        vertex = queue.pop(0)
        for neighbor in adjacency[vertex]:
            if neighbor not in distances:
                distances[neighbor] = distances[vertex] + 1
                queue.append(neighbor)
    return distances


def two_point_closure(parts):
    parts = [set(part) for part in parts]
    changed = True
    while changed:
        changed = False
        for left in range(len(parts)):
            for right in range(left + 1, len(parts)):
                if len(parts[left] & parts[right]) >= 2:
                    parts[left] |= parts[right]
                    parts.pop(right)
                    changed = True
                    break
            if changed:
                break
    return tuple(sorted(len(part) for part in parts))


def closure_profile(state):
    factors = tuple(MATCHINGS[index] for index in state)
    owner = {
        edge: factor_index
        for factor_index, matching in enumerate(factors)
        for edge in matching
    }
    hamilton_sets = []
    all_cycle_sets = []
    characteristic_two_triples = []
    hamilton_count = 0
    for left_index, right_index in itertools.combinations(range(9), 2):
        is_hamilton = len(cycle_distances(
            factors[left_index], factors[right_index], 0
        )) == 10
        hamilton_count += is_hamilton
        for base in range(10):
            distances = cycle_distances(
                factors[left_index], factors[right_index], base
            )
            odd_set = frozenset(
                owner[tuple(sorted((base, vertex)))]
                for vertex, distance in distances.items()
                if distance % 2
            )
            if len(odd_set) >= 3:
                all_cycle_sets.append(odd_set)
            if is_hamilton:
                assert len(odd_set) == 5
                hamilton_sets.append(odd_set)
    for base in range(10):
        factors_by_partner = {}
        for factor_index, matching in enumerate(factors):
            base_edge = next(edge for edge in matching if base in edge)
            partner = base_edge[0] if base_edge[1] == base else base_edge[1]
            factors_by_partner[partner] = (factor_index, matching)
        for partner, (factor_index, matching) in factors_by_partner.items():
            for left, right in matching:
                if base not in (left, right):
                    characteristic_two_triples.append(
                        {
                            factor_index,
                            owner[tuple(sorted((base, left)))],
                            owner[tuple(sorted((base, right)))],
                        }
                    )
    return {
        "hamilton_count": hamilton_count,
        "hamilton_closure": two_point_closure(set(hamilton_sets)),
        "all_cycle_closure": two_point_closure(set(all_cycle_sets)),
        "characteristic_two_closure": two_point_closure(
            characteristic_two_triples
        ),
    }


def encode_distribution(values):
    return {str(key): values.count(key) for key in sorted(set(values))}


def encode_partition_distribution(values):
    return {
        "+".join(map(str, key)) or "empty": values.count(key)
        for key in sorted(set(values))
    }


def exceptional_hesse_obstruction(state):
    factors = tuple(MATCHINGS[index] for index in state)
    owner = {
        edge: factor_index
        for factor_index, matching in enumerate(factors)
        for edge in matching
    }
    triples = set()
    for left_index, right_index in itertools.combinations(range(9), 2):
        for base in range(10):
            distances = cycle_distances(
                factors[left_index], factors[right_index], base
            )
            odd_set = frozenset(
                owner[tuple(sorted((base, vertex)))]
                for vertex, distance in distances.items()
                if distance % 2
            )
            if len(odd_set) >= 3:
                assert len(odd_set) == 3
                triples.add(odd_set)
    assert len(triples) == 12
    assert {
        sum({left, right} <= triple for triple in triples)
        for left, right in itertools.combinations(range(9), 2)
    } == {1}
    extra_triples = [
        frozenset(triple)
        for triple in itertools.combinations(range(9), 3)
        if frozenset(triple) not in triples
    ]
    assert len(extra_triples) == 72
    assert {
        two_point_closure(list(triples) + [extra]) for extra in extra_triples
    } == {(9,)}

    points = tuple(itertools.product(range(3), repeat=2))
    affine_lines = {
        frozenset(
            point_index
            for point_index, point in enumerate(points)
            if (
                (point[0] - first[0]) * (second[1] - first[1])
                - (point[1] - first[1]) * (second[0] - first[0])
            )
            % 3
            == 0
        )
        for first_index, second_index in itertools.combinations(range(9), 2)
        for first, second in ((points[first_index], points[second_index]),)
    }
    factor_to_point = (0, 1, 2, 3, 6, 8, 4, 5, 7)
    assert {
        frozenset(factor_to_point[index] for index in triple)
        for triple in triples
    } == affine_lines
    three_line_zero_carrier_witness = ((0, 1, 2), (0, 3, 6), (1, 3, 8))
    assert all(frozenset(line) in affine_lines for line in three_line_zero_carrier_witness)
    assert (
        set(three_line_zero_carrier_witness[0])
        & set(three_line_zero_carrier_witness[1])
    ) == {0}
    assert 0 not in three_line_zero_carrier_witness[2]
    six_equation_witness = {
        "infinity_edges_to_ag23_points": (0, 1, 3),
        "finite_edges_with_owner": ((0, 1, 2), (0, 3, 6), (1, 3, 8)),
    }
    assert all(
        tuple(sorted((left, right, owner))) in three_line_zero_carrier_witness
        for left, right, owner in six_equation_witness["finite_edges_with_owner"]
    )
    point_of_vertex = {
        vertex: points[factor_to_point[vertex - 1]] for vertex in range(1, 10)
    }
    for factor_index, matching in enumerate(factors):
        factor_point = points[factor_to_point[factor_index]]
        assert (0, factor_index + 1) in matching
        for left, right in matching:
            if left == 0:
                continue
            left_point = point_of_vertex[left]
            right_point = point_of_vertex[right]
            assert tuple(
                (left_point[coordinate] + right_point[coordinate]) % 3
                for coordinate in range(2)
            ) == tuple(-coordinate % 3 for coordinate in factor_point)
    _, automorphism_size, automorphism_exponent, _, _ = pynauty.autgrp(
        incidence_graph(state)
    )
    automorphism_order = int(automorphism_size * (10**automorphism_exponent))
    assert automorphism_order == 432

    zero = (Fraction(0), Fraction(0))
    one = (Fraction(1), Fraction(0))
    omega = (Fraction(0), Fraction(1))

    def extension_add(left, right):
        return (left[0] + right[0], left[1] + right[1])

    def extension_neg(value):
        return (-value[0], -value[1])

    def extension_multiply(left, right):
        # omega^2 = omega - 1
        a, b = left
        c, d = right
        return (a * c - b * d, a * d + b * c + b * d)

    def extension_inverse(value):
        a, b = value
        norm = a * a + a * b + b * b
        return ((a + b) / norm, -b / norm)

    def extension_subtract(left, right):
        return extension_add(left, extension_neg(right))

    hesse_points = (
        (one, zero, zero),
        (zero, one, zero),
        (one, omega, zero),
        (zero, zero, one),
        (one, one, one),
        (omega, omega, one),
        (omega, zero, one),
        (one, omega, one),
        (zero, one, one),
    )
    hesse_transversals = tuple(
        hesse_points[factor_to_point[factor_index]]
        for factor_index in range(9)
    )
    generic_matrix = []
    for edge_number, edge in enumerate(EDGES):
        left, right = edge
        factor_index = owner[edge]
        for coordinate in range(3):
            row = [zero] * 75
            row[3 * left + coordinate] = one
            row[3 * right + coordinate] = one
            row[30 + edge_number] = extension_neg(
                hesse_transversals[factor_index][coordinate]
            )
            generic_matrix.append(row)
    generic_rank = 0
    determinant = one
    for column in range(75):
        pivot = next(
            (
                row
                for row in range(generic_rank, len(generic_matrix))
                if generic_matrix[row][column] != zero
            ),
            None,
        )
        if pivot is None:
            continue
        if pivot != generic_rank:
            determinant = extension_neg(determinant)
        generic_matrix[generic_rank], generic_matrix[pivot] = (
            generic_matrix[pivot],
            generic_matrix[generic_rank],
        )
        pivot_value = generic_matrix[generic_rank][column]
        determinant = extension_multiply(determinant, pivot_value)
        inverse = extension_inverse(pivot_value)
        generic_matrix[generic_rank] = [
            extension_multiply(entry, inverse)
            for entry in generic_matrix[generic_rank]
        ]
        for row in range(generic_rank + 1, len(generic_matrix)):
            if generic_matrix[row][column] != zero:
                multiplier = generic_matrix[row][column]
                generic_matrix[row] = [
                    extension_subtract(
                        entry, extension_multiply(multiplier, pivot_entry)
                    )
                    for entry, pivot_entry in zip(
                        generic_matrix[row], generic_matrix[generic_rank]
                    )
                ]
        generic_rank += 1
    assert generic_rank == 75
    assert determinant == (Fraction(-8), Fraction(-8))
    determinant_norm = (
        determinant[0] * determinant[0]
        + determinant[0] * determinant[1]
        + determinant[1] * determinant[1]
    )
    assert determinant_norm == 192

    transversal_vectors = tuple(
        points[factor_to_point[factor_index]] + (1,)
        for factor_index in range(9)
    )
    matrix = []
    for edge_number, edge in enumerate(EDGES):
        left, right = edge
        factor_index = owner[edge]
        for coordinate in range(3):
            row = [0] * 75
            row[3 * left + coordinate] = 1
            row[3 * right + coordinate] = 1
            row[30 + edge_number] = (-transversal_vectors[factor_index][coordinate]) % 3
            matrix.append(row)
    rank = 0
    pivots = []
    for column in range(75):
        pivot = next(
            (row for row in range(rank, len(matrix)) if matrix[row][column] % 3),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, 3)
        matrix[rank] = [(entry * inverse) % 3 for entry in matrix[rank]]
        for row in range(len(matrix)):
            if row != rank and matrix[row][column] % 3:
                multiplier = matrix[row][column]
                matrix[row] = [
                    (entry - multiplier * pivot_entry) % 3
                    for entry, pivot_entry in zip(matrix[row], matrix[rank])
                ]
        pivots.append(column)
        rank += 1
    assert rank == 74
    free = next(column for column in range(75) if column not in pivots)
    null_vector = [0] * 75
    null_vector[free] = 1
    for row, column in reversed(tuple(enumerate(pivots))):
        null_vector[column] = -sum(
            matrix[row][later] * null_vector[later]
            for later in range(column + 1, 75)
        ) % 3
    carriers = tuple(
        tuple(null_vector[3 * vertex : 3 * vertex + 3]) for vertex in range(10)
    )
    zero_carriers = tuple(
        vertex for vertex, carrier in enumerate(carriers) if not any(carrier)
    )
    assert zero_carriers == (0,)
    return {
        "parity_triple_count": len(triples),
        "pair_multiplicity": 1,
        "extra_triples_forcing_full_pencil": len(extra_triples),
        "factor_to_ag23_point": factor_to_point,
        "affine_factorization_rule": (
            "M_a={{infinity,a}} union {{x,y}:x+y=-a}; "
            "vertices 1..9 use factor_to_ag23_point in order"
        ),
        "automorphism_group_order": automorphism_order,
        "characteristic_not_two_incidence_obstruction": {
            "hesse_lines_by_ag23_point_index": three_line_zero_carrier_witness,
            "six_equation_witness": six_equation_witness,
            "argument": (
                "the first two Hesse lines intersect only at point 0, while "
                "the third avoids point 0; the lift equations place 2*u_infinity "
                "in all three line spans, hence u_infinity=0 when 2 is nonzero"
            ),
        },
        "hesse_parameter_polynomial": "omega^2-omega+1",
        "generic_lift_matrix_shape": (len(generic_matrix), len(generic_matrix[0])),
        "generic_lift_matrix_rank": generic_rank,
        "generic_lift_minor_determinant": "-8*(1+omega)",
        "generic_lift_minor_norm": int(determinant_norm),
        "exceptional_characteristics_from_minor": (2, 3),
        "mod3_lift_matrix_rank": rank,
        "mod3_lift_nullity": 75 - rank,
        "mod3_unique_lift_carriers": carriers,
        "mod3_zero_carrier_indices": zero_carriers,
    }


def build_report():
    levels, factorizations = enumerate_factorizations()
    profiles = tuple(closure_profile(state) for state in factorizations)
    hamilton_counts = [profile["hamilton_count"] for profile in profiles]
    hamilton_closures = [profile["hamilton_closure"] for profile in profiles]
    all_cycle_closures = [profile["all_cycle_closure"] for profile in profiles]
    characteristic_two_closures = [
        profile["characteristic_two_closure"] for profile in profiles
    ]
    automorphism_orders = []
    for state in factorizations:
        _, size_base, size_exponent, _, _ = pynauty.autgrp(incidence_graph(state))
        order = int(size_base * (10 ** size_exponent))
        assert order == size_base * (10 ** size_exponent)
        automorphism_orders.append(order)
    labelled_count = sum(math.factorial(10) // order for order in automorphism_orders)
    assert labelled_count == 1_225_566_720, labelled_count
    exceptional = []
    zero_hamilton_state = None
    for state, profile in zip(factorizations, profiles):
        if profile["hamilton_closure"] != (9,):
            exceptional.append(
                {
                    "hamilton_count": profile["hamilton_count"],
                    "hamilton_closure": profile["hamilton_closure"],
                    "all_cycle_closure": profile["all_cycle_closure"],
                    "characteristic_two_closure": profile[
                        "characteristic_two_closure"
                    ],
                    "factors": tuple(MATCHINGS[index] for index in state),
                }
            )
        if profile["hamilton_count"] == 0:
            assert zero_hamilton_state is None
            zero_hamilton_state = state
    assert zero_hamilton_state is not None
    return {
        "schema": "c1015-k10-factorization-closure-v1",
        "pynauty_version": pynauty.__version__,
        "matching_count": len(MATCHINGS),
        "canonical_partial_counts": levels,
        "one_factorization_count": len(factorizations),
        "one_factorizations_sha256": hashlib.sha256(
            json.dumps(factorizations, separators=(",", ":")).encode()
        ).hexdigest(),
        "automorphism_order_distribution": encode_distribution(
            automorphism_orders
        ),
        "labelled_one_factorization_count": labelled_count,
        "hamilton_pair_count_distribution": encode_distribution(hamilton_counts),
        "hamilton_pencil_closure_distribution": encode_partition_distribution(
            hamilton_closures
        ),
        "all_cycle_pencil_closure_distribution": encode_partition_distribution(
            all_cycle_closures
        ),
        "characteristic_two_pencil_closure_distribution": encode_partition_distribution(
            characteristic_two_closures
        ),
        "full_pencil_forced_by_hamilton_constraints": sum(
            closure == (9,) for closure in hamilton_closures
        ),
        "full_pencil_forced_by_all_cycle_constraints": sum(
            closure == (9,) for closure in all_cycle_closures
        ),
        "full_pencil_forced_in_characteristic_two": sum(
            closure == (9,) for closure in characteristic_two_closures
        ),
        "exceptional_hamilton_closure_classes": exceptional,
        "zero_hamilton_hesse_obstruction": exceptional_hesse_obstruction(
            zero_hamilton_state
        ),
        "trusted_boundary": (
            "canonical colored-graph augmentation and finite cycle/closure checks; "
            "the interpolation and parity theorems are human"
        ),
    }


def rendered_report():
    return (json.dumps(build_report(), indent=2, sort_keys=True) + "\n").encode()


def rendered_manifest(output_bytes):
    rows = []
    for path, payload in (
        (Path(__file__), Path(__file__).read_bytes()),
        (OUTPUT, output_bytes),
    ):
        rows.append(f"{hashlib.sha256(payload).hexdigest()}  {path.relative_to(ROOT)}")
    return ("\n".join(rows) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    output = rendered_report()
    manifest = rendered_manifest(output)
    if args.write:
        OUTPUT.write_bytes(output)
        MANIFEST.write_bytes(manifest)
    else:
        assert OUTPUT.read_bytes() == output
        assert MANIFEST.read_bytes() == manifest
    print("C1015 K10 factorization-closure checks passed")


if __name__ == "__main__":
    main()
