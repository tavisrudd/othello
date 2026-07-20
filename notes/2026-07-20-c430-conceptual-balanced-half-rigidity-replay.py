#!/usr/bin/env python3
"""Independent row-reduction replay for the C430 finite hypotheses."""

from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
CERT_PATH = HERE / "2026-07-20-c430-conceptual-balanced-half-rigidity.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C406 = load_module("c430_replay_c406", C406_PATH)


def rref(matrix, prime):
    work = [[value % prime for value in row] for row in matrix]
    if not work:
        return work, []
    pivot_columns = []
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [value * inverse % prime for value in work[pivot_row]]
        for row in range(len(work)):
            if row == pivot_row or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [
                (left - scale * right) % prime
                for left, right in zip(work[row], work[pivot_row])
            ]
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == len(work):
            break
    return work, pivot_columns


def rank(matrix, prime):
    return len(rref(matrix, prime)[1])


def nullspace(matrix, prime):
    reduced, pivots = rref(matrix, prime)
    columns = len(matrix[0])
    free = [column for column in range(columns) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column] % prime
        basis.append(vector)
    return basis


def transpose(matrix):
    return [list(column) for column in zip(*matrix)]


def symmetric_square(vector, prime):
    return [
        vector[left] * vector[right] % prime
        for left, right in itertools.combinations_with_replacement(
            range(len(vector)), 2
        )
    ]


def canonical(vector, prime):
    pivot = next(value for value in vector if value)
    inverse = pow(pivot, -1, prime)
    return [value * inverse % prime for value in vector]


def replay_case(record):
    name = record["type"]
    prime = record["field_order"]
    conic, parameters = C406.C399.conic_parameterization(prime)
    full_group, psl_group = C406.full_pgl(prime, parameters)
    base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted(
        {C406.matching_image(element, base_matching) for element in full_group}
    )
    index = {matching: position for position, matching in enumerate(orbit)}
    base_product = C406.matching_product(base_matching, tuple(parameters), prime)
    raw_vectors = []
    for matching in orbit:
        product = C406.matching_product(matching, tuple(parameters), prime)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0))
            % prime
            for exponent in set(product) | set(base_product)
        }
        raw_vectors.append(
            C406.quotient_by_conic(difference, (prime + 1) // 2 - 2, prime)
        )
    _reduced, coordinate_pivots = rref(raw_vectors, prime)
    vectors = [
        [vector[column] for column in coordinate_pivots] for vector in raw_vectors
    ]
    assert len(coordinate_pivots) == prime - 1

    sheets = []
    unseen = set(orbit)
    while unseen:
        representative = min(unseen)
        sheet = {
            C406.matching_image(element, representative) for element in psl_group
        }
        unseen -= sheet
        sheets.append(sorted(index[matching] for matching in sheet))
    sheets.sort()
    sign = [1 if position in set(sheets[0]) else -1 % prime for position in range(2 * prime)]

    features = [
        [1] + vector + symmetric_square(vector, prime) for vector in vectors
    ]
    feature_matrix = transpose(features)
    feature_rank = rank(feature_matrix, prime)
    kernel = nullspace(feature_matrix, prime)
    assert feature_rank == 2 * prime - 1
    assert len(kernel) == 1 and canonical(kernel[0], prime) == canonical(sign, prime)

    second_moment = [
        [
            sum(vector[row] * vector[column] for vector in vectors) % prime
            for column in range(prime - 1)
        ]
        for row in range(prime - 1)
    ]
    radical = nullspace(second_moment, prime)
    assert rank(second_moment, prime) == prime - 2 and len(radical) == 1
    radical_covector = canonical(radical[0], prime)
    values = [
        sum(left * right for left, right in zip(radical_covector, vector)) % prime
        for vector in vectors
    ]
    sheet_values = [sorted({values[position] for position in sheet}) for sheet in sheets]
    assert all(len(items) == 1 for items in sheet_values)
    assert sheet_values[0] != sheet_values[1]
    return {
        "type": name,
        "field_order": prime,
        "second_moment_rank": prime - 2,
        "second_moment_radical_dimension": 1,
        "radical_sheet_values": sheet_values,
        "direct_degree_two_rank_crosscheck": feature_rank,
        "direct_trade_kernel_dimension_crosscheck": len(kernel),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", required=True)
    parser.parse_args()
    certificate = json.loads(CERT_PATH.read_text())
    scout = json.loads(C406.SCOUT_PATH.read_text())
    records = [record for record in scout["types"] if record["type"] in ("B3", "H3")]
    replayed = [replay_case(record) for record in records]
    expected = [
        {key: case[key] for key in replayed[index]}
        for index, case in enumerate(certificate["cases"])
    ]
    assert replayed == expected
    print("C430 independent row-reduction replay OK")


if __name__ == "__main__":
    main()
