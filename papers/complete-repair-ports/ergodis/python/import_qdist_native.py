#!/usr/bin/env python3
"""Import dense QDistSAT matrices into a verified Ergodis CSS-distance input."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


def read_dense(path: Path) -> tuple[list[int], int]:
    rows: list[int] = []
    columns: int | None = None
    for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if line.lstrip().startswith("#"):
            continue
        fields = line.split()
        if not fields:
            continue
        if any(field not in {"0", "1"} for field in fields):
            raise RuntimeError(f"{path}:{line_number}: expected a dense binary row")
        if columns is None:
            columns = len(fields)
        elif len(fields) != columns:
            raise RuntimeError(f"{path}:{line_number}: inconsistent row width")
        rows.append(sum((field == "1") << index for index, field in enumerate(fields)))
    if columns is None or not rows:
        raise RuntimeError(f"{path}: empty matrix")
    return rows, columns


def row_basis(rows: list[int]) -> list[int]:
    pivots: dict[int, int] = {}
    for original in rows:
        value = original
        while value:
            pivot = value.bit_length() - 1
            prior = pivots.get(pivot)
            if prior is None:
                pivots[pivot] = value
                break
            value ^= prior
    for pivot in sorted(pivots):
        value = pivots[pivot]
        for larger in sorted((other for other in pivots if other > pivot), reverse=True):
            if (pivots[larger] >> pivot) & 1:
                pivots[larger] ^= value
    return [pivots[pivot] for pivot in sorted(pivots, reverse=True)]


def is_contained(rows: list[int], basis: list[int]) -> bool:
    pivots = {row.bit_length() - 1: row for row in basis}
    for original in rows:
        value = original
        while value:
            pivot = value.bit_length() - 1
            prior = pivots.get(pivot)
            if prior is None:
                return False
            value ^= prior
    return True


def permute(value: int, block_size: int, rows: int, columns: int, axis: int) -> int:
    result = 0
    while value:
        low = value & -value
        coordinate = low.bit_length() - 1
        value ^= low
        block, offset = divmod(coordinate, block_size)
        row, column = divmod(offset, columns)
        if axis == 0:
            row = (row + 1) % rows
        else:
            column = (column + 1) % columns
        result |= 1 << (block * block_size + row * columns + column)
    return result


def sparse_rows(rows: list[int]) -> list[list[int]]:
    output: list[list[int]] = []
    for value in rows:
        support: list[int] = []
        while value:
            low = value & -value
            support.append(low.bit_length() - 1)
            value ^= low
        output.append(support)
    return output


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--physical", type=Path, required=True)
    parser.add_argument("--logical", type=Path, required=True)
    parser.add_argument("--label", required=True)
    parser.add_argument("--maximum-weight", type=int, required=True)
    parser.add_argument("--torus-shape", required=True, help="rows,columns per coordinate block")
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    try:
        torus_rows, torus_columns = (int(part) for part in args.torus_shape.split(","))
    except (TypeError, ValueError):
        raise RuntimeError("--torus-shape must be rows,columns") from None
    if torus_rows <= 0 or torus_columns <= 0:
        raise RuntimeError("torus dimensions must be positive")
    block_size = torus_rows * torus_columns

    physical, columns = read_dense(args.physical)
    logical_raw, logical_columns = read_dense(args.logical)
    if columns != logical_columns or columns != 2 * block_size:
        raise RuntimeError("matrix widths do not match the two-block torus shape")
    physical_basis = row_basis(physical)
    logical_basis = row_basis(logical_raw)
    observable_basis = row_basis(physical + logical_basis)
    observable_rank = len(observable_basis) - len(physical_basis)
    if observable_rank != len(logical_basis):
        raise RuntimeError("logical rows are not independent modulo the physical constraints")

    for axis in (0, 1):
        translated_physical = [
            permute(row, block_size, torus_rows, torus_columns, axis) for row in physical
        ]
        translated_observable = [
            permute(row, block_size, torus_rows, torus_columns, axis)
            for row in physical + logical_basis
        ]
        if not is_contained(translated_physical, physical_basis):
            raise RuntimeError(f"torus translation {axis} does not preserve physical checks")
        if not is_contained(translated_observable, observable_basis):
            raise RuntimeError(f"torus translation {axis} does not preserve observability")

    output = {
        "label": args.label,
        "coordinate_count": columns,
        "physical_checks": sparse_rows(physical),
        "logical_observations": sparse_rows(logical_basis),
        "anchors": [0, block_size],
        "maximum_weight": args.maximum_weight,
        "metadata": {
            "source_schema": "QDistSAT-dense-binary-v1",
            "physical_sha256": sha256(args.physical),
            "logical_sha256": sha256(args.logical),
            "physical_rows": len(physical),
            "physical_rank": len(physical_basis),
            "logical_source_rows": len(logical_raw),
            "logical_observation_rank": len(logical_basis),
            "torus_shape": [torus_rows, torus_columns],
            "translation_orbits": 2,
            "translation_invariance": "physical-and-observability-quotient-verified",
        },
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("x", encoding="utf-8") as stream:
        json.dump(output, stream, separators=(",", ":"), sort_keys=True)
        stream.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
