#!/usr/bin/env python3
"""C80: quotient three marked q23 replacement orbits and test the next."""
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
PREVIOUS_SOURCE = (
    ROOT / "rust/scripts/c80_q23_next_marked_replacement_orbit.py"
)
PREVIOUS_CERT = (
    ROOT / "notes/2026-07-26-c80-q23-next-marked-replacement-orbit.json"
)
OUT = (
    ROOT
    / "notes/2026-07-28-c80-q23-after-three-replacement-orbits.json"
)
BACKEND_BIN = ROOT / "rust/target/c80-q23-replacement-sweep-backend"
START_CONTROL = 88


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


PREVIOUS = load_module(PREVIOUS_SOURCE, "c80_q23_three_orbit_base")
CONTROL = PREVIOUS.CONTROL
DELETION = PREVIOUS.DELETION
FIRST = PREVIOUS.FIRST
LIVE = PREVIOUS.LIVE
SWEEP = PREVIOUS.SWEEP


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def known_orbits(game) -> tuple[set[tuple], set[tuple], set[tuple]]:
    type_i, type_ii = PREVIOUS.known_orbits(game)
    certificate = json.loads(PREVIOUS_CERT.read_text())
    type_iii = PREVIOUS.orbit_from_marked_record(
        game, certificate["next_new_orbit"]
    )
    assert type_i.isdisjoint(type_ii)
    assert type_i.isdisjoint(type_iii)
    assert type_ii.isdisjoint(type_iii)
    return type_i, type_ii, type_iii


def projective_point(game, cell: tuple[int, int]):
    return PREVIOUS.projective_point(game, cell)


def marked_key(game, target: int, witness: dict) -> tuple:
    return FIRST.marked_key(
        game,
        LIVE.selected_projective_points(game, target),
        projective_point(game, tuple(witness["opponent"])),
        projective_point(game, tuple(witness["reply"])),
        {
            projective_point(game, tuple(cell))
            for cell in witness["new_defects"]
        },
        {
            projective_point(game, tuple(cell))
            for cell in witness["retained_old_defects"]
        },
    )


def classify_local_flag(deletion, target: int, witness: dict) -> dict:
    ancestry = PREVIOUS.analyze_causal_ancestry(
        deletion, target, witness
    )
    if (
        ancestry["branching"] > 1
        or ancestry["creator_without_old_label"]
        or ancestry["ancestry_collision"]
    ):
        return {
            "status": "CAUSAL_ANCESTRY_FALSIFIER",
            "bounded_causality_flag": None,
        }
    try:
        flag = PREVIOUS.analyze_boundary_flag(
            deletion, target, witness
        )
    except (AssertionError, IndexError):
        return {
            "status": "NEW_BOUNDED_FLAG",
            "bounded_causality_flag": None,
        }
    return {
        "status": "KNOWN_BOUNDED_FLAG",
        "bounded_causality_flag": flag,
    }


def independently_replay_witness(
    deletion, target: int, witness: dict
) -> tuple[dict, dict]:
    primary = next(
        row
        for row in FIRST.replacement_witnesses(deletion, target)
        if row["opponent"] == witness["opponent"]
        and row["reply"] == witness["reply"]
    )
    for field in (
        "old_defect_rank",
        "after_opponent_defect_rank",
        "next_defect_rank",
        "created_by_opponent",
        "created_by_reply",
        "new_defects",
        "retained_old_defects",
        "removed_old_defects",
        "successor_in_F_del",
    ):
        if isinstance(primary[field], list):
            assert sorted(primary[field]) == sorted(witness[field])
        else:
            assert primary[field] == witness[field]
    ancestry = PREVIOUS.analyze_causal_ancestry(
        deletion, target, primary
    )
    return primary, ancestry


