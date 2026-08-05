#!/usr/bin/env python3
"""Exhaust the natural cross-orbital projection codes for Paper IV."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import math
import subprocess
import tempfile
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GEOMETRY = ROOT / "papers/q13-passant-code/verification/verify_minimum_geometry.py"
CORRESPONDENCE = ROOT / "notes/2026-08-04-c682-paper-iv-orbit-correspondence.py"
RUST = ROOT / "notes/2026-08-04-paper-iv-project-up-optimality.rs"
TRACKED = ROOT / "notes/2026-08-04-paper-iv-project-up-optimality.json"
N = 91
ALL = (1 << N) - 1


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def kernel_basis(rows: list[int]) -> tuple[int, ...]:
    work = rows[:]
    pivots: list[tuple[int, int]] = []
    rank = 0
    for column in range(N):
        pivot = next((row for row in range(rank, len(work)) if work[row] >> column & 1), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        for row in range(len(work)):
            if row != rank and work[row] >> column & 1:
                work[row] ^= work[rank]
        pivots.append((rank, column))
        rank += 1
    pivot_columns = {column for _, column in pivots}
    basis = []
    for free in range(N):
        if free in pivot_columns:
            continue
        vector = 1 << free
        for row, pivot in pivots:
            if work[row] >> free & 1:
                vector |= 1 << pivot
        basis.append(vector)
    return tuple(basis)


def basis_hash(basis: tuple[int, ...]) -> str:
    payload = b"".join(vector.to_bytes(12, "little") for vector in basis)
    return hashlib.sha256(payload).hexdigest()


def binary_rank(rows: tuple[int, ...] | list[int]) -> int:
    pivots: dict[int, int] = {}
    for vector in rows:
        while vector:
            pivot = vector.bit_length() - 1
            if pivot in pivots:
                vector ^= pivots[pivot]
            else:
                pivots[pivot] = vector
                break
    return len(pivots)


def enumerate_small(basis: tuple[int, ...]) -> Counter[int]:
    histogram: Counter[int] = Counter()
    word = previous = 0
    for coefficient in range(1 << len(basis)):
        gray = coefficient ^ (coefficient >> 1)
        if coefficient:
            difference = gray ^ previous
            word ^= basis[(difference & -difference).bit_length() - 1]
        histogram[word.bit_count()] += 1
        previous = gray
    return histogram


def enumerate_rust(binary: Path, basis: tuple[int, ...]) -> dict[str, int]:
    text = "".join(f"{vector & ((1 << 64) - 1):x} {vector >> 64:x}\n" for vector in basis)
    fields = subprocess.check_output([binary], input=text, text=True).split()
    return {"minimum_distance": int(fields[0]), "minimum_count": int(fields[1]), "enumerated": int(fields[2])}


def hamming_upper_bound(dimension: int) -> int:
    redundancy = N - dimension
    radius = -1
    volume = 0
    for candidate in range(N // 2 + 1):
        volume += math.comb(N, candidate)
        if volume <= 1 << redundancy:
            radius = candidate
        else:
            break
    return 2 * radius + 2


def compute() -> dict:
    geometry = load(GEOMETRY, "project_up_geometry")
    bridge = load(CORRESPONDENCE, "project_up_bridge")
    group = tuple(geometry.projective_group())
    left = bridge.transformed_orbit(geometry, group, geometry.REPRESENTATIVES[0])
    right = bridge.transformed_orbit(geometry, group, geometry.REPRESENTATIVES[1])
    left_stabilizers = [bridge.stabilizer(geometry, group, support) for support in left]
    right_stabilizers = [bridge.stabilizer(geometry, group, support) for support in right]

    signatures = sorted(
        {
            (len(left_stabilizers[i] & right_stabilizers[j]), len(set(left[i]) & set(right[j])))
            for i in range(N)
            for j in range(N)
        }
    )
    assert signatures == [(1, 1), (1, 3), (2, 0), (2, 1), (2, 4), (6, 0), (8, 4)]
    orbitals = []
    for signature in signatures:
        rows = [
            sum(
                1 << j
                for j in range(N)
                if (
                    len(left_stabilizers[i] & right_stabilizers[j]),
                    len(set(left[i]) & set(right[j])),
                )
                == signature
            )
            for i in range(N)
        ]
        degrees = {row.bit_count() for row in rows}
        assert len(degrees) == 1
        orbitals.append(rows)
    assert all((sum((orbital[i] for orbital in orbitals), 0) == ALL) for i in range(N))

    kernels: dict[int, dict[tuple[int, ...], list[int]]] = defaultdict(lambda: defaultdict(list))
    mask_dimensions: Counter[int] = Counter()
    for mask in range(1, 1 << len(orbitals)):
        rows = [0] * N
        for index, orbital in enumerate(orbitals):
            if mask >> index & 1:
                rows = [first ^ second for first, second in zip(rows, orbital)]
        basis = kernel_basis(rows)
        kernels[len(basis)][basis].append(mask)
        mask_dimensions[len(basis)] += 1

    with tempfile.TemporaryDirectory(prefix="paper-iv-project-up-") as directory:
        binary = Path(directory) / "enumerator"
        subprocess.run(["rustc", "-O", str(RUST), "-o", str(binary)], check=True)
        enumerated = []
        for dimension in (14, 15, 28, 29):
            for basis, masks in sorted(kernels[dimension].items(), key=lambda item: item[1][0]):
                result = enumerate_rust(binary, basis)
                enumerated.append(
                    {
                        "basis_sha256": basis_hash(basis),
                        "dimension": dimension,
                        "masks_hex": [f"0x{mask:02x}" for mask in masks],
                        **result,
                    }
                )

    selected_even = next(iter(kernels[14]))
    selected_odd = next(iter(kernels[15]))
    even_histogram = enumerate_small(selected_even)
    odd_histogram = enumerate_small(selected_odd)
    assert min(weight for weight in even_histogram if weight) == 28
    assert min(weight for weight in odd_histogram if weight) == 28
    assert binary_rank(selected_even + (ALL,)) == 15
    assert binary_rank(selected_even + (ALL,) + selected_odd) == 15

    large_bounds = {
        str(dimension): hamming_upper_bound(dimension)
        for dimension in sorted(kernels)
        if dimension >= 40
    }
    assert max(large_bounds.values()) <= 26
    assert max(item["minimum_distance"] for item in enumerated) == 28

    return {
        "schema": "paper-iv-project-up-optimality-v1",
        "trusted_inputs": [str(GEOMETRY.relative_to(ROOT)), str(CORRESPONDENCE.relative_to(ROOT)), str(RUST.relative_to(ROOT))],
        "cross_orbital_labels": [
            {"stabilizer_intersection_order": signature[0], "support_intersection": signature[1], "degree": orbitals[index][0].bit_count()}
            for index, signature in enumerate(signatures)
        ],
        "mask_bit_order": [list(signature) for signature in signatures],
        "nonzero_mask_nullity_distribution": {str(key): value for key, value in sorted(mask_dimensions.items())},
        "distinct_kernel_counts": {str(key): len(value) for key, value in sorted(kernels.items())},
        "exhaustively_enumerated_small_kernels": enumerated,
        "hamming_distance_upper_bounds_for_dimension_at_least_40": large_bounds,
        "optimal_code": {
            "description": "kernel of D8 cubic orbital plus the all-ones orbital",
            "mask_hex": "0x3f",
            "parameters": [91, 15, 28],
            "even_subcode_parameters": [91, 14, 28],
            "even_weight_enumerator": [[weight, count] for weight, count in sorted(even_histogram.items())],
            "weight_enumerator": [[weight, count] for weight, count in sorted(odd_histogram.items())],
        },
        "bounded_verdict": "Among kernels of all 127 nonzero sums of the seven cross orbitals, maximum distance is 28 and maximum dimension at distance 28 is 15.",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = compute()
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        if TRACKED.read_text() != text:
            raise SystemExit(f"certificate drift: {TRACKED}")
        print("Paper-IV project-up optimality: PASS")
    elif args.output:
        args.output.write_text(text)
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
