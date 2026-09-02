#!/usr/bin/env python3
"""Independent replay of an Ergodis CSS isomorphism admission record."""

from __future__ import annotations

import argparse
import json
import subprocess
from pathlib import Path
from typing import Any


def load_object(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_bytes())
    if not isinstance(value, dict):
        raise ValueError(f"{path}: expected a JSON object")
    return value


def blake3(path: Path) -> str:
    output = subprocess.run(
        ["b3sum", "--no-names", str(path)],
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    return output.strip()


def sparse_rows(rows: object, columns: int) -> list[int]:
    if not isinstance(rows, list):
        raise ValueError("matrix rows must be a list")
    output: list[int] = []
    for row in rows:
        if not isinstance(row, list):
            raise ValueError("matrix row must be a list")
        word = 0
        for coordinate in row:
            if not isinstance(coordinate, int) or not 0 <= coordinate < columns:
                raise ValueError("matrix coordinate is out of range")
            bit = 1 << coordinate
            if word & bit:
                raise ValueError("matrix row repeats a coordinate")
            word |= bit
        output.append(word)
    return output


def canonical_basis(rows: list[int]) -> tuple[int, ...]:
    basis: dict[int, int] = {}
    for source in rows:
        row = source
        while row:
            pivot = row.bit_length() - 1
            if pivot not in basis:
                basis[pivot] = row
                break
            row ^= basis[pivot]
    for pivot in sorted(basis):
        mask = 1 << pivot
        for higher in tuple(index for index in basis if index > pivot):
            if basis[higher] & mask:
                basis[higher] ^= basis[pivot]
    return tuple(basis[pivot] for pivot in sorted(basis, reverse=True))


def permute_rows(rows: list[int], images: list[int]) -> list[int]:
    output: list[int] = []
    for row in rows:
        mapped = 0
        while row:
            bit = row & -row
            mapped |= 1 << images[bit.bit_length() - 1]
            row ^= bit
        output.append(mapped)
    return output


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("target", type=Path)
    parser.add_argument("admission", type=Path)
    args = parser.parse_args()

    source = load_object(args.source)
    target = load_object(args.target)
    admission = load_object(args.admission)
    if admission.get("schema") != "ergodis-css-isomorphism-admission-v1":
        raise ValueError("unsupported admission schema")
    if admission.get("source_blake3") != blake3(args.source):
        raise ValueError("source fingerprint mismatch")
    if admission.get("target_blake3") != blake3(args.target):
        raise ValueError("target fingerprint mismatch")

    columns = source.get("coordinate_count")
    if not isinstance(columns, int) or columns <= 0 or target.get("coordinate_count") != columns:
        raise ValueError("coordinate counts differ")
    images = admission.get("coordinate_images")
    if (
        not isinstance(images, list)
        or len(images) != columns
        or any(not isinstance(image, int) for image in images)
        or sorted(images) != list(range(columns))
    ):
        raise ValueError("coordinate images are not a permutation")

    source_physical = sparse_rows(source.get("physical_checks"), columns)
    source_logical = sparse_rows(source.get("logical_observations"), columns)
    target_physical = sparse_rows(target.get("physical_checks"), columns)
    target_logical = sparse_rows(target.get("logical_observations"), columns)
    mapped_physical = canonical_basis(permute_rows(source_physical, images))
    target_physical_basis = canonical_basis(target_physical)
    mapped_observable = canonical_basis(
        permute_rows(source_physical + source_logical, images)
    )
    target_observable = canonical_basis(target_physical + target_logical)
    if mapped_physical != target_physical_basis:
        raise ValueError("physical row spaces differ")
    if mapped_observable != target_observable:
        raise ValueError("observable row spaces differ")
    if admission.get("physical_rank") != len(mapped_physical):
        raise ValueError("physical rank mismatch")
    if admission.get("observable_rank") != len(mapped_observable):
        raise ValueError("observable rank mismatch")
    print(
        json.dumps(
            {
                "coordinate_count": columns,
                "physical_rank": len(mapped_physical),
                "observable_rank": len(mapped_observable),
                "status": "verified",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
