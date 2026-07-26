#!/usr/bin/env python3
"""C80: certify the first q23 F_d\\R0 edge by defect-locus deletion."""
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
SOURCE = ROOT / "rust/scripts/c80_q23_canonical_rank_zero_sweep.py"
OUT = ROOT / "notes/2026-07-26-c80-q23-obligation-deletion-rewrite.json"

ROOT_CELLS = (
    (0, 0),
    (1, 1),
    (2, 12),
    (3, 8),
    (4, 6),
    (6, 5),
    (12, 20),
    (16, 15),
)
MARKED_DEFECT = (14, 3)
MARKED_REPLY = (18, 21)
SUCCESSOR_DEFECT = (5, 13)
PARALLEL_DISCHARGE = (22, 9)
PARALLEL_SECANT = ((12, 20), (16, 15))


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_obligation_deletion_base")
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.LIVE


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def slope(left: tuple[int, int], right: tuple[int, int]) -> int | None:
    q = BASE.BASE.Q
    dx = (right[0] - left[0]) % q
    if dx == 0:
        return None
    dy = (right[1] - left[1]) % q
    return dy * pow(dx, -1, q) % q


class DeletionCensus:
    """The hereditary kernel whose rewrites strictly delete obligations."""

    def __init__(self):
        self.census = BASE.BASE.BASE.BASE.DescentCensus()
        self.game = self.census.game
        self.memo: dict[int, bool] = {}
        self.records: dict[int, dict] = {}
        self.edges_examined = 0

    def mask(self, cells: tuple[tuple[int, int], ...]) -> int:
        return sum(
            1 << LIVE.cell_index(self.game, cell)
            for cell in cells
        )

    def cells(self, mask: int) -> list[list[int]]:
        return [
            list(self.game.cell_tuple(point))
            for point in GEOMETRY.bits(mask)
        ]

    def defects(self, mask: int) -> frozenset[int]:
        return frozenset(self.census.update.defect(mask))

    def survives(self, mask: int) -> bool:
        cached = self.memo.get(mask)
        if cached is not None:
            return cached

        defects = self.defects(mask)
        if not defects:
            self.memo[mask] = True
            self.records[mask] = {
                "mask_hex": hex(mask),
                "selected_size": mask.bit_count(),
                "defect_rank": 0,
                "witnesses": [],
            }
            return True

        witnesses = []
        self.memo[mask] = False
        for opponent in sorted(defects):
            child = mask | (1 << opponent)
            witness = None
            for reply in GEOMETRY.bits(self.game.legal_mask(child)):
                self.edges_examined += 1
                target = child | (1 << reply)
                next_defects = self.defects(target)
                if not next_defects < defects:
                    continue
                if not self.survives(target):
                    continue
                witness = {
                    "opponent": list(self.game.cell_tuple(opponent)),
                    "reply": list(self.game.cell_tuple(reply)),
                    "next_mask_hex": hex(target),
                    "next_defect_rank": len(next_defects),
                    "obligations_removed": len(defects - next_defects),
                }
                break
            if witness is None:
                return False
            witnesses.append(witness)

        self.memo[mask] = True
        self.records[mask] = {
            "mask_hex": hex(mask),
            "selected_size": mask.bit_count(),
            "defect_rank": len(defects),
            "witnesses": witnesses,
        }
        return True

    def replay(self, root: int) -> dict:
        assert self.survives(root)
        rows = {
            int(row["mask_hex"], 16): row
            for row in self.records.values()
        }
        reached: set[int] = set()
        stack = [root]
        edge_count = 0
        while stack:
            mask = stack.pop()
            if mask in reached:
                continue
            reached.add(mask)
            row = rows[mask]
            defects = self.defects(mask)
            assert row["defect_rank"] == len(defects)
            assert len(row["witnesses"]) == len(defects)
            assert {
                tuple(witness["opponent"])
                for witness in row["witnesses"]
            } == {
                self.game.cell_tuple(point) for point in defects
            }
            for witness in row["witnesses"]:
                opponent = LIVE.cell_index(
                    self.game, tuple(witness["opponent"])
                )
                reply = LIVE.cell_index(
                    self.game, tuple(witness["reply"])
                )
                child = mask | (1 << opponent)
                assert self.game.legal_mask(mask) & (1 << opponent)
                assert self.game.legal_mask(child) & (1 << reply)
                target = child | (1 << reply)
                assert target == int(witness["next_mask_hex"], 16)
                next_defects = self.defects(target)
                assert next_defects < defects
                assert witness["next_defect_rank"] == len(next_defects)
                assert witness["obligations_removed"] == len(
                    defects - next_defects
                )
                assert target in rows
                edge_count += 1
                stack.append(target)
        assert reached == set(rows)

        depth_cache: dict[int, int] = {}

        def depth(mask: int) -> int:
            cached = depth_cache.get(mask)
            if cached is not None:
                return cached
            witnesses = rows[mask]["witnesses"]
            value = 0 if not witnesses else 1 + max(
                depth(int(witness["next_mask_hex"], 16))
                for witness in witnesses
            )
            depth_cache[mask] = value
            return value

        return {
            "states": len(reached),
            "witness_edges": edge_count,
            "maximum_rewrite_depth": depth(root),
        }


