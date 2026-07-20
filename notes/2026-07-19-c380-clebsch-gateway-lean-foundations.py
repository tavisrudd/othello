#!/usr/bin/env python3
"""Cross-check C380's bounded Lean tables against the frozen C378/C379 certificates."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes/2026-07-19-c380-clebsch-gateway-lean-foundations.json"
MATCHING_LEAN = ROOT / "lean/RelativeConicArcs/ClebschGatewayQ11Matching.lean"
FUSION_LEAN = ROOT / "lean/RelativeConicArcs/ClebschGatewayQ11Fusion.lean"
C378_JSON = ROOT / "notes/2026-07-19-c378-clebsch-common-duality.json"
C379_JSON = ROOT / "notes/2026-07-19-c379-clebsch-deep-hole-extension.json"
LEAN_SOURCES = [
    ROOT / "lean/RelativeConicArcs/ClebschGateway.lean",
    ROOT / "lean/RelativeConicArcs/ClebschGatewayQ11Extension.lean",
    ROOT / "lean/RelativeConicArcs/ClebschGatewayQ11Conic.lean",
    MATCHING_LEAN,
    FUSION_LEAN,
    ROOT / "lean/RelativeConicArcs/Gates/ClebschGateway.lean",
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def vector_rows(source: str, name: str, row_count: int) -> list[list[int]]:
    marker = f"def {name}"
    start = source.index(marker)
    end = source.index("\n\n", start)
    block = source[start:end]
    rows = [
        [int(value.strip()) for value in row.split(",")]
        for row in re.findall(r"!\[([-0-9, ]+)\]", block)
    ]
    if len(rows) != row_count:
        raise ValueError(f"{name}: expected {row_count} rows, found {len(rows)}")
    return rows


def single_vector(source: str, name: str, length: int) -> list[int]:
    rows = vector_rows(source, name, 1)
    if len(rows[0]) != length:
        raise ValueError(f"{name}: expected length {length}, found {len(rows[0])}")
    return rows[0]


def mate_rows_from_c379(data: dict) -> list[list[int]]:
    points = data["deep_hole_conic"]
    point_index = {tuple(point): i for i, point in enumerate(points)}
    sheets = data["one_factorization_biplane"]
    matchings = sheets["tau8_sheet_matchings"] + sheets["tau4_sheet_matchings"]
    rows: list[list[int]] = []
    for matching in matchings:
        row = [-1] * 12
        for left, right in matching:
            i = point_index[tuple(left)]
            j = point_index[tuple(right)]
            row[i] = j
            row[j] = i
        if any(value < 0 for value in row):
            raise ValueError("incomplete C379 matching")
        rows.append(row)
    return rows


def square(matrix: list[list[int]]) -> list[list[int]]:
    n = len(matrix)
    return [
        [sum(matrix[i][k] * matrix[k][j] for k in range(n)) for j in range(n)]
        for i in range(n)
    ]


def build_certificate() -> dict:
    c378 = json.loads(C378_JSON.read_text())
    c379 = json.loads(C379_JSON.read_text())
    matching_source = MATCHING_LEAN.read_text()
    fusion_source = FUSION_LEAN.read_text()

    lean_mates = vector_rows(matching_source, "matchingMate", 22)
    frozen_mates = mate_rows_from_c379(c379)
    if lean_mates != frozen_mates:
        raise ValueError("Lean matching table differs from C379")

    if any(row[row[i]] != i or row[i] == i for row in lean_mates for i in range(12)):
        raise ValueError("matching table is not fixed-point-free and involutive")
    if len({tuple(row) for row in lean_mates}) != 22:
        raise ValueError("matching table is not injective")
    for sheet_start in (0, 11):
        edge_counts: dict[tuple[int, int], int] = {}
        for row in lean_mates[sheet_start : sheet_start + 11]:
            for i, j in enumerate(row):
                edge = tuple(sorted((i, j)))
                edge_counts[edge] = edge_counts.get(edge, 0) + 1
        # Each mate table lists an undirected edge from both endpoints.
        if len(edge_counts) != 66 or set(edge_counts.values()) != {2}:
            raise ValueError("a matching sheet is not a K12 one-factorization")

    fusion = single_vector(fusion_source, "orthogonalFusion", 8)
    fine_valencies = single_vector(fusion_source, "fineValency", 8)
    fused_sizes = single_vector(fusion_source, "fusedOrbitSize", 4)
    blocks = [[i for i, color in enumerate(fusion) if color == c] for c in range(4)]
    if blocks != c378["c372_rank_four_fusion_blocks"]:
        raise ValueError("Lean fusion blocks differ from C378")
    computed_sizes = [sum(fine_valencies[i] for i in block) for block in blocks]
    if computed_sizes != fused_sizes or sorted(fused_sizes) != c378["golden_closure_affine_orbit_sizes"]:
        raise ValueError("Lean fused orbit sizes differ from C378")

    common_j_rows = vector_rows(fusion_source, "commonJ", 2)
    if common_j_rows[0] != common_j_rows[1]:
        raise ValueError("Lean common-refinement involution has different forward/inverse tables")
    common_j = common_j_rows[0]
    if common_j != c378["J_relation_permutation"]:
        raise ValueError("Lean common-refinement involution differs from C378")
    odd_fourier = vector_rows(fusion_source, "oddFourier", 4)
    if odd_fourier != c378["odd_fourier_matrix"]:
        raise ValueError("Lean odd Fourier matrix differs from C378")
    target_square = [[1331 if i == j else 0 for j in range(4)] for i in range(4)]
    if square(odd_fourier) != target_square:
        raise ValueError("odd Fourier square is not 1331 I4")

    return {
        "schema": "c380-clebsch-gateway-lean-foundations-v1",
        "inputs": {
            C378_JSON.relative_to(ROOT).as_posix(): sha256(C378_JSON),
            C379_JSON.relative_to(ROOT).as_posix(): sha256(C379_JSON),
        },
        "lean_sources": {
            path.relative_to(ROOT).as_posix(): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in LEAN_SOURCES
        },
        "matching": {
            "parent_count": 22,
            "sheet_sizes": [11, 11],
            "distinct_matchings": 22,
            "each_sheet_is_k12_one_factorization": True,
            "decorated_parent_map_injective": True,
        },
        "fusion": {
            "blocks": blocks,
            "fused_orbit_sizes_in_block_order": fused_sizes,
            "common_refinement_J": common_j,
            "odd_fourier_square": "1331 I_4",
        },
    }


def canonical_bytes(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.write:
        OUTPUT.write_bytes(payload)
        return
    if not OUTPUT.exists() or OUTPUT.read_bytes() != payload:
        raise SystemExit("tracked C380 certificate is stale; run with --write intentionally")


if __name__ == "__main__":
    main()
