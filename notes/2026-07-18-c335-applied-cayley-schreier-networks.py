#!/usr/bin/env python3
"""Exact small-instance audit for C335's Patra--Barg AF metric."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import deque
from fractions import Fraction
from pathlib import Path
from typing import Iterable

Point = tuple[int, int, int]
Parameter = int | None
Permutation = tuple[int, ...]
Adjacency = tuple[frozenset[int], ...]


def projective_line(q: int) -> tuple[Parameter, ...]:
    return tuple(range(q)) + (None,)


def sigma(center: Point, parameter: Parameter, q: int) -> Parameter:
    a, b, c = center
    if parameter is None:
        return None if c == 0 else b * pow(c, -1, q) % q
    numerator = (b * parameter - a) % q
    denominator = (c * parameter - b) % q
    return None if denominator == 0 else numerator * pow(denominator, -1, q) % q


def projection_permutation(center: Point, q: int) -> Permutation:
    parameters = projective_line(q)
    index = {parameter: i for i, parameter in enumerate(parameters)}
    return tuple(index[sigma(center, parameter, q)] for parameter in parameters)


def compose(left: Permutation, right: Permutation) -> Permutation:
    return tuple(left[right[i]] for i in range(len(left)))


def generated_group(generators: tuple[Permutation, ...]) -> tuple[Permutation, ...]:
    identity = tuple(range(len(generators[0])))
    group = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            product = compose(generator, element)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return tuple(sorted(group))


def permutation_order(permutation: Permutation) -> int:
    identity = tuple(range(len(permutation)))
    power = identity
    for order in range(1, 10_000):
        power = compose(permutation, power)
        if power == identity:
            return order
    raise AssertionError("permutation order cutoff exceeded")


def cayley_graph(
    group: tuple[Permutation, ...], generators: tuple[Permutation, ...]
) -> Adjacency:
    index = {element: i for i, element in enumerate(group)}
    return tuple(
        frozenset(index[compose(generator, element)] for generator in generators)
        for element in group
    )


def schreier_residual(
    q: int, centers: tuple[Point, ...], burned: frozenset[Parameter]
) -> tuple[tuple[Parameter, ...], Adjacency]:
    parameters = projective_line(q)
    kept = tuple(parameter for parameter in parameters if parameter not in burned)
    kept_set = frozenset(kept)
    index = {parameter: i for i, parameter in enumerate(kept)}
    neighbors: list[set[int]] = [set() for _ in kept]
    for parameter in kept:
        for center in centers:
            image = sigma(center, parameter, q)
            if image in kept_set and image != parameter:
                neighbors[index[parameter]].add(index[image])
    adjacency = tuple(frozenset(row) for row in neighbors)
    assert all(v in adjacency[w] for v, row in enumerate(adjacency) for w in row)
    return kept, adjacency


def distances(adjacency: Adjacency, root: int) -> tuple[int, ...]:
    result = [-1] * len(adjacency)
    result[root] = 0
    queue = deque([root])
    while queue:
        vertex = queue.popleft()
        for neighbor in adjacency[vertex]:
            if result[neighbor] == -1:
                result[neighbor] = result[vertex] + 1
                queue.append(neighbor)
    assert -1 not in result
    return tuple(result)


def shell_counts(distance_list: Iterable[int]) -> tuple[int, ...]:
    values = tuple(distance_list)
    return tuple(values.count(radius) for radius in range(max(values) + 1))


def word_ball_shells(
    group: tuple[Permutation, ...], generators: tuple[Permutation, ...]
) -> tuple[int, ...]:
    """Independent Cayley-shell replay using word balls, not graph BFS."""
    identity = tuple(range(len(generators[0])))
    seen = {identity}
    layer = {identity}
    shells = [1]
    group_set = frozenset(group)
    while seen != group_set:
        next_layer = {
            compose(generator, element)
            for generator, element in itertools.product(generators, layer)
        } - seen
        assert next_layer
        shells.append(len(next_layer))
        seen |= next_layer
        layer = next_layer
    return tuple(shells)


def edge_parameters(parameters: tuple[Parameter, ...], adjacency: Adjacency) -> list[list[int]]:
    assert all(parameter is not None for parameter in parameters)
    return [
        [int(parameters[v]), int(parameters[w])]
        for v, row in enumerate(adjacency)
        for w in sorted(row)
        if v < w
    ]


def cost_rows(shells: tuple[int, ...]) -> list[dict[str, object]]:
    helper_distances = [
        radius for radius, count in enumerate(shells) for _ in range(count) if radius > 0
    ]
    rows = []
    for k in range(1, len(helper_distances) + 1):
        scalar_cost = sum(helper_distances[:k])
        candidates = []
        for d in range(k, len(helper_distances) + 1):
            distance_sum = sum(helper_distances[:d])
            candidates.append((Fraction(distance_sum, d - k + 1), d))
        optimum = min(value for value, _ in candidates)
        rows.append(
            {
                "k": k,
                "scalar_af_cost": scalar_cost,
                "subpacketized_normalized_af_cost": str(optimum),
                "subpacketized_optimal_repair_degrees": [
                    d for value, d in candidates if value == optimum
                ],
            }
        )
    return rows


def build_certificate() -> dict[str, object]:
    cayley_q = 3
    cayley_centers = ((0, 1, 0), (0, 1, 1), (1, 0, 1))
    cayley_generators = tuple(projection_permutation(center, cayley_q) for center in cayley_centers)
    assert all(permutation_order(generator) == 2 for generator in cayley_generators)
    pair_product_orders = tuple(
        sorted(
            permutation_order(compose(cayley_generators[i], cayley_generators[j]))
            for i in range(3)
            for j in range(i + 1, 3)
        )
    )
    assert pair_product_orders == (2, 3, 4)
    cayley_group = generated_group(cayley_generators)
    assert len(cayley_group) == cayley_q * (cayley_q * cayley_q - 1) == 24
    cayley_adjacency = cayley_graph(cayley_group, cayley_generators)
    assert all(len(row) == 3 for row in cayley_adjacency)
    identity = tuple(range(cayley_q + 1))
    cayley_shells = shell_counts(distances(cayley_adjacency, cayley_group.index(identity)))
    assert cayley_shells == word_ball_shells(cayley_group, cayley_generators)
    assert cayley_shells == (1, 3, 5, 7, 8)
    assert all(shell_counts(distances(cayley_adjacency, root)) == cayley_shells for root in range(24))

    schreier_q = 7
    b = 4
    schreier_centers = ((0, 1, 1), (-1, 0, 1), (1, b, 1), (-b, -1, 1))
    schreier_centers_mod_q = tuple(
        tuple(coordinate % schreier_q for coordinate in center) for center in schreier_centers
    )
    parameters, schreier_adjacency = schreier_residual(
        schreier_q, schreier_centers_mod_q, frozenset((0, None))
    )
    explicit_cycle = (1, 5, 3, 2, 4, 6)
    expected_edges = {
        frozenset((explicit_cycle[i], explicit_cycle[(i + 1) % len(explicit_cycle)]))
        for i in range(len(explicit_cycle))
    }
    actual_edges = {
        frozenset((parameters[v], parameters[w]))
        for v, row in enumerate(schreier_adjacency)
        for w in row
        if v < w
    }
    assert actual_edges == expected_edges
    schreier_shells = shell_counts(distances(schreier_adjacency, 0))
    assert schreier_shells == (1, 2, 2, 1)
    assert all(
        shell_counts(distances(schreier_adjacency, root)) == schreier_shells
        for root in range(6)
    )

    return {
        "schema": "c335-applied-cayley-schreier-network-audit-v1",
        "conventions": {
            "af_cost": "one symbol sent over one graph edge has cost one",
            "scalar": "l=1 with integral helper downloads; the exact optimum uses the k nearest helpers",
            "subpacketized": "Patra--Barg Theorem IV.1 normalized by l: min_d S_f(d)/(d-k+1)",
            "schreier": "simple union of projection-involution edges after deleting burned parameters 0 and infinity; fixed points and duplicate edges are omitted",
        },
        "cases": [
            {
                "name": "mixed_pgl2_3_cayley_234",
                "field_order": cayley_q,
                "group_order": len(cayley_group),
                "centers": [list(center) for center in cayley_centers],
                "pair_product_orders": list(pair_product_orders),
                "vertex_count": len(cayley_adjacency),
                "degree": 3,
                "distance_shells_including_root": list(cayley_shells),
                "all_roots_same_shells": True,
                "costs": cost_rows(cayley_shells),
            },
            {
                "name": "deleted_schreier_q7_b4",
                "field_order": schreier_q,
                "parameter_b": b,
                "centers_mod_q": [list(center) for center in schreier_centers_mod_q],
                "vertices": list(parameters),
                "edges": edge_parameters(parameters, schreier_adjacency),
                "explicit_cycle": list(explicit_cycle),
                "vertex_count": len(schreier_adjacency),
                "degree": 2,
                "distance_shells_including_root": list(schreier_shells),
                "all_roots_same_shells": True,
                "costs": cost_rows(schreier_shells),
            },
        ],
    }


def canonical_json(certificate: dict[str, object]) -> str:
    return json.dumps(certificate, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group()
    group.add_argument("--output", type=Path)
    group.add_argument("--check", type=Path)
    args = parser.parse_args()
    rendered = canonical_json(build_certificate())
    if args.check is not None:
        tracked = args.check.read_text()
        if tracked != rendered:
            raise SystemExit(f"certificate mismatch: {args.check}")
        print(f"checked {args.check}")
    elif args.output is not None:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
