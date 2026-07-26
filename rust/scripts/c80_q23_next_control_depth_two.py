#!/usr/bin/env python3
"""C80: test R0 on the next canonical q23 P control."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_rank_zero_correspondence.py"
C54_REPORT = ROOT / "notes/2026-07-09-codex-q23-bucket-certification.md"
ORACLE_BINARY = ROOT / "rust/target/gridcap-c54"
ORACLE_RAW = (
    ROOT / "rust/s4-dumps/2026-07-08/q23-root-1234-1-2-3-4.raw"
)
OUT = ROOT / "notes/2026-07-25-c80-q23-next-control-depth-two.json"

Q = 23
T4 = (1, 2, 3, 4)
HISTORY_OPPONENT = (0, 0)
PREVIOUS_REPLY = (5, 2)
HISTORY_REPLY = (5, 9)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_next_control_base")
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.BASE.LIVE
INPUTS = tuple(
    sorted(set((*BASE.INPUTS, SOURCE, C54_REPORT)))
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_p_replies() -> list[dict]:
    if not ORACLE_BINARY.is_file() or not ORACLE_RAW.is_file():
        raise RuntimeError("q23 C54 binary/raw archive is required")
    command = [
        str(ORACLE_BINARY),
        "s4query",
        str(Q),
        ",".join(map(str, T4)),
        "--raw",
        str(ORACLE_RAW),
    ]
    result = subprocess.run(
        command,
        input=(
            f"replies {HISTORY_OPPONENT[0]},{HISTORY_OPPONENT[1]}\n"
            "quit\n"
        ),
        text=True,
        capture_output=True,
        check=True,
    )
    p_lines = [
        line
        for line in result.stdout.splitlines()
        if line.startswith(
            f"REPLY x={HISTORY_OPPONENT[0]},{HISTORY_OPPONENT[1]} "
        )
        and " value=P" in line
    ]
    rows = []
    for line in p_lines:
        fields = line.split()
        y_field = next(field for field in fields if field.startswith("y="))
        y = tuple(map(int, y_field.removeprefix("y=").split(",")))
        rows.append({"reply": y, "oracle_line": line})
    return rows


def oracle_evidence() -> dict:
    rows = canonical_p_replies()
    previous_index = next(
        i for i, row in enumerate(rows) if row["reply"] == PREVIOUS_REPLY
    )
    target_index = next(
        i for i, row in enumerate(rows) if row["reply"] == HISTORY_REPLY
    )
    assert previous_index == 0
    assert target_index == 1
    return {
        "canonical_p_reply_index_zero_based": target_index,
        "canonical_p_replies": len(rows),
        "previous_p_reply_line": rows[previous_index]["oracle_line"],
        "target_p_reply_line": rows[target_index]["oracle_line"],
        "binary": str(ORACLE_BINARY.relative_to(ROOT)),
        "binary_sha256": sha256(ORACLE_BINARY),
        "raw_archive": str(ORACLE_RAW.relative_to(ROOT)),
        "raw_archive_bytes": ORACLE_RAW.stat().st_size,
        "raw_archive_sha256": sha256(ORACLE_RAW),
        "c54_contract": str(C54_REPORT.relative_to(ROOT)),
    }


def oracle_p_replies(
    history_reply: tuple[int, int],
    opponent_cell: tuple[int, int],
) -> list[dict]:
    command = [
        str(ORACLE_BINARY),
        "s4query",
        str(Q),
        ",".join(map(str, T4)),
        "--raw",
        str(ORACLE_RAW),
    ]
    result = subprocess.run(
        command,
        input=(
            f"play {HISTORY_OPPONENT[0]},{HISTORY_OPPONENT[1]}\n"
            f"play {history_reply[0]},{history_reply[1]}\n"
            f"replies {opponent_cell[0]},{opponent_cell[1]}\n"
            "quit\n"
        ),
        text=True,
        capture_output=True,
        check=True,
    )
    prefix = f"REPLY x={opponent_cell[0]},{opponent_cell[1]} "
    rows = []
    for line in result.stdout.splitlines():
        if not line.startswith(prefix) or " value=P" not in line:
            continue
        fields = line.split()
        y_field = next(field for field in fields if field.startswith("y="))
        y = tuple(map(int, y_field.removeprefix("y=").split(",")))
        rows.append({"reply": list(y), "oracle_line": line})
    return rows


def oracle_reply_line(
    history_reply: tuple[int, int],
    opponent_cell: tuple[int, int],
    reply_cell: tuple[int, int],
) -> str:
    command = [
        str(ORACLE_BINARY),
        "s4query",
        str(Q),
        ",".join(map(str, T4)),
        "--raw",
        str(ORACLE_RAW),
    ]
    result = subprocess.run(
        command,
        input=(
            f"play {HISTORY_OPPONENT[0]},{HISTORY_OPPONENT[1]}\n"
            f"play {history_reply[0]},{history_reply[1]}\n"
            f"replies {opponent_cell[0]},{opponent_cell[1]}\n"
            "quit\n"
        ),
        text=True,
        capture_output=True,
        check=True,
    )
    prefix = (
        f"REPLY x={opponent_cell[0]},{opponent_cell[1]} "
        f"y={reply_cell[0]},{reply_cell[1]} "
    )
    return next(
        line for line in result.stdout.splitlines()
        if line.startswith(prefix)
    )


def cells(census, mask: int) -> list[list[int]]:
    return [
        list(census.game.cell_tuple(point))
        for point in GEOMETRY.bits(mask)
    ]


def rank_zero_replies(census, mask: int) -> list[dict]:
    rank = census.defect_rank(mask)
    assert rank > 0
    rows = []
    for opponent in census.update.defect(mask):
        child = mask | (1 << opponent)
        replies = []
        for reply in GEOMETRY.bits(census.game.legal_mask(child)):
            target = child | (1 << reply)
            next_rank = census.defect_rank(target)
            if next_rank == 0:
                replies.append(
                    {
                        "reply": list(census.game.cell_tuple(reply)),
                        "next_defect_rank": 0,
                    }
                )
        rows.append(
            {
                "opponent": list(census.game.cell_tuple(opponent)),
                "rank_zero_replies": replies,
            }
        )
    return rows


def first_depth_two_obligation(census, mask: int, survivor: dict) -> dict:
    rank = census.defect_rank(mask)
    by_opponent = {
        tuple(row["opponent"]): row for row in survivor["witness_edges"]
    }
    for row in rank_zero_replies(census, mask):
        if row["rank_zero_replies"]:
            continue
        opponent_cell = tuple(row["opponent"])
        witness = by_opponent[opponent_cell]
        opponent = LIVE.cell_index(census.game, opponent_cell)
        reply_cell = tuple(witness["reply"])
        reply = LIVE.cell_index(census.game, reply_cell)
        target = mask | (1 << opponent) | (1 << reply)
        next_survivor = census.ranked_survivor(target)
        next_r0 = rank_zero_replies(census, target)
        assert 0 < witness["next_defect_rank"] < rank
        assert next_survivor["holds"]
        assert all(item["rank_zero_replies"] for item in next_r0)
        return {
            "defect_opponent": list(opponent_cell),
            "no_direct_rank_zero_reply": True,
            "selected_reply": list(reply_cell),
            "next_defect_rank": witness["next_defect_rank"],
            "next_state_cells": cells(census, target),
            "next_state_is_R0": True,
            "next_state_rank_zero_response_fibres": next_r0,
        }
    raise AssertionError("survivor outside R0 had no failing R0 obligation")


def build_certificate() -> dict:
    oracle = oracle_evidence()
    census = BASE.BASE.DescentCensus()
    game = census.game
    canonical_controls = canonical_p_replies()
    assert canonical_controls[0]["reply"] == PREVIOUS_REPLY
    assert canonical_controls[1]["reply"] == HISTORY_REPLY
    control = game.base_mask(T4)
    for cell in (HISTORY_OPPONENT, HISTORY_REPLY):
        control |= 1 << LIVE.cell_index(game, cell)

    rows = []
    direct_edges = 0
    survivor_edges = 0
    mismatches = []
    first_recursive_failure = None
    first_depth_one_obstruction = None
    for opponent in GEOMETRY.bits(game.legal_mask(control)):
        child = control | (1 << opponent)
        direct_replies = 0
        recursive_replies = 0
        candidates = 0
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            candidates += 1
            target = child | (1 << reply)
            in_r0 = all(
                row["rank_zero_replies"]
                for row in rank_zero_replies(census, target)
            )
            survivor = census.ranked_survivor(target)
            in_survivor = survivor["holds"]
            direct_edges += int(in_r0)
            survivor_edges += int(in_survivor)
            direct_replies += int(in_r0)
            recursive_replies += int(in_survivor)
            if in_r0 != in_survivor:
                mismatches.append(
                    {
                        "opponent": list(game.cell_tuple(opponent)),
                        "reply": list(game.cell_tuple(reply)),
                        "R0": in_r0,
                        "F_d": in_survivor,
                    }
                )
            if not in_survivor:
                obstruction = survivor[
                    "first_nondecreasing_obstruction"
                ]
                target_cells = cells(census, target)
                obstruction_depth = (
                    len(obstruction["state_cells"])
                    - len(target_cells)
                ) // 2
                failure = {
                    "outer_opponent": list(game.cell_tuple(opponent)),
                    "outer_reply": list(game.cell_tuple(reply)),
                    "target_cells": target_cells,
                    "target_defect_rank": census.defect_rank(target),
                    "target_omega": census.kernel.omega(target),
                    "obstruction_exchange_depth": obstruction_depth,
                    "first_nondecreasing_obstruction": obstruction,
                }
                if (
                    obstruction_depth == 1
                    and first_depth_one_obstruction is None
                ):
                    target_cell_set = {
                        tuple(cell) for cell in target_cells
                    }
                    added = [
                        tuple(cell)
                        for cell in obstruction["state_cells"]
                        if tuple(cell) not in target_cell_set
                    ]
                    paths = []
                    defect_set = set(census.update.defect(target))
                    for path_opponent_cell in added:
                        path_opponent = LIVE.cell_index(
                            game, path_opponent_cell
                        )
                        if path_opponent not in defect_set:
                            continue
                        path_child = target | (1 << path_opponent)
                        for path_reply_cell in added:
                            if path_reply_cell == path_opponent_cell:
                                continue
                            path_reply = LIVE.cell_index(
                                game, path_reply_cell
                            )
                            if game.legal_mask(path_child) & (
                                1 << path_reply
                            ):
                                paths.append(
                                    {
                                        "opponent": list(
                                            path_opponent_cell
                                        ),
                                        "reply": list(path_reply_cell),
                                    }
                                )
                    assert paths
                    paths.sort(
                        key=lambda row: (
                            LIVE.cell_index(
                                game, tuple(row["opponent"])
                            ),
                            LIVE.cell_index(game, tuple(row["reply"])),
                        )
                    )
                    failure["canonical_exchange_to_obstruction"] = (
                        paths[0]
                    )
                    failure["legal_exchange_orientations"] = paths
                    obstruction_mask = 0
                    for cell in obstruction["state_cells"]:
                        obstruction_mask |= 1 << LIVE.cell_index(
                            game, tuple(cell)
                        )
                    obstruction_moves = []
                    for move in GEOMETRY.bits(
                        game.legal_mask(obstruction_mask)
                    ):
                        follower = obstruction_mask | (1 << move)
                        obstruction_moves.append(
                            {
                                "move": list(game.cell_tuple(move)),
                                "follower_legal_moves": game.legal_mask(
                                    follower
                                ).bit_count(),
                            }
                        )
                    terminal_moves = [
                        row["move"]
                        for row in obstruction_moves
                        if row["follower_legal_moves"] == 0
                    ]
                    assert obstruction["defect_opponent"] in terminal_moves
                    failure["obstruction_legal_moves"] = (
                        obstruction_moves
                    )
                    failure["obstruction_terminal_moves"] = terminal_moves
                    failure["C54_target_value_line"] = oracle_reply_line(
                        HISTORY_REPLY,
                        game.cell_tuple(opponent),
                        game.cell_tuple(reply),
                    )
                if first_recursive_failure is None:
                    first_recursive_failure = failure
                if (
                    obstruction_depth == 1
                    and first_depth_one_obstruction is None
                ):
                    first_depth_one_obstruction = failure
        rows.append(
            {
                "opponent": list(game.cell_tuple(opponent)),
                "legal_reply_candidates": candidates,
                "R0_replies": direct_replies,
                "recursive_survivor_replies": recursive_replies,
            }
        )

    assert all(row["R0_replies"] > 0 for row in rows)
    assert not mismatches
    assert direct_edges == survivor_edges
    assert first_recursive_failure is not None
    return {
        "schema": "c80-q23-next-control-depth-two-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "control": {
            "q": Q,
            "root_t4": list(T4),
            "history": [
                list(HISTORY_OPPONENT),
                list(HISTORY_REPLY),
            ],
            "canonical_choice": (
                "second P reply in C54 s4query canonical output order "
                "after the prior control's first P reply"
            ),
            "legal_moves": game.legal_mask(control).bit_count(),
            "oracle": oracle,
        },
        "search": {
            "order": (
                "increasing internal cell index for outer opponents, "
                "then replies; complete census of the immediate next control"
            ),
            "outer_opponent_fibres": len(rows),
            "outer_reply_candidates": sum(
                row["legal_reply_candidates"] for row in rows
            ),
            "rows": rows,
        },
        "direct_recursive_comparison": {
            "R0_edges": direct_edges,
            "F_d_edges": survivor_edges,
            "mismatches": mismatches,
            "R0_opponent_complete": True,
        },
        "first_recursive_failure": first_recursive_failure,
        "first_failure_one_exchange_below_target": (
            first_depth_one_obstruction
        ),
        "verdict": {
            "R0_opponent_complete_on_immediate_next_control": True,
            "R0_equals_recursive_survivor_on_domain": True,
            "survivor_edge_outside_R0": False,
            "R0_coverage_failure": False,
            "uniform_odd_q_theorem": "OPEN",
            "c82_released": False,
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
