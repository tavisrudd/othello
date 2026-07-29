#!/usr/bin/env python3
"""Certify the bounded two-sided Klein defect spectrum for C682."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from concurrent.futures import ProcessPoolExecutor
from fractions import Fraction
from functools import reduce
from math import factorial, gcd, lcm
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
CERTIFICATE = HERE / "2026-07-29-c682-two-sided-defect-spectrum.json"
PRIMES = (1_000_000_007, 1_000_000_009)
STOP = 300
EXPECTED = {
    0: 1,
    1: 2,
    2: 3,
    6: 3,
    10: 3,
    11: 2,
    12: 1,
    20: 1,
    21: 2,
    22: 3,
    32: 1,
    40: 1,
    52: 1,
}
DIMENSIONS = {
    "1": 1,
    "2": 2,
    "2p": 2,
    "3": 3,
    "3p": 3,
    "4": 4,
    "4s": 4,
    "5": 5,
    "6": 6,
}


def load_base():
    spec = importlib.util.spec_from_file_location("defect_spectrum_base", BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load modular Klein engine")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def modular_nullity(base, degree: int, prime: int) -> int:
    rows = base.delta_matrix(degree, prime)
    if degree >= 6:
        rows += base.adjoint(
            base.delta_matrix(degree - 6, prime),
            degree - 6,
            prime,
        )
    return degree + 1 - base.matrix_rank(rows, prime)


def sweep_prime(arguments: tuple[int, int]) -> dict[int, int]:
    prime, stop = arguments
    base = load_base()
    return {
        degree: nullity
        for degree in range(stop + 1)
        if (nullity := modular_nullity(base, degree, prime))
    }


def exact_delta_matrix(source_degree: int) -> list[list[Fraction]]:
    base = load_base()
    columns = [
        base.transvectant_z(
            {(source_degree - index, index): 1},
            base.KLEIN,
            3,
        )
        for index in range(source_degree + 1)
    ]
    return [
        [
            Fraction(
                column.get((source_degree + 6 - row, row), 0)
            )
            for column in columns
        ]
        for row in range(source_degree + 7)
    ]


def exact_adjoint(
    matrix: list[list[Fraction]],
    source_degree: int,
) -> list[list[Fraction]]:
    return [
        [
            matrix[target_index][source_index]
            * Fraction(
                factorial(source_degree + 6 - target_index)
                * factorial(target_index),
                factorial(source_degree - source_index)
                * factorial(source_index),
            )
            for target_index in range(source_degree + 7)
        ]
        for source_index in range(source_degree + 1)
    ]


def exact_stacked_matrix(degree: int) -> list[list[Fraction]]:
    rows = exact_delta_matrix(degree)
    if degree >= 6:
        rows += exact_adjoint(
            exact_delta_matrix(degree - 6),
            degree - 6,
        )
    return rows


def rref(
    matrix: list[list[Fraction]],
) -> tuple[list[list[Fraction]], list[int]]:
    rows = [row[:] for row in matrix]
    if not rows:
        return rows, []
    pivot_columns = []
    pivot_row = 0
    for column in range(len(rows[0])):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(rows))
                if rows[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        scale = rows[pivot_row][column]
        rows[pivot_row] = [entry / scale for entry in rows[pivot_row]]
        for row in range(len(rows)):
            if row == pivot_row or not rows[row][column]:
                continue
            scale = rows[row][column]
            rows[row] = [
                entry - scale * pivot_entry
                for entry, pivot_entry in zip(rows[row], rows[pivot_row])
            ]
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == len(rows):
            break
    return rows, pivot_columns


def primitive_integer_vector(vector: list[Fraction]) -> list[int]:
    denominator = reduce(lcm, (entry.denominator for entry in vector), 1)
    integers = [entry.numerator * (denominator // entry.denominator) for entry in vector]
    content = reduce(gcd, (abs(entry) for entry in integers if entry), 0)
    integers = [entry // content for entry in integers]
    first = next(entry for entry in integers if entry)
    if first < 0:
        integers = [-entry for entry in integers]
    return integers


def exact_nullspace(matrix: list[list[Fraction]]) -> list[list[int]]:
    reduced, pivots = rref(matrix)
    column_count = len(matrix[0])
    free = [column for column in range(column_count) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [Fraction(0) for _ in range(column_count)]
        vector[free_column] = Fraction(1)
        for row, pivot_column in enumerate(pivots):
            vector[pivot_column] = -reduced[row][free_column]
        basis.append(primitive_integer_vector(vector))
    return basis


def annihilates(
    matrix: list[list[Fraction]],
    vectors: list[list[int]],
) -> bool:
    return all(
        all(
            sum(entry * coefficient for entry, coefficient in zip(row, vector))
            == 0
            for row in matrix
        )
        for vector in vectors
    )


def basis_digest(basis: list[list[int]]) -> str:
    payload = json.dumps(basis, separators=(",", ":")).encode("ascii")
    return hashlib.sha256(payload).hexdigest()


def isotypic_candidates(degree: int, nullity: int) -> tuple[list[str], list[str]]:
    decomposition = load_base().mckay_decomposition(degree)
    candidates = [
        module
        for module, multiplicity in decomposition.items()
        if multiplicity and DIMENSIONS[module] == nullity
    ]
    repeated = [
        module
        for module in candidates
        if decomposition[module] >= 2
    ]
    return candidates, repeated


def make_certificate(
    primes: tuple[int, int] = PRIMES,
    stop: int = STOP,
) -> dict:
    with ProcessPoolExecutor(max_workers=2) as executor:
        spectra = list(
            executor.map(
                sweep_prime,
                [(prime, stop) for prime in primes],
            )
        )
    assert spectra[0] == spectra[1] == EXPECTED

    rows = []
    for degree, nullity in EXPECTED.items():
        matrix = exact_stacked_matrix(degree)
        basis = exact_nullspace(matrix)
        assert len(basis) == nullity
        assert annihilates(matrix, basis)
        candidates, repeated = isotypic_candidates(degree, nullity)
        rows.append(
            {
                "degree": degree,
                "exact_nullity": nullity,
                "exact_rank": degree + 1 - nullity,
                "primitive_integer_kernel_basis_sha256": basis_digest(basis),
                "isotypic_candidates_by_dimension": candidates,
                "repeated_isotypic_candidates": repeated,
            }
        )

    repeated_rows = [
        [row["degree"], row["repeated_isotypic_candidates"]]
        for row in rows
        if row["repeated_isotypic_candidates"]
    ]
    assert repeated_rows == [[22, ["3"]]]

    return {
        "schema": "c682-two-sided-defect-spectrum-v1",
        "operator": (
            "Q_n=(Delta_n,Delta_{n-6}^dagger), "
            "Delta=(.,Phi_12)_3"
        ),
        "searched_domain": f"all integer degrees 0..{stop}",
        "modular_fields": [f"F_{prime}" for prime in primes],
        "two_prime_spectrum": {
            str(degree): nullity
            for degree, nullity in spectra[0].items()
        },
        "exact_exception_rows": rows,
        "relevant_repeated_defects": repeated_rows,
        "conclusion": (
            "In degrees 0..300, degree 22 is the unique two-sided defect "
            "whose dimension can occupy a repeated isotypic summand; it is "
            "the standard 3 in Sym^22."
        ),
        "claim_boundary": (
            "The exceptional degrees are exact over Q, and absence elsewhere "
            "in 0..300 is certified over two finite fields. This is finite "
            "evidence, not a proof of absence above degree 300."
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(
        make_certificate(),
        indent=2,
        sort_keys=True,
    ) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 two-sided defect spectrum")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
