#!/usr/bin/env python3
"""C80: audit a pairing-shell lift on the positive-overload certificate DAG.

For a certified positive-overload state S, define its strict reply graph H_S
on the legal moves.  Distinct x,y are adjacent when they are jointly legal,
Omega(S+x+y) < Omega(S), and the target is again in the structural copycat
survivor.  Kernel membership says only that H_S has no isolated vertices.
This script tests the stronger pairing-shell possibilities:

* a perfect matching when |H_S| is even;
* a near-perfect matching when |H_S| is odd; and
* whether every marked opponent belongs to some maximum matching.

The audit covers every positive state reached by the deterministic q=13/q=17
copycat-survivor certificate DAG.  It first tests the edges already selected
by that certificate and expands to all strict survivor replies only on a
matching failure.

Run:
  python3 rust/scripts/c80_positive_pairing_shell.py
Check:
  python3 rust/scripts/c80_positive_pairing_shell.py --check
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from collections import Counter
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_adaptive_copycat_survivor.py"
OUT = ROOT / "notes/2026-07-25-c80-positive-pairing-shell.json"
Q19_SOURCE = ROOT / "notes/2026-07-24-c80-scale-survivor-falsifiers.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_positive_pairing_base")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def maximum_matching(adjacency: tuple[int, ...]) -> tuple[int, ...]:
    """Edmonds blossom maximum matching for a small undirected graph."""
    n = len(adjacency)
    match = [-1] * n
    parent = [-1] * n
    base = list(range(n))
    used = [False] * n
    blossom = [False] * n

    def lca(left: int, right: int) -> int:
        seen = [False] * n
        while True:
            left = base[left]
            seen[left] = True
            if match[left] == -1:
                break
            left = parent[match[left]]
        while True:
            right = base[right]
            if seen[right]:
                return right
            right = parent[match[right]]

    def mark_path(vertex: int, root: int, child: int) -> None:
        while base[vertex] != root:
            blossom[base[vertex]] = True
            blossom[base[match[vertex]]] = True
            parent[vertex] = child
            child = match[vertex]
            vertex = parent[match[vertex]]

    def augment(root: int) -> bool:
        nonlocal base, parent, used, blossom
        used = [False] * n
        parent = [-1] * n
        base = list(range(n))
        queue = [root]
        used[root] = True
        head = 0
        while head < len(queue):
            vertex = queue[head]
            head += 1
            neighbours = adjacency[vertex]
            while neighbours:
                low = neighbours & -neighbours
                neighbours ^= low
                other = low.bit_length() - 1
                if base[vertex] == base[other] or match[vertex] == other:
                    continue
                if (
                    other == root
                    or match[other] != -1
                    and parent[match[other]] != -1
                ):
                    common = lca(vertex, other)
                    blossom = [False] * n
                    mark_path(vertex, common, other)
                    mark_path(other, common, vertex)
                    for index in range(n):
                        if blossom[base[index]]:
                            base[index] = common
                            if not used[index]:
                                used[index] = True
                                queue.append(index)
                elif parent[other] == -1:
                    parent[other] = vertex
                    if match[other] == -1:
                        current = other
                        while current != -1:
                            previous = parent[current]
                            following = match[previous] if previous != -1 else -1
                            match[current] = previous
                            if previous != -1:
                                match[previous] = current
                            current = following
                        return True
                    mate = match[other]
                    used[mate] = True
                    queue.append(mate)
        return False

    for vertex in range(n):
        if match[vertex] == -1:
            augment(vertex)
    return tuple(match)


def matching_size(match: tuple[int, ...]) -> int:
    return sum(other >= 0 for other in match) // 2


def induced_without(
    adjacency: tuple[int, ...], removed: int
) -> tuple[int, ...]:
    vertices = [index for index in range(len(adjacency)) if index != removed]
    position = {vertex: index for index, vertex in enumerate(vertices)}
    return tuple(
        sum(
            1 << position[other]
            for other in vertices
            if adjacency[vertex] & (1 << other)
        )
        for vertex in vertices
    )


def possible_unmatched_vertices(adjacency: tuple[int, ...]) -> tuple[int, ...]:
    if len(adjacency) % 2 == 0:
        return ()
    target = (len(adjacency) - 1) // 2
    return tuple(
        vertex
        for vertex in range(len(adjacency))
        if matching_size(maximum_matching(induced_without(adjacency, vertex)))
        == target
    )


def pairing_shell(
    adjacency: tuple[int, ...],
) -> tuple[tuple[tuple[int, int], ...], int | None] | None:
    """Perfect matching, or near-perfect matching plus one nonisolated bye."""
    match = maximum_matching(adjacency)
    target = len(adjacency) // 2
    if matching_size(match) != target:
        return None
    if len(adjacency) % 2 == 0:
        return (
            tuple(
                (left, right)
                for left, right in enumerate(match)
                if left < right
            ),
            None,
        )
    for bye in range(len(adjacency)):
        if not adjacency[bye]:
            continue
        reduced = induced_without(adjacency, bye)
        reduced_match = maximum_matching(reduced)
        if matching_size(reduced_match) != target:
            continue
        vertices = [index for index in range(len(adjacency)) if index != bye]
        pairs = tuple(
            (vertices[left], vertices[right])
            for left, right in enumerate(reduced_match)
            if left < right
        )
        return pairs, bye
    return None


def brute_matching_size(adjacency: tuple[int, ...]) -> int:
    @lru_cache(maxsize=None)
    def solve(vertices: int) -> int:
        if not vertices:
            return 0
        low = vertices & -vertices
        left = low.bit_length() - 1
        best = solve(vertices ^ low)
        candidates = adjacency[left] & vertices
        while candidates:
            right = candidates & -candidates
            candidates ^= right
            best = max(best, 1 + solve(vertices ^ low ^ right))
        return best

    return solve((1 << len(adjacency)) - 1)


def matching_self_check() -> int:
    checked = 0
    for order in range(1, 7):
        pairs = [
            (left, right)
            for left in range(order)
            for right in range(left + 1, order)
        ]
        for edge_mask in range(1 << len(pairs)):
            adjacency = [0] * order
            for edge, (left, right) in enumerate(pairs):
                if edge_mask & (1 << edge):
                    adjacency[left] |= 1 << right
                    adjacency[right] |= 1 << left
            graph = tuple(adjacency)
            assert matching_size(maximum_matching(graph)) == brute_matching_size(graph)
            checked += 1
    return checked


def chosen_reply_graph(kernel, mask: int) -> tuple[tuple[int, ...], tuple[int, ...]]:
    cells = tuple(BASE.BASE.GEOMETRY.bits(kernel.game.legal_mask(mask)))
    index = {cell: position for position, cell in enumerate(cells)}
    adjacency = [0] * len(cells)
    for opponent in cells:
        reply = kernel.responses[(mask, opponent)]
        left = index[opponent]
        right = index[reply]
        adjacency[left] |= 1 << right
        adjacency[right] |= 1 << left
    return cells, tuple(adjacency)


def full_reply_graph(kernel, mask: int) -> tuple[tuple[int, ...], tuple[int, ...]]:
    cells = tuple(BASE.BASE.GEOMETRY.bits(kernel.game.legal_mask(mask)))
    adjacency = [0] * len(cells)
    old_omega = kernel.omega(mask)
    for left, opponent in enumerate(cells):
        child = mask | (1 << opponent)
        legal_replies = kernel.game.legal_mask(child)
        for right in range(left + 1, len(cells)):
            reply = cells[right]
            if not (legal_replies & (1 << reply)):
                continue
            target = child | (1 << reply)
            if kernel.omega(target) < old_omega and kernel.contains(target):
                adjacency[left] |= 1 << right
                adjacency[right] |= 1 << left
    return cells, tuple(adjacency)


def positive_certificate_states(kernel, roots: list[int]) -> set[int]:
    seen: set[int] = set()
    stack = list(roots)
    while stack:
        mask = stack.pop()
        if mask in seen or kernel.omega(mask) == 0:
            continue
        if not kernel.contains(mask):
            raise AssertionError("certificate traversal reached a rejected state")
        seen.add(mask)
        for opponent in BASE.BASE.GEOMETRY.bits(kernel.game.legal_mask(mask)):
            reply = kernel.responses[(mask, opponent)]
            target = mask | (1 << opponent) | (1 << reply)
            if kernel.omega(target) > 0:
                stack.append(target)
    return seen


class PositivePairingKernel(BASE.CopycatKernel):
    """Well-founded strict-Omega survivor using pairing shells at every rank."""

    def __init__(self, q: int):
        super().__init__(q)
        self.positive_shells: dict[int, tuple] = {}

    @lru_cache(maxsize=None)
    def contains(self, mask: int) -> bool:
        old_omega = self.omega(mask)
        if old_omega == 0:
            witness = self.copycat_witness(mask)
            if witness is not None:
                self.boundary.add(mask)
                self.copycat_boundary[mask] = witness
                return True
            return False
        cells = tuple(BASE.BASE.GEOMETRY.bits(self.game.legal_mask(mask)))
        adjacency = [0] * len(cells)
        replies: dict[tuple[int, int], int] = {}
        for left, opponent in enumerate(cells):
            child = mask | (1 << opponent)
            legal_replies = self.game.legal_mask(child)
            for right in range(left + 1, len(cells)):
                reply = cells[right]
                if not (legal_replies & (1 << reply)):
                    continue
                target = child | (1 << reply)
                if self.omega(target) < old_omega and self.contains(target):
                    adjacency[left] |= 1 << right
                    adjacency[right] |= 1 << left
                    replies[(left, right)] = target
        graph = tuple(adjacency)
        shell = pairing_shell(graph)
        if shell is None:
            return False
        pairs, bye = shell
        special = None
        if bye is not None:
            neighbour_bit = graph[bye] & -graph[bye]
            neighbour = neighbour_bit.bit_length() - 1
            special = (bye, neighbour)
        self.positive_shells[mask] = (
            cells,
            pairs,
            special,
            tuple(sorted(replies.items())),
        )
        return True


def audit_pairing_kernel(q: int) -> dict:
    kernel = PositivePairingKernel(q)
    old_kernel = None
    records = []
    for label in BASE.BASE.escape_parameters(BASE.ROWS, q):
        mask = kernel.game.base_mask(label)
        records.append(
            {
                "t4": list(label),
                "omega": kernel.omega(mask),
                "positive_pairing_survivor": kernel.contains(mask),
                "exact_cap_value": "N" if kernel.game.value(mask) else "P",
            }
        )
    rejected_p_obstructions = []
    for row in records:
        if row["exact_cap_value"] != "P" or row["positive_pairing_survivor"]:
            continue
        mask = kernel.game.base_mask(tuple(row["t4"]))
        cells = tuple(BASE.BASE.GEOMETRY.bits(kernel.game.legal_mask(mask)))
        adjacency = [0] * len(cells)
        old_omega = kernel.omega(mask)
        for left, opponent in enumerate(cells):
            child = mask | (1 << opponent)
            legal_replies = kernel.game.legal_mask(child)
            for right in range(left + 1, len(cells)):
                reply = cells[right]
                if not (legal_replies & (1 << reply)):
                    continue
                target = child | (1 << reply)
                if kernel.omega(target) < old_omega and kernel.contains(target):
                    adjacency[left] |= 1 << right
                    adjacency[right] |= 1 << left
        graph = tuple(adjacency)
        match = maximum_matching(graph)
        isolated = [
            index for index, neighbours in enumerate(graph) if not neighbours
        ]
        if old_kernel is None:
            old_kernel = BASE.CopycatKernel(q)
        assert old_kernel.contains(mask)
        isolated_rows = []
        for index in isolated:
            opponent = cells[index]
            child = mask | (1 << opponent)
            old_replies = []
            for reply in BASE.BASE.GEOMETRY.bits(old_kernel.game.legal_mask(child)):
                target = child | (1 << reply)
                if (
                    old_kernel.omega(target) < old_kernel.omega(mask)
                    and old_kernel.contains(target)
                ):
                    old_replies.append(
                        {
                            "reply": list(old_kernel.game.cell_tuple(reply)),
                            "target_omega": old_kernel.omega(target),
                            "positive_pairing_target": kernel.contains(target),
                        }
                    )
            isolated_rows.append(
                {
                    "opponent": list(kernel.game.cell_tuple(opponent)),
                    "old_copycat_survivor_replies": old_replies,
                }
            )

        frontier = [mask]
        defect_seen: set[int] = set()
        defect_transitions: set[tuple[int, int, int]] = set()
        terminal_deficiencies = Counter()
        isolated_histogram = Counter()
        while frontier:
            state = frontier.pop()
            if state in defect_seen:
                continue
            defect_seen.add(state)
            state_cells = tuple(
                BASE.BASE.GEOMETRY.bits(kernel.game.legal_mask(state))
            )
            state_graph = [0] * len(state_cells)
            state_omega = kernel.omega(state)
            for left, state_opponent in enumerate(state_cells):
                state_child = state | (1 << state_opponent)
                legal_replies = kernel.game.legal_mask(state_child)
                for right in range(left + 1, len(state_cells)):
                    state_reply = state_cells[right]
                    if not (legal_replies & (1 << state_reply)):
                        continue
                    target = state_child | (1 << state_reply)
                    if (
                        kernel.omega(target) < state_omega
                        and kernel.contains(target)
                    ):
                        state_graph[left] |= 1 << right
                        state_graph[right] |= 1 << left
            state_isolated = [
                position
                for position, neighbours in enumerate(state_graph)
                if not neighbours
            ]
            isolated_histogram[len(state_isolated)] += 1
            if not state_isolated:
                state_match = maximum_matching(tuple(state_graph))
                terminal_deficiencies[
                    len(state_graph) - 2 * matching_size(state_match)
                ] += 1
                continue
            assert old_kernel.contains(state)
            for position in state_isolated:
                state_opponent = state_cells[position]
                state_child = state | (1 << state_opponent)
                for state_reply in BASE.BASE.GEOMETRY.bits(
                    old_kernel.game.legal_mask(state_child)
                ):
                    target = state_child | (1 << state_reply)
                    if (
                        old_kernel.omega(target) < state_omega
                        and old_kernel.contains(target)
                    ):
                        defect_transitions.add(
                            (state, state_opponent, state_reply)
                        )
                        if not kernel.contains(target):
                            frontier.append(target)
        transition_rows = "\n".join(
            f"{state}:{opponent}:{reply}"
            for state, opponent, reply in sorted(defect_transitions)
        )
        rejected_p_obstructions.append(
            {
                "t4": row["t4"],
                "legal_moves": len(cells),
                "reply_edges": sum(neighbours.bit_count() for neighbours in graph)
                // 2,
                "isolated_vertices": sum(not neighbours for neighbours in graph),
                "minimum_degree": min(
                    (neighbours.bit_count() for neighbours in graph), default=0
                ),
                "maximum_matching_size": matching_size(match),
                "matching_deficiency": len(graph) - 2 * matching_size(match),
                "isolated_marked_fibres": isolated_rows,
                "defect_thread": {
                    "states": len(defect_seen),
                    "transitions": len(defect_transitions),
                    "transition_sha256": hashlib.sha256(
                        transition_rows.encode()
                    ).hexdigest(),
                    "selected_size_min": min(
                        state.bit_count() for state in defect_seen
                    ),
                    "selected_size_max": max(
                        state.bit_count() for state in defect_seen
                    ),
                    "isolated_vertex_count_histogram": dict(
                        sorted(isolated_histogram.items())
                    ),
                    "terminal_matching_deficiency_histogram": dict(
                        sorted(terminal_deficiencies.items())
                    ),
                },
            }
        )
    return {
        "q": q,
        "roots": len(records),
        "pairing_survivor_roots": sum(
            row["positive_pairing_survivor"] for row in records
        ),
        "exact_p_roots": sum(row["exact_cap_value"] == "P" for row in records),
        "pairing_survivor_iff_exact_p_on_domain": all(
            row["positive_pairing_survivor"]
            == (row["exact_cap_value"] == "P")
            for row in records
        ),
        "positive_pairing_shell_states": len(kernel.positive_shells),
        "copycat_boundary_states": len(kernel.copycat_boundary),
        "rejected_exact_p_root_obstructions": rejected_p_obstructions,
        "records": records,
    }


def audit_order(q: int) -> dict:
    kernel = BASE.CopycatKernel(q)
    roots = []
    root_rows = []
    for label in BASE.BASE.escape_parameters(BASE.ROWS, q):
        mask = kernel.game.base_mask(label)
        accepted = kernel.contains(mask)
        if accepted:
            roots.append(mask)
        root_rows.append(
            {
                "t4": list(label),
                "copycat_survivor": accepted,
                "omega": kernel.omega(mask),
            }
        )
    states = positive_certificate_states(kernel, roots)
    chosen_deficiency = Counter()
    full_deficiency = Counter()
    chosen_failures = 0
    full_failures = []
    odd_unmatched_histogram = Counter()
    marked_cover_failures = 0
    full_graph_cache: dict[int, tuple[int, ...]] = {}

    def reply_graph(mask: int) -> tuple[int, ...]:
        if mask not in full_graph_cache:
            full_graph_cache[mask] = full_reply_graph(kernel, mask)[1]
        return full_graph_cache[mask]

    def is_pairing_core(mask: int) -> bool:
        if kernel.omega(mask) == 0:
            return kernel.contains(mask)
        graph = reply_graph(mask)
        return (
            len(graph) - 2 * matching_size(maximum_matching(graph))
            == len(graph) % 2
        )

    for mask in sorted(states):
        _cells, chosen = chosen_reply_graph(kernel, mask)
        chosen_size = matching_size(maximum_matching(chosen))
        target_size = len(chosen) // 2
        chosen_deficiency[len(chosen) - 2 * chosen_size] += 1
        graph = chosen
        if chosen_size != target_size:
            chosen_failures += 1
            _cells, graph = full_reply_graph(kernel, mask)
        full_size = matching_size(maximum_matching(graph))
        deficiency = len(graph) - 2 * full_size
        full_deficiency[deficiency] += 1
        if deficiency != len(graph) % 2:
            full_failures.append(
                {
                    "mask": mask,
                    "selected_size": mask.bit_count(),
                    "omega": kernel.omega(mask),
                    "legal_moves": len(graph),
                    "maximum_matching_size": full_size,
                }
            )
        if len(graph) % 2:
            unmatched = possible_unmatched_vertices(graph)
            odd_unmatched_histogram[len(unmatched)] += 1
            if len(unmatched) < 2 and len(graph) > 1:
                marked_cover_failures += 1
    shell_uncovered_histogram = Counter()
    shell_failures = []
    for row in full_failures:
        mask = row["mask"]
        uncovered = 0
        old_omega = kernel.omega(mask)
        for opponent in BASE.BASE.GEOMETRY.bits(kernel.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            covered = False
            for reply in BASE.BASE.GEOMETRY.bits(kernel.game.legal_mask(child)):
                target = child | (1 << reply)
                if (
                    kernel.omega(target) < old_omega
                    and kernel.contains(target)
                    and is_pairing_core(target)
                ):
                    covered = True
                    break
            if not covered:
                uncovered += 1
        shell_uncovered_histogram[uncovered] += 1
        if uncovered:
            shell_failures.append({**row, "uncovered_opponents": uncovered})
    return {
        "q": q,
        "roots": root_rows,
        "accepted_roots": len(roots),
        "positive_certificate_states": len(states),
        "chosen_reply_graph_deficiency_histogram": dict(
            sorted(chosen_deficiency.items())
        ),
        "states_requiring_full_reply_expansion": chosen_failures,
        "full_reply_graph_deficiency_histogram": dict(
            sorted(full_deficiency.items())
        ),
        "nonmaximum_reply_graph_states": full_failures,
        "odd_graph_possible_unmatched_count_histogram": dict(
            sorted(odd_unmatched_histogram.items())
        ),
        "odd_graph_marked_cover_failures": marked_cover_failures,
        "one_exchange_into_pairing_core_uncovered_histogram": dict(
            sorted(shell_uncovered_histogram.items())
        ),
        "one_exchange_into_pairing_core_failures": shell_failures,
        "full_reply_graphs_built": len(full_graph_cache),
    }


def audit_q19_boundary() -> dict:
    q = 19
    label = (15, 16, 17, 18)
    kernel = BASE.CopycatKernel(q)
    mask = kernel.game.base_mask(label)
    accepted = kernel.contains(mask)
    source = json.loads(Q19_SOURCE.read_text())["q19_out_of_sample"]
    assert source["root"] == list(label)
    return {
        "q": q,
        "root": list(label),
        "domain": "single previously certified q19 strict-kernel root",
        "prior_strict_kernel_states_visited": source["kernel_states_visited"],
        "prior_strict_kernel_response_edges": source["kernel_response_edges"],
        "copycat_boundary_survivor": accepted,
        "copycat_boundary_states": len(kernel.copycat_boundary),
        "copycat_boundary_mask_sha256": BASE.mask_digest(kernel.copycat_boundary),
        "copycat_response_edges": len(kernel.responses),
        "copycat_response_map_sha256": kernel.response_digest(),
        "boundary_rejections": dict(sorted(kernel.boundary_rejections.items())),
    }


def payload() -> dict:
    return {
        "schema": "c80-positive-pairing-shell-v1",
        "claim_scope": (
            "Exact matching audit on every positive state reached by the "
            "deterministic q13/q17 structural copycat-survivor certificate DAG."
        ),
        "orders": [audit_order(q) for q in (13, 17)],
        "well_founded_positive_pairing_kernel": [
            audit_pairing_kernel(q) for q in (13, 17)
        ],
        "q19_copycat_boundary_probe": audit_q19_boundary(),
        "matching_algorithm_exhaustive_graphs_checked": matching_self_check(),
        "source": {
            "copycat_survivor_script": str(SOURCE.relative_to(ROOT)),
            "copycat_survivor_script_sha256": sha256(SOURCE),
            "frozen_rows": str(BASE.ROWS.relative_to(ROOT)),
            "frozen_rows_sha256": sha256(BASE.ROWS),
            "q19_strict_kernel_source": str(Q19_SOURCE.relative_to(ROOT)),
            "q19_strict_kernel_source_sha256": sha256(Q19_SOURCE),
        },
    }


def write_output(path: Path) -> None:
    path.write_text(json.dumps(payload(), indent=2, sort_keys=True) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            regenerated = Path(directory) / OUT.name
            write_output(regenerated)
            if not OUT.exists() or regenerated.read_bytes() != OUT.read_bytes():
                raise SystemExit("certificate mismatch")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return
    write_output(OUT)
    for order in json.loads(OUT.read_text())["orders"]:
        print(
            f"q={order['q']} states={order['positive_certificate_states']} "
            f"full_failures={len(order['nonmaximum_reply_graph_states'])}"
        )


if __name__ == "__main__":
    main()
