#!/usr/bin/env python3
"""Independent line-load replay for C80's exact Node--Kayles state guard."""

from __future__ import annotations

import hashlib
import importlib.util
import sys
from functools import lru_cache
from itertools import combinations
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
ROWS_SHA256 = "952f189cc37bac36026238d75bccffb7feb560644582bf8c6373789a98f43f4d"
EXPECTED = {
    13: (620, 620, 533),
    17: (8770, 3048, 2822),
}


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def normalized_line(q: int, first, second) -> tuple[int, int, int]:
    x1, y1, z1 = first
    x2, y2, z2 = second
    line = (
        (y1 * z2 - z1 * y2) % q,
        (z1 * x2 - x1 * z2) % q,
        (x1 * y2 - y1 * x2) % q,
    )
    pivot = next(value for value in line if value)
    scale = pow(pivot, -1, q)
    return tuple(value * scale % q for value in line)


def on_line(q: int, line: tuple[int, int, int], point: tuple[int, int, int]) -> bool:
    return sum(a * x for a, x in zip(line, point)) % q == 0


def discriminant(q: int, first, second, third) -> int:
    r, c = first
    u, v = second
    a, b = third
    trace = (c * u - r * v + (r - u) * b - (c - v) * a) % q
    determinant = (r * c - 1) * (u * v - 1) * (a * b - 1) % q
    return (trace * trace - 4 * determinant) % q


def nonsquare(q: int, value: int) -> bool:
    return value % q != 0 and pow(value, (q - 1) // 2, q) == q - 1


def replay_q(q: int) -> tuple[int, int, int]:
    geometry = load_module(
        ROOT / "notes/2026-07-08-zone-repair-geometry.py", f"c80_nk_replay_geometry_{q}"
    )
    c31 = geometry.load_c31_module()
    c20 = c31.load_c20_module()
    game = c20.PrimeGridGame(q)
    states, _row_counts = c31.load_p_reply_states(ROWS, q)

    lines: dict[tuple[int, int, int], tuple[int, int]] = {}
    point_line: dict[tuple[int, int], tuple[int, int, int]] = {}
    for first, second in combinations(range(len(game.points)), 2):
        key = normalized_line(q, game.points[first], game.points[second])
        point_line[(first, second)] = key
        if key not in lines:
            affine_mask = sum(
                1 << cell
                for cell, point in enumerate(game.points[2:])
                if on_line(q, key, point)
            )
            fixed_load = sum(on_line(q, key, point) for point in (game.a, game.b))
            lines[key] = (affine_mask, fixed_load)
    assert len(lines) == q * q + q + 1

    incident = [[] for _ in range(q * q)]
    for affine_mask, fixed_load in lines.values():
        for cell in geometry.bits(affine_mask):
            incident[cell].append((affine_mask, fixed_load))

    @lru_cache(maxsize=None)
    def legal_mask(mask: int) -> int:
        legal = 0
        for cell in range(q * q):
            if mask & (1 << cell):
                continue
            if all(fixed + (mask & line).bit_count() < 2 for line, fixed in incident[cell]):
                legal |= 1 << cell
        return legal

    @lru_cache(maxsize=None)
    def nk_grundy(adjacency: tuple[int, ...], remaining: int) -> int:
        options = set()
        for vertex in geometry.bits(remaining):
            options.add(nk_grundy(adjacency, remaining & ~(1 << vertex) & ~adjacency[vertex]))
        value = 0
        while value in options:
            value += 1
        return value

    exact_empty_members = 0
    zero_members = 0
    zero_transitions = 0
    for mask, _row in states:
        for move in geometry.bits(legal_mask(mask) & ~game.conic_mask):
            child = mask | (1 << move)
            old_intruders = geometry.intruders(game, child)
            if len(old_intruders) != 3:
                continue
            old_cells = tuple(geometry.cell(game, point) for point in old_intruders)
            if not nonsquare(q, discriminant(q, *old_cells)):
                continue
            transition_zero = False
            for reply in geometry.bits(legal_mask(child) & ~game.conic_mask):
                if geometry.prod_order(game, move, reply) not in (q - 1, q + 1):
                    continue
                intruders = (*old_intruders, reply)
                cells = tuple(geometry.cell(game, point) for point in intruders)
                if not all(
                    nonsquare(q, discriminant(q, *(cells[index] for index in triple)))
                    for triple in combinations(range(4), 3)
                ):
                    continue

                grand = child | (1 << reply)
                legal = legal_mask(grand)
                assert legal == game.legal_mask(grand)
                if legal & game.conic_mask:
                    continue
                loads = {
                    key: fixed + (grand & affine_mask).bit_count()
                    for key, (affine_mask, fixed) in lines.items()
                }
                if any(
                    loads[key] == 0 and (legal & affine_mask).bit_count() > 2
                    for key, (affine_mask, _fixed) in lines.items()
                ):
                    continue
                exact_empty_members += 1

                vertices = geometry.bits(legal)
                index = {cell: position for position, cell in enumerate(vertices)}
                adjacency = [0] * len(vertices)
                for left, right in combinations(vertices, 2):
                    key = point_line[tuple(sorted((left + 2, right + 2)))]
                    if loads[key] == 1:
                        i, j = index[left], index[right]
                        adjacency[i] |= 1 << j
                        adjacency[j] |= 1 << i
                grundy = nk_grundy(tuple(adjacency), (1 << len(vertices)) - 1)
                assert (grundy == 0) == (not game.value(grand))
                if grundy == 0:
                    zero_members += 1
                    transition_zero = True
            zero_transitions += transition_zero
    return exact_empty_members, zero_members, zero_transitions


def main() -> int:
    assert hashlib.sha256(ROWS.read_bytes()).hexdigest() == ROWS_SHA256
    for q, expected in EXPECTED.items():
        actual = replay_q(q)
        assert actual == expected, (q, actual, expected)
        print(
            f"C80-NK-GUARD q={q} exact_empty={actual[0]} "
            f"grundy_zero={actual[1]} covered_transitions={actual[2]} PASS"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