def build_certificate(path: Path) -> dict:
    deletion = DeletionCensus()
    census = deletion.census
    game = deletion.game
    root = deletion.mask(ROOT_CELLS)
    defects = deletion.defects(root)
    assert len(defects) == 30
    assert census.kernel.omega(root) == 72
    assert not BASE.is_r0(census, root)
    assert census.ranked_survivor(root)["holds"]
    assert deletion.survives(root)

    marked_defect = LIVE.cell_index(game, MARKED_DEFECT)
    marked_reply = LIVE.cell_index(game, MARKED_REPLY)
    marked_target = root | (1 << marked_defect) | (1 << marked_reply)
    marked_next = deletion.defects(marked_target)
    successor_defect = LIVE.cell_index(game, SUCCESSOR_DEFECT)
    assert marked_next == frozenset({successor_defect})
    assert BASE.is_r0(census, marked_target)

    successor_child = marked_target | (1 << successor_defect)
    rank_zero_replies = []
    for reply in GEOMETRY.bits(game.legal_mask(successor_child)):
        target = successor_child | (1 << reply)
        if not deletion.defects(target):
            rank_zero_replies.append(game.cell_tuple(reply))
    assert rank_zero_replies == [(17, 22), PARALLEL_DISCHARGE]

    parallel_slopes = {
        "old_selected_secant": slope(*PARALLEL_SECANT),
        "marked_rewrite": slope(MARKED_DEFECT, MARKED_REPLY),
        "successor_discharge": slope(
            SUCCESSOR_DEFECT, PARALLEL_DISCHARGE
        ),
    }
    assert set(parallel_slopes.values()) == {16}

    replay = deletion.replay(root)
    comparison = DeletionCensus()
    response_comparison = Counter()
    first_disagreement = None
    response_candidates = 0
    for opponent in sorted(defects):
        child = root | (1 << opponent)
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            response_candidates += 1
            target = child | (1 << reply)
            next_defects = comparison.defects(target)
            in_delete = (
                next_defects < defects
                and comparison.survives(target)
            )
            in_fd = comparison.census.ranked_survivor(target)["holds"]
            response_comparison[(in_delete, in_fd)] += 1
            if in_delete != in_fd and first_disagreement is None:
                first_disagreement = {
                    "opponent": list(game.cell_tuple(opponent)),
                    "reply": list(game.cell_tuple(reply)),
                    "F_delete": in_delete,
                    "F_d": in_fd,
                }
    assert response_candidates == 525
    assert response_comparison[(True, True)] == 118
    assert sum(
        count
        for (in_delete, in_fd), count in response_comparison.items()
        if in_delete != in_fd
    ) == 0
    rank_histogram = Counter(
        row["defect_rank"] for row in deletion.records.values()
    )
    root_row = deletion.records[root]
    marked_witness = next(
        row for row in root_row["witnesses"]
        if tuple(row["opponent"]) == MARKED_DEFECT
    )
    assert tuple(marked_witness["reply"]) == MARKED_REPLY
    assert marked_witness["next_defect_rank"] == 1

    certificate = {
        "schema": "c80-q23-obligation-deletion-rewrite-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(SOURCE.relative_to(ROOT)): sha256(SOURCE),
        },
        "domain": {
            "q": BASE.BASE.Q,
            "root_cells": [list(cell) for cell in ROOT_CELLS],
            "root_defect_rank": len(defects),
            "root_omega": census.kernel.omega(root),
            "root_in_R0": False,
            "root_in_F_d": True,
        },
        "rewrite": {
            "definition": (
                "Def(S+x+y) is a strict subset of Def(S), and the "
                "successor admits the same rewrite"
            ),
            "root_in_F_delete": True,
            "rank_histogram": [
                {"defect_rank": rank, "states": count}
                for rank, count in sorted(rank_histogram.items())
            ],
            "search_edges_examined": deletion.edges_examined,
            **replay,
        },
        "root_response_graph_comparison": {
            "legal_reply_candidates": response_candidates,
            "F_delete_edges": sum(
                count
                for (in_delete, _), count in response_comparison.items()
                if in_delete
            ),
            "F_d_edges": sum(
                count
                for (_, in_fd), count in response_comparison.items()
                if in_fd
            ),
            "edge_disagreements": sum(
                count
                for (in_delete, in_fd), count
                in response_comparison.items()
                if in_delete != in_fd
            ),
            "first_disagreement": first_disagreement,
        },
        "first_F_d_outside_R0_edge": {
            "marked_defect": list(MARKED_DEFECT),
            "marked_reply": list(MARKED_REPLY),
            "rank_change": [len(defects), len(marked_next)],
            "successor_defects": [list(SUCCESSOR_DEFECT)],
            "successor_rank_zero_replies": [
                list(cell) for cell in rank_zero_replies
            ],
            "normalized_parallel_pencil_diagnostic": parallel_slopes,
        },
        "states": sorted(
            deletion.records.values(),
            key=lambda row: (
                row["selected_size"],
                row["defect_rank"],
                row["mask_hex"],
            ),
        ),
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
                raise SystemExit("certificate mismatch")
        print("PASS")
        return 0
    certificate = build_certificate(OUT)
    print(
        json.dumps(
            {
                "output": str(OUT.relative_to(ROOT)),
                "sha256": sha256(OUT),
                "states": certificate["rewrite"]["states"],
                "witness_edges": certificate["rewrite"][
                    "witness_edges"
                ],
                "maximum_rewrite_depth": certificate["rewrite"][
                    "maximum_rewrite_depth"
                ],
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
