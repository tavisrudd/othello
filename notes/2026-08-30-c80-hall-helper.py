#!/usr/bin/env python3
"""Independent replay for the C80 consumed-label Hall rematching instances.

This is a from-scratch exact implementation of the residual grid cap game over
`F_q`: legality, the capacity-two overload `Omega`, the small boundary, the
defect locus, the ancestral-secant edge relation, bipartite matching, and the
Node--Kayles boundary value.  Collinearity is decided by the affine determinant
rather than by precomputed slope classes, so this replay shares no code path
with the Rust driver `ergodis-private/src/bin/c80_hall_rematch.rs`.

Where possible each quantity is additionally cross-checked against the
authoritative C80 kernel in `rust/scripts/c80_strict_overload_kernel.py`.

Usage from the repository root:

    python3 notes/2026-08-30-c80-hall-helper.py
    python3 notes/2026-08-30-c80-hall-helper.py --records <summary.json> ...
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import random
import sys
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
KERNEL_SOURCE = ROOT / "rust/scripts/c80_strict_overload_kernel.py"

Point = tuple[int, int]


def load_kernel_module():
    spec = importlib.util.spec_from_file_location("c80_kernel_replay", KERNEL_SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {KERNEL_SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class Game:
    """Residual `q x q` grid cap game with determinant collinearity."""

    def __init__(self, q: int):
        self.q = q
        self.points: tuple[Point, ...] = tuple(
            (x, y) for x in range(q) for y in range(q)
        )
        self.lines: list[frozenset[Point]] = []
        for slope in range(1, q):
            for intercept in range(q):
                self.lines.append(
                    frozenset((x, (slope * x + intercept) % q) for x in range(q))
                )

    def collinear(self, a: Point, b: Point, c: Point) -> bool:
        return (
            (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])
        ) % self.q == 0

    def legal_point(self, state: frozenset[Point], point: Point) -> bool:
        if point in state:
            return False
        for selected in state:
            if selected[0] == point[0] or selected[1] == point[1]:
                return False
        ordered = sorted(state)
        for index, first in enumerate(ordered):
            for second in ordered[index + 1 :]:
                if self.collinear(first, second, point):
                    return False
        return True

    @lru_cache(maxsize=None)
    def legal(self, state: frozenset[Point]) -> frozenset[Point]:
        return frozenset(
            point for point in self.points if self.legal_point(state, point)
        )

    @lru_cache(maxsize=None)
    def omega(self, state: frozenset[Point]) -> int:
        legal = self.legal(state)
        total = 0
        for line in self.lines:
            if state & line:
                continue
            total += max(0, len(legal & line) - 2)
        return total

    @lru_cache(maxsize=None)
    def is_small_boundary(self, state: frozenset[Point]) -> bool:
        legal = self.legal(state)
        if len(legal) not in (0, 2):
            return False
        if self.omega(state) != 0:
            return False
        if not legal:
            return True
        left, right = sorted(legal)
        return self.legal_point(state | {left}, right)

    @lru_cache(maxsize=None)
    def defects(self, state: frozenset[Point]) -> frozenset[Point]:
        rows = set()
        for opponent in self.legal(state):
            child = state | {opponent}
            if not any(
                self.is_small_boundary(child | {reply}) for reply in self.legal(child)
            ):
                rows.add(opponent)
        return frozenset(rows)

    def boundary_grundy(self, state: frozenset[Point]) -> int:
        """Node--Kayles Grundy value of the full legal-point conflict graph."""
        cells = sorted(self.legal(state))
        adjacency = [0] * len(cells)
        for index, point in enumerate(cells):
            after = state | {point}
            for other in range(index + 1, len(cells)):
                if not self.legal_point(after, cells[other]):
                    adjacency[index] |= 1 << other
                    adjacency[other] |= 1 << index

        memo: dict[int, int] = {}

        def grundy(vertices: int) -> int:
            if vertices == 0:
                return 0
            cached = memo.get(vertices)
            if cached is not None:
                return cached
            values = set()
            remaining = vertices
            while remaining:
                low = remaining & -remaining
                vertex = low.bit_length() - 1
                values.add(grundy(vertices & ~(low | adjacency[vertex])))
                remaining ^= low
            result = 0
            while result in values:
                result += 1
            memo[vertices] = result
            return result

        return grundy((1 << len(cells)) - 1)


def ancestral_secant(
    game: Game,
    state: frozenset[Point],
    created: list[Point],
    consumed: list[Point],
) -> list[list[int]]:
    """`z -- ell` when a point selected before the exchange lies on `z ell`."""
    rows = []
    for defect in created:
        row = []
        for rank, label in enumerate(consumed):
            if any(
                selected not in (defect, label)
                and game.collinear(defect, label, selected)
                for selected in sorted(state)
            ):
                row.append(rank)
        rows.append(row)
    return rows


def maximum_matching(neighbours: list[list[int]], right_count: int) -> list[int]:
    """Kuhn augmenting paths; returns the matched right vertex per left."""
    match_right = [-1] * right_count
    match_left = [-1] * len(neighbours)

    def augment(left: int, seen: set[int]) -> bool:
        for right in neighbours[left]:
            if right in seen:
                continue
            seen.add(right)
            if match_right[right] < 0 or augment(match_right[right], seen):
                match_right[right] = left
                match_left[left] = right
                return True
        return False

    for left in range(len(neighbours)):
        augment(left, set())
    return match_left


def deficient_set(neighbours: list[list[int]], right_count: int) -> tuple[list[int], list[int]]:
    """Alternating-reachable Hall-deficient left set and its neighbourhood."""
    match_left = maximum_matching(neighbours, right_count)
    match_right = [-1] * right_count
    for left, right in enumerate(match_left):
        if right >= 0:
            match_right[right] = left
    reach_left = {left for left, right in enumerate(match_left) if right < 0}
    reach_right: set[int] = set()
    queue = sorted(reach_left)
    while queue:
        left = queue.pop()
        for right in neighbours[left]:
            if right in reach_right:
                continue
            reach_right.add(right)
            owner = match_right[right]
            if owner >= 0 and owner not in reach_left:
                reach_left.add(owner)
                queue.append(owner)
    return sorted(reach_left), sorted(reach_right)


def as_points(values) -> list[Point]:
    return [tuple(value) for value in values]


def verify_record(game: Game, record: dict, kernel) -> list[str]:
    """Recompute every field of one Rust failure/exchange record."""
    notes = []
    state = frozenset(as_points(record["state"]))
    opponent = tuple(record["opponent"])
    causal = tuple(record["causal"])
    child = state | {opponent}
    successor = child | {causal}

    old_defects = game.defects(state)
    half_defects = game.defects(child)
    next_defects = game.defects(successor)
    assert sorted(old_defects) == sorted(as_points(record["old_defects"])), "old defects"
    assert sorted(half_defects) == sorted(as_points(record["half_defects"])), "half defects"
    assert sorted(next_defects) == sorted(as_points(record["next_defects"])), "next defects"
    notes.append("defect loci agree")

    created = sorted(next_defects - half_defects - old_defects)
    consumed = sorted(old_defects - next_defects)
    assert created == sorted(as_points(record["created"])), "created"
    assert consumed == sorted(as_points(record["consumed"])), "consumed"
    notes.append(f"created={len(created)} consumed={len(consumed)}")

    rows = ancestral_secant(game, state, created, consumed)
    assert rows == [list(row) for row in record["neighbours"]], "ancestral-secant rows"
    left, right = deficient_set(rows, len(consumed))
    assert left == list(record["deficient_left"]), f"deficient left {left}"
    assert right == list(record["deficient_right"]), f"deficient right {right}"
    if left:
        assert len(right) < len(left), "Hall deficiency"
        notes.append(
            f"Hall-deficient Z={[list(created[i]) for i in left]} "
            f"N(Z)={[list(consumed[i]) for i in right]}"
        )
    else:
        notes.append("ancestral-secant saturated")

    omega = [game.omega(state), game.omega(child), game.omega(successor)]
    assert omega == list(record["omega"]), f"omega {omega}"
    notes.append(f"omega {omega[0]}->{omega[1]}->{omega[2]}")

    support = [len(old_defects), len(old_defects) - len(consumed) + len(created)]
    assert support == list(record["charged_support"]), "charged support"
    assert len(next_defects) == support[1], "support bookkeeping"

    if record["successor_boundary_grundy"] is not None:
        grundy = game.boundary_grundy(successor)
        assert grundy == record["successor_boundary_grundy"], f"grundy {grundy}"
        notes.append(
            f"successor Node-Kayles Grundy={grundy} "
            f"({'P' if grundy == 0 else 'N'} under the Y_NK boundary law)"
        )

    # Cross-check omega, the small boundary, and the boundary value against the
    # authoritative C80 strict-overload kernel.
    strict = kernel.StrictKernel(game.q)
    mask = 0
    for x, y in successor:
        mask |= 1 << (x * game.q + y)
    assert strict.omega(mask) == omega[2], "kernel omega"
    assert strict.boundary_grundy(mask) == game.boundary_grundy(successor), (
        "kernel boundary grundy"
    )
    if omega[2] == 0:
        # `K_Omega`'s base case is exactly the `Y_NK` Grundy-zero boundary.
        member = strict.contains(mask)
        assert member == (game.boundary_grundy(successor) == 0), (
            "kernel K_Omega membership"
        )
        notes.append(
            "authoritative kernel agrees on Omega, the boundary value, "
            f"and K_Omega membership ({member})"
        )
    else:
        notes.append("authoritative kernel agrees on Omega and the boundary value")
    return notes


def sample_exchanges(game: Game, seed: int, states: int) -> dict:
    """Independent sampled recheck of the two crown properties."""
    rng = random.Random(seed)
    counts = {
        "states": 0,
        "exchanges_with_new_defects": 0,
        "complete_relation_failures": 0,
        "nondecreasing_exchanges": 0,
        "ancestral_secant_hall_failures": 0,
        "successor_omega_positive": 0,
        "successor_boundary_p": 0,
        "support_first_lex_failures": 0,
    }
    while counts["states"] < states:
        state: frozenset[Point] = frozenset()
        for _ in range(4):
            legal = sorted(game.legal(state))
            if not legal:
                break
            state = state | {legal[rng.randrange(len(legal))]}
        if len(state) != 4:
            continue
        counts["states"] += 1
        old_defects = game.defects(state)
        old_omega = game.omega(state)
        for opponent in sorted(old_defects):
            child = state | {opponent}
            half_defects = game.defects(child)
            for causal in sorted(game.legal(child)):
                if causal not in old_defects:
                    continue
                successor = child | {causal}
                next_defects = game.defects(successor)
                created = sorted(next_defects - half_defects - old_defects)
                if not created:
                    continue
                consumed = sorted(old_defects - next_defects)
                counts["exchanges_with_new_defects"] += 1
                if len(consumed) < len(created):
                    counts["complete_relation_failures"] += 1
                if len(consumed) <= len(created):
                    counts["nondecreasing_exchanges"] += 1
                rows = ancestral_secant(game, state, created, consumed)
                left, _ = deficient_set(rows, len(consumed))
                if left:
                    counts["ancestral_secant_hall_failures"] += 1
                next_omega = game.omega(successor)
                next_support = len(next_defects)
                if (next_support, next_omega) >= (len(old_defects), old_omega):
                    counts["support_first_lex_failures"] += 1
                if next_omega > 0:
                    counts["successor_omega_positive"] += 1
                elif game.boundary_grundy(successor) == 0:
                    counts["successor_boundary_p"] += 1
    return counts


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--records",
        type=Path,
        nargs="*",
        default=[],
        help="c80-hall-rematch summary files whose records are replayed",
    )
    parser.add_argument("--q11-states", type=int, default=40)
    parser.add_argument("--q13-states", type=int, default=8)
    parser.add_argument("--seed", type=int, default=98_508_030)
    arguments = parser.parse_args()

    kernel = load_kernel_module()
    failures = 0

    for path in arguments.records:
        document = json.loads(path.read_text())
        game = Game(document["q"])
        records = []
        if document.get("first_failure"):
            records.append(("first_failure", document["first_failure"]))
        for index, record in enumerate(document.get("admission_candidates", [])):
            records.append((f"candidate[{index}]", record))
        for name, record in records:
            try:
                notes = verify_record(game, record, kernel)
            except AssertionError as error:
                failures += 1
                print(f"FAIL {path.name} {name}: {error}")
                continue
            print(f"PASS {path.name} {name}: " + "; ".join(notes))

    for q, states in ((11, arguments.q11_states), (13, arguments.q13_states)):
        game = Game(q)
        counts = sample_exchanges(game, arguments.seed, states)
        print(f"PASS q={q} independent sample: {json.dumps(counts, sort_keys=True)}")

    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
