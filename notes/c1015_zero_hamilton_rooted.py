#!/usr/bin/env python3
"""Direct rooted classification of Hamilton-free one-factorizations of K10.

This deliberately avoids canonical graph augmentation and third-party graph
isomorphism software.  It fixes one factor, solves the resulting five-pair
exact-cover problem, and quotients only by the explicit wreath-product
symmetries of those five pairs.
"""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import itertools
import json
from pathlib import Path
import tempfile


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes/c1015_zero_hamilton_rooted.json"
MANIFEST = ROOT / "notes/c1015_zero_hamilton_rooted.sha256"
VERTICES = tuple(range(10))
EDGES = tuple(itertools.combinations(VERTICES, 2))
EDGE_INDEX = {edge: index for index, edge in enumerate(EDGES)}
BASE = ((0, 1), (2, 3), (4, 5), (6, 7), (8, 9))


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


MATCHINGS = tuple(sorted(set(perfect_matchings(VERTICES))))
MATCHING_INDEX = {matching: index for index, matching in enumerate(MATCHINGS)}
MASKS = tuple(
    sum(1 << EDGE_INDEX[edge] for edge in matching) for matching in MATCHINGS
)
BASE_INDEX = MATCHING_INDEX[BASE]
BASE_MASK = MASKS[BASE_INDEX]
PAIR_OF = {vertex: pair for pair, edge in enumerate(BASE) for vertex in edge}


def components(first, second):
    adjacency = {vertex: [] for vertex in VERTICES}
    for left, right in first + second:
        adjacency[left].append(right)
        adjacency[right].append(left)
    answer = []
    unseen = set(VERTICES)
    while unseen:
        stack = [min(unseen)]
        component = set(stack)
        unseen.remove(stack[0])
        while stack:
            vertex = stack.pop()
            for neighbor in adjacency[vertex]:
                if neighbor in unseen:
                    unseen.remove(neighbor)
                    component.add(neighbor)
                    stack.append(neighbor)
        answer.append(tuple(sorted(component)))
    return tuple(sorted(answer, key=lambda part: (len(part), part)))


def product_cycle_lengths(first, second):
    first_mate = {x: y for x, y in first for x, y in ((x, y), (y, x))}
    second_mate = {x: y for x, y in second for x, y in ((x, y), (y, x))}
    permutation = {x: first_mate[second_mate[x]] for x in VERTICES}
    unseen = set(VERTICES)
    lengths = []
    while unseen:
        start = min(unseen)
        vertex = start
        length = 0
        while vertex in unseen:
            unseen.remove(vertex)
            length += 1
            vertex = permutation[vertex]
        lengths.append(length)
    return tuple(sorted(lengths))


def is_hamilton(first, second):
    by_components = tuple(map(len, components(first, second))) == (10,)
    by_product = product_cycle_lengths(first, second) == (5, 5)
    assert by_components == by_product
    return by_components


def signature(matching):
    multiplicities = Counter(
        tuple(sorted((PAIR_OF[left], PAIR_OF[right]))) for left, right in matching
    )
    doubled = tuple(edge for edge, count in multiplicities.items() if count == 2)
    if len(doubled) != 1:
        return None
    return doubled[0]


CANDIDATES = {
    edge: tuple(
        index
        for index, matching in enumerate(MATCHINGS)
        if not MASKS[index] & BASE_MASK and signature(matching) == edge
    )
    for edge in itertools.combinations(range(5), 2)
}


def signature_multiplicity_solutions():
    edges = tuple(itertools.combinations(range(5), 2))
    answer = []
    for values in itertools.product(range(3), repeat=len(edges)):
        if sum(values) != 8:
            continue
        multiplicity = dict(zip(edges, values))
        if all(
            2 * multiplicity[edge]
            + sum(
                multiplicity[other]
                for other in edges
                if set(edge).isdisjoint(other)
            )
            == 4
            for edge in edges
        ):
            answer.append(values)
    return tuple(answer)


def exact_covers(quotas):
    answers = set()

    def visit(used, remaining, chosen):
        if not remaining:
            answers.add(tuple(sorted(chosen)))
            return
        options = []
        for edge, quota in remaining.items():
            available = tuple(
                index for index in CANDIDATES[edge] if not MASKS[index] & used
            )
            if len(available) < quota:
                return
            options.append((len(available) / quota, edge, available))
        _, edge, available = min(options)
        for index in available:
            next_remaining = dict(remaining)
            next_remaining[edge] -= 1
            if not next_remaining[edge]:
                del next_remaining[edge]
            visit(used | MASKS[index], next_remaining, chosen + (index,))

    visit(BASE_MASK, dict(quotas), ())
    return tuple(sorted(answers))


def hamilton_count_away_from_base(solution):
    factors = tuple(MATCHINGS[index] for index in solution)
    return sum(
        is_hamilton(factors[left], factors[right])
        for left in range(8)
        for right in range(left)
    )


def vertex_permutations(pair_permutations):
    for pair_permutation in pair_permutations:
        for flips in itertools.product(range(2), repeat=5):
            yield tuple(
                2 * pair_permutation[pair] + (bit ^ flips[pair])
                for pair in range(5)
                for bit in range(2)
            )


def matching_action(vertex_permutation):
    return tuple(
        MATCHING_INDEX[
            tuple(
                sorted(
                    tuple(sorted((vertex_permutation[left], vertex_permutation[right])))
                    for left, right in matching
                )
            )
        ]
        for matching in MATCHINGS
    )


