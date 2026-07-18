#!/usr/bin/env python3
"""Exact bounded gate for pairing-based Crown I silver at three centres."""

from __future__ import annotations

import argparse
import itertools
import json
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "rust" / "scripts"))

from c84_pairing_locus import has_abstract_pairing, pair_orders  # noqa: E402
from c84_two_ply_pairing import induced_graph, pairing_position  # noqa: E402
from three_centre_probe import (  # noqa: E402
    centres,
    compose,
    conic_point,
    determinant,
    generated_group,
    grundy,
    projective_line,
    residual_graph,
    sigma,
)


def path_grundy_values(limit: int) -> tuple[int, ...]:
    values = [0]
    for size in range(1, limit + 1):
        options = {
            values[max(0, move - 1)] ^ values[max(0, size - move - 2)]
            for move in range(size)
        }
        value = 0
        while value in options:
            value += 1
        values.append(value)
    return tuple(values)


def degree_two_grundy(adjacency: tuple[int, ...], mask: int) -> int | None:
    path_values = path_grundy_values(len(adjacency))
    unseen = mask
    value = 0
    while unseen:
        frontier = unseen & -unseen
        component = 0
        while frontier:
            component |= frontier
            unseen &= ~frontier
            neighbours = 0
            bits = frontier
            while bits:
                bit = bits & -bits
                vertex = bit.bit_length() - 1
                degree = (adjacency[vertex] & mask).bit_count()
                if degree > 2:
                    return None
                neighbours |= adjacency[vertex]
                bits ^= bit
            frontier = neighbours & unseen
        size = component.bit_count()
        is_cycle = size >= 3 and all(
            (adjacency[vertex] & component).bit_count() == 2
            for vertex in range(len(adjacency))
            if (component >> vertex) & 1
        )
        component_value = int(path_values[size - 3] == 0) if is_cycle else path_values[size]
        value ^= component_value
    return value


def crosscheck_degree_two_kernel(limit: int) -> None:
    for size in range(limit + 1):
        path = [0] * size
        for vertex in range(size - 1):
            path[vertex] |= 1 << (vertex + 1)
            path[vertex + 1] |= 1 << vertex
        path_graph = tuple(path)
        grundy.cache_clear()
        assert degree_two_grundy(path_graph, (1 << size) - 1) == grundy(
            path_graph, (1 << size) - 1
        )
        if size >= 3:
            cycle = list(path)
            cycle[0] |= 1 << (size - 1)
            cycle[-1] |= 1
            cycle_graph = tuple(cycle)
            grundy.cache_clear()
            assert degree_two_grundy(cycle_graph, (1 << size) - 1) == grundy(
                cycle_graph, (1 << size) - 1
            )


def response_coverages(adjacency: tuple[int, ...]) -> tuple[int, int, int]:
    closed = tuple(mask | (1 << vertex) for vertex, mask in enumerate(adjacency))
    full = (1 << len(adjacency)) - 1
    paired_coverage = 0
    degree_two_coverage = 0
    combined_coverage = 0
    for first in range(len(adjacency)):
        follower = full & ~closed[first]
        paired = False
        degree_two = False
        replies = follower
        while replies and not (paired and degree_two):
            bit = replies & -replies
            second = bit.bit_length() - 1
            grandchild = follower & ~closed[second]
            paired |= pairing_position(induced_graph(adjacency, grandchild))
            degree_two |= degree_two_grundy(adjacency, grandchild) == 0
            replies ^= bit
        paired_coverage += paired
        degree_two_coverage += degree_two
        combined_coverage += paired or degree_two
    return paired_coverage, degree_two_coverage, combined_coverage


def inverse_permutation(perm: tuple[int, ...]) -> tuple[int, ...]:
    inverse = [0] * len(perm)
    for source, target in enumerate(perm):
        inverse[target] = source
    return tuple(inverse)


def exception_orbit_audit(
    q: int,
    external: tuple[tuple[int, int, int], ...],
    exception_triples: set[tuple[tuple[int, int, int], ...]],
) -> list[dict[str, object]]:
    if not exception_triples:
        return []
    parameters = projective_line(q)
    conic = tuple(conic_point(t, q) for t in parameters)
    parameter_index = {parameter: i for i, parameter in enumerate(parameters)}
    permutations = {
        center: tuple(parameter_index[sigma(center, t, q)] for t in parameters)
        for center in external
    }
    permutation_to_center = {perm: center for center, perm in permutations.items()}
    assert len(permutation_to_center) == len(permutations)
    full_group = generated_group(tuple(permutations.values()))
    assert len(full_group) == q * (q * q - 1)
    remaining = set(exception_triples)
    audits = []
    while remaining:
        representative = min(remaining)
        orbit = set()
        for element in full_group:
            inverse = inverse_permutation(element)
            image = tuple(sorted(
                permutation_to_center[compose(compose(element, permutations[center]), inverse)]
                for center in representative
            ))
            orbit.add(image)
        assert orbit <= exception_triples
        _, adjacency, _ = residual_graph(representative, parameters, conic, q)
        subgroup = generated_group(tuple(permutations[center] for center in representative))
        grundy.cache_clear()
        audits.append({
            "components": component_sizes(adjacency),
            "degree_sequence": sorted(mask.bit_count() for mask in adjacency),
            "edges": sum(mask.bit_count() for mask in adjacency) // 2,
            "generated_group_order": len(subgroup),
            "grundy": grundy(adjacency, (1 << len(adjacency)) - 1),
            "orbit_size": len(orbit),
            "pair_product_orders": list(pair_orders(tuple(
                permutations[center] for center in representative
            ))),
            "representative": [list(center) for center in representative],
            "root_pairing": has_abstract_pairing(adjacency),
            "triangles": triangle_count(adjacency),
            "vertices": len(adjacency),
        })
        remaining -= orbit
    return audits


