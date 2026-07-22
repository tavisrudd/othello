#!/usr/bin/env python3
"""C80: census the Y_0 response fibre before the terminal score-9 layer."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from itertools import combinations
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
OUT = ROOT / "notes/2026-07-22-c80-response-fibre-census.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def discriminant(q: int, first, second, third) -> int:
    r, c = first
    u, v = second
    a, b = third
    trace = (c * u - r * v + (r - u) * b - (c - v) * a) % q
    determinant = (r * c - 1) * (u * v - 1) * (a * b - 1) % q
    return (trace * trace - 4 * determinant) % q


def fixed_count(q: int, value: int) -> int:
    if value == 0:
        return 1
    return 2 if pow(value, (q - 1) // 2, q) == 1 else 0


def projective_lines(game) -> tuple[tuple[int, int], ...]:
    """Return (affine-point mask, load from the two fixed points) for every line."""
    lines: dict[int, int] = {}
    for first in range(len(game.points)):
        for second in range(first + 1, len(game.points)):
            affine_mask = game.line_masks[first][second]
            fixed_load = sum(
                game.collinear(fixed, game.points[first], game.points[second])
                for fixed in (game.a, game.b)
            )
            previous = lines.setdefault(affine_mask, fixed_load)
            assert previous == fixed_load
    assert len(lines) == game.q * game.q + game.q + 1
    return tuple(sorted(lines.items()))


def maximum_capacity_two_line(
    game, lines: tuple[tuple[int, int], ...], mask: int
) -> int:
    """Maximum legal-point count on a line containing no selected point."""
    legal = game.legal_mask(mask)
    return max(
        (
            (legal & line_mask).bit_count()
            for line_mask, fixed_load in lines
            if fixed_load + (mask & line_mask).bit_count() == 0
        ),
        default=0,
    )


def node_kayles_exact(game, lines: tuple[tuple[int, int], ...], mask: int) -> bool:
    """Whether every capacity-2 line has at most two currently legal points."""
    return maximum_capacity_two_line(game, lines, mask) <= 2


def summarize(counter: Counter) -> list[dict]:
    return [
        {
            "parent_live_conic": key[0],
            "child_live_conic": key[1],
            "prior_triple_fixed_points": key[2],
            "packet_size": key[3],
            "p_members": key[4],
            "clean_members": key[5],
            "p_members_strict_live_descent_from_parent": key[6],
            "p_members_strict_live_descent_from_child": key[7],
            "node_kayles_exact_members": key[8],
            "node_kayles_zero_members": key[9],
            "transitions": count,
        }
        for key, count in sorted(counter.items())
    ]


def run_q(q: int, rows_path: Path) -> dict:
    geometry = load_module(
        ROOT / "notes/2026-07-08-zone-repair-geometry.py", f"c80_fibre_geometry_{q}"
    )
    c31 = geometry.load_c31_module()
    c20 = c31.load_c20_module()
    game = c20.PrimeGridGame(q)
    lines = projective_lines(game)
    states, _row_counts = c31.load_p_reply_states(rows_path, q)

    profiles = Counter()
    transitions = 0
    permutation_checks = 0
    packet_members = 0
    p_members = 0
    clean_members = 0
    nonempty = 0
    p_nonempty = 0
    impure = 0
    strict_parent_descent_nonempty = 0
    strict_child_descent_nonempty = 0
    node_kayles_exact_members = 0
    node_kayles_exact_empty_members = 0
    node_kayles_zero_members = 0
    node_kayles_zero_nonempty = 0
    clean_without_node_kayles_exact_p_members = 0
    clean_without_node_kayles_exact_n_members = 0
    clean_nonexact_capacity_two_profiles = Counter()
    transitions_outside_three_intruder_domain = 0

    for mask, _row in states:
        parent_live = len(geometry.live_conic(game, mask))
        for move in geometry.bits(game.legal_mask(mask) & ~game.conic_mask):
            transitions += 1
            child = mask | (1 << move)
            child_live = len(geometry.live_conic(game, child))
            old_intruders = geometry.intruders(game, child)
            if len(old_intruders) != 3:
                transitions_outside_three_intruder_domain += 1
                continue
            old_cells = tuple(geometry.cell(game, point) for point in old_intruders)
            prior_discriminant = discriminant(q, *old_cells)
            prior_fixed = fixed_count(q, prior_discriminant)

            if prior_fixed:
                profiles[(parent_live, child_live, prior_fixed, 0, 0, 0, 0, 0, 0, 0)] += 1
                continue

            packet = []
            for reply in geometry.bits(game.legal_mask(child) & ~game.conic_mask):
                if geometry.prod_order(game, move, reply) not in (q - 1, q + 1):
                    continue
                intruders = (*old_intruders, reply)
                cells = tuple(geometry.cell(game, point) for point in intruders)
                triple_fixed = tuple(
                    fixed_count(q, discriminant(q, *(cells[index] for index in triple)))
                    for triple in combinations(range(4), 3)
                )
                if any(triple_fixed):
                    continue
                permutations = [game.sigma_perm(point) for point in intruders]
                direct_fixed = tuple(
                    sum(
                        permutations[i][permutations[j][permutations[k][point]]] == point
                        for point in game.params
                    )
                    for i, j, k in combinations(range(4), 3)
                )
                assert triple_fixed == direct_fixed
                permutation_checks += 1

                grand = child | (1 << reply)
                features = game.state_features(grand, geometry.intruders(game, grand))
                p_value = not game.value(grand)
                clean = geometry.clean_empty(features)
                grand_live = len(geometry.live_conic(game, grand))
                nk_exact = node_kayles_exact(game, lines, grand)
                nk_zero = nk_exact and not grand_live and features["zone_grundy"] == 0
                if nk_exact and not grand_live:
                    assert p_value == (features["zone_grundy"] == 0)
                assert not nk_zero or p_value
                if clean and not nk_exact:
                    clean_nonexact_capacity_two_profiles[
                        (maximum_capacity_two_line(game, lines, grand), p_value)
                    ] += 1
                packet.append(
                    (
                        p_value,
                        clean,
                        grand_live < parent_live,
                        grand_live < child_live,
                        nk_exact,
                        nk_zero,
                        not grand_live,
                    )
                )

            packet_size = len(packet)
            packet_p = sum(item[0] for item in packet)
            packet_clean = sum(item[1] for item in packet)
            parent_descending_p = sum(item[0] and item[2] for item in packet)
            child_descending_p = sum(item[0] and item[3] for item in packet)
            packet_nk_exact = sum(item[4] for item in packet)
            packet_nk_zero = sum(item[5] for item in packet)
            profiles[
                (
                    parent_live,
                    child_live,
                    prior_fixed,
                    packet_size,
                    packet_p,
                    packet_clean,
                    parent_descending_p,
                    child_descending_p,
                    packet_nk_exact,
                    packet_nk_zero,
                )
            ] += 1
            packet_members += packet_size
            p_members += packet_p
            clean_members += packet_clean
            nonempty += bool(packet_size)
            p_nonempty += bool(packet_p)
            impure += bool(packet_p and packet_p != packet_size)
            strict_parent_descent_nonempty += bool(parent_descending_p)
            strict_child_descent_nonempty += bool(child_descending_p)
            node_kayles_exact_members += packet_nk_exact
            node_kayles_exact_empty_members += sum(item[4] and item[6] for item in packet)
            node_kayles_zero_members += packet_nk_zero
            node_kayles_zero_nonempty += bool(packet_nk_zero)
            clean_without_node_kayles_exact_p_members += sum(
                item[0] and item[1] and not item[4] for item in packet
            )
            clean_without_node_kayles_exact_n_members += sum(
                not item[0] and item[1] and not item[4] for item in packet
            )

    return {
        "q": q,
        "p_reply_states": len(states),
        "intruder_opponent_transitions": transitions,
        "transitions_outside_three_intruder_domain": transitions_outside_three_intruder_domain,
        "three_intruder_transitions": transitions - transitions_outside_three_intruder_domain,
        "primitive_candidate_permutation_checks": permutation_checks,
        "packet_members": packet_members,
        "p_members": p_members,
        "clean_members": clean_members,
        "nonempty_transitions": nonempty,
        "p_nonempty_transitions": p_nonempty,
        "impure_transitions": impure,
        "strict_parent_live_descent_p_nonempty_transitions": strict_parent_descent_nonempty,
        "strict_child_live_descent_p_nonempty_transitions": strict_child_descent_nonempty,
        "node_kayles_exact_members": node_kayles_exact_members,
        "node_kayles_exact_empty_members": node_kayles_exact_empty_members,
        "node_kayles_zero_members": node_kayles_zero_members,
        "node_kayles_zero_nonempty_transitions": node_kayles_zero_nonempty,
        "clean_without_node_kayles_exact_p_members": clean_without_node_kayles_exact_p_members,
        "clean_without_node_kayles_exact_n_members": clean_without_node_kayles_exact_n_members,
        "clean_nonexact_capacity_two_profiles": [
            {"maximum_legal_points": key[0], "p_value": key[1], "members": count}
            for key, count in sorted(clean_nonexact_capacity_two_profiles.items())
        ],
        "profiles": summarize(profiles),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=Path, default=ROWS)
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--q", type=int, nargs="+", default=[13, 17])
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    payload = {
        "claim_scope": (
            "Exact Y_0 packet census over every legal intruder opponent transition from the "
            "recorded q=13 and q=17 C20 P reply states."
        ),
        "definition": (
            "Y_0 consists of legal off-conic replies primitive relative to the opponent move "
            "and having no conic fixed point for any of the four intruder triple products."
        ),
        "node_kayles_guard": (
            "A Y_0 grandchild passes the exact Node-Kayles guard when its conic is empty, "
            "every projective line of residual capacity two contains at most two legal points, "
            "and the resulting residual conflict graph has Grundy value zero."
        ),
        "source": {
            "path": str(args.rows.relative_to(ROOT)),
            "sha256": sha256(args.rows),
            "bytes": args.rows.stat().st_size,
        },
        "fields": [run_q(q, args.rows) for q in args.q],
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered
        print("C80 response-fibre census: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