def orbit_count(solutions, pair_permutations):
    actions = tuple(
        matching_action(permutation)
        for permutation in vertex_permutations(pair_permutations)
    )
    solution_set = set(solutions)
    representatives = {
        min(tuple(sorted(action[index] for index in solution)) for action in actions)
        for solution in solutions
    }
    assert all(representative in solution_set for representative in representatives)
    return len(actions), len(representatives)


def factorization(solution):
    return (BASE,) + tuple(MATCHINGS[index] for index in solution)


def common_four_cycle_vertices(solution):
    factors = factorization(solution)
    four_sets = []
    for left in range(9):
        for right in range(left):
            parts = components(factors[left], factors[right])
            if tuple(map(len, parts)) != (4, 6):
                return ()
            four_sets.append(set(parts[0]))
    return tuple(sorted(set.intersection(*four_sets)))


def matching_json(matching):
    return [list(edge) for edge in matching]


def distribution(values):
    return {str(key): value for key, value in sorted(Counter(values).items())}


def build_certificate():
    multiplicities = signature_multiplicity_solutions()
    pattern_distribution = Counter(tuple(sorted(values)) for values in multiplicities)
    star_quotas = {(0, outer): 2 for outer in range(1, 5)}
    triangle_quotas = {
        **{(inner, outer): 1 for inner in range(3) for outer in (3, 4)},
        (3, 4): 2,
    }
    star = exact_covers(star_quotas)
    triangle = exact_covers(triangle_quotas)
    star_hamilton = {
        solution: hamilton_count_away_from_base(solution) for solution in star
    }
    triangle_hamilton = {
        solution: hamilton_count_away_from_base(solution) for solution in triangle
    }
    zero_star = tuple(
        solution for solution, count in star_hamilton.items() if count == 0
    )
    zero_triangle = tuple(
        solution for solution, count in triangle_hamilton.items() if count == 0
    )
    star_pair_permutations = tuple(
        (0,) + permutation for permutation in itertools.permutations(range(1, 5))
    )
    triangle_pair_permutations = tuple(
        left + right
        for left in itertools.permutations(range(3))
        for right in itertools.permutations(range(3, 5))
    )
    star_group_order, zero_star_orbits = orbit_count(
        zero_star, star_pair_permutations
    )
    triangle_group_order, triangle_orbits = orbit_count(
        triangle, triangle_pair_permutations
    )
    common_vertices = {
        common_four_cycle_vertices(solution) for solution in zero_star
    }
    assert common_vertices == {(0,), (1,)}
    representative = min(zero_star)
    return {
        "schema": "c1015-zero-hamilton-rooted-v1",
        "domain": {
            "vertices": 10,
            "perfect_matchings": len(MATCHINGS),
            "fixed_base_factor": matching_json(BASE),
            "rooted_candidates_per_signature": sorted(
                set(map(len, CANDIDATES.values()))
            ),
        },
        "signature_multiplicity_equation": "2*d_e + sum_{f disjoint e} d_f = 4",
        "signature_multiplicity_solutions": {
            "labelled": len(multiplicities),
            "pattern_distribution": {
                str(list(pattern)): count
                for pattern, count in sorted(pattern_distribution.items())
            },
        },
        "star_pattern": {
            "rooted_exact_covers": len(star),
            "hamilton_pairs_away_from_base": distribution(star_hamilton.values()),
            "hamilton_free_completions": len(zero_star),
            "explicit_symmetry_group_order": star_group_order,
            "hamilton_free_orbits": zero_star_orbits,
            "common_four_cycle_vertex_sets": [list(vertices) for vertices in sorted(common_vertices)],
        },
        "three_plus_two_pattern": {
            "rooted_exact_covers": len(triangle),
            "hamilton_pairs_away_from_base": distribution(
                triangle_hamilton.values()
            ),
            "hamilton_free_completions": len(zero_triangle),
            "explicit_symmetry_group_order": triangle_group_order,
            "all_completion_orbits": triangle_orbits,
        },
        "unique_rooted_hamilton_free_representative": [
            matching_json(matching) for matching in factorization(representative)
        ],
        "cross_checks": {
            "hamilton_test": "component size 10 iff product cycle lengths are [5,5]",
            "all_hamilton_free_representatives_have_common_four_cycle_vertex": True,
            "independent_full_census_bundle": "notes/c1015_k10_factorization_closure.py",
        },
        "trusted_boundary": (
            "deterministic exact cover after fixing one factor; explicit pair permutations "
            "and endpoint flips only; no graph-isomorphism package"
        ),
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def manifest_bytes(script_path, output_bytes):
    rows = []
    for path, data in ((script_path, script_path.read_bytes()), (OUTPUT, output_bytes)):
        rows.append(f"{hashlib.sha256(data).hexdigest()}  {path.relative_to(ROOT)}")
    return ("\n".join(rows) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    certificate = build_certificate()
    output_bytes = canonical_bytes(certificate)
    script_path = Path(__file__).resolve()
    manifest = manifest_bytes(script_path, output_bytes)
    if arguments.check:
        assert OUTPUT.read_bytes() == output_bytes
        assert MANIFEST.read_bytes() == manifest
        print("C1015 rooted zero-Hamilton checks passed")
        return
    OUTPUT.write_bytes(output_bytes)
    MANIFEST.write_bytes(manifest)
    print(f"wrote {OUTPUT.relative_to(ROOT)} and {MANIFEST.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
