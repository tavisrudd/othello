#!/usr/bin/env python3
"""C80: find the first q23 replacement edge outside the known marked orbit."""
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
SOURCE = ROOT / "rust/scripts/c80_q23_next_replacement_ancestry.py"
OUT = ROOT / "notes/2026-07-26-c80-q23-first-new-replacement-orbit.json"

START_CONTROL = 20
SECOND_KNOWN_OUTER_EDGE = ((12, 19), (19, 14))


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_first_new_replacement_base")
SWEEP = BASE.SWEEP
DELETION = BASE.BASE
CONTROL = BASE.CONTROL
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.LIVE
LINEAGE = BASE.LINEAGE


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def projective_point(game, cell: tuple[int, int]):
    return LIVE.SPOILER.projective_point(
        game, LIVE.cell_index(game, cell)
    )


def marked_key(
    game,
    selected_points,
    opponent_point,
    reply_point,
    new_points,
    retained_points,
):
    return (
        tuple(sorted(selected_points)),
        opponent_point,
        reply_point,
        tuple(sorted(new_points)),
        tuple(sorted(retained_points)),
    )


def known_orbit(game) -> set[tuple]:
    deletion = DELETION.DeletionCensus()
    mask = deletion.mask(LINEAGE.T_CELLS)
    child = mask | (
        1 << LIVE.cell_index(game, LINEAGE.OPPONENT)
    )
    successor = child | (
        1 << LIVE.cell_index(game, LINEAGE.REPLY)
    )
    old_defects = deletion.defects(mask)
    next_defects = deletion.defects(successor)
    new_defects = next_defects - old_defects
    retained_defects = next_defects & old_defects
    selected = LIVE.selected_projective_points(game, mask)
    opponent = projective_point(game, LINEAGE.OPPONENT)
    reply = projective_point(game, LINEAGE.REPLY)
    new_points = {
        LIVE.SPOILER.projective_point(game, point)
        for point in new_defects
    }
    retained_points = {
        LIVE.SPOILER.projective_point(game, point)
        for point in retained_defects
    }
    result = set()
    for matrix in LIVE.SPOILER.pgl2(game.q):
        transform = lambda point: LIVE.SPOILER.sym2(
            game.q, matrix, point
        )
        result.add(
            marked_key(
                game,
                {transform(point) for point in selected},
                transform(opponent),
                transform(reply),
                {transform(point) for point in new_points},
                {transform(point) for point in retained_points},
            )
        )
    return result


def cell_rows(deletion, points) -> list[list[int]]:
    return [
        list(deletion.game.cell_tuple(point))
        for point in sorted(points)
    ]


def replacement_witnesses(deletion, mask: int) -> list[dict]:
    game = deletion.game
    defects = deletion.defects(mask)
    rows = []
    for opponent in sorted(defects):
        child = mask | (1 << opponent)
        fd_rows = []
        deletion_rows = []
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            successor = child | (1 << reply)
            next_defects = deletion.defects(successor)
            next_fd = deletion.census.ranked_survivor(
                successor
            )["holds"]
            if next_fd and len(next_defects) < len(defects):
                fd_rows.append((reply, successor, next_defects))
            if (
                next_defects < defects
                and deletion.survives(successor)
            ):
                deletion_rows.append(reply)
        if deletion_rows:
            continue
        for reply, successor, next_defects in fd_rows:
            new_defects = next_defects - defects
            if not new_defects:
                continue
            half_defects = deletion.defects(child)
            rows.append(
                {
                    "opponent_index": opponent,
                    "reply_index": reply,
                    "successor": successor,
                    "next_defects": next_defects,
                    "opponent": list(game.cell_tuple(opponent)),
                    "reply": list(game.cell_tuple(reply)),
                    "old_defect_rank": len(defects),
                    "after_opponent_defect_rank": len(half_defects),
                    "next_defect_rank": len(next_defects),
                    "created_by_opponent": cell_rows(
                        deletion, half_defects - defects
                    ),
                    "created_by_reply": cell_rows(
                        deletion, next_defects - half_defects
                    ),
                    "new_defects": cell_rows(
                        deletion, new_defects
                    ),
                    "retained_old_defects": cell_rows(
                        deletion, next_defects & defects
                    ),
                    "removed_old_defects": cell_rows(
                        deletion, defects - next_defects
                    ),
                    "successor_in_F_del": deletion.survives(
                        successor
                    ),
                }
            )
    return rows


