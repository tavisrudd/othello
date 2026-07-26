#!/usr/bin/env python3
"""C80: test the continuation-complex to conic-matching bridge."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_history_torus_obligation_rewrite.py"
OUT = ROOT / "notes/2026-07-25-c80-continuation-conic-matching-bridge.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


HISTORY = load_module(SOURCE, "c80_bridge_history")
COMPARE = HISTORY.COMPARE
LIVE = HISTORY.LIVE
SPOILER = HISTORY.SPOILER
GEOMETRY = HISTORY.GEOMETRY
INPUTS = (SOURCE, *HISTORY.INPUTS)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matching_edges_on_subset(game, move: int, subset) -> int:
    return sum(
        first != game.sigma(move, first)
        and game.sigma(move, first) in subset
        for first in subset
    ) // 2


def move_rows(game, target: int) -> list[dict]:
    isolates = HISTORY.terminal_isolates(game, target)
    played = GEOMETRY.played_params(game, target)
    live = GEOMETRY.live_conic(game, target)
    rows = []
    for move in GEOMETRY.bits(game.legal_mask(target)):
        if game.is_conic_cell(move):
            row = {
                "cell": list(game.cell_tuple(move)),
                "terminal_graph_status": (
                    "isolate" if move in isolates else "core"
                ),
                "move_kind": "conic",
                "full_conic_fixed_points": None,
                "selected_mark_matching_edges": None,
                "live_conic_matching_edges": None,
                "full_conic_perfect_matching": False,
            }
        else:
            fixed = GEOMETRY.tau(game, move)
            row = {
                "cell": list(game.cell_tuple(move)),
                "terminal_graph_status": (
                    "isolate" if move in isolates else "core"
                ),
                "move_kind": "intruder",
                "full_conic_fixed_points": fixed,
                "selected_mark_matching_edges": matching_edges_on_subset(
                    game, move, played
                ),
                "live_conic_matching_edges": matching_edges_on_subset(
                    game, move, live
                ),
                "full_conic_perfect_matching": fixed == 0,
            }
        rows.append(row)
    return sorted(rows, key=lambda row: row["cell"])


def signature(row: dict) -> tuple:
    return (
        row["terminal_graph_status"],
        row["move_kind"],
        row["full_conic_fixed_points"],
        row["selected_mark_matching_edges"],
        row["live_conic_matching_edges"],
        row["full_conic_perfect_matching"],
    )


def case_data(
    q: int,
    t4: tuple[int, ...],
    opponent_cell: tuple[int, int],
    repair_cell: tuple[int, int],
) -> dict:
    kernel = SPOILER.BASE.CopycatKernel(q)
    game = kernel.game
    target = game.base_mask(t4)
    target |= 1 << LIVE.cell_index(game, opponent_cell)
    target |= 1 << LIVE.cell_index(game, repair_cell)
    rows = move_rows(game, target)
    counts = Counter(
        (
            row["terminal_graph_status"],
            row["move_kind"],
            row["full_conic_fixed_points"],
            row["live_conic_matching_edges"],
        )
        for row in rows
    )
    external_rows = [
        row for row in rows if row["full_conic_perfect_matching"]
    ]
    live_rows = [
        row
        for row in rows
        if row["live_conic_matching_edges"] not in (None, 0)
    ]
    return {
        "q": q,
        "root_t4": list(t4),
        "history_edge": {
            "opponent": list(opponent_cell),
            "repair": list(repair_cell),
        },
        "selected_conic_marks": len(GEOMETRY.played_params(game, target)),
        "live_conic_points": len(GEOMETRY.live_conic(game, target)),
        "legal_moves": len(rows),
        "terminal_graph_isolates": sum(
            row["terminal_graph_status"] == "isolate" for row in rows
        ),
        "selected_mark_matching_nonempty_moves": sum(
            (row["selected_mark_matching_edges"] or 0) > 0 for row in rows
        ),
        "full_conic_perfect_matching_moves": len(external_rows),
        "full_conic_perfect_matching_core_moves": sum(
            row["terminal_graph_status"] == "core"
            for row in external_rows
        ),
        "full_conic_perfect_matching_isolates": sum(
            row["terminal_graph_status"] == "isolate"
            for row in external_rows
        ),
        "full_conic_plucker_quotient_degree": (q - 3) // 2,
        "live_matching_nonempty_moves": len(live_rows),
        "live_matching_nonempty_core_moves": sum(
            row["terminal_graph_status"] == "core" for row in live_rows
        ),
        "live_matching_nonempty_isolates": sum(
            row["terminal_graph_status"] == "isolate" for row in live_rows
        ),
        "signature_histogram": [
            {
                "status": key[0],
                "kind": key[1],
                "full_fixed_points": key[2],
                "live_matching_edges": key[3],
                "count": count,
            }
            for key, count in sorted(counts.items(), key=lambda item: repr(item[0]))
        ],
        "moves": rows,
    }


def transport_check(case: dict) -> dict:
    q = case["q"]
    t4 = tuple(case["root_t4"])
    opponent_cell = tuple(case["history_edge"]["opponent"])
    repair_cell = tuple(case["history_edge"]["repair"])
    kernel = SPOILER.BASE.CopycatKernel(q)
    game = kernel.game
    state = game.base_mask(t4)
    opponent = LIVE.cell_index(game, opponent_cell)
    repair = LIVE.cell_index(game, repair_cell)
    target = state | (1 << opponent) | (1 << repair)
    base_rows = {
        LIVE.cell_index(game, tuple(row["cell"])): signature(row)
        for row in move_rows(game, target)
    }
    lookup = LIVE.point_to_cell(game)
    matrices = LIVE.stabilizer_matrices(game, state)
    checks = 0
    for transporter in matrices:
        transformed_opponent = lookup[
            SPOILER.sym2(
                q, transporter, SPOILER.projective_point(game, opponent)
            )
        ]
        transformed_repair = lookup[
            SPOILER.sym2(
                q, transporter, SPOILER.projective_point(game, repair)
            )
        ]
        transformed_target = (
            state | (1 << transformed_opponent) | (1 << transformed_repair)
        )
        transformed_rows = {
            LIVE.cell_index(game, tuple(row["cell"])): signature(row)
            for row in move_rows(game, transformed_target)
        }
        for move, expected_signature in base_rows.items():
            transformed_move = lookup[
                SPOILER.sym2(
                    q, transporter, SPOILER.projective_point(game, move)
                )
            ]
            assert transformed_rows[transformed_move] == expected_signature
            checks += 1
    return {
        "stabilizer_order": len(matrices),
        "transported_move_signature_checks": checks,
        "all_checks_pass": True,
    }


def build_certificate() -> dict:
    cases = [
        case_data(q, t4, opponent, repair)
        for q, t4, opponent, repair in COMPARE.REPAIRS
    ]
    assert all(
        (
            case["selected_mark_matching_nonempty_moves"],
            case["full_conic_perfect_matching_moves"],
            case["full_conic_perfect_matching_core_moves"],
            case["full_conic_perfect_matching_isolates"],
            case["live_matching_nonempty_moves"],
            case["live_matching_nonempty_core_moves"],
            case["live_matching_nonempty_isolates"],
        )
        == (0, 9, 2, 7, 3, 1, 2)
        for case in cases[:4]
    )
    assert (
        cases[-1]["selected_mark_matching_nonempty_moves"],
        cases[-1]["full_conic_perfect_matching_moves"],
        cases[-1]["live_matching_nonempty_moves"],
    ) == (0, 20, 16)
    transports = {
        "q17_representative": transport_check(cases[0]),
        "q19_control": transport_check(cases[-1]),
    }
    return {
        "schema": "c80-continuation-conic-matching-bridge-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path)
            for path in sorted(set(INPUTS))
        },
        "candidate_bridge": {
            "source": (
                "legal moves and maximal two-faces of the full "
                "continuation complex"
            ),
            "target": (
                "matching data from the conic involution induced by a "
                "legal intruder"
            ),
            "tested_restrictions": (
                "selected conic marks, live conic points, and the full "
                "rational conic"
            ),
        },
        "cases": cases,
        "transport": transports,
        "general_obstruction": {
            "selected_mark_matching": (
                "empty for every legal intruder: pairing two selected "
                "marks would put the move on their selected secant"
            ),
            "full_conic_matching": (
                "perfect only for external intruders; split intruders "
                "have two fixed conic points and conic moves have no "
                "projection matching"
            ),
            "full_conic_quotient_degree": (
                "(q-3)/2, hence unbounded in q"
            ),
        },
        "cross_checks": {
            "all_selected_mark_matching_counts_are_zero": True,
            "move_signatures_commute_with_projective_transport": True,
        },
        "verdict": {
            "selected_mark_plucker_bridge": "FAIL: empty matching",
            "full_conic_plucker_bridge": (
                "FAIL: partial domain and unbounded quotient degree"
            ),
            "live_conic_matching_bridge_q17": "FAIL: 3/32 moves",
            "uniform_c80_candidate": False,
        },
    }


def write_certificate(path: Path) -> None:
    path.write_text(
        json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            write_certificate(candidate)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return
    write_certificate(OUT)
    print(f"WROTE {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
