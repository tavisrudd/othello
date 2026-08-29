#!/usr/bin/env python3
"""Independently check a paired BB CSS-distance result and X/Z isomorphism."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def packed_rows(rows: list[list[int]]) -> list[int]:
    return [sum(1 << coordinate for coordinate in row) for row in rows]


def row_basis(rows: list[int]) -> dict[int, int]:
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
    return pivots


def same_row_space(left: list[int], right: list[int]) -> bool:
    left_basis = row_basis(left)
    right_basis = row_basis(right)
    if len(left_basis) != len(right_basis):
        return False
    for original in left:
        value = original
        while value:
            pivot = value.bit_length() - 1
            prior = right_basis.get(pivot)
            if prior is None:
                return False
            value ^= prior
    return True


def block_swap_inversion(value: int, torus_rows: int, torus_columns: int) -> int:
    block_size = torus_rows * torus_columns
    result = 0
    while value:
        low = value & -value
        coordinate = low.bit_length() - 1
        value ^= low
        block, offset = divmod(coordinate, block_size)
        row, column = divmod(offset, torus_columns)
        image = (
            (block ^ 1) * block_size
            + ((-row) % torus_rows) * torus_columns
            + (-column) % torus_columns
        )
        result |= 1 << image
    return result


def validate_record(problem: dict, record: dict) -> tuple[int | None, int]:
    result = record["result"]
    distance = result["distance"]
    searched = result["searched_maximum_weight"]
    if searched != record["maximum_weight"] or searched > problem["maximum_weight"]:
        raise RuntimeError("record does not exhaust its stated input radius")
    witness = result["witness"]
    if distance is None:
        if witness:
            raise RuntimeError("bounded miss retains a witness")
        return None, searched
    support = set(witness)
    if len(support) != len(witness) or len(witness) != distance:
        raise RuntimeError("witness weight is invalid")
    if any(sum(coordinate in support for coordinate in row) & 1 for row in problem["physical_checks"]):
        raise RuntimeError("witness has nonzero physical syndrome")
    if not any(
        sum(coordinate in support for coordinate in row) & 1
        for row in problem["logical_observations"]
    ):
        raise RuntimeError("witness is logically trivial")
    return distance, searched


def load_record(path: Path) -> dict:
    records = [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]
    if len(records) != 1:
        raise RuntimeError(f"{path}: expected exactly one evidence record")
    return records[0]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--first-input", type=Path, required=True)
    parser.add_argument("--second-input", type=Path, required=True)
    parser.add_argument("--first-evidence", type=Path, required=True)
    parser.add_argument("--second-evidence", type=Path)
    args = parser.parse_args()

    first = json.loads(args.first_input.read_text(encoding="utf-8"))
    second = json.loads(args.second_input.read_text(encoding="utf-8"))
    if first["coordinate_count"] != second["coordinate_count"]:
        raise RuntimeError("paired inputs have different coordinate counts")
    shape = first.get("metadata", {}).get("torus_shape")
    if shape != second.get("metadata", {}).get("torus_shape") or not shape:
        raise RuntimeError("paired inputs have no common torus shape")
    torus_rows, torus_columns = shape
    if first["coordinate_count"] != 2 * torus_rows * torus_columns:
        raise RuntimeError("torus shape does not cover both coordinate blocks")

    first_physical = packed_rows(first["physical_checks"])
    second_physical = packed_rows(second["physical_checks"])
    first_observable = first_physical + packed_rows(first["logical_observations"])
    second_observable = second_physical + packed_rows(second["logical_observations"])
    if not same_row_space(
        [block_swap_inversion(row, torus_rows, torus_columns) for row in first_physical],
        second_physical,
    ):
        raise RuntimeError("block-swap inversion does not preserve physical constraints")
    if not same_row_space(
        [block_swap_inversion(row, torus_rows, torus_columns) for row in first_observable],
        second_observable,
    ):
        raise RuntimeError("block-swap inversion does not preserve observability")

    first_record = load_record(args.first_evidence)
    distance, searched = validate_record(first, first_record)
    if distance is None:
        raise RuntimeError("first evidence has no witness to transport")
    transported = block_swap_inversion(
        sum(1 << coordinate for coordinate in first_record["result"]["witness"]),
        torus_rows,
        torus_columns,
    )
    transported_support = {index for index in range(first["coordinate_count"]) if transported >> index & 1}
    if len(transported_support) != distance:
        raise RuntimeError("transported witness changes weight")
    if any(
        sum(coordinate in transported_support for coordinate in row) & 1
        for row in second["physical_checks"]
    ):
        raise RuntimeError("transported witness has nonzero physical syndrome")
    if not any(
        sum(coordinate in transported_support for coordinate in row) & 1
        for row in second["logical_observations"]
    ):
        raise RuntimeError("transported witness is logically trivial")

    second_checked = False
    if args.second_evidence is not None:
        second_distance, second_searched = validate_record(
            second, load_record(args.second_evidence)
        )
        if (second_distance, second_searched) != (distance, searched):
            raise RuntimeError("paired exhaustive results disagree")
        second_checked = True

    output = {
        "schema": "ergodis-qdist-bb-pair-check-v1",
        "coordinate_count": first["coordinate_count"],
        "distance": distance,
        "searched_maximum_weight": searched,
        "second_exhaustive_record_checked": second_checked,
        "transported_witness": sorted(transported_support),
        "x_z_isomorphism": "block-swap-plus-torus-inversion",
    }
    print(json.dumps(output, separators=(",", ":"), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
