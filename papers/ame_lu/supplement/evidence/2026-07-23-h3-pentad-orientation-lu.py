#!/usr/bin/env python3
"""Exact certificate for C546's odd-pentad local-Clifford lift."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from pathlib import Path
from typing import Sequence

HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-07-23-c402-h3-ame-uniform-lu-separation.py"
INPUT_SHA256 = "914fc8b57af5a14035fd5d2cc4cf7902388c7d15bcdd831e834518aecf2b2627"
CERTIFICATE = HERE / "2026-07-23-c546-h3-pentad-orientation-lu.json"
PERMUTATION = (0, 1, 4, 5, 3, 2)
PENTAD = frozenset(
    ("01|23|45", "02|15|34", "03|14|25", "04|12|35", "05|13|24")
)


def load_c402():
    digest = hashlib.sha256(INPUT.read_bytes()).hexdigest()
    if digest != INPUT_SHA256:
        raise AssertionError(f"stale C402 input: {digest}")
    spec = importlib.util.spec_from_file_location("c402_c546_input", INPUT)
    if spec is None or spec.loader is None:
        raise AssertionError("cannot load C402 input")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


C402 = load_c402()


def determinant3(entries):
    return (
        entries[0] * (entries[4] * entries[8] - entries[5] * entries[7])
        - entries[1] * (entries[3] * entries[8] - entries[5] * entries[6])
        + entries[2] * (entries[3] * entries[7] - entries[4] * entries[6])
    )


def matrix_vector(entries, vector, zero):
    return tuple(
        sum((entries[3 * row + column] * vector[column] for column in range(3)), zero)
        for row in range(3)
    )


def matching_name(matching: Sequence[tuple[int, int]]) -> str:
    return "|".join(
        f"{a}{b}" for a, b in sorted(tuple(sorted(edge)) for edge in matching)
    )


def preserves_pentad(permutation: Sequence[int]) -> bool:
    image = set()
    for name in PENTAD:
        matching = tuple((int(edge[0]), int(edge[1])) for edge in name.split("|"))
        image.add(
            matching_name(
                tuple((permutation[a], permutation[b]) for a, b in matching)
            )
        )
    return frozenset(image) == PENTAD


def exact_integral_identity() -> dict[str, object]:
    z, o, tau = C402.GOLDEN_ZERO, C402.GOLDEN_ONE, C402.TAU
    points = (
        (z, o, o - tau),
        (z, o, tau - o),
        (o, o - tau, z),
        (o, tau - o, z),
        (o, z, -tau),
        (o, z, tau),
    )
    parity_check = tuple(
        tuple(points[column][row] for column in range(6)) for row in range(3)
    )
    generator = C402.nullspace_generic(
        parity_check, 6, z, o, lambda value: value.inverse()
    )
    generator_points = tuple(
        tuple(generator[row][column] for row in range(3)) for column in range(6)
    )
    matrix = (
        tau - o,
        o - tau,
        o - tau,
        z,
        tau - 2,
        o + o - tau,
        o,
        z,
        z,
    )
    multipliers = (o, -o, tau - o, tau - o, o - tau, o - tau)
    for column, source in enumerate(generator_points):
        target = points[PERMUTATION[column]]
        actual = matrix_vector(matrix, source, z)
        expected = tuple(multipliers[column] * value for value in target)
        if actual != expected:
            raise AssertionError(f"integral isodual identity fails at column {column}")
    determinant = determinant3(matrix)
    if determinant.norm() != -4:
        raise AssertionError("unexpected projectivity determinant norm")
    if tuple(multiplier.norm() for multiplier in multipliers) != (1, 1, -1, -1, -1, -1):
        raise AssertionError("unexpected multiplier norms")
    if C402.permutation_even(PERMUTATION) or not preserves_pentad(PERMUTATION):
        raise AssertionError("representative must be in the odd pentad coset")
    return {
        "base_ring": "Z[tau], tau^2=tau+1",
        "permutation_zero_based": list(PERMUTATION),
        "permutation_cycles": "(2 4 3 5)",
        "permutation_is_odd": True,
        "permutation_preserves_pentad": True,
        "projectivity_matrix": [
            [matrix[3 * row + column].display() for column in range(3)]
            for row in range(3)
        ],
        "projectivity_determinant": determinant.display(),
        "projectivity_determinant_norm": int(determinant.norm()),
        "coordinate_multipliers": [value.display() for value in multipliers],
        "coordinate_multiplier_norms": [int(value.norm()) for value in multipliers],
        "identity": "A*G_col(j)=lambda_j*H_col(permutation(j)) for all six columns",
        "odd_reduction_boundary": (
            "determinant norm -4 and multiplier norms +/-1 make the identity "
            "invertible over every odd residue field"
        ),
    }


def mod_det3(entries: Sequence[int], q: int) -> int:
    return (
        entries[0] * (entries[4] * entries[8] - entries[5] * entries[7])
        - entries[1] * (entries[3] * entries[8] - entries[5] * entries[6])
        + entries[2] * (entries[3] * entries[7] - entries[4] * entries[6])
    ) % q


def projective_isodual_permutations(q: int, tau: int) -> tuple[tuple[int, ...], ...]:
    C402.Q = q
    columns = (
        (0, 1, 1 - tau),
        (0, 1, tau - 1),
        (1, 1 - tau, 0),
        (1, tau - 1, 0),
        (1, 0, -tau),
        (1, 0, tau),
    )
    parity_check = tuple(
        tuple(columns[column][row] % q for column in range(6)) for row in range(3)
    )
    generator = C402.mod_nullspace(parity_check, 6)
    generator_points = tuple(
        tuple(generator[row][column] for row in range(3)) for column in range(6)
    )
    parity_points = tuple(
        tuple(parity_check[row][column] for row in range(3)) for column in range(6)
    )
    result: list[tuple[int, ...]] = []
    for permutation in itertools.permutations(range(6)):
        equations: list[tuple[int, ...]] = []
        for column, source in enumerate(generator_points):
            target = parity_points[permutation[column]]
            for first, second in ((0, 1), (0, 2), (1, 2)):
                row = [0] * 9
                for index in range(3):
                    row[3 * first + index] = (
                        row[3 * first + index] + source[index] * target[second]
                    ) % q
                    row[3 * second + index] = (
                        row[3 * second + index] - source[index] * target[first]
                    ) % q
                equations.append(tuple(row))
        solutions = C402.mod_nullspace(tuple(equations), 9)
        if len(solutions) == 1 and mod_det3(solutions[0], q):
            result.append(tuple(permutation))
    return tuple(result)


def field_replay(q: int, tau: int) -> dict[str, object]:
    permutations = projective_isodual_permutations(q, tau)
    odd = tuple(
        permutation
        for permutation in permutations
        if not C402.permutation_even(permutation)
    )
    pentad = tuple(permutation for permutation in permutations if preserves_pentad(permutation))
    if len(permutations) != 60 or odd != permutations or pentad != permutations:
        raise AssertionError(f"unexpected isodual coset over F_{q}")
    if PERMUTATION not in permutations:
        raise AssertionError("integral representative missing from field replay")
    return {
        "field": f"F_{q}",
        "tau": tau,
        "permutations_checked": 720,
        "projective_isodualities": len(permutations),
        "odd_isodualities": len(odd),
        "pentad_stabilizing_isodualities": len(pentad),
        "contains_integral_representative": True,
        "isodual_permutations": [list(permutation) for permutation in permutations],
    }


def build_certificate() -> dict[str, object]:
    return {
        "schema": "c546-h3-pentad-orientation-lu-v1",
        "input": {
            "path": INPUT.name,
            "sha256": INPUT_SHA256,
        },
        "integral_isoduality": exact_integral_identity(),
        "field_replays": [
            field_replay(11, 8),
            field_replay(19, 5),
        ],
        "fourier_lift": {
            "convention": (
                "F|x>=q^(-1/2) sum_y chi(x*y)|y>; "
                "F^(tensor 6)|Psi_C>=|Psi_(C^perp)>"
            ),
            "proof": (
                "The coefficient at y is q^(-9/2) sum_(c in C) chi(c dot y), "
                "which is q^(-3/2) exactly for y in C^perp and zero otherwise."
            ),
            "conclusion": (
                "Compose F^(tensor 6) with the integral coordinate monomial "
                "isoduality to obtain an odd party-permuting local-Clifford "
                "automorphism in every odd reduction."
            ),
        },
        "verdict": {
            "orientation": "LU-forgettable",
            "strength": "explicit local-Clifford lift",
            "odd_characteristic_exceptions": [],
            "characteristic_two": "projectivity determinant norm -4 vanishes; not claimed",
        },
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(build_certificate())
    if args.write:
        CERTIFICATE.write_bytes(generated)
        print(f"wrote {CERTIFICATE.name} ({len(generated)} bytes)")
        return
    tracked = CERTIFICATE.read_bytes()
    if tracked != generated:
        raise SystemExit("certificate is stale; rerun with --write")
    print(
        "C546 certificate OK: integral odd pentad isoduality; "
        "60/60 odd projective isodualities at q=11 and q=19"
    )


if __name__ == "__main__":
    main()