def analyze_new_type(deletion, mask: int, witness: dict) -> dict:
    game = deletion.game
    index = lambda cell: LIVE.cell_index(game, cell)
    old_defects = deletion.defects(mask)
    opponent_cell = tuple(witness["opponent"])
    reply_cell = tuple(witness["reply"])
    new_cells = [tuple(cell) for cell in witness["new_defects"]]
    assert len(new_cells) == 1
    new_cell = new_cells[0]
    opponent = index(opponent_cell)
    reply = index(reply_cell)
    new_defect = index(new_cell)
    child = mask | (1 << opponent)
    successor = child | (1 << reply)
    half_defects = deletion.defects(child)
    next_defects = deletion.defects(successor)

    assert opponent in old_defects
    assert reply in old_defects
    assert half_defects - old_defects == set()
    assert next_defects - half_defects == {new_defect}
    assert next_defects == {new_defect}

    before_reply_boundary = LINEAGE.primary_boundary_replies(
        deletion, child, new_defect
    )
    assert len(before_reply_boundary) == 1
    boundary = before_reply_boundary[0]
    assert boundary["kind"] == "two_nonconflicting_moves"
    assert len(boundary["remaining_legal"]) == 2
    old_boundary_reply_cell = tuple(boundary["reply"])
    old_boundary_reply = index(old_boundary_reply_cell)
    old_pair = [
        tuple(cell) for cell in boundary["remaining_legal"]
    ]
    assert not (
        game.legal_mask(successor) & (1 << old_boundary_reply)
    )
    assert all(
        game.legal_mask(successor) & (1 << index(cell))
        for cell in old_pair
    )
    causal_pivots = [
        game.cell_tuple(point)
        for point in GEOMETRY.bits(child)
        if LINEAGE.affine_collinear(
            game.cell_tuple(point),
            reply_cell,
            old_boundary_reply_cell,
        )
    ]
    assert causal_pivots == [opponent_cell]

    assert not LINEAGE.primary_boundary_replies(
        deletion, successor, new_defect
    )
    rank_zero = LINEAGE.primary_rank_zero_replies(
        deletion, successor, new_defect
    )
    assert len(rank_zero) == 1
    shell_reply_cell = tuple(rank_zero[0]["reply"])
    assert shell_reply_cell in old_pair
    shell_state = (
        successor
        | (1 << new_defect)
        | (1 << index(shell_reply_cell))
    )
    shell_legal = [
        game.cell_tuple(point)
        for point in GEOMETRY.bits(game.legal_mask(shell_state))
    ]
    assert len(shell_legal) == 3
    shell_rows = {
        str(cell): LINEAGE.primary_boundary_replies(
            deletion, shell_state, index(cell)
        )
        for cell in shell_legal
    }
    assert all(shell_rows.values())
    assert all(
        row["kind"] == "terminal"
        for rows in shell_rows.values()
        for row in rows
    )
    response_edges = {
        tuple(sorted((cell, tuple(row["reply"]))))
        for cell in shell_legal
        for row in shell_rows[str(cell)]
    }
    assert len(response_edges) == 2
    degrees = Counter(
        point for edge in response_edges for point in edge
    )
    hub = next(point for point, degree in degrees.items() if degree == 2)
    leaves = sorted(
        point for point, degree in degrees.items() if degree == 1
    )
    assert len(leaves) == 2
    assert shell_reply_cell in old_pair
    old_other_endpoint = next(
        point for point in old_pair if point != shell_reply_cell
    )
    assert old_other_endpoint in leaves
    shell_conflict_pivots = [
        game.cell_tuple(point)
        for point in GEOMETRY.bits(shell_state)
        if LINEAGE.affine_collinear(
            game.cell_tuple(point), leaves[0], leaves[1]
        )
    ]
    assert shell_conflict_pivots == [shell_reply_cell]

    deletion_counts = []
    for old_obligation in sorted(old_defects):
        obligation_child = mask | (1 << old_obligation)
        count = 0
        for candidate_reply in GEOMETRY.bits(
            game.legal_mask(obligation_child)
        ):
            target = obligation_child | (1 << candidate_reply)
            if (
                deletion.defects(target) < old_defects
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

    reference = LINEAGE.ReferenceGame()
    ref_mask = frozenset(
        tuple(cell) for cell in SWEEP.cells(deletion, mask)
    )
    ref_child = ref_mask | {opponent_cell}
    ref_successor = ref_child | {reply_cell}
    reference_defects = {
        "before": [
            list(point) for point in reference.defects(ref_mask)
        ],
        "after_opponent": [
            list(point) for point in reference.defects(ref_child)
        ],
        "after_reply": [
            list(point) for point in reference.defects(ref_successor)
        ],
    }
    primary_defects = {
        "before": cell_rows(deletion, old_defects),
        "after_opponent": cell_rows(deletion, half_defects),
        "after_reply": cell_rows(deletion, next_defects),
    }
    assert reference_defects == primary_defects
    assert (
        reference.boundary_replies(ref_child, new_cell)
        == before_reply_boundary
    )
    ref_shell = (
        ref_successor | {new_cell} | {shell_reply_cell}
    )
    assert [
        list(point) for point in reference.legal(ref_shell)
    ] == [list(point) for point in shell_legal]
    reference_shell_rows = {
        str(cell): reference.boundary_replies(ref_shell, cell)
        for cell in shell_legal
    }
    assert reference_shell_rows == shell_rows

    return {
        "causal_kind": "created_by_reply",
        "causal_old_label": list(reply_cell),
        "new_defect": list(new_cell),
        "old_label_count": len(old_defects),
        "surviving_label_count": 1,
        "strict_support_drop": len(old_defects) - 1,
        "branching": 1,
        "ancestry_collision": False,
        "before_reply_boundary": before_reply_boundary,
        "killed_certificate_reply": list(old_boundary_reply_cell),
        "boundary_endpoints_survive_reply": [
            list(cell) for cell in old_pair
        ],
        "causal_secant": {
            "opponent_pivot": list(opponent_cell),
            "reply": list(reply_cell),
            "killed_certificate_reply": list(
                old_boundary_reply_cell
            ),
            "line_coefficients": list(
                LINEAGE.projective_line(
                    opponent_cell, reply_cell
                )
            ),
        },
        "rank_zero_response": rank_zero,
        "three_move_shell": {
            "selected_old_boundary_endpoint": list(
                shell_reply_cell
            ),
            "legal_moves": [list(cell) for cell in shell_legal],
            "terminal_response_rows": shell_rows,
            "response_edges": [
                [list(point) for point in edge]
                for edge in sorted(response_edges)
            ],
            "hub": list(hub),
            "conflicting_leaves": [list(point) for point in leaves],
            "leaf_conflict_selected_pivot": list(
                shell_reply_cell
            ),
        },
        "full_root_coverage": {
            "strict_deletion_fibres": len(old_defects) - 1,
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
            "successor_in_F_del": witness[
                "successor_in_F_del"
            ],
        },
        "independent_reference": {
            "defects": reference_defects,
            "former_boundary": before_reply_boundary,
            "three_move_shell_legal": [
                list(point) for point in reference.legal(ref_shell)
            ],
            "three_move_shell_boundary_rows": (
                reference_shell_rows
            ),
        },
    }


def build_certificate(path: Path) -> dict:
    deletion = DELETION.DeletionCensus()
    game = deletion.game
    orbit = known_orbit(game)
    canonical_rows = CONTROL.canonical_p_replies()
    counts = Counter()
    passed_second_known_edge = False

    for control_index, canonical_row in enumerate(
        canonical_rows[START_CONTROL:], START_CONTROL
    ):
        history_reply = tuple(canonical_row["reply"])
        control = game.base_mask(CONTROL.T4)
        for cell in (CONTROL.HISTORY_OPPONENT, history_reply):
            control |= 1 << LIVE.cell_index(game, cell)

        for opponent in GEOMETRY.bits(game.legal_mask(control)):
            counts["outer_opponent_fibres"] += 1
            child = control | (1 << opponent)
            for reply in GEOMETRY.bits(game.legal_mask(child)):
                counts["outer_reply_candidates"] += 1
                outer_edge = (
                    game.cell_tuple(opponent),
                    game.cell_tuple(reply),
                )
                if not passed_second_known_edge:
                    if (
                        control_index == START_CONTROL
                        and outer_edge == SECOND_KNOWN_OUTER_EDGE
                    ):
                        passed_second_known_edge = True
                    continue

                target = child | (1 << reply)
                if not deletion.census.ranked_survivor(target)[
                    "holds"
                ]:
                    continue
                counts["outer_F_d_edges"] += 1
                if deletion.survives(target):
                    counts["outer_F_del_edges"] += 1
                    continue

                for witness in replacement_witnesses(
                    deletion, target
                ):
                    counts["necessary_replacement_witnesses"] += 1
                    selected = LIVE.selected_projective_points(
                        game, target
                    )
                    new_points = {
                        projective_point(game, tuple(cell))
                        for cell in witness["new_defects"]
                    }
                    retained_points = {
                        projective_point(game, tuple(cell))
                        for cell in witness["retained_old_defects"]
                    }
                    key = marked_key(
                        game,
                        selected,
                        LIVE.SPOILER.projective_point(
                            game, witness["opponent_index"]
                        ),
                        LIVE.SPOILER.projective_point(
                            game, witness["reply_index"]
                        ),
                        new_points,
                        retained_points,
                    )
                    if key in orbit:
                        counts["known_orbit_witnesses_skipped"] += 1
                        continue

                    new_type_analysis = analyze_new_type(
                        deletion, target, witness
                    )
                    witness = {
                        key: value
                        for key, value in witness.items()
                        if key
                        not in {
                            "opponent_index",
                            "reply_index",
                            "successor",
                            "next_defects",
                        }
                    }
                    certificate = {
                        "schema": (
                            "c80-q23-first-new-replacement-orbit-v1"
                        ),
                        "source": str(
                            Path(__file__).resolve().relative_to(ROOT)
                        ),
                        "input_sha256": {
                            str(SOURCE.relative_to(ROOT)): sha256(
                                SOURCE
                            ),
                            str(
                                BASE.LINEAGE_SOURCE.relative_to(ROOT)
                            ): sha256(BASE.LINEAGE_SOURCE),
                            str(BASE.SOURCE.relative_to(ROOT)): sha256(
                                BASE.SOURCE
                            ),
                            **{
                                str(path.relative_to(ROOT)): sha256(
                                    path
                                )
                                for path in CONTROL.INPUTS
                            },
                        },
                        "domain": {
                            "q": CONTROL.Q,
                            "start_control_zero_based": START_CONTROL,
                            "resume_after_outer_edge": [
                                list(SECOND_KNOWN_OUTER_EDGE[0]),
                                list(SECOND_KNOWN_OUTER_EDGE[1]),
                            ],
                            "known_marked_orbit_size": len(orbit),
                            "control_order": (
                                "C54 canonical P-reply order"
                            ),
                            "edge_order": (
                                "outer opponent, outer reply, blocking "
                                "obligation, sound reply lexicographic"
                            ),
                            "stop_condition": (
                                "first necessary replacement witness "
                                "outside the first marked PGL2 orbit"
                            ),
                        },
                        "search_counts": dict(counts),
                        "first_new_orbit": {
                            "control_index_zero_based": control_index,
                            "history_reply": list(history_reply),
                            "outer_opponent": list(
                                game.cell_tuple(opponent)
                            ),
                            "outer_reply": list(
                                game.cell_tuple(reply)
                            ),
                            "target_cells": SWEEP.cells(
                                deletion, target
                            ),
                            "target_omega": (
                                deletion.census.kernel.omega(target)
                            ),
                            **witness,
                        },
                        "ancestral_charge": new_type_analysis,
                        "status": "FOUND",
                    }
                    write_json(path, certificate)
                    return certificate
    raise AssertionError("no projectively new replacement witness found")


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
                "first_new_orbit": certificate["first_new_orbit"],
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
