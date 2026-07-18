#!/usr/bin/env python3
"""Exact obstruction to one-exchange recursive mirrors for the C294 mixed scar."""

from __future__ import annotations

import argparse
import functools
import hashlib
import importlib.util
import json
from collections import Counter
from pathlib import Path
from types import ModuleType


Mask = int
Pairing = tuple[int, ...]


def load_obstruction_module() -> ModuleType:
    path = Path(__file__).with_name("2026-07-17-c294-mixed-scar-obstruction.py")
    spec = importlib.util.spec_from_file_location("c294_mixed_scar", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


M = load_obstruction_module()


def map_mask(mask: Mask, action: tuple[int, ...]) -> Mask:
    result = 0
    for vertex in M.bits(mask):
        result |= 1 << action[vertex]
    return result


class Model:
    def __init__(self, q: int, type_index: int) -> None:
        parameters = M.projective_line(q)
        parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
        points = M.centres(q)
        permutations = {
            point: tuple(
                parameter_index[M.sigma(point, parameter, q)] for parameter in parameters
            )
            for point in points
        }
        group = M.generated_group(tuple(permutations.values()))
        representative, orbit_size = M.mixed_full_orbits(
            q, points, permutations, group
        )[type_index]
        generators = tuple(permutations[point] for point in representative)
        elements, adjacency = M.cayley_graph(group, generators)
        index = {element: position for position, element in enumerate(elements)}
        identity = tuple(range(q + 1))

        self.q = q
        self.type_index = type_index
        self.representative = representative
        self.orbit_size = orbit_size
        self.group = group
        self.generators = generators
        self.classes = tuple(M.determinant_class(point, q) for point in representative)
        self.elements = elements
        self.index = index
        self.adjacency = adjacency
        self.closed = tuple(mask | (1 << vertex) for vertex, mask in enumerate(adjacency))
        self.full = (1 << len(elements)) - 1
        self.identity_index = index[identity]
        self.right_actions = tuple(
            tuple(index[M.compose(element, right)] for element in elements) for right in elements
        )

    def right_pairing(self, element: tuple[int, ...]) -> Pairing:
        return tuple(self.index[M.compose(left, element)] for left in self.elements)


def restrict_pairing(pairing: Pairing, mask: Mask) -> Pairing:
    return tuple(pairing[vertex] if (mask >> vertex) & 1 else -1 for vertex in range(len(pairing)))


def canonical_state(model: Model, mask: Mask, pairing: Pairing) -> tuple[Mask, Pairing]:
    best: tuple[Mask, Pairing] | None = None
    for action in model.right_actions:
        mapped_mask = map_mask(mask, action)
        mapped = [-1] * len(model.elements)
        for vertex in M.bits(mask):
            mapped[action[vertex]] = action[pairing[vertex]]
        candidate = (mapped_mask, tuple(mapped))
        if best is None or candidate < best:
            best = candidate
    assert best is not None
    return best


def verify_pairing(model: Model, mask: Mask, pairing: Pairing) -> None:
    for vertex in M.bits(mask):
        mate = pairing[vertex]
        assert mate != vertex and (mask >> mate) & 1
        assert pairing[mate] == vertex
        mapped_neighbours = {
            pairing[other] for other in M.bits(model.adjacency[vertex] & mask)
        }
        assert mapped_neighbours == set(M.bits(model.adjacency[mate] & mask))


def defect_pairs(model: Model, mask: Mask, pairing: Pairing) -> int:
    return sum(
        vertex < pairing[vertex] and bool((model.adjacency[vertex] >> pairing[vertex]) & 1)
        for vertex in M.bits(mask)
    )


def state_hash(mask: Mask, pairing: Pairing) -> str:
    width = (len(pairing) + 7) // 8
    payload = bytearray(mask.to_bytes(width, "little"))
    for value in pairing:
        payload.extend(value.to_bytes(2, "little", signed=True))
    return hashlib.sha256(payload).hexdigest()


def independent_stable_partition(adjacency: tuple[int, ...]) -> tuple[frozenset[int], ...]:
    """Independent cell-splitting replay of the stable-colour partition."""
    by_degree: dict[int, set[int]] = {}
    for vertex, neighbours in enumerate(adjacency):
        by_degree.setdefault(neighbours.bit_count(), set()).add(vertex)
    partition = tuple(frozenset(by_degree[key]) for key in sorted(by_degree))
    while True:
        refined = []
        for cell in partition:
            blocks: dict[tuple[int, ...], set[int]] = {}
            for vertex in cell:
                signature = tuple(
                    sum((adjacency[vertex] >> other) & 1 for other in target)
                    for target in partition
                )
                blocks.setdefault(signature, set()).add(vertex)
            refined.extend(frozenset(blocks[key]) for key in sorted(blocks))
        next_partition = tuple(sorted(refined, key=lambda cell: (min(cell), len(cell))))
        if {frozenset(cell) for cell in next_partition} == {
            frozenset(cell) for cell in partition
        }:
            return next_partition
        partition = next_partition


def primary_partition(adjacency: tuple[int, ...]) -> tuple[frozenset[int], ...]:
    cells: dict[int, set[int]] = {}
    for vertex, colour in enumerate(M.stable_colours(adjacency)):
        cells.setdefault(colour, set()).add(vertex)
    return tuple(frozenset(cells[key]) for key in sorted(cells))


def histogram_rows(counter: Counter[tuple[int, ...]]) -> list[dict[str, object]]:
    return [
        {
            "child_vertices": key[0],
            "largest_stable_cell": key[3],
            "odd_stable_cells": key[2],
            "reply_count": counter[key],
            "stable_cells": key[1],
        }
        for key in sorted(counter)
    ]


def mirror_obstruction_case(
    model: Model,
    *,
    label: str,
    root_generator_index: int,
    mirror_moves: tuple[int, ...],
    terminal_move: int,
) -> dict[str, object]:
    pairing = model.right_pairing(model.generators[root_generator_index])
    mask, pairing = canonical_state(model, model.full, pairing)
    verify_pairing(model, mask, pairing)
    path = []
    for move in mirror_moves:
        mate = pairing[move]
        assert not ((model.adjacency[move] >> mate) & 1)
        path.append(
            {
                "defect_pairs": defect_pairs(model, mask, pairing),
                "move": move,
                "response": mate,
                "state_sha256": state_hash(mask, pairing),
                "vertices": mask.bit_count(),
            }
        )
        child = mask & ~model.closed[move] & ~model.closed[mate]
        mask, pairing = canonical_state(model, child, restrict_pairing(pairing, child))
        verify_pairing(model, mask, pairing)

    terminal_mate = pairing[terminal_move]
    assert (model.adjacency[terminal_move] >> terminal_mate) & 1
    follower = mask & ~model.closed[terminal_move]
    stable_histogram: Counter[tuple[int, ...]] = Counter()
    degree_parity_obstructions = 0
    replayed_partitions = 0
    for reply in M.bits(follower):
        child = follower & ~model.closed[reply]
        induced = M.induced_graph(model.adjacency, child)
        primary = primary_partition(induced)
        independent = independent_stable_partition(induced)
        assert set(primary) == set(independent)
        replayed_partitions += 1
        sizes = tuple(len(cell) for cell in primary)
        odd_cells = sum(size % 2 for size in sizes)
        assert odd_cells > 0
        stable_histogram[(len(induced), len(sizes), odd_cells, max(sizes))] += 1
        degree_counts = Counter(mask.bit_count() for mask in induced)
        degree_parity_obstructions += int(any(count % 2 for count in degree_counts.values()))

    return {
        "degree_parity_obstructed_replies": degree_parity_obstructions,
        "exhaustive_involution_class_label": label,
        "mirror_path": path,
        "reply_tests": replayed_partitions,
        "root_generator_index": root_generator_index,
        "stable_colour_histogram": histogram_rows(stable_histogram),
        "terminal": {
            "defect_move": terminal_move,
            "defect_pairs": defect_pairs(model, mask, pairing),
            "mate": terminal_mate,
            "state_sha256": state_hash(mask, pairing),
            "vertices": mask.bit_count(),
        },
    }


def involution_classes(model: Model) -> list[dict[str, object]]:
    identity = tuple(range(model.q + 1))
    involutions = {
        element
        for element in model.group
        if element != identity and M.compose(element, element) == identity
    }
    remaining = set(involutions)
    result = []
    while remaining:
        seed = min(remaining)
        orbit = {
            M.compose(
                M.compose(M.inverse_permutation(group_element), seed), group_element
            )
            for group_element in model.group
        }
        assert orbit <= involutions
        result.append(
            {
                "centralizer_order": len(model.group) // len(orbit),
                "class_size": len(orbit),
                "generator_indices": [
                    index for index, generator in enumerate(model.generators) if generator in orbit
                ],
            }
        )
        remaining -= orbit
    return sorted(result, key=lambda row: row["class_size"])


def direct_base() -> dict[str, object]:
    model = Model(3, 0)
    full = model.full

    @functools.cache
    def is_p(mask: Mask) -> bool:
        return not any(is_p(mask & ~model.closed[vertex]) for vertex in M.bits(mask))

    M.grundy.cache_clear()
    root_grundy = M.grundy(model.adjacency, full)
    assert root_grundy == 0 and is_p(full)
    follower = full & ~model.closed[model.identity_index]
    p_replies = 0
    for reply in M.bits(follower):
        child = follower & ~model.closed[reply]
        assert (M.grundy(model.adjacency, child) == 0) == is_p(child)
        p_replies += int(is_p(child))
    assert p_replies == follower.bit_count()
    return {
        "determinant_classes": list(model.classes),
        "field_order": 3,
        "legal_replies_after_identity": follower.bit_count(),
        "pair_product_orders": list(M.pair_product_orders(model.generators)),
        "p_replies_after_identity": p_replies,
        "root_grundy": root_grundy,
        "vertices": len(model.elements),
    }


def generate() -> dict[str, object]:
    model = Model(5, 0)
    classes = involution_classes(model)
    assert [row["class_size"] for row in classes] == [10, 15]
    assert sorted(index for row in classes for index in row["generator_indices"]) == [0, 1, 2]
    return {
        "conventions": {
            "canonicalization": "minimum labelled state under all right translations",
            "cayley": "left edges h--s*h",
            "defect_pair": "a mirror orbit {v,tau(v)} that is an edge",
            "parity_obstruction": (
                "a graph automorphism preserves stable 1-WL cells; a fixed-point-free "
                "involution requires every such cell to have even size"
            ),
        },
        "direct_pgl2_3_base": direct_base(),
        "pgl2_5_gate": {
            "determinant_classes": list(model.classes),
            "involution_classes": classes,
            "orbit_size": model.orbit_size,
            "pair_product_orders": list(M.pair_product_orders(model.generators)),
            "representative": [M.encode_point(point) for point in model.representative],
            "right_mirror_obstructions": [
                mirror_obstruction_case(
                    model,
                    label="class represented once in the generator triple",
                    root_generator_index=2,
                    mirror_moves=(0, 0, 1),
                    terminal_move=1,
                ),
                mirror_obstruction_case(
                    model,
                    label="class represented twice in the generator triple",
                    root_generator_index=0,
                    mirror_moves=(0, 0, 1, 0, 1, 3, 6, 7, 12, 7),
                    terminal_move=21,
                ),
            ],
        },
        "schema": "c294-recursive-defective-mirror-obstruction-v1",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    encoded = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.check is not None and encoded != args.check.read_text():
        raise SystemExit(f"generated output differs from {args.check}")
    if args.output is not None:
        args.output.write_text(encoded)
    if args.output is None and args.check is None:
        print(encoded, end="")


if __name__ == "__main__":
    main()
