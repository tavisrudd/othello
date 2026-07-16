#!/usr/bin/env python3
"""Independent q=9 replay for C203's coefficient-labelled repair equations.

This script is independent of Lean.  It reuses only the small finite-field and point constructors
from the projective-completion verifier, then implements its own nullspace solver.  It enumerates
every size-three/four circuit, checks full-support coefficients and every retargeted scalar recovery
equation on a row-code basis, compares the three closed formulas with the computed kernels, and
replays the arbitrary-helper-coefficient gauge boundary with the target coefficient fixed.
"""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import importlib.util
from itertools import combinations
import json
from pathlib import Path
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


def vector_add(field, left, right):
    return tuple(field.add(a, b) for a, b in zip(left, right))


def vector_scale(field, scalar, vector):
    return tuple(field.mul(scalar, value) for value in vector)


def linear_combination(field, coefficients, columns):
    result = (0, 0, 0, 0)
    for coefficient, column in zip(coefficients, columns):
        result = vector_add(field, result, vector_scale(field, coefficient, column))
    return result


def matrix_rank(field, columns):
    """Independently compute the rank of a family of four-coordinate columns."""

    matrix = [[columns[column][row] for column in range(len(columns))] for row in range(4)]
    pivot_row = 0
    for column in range(len(columns)):
        pivot = next((row for row in range(pivot_row, 4) if matrix[row][column]), None)
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        inverse = field.inv(matrix[pivot_row][column])
        matrix[pivot_row] = [field.mul(inverse, value) for value in matrix[pivot_row]]
        for row in range(pivot_row + 1, 4):
            if matrix[row][column] == 0:
                continue
            multiplier = matrix[row][column]
            matrix[row] = [
                field.sub(value, field.mul(multiplier, pivot_value))
                for value, pivot_value in zip(matrix[row], matrix[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


def enumerate_small_circuits(field, points):
    """Independently enumerate every minimal dependent support of size three or four."""

    circuits = []
    for size in (3, 4):
        for support in combinations(range(len(points)), size):
            columns = [points[index] for index in support]
            if matrix_rank(field, columns) == size:
                continue
            if not all(
                matrix_rank(field, columns[:deleted] + columns[deleted + 1 :]) == size - 1
                for deleted in range(size)
            ):
                continue
            circuits.append(support)
    return tuple(circuits)


def kernel_generator(field, columns):
    """Return the normalized generator of a nullspace known to have dimension one."""

    column_count = len(columns)
    matrix = [[columns[column][row] for column in range(column_count)] for row in range(4)]
    pivots = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next((row for row in range(pivot_row, 4) if matrix[row][column]), None)
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        inverse = field.inv(matrix[pivot_row][column])
        matrix[pivot_row] = [field.mul(inverse, value) for value in matrix[pivot_row]]
        for row in range(4):
            if row == pivot_row or matrix[row][column] == 0:
                continue
            multiplier = matrix[row][column]
            matrix[row] = [
                field.sub(value, field.mul(multiplier, pivot_value))
                for value, pivot_value in zip(matrix[row], matrix[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    free = [column for column in range(column_count) if column not in pivots]
    assert len(free) == 1
    answer = [0] * column_count
    answer[free[0]] = 1
    for row, pivot in reversed(list(enumerate(pivots))):
        total = 0
        for column in free:
            total = field.add(total, field.mul(matrix[row][column], answer[column]))
        answer[pivot] = field.neg(total)
    assert linear_combination(field, answer, columns) == (0, 0, 0, 0)
    first = next(value for value in answer if value)
    inverse = field.inv(first)
    return tuple(field.mul(inverse, value) for value in answer)


def normalize(field, coefficients):
    first = next(value for value in coefficients if value)
    inverse = field.inv(first)
    return tuple(field.mul(inverse, value) for value in coefficients)


def relation_on_support(field, support, coefficient_by_index):
    return normalize(field, tuple(coefficient_by_index[index] for index in support))


def check_retargeted_recovery(field, points, support, coefficients):
    """Check every target equation on the four generator rows."""

    for target_position, target in enumerate(support):
        target_coefficient = coefficients[target_position]
        assert target_coefficient != 0
        factor = field.neg(field.inv(target_coefficient))
        for row in range(4):
            helper_sum = 0
            for position, helper in enumerate(support):
                if position == target_position:
                    continue
                helper_sum = field.add(
                    helper_sum,
                    field.mul(coefficients[position], points[helper][row]),
                )
            recovered = field.mul(factor, helper_sum)
            assert recovered == points[target][row]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    base = load_base()
    field = base.FIELDS[1]
    assert field.q == 9
    points, labels = base.completed_points(field)
    circuits = enumerate_small_circuits(field, points)
    assert Counter(map(len, circuits)) == Counter({3: 120, 4: 120})

    coefficient_rows = []
    coefficient_by_support = {}
    for support in circuits:
        coefficients = kernel_generator(field, [points[index] for index in support])
        assert all(coefficients)
        check_retargeted_recovery(field, points, support, coefficients)
        coefficient_by_support[frozenset(support)] = coefficients
        coefficient_rows.append({
            "support": [labels[index] for index in support],
            "normalized_coefficients": list(coefficients),
        })

    q = field.q
    formula_checks = Counter()
    gauge_checks = 0
    for a in range(q):
        for b in range(q):
            if a == b:
                continue
            support = tuple(sorted((q + 1 + a, q + 1 + b, 2 * q + 1)))
            relation = {
                q + 1 + a: 1,
                q + 1 + b: field.neg(1),
                2 * q + 1: field.sub(b, a),
            }
            expected = relation_on_support(field, support, relation)
            assert expected == coefficient_by_support[frozenset(support)]
            formula_checks["axis_pair_ordered"] += 1
            for desired in range(1, q):
                scale = field.inv(desired)
                assert scale != 0
                scaled_columns = [points[index] for index in support]
                helper_position = support.index(q + 1 + a)
                scaled_columns[helper_position] = vector_scale(
                    field, scale, scaled_columns[helper_position]
                )
                scaled_coefficients = [relation[index] for index in support]
                scaled_coefficients[helper_position] = desired
                assert linear_combination(field, scaled_coefficients, scaled_columns) == (0, 0, 0, 0)
                gauge_checks += 1

    for s in range(q):
        for t in range(q):
            if s == t:
                continue
            support = tuple(sorted((q, s, t, q + 1 + field.add(s, t))))
            difference = field.sub(s, t)
            relation = {
                q: field.neg(field.pow(difference, 3)),
                s: 1,
                t: field.neg(1),
                q + 1 + field.add(s, t): field.sub(t, s),
            }
            expected = relation_on_support(field, support, relation)
            assert expected == coefficient_by_support[frozenset(support)]
            formula_checks["cubic_infinity_ordered"] += 1

    for s in range(q):
        for t in range(q):
            for u in range(q):
                if len({s, t, u}) != 3 or field.add(field.add(s, t), u) != 0:
                    continue
                support = tuple(sorted((s, t, u, 2 * q + 1)))
                vandermonde = field.mul(
                    field.mul(field.sub(s, t), field.sub(s, u)), field.sub(t, u)
                )
                relation = {
                    s: field.sub(t, u),
                    t: field.sub(u, s),
                    u: field.sub(s, t),
                    2 * q + 1: field.neg(vandermonde),
                }
                expected = relation_on_support(field, support, relation)
                assert expected == coefficient_by_support[frozenset(support)]
                formula_checks["axis_infinity_zero_sum_ordered"] += 1

    encoded_rows = json.dumps(coefficient_rows, sort_keys=True, separators=(",", ":")).encode()
    certificate = {
        "task": "C203",
        "q": q,
        "field_encoding": "GF(3)[x]/(x^2+1), base-3 coefficient encoding",
        "base_verifier_sha256": hashlib.sha256(BASE_VERIFIER.read_bytes()).hexdigest(),
        "small_circuit_count_by_size": {
            str(size): sum(len(circuit) == size for circuit in circuits) for size in (3, 4)
        },
        "full_support_relation_count": len(coefficient_rows),
        "retargeted_recovery_equation_count": sum(len(circuit) for circuit in circuits),
        "formula_checks": dict(sorted(formula_checks.items())),
        "arbitrary_helper_coefficient_gauge_checks": gauge_checks,
        "coefficient_table_sha256": hashlib.sha256(encoded_rows).hexdigest(),
        "coefficient_table": coefficient_rows,
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
