#!/usr/bin/env python3
"""Independent dense-polynomial replay for C682 all-r Schur signs."""

from __future__ import annotations

import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
EXACT_PATH = HERE / "2026-07-28-c682-klein-e8-free-covariant.py"
CERTIFICATE = HERE / "2026-07-30-c682-all-r-schur.json"
TYPES = (("4", 6), ("4s", 3), ("5", 4), ("6", 5))
CHAIN_RESIDUES = {"4": 4, "4s": 2, "5": 2, "6": 0}
SAMPLES = (6, 13, 37)


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


EXACT = load(EXACT_PATH, "c682_all_r_replay_exact")
TOOLS, KLEIN, _, _, _ = EXACT.build_data()


def dense_chain_matrix(degree, residue, order):
    source = list(range(residue, degree + 1, 5))
    target_degree = degree + 12 - 2 * order
    target_residue = (residue + 1 - order) % 5
    target = list(range(target_residue, target_degree + 1, 5))
    rows = [[0] * len(source) for _ in target]
    for column, index in enumerate(source):
        image = TOOLS.transvectant(
            {(degree - index, index): 1}, KLEIN, order
        )
        for row, target_index in enumerate(target):
            rows[row][column] = image.get(
                (target_degree - target_index, target_index), 0
            )
    return source, target, rows


def boundary_null(rows, side):
    row_count = len(rows)
    column_count = len(rows[0])
    values = {}
    if side == "left":
        support = [row for row in range(row_count) if rows[row][0]]
        assert support == [0, 1]
        values[0] = Fraction(rows[1][0])
        values[1] = Fraction(-rows[0][0])
        columns = range(1, column_count)
        choose_new = max
    else:
        support = [row for row in range(row_count) if rows[row][-1]]
        assert support == [row_count - 2, row_count - 1]
        values[row_count - 2] = Fraction(rows[-1][-1])
        values[row_count - 1] = Fraction(-rows[-2][-1])
        columns = range(column_count - 2, -1, -1)
        choose_new = min
    for column in columns:
        support = [
            row for row in range(row_count) if rows[row][column]
        ]
        new_row = choose_new(support)
        if new_row in values:
            continue
        values[new_row] = -sum(
            Fraction(rows[row][column]) * values[row]
            for row in support
            if row in values
        ) / rows[new_row][column]
        if len(values) == 6:
            return values
    raise AssertionError("boundary recurrence did not reach width six")


def dense_obstruction(label, residue, r):
    degree = residue + 20 * r
    _, current, incoming = dense_chain_matrix(
        degree - 6, CHAIN_RESIDUES[label], 3
    )
    current_residue = current[0] % 5
    current_2, upper, outgoing = dense_chain_matrix(
        degree, current_residue, 3
    )
    upper_2, current_3, ninth = dense_chain_matrix(
        degree + 6, upper[0] % 5, 9
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    side = "left" if label == "6" else "right"
    null = boundary_null(incoming, side)
    indices = sorted(null)
    first, second = (
        indices[:2] if side == "left" else indices[-2:]
    )

    def transpose_action(column):
        return sum(
            null[row]
            * sum(
                ninth[row][middle] * outgoing[middle][column]
                for middle in range(len(upper))
            )
            for row in indices
        )

    return (
        transpose_action(first) * null[second]
        - transpose_action(second) * null[first]
    )


def certified_formula(record, r):
    obstruction = record["boundary_eigen_obstruction"]
    coefficients = obstruction[
        "shifted_numerator_primitive_coefficients"
    ]
    shifted = r - 6
    numerator = Fraction(
        obstruction["shifted_numerator_positive_scale"]
    ) * sum(
        coefficient * shifted**degree
        for degree, coefficient in enumerate(coefficients)
    )
    denominator = Fraction(1)
    for root in obstruction["denominator_roots"]:
        denominator *= Fraction(r) - Fraction(root)
    return numerator / denominator


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    assert certificate["schema"] == "c682-all-r-signed-schur-v1"
    checks = 0
    for label, residue in TYPES:
        record = certificate["types"][f"{label}_{residue}"]
        for r in SAMPLES:
            direct = dense_obstruction(label, residue, r)
            formula = certified_formula(record, r)
            assert direct == formula
            assert direct < 0
            checks += 1
    print(
        "PASS: independent dense-polynomial Schur replay "
        f"({checks} exact comparisons)"
    )


if __name__ == "__main__":
    main()
