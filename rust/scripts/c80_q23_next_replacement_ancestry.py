#!/usr/bin/env python3
"""C80: locate and analyze the next necessary q23 replacement edge."""
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
SOURCE = ROOT / "rust/scripts/c80_q23_obligation_deletion_sweep.py"
LINEAGE_SOURCE = ROOT / "rust/scripts/c80_q23_replacement_lineage.py"
OUT = ROOT / "notes/2026-07-26-c80-q23-next-replacement-ancestry.json"

START_CONTROL = 20
KNOWN_EDGE = ((8, 4), (13, 7))


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


SWEEP = load_module(SOURCE, "c80_q23_next_replacement_base")
BASE = SWEEP.BASE
CONTROL = SWEEP.CONTROL
GEOMETRY = SWEEP.GEOMETRY
LIVE = SWEEP.LIVE
LINEAGE = load_module(
    LINEAGE_SOURCE, "c80_q23_next_replacement_lineage_helpers"
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def point_cells(deletion, points) -> list[list[int]]:
    return [
        list(deletion.game.cell_tuple(point))
        for point in sorted(points)
    ]


def target_record(deletion, mask: int) -> dict | None:
    game = deletion.game
    census = deletion.census
    defects = deletion.defects(mask)
    blocking_rows = []
    for opponent in sorted(defects):
        child = mask | (1 << opponent)
        witnesses = []
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            successor = child | (1 << reply)
            next_defects = deletion.defects(successor)
            if len(next_defects) >= len(defects):
                continue
            if not census.ranked_survivor(successor)["holds"]:
                continue
            half_defects = deletion.defects(child)
            witnesses.append(
                {
                    "reply": list(game.cell_tuple(reply)),
                    "after_opponent_defects": point_cells(
                        deletion, half_defects
                    ),
                    "after_reply_defects": point_cells(
                        deletion, next_defects
                    ),
                    "created_by_opponent": point_cells(
                        deletion, half_defects - defects
                    ),
                    "created_by_reply": point_cells(
                        deletion, next_defects - half_defects
                    ),
                    "removed_old_defects": point_cells(
                        deletion, defects - next_defects
                    ),
                    "retained_old_defects": point_cells(
                        deletion, defects & next_defects
                    ),
                    "new_defects": point_cells(
                        deletion, next_defects - defects
                    ),
                    "successor_in_F_del": deletion.survives(successor),
                }
            )
        deletion_witnesses = [
            row for row in witnesses
            if not row["new_defects"] and row["successor_in_F_del"]
        ]
        if witnesses and not deletion_witnesses:
            blocking_rows.append(
                {
                    "opponent": list(game.cell_tuple(opponent)),
                    "F_d_witness_count": len(witnesses),
                    "witnesses": witnesses,
                }
            )
    if not blocking_rows:
        return None
    return {
        "state_cells": SWEEP.cells(deletion, mask),
        "defect_rank": len(defects),
        "defects": point_cells(deletion, defects),
        "omega": census.kernel.omega(mask),
        "blocking_obligations": blocking_rows,
    }


def analyze_lineage(deletion, mask: int, record: dict) -> dict:
    game = deletion.game
    defects = deletion.defects(mask)
    blocking = record["blocking_obligations"][0]
    assert len(record["blocking_obligations"]) == 1
    assert blocking["F_d_witness_count"] == 1
    witness = blocking["witnesses"][0]
    assert len(witness["new_defects"]) == 1
    assert len(witness["retained_old_defects"]) == 1

    opponent_cell = tuple(blocking["opponent"])
    reply_cell = tuple(witness["reply"])
    new_cell = tuple(witness["new_defects"][0])
    retained_cell = tuple(witness["retained_old_defects"][0])
    index = lambda cell: LIVE.cell_index(game, cell)
    opponent = index(opponent_cell)
    reply = index(reply_cell)
    new_defect = index(new_cell)
    retained = index(retained_cell)
    child = mask | (1 << opponent)
    successor = child | (1 << reply)

    old_boundary = LINEAGE.primary_boundary_replies(
        deletion, mask, new_defect
    )
    assert len(old_boundary) == 1
    damaged_boundaries = []
    for row in old_boundary:
        boundary_reply_cell = tuple(row["reply"])
        boundary_reply = index(boundary_reply_cell)
        damaged = (
            child | (1 << new_defect) | (1 << boundary_reply)
        )
        remaining = [
            game.cell_tuple(point)
            for point in GEOMETRY.bits(game.legal_mask(damaged))
        ]
        old_remaining = [tuple(point) for point in row["remaining_legal"]]
        killed = sorted(set(old_remaining) - set(remaining))
        pivots = {
            killed_cell: [
                selected
                for selected in SWEEP.cells(deletion, mask)
                if LINEAGE.affine_collinear(
                    tuple(selected), opponent_cell, killed_cell
                )
            ]
            for killed_cell in killed
        }
        damaged_boundaries.append(
            {
                "former_boundary_reply": list(boundary_reply_cell),
                "former_kind": row["kind"],
                "former_legal_locus": [
                    list(point) for point in old_remaining
                ],
                "after_opponent_legal_locus": [
                    list(point) for point in remaining
                ],
                "killed_endpoints": [
                    list(point) for point in killed
                ],
                "causal_selected_pivots": {
                    str(point): pivots[point] for point in killed
                },
            }
        )

    rank_zero = {}
    common_replies = None
    for obligation_cell in (retained_cell, new_cell):
        rows = LINEAGE.primary_rank_zero_replies(
            deletion, successor, index(obligation_cell)
        )
        rank_zero[str(obligation_cell)] = rows
        replies = {tuple(row["reply"]) for row in rows}
        common_replies = (
            replies if common_replies is None
            else common_replies & replies
        )
    assert common_replies is not None
    assert len(common_replies) == 1
    new_boundaries = {}
    for common_reply_cell in sorted(common_replies):
        rows = LINEAGE.primary_boundary_replies(
            deletion, successor, index(common_reply_cell)
        )
        new_boundaries[str(common_reply_cell)] = rows

    reference = LINEAGE.ReferenceGame()
    ref_mask = frozenset(
        tuple(cell) for cell in SWEEP.cells(deletion, mask)
    )
    ref_child = ref_mask | {opponent_cell}
    ref_successor = ref_child | {reply_cell}
    primary_defects = {
        "before": point_cells(deletion, defects),
        "after_opponent": point_cells(deletion, deletion.defects(child)),
        "after_reply": point_cells(
            deletion, deletion.defects(successor)
        ),
    }
    reference_defects = {
        "before": [list(point) for point in reference.defects(ref_mask)],
        "after_opponent": [
            list(point) for point in reference.defects(ref_child)
        ],
        "after_reply": [
            list(point) for point in reference.defects(ref_successor)
        ],
    }
    assert primary_defects == reference_defects
    assert (
        reference.boundary_replies(ref_mask, new_cell)
        == old_boundary
    )

    damaged = damaged_boundaries[0]
    assert len(damaged["killed_endpoints"]) == 1
    killed_cell = tuple(damaged["killed_endpoints"][0])
    assert len(damaged["causal_selected_pivots"][str(killed_cell)]) == 1
    pivot_cell = tuple(
        damaged["causal_selected_pivots"][str(killed_cell)][0]
    )
    old_boundary_reply = tuple(old_boundary[0]["reply"])
    common_reply = next(iter(common_replies))
    assert len(new_boundaries[str(common_reply)]) == 1
    new_boundary = new_boundaries[str(common_reply)][0]
    new_boundary_reply = tuple(new_boundary["reply"])
    assert {
        tuple(point) for point in new_boundary["remaining_legal"]
    } == {retained_cell, new_cell}
    assert LINEAGE.affine_collinear(
        pivot_cell, opponent_cell, killed_cell
    )
    assert LINEAGE.affine_collinear(
        killed_cell, new_cell, common_reply
    )
    assert LINEAGE.affine_collinear(
        old_boundary_reply, new_cell, new_boundary_reply
    )
    killing_line = LINEAGE.projective_line(
        opponent_cell, killed_cell
    )
    assert LINEAGE.line_contains(killing_line, pivot_cell)
    assert (
        reference.boundary_replies(ref_successor, common_reply)
        == [new_boundary]
    )

    previous_mask = deletion.mask(LINEAGE.T_CELLS)
    current_selected = LIVE.selected_projective_points(game, mask)
    previous_selected = LIVE.selected_projective_points(
        game, previous_mask
    )
    transporters = [
        matrix
        for matrix in LIVE.SPOILER.pgl2(game.q)
        if frozenset(
            LIVE.SPOILER.sym2(game.q, matrix, point)
            for point in current_selected
        )
        == previous_selected
    ]
    assert len(transporters) == 1
    transporter = transporters[0]
    point_lookup = LIVE.point_to_cell(game)

    def transported_cell(cell):
        point = LIVE.SPOILER.projective_point(game, index(cell))
        return game.cell_tuple(
            point_lookup[
                LIVE.SPOILER.sym2(game.q, transporter, point)
            ]
        )

    current_flag = {
        "opponent_parent": opponent_cell,
        "reply": reply_cell,
        "replacement_defect": new_cell,
        "retained_defect": retained_cell,
        "old_boundary_reply": old_boundary_reply,
        "killed_boundary_mate": killed_cell,
        "secant_pivot": pivot_cell,
        "common_rank_zero_reply": common_reply,
        "new_boundary_reply": new_boundary_reply,
    }
    mapped_flag = {
        name: transported_cell(cell)
        for name, cell in current_flag.items()
    }
    previous_flag = {
        "opponent_parent": LINEAGE.OPPONENT,
        "reply": LINEAGE.REPLY,
        "replacement_defect": LINEAGE.REPLACEMENT,
        "retained_defect": LINEAGE.RETAINED,
        "old_boundary_reply": LINEAGE.OLD_BOUNDARY_REPLY,
        "killed_boundary_mate": LINEAGE.KILLED_BOUNDARY_MATE,
        "secant_pivot": LINEAGE.SECANT_PIVOT,
        "common_rank_zero_reply": LINEAGE.COMMON_RANK_ZERO_REPLY,
        "new_boundary_reply": LINEAGE.NEW_BOUNDARY_REPLY,
    }
    assert mapped_flag == previous_flag

    deletion_counts = []
    for old_obligation in sorted(defects):
        obligation_child = mask | (1 << old_obligation)
        count = 0
        for candidate_reply in GEOMETRY.bits(
            game.legal_mask(obligation_child)
        ):
            target = obligation_child | (1 << candidate_reply)
            if (
                deletion.defects(target) < defects
                and deletion.survives(target)
            ):
                count += 1
        deletion_counts.append(
            {
                "opponent": list(game.cell_tuple(old_obligation)),
                "strict_deletion_witnesses": count,
            }
        )
    assert [
        row["opponent"]
        for row in deletion_counts
        if row["strict_deletion_witnesses"] == 0
    ] == [list(opponent_cell)]

    support = {retained_cell, opponent_cell}
    old_cells = {
        game.cell_tuple(point) for point in defects
    }
    assert support < old_cells
    return {
        "causal_parent": list(opponent_cell),
        "new_defect": list(new_cell),
        "retained_defect": list(retained_cell),
        "damaged_former_boundaries": damaged_boundaries,
        "rank_zero_replies": rank_zero,
        "common_rank_zero_replies": [
            list(point) for point in sorted(common_replies)
        ],
        "new_boundaries": new_boundaries,
        "projective_incidence": {
            "killing_secant": {
                "line_coefficients": list(killing_line),
                "selected_pivot": list(pivot_cell),
                "opponent_parent": list(opponent_cell),
                "killed_boundary_endpoint": list(killed_cell),
            },
            "replacement_construction": {
                "line_1": [
                    list(killed_cell),
                    list(common_reply),
                ],
                "line_2": [
                    list(old_boundary_reply),
                    list(new_boundary_reply),
                ],
                "intersection": list(new_cell),
            },
        },
        "projective_orbit_comparison": {
            "previous_replacement_state": [
                list(cell) for cell in LINEAGE.T_CELLS
            ],
            "state_transporter_count": len(transporters),
            "unique_pgl2_matrix": list(transporter),
            "current_flag": {
                name: list(cell) for name, cell in current_flag.items()
            },
            "transported_flag": {
                name: list(cell) for name, cell in mapped_flag.items()
            },
            "previous_flag": {
                name: list(cell) for name, cell in previous_flag.items()
            },
            "full_marked_flag_is_transport_copy": True,
        },
        "ancestral_labels": {
            str(retained_cell): list(retained_cell),
            str(new_cell): list(opponent_cell),
        },
        "old_label_count": len(defects),
        "surviving_label_count": len(support),
        "strict_support_drop": len(defects) - len(support),
        "branching": len(witness["new_defects"]),
        "injective": len(support) == 2,
        "full_root_coverage": {
            "strict_deletion_fibres": len(defects) - 1,
            "lineage_transport_fibres": 1,
            "uncovered_fibres": 0,
            "deletion_witness_count_range": [
                min(
                    row["strict_deletion_witnesses"]
                    for row in deletion_counts
                    if row["strict_deletion_witnesses"]
                ),
                max(
                    row["strict_deletion_witnesses"]
                    for row in deletion_counts
                ),
            ],
            "successor_in_F_del": witness["successor_in_F_del"],
        },
        "independent_reference_defects": reference_defects,
        "independent_reference_boundaries": {
            "former": old_boundary,
            "transported": [new_boundary],
        },
    }


def build_certificate(path: Path) -> dict:
    canonical_rows = CONTROL.canonical_p_replies()
    deletion = BASE.DeletionCensus()
    game = deletion.game
    counts = Counter()
    skipped_known = False

    for control_index, canonical_row in enumerate(
        canonical_rows[START_CONTROL:], START_CONTROL
    ):
        history_reply = tuple(canonical_row["reply"])
        control = game.base_mask(CONTROL.T4)
        for cell in (CONTROL.HISTORY_OPPONENT, history_reply):
            control |= 1 << LIVE.cell_index(game, cell)

        for opponent in GEOMETRY.bits(game.legal_mask(control)):
            counts["opponent_fibres"] += 1
            child = control | (1 << opponent)
            for reply in GEOMETRY.bits(game.legal_mask(child)):
                counts["legal_reply_candidates"] += 1
                target = child | (1 << reply)
                if not deletion.census.ranked_survivor(target)["holds"]:
                    continue
                counts["F_d_edges"] += 1
                if deletion.survives(target):
                    counts["F_del_edges"] += 1
                    continue
                edge = (
                    game.cell_tuple(opponent),
                    game.cell_tuple(reply),
                )
                if (
                    control_index == START_CONTROL
                    and edge == KNOWN_EDGE
                    and not skipped_known
                ):
                    skipped_known = True
                    counts["known_replacement_edges_skipped"] += 1
                    continue
                record = target_record(deletion, target)
                if record is None:
                    raise AssertionError("F_d outside F_del without blocker")
                lineage = analyze_lineage(deletion, target, record)
                certificate = {
                    "schema": "c80-q23-next-replacement-ancestry-v1",
                    "source": str(
                        Path(__file__).resolve().relative_to(ROOT)
                    ),
                    "input_sha256": {
                        str(SOURCE.relative_to(ROOT)): sha256(SOURCE),
                        str(LINEAGE_SOURCE.relative_to(ROOT)): sha256(
                            LINEAGE_SOURCE
                        ),
                        str(SWEEP.SOURCE.relative_to(ROOT)): sha256(
                            SWEEP.SOURCE
                        ),
                        **{
                            str(input_path.relative_to(ROOT)): sha256(
                                input_path
                            )
                            for input_path in CONTROL.INPUTS
                        },
                    },
                    "domain": {
                        "q": CONTROL.Q,
                        "start_control_zero_based": START_CONTROL,
                        "known_edge_skipped": [
                            list(KNOWN_EDGE[0]),
                            list(KNOWN_EDGE[1]),
                        ],
                        "control_order": "C54 canonical P-reply order",
                        "edge_order": (
                            "lexicographic opponent then reply cell"
                        ),
                        "stop_condition": (
                            "first later outer target in F_d outside F_del"
                        ),
                    },
                    "search_counts": dict(counts),
                    "next_replacement_target": {
                        "control_index_zero_based": control_index,
                        "history_reply": list(history_reply),
                        "outer_opponent": list(
                            game.cell_tuple(opponent)
                        ),
                        "outer_reply": list(game.cell_tuple(reply)),
                        **record,
                    },
                    "ancestral_charge": lineage,
                    "status": "FOUND",
                }
                assert skipped_known
                write_json(path, certificate)
                return certificate
    raise AssertionError("no later replacement target found")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        if not OUT.is_file():
            raise SystemExit(f"missing certificate: {OUT}")
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            build_certificate(candidate)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return 0
    certificate = build_certificate(OUT)
    print(
        json.dumps(
            {
                "output": str(OUT.relative_to(ROOT)),
                "sha256": sha256(OUT),
                "status": certificate["status"],
                "search_counts": certificate["search_counts"],
                "next_replacement_target": certificate[
                    "next_replacement_target"
                ],
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
