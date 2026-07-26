#!/usr/bin/env python3
"""C80: extract and canonicalize the marked q=17/q=19 spoiling fibres."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_coupled_overload_tutte_bank.py"
OUT = ROOT / "notes/2026-07-25-c80-spoiling-fibres.json"

Point = tuple[int, int, int]
Matrix = tuple[int, int, int, int]
ObjectKey = tuple[tuple[Point, ...], Point, tuple[Point, ...]]

CASES = (
    (17, (13, 14, 15, 16), (4, 0), (5, 15)),
    (17, (13, 14, 15, 16), (5, 0), (7, 7)),
    (17, (13, 14, 15, 16), (8, 14), (6, 2)),
    (17, (13, 14, 15, 16), (11, 9), (10, 13)),
    (19, (15, 16, 17, 18), (4, 0), (7, 1)),
)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BANK = load_module(SOURCE, "c80_spoiling_source")
SHELL = BANK.SHELL
BASE = BANK.BASE
GEOMETRY = BANK.GEOMETRY
INPUTS = (SOURCE, *BANK.INPUTS)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalize(q: int, point: Point) -> Point:
    for coordinate in point:
        if coordinate % q:
            scale = pow(coordinate, -1, q)
            return tuple((scale * value) % q for value in point)  # type: ignore[return-value]
    raise ValueError("zero projective point")


def pgl2(q: int) -> tuple[Matrix, ...]:
    representatives = set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    entries = (a, b, c, d)
                    pivot = next(value for value in entries if value)
                    scale = pow(pivot, -1, q)
                    representatives.add(
                        tuple((scale * value) % q for value in entries)
                    )
    result = tuple(sorted(representatives))
    assert len(result) == q * (q * q - 1)
    return result


def sym2(q: int, matrix: Matrix, point: Point) -> Point:
    a, b, c, d = matrix
    x, y, z = point
    return normalize(
        q,
        (
            (a * a * x + b * b * y + 2 * a * b * z) % q,
            (c * c * x + d * d * y + 2 * c * d * z) % q,
            (a * c * x + b * d * y + (a * d + b * c) * z) % q,
        ),
    )


def projective_point(game, cell: int) -> Point:
    return normalize(game.q, game.points[cell + 2])


def object_key(
    game, target: int, spoiler: int, strict_replies: tuple[int, ...]
) -> ObjectKey:
    selected = {(1, 0, 0), (0, 1, 0)}
    selected.update(projective_point(game, cell) for cell in GEOMETRY.bits(target))
    return (
        tuple(sorted(selected)),
        projective_point(game, spoiler),
        tuple(sorted(projective_point(game, reply) for reply in strict_replies)),
    )


def transform_key(q: int, matrix: Matrix, key: ObjectKey) -> ObjectKey:
    selected, spoiler, strict_replies = key
    return (
        tuple(sorted(sym2(q, matrix, point) for point in selected)),
        sym2(q, matrix, spoiler),
        tuple(sorted(sym2(q, matrix, point) for point in strict_replies)),
    )


def encode_key(key: ObjectKey) -> dict:
    selected, spoiler, strict_replies = key
    return {
        "selected": [list(point) for point in selected],
        "spoiler": list(spoiler),
        "strict_reply_candidates": [
            list(point) for point in strict_replies
        ],
    }


def strict_reply_rows(pair_kernel, copycat_kernel, target: int, spoiler: int):
    child = target | (1 << spoiler)
    rows = []
    for reply in GEOMETRY.bits(pair_kernel.game.legal_mask(child)):
        next_state = child | (1 << reply)
        next_omega = pair_kernel.omega(next_state)
        if next_omega >= pair_kernel.omega(target):
            continue
        rows.append(
            {
                "reply": list(pair_kernel.game.cell_tuple(reply)),
                "target_omega": next_omega,
                "in_copycat_survivor": copycat_kernel.contains(next_state),
                "in_positive_pairing_kernel": pair_kernel.contains(next_state),
            }
        )
    return sorted(rows, key=lambda row: (row["reply"], row["target_omega"]))


def direct_spoilers(pair_kernel, copycat_kernel, target: int):
    spoilers = []
    for opponent in GEOMETRY.bits(pair_kernel.game.legal_mask(target)):
        rows = strict_reply_rows(pair_kernel, copycat_kernel, target, opponent)
        if not any(row["in_positive_pairing_kernel"] for row in rows):
            spoilers.append((opponent, rows))
    return spoilers


def run() -> dict:
    records = []
    by_q: dict[int, list[dict]] = defaultdict(list)
    groups = {q: pgl2(q) for q in sorted({case[0] for case in CASES})}
    for case_index, (q, t4, marked_opponent, decoy_reply) in enumerate(CASES):
        pair_kernel = SHELL.PositivePairingKernel(q)
        copycat_kernel = BASE.CopycatKernel(q)
        root = pair_kernel.game.base_mask(t4)
        target = BANK.target_mask(
            pair_kernel.game, root, marked_opponent, decoy_reply
        )
        cells, adjacency = BANK.TUTTE.reply_graph(pair_kernel, target)
        graph_spoilers = [
            cells[index] for index, neighbours in enumerate(adjacency) if not neighbours
        ]
        direct = direct_spoilers(pair_kernel, copycat_kernel, target)
        direct_indices = [opponent for opponent, _ in direct]
        assert graph_spoilers == direct_indices
        assert not pair_kernel.contains(target)
        assert direct
        for spoiler, rows in direct:
            assert rows
            assert not any(row["in_copycat_survivor"] for row in rows)
            strict_reply_indices = tuple(
                row["reply"][0] * q + row["reply"][1] for row in rows
            )
            key = object_key(
                pair_kernel.game, target, spoiler, strict_reply_indices
            )
            images = {transform_key(q, matrix, key) for matrix in groups[q]}
            canonical = min(images)
            state_images = {
                transform_key(q, matrix, key)[0] for matrix in groups[q]
            }
            canonical_state = min(state_images)
            state_stabilizer = len(groups[q]) // len(state_images)
            stabilizer = sum(
                transform_key(q, matrix, key) == key for matrix in groups[q]
            )
            assert len(images) * stabilizer == len(groups[q])
            record = {
                "case": case_index,
                "q": q,
                "root_t4": list(t4),
                "marked_opponent": list(marked_opponent),
                "decoy_reply": list(decoy_reply),
                "decoy_omega": pair_kernel.omega(target),
                "spoiler": list(pair_kernel.game.cell_tuple(spoiler)),
                "strict_reply_count": len(rows),
                "strict_replies": rows,
                "zero_copycat_survivor_replies": True,
                "zero_positive_pairing_replies": True,
                "canonical_decoy_state": [
                    list(point) for point in canonical_state
                ],
                "canonical": encode_key(canonical),
                "decoy_state_orbit_size": len(state_images),
                "decoy_state_stabilizer_size": state_stabilizer,
                "object_orbit_size": len(images),
                "object_stabilizer_size": stabilizer,
            }
            records.append(record)
            by_q[q].append(record)

    orbit_summary = {}
    for q, q_records in sorted(by_q.items()):
        buckets: dict[str, list[int]] = defaultdict(list)
        for index, record in enumerate(q_records):
            encoded = json.dumps(record["canonical"], sort_keys=True)
            buckets[encoded].append(index)
        orbit_summary[str(q)] = {
            "decoy_state_orbits": len(
                {
                    json.dumps(record["canonical_decoy_state"])
                    for record in q_records
                }
            ),
            "spoiling_fibres": len(q_records),
            "canonical_orbits": len(buckets),
            "orbit_multiplicities": sorted(len(indices) for indices in buckets.values()),
            "orbit_members": [indices for _, indices in sorted(buckets.items())],
        }

    assert orbit_summary["17"]["spoiling_fibres"] == 8
    assert orbit_summary["19"]["spoiling_fibres"] == 1
    assert orbit_summary["17"]["decoy_state_orbits"] == 1
    assert orbit_summary["17"]["canonical_orbits"] == 2
    assert orbit_summary["17"]["orbit_multiplicities"] == [4, 4]
    assert orbit_summary["19"]["decoy_state_orbits"] == 1
    assert orbit_summary["19"]["canonical_orbits"] == 1
    assert sum(record["strict_reply_count"] for record in records) == 106
    return {
        "schema": "c80-spoiling-fibres-v1",
        "source": "rust/scripts/c80_spoiling_fibre_canonicalization.py",
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "definition": {
            "spoiling_fibre": (
                "a legal opponent at a marked decoy target for which every "
                "jointly legal strict-Omega reply lies outside M_Omega"
            ),
            "minimality": (
                "one marked opponent fibre; emptiness is checked by exhaustive "
                "enumeration of every jointly legal strict-Omega reply"
            ),
            "canonicalization": (
                "lexicographically least symmetric-square PGL(2,q) image of "
                "the selected projective set, marked spoiler, and complete "
                "strict-reply candidate set"
            ),
        },
        "cross_checks": {
            "isolated_vertices_equal_direct_empty_fibres": True,
            "every_strict_candidate_outside_copycat_survivor": True,
            "orbit_stabilizer_identity_verified": True,
        },
        "orbit_summary": orbit_summary,
        "records": records,
    }


def write_output(path: Path) -> None:
    path.write_text(json.dumps(run(), indent=2, sort_keys=True) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as tmp:
            candidate = Path(tmp) / OUT.name
            write_output(candidate)
            if not OUT.exists() or candidate.read_bytes() != OUT.read_bytes():
                print(f"FAIL {OUT.relative_to(ROOT)}")
                return 1
        print(f"PASS {OUT.relative_to(ROOT)}")
        return 0
    write_output(OUT)
    print(f"WROTE {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
