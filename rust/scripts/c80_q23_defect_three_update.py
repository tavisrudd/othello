#!/usr/bin/env python3
"""C80: classify the q23 defect-three locus and certify its rank update."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from collections import Counter
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_small_shell_falsifier.py"
OUT = ROOT / "notes/2026-07-25-c80-q23-defect-three-update.json"

Q = 23
T4 = (1, 2, 3, 4)
HISTORY = ((0, 0), (5, 2), (9, 16), (17, 18))


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_defect_update_base")
SHELL = BASE.BASE
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.LIVE
SPOILER = SHELL.SPOILER
INPUTS = tuple(sorted(set((*BASE.INPUTS, SOURCE))))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class DefectUpdate:
    def __init__(self):
        self.shell = SHELL.IncidenceShell(Q)
        self.kernel = self.shell.kernel
        self.game = self.shell.game

    @lru_cache(maxsize=None)
    def defect(self, mask: int) -> tuple[int, ...]:
        """Opponents with no immediate reply into B_small."""
        result = []
        for opponent in GEOMETRY.bits(self.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            if not any(
                self.shell.small_boundary(child | (1 << reply)) is not None
                for reply in GEOMETRY.bits(self.game.legal_mask(child))
            ):
                result.append(opponent)
        return tuple(result)

    def target(self) -> int:
        mask = self.game.base_mask(T4)
        for cell in HISTORY:
            mask |= 1 << LIVE.cell_index(self.game, cell)
        return mask

    def active_blocks(self, mask: int) -> list[dict]:
        legal = self.game.legal_mask(mask)
        defects = set(self.defect(mask))
        blocks = []
        for line_mask, fixed_load in self.kernel.lines:
            support = legal & line_mask
            if (
                fixed_load + (mask & line_mask).bit_count() == 0
                and support.bit_count() > 2
            ):
                cells = tuple(GEOMETRY.bits(support))
                blocks.append(
                    {
                        "size": len(cells),
                        "points": [
                            list(self.game.cell_tuple(point))
                            for point in cells
                        ],
                        "defect_points": [
                            list(self.game.cell_tuple(point))
                            for point in cells if point in defects
                        ],
                    }
                )
        return sorted(
            blocks,
            key=lambda row: (row["size"], row["points"]),
        )

    def response_data(self, mask: int) -> dict:
        defects = set(self.defect(mask))
        rank = len(defects)
        rows = []
        for opponent in GEOMETRY.bits(self.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            replies = []
            if opponent in defects:
                candidates = sorted(defects - {opponent})
                for reply in candidates:
                    if not (self.game.legal_mask(child) & (1 << reply)):
                        continue
                    target = child | (1 << reply)
                    next_rank = len(self.defect(target))
                    if next_rank < rank:
                        replies.append(
                            {
                                "reply": list(self.game.cell_tuple(reply)),
                                "kind": "defect_exchange",
                                "next_defect_rank": next_rank,
                                "target_omega": self.kernel.omega(target),
                                "target_legal_moves": self.game.legal_mask(
                                    target
                                ).bit_count(),
                            }
                        )
            else:
                for reply in GEOMETRY.bits(self.game.legal_mask(child)):
                    target = child | (1 << reply)
                    kind = self.shell.small_boundary(target)
                    if kind is not None:
                        replies.append(
                            {
                                "reply": list(self.game.cell_tuple(reply)),
                                "kind": kind,
                                "next_defect_rank": len(
                                    self.defect(target)
                                ),
                                "target_omega": self.kernel.omega(target),
                                "target_legal_moves": self.game.legal_mask(
                                    target
                                ).bit_count(),
                            }
                        )
            assert replies
            rows.append(
                {
                    "opponent": list(self.game.cell_tuple(opponent)),
                    "is_defect": opponent in defects,
                    "replies": replies,
                }
            )
        kinds = Counter(
            reply["kind"]
            for row in rows
            for reply in row["replies"]
        )
        degrees = Counter(len(row["replies"]) for row in rows)
        next_ranks = Counter(
            reply["next_defect_rank"]
            for row in rows
            for reply in row["replies"]
        )
        omegas = Counter(
            reply["target_omega"]
            for row in rows
            for reply in row["replies"]
        )
        return {
            "opponents": len(rows),
            "oriented_response_edges": sum(
                len(row["replies"]) for row in rows
            ),
            "response_kind_histogram": dict(kinds),
            "response_degree_histogram": [
                {"degree": degree, "opponents": count}
                for degree, count in sorted(degrees.items())
            ],
            "next_defect_rank_histogram": [
                {"next_defect_rank": value, "oriented_edges": count}
                for value, count in sorted(next_ranks.items())
            ],
            "target_omega_histogram": [
                {"target_omega": value, "oriented_edges": count}
                for value, count in sorted(omegas.items())
            ],
            "rows": rows,
        }


def transported_cell(update: DefectUpdate, matrix, cell: tuple[int, int]):
    game = update.game
    lookup = LIVE.point_to_cell(game)
    index = LIVE.cell_index(game, cell)
    return game.cell_tuple(
        lookup[
            SPOILER.sym2(
                Q,
                matrix,
                SPOILER.projective_point(game, index),
            )
        ]
    )


def build_certificate() -> dict:
    update = DefectUpdate()
    game = update.game
    target = update.target()
    defects = update.defect(target)
    defect_cells = [list(game.cell_tuple(point)) for point in defects]
    assert defect_cells == [[7, 13], [15, 22], [19, 4]]
    assert all(
        game.legal_mask(target | (1 << first)) & (1 << second)
        for i, first in enumerate(defects)
        for second in defects[i + 1 :]
    )
    assert not game.collinear(
        *[SPOILER.projective_point(game, point) for point in defects]
    )

    active_blocks = update.active_blocks(target)
    assert Counter(row["size"] for row in active_blocks) == {
        3: 10,
        4: 2,
        6: 1,
    }
    assert sum(max(0, row["size"] - 2) for row in active_blocks) == 18
    response = update.response_data(target)
    assert response["opponents"] == 24
    assert response["oriented_response_edges"] == 50
    assert response["response_kind_histogram"] == {
        "terminal": 8,
        "two_nonconflicting_moves": 36,
        "defect_exchange": 6,
    }
    assert response["next_defect_rank_histogram"] == [
        {"next_defect_rank": 0, "oriented_edges": 50}
    ]
    assert response["target_omega_histogram"] == [
        {"target_omega": 0, "oriented_edges": 48},
        {"target_omega": 2, "oriented_edges": 2},
    ]
    assert all(
        reply["next_defect_rank"] == 0
        and reply["target_omega"] < 18
        for row in response["rows"]
        for reply in row["replies"]
    )

    stabilizer = LIVE.stabilizer_matrices(game, target)
    assert len(stabilizer) == 2
    defect_actions = []
    for matrix in stabilizer:
        defect_actions.append(
            [
                list(
                    transported_cell(
                        update, matrix, game.cell_tuple(point)
                    )
                )
                for point in defects
            ]
        )
    assert defect_actions == [
        [[7, 13], [15, 22], [19, 4]],
        [[15, 22], [7, 13], [19, 4]],
    ]

    return {
        "schema": "c80-q23-defect-three-update-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "target": {
            "q": Q,
            "root_t4": list(T4),
            "history": [list(cell) for cell in HISTORY],
            "legal_moves": game.legal_mask(target).bit_count(),
            "omega": update.kernel.omega(target),
            "stabilizer_order": len(stabilizer),
        },
        "defect_locus": {
            "definition": (
                "Def(S)={x in Legal(S): no legal y makes "
                "S+x+y satisfy B_small}"
            ),
            "rank": len(defects),
            "points": defect_cells,
            "pairwise_mutually_legal": True,
            "noncollinear": True,
            "stabilizer_actions": defect_actions,
            "stabilizer_orbit_sizes": [2, 1],
            "active_zero_load_blocks": active_blocks,
        },
        "rank_update": {
            "nondefect_rule": (
                "reply directly into terminal or two-nonconflicting-move "
                "B_small"
            ),
            "defect_rule": (
                "reply to a defect point with either other defect point"
            ),
            "rank_change_on_every_selected_edge": "3 -> 0",
            "soundness": (
                "nondefect replies land in B_small; defect exchanges land "
                "at Def-rank zero, hence in Shell_small"
            ),
            **response,
        },
        "verdict": {
            "defect_three_classification": "PASS",
            "direct_rank_carrying_update": "PASS",
            "opponent_complete": "24/24",
            "selected_edge_soundness": "PROVED",
            "uniform_update_law": "OPEN",
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
