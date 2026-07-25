#!/usr/bin/env python3
"""Falsify the pure-extension ranked survivor on certified q=13 P roots.

The candidate requires the continuation complex at a controlled state to be
pure of even rank.  A pair of maximal continuations of different cardinality
is therefore a compact exact countercertificate.

Run:
  python3 rust/scripts/c80_pure_extension_survivor.py
Check:
  python3 rust/scripts/c80_pure_extension_survivor.py --check
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import random
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
KERNEL_CERT = ROOT / "notes/2026-07-24-c80-strict-overload-kernel.json"
KERNEL_SCRIPT = ROOT / "rust/scripts/c80_strict_overload_kernel.py"
OUT = ROOT / "notes/2026-07-25-c80-pure-extension-survivor.json"
SEED_STOP = 512


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


KERNEL = load_module(KERNEL_SCRIPT, "c80_pure_extension_kernel")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cells(game, mask: int) -> tuple[tuple[int, int], ...]:
    return tuple(KERNEL.GEOMETRY.cell(game, i) for i in KERNEL.GEOMETRY.bits(mask))


def collinear(q: int, a: tuple[int, int], b: tuple[int, int], c: tuple[int, int]) -> bool:
    return (
        (b[0] - a[0]) * (c[1] - a[1])
        - (b[1] - a[1]) * (c[0] - a[0])
    ) % q == 0


def direct_valid(q: int, points: tuple[tuple[int, int], ...]) -> bool:
    if len({x for x, _ in points}) != len(points):
        return False
    if len({y for _, y in points}) != len(points):
        return False
    for i in range(len(points)):
        for j in range(i + 1, len(points)):
            for k in range(j + 1, len(points)):
                if collinear(q, points[i], points[j], points[k]):
                    return False
    return True


def direct_maximal(q: int, points: tuple[tuple[int, int], ...]) -> bool:
    selected = set(points)
    return all(
        not direct_valid(q, points + ((x, y),))
        for x in range(q)
        for y in range(q)
        if (x, y) not in selected
    )


def greedy_continuation(game, root: int, seed: int) -> tuple[int, ...]:
    order = list(KERNEL.GEOMETRY.bits(game.legal_mask(root)))
    random.Random(seed).shuffle(order)
    mask = root
    chosen: list[int] = []
    for point in order:
        if game.legal_mask(mask) & (1 << point):
            chosen.append(point)
            mask |= 1 << point
    if game.legal_mask(mask):
        raise AssertionError("greedy continuation is not maximal")
    return tuple(chosen)


def verify_witness(game, root: int, witness: dict) -> None:
    indices = tuple(int(i) for i in witness["indices"])
    coordinates = tuple(tuple(int(z) for z in xy) for xy in witness["coordinates"])
    if coordinates != tuple(KERNEL.GEOMETRY.cell(game, i) for i in indices):
        raise AssertionError("index/coordinate mismatch")
    if len(indices) != witness["length"]:
        raise AssertionError("length mismatch")

    mask = root
    for point in indices:
        if not (game.legal_mask(mask) & (1 << point)):
            raise AssertionError("engine replay found an illegal move")
        mask |= 1 << point
    if game.legal_mask(mask):
        raise AssertionError("engine replay found a nonmaximal continuation")

    root_coordinates = cells(game, root)
    accumulated = root_coordinates
    for point in coordinates:
        accumulated += (point,)
        if not direct_valid(game.q, accumulated):
            raise AssertionError("direct determinant reference found an illegal prefix")
    if not direct_maximal(game.q, accumulated):
        raise AssertionError("direct determinant reference found a legal extension")


def build() -> dict:
    source = json.loads(KERNEL_CERT.read_text())
    q13 = next(row for row in source["frozen_escape_orders"] if row["q"] == 13)
    labels = [
        tuple(int(t) for t in row["t4"])
        for row in q13["records"]
        if row["strict_kernel"]
    ]
    game = KERNEL.C20.PrimeGridGame(13)
    records = []
    for label in labels:
        root = game.base_mask(label)
        by_parity: dict[int, tuple[int, tuple[int, ...]]] = {}
        for seed in range(SEED_STOP):
            continuation = greedy_continuation(game, root, seed)
            by_parity.setdefault(len(continuation) % 2, (seed, continuation))
            if len(by_parity) == 2:
                break
        if len(by_parity) != 2:
            raise AssertionError(f"no mixed-parity witnesses found for {label}")

        witnesses = []
        for parity in (0, 1):
            seed, continuation = by_parity[parity]
            witness = {
                "seed": seed,
                "length": len(continuation),
                "indices": list(continuation),
                "coordinates": [
                    list(KERNEL.GEOMETRY.cell(game, i)) for i in continuation
                ],
            }
            verify_witness(game, root, witness)
            witnesses.append(witness)
        records.append(
            {
                "q": 13,
                "t4": list(label),
                "root_coordinates": [list(xy) for xy in cells(game, root)],
                "maximal_continuations": witnesses,
                "different_lengths": witnesses[0]["length"] != witnesses[1]["length"],
                "different_parities": True,
                "engine_replay": "PASS",
                "independent_affine_determinant_replay": "PASS",
            }
        )

    return {
        "schema": "c80-pure-extension-survivor-v1",
        "claim_scope": (
            "Each of the five q=13 strict-kernel/P escape roots has certified "
            "maximal continuations of opposite parity, so its continuation "
            "complex is not pure."
        ),
        "source": {
            "strict_kernel_certificate": str(KERNEL_CERT.relative_to(ROOT)),
            "strict_kernel_certificate_sha256": sha256(KERNEL_CERT),
            "strict_kernel_script": str(KERNEL_SCRIPT.relative_to(ROOT)),
            "strict_kernel_script_sha256": sha256(KERNEL_SCRIPT),
        },
        "search": {
            "algorithm": "Python random.Random(seed) shuffle, then greedy legal extension",
            "seed_range": [0, SEED_STOP - 1],
            "stop": "first even-length and first odd-length maximal continuation per root",
        },
        "roots_checked": len(records),
        "roots_with_mixed_parity_maximal_continuations": sum(
            row["different_parities"] for row in records
        ),
        "records": records,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if args.check:
        with tempfile.TemporaryDirectory() as tmp:
            candidate = Path(tmp) / OUT.name
            candidate.write_text(payload)
            if not OUT.exists() or candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"FAIL: {OUT} is stale")
        print("PASS: certificate is current; engine and independent replay agree")
    else:
        OUT.write_text(payload)
        print(f"wrote {OUT}")


if __name__ == "__main__":
    main()
