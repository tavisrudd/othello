#!/usr/bin/env python3
"""Independent stdlib replay for the C958 tangent-quotient infrastructure."""

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def determinant(matrix):
    work = [[Fraction(value) for value in row] for row in matrix]
    result = Fraction(1)
    for column in range(len(work)):
        pivot = next((row for row in range(column, len(work)) if work[row][column]), None)
        if pivot is None:
            return Fraction(0)
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            result = -result
        pivot_value = work[column][column]
        result *= pivot_value
        for row in range(column + 1, len(work)):
            if not work[row][column]:
                continue
            ratio = work[row][column] / pivot_value
            for index in range(column + 1, len(work)):
                work[row][index] -= ratio * work[column][index]
    return result


def canonical(value):
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    arguments = parser.parse_args()
    data = json.loads(arguments.certificate.read_text())
    assert data["schema"] == "c958-type-i1-tangent-quotient-infrastructure-v1"

    for name, expected in data["input_sha256"].items():
        filenames = {
            "split_section": "2026-08-24-c958-generic-split-parametrization.json",
            "descent_action": "2026-08-24-c958-type-i1-descent-action.json",
            "cox_descent": "2026-08-25-c958-type-i1-cox-descent-cocycle.json",
            "full_coboundary": "2026-08-25-c958-type-i1-full-coboundary.json",
        }
        raw = (ROOT / "notes" / filenames[name]).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == expected

    ground = data["ground_coordinate_basis"]
    matrix = ground["matrix_at_specialization"]
    assert len(matrix) == 16 and all(len(row) == 16 for row in matrix)
    det = determinant(matrix)
    assert det != 0
    assert ground["rank"] == 16
    determinant_text = canonical(det)
    assert determinant_text == ground["determinant"]
    assert hashlib.sha256(determinant_text.encode()).hexdigest() == ground["determinant_sha256"]
    assert ground["generator_invariance_at_specialization"] == [True, True, True]

    split = data["split_slice_inverse"]
    coefficient_matrix = split["coefficient_matrix_at_witness"]
    coefficient_det = determinant(coefficient_matrix)
    assert canonical(coefficient_det) == split["coefficient_determinant_at_witness"]
    assert coefficient_det != 0
    assert split["linearity_degrees"] == [1, 1, 1]


if __name__ == "__main__":
    main()
