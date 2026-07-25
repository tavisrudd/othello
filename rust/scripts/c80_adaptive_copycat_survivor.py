#!/usr/bin/env python3
"""C80: test strict-overload descent to a structural copycat boundary.

At omega zero the residual cap game is static Node--Kayles.  This script
accepts only graphs with an explicit persistent nonedge pairing.  After either
vertex of a pair is played, its mate is legal, and every other pair either
survives or is deleted as a whole.  This is an explicit copycat strategy, so
the boundary is P without a Grundy-value oracle.  Component swaps and internal
fixed-point-free nonedge automorphisms are special cases.  It also accepts a
one-exchange adaptive shell: every first move has a reply leaving a
persistently paired graph.

Above the boundary, membership uses the strict-omega response recursion from
the C80 kernel.  The computation is a finite gate for the proposed adaptive
survivor; it is not a uniform algebraic construction.

Run:
  python3 rust/scripts/c80_adaptive_copycat_survivor.py
Check:
  python3 rust/scripts/c80_adaptive_copycat_survivor.py --check
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
OUT = ROOT / "notes/2026-07-25-c80-adaptive-copycat-survivor.json"
KERNEL_PATH = ROOT / "rust/scripts/c80_strict_overload_kernel.py"
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(KERNEL_PATH, "c80_copycat_base")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def mask_digest(masks) -> str:
    rows = "\n".join(str(mask) for mask in sorted(masks))
    return hashlib.sha256(rows.encode()).hexdigest()


def conflict_graph(kernel, mask: int) -> tuple[tuple[int, ...], tuple[int, ...]]:
    cells = tuple(BASE.GEOMETRY.bits(kernel.game.legal_mask(mask)))
    adjacency = [0] * len(cells)
    for i, point in enumerate(cells):
        after = kernel.game.legal_mask(mask | (1 << point))
        for j in range(i + 1, len(cells)):
            if not (after & (1 << cells[j])):
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i
    return cells, tuple(adjacency)


def components(adjacency: tuple[int, ...]) -> list[tuple[int, ...]]:
    unseen = (1 << len(adjacency)) - 1
    result = []
    while unseen:
        seed = unseen & -unseen
        frontier = seed
        component = 0
        while frontier:
            low = frontier & -frontier
            frontier ^= low
            vertex = low.bit_length() - 1
            if component & low:
                continue
            component |= low
            frontier |= adjacency[vertex] & ~component
        unseen &= ~component
        result.append(tuple(BASE.GEOMETRY.bits(component)))
    return result


def induced_graph(
    adjacency: tuple[int, ...], vertices: tuple[int, ...]
) -> tuple[int, ...]:
    index = {vertex: i for i, vertex in enumerate(vertices)}
    return tuple(
        sum(1 << index[other] for other in vertices if adjacency[vertex] & (1 << other))
        for vertex in vertices
    )


def refined_colors(adjacency: tuple[int, ...]) -> tuple[int, ...]:
    colors = tuple(row.bit_count() for row in adjacency)
    while True:
        signatures = [
            (colors[i], tuple(sorted(colors[j] for j in BASE.GEOMETRY.bits(row))))
            for i, row in enumerate(adjacency)
        ]
        palette = {signature: i for i, signature in enumerate(sorted(set(signatures)))}
        updated = tuple(palette[signature] for signature in signatures)
        if updated == colors:
            return colors
        colors = updated


def graph_invariant(adjacency: tuple[int, ...]) -> tuple:
    colors = refined_colors(adjacency)
    return (
        len(adjacency),
        sum(row.bit_count() for row in adjacency) // 2,
        tuple(sorted(Counter(colors).values())),
        tuple(sorted(row.bit_count() for row in adjacency)),
    )


def isomorphism(
    left: tuple[int, ...], right: tuple[int, ...]
) -> tuple[int, ...] | None:
    if graph_invariant(left) != graph_invariant(right):
        return None
    left_colors = refined_colors(left)
    right_colors = refined_colors(right)
    candidates = [
        tuple(j for j, color in enumerate(right_colors) if color == left_colors[i])
        for i in range(len(left))
    ]
    order = sorted(
        range(len(left)),
        key=lambda i: (len(candidates[i]), -left[i].bit_count(), i),
    )
    mapping = [-1] * len(left)
    used = 0

    def extend(depth: int) -> bool:
        nonlocal used
        if depth == len(order):
            return True
        vertex = order[depth]
        for image in candidates[vertex]:
            bit = 1 << image
            if used & bit:
                continue
            good = True
            for previous in order[:depth]:
                previous_image = mapping[previous]
                left_edge = bool(left[vertex] & (1 << previous))
                right_edge = bool(right[image] & (1 << previous_image))
                if left_edge != right_edge:
                    good = False
                    break
            if not good:
                continue
            mapping[vertex] = image
            used |= bit
            if extend(depth + 1):
                return True
            used ^= bit
            mapping[vertex] = -1
        return False

    return tuple(mapping) if extend(0) else None


def internal_copycat(adjacency: tuple[int, ...]) -> tuple[int, ...] | None:
    """Find an involutive automorphism pairing every vertex with a non-neighbour."""
    if len(adjacency) % 2:
        return None
    colors = refined_colors(adjacency)
    mapping = [-1] * len(adjacency)

    def compatible(left: int, right: int) -> bool:
        if left == right or colors[left] != colors[right]:
            return False
        if adjacency[left] & (1 << right):
            return False
        assigned = [vertex for vertex, image in enumerate(mapping) if image >= 0]
        for vertex in assigned:
            image = mapping[vertex]
            if bool(adjacency[left] & (1 << vertex)) != bool(
                adjacency[right] & (1 << image)
            ):
                return False
            if bool(adjacency[right] & (1 << vertex)) != bool(
                adjacency[left] & (1 << image)
            ):
                return False
        return True

    def pair_remaining() -> bool:
        try:
            left = next(i for i, image in enumerate(mapping) if image < 0)
        except StopIteration:
            return True
        candidates = [
            right
            for right in range(left + 1, len(adjacency))
            if mapping[right] < 0 and compatible(left, right)
        ]
        for right in candidates:
            mapping[left] = right
            mapping[right] = left
            if pair_remaining():
                return True
            mapping[left] = -1
            mapping[right] = -1
        return False

    return tuple(mapping) if pair_remaining() else None


def persistent_pairing(adjacency: tuple[int, ...]) -> tuple[tuple[int, int], ...] | None:
    """Pair vertices so every reply is legal and all remaining pairs persist."""
    if len(adjacency) % 2:
        return None
    pairs: list[tuple[int, int]] = []
    def extend(remaining: int) -> bool:
        if not remaining:
            return True
        low = remaining & -remaining
        left = low.bit_length() - 1
        candidates = remaining & ~low & ~adjacency[left]
        while candidates:
            right_bit = candidates & -candidates
            candidates ^= right_bit
            right = right_bit.bit_length() - 1
            killed = adjacency[left] | adjacency[right]
            incompatible = False
            for first, second in pairs:
                old_killed = adjacency[first] | adjacency[second]
                if bool(killed & (1 << first)) != bool(killed & (1 << second)):
                    incompatible = True
                    break
                if bool(old_killed & (1 << left)) != bool(
                    old_killed & (1 << right)
                ):
                    incompatible = True
                    break
            if incompatible:
                continue
            pairs.append((left, right))
            if extend(remaining & ~low & ~right_bit):
                return True
            pairs.pop()
        return False

    return tuple(pairs) if extend((1 << len(adjacency)) - 1) else None


@lru_cache(maxsize=None)
def adaptive_pairing_shell(adjacency: tuple[int, ...], depth: int) -> tuple | None:
    """Give every first move a reply into a shallower copycat shell."""
    if depth == 0:
        pairing = persistent_pairing(adjacency)
        if pairing is None:
            return None
        return ("pairing", pairing)
    responses = []
    full = (1 << len(adjacency)) - 1
    for opponent in range(len(adjacency)):
        candidates = full & ~(1 << opponent) & ~adjacency[opponent]
        witness = None
        while candidates:
            low = candidates & -candidates
            candidates ^= low
            reply = low.bit_length() - 1
            survivors = full & ~(
                (1 << opponent)
                | adjacency[opponent]
                | (1 << reply)
                | adjacency[reply]
            )
            survivor_vertices = tuple(BASE.GEOMETRY.bits(survivors))
            follower = induced_graph(adjacency, survivor_vertices)
            continuation = adaptive_pairing_shell(follower, depth - 1)
            if continuation is not None:
                witness = (
                    reply,
                    survivor_vertices,
                    continuation,
                )
                break
        if witness is None:
            return None
        responses.append((opponent, witness[0], witness[1], witness[2]))
    return ("shell", tuple(responses))


class CopycatKernel(BASE.StrictKernel):
    def __init__(self, q: int):
        super().__init__(q)
        self.copycat_boundary: dict[int, tuple] = {}
        self.boundary_rejections = Counter()
        self.contains_cache_start = self.contains.cache_info().currsize

    @lru_cache(maxsize=None)
    def copycat_witness(self, mask: int) -> tuple | None:
        cells, adjacency = conflict_graph(self, mask)
        shell = adaptive_pairing_shell(adjacency, 1)
        if shell is not None:
            return (
                list(cells),
                [list(component) for component in components(adjacency)],
                {"adaptive_pairing_shell": shell},
                [],
            )
        pairing = persistent_pairing(adjacency)
        if pairing is not None:
            return (
                list(cells),
                [list(component) for component in components(adjacency)],
                {"persistent_pairing": [list(pair) for pair in pairing]},
                [],
            )
        graphs = [
            induced_graph(adjacency, component)
            for component in components(adjacency)
        ]
        internal = {
            i: witness
            for i, graph in enumerate(graphs)
            if (witness := internal_copycat(graph)) is not None
        }
        buckets: dict[tuple, list[int]] = {}
        for i, graph in enumerate(graphs):
            if i in internal:
                continue
            buckets.setdefault(graph_invariant(graph), []).append(i)
        pairs = []
        for invariant, indices in sorted(buckets.items()):
            unmatched = list(indices)
            while unmatched:
                left_index = unmatched.pop(0)
                match_at = None
                match_map = None
                for position, right_index in enumerate(unmatched):
                    witness = isomorphism(graphs[left_index], graphs[right_index])
                    if witness is not None:
                        match_at = position
                        match_map = witness
                        break
                if match_at is None:
                    self.boundary_rejections[
                        f"unpaired_component_order_{invariant[0]}"
                    ] += 1
                    return None
                right_index = unmatched.pop(match_at)
                pairs.append((left_index, right_index, list(match_map)))
        return (
            list(cells),
            [list(component) for component in components(adjacency)],
            {str(index): list(witness) for index, witness in internal.items()},
            pairs,
        )

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

        for opponent in BASE.GEOMETRY.bits(self.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            witness = None
            for reply in BASE.GEOMETRY.bits(self.game.legal_mask(child)):
                target = child | (1 << reply)
                if self.omega(target) < old_omega and self.contains(target):
                    witness = reply
                    break
            if witness is None:
                return False
            self.responses[(mask, opponent)] = witness
        return True


def run_order(q: int) -> dict:
    kernel = CopycatKernel(q)
    records = []
    for label in BASE.escape_parameters(ROWS, q):
        mask = kernel.game.base_mask(label)
        records.append(
            {
                "t4": list(label),
                "omega": kernel.omega(mask),
                "copycat_survivor": kernel.contains(mask),
                "exact_cap_value": "N" if kernel.game.value(mask) else "P",
            }
        )
    component_histogram = Counter()
    legal_histogram = Counter()
    for mask, witness in kernel.copycat_boundary.items():
        cells, component_rows, _internal, _pairs = witness
        legal_histogram[len(cells)] += 1
        for component in component_rows:
            component_histogram[len(component)] += 1
    boundary_grundies = Counter(
        kernel.boundary_grundy(mask) for mask in kernel.copycat_boundary
    )
    return {
        "q": q,
        "records": records,
        "roots": len(records),
        "exact_p_roots": sum(row["exact_cap_value"] == "P" for row in records),
        "survivor_roots": sum(row["copycat_survivor"] for row in records),
        "copycat_boundary_states": len(kernel.copycat_boundary),
        "copycat_boundary_mask_sha256": mask_digest(kernel.copycat_boundary),
        "independent_boundary_grundy_histogram": dict(
            sorted(boundary_grundies.items())
        ),
        "kernel_states_visited": kernel.states_visited(),
        "certified_response_edges": len(kernel.responses),
        "response_map_sha256": kernel.response_digest(),
        "boundary_legal_vertex_histogram": dict(sorted(legal_histogram.items())),
        "boundary_component_order_histogram": dict(sorted(component_histogram.items())),
        "boundary_rejections": dict(sorted(kernel.boundary_rejections.items())),
    }


def component_kind(graph: tuple[int, ...]) -> str:
    order = len(graph)
    edges = sum(row.bit_count() for row in graph) // 2
    degrees = [row.bit_count() for row in graph]
    if order == 1:
        return "isolated"
    if edges == order * (order - 1) // 2:
        return "clique"
    if max(degrees) <= 2:
        if all(degree == 2 for degree in degrees):
            return "cycle"
        return "path"
    return "other"


def audit_original_boundary(q: int) -> dict:
    kernel = BASE.StrictKernel(q)
    for label in BASE.escape_parameters(ROWS, q):
        kernel.contains(kernel.game.base_mask(label))
    component_kinds = Counter()
    state_classes = Counter()
    shell_depths = Counter()
    legal_sizes = Counter()
    for mask in kernel.boundary:
        _cells, adjacency = conflict_graph(kernel, mask)
        legal_sizes[len(adjacency)] += 1
        kinds = []
        for component in components(adjacency):
            graph = induced_graph(adjacency, component)
            kind = component_kind(graph)
            kinds.append(kind)
            component_kinds[kind] += 1
        state_classes[
            "path_cycle_clique_only"
            if all(kind != "other" for kind in kinds)
            else "has_other_component"
        ] += 1
        minimum = None
        for depth in range(4):
            if adaptive_pairing_shell(adjacency, depth) is not None:
                minimum = depth
                break
        shell_depths[str(minimum) if minimum is not None else ">3"] += 1
    return {
        "q": q,
        "ynk_boundary_states": len(kernel.boundary),
        "ynk_boundary_mask_sha256": mask_digest(kernel.boundary),
        "legal_vertex_histogram": dict(sorted(legal_sizes.items())),
        "component_kind_histogram": dict(sorted(component_kinds.items())),
        "state_component_class_histogram": dict(sorted(state_classes.items())),
        "minimum_adaptive_pairing_shell_depth": dict(sorted(shell_depths.items())),
    }


def payload() -> dict:
    orders = [run_order(q) for q in (13, 17)]
    return {
        "schema": "c80-adaptive-copycat-survivor-v6",
        "claim_scope": (
            "Finite gate on the frozen q13/q17 escape-root domains. The omega-zero "
            "boundary is certified by a one-exchange adaptive shell into a "
            "persistent nonedge pairing (with graph involutions/component swaps "
            "as special cases); positive layers use strict-omega adaptive "
            "response descent."
        ),
        "orders": orders,
        "original_ynk_boundary_audit": [
            audit_original_boundary(q) for q in (13, 17)
        ],
        "source": {
            "frozen_rows": str(ROWS.relative_to(ROOT)),
            "frozen_rows_sha256": sha256(ROWS),
            "strict_kernel_script": str(KERNEL_PATH.relative_to(ROOT)),
            "strict_kernel_script_sha256": sha256(KERNEL_PATH),
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
            f"q={order['q']} survivor={order['survivor_roots']}/"
            f"{order['roots']} boundary={order['copycat_boundary_states']}"
        )


if __name__ == "__main__":
    main()
