#!/usr/bin/env python3
"""C80: sweep later canonical q23 F_d edges for the first F_del failure."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import sys
import tempfile
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_obligation_deletion_rewrite.py"
OUT = ROOT / "notes/2026-07-26-c80-q23-obligation-deletion-sweep.json"
START_INDEX = 11


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_obligation_deletion_sweep_base")
SWEEP = BASE.BASE
CONTROL = SWEEP.BASE
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.LIVE


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def cells(deletion: BASE.DeletionCensus, mask: int) -> list[list[int]]:
    return [
        list(deletion.game.cell_tuple(point))
        for point in GEOMETRY.bits(mask)
    ]


def obstruction_record(
    deletion: BASE.DeletionCensus,
    mask: int,
) -> dict:
    census = deletion.census
    game = deletion.game
    defects = deletion.defects(mask)
    blocking = None

    for opponent in sorted(defects):
        child = mask | (1 << opponent)
        reply_rows = []
        deletion_witnesses = 0
        fd_witnesses = 0
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            target = child | (1 << reply)
            next_defects = deletion.defects(target)
            next_fd = census.ranked_survivor(target)["holds"]
            is_fd_edge = next_fd and len(next_defects) < len(defects)
            is_deletion_edge = (
                next_defects < defects and deletion.survives(target)
            )
            fd_witnesses += int(is_fd_edge)
            deletion_witnesses += int(is_deletion_edge)
            if not is_fd_edge and not is_deletion_edge:
                continue
            new_defects = next_defects - defects
            retained_defects = next_defects & defects
            reply_rows.append(
                {
                    "reply": list(game.cell_tuple(reply)),
                    "next_defect_rank": len(next_defects),
                    "next_defects": [
                        list(game.cell_tuple(point))
                        for point in sorted(next_defects)
                    ],
                    "removed_old_defect_count": len(
                        defects - next_defects
                    ),
                    "retained_old_defects": [
                        list(game.cell_tuple(point))
                        for point in sorted(retained_defects)
                    ],
                    "new_defect_count": len(new_defects),
                    "new_defects": [
                        list(game.cell_tuple(point))
                        for point in sorted(new_defects)
                    ],
                    "strict_locus_deletion": next_defects < defects,
                    "successor_in_F_d": next_fd,
                    "successor_in_F_del": deletion.survives(target),
                }
            )
        if deletion_witnesses == 0:
            blocking = {
                "opponent": list(game.cell_tuple(opponent)),
                "F_d_witnesses": fd_witnesses,
                "F_del_witnesses": deletion_witnesses,
                "all_F_d_witnesses_create_replacements": bool(
                    fd_witnesses
                ) and all(
                    row["new_defect_count"] > 0
                    for row in reply_rows
                    if row["successor_in_F_d"]
                    and row["next_defect_rank"] < len(defects)
                ),
                "witness_rows": reply_rows,
            }
            break

    assert blocking is not None
    return {
        "state_cells": cells(deletion, mask),
        "defect_rank": len(defects),
        "omega": census.kernel.omega(mask),
        "blocking_obligation": blocking,
    }


def build_certificate(
    path: Path, max_controls: int | None = None
) -> dict:
    canonical_rows = CONTROL.canonical_p_replies()
    assert len(canonical_rows) > START_INDEX
    deletion = BASE.DeletionCensus()
    census = deletion.census
    game = deletion.game
    completed = []

    certificate = {
        "schema": "c80-q23-obligation-deletion-sweep-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(SOURCE.relative_to(ROOT)): sha256(SOURCE),
            str(BASE.SOURCE.relative_to(ROOT)): sha256(BASE.SOURCE),
            **{
                str(input_path.relative_to(ROOT)): sha256(input_path)
                for input_path in CONTROL.INPUTS
            },
        },
        "domain": {
            "q": CONTROL.Q,
            "root_t4": list(CONTROL.T4),
            "history_opponent": list(CONTROL.HISTORY_OPPONENT),
            "canonical_p_controls": len(canonical_rows),
            "start_index_zero_based": START_INDEX,
            "control_order": "C54 canonical P-reply order",
            "edge_order": "lexicographic opponent then reply cell",
            "stop_condition": (
                "first outer reply target in F_d but not in F_del, "
                "explicit max-controls limit, or exhaustion"
            ),
        },
        "completed_controls": completed,
        "stop": None,
        "status": "RUNNING",
    }
    write_json(path, certificate)

    rows = canonical_rows[START_INDEX:]
    if max_controls is not None:
        rows = rows[:max_controls]

    for offset, canonical_row in enumerate(rows):
        control_index = START_INDEX + offset
        history_reply = tuple(canonical_row["reply"])
        control = game.base_mask(CONTROL.T4)
        for cell in (CONTROL.HISTORY_OPPONENT, history_reply):
            control |= 1 << LIVE.cell_index(game, cell)

        counts = Counter()
        mismatch = None
        for opponent in GEOMETRY.bits(game.legal_mask(control)):
            counts["opponent_fibres"] += 1
            child = control | (1 << opponent)
            for reply in GEOMETRY.bits(game.legal_mask(child)):
                counts["legal_reply_candidates"] += 1
                target = child | (1 << reply)
                survivor = census.ranked_survivor(target)
                if not survivor["holds"]:
                    continue
                counts["F_d_edges"] += 1
                if deletion.survives(target):
                    counts["F_del_edges"] += 1
                    continue
                mismatch = {
                    "kind": "F_d_outside_F_del",
                    "control_index_zero_based": control_index,
                    "history_reply": list(history_reply),
                    "outer_opponent": list(game.cell_tuple(opponent)),
                    "outer_reply": list(game.cell_tuple(reply)),
                    "candidates_scanned_in_control": counts[
                        "legal_reply_candidates"
                    ],
                    **obstruction_record(deletion, target),
                }
                break
            if mismatch is not None:
                break

        if mismatch is not None:
            certificate["status"] = "FAILURE_FOUND"
            certificate["stop"] = mismatch
            certificate["search_totals"] = dict(
                sum(
                    (Counter(row["counts"]) for row in completed),
                    counts,
                )
            )
            write_json(path, certificate)
            return certificate

        completed.append(
            {
                "control_index_zero_based": control_index,
                "history_reply": list(history_reply),
                "oracle_line": canonical_row["oracle_line"],
                "counts": dict(counts),
                "F_del_equals_F_d": True,
            }
        )
        write_json(path, certificate)

    certificate["search_totals"] = dict(
        sum(
            (Counter(row["counts"]) for row in completed),
            Counter(),
        )
    )
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
            "controls_tested": len(completed),
        }
    write_json(path, certificate)
    return certificate


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--max-controls", type=int)
    args = parser.parse_args()
    if args.max_controls is not None and args.max_controls < 1:
        raise SystemExit("--max-controls must be positive")
    if args.check:
        if not OUT.is_file():
            raise SystemExit(f"missing certificate: {OUT}")
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            build_certificate(candidate, args.max_controls)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return 0
    certificate = build_certificate(OUT, args.max_controls)
    print(
        json.dumps(
            {
                "output": str(OUT.relative_to(ROOT)),
                "sha256": sha256(OUT),
                "status": certificate["status"],
                "stop": certificate["stop"],
                "search_totals": certificate["search_totals"],
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
