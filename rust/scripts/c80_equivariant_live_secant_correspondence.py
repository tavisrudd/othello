#!/usr/bin/env python3
"""C80: test one equivariant live-secant reply correspondence."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_marked_secant_spoiler_repair_compare.py"
OUT = ROOT / "notes/2026-07-25-c80-equivariant-live-secant-correspondence.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


COMPARE = load_module(SOURCE, "c80_live_secant_compare")
SPOILER = COMPARE.SPOILER
GEOMETRY = COMPARE.GEOMETRY
INPUTS = (SOURCE, *COMPARE.INPUTS)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cell_index(game, cell: tuple[int, int]) -> int:
    return cell[0] * game.q + cell[1]


def live_chord_pairs(game, target: int, reply: int) -> tuple[tuple[int, int], ...]:
    """Pairs of live conic parameters exchanged by the reply involution."""
    live = sorted(GEOMETRY.live_conic(game, target))
    pairs = []
    for left, first in enumerate(live):
        second = game.sigma(reply, first)
        if second in live[left + 1 :]:
            pairs.append((first, second))
    return tuple(pairs)


def direct_live_chord_pairs(
    game, target: int, reply: int
) -> tuple[tuple[int, int], ...]:
    """Independent determinant replay of the live-chord condition."""
    live = sorted(GEOMETRY.live_conic(game, target))
    reply_point = game.points[reply + 2]
    return tuple(
        (first, second)
        for left, first in enumerate(live)
        for second in live[left + 1 :]
        if game.collinear(
            reply_point,
            game.conic_point[first],
            game.conic_point[second],
        )
    )


def strict_external_domain(kernel, state: int, opponent: int) -> tuple[int, ...]:
    game = kernel.game
    old_omega = kernel.omega(state)
    child = state | (1 << opponent)
    return tuple(
        reply
        for reply in GEOMETRY.bits(game.legal_mask(child))
        if not game.is_conic_cell(reply)
        and GEOMETRY.line_type(game, opponent, reply) == "external"
        and kernel.omega(child | (1 << reply)) < old_omega
    )


def correspondence_rows(kernel, state: int, opponent: int) -> list[dict]:
    game = kernel.game
    child = state | (1 << opponent)
    rows = []
    for reply in strict_external_domain(kernel, state, opponent):
        target = child | (1 << reply)
        pairs = live_chord_pairs(game, target, reply)
        direct_pairs = direct_live_chord_pairs(game, target, reply)
        assert pairs == direct_pairs
        if not pairs:
            continue
        rows.append(
            {
                "reply": list(game.cell_tuple(reply)),
                "live_conic_points": len(GEOMETRY.live_conic(game, target)),
                "surviving_reply_chords": len(pairs),
                "target_omega": kernel.omega(target),
                "exact_grid_value": "P" if not game.value(target) else "N",
            }
        )
    return sorted(rows, key=lambda row: row["reply"])


def selected_projective_points(game, state: int) -> frozenset[tuple[int, int, int]]:
    selected = {(1, 0, 0), (0, 1, 0)}
    selected.update(
        SPOILER.projective_point(game, cell)
        for cell in GEOMETRY.bits(state)
    )
    return frozenset(selected)


def point_to_cell(game) -> dict[tuple[int, int, int], int]:
    return {
        SPOILER.projective_point(game, cell): cell
        for cell in range(game.q * game.q)
    }


def stabilizer_matrices(game, state: int):
    selected = selected_projective_points(game, state)
    return tuple(
        matrix
        for matrix in SPOILER.pgl2(game.q)
        if frozenset(
            SPOILER.sym2(game.q, matrix, point) for point in selected
        )
        == selected
    )


def transport_check(
    kernel, state: int, opponent: int, rows: list[dict]
) -> dict:
    game = kernel.game
    lookup = point_to_cell(game)
    reply_cells = {
        cell_index(game, tuple(row["reply"]))
        for row in rows
    }
    matrices = stabilizer_matrices(game, state)
    checked_edges = 0
    marked_opponents = set()
    for matrix in matrices:
        transformed_opponent_point = SPOILER.sym2(
            game.q, matrix, SPOILER.projective_point(game, opponent)
        )
        transformed_opponent = lookup[transformed_opponent_point]
        marked_opponents.add(game.cell_tuple(transformed_opponent))
        expected = {
            lookup[
                SPOILER.sym2(
                    game.q,
                    matrix,
                    SPOILER.projective_point(game, reply),
                )
            ]
            for reply in reply_cells
        }
        actual = {
            cell_index(game, tuple(row["reply"]))
            for row in correspondence_rows(
                kernel, state, transformed_opponent
            )
        }
        assert expected == actual
        checked_edges += len(expected)
    return {
        "selected_six_set_stabilizer_order": len(matrices),
        "transported_marked_opponents": [
            list(cell) for cell in sorted(marked_opponents)
        ],
        "commuting_edge_checks": checked_edges,
        "all_transported_fibres_equal": True,
    }


def case_row(
    q: int,
    t4: tuple[int, ...],
    opponent_cell: tuple[int, int],
    repair_cell: tuple[int, int],
    *,
    with_transport: bool,
) -> dict:
    kernel = SPOILER.SHELL.PositivePairingKernel(q)
    game = kernel.game
    state = game.base_mask(t4)
    opponent = cell_index(game, opponent_cell)
    rows = correspondence_rows(kernel, state, opponent)
    repair_present = any(tuple(row["reply"]) == repair_cell for row in rows)
    assert repair_present
    p_count = sum(row["exact_grid_value"] == "P" for row in rows)
    result = {
        "q": q,
        "root_t4": list(t4),
        "opponent": list(opponent_cell),
        "certified_repair": list(repair_cell),
        "certified_repair_present": repair_present,
        "projected_fibre_degree": len(rows),
        "value_histogram": {"P": p_count, "N": len(rows) - p_count},
        "edges": rows,
    }
    if with_transport:
        result["transport"] = transport_check(
            kernel, state, opponent, rows
        )
    return result


def build_certificate() -> dict:
    cases = [
        case_row(q, t4, opponent, reply, with_transport=index in (0, 4))
        for index, (q, t4, opponent, reply) in enumerate(COMPARE.REPAIRS)
    ]
    assert [case["projected_fibre_degree"] for case in cases] == [
        23,
        23,
        23,
        23,
        47,
    ]
    assert [case["value_histogram"] for case in cases] == [
        {"P": 1, "N": 22},
        {"P": 1, "N": 22},
        {"P": 1, "N": 22},
        {"P": 1, "N": 22},
        {"P": 39, "N": 8},
    ]
    return {
        "schema": "c80-equivariant-live-secant-correspondence-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path)
            for path in sorted(set(INPUTS))
        },
        "correspondence": {
            "domain": (
                "jointly legal strict-overload external intruder replies"
            ),
            "equation": (
                "there exist two distinct conic points still legal after "
                "the exchange whose chord contains the reply"
            ),
            "intended_role": (
                "retain one formula-defined conic reply edge without "
                "choosing a matching representative"
            ),
        },
        "cases": cases,
        "cross_checks": {
            "all_five_certified_repairs_present": True,
            "sigma_pair_test_equals_direct_determinant_test_on_domain": True,
            "q17_klein_four_transport_commutes": True,
            "q19_control_stabilizer_transport_commutes": True,
        },
        "verdict": {
            "transport_naturality": "PASS",
            "edgewise_soundness": "FAIL",
            "q17_counterexamples_per_marked_fibre": 22,
            "q19_counterexamples_in_control_fibre": 8,
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
