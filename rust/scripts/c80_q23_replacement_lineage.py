#!/usr/bin/env python3
"""C80: extract the first q23 replacement-obligation lineage and charge."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import sys
import tempfile
from itertools import combinations
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_obligation_deletion_sweep.py"
SOURCE_CERT = ROOT / "notes/2026-07-26-c80-q23-obligation-deletion-sweep.json"
OUT = ROOT / "notes/2026-07-26-c80-q23-replacement-lineage.json"

Q = 23
T_CELLS = (
    (0, 0),
    (1, 1),
    (2, 12),
    (3, 8),
    (4, 6),
    (7, 5),
    (8, 4),
    (13, 7),
)
OPPONENT = (12, 15)
REPLY = (22, 14)
REPLACEMENT = (21, 17)
RETAINED = (17, 19)
OLD_BOUNDARY_REPLY = (5, 13)
KILLED_BOUNDARY_MATE = (22, 9)
SECANT_PIVOT = (4, 6)
COMMON_RANK_ZERO_REPLY = (10, 13)
NEW_BOUNDARY_REPLY = (11, 3)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


SWEEP = load_module(SOURCE, "c80_q23_replacement_lineage_base")
BASE = SWEEP.BASE
GEOMETRY = SWEEP.GEOMETRY
LIVE = SWEEP.LIVE


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def affine_collinear(
    left: tuple[int, int],
    middle: tuple[int, int],
    right: tuple[int, int],
) -> bool:
    return (
        (middle[0] - left[0]) * (right[1] - left[1])
        - (middle[1] - left[1]) * (right[0] - left[0])
    ) % Q == 0


def projective_line(
    left: tuple[int, int], right: tuple[int, int]
) -> tuple[int, int, int]:
    """Normalized homogeneous coefficients for the line through two cells."""
    raw = (
        (left[1] - right[1]) % Q,
        (right[0] - left[0]) % Q,
        (left[0] * right[1] - left[1] * right[0]) % Q,
    )
    first = next(value for value in raw if value)
    scale = pow(first, -1, Q)
    return tuple(value * scale % Q for value in raw)


def line_contains(
    line: tuple[int, int, int], point: tuple[int, int]
) -> bool:
    return (
        line[0] * point[0] + line[1] * point[1] + line[2]
    ) % Q == 0


def primary_cells(deletion, points) -> list[list[int]]:
    return [
        list(deletion.game.cell_tuple(point))
        for point in sorted(points)
    ]


def primary_boundary_replies(deletion, mask: int, opponent: int) -> list[dict]:
    game = deletion.game
    child = mask | (1 << opponent)
    rows = []
    for reply in GEOMETRY.bits(game.legal_mask(child)):
        target = child | (1 << reply)
        kind = deletion.census.update.shell.small_boundary(target)
        if kind is None:
            continue
        rows.append(
            {
                "reply": list(game.cell_tuple(reply)),
                "kind": kind,
                "remaining_legal": [
                    list(game.cell_tuple(point))
                    for point in GEOMETRY.bits(game.legal_mask(target))
                ],
            }
        )
    return rows


def primary_rank_zero_replies(deletion, mask: int, opponent: int) -> list[dict]:
    game = deletion.game
    child = mask | (1 << opponent)
    rows = []
    for reply in GEOMETRY.bits(game.legal_mask(child)):
        target = child | (1 << reply)
        next_defects = deletion.defects(target)
        if next_defects:
            continue
        rows.append(
            {
                "reply": list(game.cell_tuple(reply)),
                "omega": deletion.census.kernel.omega(target),
                "remaining_legal": [
                    list(game.cell_tuple(point))
                    for point in GEOMETRY.bits(game.legal_mask(target))
                ],
            }
        )
    return rows


class ReferenceGame:
    """Independent direct affine-determinant replay of the local certificate."""

    def __init__(self):
        self.board = tuple((x, y) for x in range(Q) for y in range(Q))
        self._legal_cache: dict[
            frozenset[tuple[int, int]], tuple[tuple[int, int], ...]
        ] = {}
        self._omega_cache: dict[frozenset[tuple[int, int]], int] = {}
        self._boundary_cache: dict[
            frozenset[tuple[int, int]], str | None
        ] = {}
        self._defect_cache: dict[
            frozenset[tuple[int, int]], tuple[tuple[int, int], ...]
        ] = {}

    def legal_after(
        self,
        state: frozenset[tuple[int, int]],
        point: tuple[int, int],
    ) -> bool:
        if point in state:
            return False
        if any(
            point[0] == selected[0] or point[1] == selected[1]
            for selected in state
        ):
            return False
        return not any(
            affine_collinear(left, right, point)
            for left, right in combinations(state, 2)
        )

    def legal(
        self, state: frozenset[tuple[int, int]]
    ) -> tuple[tuple[int, int], ...]:
        cached = self._legal_cache.get(state)
        if cached is None:
            cached = tuple(
                point for point in self.board
                if self.legal_after(state, point)
            )
            self._legal_cache[state] = cached
        return cached

    def omega(self, state: frozenset[tuple[int, int]]) -> int:
        cached = self._omega_cache.get(state)
        if cached is not None:
            return cached
        legal = self.legal(state)
        total = 0
        for slope in range(1, Q):
            selected_intercepts = {
                (y - slope * x) % Q for x, y in state
            }
            legal_counts = [0] * Q
            for x, y in legal:
                legal_counts[(y - slope * x) % Q] += 1
            total += sum(
                max(0, count - 2)
                for intercept, count in enumerate(legal_counts)
                if intercept not in selected_intercepts
            )
        self._omega_cache[state] = total
        return total

    def small_boundary(
        self, state: frozenset[tuple[int, int]]
    ) -> str | None:
        if state in self._boundary_cache:
            return self._boundary_cache[state]
        result = None
        if self.omega(state) == 0:
            legal = self.legal(state)
            if not legal:
                result = "terminal"
            elif (
                len(legal) == 2
                and self.legal_after(state | {legal[0]}, legal[1])
            ):
                result = "two_nonconflicting_moves"
        self._boundary_cache[state] = result
        return result

    def boundary_replies(
        self,
        state: frozenset[tuple[int, int]],
        opponent: tuple[int, int],
    ) -> list[dict]:
        child = state | {opponent}
        rows = []
        for reply in self.legal(child):
            target = child | {reply}
            kind = self.small_boundary(target)
            if kind is not None:
                rows.append(
                    {
                        "reply": list(reply),
                        "kind": kind,
                        "remaining_legal": [
                            list(point) for point in self.legal(target)
                        ],
                    }
                )
        return rows

    def defects(
        self, state: frozenset[tuple[int, int]]
    ) -> tuple[tuple[int, int], ...]:
        cached = self._defect_cache.get(state)
        if cached is None:
            cached = tuple(
                opponent for opponent in self.legal(state)
                if not self.boundary_replies(state, opponent)
            )
            self._defect_cache[state] = cached
        return cached


def build_certificate(path: Path) -> dict:
    deletion = BASE.DeletionCensus()
    game = deletion.game
    index = lambda cell: LIVE.cell_index(game, cell)
    mask = deletion.mask(T_CELLS)
    after_opponent = mask | (1 << index(OPPONENT))
    successor = after_opponent | (1 << index(REPLY))

    old_defects = deletion.defects(mask)
    half_defects = deletion.defects(after_opponent)
    next_defects = deletion.defects(successor)
    replacement_index = index(REPLACEMENT)
    retained_index = index(RETAINED)
    opponent_index = index(OPPONENT)
    reply_index = index(REPLY)

    assert len(old_defects) == 27
    assert old_defects - half_defects
    assert half_defects - old_defects == {replacement_index}
    assert next_defects - half_defects == set()
    assert next_defects == {retained_index, replacement_index}
    assert opponent_index in old_defects
    assert reply_index in old_defects

    old_boundary = primary_boundary_replies(
        deletion, mask, replacement_index
    )
    assert old_boundary == [
        {
            "reply": list(OLD_BOUNDARY_REPLY),
            "kind": "two_nonconflicting_moves",
            "remaining_legal": [
                list(RETAINED), list(KILLED_BOUNDARY_MATE)
            ],
        }
    ]
    after_x_z_r = (
        after_opponent
        | (1 << replacement_index)
        | (1 << index(OLD_BOUNDARY_REPLY))
    )
    stranded_legal = [
        list(game.cell_tuple(point))
        for point in GEOMETRY.bits(game.legal_mask(after_x_z_r))
    ]
    assert stranded_legal == [list(RETAINED)]
    assert deletion.census.update.shell.small_boundary(after_x_z_r) is None

    killing_line = projective_line(OPPONENT, KILLED_BOUNDARY_MATE)
    assert line_contains(killing_line, SECANT_PIVOT)
    assert [
        cell for cell in T_CELLS if line_contains(killing_line, cell)
    ] == [SECANT_PIVOT]

    deletion_fibres = []
    for old_obligation in sorted(old_defects):
        child = mask | (1 << old_obligation)
        witness_count = 0
        for candidate_reply in GEOMETRY.bits(game.legal_mask(child)):
            target = child | (1 << candidate_reply)
            if not deletion.defects(target) < old_defects:
                continue
            if deletion.survives(target):
                witness_count += 1
        deletion_fibres.append(
            {
                "opponent": list(game.cell_tuple(old_obligation)),
                "strict_deletion_witnesses": witness_count,
            }
        )
    assert [
        row["opponent"]
        for row in deletion_fibres
        if row["strict_deletion_witnesses"] == 0
    ] == [list(OPPONENT)]
    assert deletion.survives(successor)

    common_rows = {}
    for obligation in (RETAINED, REPLACEMENT):
        rows = primary_rank_zero_replies(
            deletion, successor, index(obligation)
        )
        assert [row["reply"] for row in rows] == [
            list(COMMON_RANK_ZERO_REPLY)
        ]
        common_rows[str(obligation)] = rows

    new_boundary = primary_boundary_replies(
        deletion, successor, index(COMMON_RANK_ZERO_REPLY)
    )
    assert new_boundary == [
        {
            "reply": list(NEW_BOUNDARY_REPLY),
            "kind": "two_nonconflicting_moves",
            "remaining_legal": [list(RETAINED), list(REPLACEMENT)],
        }
    ]

    named = {
        "secant_pivot": SECANT_PIVOT,
        "opponent_parent": OPPONENT,
        "reply": REPLY,
        "old_boundary_reply": OLD_BOUNDARY_REPLY,
        "retained_defect": RETAINED,
        "killed_boundary_mate": KILLED_BOUNDARY_MATE,
        "replacement_defect": REPLACEMENT,
        "common_rank_zero_reply": COMMON_RANK_ZERO_REPLY,
        "new_boundary_reply": NEW_BOUNDARY_REPLY,
    }
    collinear_triples = [
        list(names)
        for names in combinations(named, 3)
        if affine_collinear(*(named[name] for name in names))
    ]
    assert collinear_triples == [
        ["secant_pivot", "opponent_parent", "killed_boundary_mate"],
        [
            "old_boundary_reply",
            "replacement_defect",
            "new_boundary_reply",
        ],
        [
            "killed_boundary_mate",
            "replacement_defect",
            "common_rank_zero_reply",
        ],
    ]
    assert affine_collinear(
        OLD_BOUNDARY_REPLY, REPLACEMENT, NEW_BOUNDARY_REPLY
    )
    assert affine_collinear(
        KILLED_BOUNDARY_MATE, REPLACEMENT, COMMON_RANK_ZERO_REPLY
    )

    # Independent direct determinant replay.
    reference = ReferenceGame()
    ref_mask = frozenset(T_CELLS)
    ref_half = ref_mask | {OPPONENT}
    ref_successor = ref_half | {REPLY}
    reference_defects = {
        "before": [list(point) for point in reference.defects(ref_mask)],
        "after_opponent": [
            list(point) for point in reference.defects(ref_half)
        ],
        "after_reply": [
            list(point) for point in reference.defects(ref_successor)
        ],
    }
    primary_defects = {
        "before": primary_cells(deletion, old_defects),
        "after_opponent": primary_cells(deletion, half_defects),
        "after_reply": primary_cells(deletion, next_defects),
    }
    assert reference_defects == primary_defects
    assert reference.boundary_replies(ref_mask, REPLACEMENT) == old_boundary
    assert reference.boundary_replies(
        ref_successor, COMMON_RANK_ZERO_REPLY
    ) == new_boundary

    transported_labels = {
        str(RETAINED): list(RETAINED),
        str(REPLACEMENT): list(OPPONENT),
    }
    surviving_label_support = {RETAINED, OPPONENT}
    assert surviving_label_support < {
        game.cell_tuple(point) for point in old_defects
    }

    certificate = {
        "schema": "c80-q23-replacement-lineage-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(SOURCE.relative_to(ROOT)): sha256(SOURCE),
            str(SOURCE_CERT.relative_to(ROOT)): sha256(SOURCE_CERT),
        },
        "domain": {
            "q": Q,
            "state": [list(cell) for cell in T_CELLS],
            "marked_exchange": {
                "opponent": list(OPPONENT),
                "reply": list(REPLY),
            },
            "scope": "first exact F_d outside F_del edge only",
        },
        "defect_evolution": {
            "primary": primary_defects,
            "independent_reference": reference_defects,
            "ranks": [27, 7, 2],
            "created_by_opponent": [list(REPLACEMENT)],
            "created_by_reply": [],
            "removed_by_opponent": len(old_defects - half_defects),
            "removed_by_reply": len(half_defects - next_defects),
        },
        "causal_lineage": {
            "parent_old_defect": list(OPPONENT),
            "descendant_new_defect": list(REPLACEMENT),
            "unique_former_boundary_reply": old_boundary,
            "killed_boundary_mate": list(KILLED_BOUNDARY_MATE),
            "retained_boundary_mate": list(RETAINED),
            "killing_secant": {
                "line_coefficients": list(killing_line),
                "old_selected_pivot": list(SECANT_PIVOT),
            },
            "after_parent_move_old_certificate_has_legal_locus": (
                stranded_legal
            ),
        },
        "boundary_endpoint_transport": {
            "before_pair": [list(RETAINED), list(KILLED_BOUNDARY_MATE)],
            "after_pair": [list(RETAINED), list(REPLACEMENT)],
            "common_endpoint": list(RETAINED),
            "replaced_endpoint": {
                "from": list(KILLED_BOUNDARY_MATE),
                "to": list(REPLACEMENT),
            },
            "common_rank_zero_reply": list(COMMON_RANK_ZERO_REPLY),
            "new_boundary_reply": new_boundary,
            "rank_zero_rows": common_rows,
        },
        "projective_incidence": {
            "named_points": {
                name: list(point) for name, point in named.items()
            },
            "collinear_triples": collinear_triples,
            "replacement_construction": {
                "line_1": [
                    "killed_boundary_mate",
                    "common_rank_zero_reply",
                ],
                "line_2": [
                    "old_boundary_reply",
                    "new_boundary_reply",
                ],
                "intersection": "replacement_defect",
            },
        },
        "ancestral_charge": {
            "rule": (
                "retain labels of retained defects; transport the marked "
                "opponent label to the unique causally created defect"
            ),
            "current_defect_to_old_label": transported_labels,
            "old_label_count": len(old_defects),
            "surviving_label_count": len(surviving_label_support),
            "strict_label_support_drop": (
                len(old_defects) - len(surviving_label_support)
            ),
            "branching_at_this_edge": 1,
            "full_root_coverage": {
                "strict_deletion_fibres": len(old_defects) - 1,
                "lineage_transport_fibres": 1,
                "uncovered_fibres": 0,
                "deletion_witness_count_range": [
                    min(
                        row["strict_deletion_witnesses"]
                        for row in deletion_fibres
                        if row["strict_deletion_witnesses"]
                    ),
                    max(
                        row["strict_deletion_witnesses"]
                        for row in deletion_fibres
                    ),
                ],
                "successor_in_F_del": True,
            },
        },
        "trust": {
            "primary": "existing normalized q23 bitmask incidence engine",
            "independent": (
                "direct affine determinant engine with independent legal, "
                "Omega, B_small, and Def implementations"
            ),
        },
        "status": "PASS",
    }
    write_json(path, certificate)
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
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
