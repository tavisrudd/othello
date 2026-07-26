#!/usr/bin/env python3
"""C80: sweep canonical q23 P controls until R0/F_d first fails."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_next_control_depth_two.py"
OUT = ROOT / "notes/2026-07-25-c80-q23-canonical-rank-zero-sweep.json"
START_INDEX = 4


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_canonical_sweep_base")
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.LIVE


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def is_r0(census, mask: int) -> bool:
    rank = census.defect_rank(mask)
    if rank == 0:
        return True
    for opponent in census.update.defect(mask):
        child = mask | (1 << opponent)
        if not any(
            census.defect_rank(child | (1 << reply)) == 0
            for reply in GEOMETRY.bits(census.game.legal_mask(child))
        ):
            return False
    return True


def mismatch_record(
    census,
    control_index: int,
    history_reply: tuple[int, int],
    opponent: int,
    reply: int,
    in_r0: bool,
    survivor: dict,
    scanned_candidates: int,
) -> dict:
    target = (
        census.game.base_mask(BASE.T4)
        | (1 << LIVE.cell_index(census.game, BASE.HISTORY_OPPONENT))
        | (1 << LIVE.cell_index(census.game, history_reply))
        | (1 << opponent)
        | (1 << reply)
    )
    record = {
        "kind": (
            "F_d_outside_R0"
            if survivor["holds"] and not in_r0
            else "R0_outside_F_d"
        ),
        "control_index_zero_based": control_index,
        "history_reply": list(history_reply),
        "outer_opponent": list(census.game.cell_tuple(opponent)),
        "outer_reply": list(census.game.cell_tuple(reply)),
        "C54_target_value_line": BASE.oracle_reply_line(
            history_reply,
            census.game.cell_tuple(opponent),
            census.game.cell_tuple(reply),
        ),
        "target_defect_rank": census.defect_rank(target),
        "target_omega": census.kernel.omega(target),
        "R0": in_r0,
        "F_d": survivor["holds"],
        "candidates_scanned_in_control": scanned_candidates,
        "first_nondecreasing_obstruction": survivor.get(
            "first_nondecreasing_obstruction"
        ),
    }
    if survivor["holds"] and not in_r0:
        witnesses = {
            tuple(row["opponent"]): row
            for row in survivor["witness_edges"]
        }
        failures = []
        for row in BASE.rank_zero_replies(census, target):
            if row["rank_zero_replies"]:
                continue
            opponent_cell = tuple(row["opponent"])
            witness = witnesses[opponent_cell]
            defect_opponent = LIVE.cell_index(
                census.game, opponent_cell
            )
            reply_cell = tuple(witness["reply"])
            reply_index = LIVE.cell_index(census.game, reply_cell)
            successor = (
                target
                | (1 << defect_opponent)
                | (1 << reply_index)
            )
            successor_survivor = census.ranked_survivor(successor)
            failures.append(
                {
                    "defect_opponent": list(opponent_cell),
                    "direct_rank_zero_replies": [],
                    "F_d_witness_reply": list(reply_cell),
                    "next_defect_rank": witness["next_defect_rank"],
                    "next_omega": census.kernel.omega(successor),
                    "next_is_R0": is_r0(census, successor),
                    "next_is_F_d": successor_survivor["holds"],
                    "next_state_cells": [
                        list(census.game.cell_tuple(point))
                        for point in GEOMETRY.bits(successor)
                    ],
                }
            )
        assert failures
        record["R0_failure_obligations"] = failures
        record["all_F_d_witness_targets_are_R0"] = all(
            row["next_is_R0"] for row in failures
        )
    return record


def build_certificate(path: Path, max_controls: int | None = None) -> dict:
    canonical_rows = BASE.canonical_p_replies()
    assert len(canonical_rows) > START_INDEX
    census = BASE.BASE.BASE.DescentCensus()
    game = census.game
    summaries = []
    stop = None

    certificate = {
        "schema": "c80-q23-canonical-rank-zero-sweep-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(SOURCE.relative_to(ROOT)): sha256(SOURCE),
            **{
                str(input_path.relative_to(ROOT)): sha256(input_path)
                for input_path in BASE.INPUTS
            },
        },
        "domain": {
            "q": BASE.Q,
            "root_t4": list(BASE.T4),
            "history_opponent": list(BASE.HISTORY_OPPONENT),
            "canonical_p_controls": len(canonical_rows),
            "start_index_zero_based": START_INDEX,
            "stop_condition": (
                "first R0/F_d edge disagreement, first opponent fibre "
                "without an R0 reply, explicit max-controls limit, or "
                "exhaustion of canonical P controls"
            ),
        },
        "completed_controls": summaries,
        "stop": stop,
        "status": "RUNNING",
    }
    write_json(path, certificate)

    rows = canonical_rows[START_INDEX:]
    if max_controls is not None:
        rows = rows[:max_controls]
    for offset, canonical_row in enumerate(rows):
        control_index = START_INDEX + offset
        history_reply = tuple(canonical_row["reply"])
        control = game.base_mask(BASE.T4)
        for cell in (BASE.HISTORY_OPPONENT, history_reply):
            control |= 1 << LIVE.cell_index(game, cell)

        fibres = 0
        candidates = 0
        r0_edges = 0
        fd_edges = 0
        uncovered = None
        mismatch = None
        for opponent in GEOMETRY.bits(game.legal_mask(control)):
            fibres += 1
            child = control | (1 << opponent)
            fibre_r0_edges = 0
            for reply in GEOMETRY.bits(game.legal_mask(child)):
                candidates += 1
                target = child | (1 << reply)
                in_r0 = is_r0(census, target)
                survivor = census.ranked_survivor(target)
                in_fd = survivor["holds"]
                r0_edges += int(in_r0)
                fd_edges += int(in_fd)
                fibre_r0_edges += int(in_r0)
                if in_r0 != in_fd:
                    mismatch = mismatch_record(
                        census,
                        control_index,
                        history_reply,
                        opponent,
                        reply,
                        in_r0,
                        survivor,
                        candidates,
                    )
                    break
            if mismatch is not None:
                break
            if fibre_r0_edges == 0:
                uncovered = {
                    "kind": "R0_coverage_failure",
                    "control_index_zero_based": control_index,
                    "history_reply": list(history_reply),
                    "outer_opponent": list(game.cell_tuple(opponent)),
                    "candidates_scanned_in_control": candidates,
                }
                break

        if mismatch is not None or uncovered is not None:
            stop = mismatch if mismatch is not None else uncovered
            certificate["stop"] = stop
            certificate["status"] = "FAILURE_FOUND"
            write_json(path, certificate)
            return certificate

        summaries.append(
            {
                "control_index_zero_based": control_index,
                "history_reply": list(history_reply),
                "oracle_line": canonical_row["oracle_line"],
                "outer_opponent_fibres": fibres,
                "outer_reply_candidates": candidates,
                "R0_edges": r0_edges,
                "F_d_edges": fd_edges,
                "R0_opponent_complete": True,
                "R0_equals_F_d": True,
            }
        )
        write_json(path, certificate)

    if max_controls is not None and START_INDEX + len(rows) < len(
        canonical_rows
    ):
        certificate["status"] = "LIMIT_REACHED"
        certificate["stop"] = {
            "kind": "explicit_max_controls",
            "controls_requested": max_controls,
        }
    else:
        certificate["status"] = "EXHAUSTED"
        certificate["stop"] = {
            "kind": "canonical_P_controls_exhausted",
            "controls_tested": len(summaries),
        }
    write_json(path, certificate)
    return certificate


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--max-controls", type=int)
    args = parser.parse_args()
    if args.max_controls is not None and args.max_controls < 1:
        raise SystemExit("--max-controls must be positive")
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            build_certificate(candidate, args.max_controls)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return
    build_certificate(OUT, args.max_controls)
    print(f"WROTE {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