def build_certificate(path: Path, backend: Path = BACKEND_BIN) -> dict:
    PREVIOUS.compile_backend(backend)
    deletion = DELETION.DeletionCensus()
    game = deletion.game
    type_i, type_ii, type_iii = known_orbits(game)
    orbit_sets = {
        "type_i": type_i,
        "type_ii": type_ii,
        "type_iii": type_iii,
    }
    known = type_i | type_ii | type_iii
    canonical_rows = CONTROL.canonical_p_replies()
    totals = Counter()
    completed = []

    for control_index in range(START_CONTROL, len(canonical_rows)):
        history_reply = tuple(canonical_rows[control_index]["reply"])
        result = PREVIOUS.rust_control(backend, history_reply)
        totals.update(result["counts"])
        control = game.base_mask(CONTROL.T4)
        for cell in (CONTROL.HISTORY_OPPONENT, history_reply):
            control |= 1 << LIVE.cell_index(game, cell)

        for witness in result["witnesses"]:
            outer_opponent = LIVE.cell_index(
                game, tuple(witness["outer_opponent"])
            )
            outer_reply = LIVE.cell_index(
                game, tuple(witness["outer_reply"])
            )
            target = (
                control
                | (1 << outer_opponent)
                | (1 << outer_reply)
            )
            key = marked_key(game, target, witness)
            if key in known:
                primary, ancestry = independently_replay_witness(
                    deletion, target, witness
                )
                assert marked_key(game, target, primary) == key
                assert ancestry["injective_causal_ancestry"]
                totals["independent_witness_replays"] += 1
                totals["known_orbit_witnesses_skipped"] += 1
                for name, orbit in orbit_sets.items():
                    if key in orbit:
                        totals[f"{name}_witnesses_skipped"] += 1
                continue

            primary, ancestry = independently_replay_witness(
                deletion, target, witness
            )
            local = classify_local_flag(
                deletion, target, primary
            )
            previous_certificate = json.loads(
                PREVIOUS_CERT.read_text()
            )
            certificate = {
                "schema": (
                    "c80-q23-after-three-replacement-orbits-v1"
                ),
                "source": str(
                    Path(__file__).resolve().relative_to(ROOT)
                ),
                "input_sha256": {
                    **previous_certificate["input_sha256"],
                    str(PREVIOUS_SOURCE.relative_to(ROOT)): sha256(
                        PREVIOUS_SOURCE
                    ),
                    str(PREVIOUS_CERT.relative_to(ROOT)): sha256(
                        PREVIOUS_CERT
                    ),
                },
                "domain": {
                    "q": CONTROL.Q,
                    "start_control_zero_based": START_CONTROL,
                    "known_marked_orbit_sizes": {
                        "type_i": len(type_i),
                        "type_ii": len(type_ii),
                        "type_iii": len(type_iii),
                        "union": len(known),
                    },
                    "control_order": "C54 canonical P-reply order",
                    "edge_order": (
                        "outer opponent, outer reply, blocking "
                        "obligation, sound reply lexicographic"
                    ),
                    "stop_condition": (
                        "first necessary replacement witness "
                        "outside the first three marked PGL2 orbits"
                    ),
                    "backend": (
                        "fresh bounded-memory Rust line-load engine "
                        "for each canonical control"
                    ),
                },
                "completed_controls": completed,
                "search_counts": dict(totals),
                "next_new_orbit": {
                    "control_index_zero_based": control_index,
                    "history_reply": list(history_reply),
                    "target_cells": SWEEP.cells(deletion, target),
                    "target_omega": (
                        deletion.census.kernel.omega(target)
                    ),
                    **witness,
                },
                "causal_ancestry": ancestry,
                **local,
                "independent_replay": {
                    "rust_python_witness_fields_agree": True,
                    "python_affine_determinant_defects_agree": True,
                },
            }
            PREVIOUS.write_json(path, certificate)
            return certificate

        completed.append(
            {
                "control_index_zero_based": control_index,
                "history_reply": list(history_reply),
                "counts": result["counts"],
            }
        )

    assert (
        totals["known_orbit_witnesses_skipped"]
        == totals["necessary_replacement_witnesses"]
    )
    assert totals["known_orbit_witnesses_skipped"] == sum(
        totals[f"{name}_witnesses_skipped"]
        for name in orbit_sets
    )
    previous_certificate = json.loads(PREVIOUS_CERT.read_text())
    certificate = {
        "schema": "c80-q23-after-three-replacement-orbits-v1",
        "source": str(
            Path(__file__).resolve().relative_to(ROOT)
        ),
        "input_sha256": {
            **previous_certificate["input_sha256"],
            str(PREVIOUS_SOURCE.relative_to(ROOT)): sha256(
                PREVIOUS_SOURCE
            ),
            str(PREVIOUS_CERT.relative_to(ROOT)): sha256(
                PREVIOUS_CERT
            ),
        },
        "domain": {
            "q": CONTROL.Q,
            "start_control_zero_based": START_CONTROL,
            "end_control_zero_based": len(canonical_rows) - 1,
            "known_marked_orbit_sizes": {
                "type_i": len(type_i),
                "type_ii": len(type_ii),
                "type_iii": len(type_iii),
                "union": len(known),
            },
            "control_order": "C54 canonical P-reply order",
            "edge_order": (
                "outer opponent, outer reply, blocking "
                "obligation, sound reply lexicographic"
            ),
            "stop_condition": (
                "first necessary replacement witness outside "
                "the first three marked PGL2 orbits, or "
                "exhaustion of all remaining canonical controls"
            ),
            "backend": (
                "fresh bounded-memory Rust line-load engine "
                "for each canonical control"
            ),
        },
        "completed_controls": completed,
        "search_counts": dict(totals),
        "next_new_orbit": None,
        "known_orbit_ancestry": {
            "type_i": (
                "opponent-created endpoint degradation; "
                "injective old-label transport"
            ),
            "type_ii": (
                "reply-created certificate-reply deletion; "
                "injective old-label transport"
            ),
            "type_iii": (
                "reply-created certificate-reply deletion with "
                "pre-existing selected pivot; injective "
                "old-label transport"
            ),
            "branching_or_unlabelled_creator": False,
        },
        "independent_replay": {
            "rust_python_witness_fields_agree": True,
            "python_affine_determinant_defects_agree": True,
            "orbit_partition_is_disjoint": True,
            "every_backend_witness_is_in_known_union": True,
        },
        "status": "EXHAUSTED_NO_NEW_ORBIT",
    }
    PREVIOUS.write_json(path, certificate)
    return certificate


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        if not OUT.is_file():
            raise SystemExit(f"missing certificate: {OUT}")
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            backend = Path(directory) / BACKEND_BIN.name
            build_certificate(candidate, backend)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return 0

    certificate = build_certificate(OUT)
    summary = {
        "output": str(OUT.relative_to(ROOT)),
        "sha256": sha256(OUT),
        "status": certificate["status"],
        "search_counts": certificate["search_counts"],
    }
    if certificate["next_new_orbit"] is not None:
        ancestry = certificate["causal_ancestry"]
        summary.update(
            {
                "control_index": certificate["next_new_orbit"][
                    "control_index_zero_based"
                ],
                "history_reply": certificate["next_new_orbit"][
                    "history_reply"
                ],
                "branching": ancestry["branching"],
                "creator_without_old_label": ancestry[
                    "creator_without_old_label"
                ],
                "ancestry_collision": ancestry[
                    "ancestry_collision"
                ],
            }
        )
    print(json.dumps(summary, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
