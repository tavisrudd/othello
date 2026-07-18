#!/usr/bin/env python3
"""Exact linked-port and local-transition audit for the C294 mixed scar."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import Counter, defaultdict
from pathlib import Path
from types import ModuleType


Mask = int
Pairing = tuple[int, ...]
Rank = tuple[int, int]
Relation = tuple[tuple[str, int], ...]
CanonicalDiagram = tuple[tuple[tuple[object, ...], ...], tuple[Relation, ...]]


def load_boundary_module() -> ModuleType:
    path = Path(__file__).with_name("2026-07-17-c294-asymmetric-boundary-word.py")
    spec = importlib.util.spec_from_file_location("c294_boundary_word", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


B = load_boundary_module()
R = B.R
M = B.M


def add_relation(
    relations: list[list[list[tuple[str, int]]]],
    first: int,
    second: int,
    relation: tuple[str, int],
) -> None:
    relations[first][second].append(relation)
    if first != second:
        relations[second][first].append(relation)


def refine_partition(
    partition: tuple[tuple[int, ...], ...], relations: tuple[tuple[Relation, ...], ...]
) -> tuple[tuple[int, ...], ...]:
    while True:
        refined = []
        for cell in partition:
            blocks: dict[tuple[object, ...], list[int]] = defaultdict(list)
            for vertex in cell:
                signature = []
                for target in partition:
                    counts = Counter(relations[vertex][other] for other in target)
                    signature.append(tuple(sorted(counts.items())))
                blocks[tuple(signature)].append(vertex)
            refined.extend(tuple(sorted(blocks[key])) for key in sorted(blocks))
        next_partition = tuple(refined)
        if next_partition == partition:
            return partition
        partition = next_partition


def canonical_coloured_graph(
    vertex_colours: tuple[tuple[object, ...], ...],
    relations: tuple[tuple[Relation, ...], ...],
) -> CanonicalDiagram:
    colour_cells: dict[tuple[object, ...], list[int]] = defaultdict(list)
    for vertex, colour in enumerate(vertex_colours):
        colour_cells[colour].append(vertex)
    initial = tuple(tuple(colour_cells[colour]) for colour in sorted(colour_cells))

    def search(partition: tuple[tuple[int, ...], ...]) -> CanonicalDiagram:
        partition = refine_partition(partition, relations)
        if all(len(cell) == 1 for cell in partition):
            order = tuple(cell[0] for cell in partition)
            return (
                tuple(vertex_colours[vertex] for vertex in order),
                tuple(relations[first][second] for first in order for second in order),
            )
        cell_index = min(
            (index for index, cell in enumerate(partition) if len(cell) > 1),
            key=lambda index: (len(partition[index]), index),
        )
        cell = partition[cell_index]
        candidates = []
        for vertex in cell:
            remainder = tuple(other for other in cell if other != vertex)
            individualized = (
                partition[:cell_index]
                + ((vertex,), remainder)
                + partition[cell_index + 1 :]
            )
            candidates.append(search(individualized))
        return min(candidates)

    return search(initial)


def diagram_hash(canonical: CanonicalDiagram) -> str:
    payload = json.dumps(canonical, separators=(",", ":"))
    return hashlib.sha256(payload.encode()).hexdigest()


def linked_port_diagram(
    model: R.Model,
    pairing: Pairing,
    mask: Mask,
    backbone_colours: tuple[int, int],
    third_colour: int,
    *,
    include_cut_context: bool,
    twist_radius: int | None = None,
) -> tuple[CanonicalDiagram, dict[str, int]]:
    assert twist_radius is None or (include_cut_context and twist_radius >= 0)
    ports = {
        vertex
        for vertex in range(len(model.elements))
        if bool((mask >> vertex) & 1) != bool((mask >> pairing[vertex]) & 1)
    }
    assert all(pairing[vertex] in ports for vertex in ports)
    cycles = B.alternating_cycles(model, backbone_colours)
    vertex_cycle = {
        vertex: cycle_index
        for cycle_index, cycle in enumerate(cycles)
        for vertex in cycle
    }
    cut_endpoints = set()
    cut_cycle_vertices = set()
    cut_cycle_indices = set()
    cut_backbones = 0
    if include_cut_context:
        for cycle_index, cycle in enumerate(cycles):
            live_count = sum((mask >> vertex) & 1 for vertex in cycle)
            if live_count in (0, len(cycle)):
                continue
            cut_backbones += 1
            cut_cycle_indices.add(cycle_index)
            cut_cycle_vertices.update(cycle)
            for position, vertex in enumerate(cycle):
                following = cycle[(position + 1) % len(cycle)]
                if bool((mask >> vertex) & 1) != bool((mask >> following) & 1):
                    cut_endpoints.add(vertex)
                    cut_endpoints.add(following)
    twist_cycle_indices = set(cut_cycle_indices)
    if twist_radius is not None:
        for _ in range(twist_radius):
            expanded = set(twist_cycle_indices)
            for cycle_index in twist_cycle_indices:
                for vertex in cycles[cycle_index]:
                    third = model.index[
                        M.compose(
                            model.generators[third_colour], model.elements[vertex]
                        )
                    ]
                    expanded.add(vertex_cycle[third])
                    expanded.add(vertex_cycle[pairing[vertex]])
            twist_cycle_indices = expanded
    twist_sources = (
        {
            vertex
            for cycle_index in twist_cycle_indices
            for vertex in cycles[cycle_index]
        }
        if twist_radius is not None
        else set()
    )
    third_sources = ports | cut_endpoints | twist_sources
    tau_sources = ports | cut_endpoints | twist_sources
    third_neighbour = {
        vertex: model.index[M.compose(model.generators[third_colour], model.elements[vertex])]
        for vertex in third_sources
    }
    tau_neighbour = {vertex: pairing[vertex] for vertex in tau_sources}
    markers = (
        third_sources
        | set(third_neighbour.values())
        | set(tau_neighbour.values())
    )

    marker_nodes: dict[int, int] = {}
    vertex_colours: list[tuple[object, ...]] = []
    for vertex in sorted(markers):
        sign = (
            "+"
            if (mask >> vertex) & 1 and not ((mask >> pairing[vertex]) & 1)
            else "-"
            if not ((mask >> vertex) & 1) and (mask >> pairing[vertex]) & 1
            else "."
        )
        marker_nodes[vertex] = len(vertex_colours)
        vertex_colours.append(
            (
                "marker",
                sign,
                int(bool((mask >> vertex) & 1)),
                int(vertex in cut_endpoints),
            )
        )

    segment_rows: list[tuple[int, int, int, int, int]] = []
    affected_cycles = 0
    for cycle_index, cycle in enumerate(cycles):
        positions = sorted(
            position for position, vertex in enumerate(cycle) if vertex in markers
        )
        if not positions:
            continue
        affected_cycles += 1
        for offset, position in enumerate(positions):
            following = positions[(offset + 1) % len(positions)]
            gap = (following - position) % len(cycle)
            if gap == 0:
                gap = len(cycle)
            first_vertex = cycle[position]
            second_vertex = cycle[following]
            first_colour = backbone_colours[position % 2]
            second_colour = backbone_colours[(following - 1) % 2]
            segment_rows.append(
                (
                    marker_nodes[first_vertex],
                    marker_nodes[second_vertex],
                    gap,
                    first_colour,
                    second_colour,
                )
            )

    for _, _, gap, _, _ in segment_rows:
        vertex_colours.append(("segment", gap))
    size = len(vertex_colours)
    raw_relations = [[[] for _ in range(size)] for _ in range(size)]
    segment_start = len(marker_nodes)
    for index, (first, second, _, first_colour, second_colour) in enumerate(segment_rows):
        segment = segment_start + index
        add_relation(raw_relations, first, segment, ("cycle", first_colour))
        add_relation(raw_relations, second, segment, ("cycle", second_colour))

    seen_tau_edges = set()
    for vertex, mate in tau_neighbour.items():
        edge = tuple(sorted((marker_nodes[vertex], marker_nodes[mate])))
        if edge not in seen_tau_edges:
            seen_tau_edges.add(edge)
            add_relation(
                raw_relations,
                edge[0],
                edge[1],
                ("tau", 0),
            )
    seen_third_edges = set()
    for vertex, neighbour in third_neighbour.items():
        edge = tuple(sorted((marker_nodes[vertex], marker_nodes[neighbour])))
        if edge not in seen_third_edges:
            seen_third_edges.add(edge)
            add_relation(raw_relations, edge[0], edge[1], ("third", third_colour))

    relations = tuple(
        tuple(tuple(sorted(raw_relations[first][second])) for second in range(size))
        for first in range(size)
    )
    canonical = canonical_coloured_graph(tuple(vertex_colours), relations)
    return canonical, {
        "affected_backbones": affected_cycles,
        "anchors": len(set(third_neighbour.values()) - ports),
        "cut_backbones": cut_backbones,
        "cut_endpoints": len(cut_endpoints),
        "diagram_nodes": size,
        "ports": len(ports),
        "segments": len(segment_rows),
        "tau_anchors": len(set(tau_neighbour.values()) - tau_sources),
        "twist_sources": len(twist_sources),
        "twist_backbones": len(twist_cycle_indices) if twist_radius is not None else 0,
    }


def direct_diagram_relabel_check(
    model: R.Model,
    pairing: Pairing,
    mask: Mask,
    backbone_colours: tuple[int, int],
    third_colour: int,
    canonical: CanonicalDiagram,
    *,
    include_cut_context: bool,
    twist_radius: int | None = None,
) -> None:
    commuting_actions = [
        action
        for action in model.right_actions
        if all(action[pairing[vertex]] == pairing[action[vertex]] for vertex in range(len(pairing)))
    ]
    assert commuting_actions
    for action in (commuting_actions[0], commuting_actions[-1]):
        mapped = R.map_mask(mask, action)
        replay, _ = linked_port_diagram(
            model,
            pairing,
            mapped,
            backbone_colours,
            third_colour,
            include_cut_context=include_cut_context,
            twist_radius=twist_radius,
        )
        assert replay == canonical


def local_rank_signature(
    model: R.Model, ranker: B.MirrorRanker, state: Mask
) -> tuple[tuple[tuple[tuple[Rank, int], ...], int], ...]:
    move_signatures: Counter[tuple[tuple[Rank, int], ...]] = Counter()
    for move in M.bits(state):
        follower = state & ~model.closed[move]
        replies = Counter(
            ranker.rank(follower & ~model.closed[reply]) for reply in M.bits(follower)
        )
        move_signatures[tuple(sorted(replies.items()))] += 1
    return tuple(sorted(move_signatures.items()))


def signature_hash(signature: object) -> str:
    payload = json.dumps(signature, separators=(",", ":"))
    return hashlib.sha256(payload.encode()).hexdigest()


def unlinked_word_key(
    model: R.Model,
    pairing: Pairing,
    state: Mask,
    backbone_colours: tuple[int, int],
) -> object:
    return B.boundary_word(model, pairing, state, backbone_colours)


def partition_audit(rows: list[dict[str, object]], key_name: str) -> dict[str, int]:
    classes: dict[object, list[dict[str, object]]] = defaultdict(list)
    for row in rows:
        classes[row[key_name]].append(row)
    ambiguous = [
        group
        for group in classes.values()
        if len({row["local_signature"] for row in group}) > 1
    ]
    return {
        "ambiguous_classes": len(ambiguous),
        "ambiguous_states": sum(len(group) for group in ambiguous),
        "classes": len(classes),
        "largest_class": max(map(len, classes.values())),
        "states": len(rows),
    }


def full_twist_refinement(
    rows: list[dict[str, object]],
    *,
    model: R.Model,
    pairing: Pairing,
    backbone_colours: tuple[int, int],
    third_colour: int,
) -> dict[str, object]:
    cut_classes: dict[object, list[dict[str, object]]] = defaultdict(list)
    for row in rows:
        cut_classes[row["cut_diagram"]].append(row)
    ambiguous_groups = [
        group
        for group in cut_classes.values()
        if len({row["local_signature"] for row in group}) > 1
    ]
    if not ambiguous_groups:
        return {
            "input_ambiguous_classes": 0,
            "input_ambiguous_states": 0,
            "radius_audits": [],
        }
    total_backbones = len(B.alternating_cycles(model, backbone_colours))
    radius_audits = []
    for radius in range(6):
        twist_rows = []
        sizes = []
        for group_index, group in enumerate(ambiguous_groups):
            for row_index, row in enumerate(group):
                state = int(row["_state"])
                canonical, counts = linked_port_diagram(
                    model,
                    pairing,
                    state,
                    backbone_colours,
                    third_colour,
                    include_cut_context=True,
                    twist_radius=radius,
                )
                sizes.append((counts["twist_backbones"], counts["diagram_nodes"]))
                if group_index == 0 and row_index == 0:
                    direct_diagram_relabel_check(
                        model,
                        pairing,
                        state,
                        backbone_colours,
                        third_colour,
                        canonical,
                        include_cut_context=True,
                        twist_radius=radius,
                    )
                twist_rows.append(
                    {
                        "full_twist_diagram": (group_index, canonical),
                        "local_signature": row["local_signature"],
                    }
                )
        audit = partition_audit(twist_rows, "full_twist_diagram")
        radius_audits.append(
            {
                **audit,
                "maximum_diagram_nodes": max(size[1] for size in sizes),
                "maximum_twist_backbones": max(size[0] for size in sizes),
                "minimum_twist_backbones": min(size[0] for size in sizes),
                "radius": radius,
                "total_backbones": total_backbones,
            }
        )
        if audit["ambiguous_states"] == 0 or all(
            size[0] == total_backbones for size in sizes
        ):
            break
    return {
        "input_ambiguous_classes": len(ambiguous_groups),
        "input_ambiguous_states": sum(map(len, ambiguous_groups)),
        "radius_audits": radius_audits,
    }


def audit_context(
    *,
    label: str,
    model: R.Model,
    parent_mask: Mask,
    pairing: Pairing,
    defect_move: int,
    backbone_colours: tuple[int, int],
    third_colour: int,
) -> tuple[dict[str, object], list[dict[str, object]]]:
    ranker = B.MirrorRanker(model, pairing)
    follower = parent_mask & ~model.closed[defect_move]
    rows = []
    diagram_size_histogram: Counter[tuple[int, int, int, int]] = Counter()
    cut_diagram_size_histogram: Counter[tuple[int, int, int, int, int, int]] = Counter()
    local_rank_children = 0
    exact_grundy_histogram: Counter[int] = Counter()
    if model.q == 3:
        M.grundy.cache_clear()
    for response_index, response in enumerate(M.bits(follower)):
        state = follower & ~model.closed[response]
        canonical, counts = linked_port_diagram(
            model,
            pairing,
            state,
            backbone_colours,
            third_colour,
            include_cut_context=False,
        )
        cut_canonical, cut_counts = linked_port_diagram(
            model,
            pairing,
            state,
            backbone_colours,
            third_colour,
            include_cut_context=True,
        )
        if response_index in (0, follower.bit_count() - 1):
            direct_diagram_relabel_check(
                model,
                pairing,
                state,
                backbone_colours,
                third_colour,
                canonical,
                include_cut_context=False,
            )
            direct_diagram_relabel_check(
                model,
                pairing,
                state,
                backbone_colours,
                third_colour,
                cut_canonical,
                include_cut_context=True,
            )
        local_signature = local_rank_signature(model, ranker, state)
        if model.q == 3:
            exact_grundy_histogram[M.grundy(model.adjacency, state)] += 1
        if response_index == 0:
            sample_moves = tuple(M.bits(state))
            for move in (sample_moves[0], sample_moves[-1]):
                sample_follower = state & ~model.closed[move]
                for reply in M.bits(sample_follower):
                    child = sample_follower & ~model.closed[reply]
                    assert ranker.rank(child) == B.direct_rank(model, pairing, child)
        local_rank_children += sum(
            move_count * sum(reply_count for _, reply_count in reply_signature)
            for reply_signature, move_count in local_signature
        )
        diagram_size_histogram[
            (
                counts["ports"],
                counts["anchors"],
                counts["affected_backbones"],
                counts["diagram_nodes"],
            )
        ] += 1
        cut_diagram_size_histogram[
            (
                cut_counts["ports"],
                cut_counts["anchors"],
                cut_counts["affected_backbones"],
                cut_counts["cut_backbones"],
                cut_counts["cut_endpoints"],
                cut_counts["diagram_nodes"],
            )
        ] += 1
        rows.append(
            {
                "_state": state,
                "context": label,
                "cut_diagram": cut_canonical,
                "cut_diagram_hash": diagram_hash(cut_canonical),
                "diagram": canonical,
                "diagram_hash": diagram_hash(canonical),
                "local_signature": local_signature,
                "local_signature_hash": signature_hash(local_signature),
                "response": response,
                "unlinked_word": unlinked_word_key(
                    model, pairing, state, backbone_colours
                ),
            }
        )

    summary = {
        "context": label,
        "cut_diagram_size_histogram": [
            {
                "affected_backbones": key[2],
                "anchors": key[1],
                "cut_backbones": key[3],
                "cut_endpoints": key[4],
                "diagram_nodes": key[5],
                "ports": key[0],
                "states": count,
            }
            for key, count in sorted(cut_diagram_size_histogram.items())
        ],
        "diagram_size_histogram": [
            {
                "affected_backbones": key[2],
                "anchors": key[1],
                "diagram_nodes": key[3],
                "ports": key[0],
                "states": count,
            }
            for key, count in sorted(diagram_size_histogram.items())
        ],
        "linked_partition": partition_audit(rows, "diagram"),
        "linked_cut_partition": partition_audit(rows, "cut_diagram"),
        "full_twist_refinement": full_twist_refinement(
            rows,
            model=model,
            pairing=pairing,
            backbone_colours=backbone_colours,
            third_colour=third_colour,
        ),
        "local_rank_children": local_rank_children,
        "response_states": len(rows),
        "unlinked_partition": partition_audit(rows, "unlinked_word"),
    }
    if model.q == 3:
        summary["exact_grundy_histogram"] = {
            str(value): count for value, count in sorted(exact_grundy_histogram.items())
        }
    return summary, rows


def terminal_contexts() -> list[dict[str, object]]:
    model = R.Model(5, 0)
    specifications = (
        (2, (0, 0, 1), 1),
        (0, (0, 0, 1, 0, 1, 3, 6, 7, 12, 7), 21),
    )
    contexts = []
    for root_generator_index, mirror_moves, terminal_move in specifications:
        partial = model.right_pairing(model.generators[root_generator_index])
        mask, partial = R.canonical_state(model, model.full, partial)
        for move in mirror_moves:
            mate = partial[move]
            child = mask & ~model.closed[move] & ~model.closed[mate]
            mask, partial = R.canonical_state(
                model, child, R.restrict_pairing(partial, child)
            )
        pairing = B.global_pairing_extension(model, mask, partial)
        contexts.append(
            {
                "backbone_colours": tuple(
                    index for index in range(3) if index != root_generator_index
                ),
                "defect_move": terminal_move,
                "label": f"terminal-mirror-{root_generator_index}",
                "model": model,
                "pairing": pairing,
                "parent_mask": mask,
                "third_colour": root_generator_index,
            }
        )
    return contexts


def root_contexts() -> list[dict[str, object]]:
    contexts = []
    direct_model = R.Model(3, 0)
    direct_class_counts = Counter(direct_model.classes)
    direct_minority = next(
        index
        for index, class_value in enumerate(direct_model.classes)
        if direct_class_counts[class_value] == 1
    )
    contexts.append(
        {
            "backbone_colours": tuple(
                index for index in range(3) if index != direct_minority
            ),
            "defect_move": direct_model.identity_index,
            "label": "direct-pgl2-3-base",
            "model": direct_model,
            "pairing": direct_model.right_pairing(
                direct_model.generators[direct_minority]
            ),
            "parent_mask": direct_model.full,
            "third_colour": direct_minority,
        }
    )
    for type_index in (0, 1, 2, 3, 7, 9, 11):
        model = R.Model(5, type_index)
        class_counts = Counter(model.classes)
        minority = next(
            index
            for index, class_value in enumerate(model.classes)
            if class_counts[class_value] == 1
        )
        contexts.append(
            {
                "backbone_colours": tuple(
                    index for index in range(3) if index != minority
                ),
                "defect_move": model.identity_index,
                "label": f"root-type-{type_index}",
                "model": model,
                "pairing": model.right_pairing(model.generators[minority]),
                "parent_mask": model.full,
                "third_colour": minority,
            }
        )
    return contexts


def generate() -> dict[str, object]:
    summaries = []
    all_rows = []
    for context in root_contexts() + terminal_contexts():
        summary, rows = audit_context(**context)
        summaries.append(summary)
        all_rows.extend(rows)

    pooled_linked = partition_audit(all_rows, "diagram")
    pooled_linked_cut = partition_audit(all_rows, "cut_diagram")
    pooled_unlinked = partition_audit(all_rows, "unlinked_word")
    hybrid_classes = 0
    hybrid_ambiguous_states = 0
    for summary in summaries:
        cut = summary["linked_cut_partition"]
        refinement = summary["full_twist_refinement"]
        radius_audits = refinement["radius_audits"]
        if not radius_audits:
            hybrid_classes += int(cut["classes"])
            hybrid_ambiguous_states += int(cut["ambiguous_states"])
            continue
        final = radius_audits[-1]
        hybrid_classes += (
            int(cut["classes"])
            - int(refinement["input_ambiguous_classes"])
            + int(final["classes"])
        )
        hybrid_ambiguous_states += int(final["ambiguous_states"])
    return {
        "contexts": summaries,
        "conventions": {
            "anchors": "third-colour neighbours of signed boundary ports",
            "linked_port_diagram": (
                "canonical coloured relational graph of signed ports, tau links, third links, "
                "and alternating-backbone segments labelled by length and incident colours"
            ),
            "linked_cut_diagram": (
                "linked port diagram augmented by every live/dead transition endpoint on every "
                "cut backbone and its tau/third anchors"
            ),
            "twist_radius": (
                "number of successive backbone layers added through tau and third-matching "
                "neighbours, with radius zero equal to every initially cut backbone"
            ),
            "local_rank_signature": (
                "multiset over opponent moves of the multiset of boundary ranks of every legal "
                "reply child"
            ),
            "unlinked_word": (
                "the predecessor multiset of signed cyclic words, without tau links or third "
                "matching anchors"
            ),
        },
        "hybrid_within_context_partition": {
            "ambiguous_states": hybrid_ambiguous_states,
            "classes": hybrid_classes,
            "states": len(all_rows),
        },
        "pooled_linked_partition": pooled_linked,
        "pooled_linked_cut_partition": pooled_linked_cut,
        "pooled_unlinked_partition": pooled_unlinked,
        "schema": "c294-linked-port-diagram-v1",
        "total_local_rank_children": sum(
            int(summary["local_rank_children"]) for summary in summaries
        ),
        "total_response_states": len(all_rows),
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
