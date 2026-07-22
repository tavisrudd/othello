#!/usr/bin/env python3
"""Independent algebraic replay for the C454 Klein-cubic certificate."""

from __future__ import annotations

import hashlib
import itertools
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-21-c454-klein-cubic.json"


def rank(matrix, prime):
    work = [[value % prime for value in row] for row in matrix]
    row_count = len(work)
    column_count = len(work[0]) if work else 0
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        scale = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [scale * value % prime for value in work[pivot_row]]
        for row in range(row_count):
            if row == pivot_row or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [
                (left - scale * right) % prime
                for left, right in zip(work[row], work[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


def column_rank(columns, prime):
    return rank([list(row) for row in zip(*columns)], prime) if columns else 0


def symmetric_cube_columns(columns, prime):
    output_dimension = len(columns[0])
    input_dimension = len(columns)
    output_basis = list(itertools.combinations_with_replacement(range(output_dimension), 3))
    input_basis = list(itertools.combinations_with_replacement(range(input_dimension), 3))
    input_index = {indices: index for index, indices in enumerate(input_basis)}
    result = [[0] * len(input_basis) for _ in output_basis]
    for row, (i, j, k) in enumerate(output_basis):
        for left in range(input_dimension):
            for middle in range(input_dimension):
                for right in range(input_dimension):
                    column = input_index[tuple(sorted((left, middle, right)))]
                    result[row][column] = (
                        result[row][column]
                        + columns[left][i] * columns[middle][j] * columns[right][k]
                    ) % prime
    return [list(column) for column in zip(*result)]


def polynomial_divide(dividend, divisor):
    quotient = [0] * (len(dividend) - len(divisor) + 1)
    remainder = list(dividend)
    while len(remainder) >= len(divisor):
        coefficient = remainder[-1] // divisor[-1]
        shift = len(remainder) - len(divisor)
        quotient[shift] = coefficient
        for index, value in enumerate(divisor):
            remainder[index + shift] -= coefficient * value
        while remainder and remainder[-1] == 0:
            remainder.pop()
    assert not remainder
    return quotient


def cyclotomic_polynomial(order):
    known = {1: [-1, 1]}
    for number in range(2, order + 1):
        if order % number:
            continue
        polynomial = [-1] + [0] * (number - 1) + [1]
        for divisor in sorted(value for value in known if number % value == 0):
            polynomial = polynomial_divide(polynomial, known[divisor])
        known[number] = polynomial
    return known[order]


def reduce_polynomial(coefficients, cyclotomic):
    work = [Fraction(value) for value in coefficients]
    while len(work) > 1 and work[-1] == 0:
        work.pop()
    degree = len(cyclotomic) - 1
    while len(work) - 1 >= degree:
        coefficient = work[-1]
        shift = len(work) - 1 - degree
        for index, value in enumerate(cyclotomic):
            work[index + shift] -= coefficient * value
        while len(work) > 1 and work[-1] == 0:
            work.pop()
    return work + [Fraction(0)] * (degree - len(work))


def expand_character(records, order):
    result = [0] * order
    for exponent, multiplicity in records:
        result[exponent] = multiplicity
    return result


def cyclic_product(left, right):
    order = len(left)
    result = [0] * order
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            result[(left_index + right_index) % order] += left_value * right_value
    return result


def replay_type(record):
    prime = record["field"]
    groups = record["groups"]
    characteristic_zero = record["characteristic_zero"]
    psl_classes = characteristic_zero["psl_character_classes"]
    assert sum(item["class_size"] for item in psl_classes) == groups["psl_order"]
    assert (
        sum(
            item["class_size"] * item["augmentation_character"] ** 2
            for item in psl_classes
        )
        == groups["psl_order"]
    )

    order = characteristic_zero["molien_cyclotomic_order"]
    numerator = [0] * order
    class_records = characteristic_zero["molien_class_records"]
    assert sum(item["class_size"] for item in class_records) == groups["pgl_order"]
    for item in class_records:
        character = expand_character(item["character_exponents"], order)
        square = expand_character(item["square_character_exponents"], order)
        cube = expand_character(item["cube_character_exponents"], order)
        symmetric_cube = cyclic_product(cyclic_product(character, character), character)
        mixed = cyclic_product(character, square)
        for index in range(order):
            symmetric_cube[index] += 3 * mixed[index] + 2 * cube[index]
            numerator[index] += (
                item["outer_sign"] * item["class_size"] * symmetric_cube[index]
            )
    reduced = reduce_polynomial(numerator, cyclotomic_polynomial(order))
    denominator = characteristic_zero["molien_denominator"]
    assert reduced[0] == 3 * denominator
    assert all(value == 0 for value in reduced[1:])

    modular = record["defining_characteristic"]
    assert modular["invariant_dual_pairing"][0][0] % prime != 0
    relative = record["relative_cubics"]
    assert len(relative["basis"]) == relative["dimension"] == 3
    assert rank(relative["basis"], prime) == 3
    assert hashlib.sha256(bytes(sum(relative["basis"], []))).hexdigest() == relative["basis_sha256"]

    if record["type"] == "H3":
        parent = record["parent_five_component"]
        component = parent["five_dimensional_component_basis"]
        assert column_rank(component, prime) == 5
        cube_columns = symmetric_cube_columns(component, prime)
        assert column_rank(cube_columns, prime) == 35
        intersection = (
            column_rank(cube_columns, prime)
            + rank(relative["basis"], prime)
            - column_rank(cube_columns + relative["basis"], prime)
        )
        assert intersection == parent["intersection_with_relative_cubic_space_dimension"] == 0


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    assert certificate["schema"] == "c454-klein-cubic-v1"
    for filename, expected in certificate["inputs"].items():
        assert hashlib.sha256((HERE / filename).read_bytes()).hexdigest() == expected
    for record in certificate["types"].values():
        replay_type(record)
    comparison = certificate["h3_split_line_comparison"]
    ordered_lines = [
        comparison["split_component_lines"][label]
        for label in comparison["split_coordinate_order"]
    ]
    for name, coordinates in comparison["c412_line_split_coordinates"].items():
        reconstructed = [
            sum(coefficient * line[index] for coefficient, line in zip(coordinates, ordered_lines)) % 11
            for index in range(3)
        ]
        assert reconstructed == comparison["c412_lines"][name]
    assert comparison["c412_line_split_coordinates"] == {
        "rank_one": [1, 0, 0],
        "rank_nine_tate_kernel": [0, 0, 1],
        "signed_moment": [0, 2, 10],
    }
    assert certificate["h3_klein_adler_verdict"]["adler_cubic_pullback_to_W"] is False
    print("C454 independent replay OK")


if __name__ == "__main__":
    main()
