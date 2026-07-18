#!/usr/bin/env python3
"""Exact first gate for C294 asymmetric mirror boundary words."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import Counter
from pathlib import Path
from types import ModuleType


Mask = int
Pairing = tuple[int, ...]
Rank = tuple[int, int]


def load_recursive_module() -> ModuleType:
    path = Path(__file__).with_name("2026-07-17-c294-recursive-defective-mirror.py")
    spec = importlib.util.spec_from_file_location("c294_recursive_mirror", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


R = load_recursive_module()
M = R.M


def encode_element(element: tuple[int, ...]) -> list[int]:
    return list(element)


def encode_move(model: R.Model, vertex: int) -> dict[str, object]:
    return {"element": encode_element(model.elements[vertex]), "vertex": vertex}


def mask_hash(mask: Mask, width: int) -> str:
    return hashlib.sha256(mask.to_bytes((width + 7) // 8, "little")).hexdigest()


class MirrorRanker:
    """Fast exact rank for a fixed global involutory graph automorphism."""

    def __init__(self, model: R.Model, pairing: Pairing) -> None:
        self.model = model
        self.pairing = pairing
        self.chunk_width = 15
        self.tables: list[tuple[int, ...]] = []
        for start in range(0, len(pairing), self.chunk_width):
            width = min(self.chunk_width, len(pairing) - start)
            table = [0] * (1 << width)
            for value in range(1, 1 << width):
                bit = value & -value
                offset = bit.bit_length() - 1
                table[value] = table[value ^ bit] | (1 << pairing[start + offset])
            self.tables.append(tuple(table))

        defect_representatives = 0
        for vertex, mate in enumerate(pairing):
            if vertex < mate and (model.adjacency[vertex] >> mate) & 1:
                defect_representatives |= 1 << vertex
        self.defect_representatives = defect_representatives
        assert all(self.image(1 << vertex) == 1 << pairing[vertex] for vertex in range(len(pairing)))

    def image(self, mask: Mask) -> Mask:
        result = 0
        chunk_mask = (1 << self.chunk_width) - 1
        for index, table in enumerate(self.tables):
            result |= table[(mask >> (index * self.chunk_width)) & chunk_mask]
        return result

    def rank(self, mask: Mask) -> Rank:
        image = self.image(mask)
        unbalanced_pairs = (mask ^ image).bit_count() // 2
        live_defect_pairs = (mask & image & self.defect_representatives).bit_count()
        return unbalanced_pairs, live_defect_pairs

    def verify(self, mask: Mask) -> None:
        image = sum(1 << self.pairing[vertex] for vertex in M.bits(mask))
        assert image == self.image(mask)
        assert self.rank(mask) == (
            (mask ^ image).bit_count() // 2,
            R.defect_pairs(self.model, mask, self.pairing),
        )


def direct_rank(model: R.Model, pairing: Pairing, mask: Mask) -> Rank:
    """Pair-oriented replay independent of the chunked mask permutation."""
    unbalanced_pairs = 0
    live_defect_pairs = 0
    for vertex, mate in enumerate(pairing):
        if vertex >= mate:
            continue
        vertex_live = bool((mask >> vertex) & 1)
        mate_live = bool((mask >> mate) & 1)
        unbalanced_pairs += int(vertex_live != mate_live)
        live_defect_pairs += int(
            vertex_live and mate_live and bool((model.adjacency[vertex] >> mate) & 1)
        )
    return unbalanced_pairs, live_defect_pairs


def global_pairing_extension(model: R.Model, mask: Mask, partial: Pairing) -> Pairing:
    candidates = []
    for element in model.elements:
        pairing = model.right_pairing(element)
        if all(pairing[vertex] == partial[vertex] for vertex in M.bits(mask)):
            candidates.append(pairing)
    assert len(candidates) == 1
    return candidates[0]


def alternating_cycles(model: R.Model, colours: tuple[int, int]) -> tuple[tuple[int, ...], ...]:
    unseen = set(range(len(model.elements)))
    cycles = []
    while unseen:
        start = min(unseen)
        cycle = []
        vertex = start
        phase = 0
        while not cycle or vertex != start or phase != 0:
            assert vertex in unseen
            cycle.append(vertex)
            unseen.remove(vertex)
            product = M.compose(model.generators[colours[phase]], model.elements[vertex])
            vertex = model.index[product]
            phase ^= 1
        cycles.append(tuple(cycle))
    return tuple(cycles)


def canonical_cycle_boundary(
    signs: tuple[str, ...], colours: tuple[int, int]
) -> tuple[tuple[str, int, int], ...] | None:
    marked = tuple(index for index, sign in enumerate(signs) if sign != ".")
    if not marked:
        return None
    size = len(signs)
    candidates = []
    for direction in (1, -1):
        for start in marked:
            word = []
            index = start
            while True:
                following = (index + direction) % size
                gap = 1
                while signs[following] == ".":
                    following = (following + direction) % size
                    gap += 1
                outgoing_colour = (
                    colours[index % 2]
                    if direction == 1
                    else colours[(index - 1) % 2]
                )
                word.append((signs[index], outgoing_colour, gap))
                index = following
                if index == start:
                    break
            candidates.append(tuple(word))
    return min(candidates)


def boundary_word(
    model: R.Model,
    pairing: Pairing,
    mask: Mask,
    colours: tuple[int, int],
) -> tuple[tuple[tuple[str, int, int], ...], ...]:
    words = []
    for cycle in alternating_cycles(model, colours):
        signs = tuple(
            "+"
            if (mask >> vertex) & 1 and not ((mask >> pairing[vertex]) & 1)
            else "-"
            if not ((mask >> vertex) & 1) and (mask >> pairing[vertex]) & 1
            else "."
            for vertex in cycle
        )
        word = canonical_cycle_boundary(signs, colours)
        if word is not None:
            words.append(word)
    return tuple(sorted(words))


def encode_boundary_word(
    word: tuple[tuple[tuple[str, int, int], ...], ...]
) -> list[list[dict[str, object]]]:
    return [
        [
            {"gap": gap, "outgoing_colour": colour, "sign": sign}
            for sign, colour, gap in cycle
        ]
        for cycle in word
    ]


def histogram_rows(counter: Counter[tuple[int, int]]) -> list[dict[str, int]]:
    return [
        {"covered_moves": covered, "opponent_moves": moves, "response_count": count}
        for (moves, covered), count in sorted(counter.items())
    ]


def strict_decrease_summary(
    model: R.Model,
    parent_mask: Mask,
    pairing: Pairing,
    defect_move: int,
    *,
    audit_closure: bool,
    backbone_colours: tuple[int, int],
) -> dict[str, object]:
    ranker = MirrorRanker(model, pairing)
    ranker.verify(parent_mask)
    follower = parent_mask & ~model.closed[defect_move]
    decrease_histogram: Counter[tuple[int, int]] = Counter()
    closure_histogram: Counter[tuple[int, int]] = Counter()
    perfect = []
    response_rows = []
    opponent_moves_tested = 0
    reply_children_ranked = 0
    colours = backbone_colours

    for response in M.bits(follower):
        state = follower & ~model.closed[response]
        state_rank = ranker.rank(state)
        decrease_coverage = 0
        closure_coverage = 0
        first_uncovered = None
        for move in M.bits(state):
            opponent_moves_tested += 1
            after_move = state & ~model.closed[move]
            has_decrease = False
            has_closure = False
            reply_ranks: Counter[Rank] = Counter()
            for reply in M.bits(after_move):
                reply_children_ranked += 1
                child_rank = ranker.rank(after_move & ~model.closed[reply])
                reply_ranks[child_rank] += 1
                has_decrease |= child_rank < state_rank
                has_closure |= child_rank == (0, 0)
                if has_decrease and (has_closure or not audit_closure):
                    break
            decrease_coverage += int(has_decrease)
            closure_coverage += int(has_closure)
            if not has_decrease and first_uncovered is None:
                first_uncovered = {
                    "move": encode_move(model, move),
                    "reply_rank_histogram": [
                        {"boundary_rank": list(rank), "reply_count": count}
                        for rank, count in sorted(reply_ranks.items())
                    ],
                }
        decrease_histogram[(state.bit_count(), decrease_coverage)] += 1
        if audit_closure:
            closure_histogram[(state.bit_count(), closure_coverage)] += 1
        word = boundary_word(model, pairing, state, colours)
        assert sum(len(cycle) for cycle in word) == 2 * state_rank[0]
        row = {
            "boundary_rank": list(state_rank),
            "boundary_word": encode_boundary_word(word),
            "covered_opponent_moves": decrease_coverage,
            "first_uncovered": first_uncovered,
            "opponent_moves": state.bit_count(),
            "response": encode_move(model, response),
            "state_sha256": mask_hash(state, len(model.elements)),
            "vertices": state.bit_count(),
        }
        response_rows.append(row)
        if decrease_coverage == state.bit_count():
            perfect.append(row)

    smallest_deficit = min(
        int(row["opponent_moves"]) - int(row["covered_opponent_moves"])
        for row in response_rows
    )
    best = [
        row
        for row in response_rows
        if int(row["opponent_moves"]) - int(row["covered_opponent_moves"])
        == smallest_deficit
    ]
    for row in best:
        response = int(row["response"]["vertex"])
        state = follower & ~model.closed[response]
        assert ranker.rank(state) == direct_rank(model, pairing, state)
        first_uncovered = row["first_uncovered"]
        assert isinstance(first_uncovered, dict)
        move = int(first_uncovered["move"]["vertex"])
        after_move = state & ~model.closed[move]
        assert all(
            direct_rank(model, pairing, after_move & ~model.closed[reply])
            >= direct_rank(model, pairing, state)
            for reply in M.bits(after_move)
        )

    result: dict[str, object] = {
        "decrease_coverage_histogram": histogram_rows(decrease_histogram),
        "defect_move": encode_move(model, defect_move),
        "legal_responses": follower.bit_count(),
        "minimum_uncovered_opponent_moves": smallest_deficit,
        "minimum_uncovered_responses": best,
        "opponent_moves_tested": opponent_moves_tested,
        "perfect_strict_decrease_responses": perfect,
        "reply_children_ranked": reply_children_ranked,
    }
    if audit_closure:
        result["closure_coverage_histogram"] = histogram_rows(closure_histogram)
    return result


def replay_terminal_case(
    model: R.Model,
    *,
    root_generator_index: int,
    mirror_moves: tuple[int, ...],
    terminal_move: int,
) -> dict[str, object]:
    partial = model.right_pairing(model.generators[root_generator_index])
    mask, partial = R.canonical_state(model, model.full, partial)
    for move in mirror_moves:
        mate = partial[move]
        assert not ((model.adjacency[move] >> mate) & 1)
        child = mask & ~model.closed[move] & ~model.closed[mate]
        mask, partial = R.canonical_state(model, child, R.restrict_pairing(partial, child))
    pairing = global_pairing_extension(model, mask, partial)
    assert (model.adjacency[terminal_move] >> pairing[terminal_move]) & 1
    summary = strict_decrease_summary(
        model,
        mask,
        pairing,
        terminal_move,
        audit_closure=True,
        backbone_colours=tuple(
            index for index in range(3) if index != root_generator_index
        ),
    )
    return {
        "mirror_generator_index": root_generator_index,
        "mirror_rounds": len(mirror_moves),
        "parent_boundary_rank": list(MirrorRanker(model, pairing).rank(mask)),
        "parent_state_sha256": mask_hash(mask, len(model.elements)),
        "parent_vertices": mask.bit_count(),
        "transition_audit": summary,
    }


def root_type_gate(model: R.Model) -> dict[str, object]:
    class_counts = Counter(model.classes)
    minority = next(
        index for index, class_value in enumerate(model.classes) if class_counts[class_value] == 1
    )
    pairing = model.right_pairing(model.generators[minority])
    summary = strict_decrease_summary(
        model,
        model.full,
        pairing,
        model.identity_index,
        audit_closure=False,
        backbone_colours=tuple(index for index in range(3) if index != minority),
    )
    return {
        "determinant_classes": list(model.classes),
        "minority_mirror_generator_index": minority,
        "orbit_size": model.orbit_size,
        "pair_product_orders": list(M.pair_product_orders(model.generators)),
        "representative": [M.encode_point(point) for point in model.representative],
        "transition_audit": summary,
        "type_index": model.type_index,
    }


def generate() -> dict[str, object]:
    model = R.Model(5, 0)
    terminal_cases = [
        replay_terminal_case(
            model,
            root_generator_index=2,
            mirror_moves=(0, 0, 1),
            terminal_move=1,
        ),
        replay_terminal_case(
            model,
            root_generator_index=0,
            mirror_moves=(0, 0, 1, 0, 1, 3, 6, 7, 12, 7),
            terminal_move=21,
        ),
    ]
    obstructed_type_indices = (0, 1, 2, 3, 7, 9, 11)
    root_gates = [root_type_gate(R.Model(5, index)) for index in obstructed_type_indices]
    return {
        "conventions": {
            "boundary_rank": [
                "number of mirror pairs with exactly one live vertex",
                "number of live adjacent mirror pairs",
            ],
            "boundary_word": (
                "multiset of canonical signed cyclic words on the two nonmirror-colour "
                "backbones; + means live with dead mate, - means dead with live mate, "
                "and each letter records outgoing colour and cyclic gap to the next letter"
            ),
            "closure": (
                "after one opponent move, a legal reply leaves boundary rank (0,0), "
                "hence the fixed original mirror is a nonadjacent pairing"
            ),
            "strict_rank_strategy": (
                "after every opponent move choose a legal reply with lexicographically "
                "smaller boundary rank, with rank (0,0) as the pairing base"
            ),
        },
        "direct_pgl2_3_base": R.direct_base(),
        "pgl2_5_obstructed_root_gates": root_gates,
        "pgl2_5_terminal_obstruction_gates": terminal_cases,
        "schema": "c294-asymmetric-boundary-word-v1",
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
