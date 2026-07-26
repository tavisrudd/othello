#!/usr/bin/env python3
"""C80: test causal-half-move ancestry on the next marked q23 orbit."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import subprocess
import sys
import tempfile
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_first_new_replacement_orbit.py"
BACKEND_SOURCE = (
    ROOT / "rust/scripts/c80_q23_replacement_sweep_backend.rs"
)
BACKEND_BIN = (
    ROOT / "rust/target/c80-q23-replacement-sweep-backend"
)
TYPE_II_CERT = (
    ROOT / "notes/2026-07-26-c80-q23-first-new-replacement-orbit.json"
)
OUT = (
    ROOT / "notes/2026-07-26-c80-q23-next-marked-replacement-orbit.json"
)

START_CONTROL = 22
RESUME_OUTER_EDGE = ((14, 13), (15, 2))
RESUME_REPLACEMENT_EDGE = ((16, 18), (20, 17))


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


FIRST = load_module(SOURCE, "c80_q23_next_marked_base")
BASE = FIRST.BASE
SWEEP = FIRST.SWEEP
DELETION = FIRST.DELETION
CONTROL = FIRST.CONTROL
GEOMETRY = FIRST.GEOMETRY
LIVE = FIRST.LIVE
LINEAGE = FIRST.LINEAGE


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


def orbit_from_marked_record(game, record: dict) -> set[tuple]:
    mask = 0
    for cell in record["target_cells"]:
        mask |= 1 << LIVE.cell_index(game, tuple(cell))
    selected = LIVE.selected_projective_points(game, mask)
    opponent = projective_point(game, tuple(record["opponent"]))
    reply = projective_point(game, tuple(record["reply"]))
    new_points = {
        projective_point(game, tuple(cell))
        for cell in record["new_defects"]
    }
    retained_points = {
        projective_point(game, tuple(cell))
        for cell in record["retained_old_defects"]
    }
    result = set()
    for matrix in LIVE.SPOILER.pgl2(game.q):
        transform = lambda point: LIVE.SPOILER.sym2(
            game.q, matrix, point
        )
        result.add(
            FIRST.marked_key(
                game,
                {transform(point) for point in selected},
                transform(opponent),
                transform(reply),
                {transform(point) for point in new_points},
                {transform(point) for point in retained_points},
            )
        )
    return result


def known_orbits(game) -> tuple[set[tuple], set[tuple]]:
    type_i = FIRST.known_orbit(game)
    certificate = json.loads(TYPE_II_CERT.read_text())
    type_ii = orbit_from_marked_record(
        game, certificate["first_new_orbit"]
    )
    assert type_i.isdisjoint(type_ii)
    return type_i, type_ii


def compile_backend(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(
        [
            "rustc",
            "--edition",
            "2021",
            "-O",
            "-C",
            "target-cpu=native",
            str(BACKEND_SOURCE),
            "-o",
            str(path),
        ],
        check=True,
    )


def parse_point_list(value: str) -> list[list[int]]:
    if not value:
        return []
    return [
        [int(coordinate) for coordinate in point.split(",")]
        for point in value.split(";")
    ]


def rust_control(
    backend: Path, history_reply: tuple[int, int]
) -> dict:
    result = subprocess.run(
        [
            str(backend),
            str(history_reply[0]),
            str(history_reply[1]),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    lines = result.stdout.splitlines()
    assert lines and lines[0].startswith("C\t")
    _, opponent_fibres, candidates, fd_edges, fdel_edges = (
        lines[0].split("\t")
    )
    witnesses = []
    for line in lines[1:]:
        fields = line.split("\t")
        assert len(fields) == 13 and fields[0] == "W"
        (
            _,
            outer_opponent,
            outer_reply,
            opponent,
            reply,
            old_rank,
            half_rank,
            next_rank,
            created_by_opponent,
            created_by_reply,
            retained,
            removed,
            successor_fdel,
        ) = fields
        as_cell = lambda point: list(divmod(int(point), CONTROL.Q))
        created_opponent_rows = parse_point_list(
            created_by_opponent
        )
        created_reply_rows = parse_point_list(created_by_reply)
        witnesses.append(
            {
                "outer_opponent": as_cell(outer_opponent),
                "outer_reply": as_cell(outer_reply),
                "opponent": as_cell(opponent),
                "reply": as_cell(reply),
                "old_defect_rank": int(old_rank),
                "after_opponent_defect_rank": int(half_rank),
                "next_defect_rank": int(next_rank),
                "created_by_opponent": created_opponent_rows,
                "created_by_reply": created_reply_rows,
                "new_defects": sorted(
                    created_opponent_rows + created_reply_rows
                ),
                "retained_old_defects": parse_point_list(retained),
                "removed_old_defects": parse_point_list(removed),
                "successor_in_F_del": bool(int(successor_fdel)),
            }
        )
    return {
        "counts": {
            "outer_opponent_fibres": int(opponent_fibres),
            "outer_reply_candidates": int(candidates),
            "outer_F_d_edges": int(fd_edges),
            "outer_F_del_edges": int(fdel_edges),
            "necessary_replacement_witnesses": len(witnesses),
        },
        "witnesses": witnesses,
    }


def cell_rows(deletion, points) -> list[list[int]]:
    return [
        list(deletion.game.cell_tuple(point))
        for point in sorted(points)
    ]


def analyze_causal_ancestry(
    deletion, mask: int, witness: dict
) -> dict:
    game = deletion.game
    index = lambda cell: LIVE.cell_index(game, cell)
    old_defects = deletion.defects(mask)
    opponent_cell = tuple(witness["opponent"])
    reply_cell = tuple(witness["reply"])
    opponent = index(opponent_cell)
    reply = index(reply_cell)
    child = mask | (1 << opponent)
    successor = child | (1 << reply)
    half_defects = deletion.defects(child)
    next_defects = deletion.defects(successor)
    created_by_opponent = half_defects - old_defects
    created_by_reply = next_defects - half_defects
    retained = next_defects & old_defects

    assignments = []
    for creator, creator_cell, created in (
        (opponent, opponent_cell, created_by_opponent),
        (reply, reply_cell, created_by_reply),
    ):
        for new_defect in sorted(created):
            assignments.append(
                {
                    "new_defect": list(game.cell_tuple(new_defect)),
                    "causal_half_move": list(creator_cell),
                    "creator_has_old_label": creator in old_defects,
                }
            )

    transported_labels = [
        creator
        for creator, created in (
            (opponent, created_by_opponent),
            (reply, created_by_reply),
        )
        for _ in created
        if creator in old_defects
    ]
    surviving_labels = set(retained) | set(transported_labels)
    branching = max(
        len(created_by_opponent), len(created_by_reply)
    )
    collision = (
        len(transported_labels) != len(set(transported_labels))
        or bool(set(transported_labels) & retained)
    )
    missing_parent = any(
        not row["creator_has_old_label"] for row in assignments
    )

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

    return {
        "assignments": assignments,
        "created_by_opponent_count": len(created_by_opponent),
        "created_by_reply_count": len(created_by_reply),
        "branching": branching,
        "creator_without_old_label": missing_parent,
        "ancestry_collision": collision,
        "old_label_count": len(old_defects),
        "retained_old_label_count": len(retained),
        "surviving_label_count": len(surviving_labels),
        "strict_support_drop": (
            len(old_defects) - len(surviving_labels)
        ),
        "injective_causal_ancestry": (
            not missing_parent
            and not collision
            and branching <= 1
            and len(surviving_labels) < len(old_defects)
        ),
        "independent_reference_defects": reference_defects,
    }


def analyze_boundary_flag(
    deletion, mask: int, witness: dict
) -> dict:
    game = deletion.game
    index = lambda cell: LIVE.cell_index(game, tuple(cell))
    old_defects = deletion.defects(mask)
    opponent_cell = tuple(witness["opponent"])
    reply_cell = tuple(witness["reply"])
    new_cell = tuple(witness["new_defects"][0])
    opponent = index(opponent_cell)
    reply = index(reply_cell)
    new_defect = index(new_cell)
    child = mask | (1 << opponent)
    successor = child | (1 << reply)

    boundary_rows = LINEAGE.primary_boundary_replies(
        deletion, child, new_defect
    )
    assert len(boundary_rows) == 1
    boundary = boundary_rows[0]
    assert boundary["kind"] == "two_nonconflicting_moves"
    certificate_reply_cell = tuple(boundary["reply"])
    certificate_reply = index(certificate_reply_cell)
    endpoints = [
        tuple(cell) for cell in boundary["remaining_legal"]
    ]
    assert len(endpoints) == 2
    assert not game.legal_mask(successor) & (
        1 << certificate_reply
    )
    assert all(
        game.legal_mask(successor) & (1 << index(endpoint))
        for endpoint in endpoints
    )
    pivots = [
        game.cell_tuple(point)
        for point in GEOMETRY.bits(child)
        if LINEAGE.affine_collinear(
            game.cell_tuple(point),
            reply_cell,
            certificate_reply_cell,
        )
    ]
    assert len(pivots) == 1

    rank_zero = LINEAGE.primary_rank_zero_replies(
        deletion, successor, new_defect
    )
    assert len(rank_zero) == 1
    shell_reply_cell = tuple(rank_zero[0]["reply"])
    assert shell_reply_cell in endpoints
    shell = (
        successor
        | (1 << new_defect)
        | (1 << index(shell_reply_cell))
    )
    shell_legal = [
        game.cell_tuple(point)
        for point in GEOMETRY.bits(game.legal_mask(shell))
    ]
    assert len(shell_legal) == 3
    shell_rows = {
        str(cell): LINEAGE.primary_boundary_replies(
            deletion, shell, index(cell)
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
    assert sorted(degrees.values()) == [1, 1, 2]

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
        deletion_counts.append((old_obligation, count))
    assert [
        point for point, count in deletion_counts if count == 0
    ] == [opponent]

    reference = LINEAGE.ReferenceGame()
    ref_child = frozenset(
        tuple(cell) for cell in SWEEP.cells(deletion, child)
    )
    assert (
        reference.boundary_replies(ref_child, new_cell)
        == boundary_rows
    )
    ref_shell = frozenset(
        tuple(cell) for cell in SWEEP.cells(deletion, shell)
    )
    assert [
        list(point) for point in reference.legal(ref_shell)
    ] == [list(point) for point in shell_legal]

    return {
        "failure_kind": "certificate_reply_deletion",
        "former_boundary": boundary,
        "saturating_secant": {
            "causal_reply": list(reply_cell),
            "certificate_reply": list(certificate_reply_cell),
            "preexisting_pivot": list(pivots[0]),
            "pivot_is_current_opponent": pivots[0] == opponent_cell,
            "line_coefficients": list(
                LINEAGE.projective_line(
                    reply_cell, certificate_reply_cell
                )
            ),
        },
        "rank_zero_response": rank_zero,
        "terminal_response_shell": {
            "legal_moves": [list(cell) for cell in shell_legal],
            "response_edges": [
                [list(point) for point in edge]
                for edge in sorted(response_edges)
            ],
            "degree_sequence": sorted(degrees.values()),
        },
        "full_root_coverage": {
            "strict_deletion_fibres": len(old_defects) - 1,
            "lineage_transport_fibres": 1,
            "uncovered_fibres": 0,
            "successor_in_F_del": witness[
                "successor_in_F_del"
            ],
        },
        "independent_reference_boundary_and_shell": True,
    }


def scan_control(control_index: int) -> dict:
    deletion = DELETION.DeletionCensus()
    game = deletion.game
    type_i, type_ii = known_orbits(game)
    known = type_i | type_ii
    canonical_rows = CONTROL.canonical_p_replies()
    canonical_row = canonical_rows[control_index]
    counts = Counter()
    resumed = control_index != START_CONTROL
    history_reply = tuple(canonical_row["reply"])
    control = game.base_mask(CONTROL.T4)
    for cell in (CONTROL.HISTORY_OPPONENT, history_reply):
        control |= 1 << LIVE.cell_index(game, cell)

    for opponent in GEOMETRY.bits(game.legal_mask(control)):
        counts["outer_opponent_fibres"] += 1
        child = control | (1 << opponent)
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            counts["outer_reply_candidates"] += 1
            target = child | (1 << reply)
            if not deletion.census.ranked_survivor(target)["holds"]:
                continue
            counts["outer_F_d_edges"] += 1
            if deletion.survives(target):
                counts["outer_F_del_edges"] += 1
                continue

            for witness in FIRST.replacement_witnesses(
                deletion, target
            ):
                replacement_edge = (
                    tuple(witness["opponent"]),
                    tuple(witness["reply"]),
                )
                outer_edge = (
                    game.cell_tuple(opponent),
                    game.cell_tuple(reply),
                )
                if not resumed:
                    if (
                        outer_edge == RESUME_OUTER_EDGE
                        and replacement_edge
                        == RESUME_REPLACEMENT_EDGE
                    ):
                        resumed = True
                    continue

                counts["necessary_replacement_witnesses"] += 1
                selected = LIVE.selected_projective_points(game, target)
                new_points = {
                    projective_point(game, tuple(cell))
                    for cell in witness["new_defects"]
                }
                retained_points = {
                    projective_point(game, tuple(cell))
                    for cell in witness["retained_old_defects"]
                }
                key = FIRST.marked_key(
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
                if key in known:
                    counts["known_orbit_witnesses_skipped"] += 1
                    if key in type_i:
                        counts["type_i_witnesses_skipped"] += 1
                    if key in type_ii:
                        counts["type_ii_witnesses_skipped"] += 1
                    continue

                cleaned_witness = {
                    name: value
                    for name, value in witness.items()
                    if name
                    not in {
                        "opponent_index",
                        "reply_index",
                        "successor",
                        "next_defects",
                    }
                }
                return {
                    "status": "FOUND",
                    "counts": dict(counts),
                    "next_new_orbit": {
                        "control_index_zero_based": control_index,
                        "history_reply": list(history_reply),
                        "outer_opponent": list(
                            game.cell_tuple(opponent)
                        ),
                        "outer_reply": list(game.cell_tuple(reply)),
                        "target_cells": SWEEP.cells(deletion, target),
                        "target_omega": (
                            deletion.census.kernel.omega(target)
                        ),
                        **cleaned_witness,
                    },
                    "causal_ancestry": analyze_causal_ancestry(
                        deletion, target, witness
                    ),
                }

    assert resumed
    return {
        "status": "CONTROL_EXHAUSTED",
        "counts": dict(counts),
        "control_index_zero_based": control_index,
        "history_reply": list(history_reply),
    }


def build_certificate(
    path: Path, backend: Path = BACKEND_BIN
) -> dict:
    compile_backend(backend)
    deletion = DELETION.DeletionCensus()
    game = deletion.game
    type_i, type_ii = known_orbits(game)
    known = type_i | type_ii
    canonical_rows = CONTROL.canonical_p_replies()
    totals = Counter()
    completed = []
    for control_index in range(START_CONTROL, len(canonical_rows)):
        history_reply = tuple(canonical_rows[control_index]["reply"])
        result = rust_control(backend, history_reply)
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
            key = FIRST.marked_key(
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
            if key in known:
                totals["known_orbit_witnesses_skipped"] += 1
                if key in type_i:
                    totals["type_i_witnesses_skipped"] += 1
                if key in type_ii:
                    totals["type_ii_witnesses_skipped"] += 1
                continue

            primary_rows = FIRST.replacement_witnesses(
                deletion, target
            )
            primary = next(
                row
                for row in primary_rows
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
                    assert sorted(primary[field]) == sorted(
                        witness[field]
                    )
                else:
                    assert primary[field] == witness[field]
            analysis = analyze_causal_ancestry(
                deletion, target, primary
            )
            boundary_flag = analyze_boundary_flag(
                deletion, target, primary
            )
            certificate = {
                "schema": (
                    "c80-q23-next-marked-replacement-orbit-v2"
                ),
                "source": str(
                    Path(__file__).resolve().relative_to(ROOT)
                ),
                "input_sha256": {
                    str(SOURCE.relative_to(ROOT)): sha256(SOURCE),
                    str(BACKEND_SOURCE.relative_to(ROOT)): sha256(
                        BACKEND_SOURCE
                    ),
                    str(TYPE_II_CERT.relative_to(ROOT)): sha256(
                        TYPE_II_CERT
                    ),
                    str(
                        BASE.LINEAGE_SOURCE.relative_to(ROOT)
                    ): sha256(BASE.LINEAGE_SOURCE),
                    str(BASE.SOURCE.relative_to(ROOT)): sha256(
                        BASE.SOURCE
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
                    "known_marked_orbit_sizes": {
                        "type_i": len(type_i),
                        "type_ii": len(type_ii),
                        "union": len(known),
                    },
                    "control_order": "C54 canonical P-reply order",
                    "edge_order": (
                        "outer opponent, outer reply, blocking "
                        "obligation, sound reply lexicographic"
                    ),
                    "stop_condition": (
                        "first necessary replacement witness "
                        "outside the first two marked PGL2 orbits"
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
                "causal_ancestry": analysis,
                "bounded_causality_flag": boundary_flag,
                "independent_replay": {
                    "rust_python_witness_fields_agree": True,
                    "python_affine_determinant_defects_agree": True,
                },
                "status": "FOUND",
            }
            write_json(path, certificate)
            return certificate
        completed.append(
            {
                "control_index_zero_based": control_index,
                "history_reply": list(history_reply),
                "counts": result["counts"],
            }
        )
    raise AssertionError("no new marked replacement orbit found")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--worker-control", type=int)
    parser.add_argument("--worker-output", type=Path)
    args = parser.parse_args()
    if args.worker_control is not None:
        if args.worker_output is None:
            raise SystemExit("--worker-output is required")
        write_json(
            args.worker_output, scan_control(args.worker_control)
        )
        return 0
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
    print(
        json.dumps(
            {
                "output": str(OUT.relative_to(ROOT)),
                "sha256": sha256(OUT),
                "status": certificate["status"],
                "search_counts": certificate["search_counts"],
                "next_new_orbit": certificate["next_new_orbit"],
                "causal_ancestry": certificate["causal_ancestry"],
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
