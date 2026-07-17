#!/usr/bin/env python3
"""Finite checks for C218's characteristic-three quartic-nucleus repair family."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import combinations, product
import importlib.util
import json
import math
from operator import or_
from pathlib import Path
from functools import reduce
import sys


HERE = Path(__file__).resolve().parent
BASE_VERIFIER = HERE / "2026-07-13-projective-completion-verifier.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_base():
    spec = importlib.util.spec_from_file_location("projective_completion_verifier", BASE_VERIFIER)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def add_many(field, values):
    result = 0
    for value in values:
        result = field.add(result, value)
    return result


def rank(field, columns):
    row_count = len(columns[0]) if columns else 0
    matrix = [[columns[column][row] for column in range(len(columns))] for row in range(row_count)]
    pivot_row = 0
    for column in range(len(columns)):
        pivot = next(
            (row for row in range(pivot_row, row_count) if matrix[row][column]), None
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        inverse = field.inv(matrix[pivot_row][column])
        matrix[pivot_row] = [field.mul(inverse, value) for value in matrix[pivot_row]]
        for row in range(row_count):
            if row == pivot_row or matrix[row][column] == 0:
                continue
            multiplier = matrix[row][column]
            matrix[row] = [
                field.sub(value, field.mul(multiplier, pivot_value))
                for value, pivot_value in zip(matrix[row], matrix[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


def quartic_system(field):
    curve = [
        (1, t, field.pow(t, 2), field.pow(t, 3), field.pow(t, 4))
        for t in range(field.q)
    ]
    curve.append((0, 0, 0, 0, 1))
    nucleus = (0, 0, 1, 0, 0)
    return curve + [nucleus]


def triple_completion(field, triple):
    infinity = field.q
    if infinity in triple:
        finite = [value for value in triple if value != infinity]
        assert len(finite) == 2
        return field.neg(field.add(finite[0], finite[1]))
    a, b, c = triple
    e1 = add_many(field, (a, b, c))
    e2 = add_many(field, (field.mul(a, b), field.mul(a, c), field.mul(b, c)))
    if e1 == 0:
        assert e2 != 0
        return infinity
    return field.mul(field.neg(e2), field.inv(e1))


def harmonic_blocks(field):
    points = range(field.q + 1)
    blocks = set()
    for triple in combinations(points, 3):
        fourth = triple_completion(field, triple)
        assert fourth not in triple
        blocks.add(frozenset((*triple, fourth)))
    assert all(sum(block.issuperset(triple) for block in blocks) == 1 for triple in combinations(points, 3))
    return blocks


def block_satisfies_middle_coefficient(field, block):
    infinity = field.q
    finite = [value for value in block if value != infinity]
    if len(finite) == 3:
        return add_many(field, finite) == 0
    assert len(finite) == 4
    e2 = add_many(field, (field.mul(a, b) for a, b in combinations(finite, 2)))
    return e2 == 0


def normalized_forms(field, dimension):
    for first in range(dimension):
        for tail in product(range(field.q), repeat=dimension - first - 1):
            yield (0,) * first + (1,) + tail


def dot(field, left, right):
    return add_many(field, (field.mul(a, b) for a, b in zip(left, right)))


def nucleus_row(field, blocks):
    point_count = field.q + 1
    masks = [sum(1 << point for point in block) for block in blocks]
    independence = max(
        mask.bit_count()
        for mask in range(1 << point_count)
        if all(mask & block != block for block in masks)
    )
    matching = 0
    for size in range(point_count // 4, 0, -1):
        if any(
            sum(mask.bit_count() for mask in family) == reduce(or_, family).bit_count()
            for family in combinations(masks, size)
        ):
            matching = size
            break
    return matching, point_count - independence, independence


def base_p_digits(number, prime):
    digits = []
    while number:
        digits.append(number % prime)
        number //= prime
    return digits or [0]


def hyperplane_nucleus_dimension(degree, prime):
    nonzero_pascal_entries = 1
    for digit in base_p_digits(degree, prime):
        nonzero_pascal_entries *= digit + 1
    return degree - nonzero_pascal_entries


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    base = load_base()
    field_results = []
    for field in base.FIELDS[1:]:  # GF(9) and GF(27)
        points = quartic_system(field)
        blocks = harmonic_blocks(field)
        expected_blocks = (field.q + 1) * field.q * (field.q - 1) // 24
        assert len(blocks) == expected_blocks
        assert all(block_satisfies_middle_coefficient(field, block) for block in blocks)
        assert rank(field, points[:5]) == 5

        nucleus = field.q + 1
        circuit_supports = {frozenset((*block, nucleus)) for block in blocks}
        for support in circuit_supports:
            columns = [points[index] for index in support]
            assert rank(field, columns) == 4
            assert all(
                rank(field, columns[:deleted] + columns[deleted + 1 :]) == 4
                for deleted in range(5)
            )
        enumerated_dependent_fives = {
            frozenset(support)
            for support in combinations(range(field.q + 2), 5)
            if rank(field, [points[index] for index in support]) < 5
        }
        assert enumerated_dependent_fives == circuit_supports

        result = {
            "q": field.q,
            "point_count": len(points),
            "rank": 5,
            "harmonic_block_count": len(blocks),
            "mixed_five_circuit_count": len(circuit_supports),
            "repairs_at_nucleus": len(blocks),
            "repairs_at_curve_point": field.q * (field.q - 1) // 6,
        }
        if field.q == 9:
            section_histogram = Counter(
                sum(dot(field, form, point) == 0 for point in points)
                for form in normalized_forms(field, 5)
            )
            assert max(section_histogram) == 5
            matching, transversal, independence = nucleus_row(field, blocks)
            result.update(
                {
                    "projective_hyperplane_count": sum(section_histogram.values()),
                    "maximum_hyperplane_section": 5,
                    "code_parameters": [11, 5, 6],
                    "nucleus_matching": matching,
                    "nucleus_transversal": transversal,
                    "harmonic_independence_number": independence,
                }
            )
        field_results.append(result)

    lucas_checks = 0
    for prime in (2, 3, 5, 7):
        for degree in range(2, 65):
            zero_count = sum(
                math.comb(degree, index) % prime == 0
                for index in range(degree + 1)
            )
            assert hyperplane_nucleus_dimension(degree, prime) == zero_count - 1
            lucas_checks += 1
    assert hyperplane_nucleus_dimension(4, 3) == 0

    certificate = {
        "task": "C218",
        "family": "degree-four normal rational curve plus common hyperplane nucleus in characteristic three",
        "hyperplane_nucleus_dimension_formula": "degree - product(base-p digit + 1)",
        "lucas_formula_checks": lucas_checks,
        "fields": field_results,
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
