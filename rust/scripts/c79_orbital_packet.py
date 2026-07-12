#!/usr/bin/env python3
"""Verify the odd-q conic-intruder orbital discriminant in grid coordinates."""

from __future__ import annotations

import argparse
import importlib.util
import sys
from collections import Counter
from pathlib import Path


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def chi(q: int, value: int) -> int:
    value %= q
    if value == 0:
        return 0
    return 1 if pow(value, (q - 1) // 2, q) == 1 else -1


def discriminant(q: int, x: tuple[int, int], y: tuple[int, int]) -> int:
    r, c = x
    u, v = y
    trace = 2 - r * v - c * u
    determinant = (r * c - 1) * (u * v - 1)
    return (trace * trace - 4 * determinant) % q


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("q", nargs="*", type=int, default=[11, 13, 17, 19])
    args = parser.parse_args()

    notes = Path(__file__).resolve().parents[2] / "notes"
    c20 = load_module(notes / "2026-07-08-intrusion-census.py", "c79_orbital_c20")
    for q in args.q:
        game = c20.PrimeGridGame(q)
        intruders = [cell for cell in range(q * q) if not game.is_conic_cell(cell)]
        perms = {cell: game.sigma_perm(cell) for cell in intruders}
        counts = Counter()
        overlaps = Counter()
        failures = []
        for i, xcell in enumerate(intruders):
            x = game.cell_tuple(xcell)
            px = perms[xcell]
            for ycell in intruders[i + 1:]:
                y = game.cell_tuple(ycell)
                py = perms[ycell]
                common_directed = sum(
                    1 for t in game.params if px[t] == py[t] and px[t] != t
                )
                assert common_directed % 2 == 0
                common_edges = common_directed // 2
                overlaps[common_edges] += 1
                if common_edges > 1:
                    failures.append((x, y, "matching-overlap", common_edges))
                dchar = chi(q, discriminant(q, x, y))
                line_type = {0: -1, 1: 0, 2: 1}[len(
                    tuple(
                        t for t in game.params
                        if game.collinear(
                            game.points[xcell + 2], game.points[ycell + 2], game.conic_point[t]
                        )
                    )
                )]
                order = game.prod_order(px, py)
                order_ok = (
                    (dchar == 0 and order == q)
                    or (dchar == 1 and (q - 1) % order == 0)
                    or (dchar == -1 and (q + 1) % order == 0)
                )
                counts[(dchar, order)] += 1
                if dchar != line_type or not order_ok:
                    failures.append((x, y, dchar, line_type, order))
        print(
            f"ORBITAL-DISCRIMINANT q={q} pairs={sum(counts.values())} "
            f"failures={len(failures)} counts={dict(sorted(counts.items()))} "
            f"matching_overlaps={dict(sorted(overlaps.items()))}"
        )
        if failures:
            print(f"ORBITAL-DISCRIMINANT-FIRST-FAILURE {failures[0]}")
            return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