def component_sizes(adjacency: tuple[int, ...]) -> list[int]:
    unseen = (1 << len(adjacency)) - 1
    sizes = []
    while unseen:
        frontier = unseen & -unseen
        component = 0
        while frontier:
            component |= frontier
            unseen &= ~frontier
            neighbours = 0
            bits = frontier
            while bits:
                bit = bits & -bits
                neighbours |= adjacency[bit.bit_length() - 1]
                bits ^= bit
            frontier = neighbours & unseen
        sizes.append(component.bit_count())
    return sorted(sizes)


def triangle_count(adjacency: tuple[int, ...]) -> int:
    return sum(
        1
        for first in range(len(adjacency))
        for second in range(first + 1, len(adjacency))
        for third in range(second + 1, len(adjacency))
        if (adjacency[first] >> second) & 1
        and (adjacency[second] >> third) & 1
        and (adjacency[third] >> first) & 1
    )


def probe(q: int) -> dict[str, object]:
    parameters = projective_line(q)
    conic = tuple(conic_point(t, q) for t in parameters)
    external = centres(q)
    values: Counter[int] = Counter()
    root_pairing = 0
    root_pairing_false_positives = 0
    atlas = 0
    atlas_false_positives = 0
    degree_two_atlas = 0
    degree_two_atlas_false_positives = 0
    combined_atlas = 0
    combined_atlas_false_positives = 0
    p_root_pairing = 0
    p_atlas_only = 0
    p_uncovered = 0
    p_uncovered_after_degree_two = 0
    degree_two_exceptions: set[tuple[tuple[int, int, int], ...]] = set()
    combined_exceptions: set[tuple[tuple[int, int, int], ...]] = set()
    pairing_position.cache_clear()
    legal = 0
    for triple in itertools.combinations(external, 3):
        if determinant(triple, q) == 0:
            continue
        legal += 1
        _, adjacency, _ = residual_graph(triple, parameters, conic, q)
        grundy.cache_clear()
        value = grundy(adjacency, (1 << len(adjacency)) - 1)
        values[value] += 1
        paired = has_abstract_pairing(adjacency)
        paired_coverage, degree_two_coverage, combined_coverage = response_coverages(adjacency)
        atlas_certified = paired_coverage == len(adjacency)
        degree_two_certified = degree_two_coverage == len(adjacency)
        combined_certified = combined_coverage == len(adjacency)
        root_pairing += paired
        root_pairing_false_positives += paired and value != 0
        atlas += atlas_certified
        atlas_false_positives += atlas_certified and value != 0
        degree_two_atlas += degree_two_certified
        degree_two_atlas_false_positives += degree_two_certified and value != 0
        combined_atlas += combined_certified
        combined_atlas_false_positives += combined_certified and value != 0
        if value == 0:
            if paired:
                p_root_pairing += 1
            elif atlas_certified:
                p_atlas_only += 1
            else:
                p_uncovered += 1
            p_uncovered_after_degree_two += not combined_certified
            if not degree_two_certified:
                degree_two_exceptions.add(triple)
            if not combined_certified:
                combined_exceptions.add(triple)
    return {
        "atlas_certified": atlas,
        "atlas_false_positives": atlas_false_positives,
        "combined_atlas_certified": combined_atlas,
        "combined_atlas_false_positives": combined_atlas_false_positives,
        "degree_two_atlas_certified": degree_two_atlas,
        "degree_two_atlas_false_positives": degree_two_atlas_false_positives,
        "degree_two_exception_orbits": exception_orbit_audit(q, external, degree_two_exceptions),
        "grundy_counts": {str(key): values[key] for key in sorted(values)},
        "legal_triples": legal,
        "pairing_or_degree_two_exception_orbits": exception_orbit_audit(
            q, external, combined_exceptions
        ),
        "p_atlas_only": p_atlas_only,
        "p_root_pairing": p_root_pairing,
        "p_uncovered": p_uncovered,
        "p_uncovered_after_degree_two": p_uncovered_after_degree_two,
        "q": q,
        "root_pairing_certified": root_pairing,
        "root_pairing_false_positives": root_pairing_false_positives,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", type=int, nargs="+")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    kernel_limit = max(args.q) + 1
    crosscheck_degree_two_kernel(kernel_limit)
    result = {
        "cases": [probe(q) for q in args.q],
        "degree_two_kernel_crosscheck_max_vertices": kernel_limit,
        "schema": "c294-silver-three-centre-gate-v3",
    }
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check is not None:
        if args.check.read_text() != encoded:
            raise SystemExit(f"mismatch: {args.check}")
        print(f"PASS {args.check}")
    elif args.output is not None:
        args.output.write_text(encoded)
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
