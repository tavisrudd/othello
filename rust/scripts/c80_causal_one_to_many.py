#!/usr/bin/env python3
"""Certify the first extracted C80 uncompensated one-to-many replacement."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import random
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_causal_nonpacking.py"
OUT = ROOT / "notes/2026-07-29-c80-causal-one-to-many.json"

Q = 11
SEED = 80011
PATH = ((5, 2), (9, 6), (1, 3), (10, 1))
STATE = frozenset(PATH)
OPPONENT = (4, 4)
CAUSAL_REPLY = (7, 10)
NEW_DEFECTS = frozenset(((0, 5), (6, 5)))


def load_source():
    spec = importlib.util.spec_from_file_location(
        "c80_causal_one_to_many_source", SOURCE
    )
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


SOURCE_MODULE = load_source()


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def primary_mask(game, points) -> int:
    by_cell = {
        game.cell_tuple(index): index for index in range(Q * Q)
    }
    return sum(1 << by_cell[point] for point in points)


def primary_cells(game, points) -> list[list[int]]:
    return [list(game.cell_tuple(point)) for point in sorted(points)]


def primary_certificate() -> dict:
    boundary = SOURCE_MODULE.SmallBoundaryGame(Q)
    game = boundary.game
    state = primary_mask(game, STATE)
    opponent = primary_mask(game, (OPPONENT,))
    causal = primary_mask(game, (CAUSAL_REPLY,))
    child = state | opponent
    successor = child | causal

    old_defects = boundary.defects(state)
    half_defects = boundary.defects(child)
    next_defects = boundary.defects(successor)
    created = next_defects - half_defects - old_defects
    assert opponent.bit_length() - 1 in old_defects
    assert causal.bit_length() - 1 in old_defects
    assert primary_cells(game, created) == [
        list(point) for point in sorted(NEW_DEFECTS)
    ]

    fibres = []
    for defect in sorted(created):
        before_child = child | (1 << defect)
        after_child = successor | (1 << defect)
        old_replies = [
            reply
            for reply in SOURCE_MODULE.KERNEL.GEOMETRY.bits(
                game.legal_mask(before_child)
            )
            if boundary.is_small_boundary(before_child | (1 << reply))
        ]
        new_replies = [
            reply
            for reply in SOURCE_MODULE.KERNEL.GEOMETRY.bits(
                game.legal_mask(after_child)
            )
            if boundary.is_small_boundary(after_child | (1 << reply))
        ]
        assert old_replies and not new_replies
        fibres.append(
            {
                "defect": list(game.cell_tuple(defect)),
                "old_B_small_certificate_replies": primary_cells(
                    game, old_replies
                ),
                "new_B_small_certificate_replies": primary_cells(
                    game, new_replies
                ),
            }
        )

    return {
        "old_defects": primary_cells(game, old_defects),
        "defects_after_opponent": primary_cells(game, half_defects),
        "defects_after_causal_reply": primary_cells(game, next_defects),
        "genuinely_new_defects": primary_cells(game, created),
        "uncompensated_fibres": fibres,
    }


def direct_certificate() -> dict:
    game = SOURCE_MODULE.DirectSmallBoundaryGame(Q)
    child = STATE | {OPPONENT}
    successor = child | {CAUSAL_REPLY}
    assert OPPONENT in game.legal(STATE)
    assert CAUSAL_REPLY in game.legal(child)

    old_defects = game.defects(STATE)
    half_defects = game.defects(child)
    next_defects = game.defects(successor)
    created = next_defects - half_defects - old_defects
    assert OPPONENT in old_defects
    assert CAUSAL_REPLY in old_defects
    assert created == NEW_DEFECTS

    fibres = []
    for defect in sorted(created):
        old_replies = [
            reply
            for reply in game.legal(child | {defect})
            if game.is_small_boundary(child | {defect, reply})
        ]
        new_replies = [
            reply
            for reply in game.legal(successor | {defect})
            if game.is_small_boundary(successor | {defect, reply})
        ]
        assert old_replies and not new_replies
        attacks = []
        for reply in old_replies:
            if reply == CAUSAL_REPLY:
                attacks.append(
                    {
                        "reply": list(reply),
                        "mode": "causal_reply_already_selected",
                    }
                )
            else:
                pivots = sorted(
                    point
                    for point in child | {defect}
                    if game.collinear(point, CAUSAL_REPLY, reply)
                )
                assert not game.legal_after(
                    successor | {defect}, reply
                )
                assert pivots
                attacks.append(
                    {
                        "reply": list(reply),
                        "mode": "certificate_reply_secant_deletion",
                        "pivots": [list(point) for point in pivots],
                    }
                )
        fibres.append(
            {
                "defect": list(defect),
                "old_B_small_certificate_replies": [
                    list(reply) for reply in old_replies
                ],
                "new_B_small_certificate_replies": [
                    list(reply) for reply in new_replies
                ],
                "attacks": attacks,
            }
        )

    return {
        "old_defects": [list(point) for point in sorted(old_defects)],
        "defects_after_opponent": [
            list(point) for point in sorted(half_defects)
        ],
        "defects_after_causal_reply": [
            list(point) for point in sorted(next_defects)
        ],
        "genuinely_new_defects": [
            list(point) for point in sorted(created)
        ],
        "uncompensated_fibres": fibres,
    }


def replay_discovery_path() -> list[list[int]]:
    boundary = SOURCE_MODULE.SmallBoundaryGame(Q)
    game = boundary.game
    rng = random.Random(SEED)
    mask = 0
    path = []
    for _ in range(4):
        legal = list(
            SOURCE_MODULE.KERNEL.GEOMETRY.bits(game.legal_mask(mask))
        )
        point = rng.choice(legal)
        mask |= 1 << point
        path.append(list(game.cell_tuple(point)))
    assert path == [list(point) for point in PATH]
    return path


def build_certificate(path: Path) -> dict:
    primary = primary_certificate()
    direct = direct_certificate()
    for key in (
        "old_defects",
        "defects_after_opponent",
        "defects_after_causal_reply",
        "genuinely_new_defects",
    ):
        assert primary[key] == direct[key]
    certificate = {
        "schema": "c80-causal-one-to-many-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(SOURCE.relative_to(ROOT)): sha256(SOURCE),
        },
        "field": {"order": Q, "model": "prime field F_11"},
        "discovery": {
            "method": (
                "deterministic seeded legal-path scout; first path, "
                "first state eligible at residual selected size four"
            ),
            "seed": SEED,
            "legal_path": replay_discovery_path(),
        },
        "witness": {
            "state": [list(point) for point in sorted(STATE)],
            "opponent": list(OPPONENT),
            "causal_reply": list(CAUSAL_REPLY),
        },
        "primary_bitmask_replay": primary,
        "independent_affine_determinant_replay": direct,
        "conclusion": {
            "opponent_and_reply_carry_distinct_old_defect_labels": True,
            "intermediate_defect_locus_is_empty": True,
            "uncompensated_new_defect_count": len(NEW_DEFECTS),
            "certificate_exchange_nonpacking": False,
            "uniform_certificate_exchange_repair_lemma": False,
            "single_causal_label_update_is_injective": False,
        },
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
                "new_defects": certificate["conclusion"][
                    "uncompensated_new_defect_count"
                ],
            },
            sort_keys=True,
        )
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
