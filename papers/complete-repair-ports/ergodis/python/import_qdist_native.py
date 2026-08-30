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


def permute_cyclic_blocks(value: int, block_size: int) -> int:
    result = 0
    while value:
        low = value & -value
        coordinate = low.bit_length() - 1
        value ^= low
        block, offset = divmod(coordinate, block_size)
        result |= 1 << (block * block_size + (offset + 1) % block_size)
    return result


def permute_global_shift(value: int, coordinate_count: int, step: int) -> int:
    result = 0
    while value:
        low = value & -value
        coordinate = low.bit_length() - 1
        value ^= low
        result |= 1 << ((coordinate + step) % coordinate_count)
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


def translation_preserves(
    physical: list[int],
    physical_basis: list[int],
    observable: list[int],
    observable_basis: list[int],
    block_size: int,
    rows: int,
    columns: int,
) -> bool:
    for axis in (0, 1):
        translated_physical = [
            permute(row, block_size, rows, columns, axis) for row in physical
        ]
        translated_observable = [
            permute(row, block_size, rows, columns, axis) for row in observable
        ]
        if not is_contained(translated_physical, physical_basis):
            return False
        if not is_contained(translated_observable, observable_basis):
            return False
    return True


def discover_torus_shape(
    physical: list[int],
    physical_basis: list[int],
    observable: list[int],
    observable_basis: list[int],
    coordinate_count: int,
) -> tuple[int, int] | None:
    if coordinate_count % 2:
        return None
    block_size = coordinate_count // 2
    shapes = [
        (rows, block_size // rows)
        for rows in range(1, int(block_size**0.5) + 1)
        if block_size % rows == 0
    ]
    shapes += [(columns, rows) for rows, columns in shapes if rows != columns]
    shapes.sort(key=lambda shape: (abs(shape[0] - shape[1]), shape))
    for rows, columns in shapes:
        if translation_preserves(
            physical,
            physical_basis,
            observable,
            observable_basis,
            block_size,
            rows,
            columns,
        ):
            return rows, columns
    return None


def discover_cyclic_block_size(
    physical: list[int],
    physical_basis: list[int],
    observable: list[int],
    observable_basis: list[int],
    coordinate_count: int,
) -> int | None:
    block_sizes = [
        size
        for size in range(2, coordinate_count + 1)
        if coordinate_count % size == 0
    ]
    for block_size in reversed(block_sizes):
        translated_physical = [
            permute_cyclic_blocks(row, block_size) for row in physical
        ]
        if not is_contained(translated_physical, physical_basis):
            continue
        translated_observable = [
            permute_cyclic_blocks(row, block_size) for row in observable
        ]
        if is_contained(translated_observable, observable_basis):
            return block_size
    return None


def discover_global_shift(
    physical: list[int],
    physical_basis: list[int],
    observable: list[int],
    observable_basis: list[int],
    coordinate_count: int,
) -> int | None:
    steps = [
        step
        for step in range(1, coordinate_count)
        if coordinate_count % step == 0
    ]
    steps.sort(key=lambda step: (step, -coordinate_count // step))
    for step in steps:
        translated_physical = [
            permute_global_shift(row, coordinate_count, step) for row in physical
        ]
        if not is_contained(translated_physical, physical_basis):
            continue
        translated_observable = [
            permute_global_shift(row, coordinate_count, step) for row in observable
        ]
        if is_contained(translated_observable, observable_basis):
            return step
    return None


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--physical", type=Path, required=True)
    parser.add_argument("--logical", type=Path, required=True)
    parser.add_argument("--label", required=True)
    parser.add_argument("--maximum-weight", type=int, required=True)
    symmetry = parser.add_mutually_exclusive_group()
    symmetry.add_argument("--torus-shape", help="rows,columns per coordinate block")
    symmetry.add_argument(
        "--auto-torus",
        action="store_true",
        help="use a two-block torus quotient only after verifying both translations",
    )
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    physical, columns = read_dense(args.physical)
    logical_raw, logical_columns = read_dense(args.logical)
    if columns != logical_columns:
        raise RuntimeError("physical and logical matrix widths differ")
    physical_basis = row_basis(physical)
    logical_basis = row_basis(logical_raw)
    observable_basis = row_basis(physical + logical_basis)
    observable_rank = len(observable_basis) - len(physical_basis)
    if observable_rank != len(logical_basis):
        raise RuntimeError("logical rows are not independent modulo the physical constraints")

    observable = physical + logical_basis
    torus_shape: tuple[int, int] | None = None
    cyclic_block_size: int | None = None
    global_shift: int | None = None
    if args.torus_shape is not None:
        try:
            torus_shape = tuple(int(part) for part in args.torus_shape.split(","))
        except ValueError:
            raise RuntimeError("--torus-shape must be rows,columns") from None
        if len(torus_shape) != 2 or min(torus_shape) <= 0:
            raise RuntimeError("--torus-shape must contain two positive dimensions")
        if columns != 2 * torus_shape[0] * torus_shape[1]:
            raise RuntimeError("matrix widths do not match the two-block torus shape")
        if not translation_preserves(
            physical,
            physical_basis,
            observable,
            observable_basis,
            columns // 2,
            *torus_shape,
        ):
            raise RuntimeError("torus translations do not preserve the imported problem")
    elif args.auto_torus:
        found_global_shift = discover_global_shift(
            physical, physical_basis, observable, observable_basis, columns
        )
        found_cyclic_block_size = discover_cyclic_block_size(
            physical, physical_basis, observable, observable_basis, columns
        )
        found_torus_shape = discover_torus_shape(
            physical,
            physical_basis,
            observable,
            observable_basis,
            columns,
        )
        choices: list[tuple[int, str, object]] = []
        if found_global_shift is not None:
            choices.append((found_global_shift, "global", found_global_shift))
        if found_cyclic_block_size is not None:
            choices.append(
                (columns // found_cyclic_block_size, "cyclic", found_cyclic_block_size)
            )
        if found_torus_shape is not None:
            choices.append((2, "torus", found_torus_shape))
        if choices:
            _, symmetry_kind, symmetry_value = min(choices, key=lambda choice: choice[:2])
            if symmetry_kind == "global":
                global_shift = int(symmetry_value)
            elif symmetry_kind == "cyclic":
                cyclic_block_size = int(symmetry_value)
            else:
                torus_shape = symmetry_value  # type: ignore[assignment]

    if global_shift is not None:
        anchors = list(range(global_shift))
        translation_invariance = "physical-and-observability-global-shift-quotient-verified"
    elif cyclic_block_size is not None:
        anchors = list(range(0, columns, cyclic_block_size))
        translation_invariance = "physical-and-observability-cyclic-quotient-verified"
    elif torus_shape is None:
        anchors = list(range(columns))
        translation_invariance = "none-used-all-coordinate-anchors"
    else:
        anchors = [0, columns // 2]
        translation_invariance = "physical-and-observability-quotient-verified"

    output = {
        "label": args.label,
        "coordinate_count": columns,
        "physical_checks": sparse_rows(physical),
        "logical_observations": sparse_rows(logical_basis),
        "anchors": anchors,
        "maximum_weight": args.maximum_weight,
        "metadata": {
            "source_schema": "QDistSAT-dense-binary-v1",
            "physical_sha256": sha256(args.physical),
            "logical_sha256": sha256(args.logical),
            "physical_rows": len(physical),
            "physical_rank": len(physical_basis),
            "logical_source_rows": len(logical_raw),
            "logical_observation_rank": len(logical_basis),
            "torus_shape": list(torus_shape) if torus_shape is not None else None,
            "cyclic_block_size": cyclic_block_size,
            "global_shift": global_shift,
            "translation_orbits": len(anchors),
            "translation_invariance": translation_invariance,
        },
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("x", encoding="utf-8") as stream:
        json.dump(output, stream, separators=(",", ":"), sort_keys=True)
        stream.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
