#!/usr/bin/env python3
"""Independent entry point for the C682 golden/E8 descent certificate."""

from __future__ import annotations

import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIMARY = HERE / "2026-07-30-c682-golden-e8-descent.py"
CERTIFICATE = HERE / "2026-07-30-c682-golden-e8-descent.json"
STANDARD_KLEIN = HERE / "2026-07-28-c682-klein-e8-operator-algebra.py"


def load_primary():
    spec = importlib.util.spec_from_file_location("c682_golden_e8_descent", PRIMARY)
    if spec is None or spec.loader is None:
        raise AssertionError("could not load primary certificate builder")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def load_standard_klein():
    spec = importlib.util.spec_from_file_location(
        "c682_standard_klein_operator",
        STANDARD_KLEIN,
    )
    if spec is None or spec.loader is None:
        raise AssertionError("could not load standard Klein checker")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> None:
    primary = load_primary()
    rebuilt = primary.build_certificate()
    stored = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    if rebuilt != stored:
        raise AssertionError("stored certificate differs from exact rebuild")
    bridge = rebuilt["bridge"]
    graded = rebuilt["graded_lift"]
    if not bridge["not_just_character_comparison"]:
        raise AssertionError("operator-level bridge was not certified")
    if graded["same_tower_no_go"]["first_dimension_mismatch_degree"] != 2:
        raise AssertionError("same-tower obstruction moved")
    if (
        graded["correct_bi_mckay_descent"]["recurrence_check_through_degree"]
        != 180
    ):
        raise AssertionError("bi-McKay replay depth changed")
    conference = rebuilt["six_axis_harmonic_model"]["conference_matrix"]
    square = [
        [
            sum(
                conference[row][middle] * conference[middle][column]
                for middle in range(6)
            )
            for column in range(6)
        ]
        for row in range(6)
    ]
    if square != [
        [5 * int(row == column) for column in range(6)]
        for row in range(6)
    ]:
        raise AssertionError("stored conference matrix does not square to five")

    # Independent cross-marking invariant: use the older rational Klein form,
    # not the golden-axis form or its degree-ten basis.
    standard = load_standard_klein()
    operator = standard.gram_operator(10)
    trace = standard.matrix_trace(operator)
    trace_square = standard.matrix_trace(
        standard.matrix_multiply(operator, operator)
    )
    # Spectrum shape is 0^3, lambda_5^5, lambda_3p^3.  Solve its first two
    # moments and select lambda_5 by evaluating on im(Delta_4)=the 5-block.
    delta_four = standard.delta_matrix(4)
    vector = [row[0] for row in delta_four]
    image = [
        sum(entry * value for entry, value in zip(row, vector))
        for row in operator
    ]
    lambda_five = next(
        image_value / vector_value
        for image_value, vector_value in zip(image, vector)
        if vector_value
    )
    if any(
        image_value != lambda_five * vector_value
        for image_value, vector_value in zip(image, vector)
    ):
        raise AssertionError("standard Klein 5-block is not scalar")
    lambda_three_prime = (trace - 5 * lambda_five) / 3
    if (
        5 * lambda_five**2 + 3 * lambda_three_prime**2
        != trace_square
    ):
        raise AssertionError("standard Klein spectral moments disagree")
    if lambda_three_prime / lambda_five != Fraction(143, 108):
        raise AssertionError("standard and golden markings have different spectra")
    if standard.mckay_decomposition(16).get("3", 0):
        raise AssertionError("degree-sixteen target unexpectedly contains 3")
    print(
        "PASS: exact degree-ten Klein return equals an affine golden "
        "conference generator; Galois kernels exchange; same-tower "
        "graded descent fails first in degree 2; paired E8 McKay towers "
        "match through degree 180; independent rational Klein marking "
        "reproduces the 143/108 spectral ratio"
    )


if __name__ == "__main__":
    main()
