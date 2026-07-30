#!/usr/bin/env python3
"""Signed global Schur complements for the exceptional C682 entrances."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-29-c682-global-phase-propagation.py"
MONOTONE_PATH = HERE / "2026-07-29-c682-monotone-entrance-propagation.py"
OPERATORS = HERE / "2026-07-29-c682-monotone-weyl-operators.json"
CERTIFICATE = HERE / "2026-07-30-c682-exceptional-monotone-schur.json"
TYPES = (("4", 6), ("4s", 3), ("5", 4), ("6", 5))
TAIL_WIDTH = 1
FACTOR_ROOTS = {
    "4": (
        {-2: 1, -1: 2, 0: 4, 1: 3, 2: 2},
        {-2: 1, -1: 3, 0: 4, 1: 3, 2: 1},
        {-2: 2, -1: 3, 0: 4, 1: 2, 2: 1},
    ),
    "4s": (
        {-2: 1, -1: 2, 0: 4, 1: 3, 2: 2},
        {-2: 1, -1: 3, 0: 4, 1: 3, 2: 1},
        {-2: 2, -1: 3, 0: 4, 1: 2, 2: 1},
    ),
    "5": (
        {-2: 1, -1: 3, 0: 5, 1: 4, 2: 2},
        {-2: 2, -1: 4, 0: 5, 1: 3, 2: 1},
        {-2: 2, -1: 3, 0: 5, 1: 3, 2: 2},
    ),
    "6": (
        {-2: 2, -1: 4, 0: 6, 1: 4, 2: 2},
        {-2: 2, -1: 4, 0: 6, 1: 4, 2: 2},
        {-2: 2, -1: 4, 0: 6, 1: 4, 2: 2},
    ),
}


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


MONOTONE = load(MONOTONE_PATH, "c682_monotone")
BASE = MONOTONE.BASE


def tail_indices(rows, width=TAIL_WIDTH):
    levels = BASE.local_levels(rows)
    maxima = {}
    for (name, *_), level in zip(rows, levels):
        maxima[name] = max(maxima.get(name, -1), level)
    return [
        index
        for index, ((name, *_), level) in enumerate(zip(rows, levels))
        if level >= maxima[name] - width + 1
    ]


def schur_columns(incoming, returned, tail):
    """Eliminate the complementary rows using only incoming pivots."""
    size = len(incoming) + 1
    assert all(len(column) == size for column in incoming)
    assert len(returned) == size
    tail_set = set(tail)
    head = [row for row in range(size) if row not in tail_set]
    columns = [
        [Fraction(value) for value in column]
        for column in incoming + [returned]
    ]
    available = list(range(len(incoming)))
    pivots = []
    for row in head:
        pivot = next(index for index in available if columns[index][row])
        pivots.append(pivot)
        available.remove(pivot)
        pivot_value = columns[pivot][row]
        for index in available + [len(incoming)]:
            if not columns[index][row]:
                continue
            multiplier = columns[index][row] / pivot_value
            columns[index] = [
                left - multiplier * right
                for left, right in zip(columns[index], columns[pivot])
            ]
    assert all(
        not columns[index][row]
        for index in available + [len(incoming)]
        for row in head
    )
    assert len(available) + 1 == len(tail)
    return (
        [[columns[index][row] for row in tail] for index in available]
        + [[columns[-1][row] for row in tail]],
        pivots,
        available,
    )


def natural_block_schur(label, degree, operators):
    lower, current, incoming = BASE.operator_matrix(
        label, degree - 6, 3, operators
    )
    current_2, upper, outgoing = BASE.operator_matrix(
        label, degree, 3, operators
    )
    upper_2, current_3, ninth = BASE.operator_matrix(
        label, degree + 6, 9, operators
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    lower_levels = BASE.local_levels(lower)
    current_levels = BASE.local_levels(current)
    last_full_level = max(lower_levels)
    lower_names = list(dict.fromkeys(name for name, *_ in lower))
    current_names = list(dict.fromkeys(name for name, *_ in current))
    lower_name_index = {name: index for index, name in enumerate(lower_names)}
    current_name_index = {
        name: index for index, name in enumerate(current_names)
    }
    lower_order = sorted(
        range(len(lower)),
        key=lambda index: (
            lower_levels[index],
            lower_name_index[lower[index][0]],
        ),
    )
    current_order = sorted(
        range(len(current)),
        key=lambda index: (
            current_levels[index],
            current_name_index[current[index][0]],
        ),
    )
    pivot_indices = [
        index for index in lower_order if lower_levels[index] > 0
    ]
    residual_indices = [
        index for index in lower_order if lower_levels[index] == 0
    ]
    head = [
        index
        for index in current_order
        if current_levels[index] < last_full_level
    ]
    tail = [
        index
        for index in current_order
        if current_levels[index] >= last_full_level
    ]
    endpoint = BASE.endpoint_index(
        lower, lower_levels, (lower[-1][0], 0)
    )
    returned = BASE.matvec(
        ninth, BASE.matvec(outgoing, incoming[endpoint])
    )
    ordered = pivot_indices + residual_indices
    columns = [
        [Fraction(value) for value in incoming[index]]
        for index in ordered
    ] + [[Fraction(value) for value in returned]]
    available = list(range(len(pivot_indices)))
    residual = list(
        range(len(pivot_indices), len(pivot_indices) + len(residual_indices))
    )
    for row in head:
        pivot = next(index for index in available if columns[index][row])
        available.remove(pivot)
        pivot_value = columns[pivot][row]
        for index in available + residual + [len(columns) - 1]:
            if not columns[index][row]:
                continue
            multiplier = columns[index][row] / pivot_value
            columns[index] = [
                left - multiplier * right
                for left, right in zip(columns[index], columns[pivot])
            ]
    assert not available
    assert all(
        not columns[index][row]
        for index in residual + [len(columns) - 1]
        for row in head
    )
    reduced = [
        [columns[index][row] for row in tail]
        for index in residual + [len(columns) - 1]
    ]
    assert len(reduced) == len(tail)
    determinant = BASE.determinant_columns(reduced)
    assert determinant
    return {
        "label": label,
        "degree": degree,
        "block_size": len(residual),
        "level_count": last_full_level + 1,
        "schur_size": len(tail),
        "endpoint_key": BASE.endpoint_key(lower, lower_levels, endpoint),
        "columns": reduced,
        "determinant": determinant,
    }


def mod20_block_schur(label, degree, operators):
    lower, current, incoming = BASE.operator_matrix(
        label, degree - 6, 3, operators
    )
    current_2, upper, outgoing = BASE.operator_matrix(
        label, degree, 3, operators
    )
    upper_2, current_3, ninth = BASE.operator_matrix(
        label, degree + 6, 9, operators
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    lower_levels = [row[2] // 3 for row in lower]
    current_levels = [row[2] // 3 for row in current]
    lower_names = list(dict.fromkeys(name for name, *_ in lower))
    current_names = list(dict.fromkeys(name for name, *_ in current))
    lower_name_index = {name: index for index, name in enumerate(lower_names)}
    current_name_index = {
        name: index for index, name in enumerate(current_names)
    }
    lower_order = sorted(
        range(len(lower)),
        key=lambda index: (
            lower_levels[index],
            lower_name_index[lower[index][0]],
        ),
    )
    current_order = sorted(
        range(len(current)),
        key=lambda index: (
            current_levels[index],
            current_name_index[current[index][0]],
        ),
    )
    level_counts = {
        level: lower_levels.count(level) for level in set(lower_levels)
    }
    block_size = max(level_counts.values())
    full_levels = sorted(
        level for level, count in level_counts.items()
        if count == block_size
    )
    assert full_levels == list(range(max(full_levels) + 1))
    last_full_level = max(full_levels)
    pivot_indices = [
        index
        for index in lower_order
        if 1 <= lower_levels[index] <= last_full_level
    ]
    residual_indices = [
        index
        for index in lower_order
        if lower_levels[index] == 0
        or lower_levels[index] > last_full_level
    ]
    head = [
        index
        for index in current_order
        if current_levels[index] < last_full_level
    ]
    tail = [
        index
        for index in current_order
        if current_levels[index] >= last_full_level
    ]
    assert len(pivot_indices) == len(head)
    endpoint = lower_order[-1]
    returned = BASE.matvec(
        ninth, BASE.matvec(outgoing, incoming[endpoint])
    )
    ordered = pivot_indices + residual_indices
    columns = [
        [Fraction(value) for value in incoming[index]]
        for index in ordered
    ] + [[Fraction(value) for value in returned]]
    available = list(range(len(pivot_indices)))
    residual = list(
        range(len(pivot_indices), len(pivot_indices) + len(residual_indices))
    )
    for row in head:
        pivot = next(index for index in available if columns[index][row])
        available.remove(pivot)
        pivot_value = columns[pivot][row]
        for index in available + residual + [len(columns) - 1]:
            if not columns[index][row]:
                continue
            multiplier = columns[index][row] / pivot_value
            columns[index] = [
                left - multiplier * right
                for left, right in zip(columns[index], columns[pivot])
            ]
    assert not available
    reduced = [
        [columns[index][row] for row in tail]
        for index in residual + [len(columns) - 1]
    ]
    assert len(reduced) == len(tail)
    determinant = BASE.determinant_columns(reduced)
    assert determinant
    return {
        "label": label,
        "degree": degree,
        "block_size": block_size,
        "full_level_count": last_full_level + 1,
        "partial_source_size": len(residual_indices) - block_size,
        "schur_size": len(tail),
        "endpoint_key": lower[endpoint],
        "columns": reduced,
        "determinant": determinant,
    }


def exceptional_schur(label, phase, q, operators):
    degree = 60 + phase + 60 * q
    lower, current, incoming = BASE.operator_matrix(
        label, degree - 6, 3, operators
    )
    current_2, upper, outgoing = BASE.operator_matrix(
        label, degree, 3, operators
    )
    upper_2, current_3, ninth = BASE.operator_matrix(
        label, degree + 6, 9, operators
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    lower_levels = BASE.local_levels(lower)
    endpoint = BASE.endpoint_index(
        lower, lower_levels, (lower[-1][0], 0)
    )
    returned = BASE.matvec(
        ninth, BASE.matvec(outgoing, incoming[endpoint])
    )
    tail = tail_indices(current)
    columns, pivots, residual = schur_columns(incoming, returned, tail)
    determinant = BASE.determinant_columns(columns)
    assert determinant
    return {
        "label": label,
        "phase": phase,
        "q": q,
        "degree": degree,
        "current_dimension": len(current),
        "tail_dimension": len(tail),
        "head_dimension": len(current) - len(tail),
        "residual_incoming_dimension": len(residual),
        "endpoint_key": BASE.endpoint_key(lower, lower_levels, endpoint),
        "pivot_keys": [current[index] for index in pivots],
        "residual_keys": [lower[index] for index in residual],
        "columns": columns,
        "determinant": determinant,
    }


def augmented_determinant(label, phase, q, operators):
    return augmented_determinant_degree(
        label, 60 + phase + 60 * q, operators
    )


def augmented_determinant_degree(label, degree, operators):
    lower, current, incoming = BASE.operator_matrix(
        label, degree - 6, 3, operators
    )
    current_2, upper, outgoing = BASE.operator_matrix(
        label, degree, 3, operators
    )
    upper_2, current_3, ninth = BASE.operator_matrix(
        label, degree + 6, 9, operators
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    endpoint = BASE.endpoint_index(
        lower, BASE.local_levels(lower), (lower[-1][0], 0)
    )
    returned = BASE.matvec(
        ninth, BASE.matvec(outgoing, incoming[endpoint])
    )
    third_scale = BASE.operator_denominator(label, 3, operators)
    ninth_scale = BASE.operator_denominator(label, 9, operators)
    integer_incoming = BASE.scale_columns(incoming, third_scale)
    integer_returned = [
        int(value * third_scale**2 * ninth_scale)
        for value in returned
    ]
    return BASE.determinant_columns_integer(
        integer_incoming + [integer_returned]
    )


def solve_square(rows, right):
    size = len(rows)
    work = [
        [Fraction(value) for value in row] + [Fraction(value_right)]
        for row, value_right in zip(rows, right)
    ]
    for column in range(size):
        pivot = next(
            row for row in range(column, size) if work[row][column]
        )
        work[column], work[pivot] = work[pivot], work[column]
        value = work[column][column]
        work[column] = [entry / value for entry in work[column]]
        for row in range(size):
            if row == column or not work[row][column]:
                continue
            value = work[row][column]
            work[row] = [
                left - value * right_entry
                for left, right_entry in zip(work[row], work[column])
            ]
    return [work[index][-1] for index in range(size)]


def polynomial_value(coefficients, value):
    out = Fraction(0)
    for coefficient in reversed(coefficients):
        out = out * value + coefficient
    return out


def matrix_add(*matrices):
    return [
        [sum(matrix[row][column] for matrix in matrices)
         for column in range(len(matrices[0][0]))]
        for row in range(len(matrices[0]))
    ]


def matrix_scale(matrix, scalar):
    return [[scalar * value for value in row] for row in matrix]


def matrix_multiply(left, right):
    return [
        [
            sum(left[row][middle] * right[middle][column]
                for middle in range(len(right)))
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def matrix_solve(left, right):
    size = len(left)
    width = len(right[0])
    work = [
        [Fraction(value) for value in left[row]]
        + [Fraction(value) for value in right[row]]
        for row in range(size)
    ]
    for column in range(size):
        pivot = next(
            row for row in range(column, size) if work[row][column]
        )
        work[column], work[pivot] = work[pivot], work[column]
        value = work[column][column]
        work[column] = [entry / value for entry in work[column]]
        for row in range(size):
            if row == column or not work[row][column]:
                continue
            value = work[row][column]
            work[row] = [
                left_value - value * right_value
                for left_value, right_value in zip(
                    work[row], work[column]
                )
            ]
    return [row[size : size + width] for row in work]


def recurrence_block_schur(
    label, degree, operators, endpoint_key=None
):
    lower, current, incoming = BASE.operator_matrix(
        label, degree - 6, 3, operators
    )
    current_2, upper, outgoing = BASE.operator_matrix(
        label, degree, 3, operators
    )
    upper_2, current_3, ninth = BASE.operator_matrix(
        label, degree + 6, 9, operators
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    lower_levels = BASE.local_levels(lower)
    current_levels = BASE.local_levels(current)
    lower_names = list(dict.fromkeys(name for name, *_ in lower))
    current_names = list(dict.fromkeys(name for name, *_ in current))
    lower_lookup = {
        (name, level): index
        for index, ((name, *_), level) in enumerate(
            zip(lower, lower_levels)
        )
    }
    current_lookup = {
        (name, level): index
        for index, ((name, *_), level) in enumerate(
            zip(current, current_levels)
        )
    }
    block_size = len(lower_names)
    last_level = max(lower_levels)
    assert len(current_names) == block_size

    def block(source_level, target_level):
        source_indices = [
            lower_lookup[name, source_level] for name in lower_names
        ]
        target_indices = [
            current_lookup[name, target_level] for name in current_names
        ]
        return [
            [incoming[source][target] for source in source_indices]
            for target in target_indices
        ]

    if endpoint_key is None:
        endpoint_key = (lower[-1][0], 0)
    endpoint = BASE.endpoint_index(
        lower, lower_levels, endpoint_key
    )
    returned = BASE.matvec(
        ninth, BASE.matvec(outgoing, incoming[endpoint])
    )

    def forcing(level):
        indices = [
            current_lookup[name, level] for name in current_names
        ]
        return [[returned[index]] for index in indices]

    zero = [[Fraction(0)] * (block_size + 1) for _ in range(block_size)]
    previous = zero
    current_state = [
        [Fraction(int(row == column)) for column in range(block_size)]
        + [Fraction(0)]
        for row in range(block_size)
    ]
    state_trace = [current_state]
    backward_determinants = []
    for level in range(last_level):
        backward = block(level + 1, level)
        diagonal = block(level, level)
        forward = (
            [[Fraction(0)] * block_size for _ in range(block_size)]
            if level == 0
            else block(level - 1, level)
        )
        backward_determinants.append(
            BASE.determinant_columns(
                [[backward[row][column] for row in range(block_size)]
                 for column in range(block_size)]
            )
        )
        rhs = matrix_add(
            matrix_multiply(forward, previous),
            matrix_multiply(diagonal, current_state),
            [
                [Fraction(0)] * block_size + forcing(level)[row]
                for row in range(block_size)
            ],
        )
        next_state = matrix_scale(matrix_solve(backward, rhs), -1)
        previous, current_state = current_state, next_state
        state_trace.append(current_state)
    diagonal = block(last_level, last_level)
    forward = (
        [[Fraction(0)] * block_size for _ in range(block_size)]
        if last_level == 0
        else block(last_level - 1, last_level)
    )
    final_full = matrix_add(
        matrix_multiply(forward, previous),
        matrix_multiply(diagonal, current_state),
        [
            [Fraction(0)] * block_size + forcing(last_level)[row]
            for row in range(block_size)
        ],
    )
    final_index = next(
        index
        for index, level in enumerate(current_levels)
        if level == last_level + 1
    )
    final_scalar = []
    for column in range(block_size + 1):
        value = returned[final_index] if column == block_size else 0
        for source_name, coefficient in zip(
            lower_names,
            [current_state[row][column] for row in range(block_size)],
        ):
            source = lower_lookup[source_name, last_level]
            value += incoming[source][final_index] * coefficient
        final_scalar.append(value)
    rows = final_full + [final_scalar]
    columns = [
        [rows[row][column] for row in range(block_size + 1)]
        for column in range(block_size + 1)
    ]
    determinant = BASE.determinant_columns(columns)
    assert determinant
    return {
        "label": label,
        "degree": degree,
        "block_size": block_size,
        "level_count": last_level + 1,
        "schur_size": block_size + 1,
        "endpoint_key": BASE.endpoint_key(
            lower, lower_levels, endpoint
        ),
        "columns": columns,
        "state_trace": state_trace,
        "backward_determinants": backward_determinants,
        "determinant": determinant,
    }


def modular_block_schur_determinant(
    label, degree, operators, prime=1000000007
):
    def reduce_value(value):
        value = Fraction(value)
        return (
            value.numerator
            * pow(value.denominator % prime, prime - 2, prime)
        ) % prime

    def modular_operator_matrix(source_degree, order):
        source = BASE.descriptors(label, source_degree)
        target = BASE.descriptors(
            label, source_degree + 12 - 2 * order
        )
        lookup = {
            descriptor: index for index, descriptor in enumerate(target)
        }
        columns = [[0] * len(target) for _ in source]
        terms_by_source = {}
        for term in operators[label][str(order)]["terms"]:
            terms_by_source.setdefault(term["source"], []).append(term)
        reduced_coefficients = {
            id(term): reduce_value(term["coefficient"])
            for terms in terms_by_source.values()
            for term in terms
        }
        for column, (source_name, f_power, h_power) in enumerate(source):
            for term in terms_by_source.get(source_name, []):
                scalar = (
                    reduced_coefficients[id(term)]
                    * BASE.falling(f_power, term["dF_order"])
                    * BASE.falling(h_power, term["dH_order"])
                ) % prime
                if not scalar:
                    continue
                target_descriptor = (
                    term["target"],
                    f_power
                    - term["dF_order"]
                    + term["F_multiplier"],
                    h_power
                    - term["dH_order"]
                    + term["H_multiplier"],
                )
                if target_descriptor in lookup:
                    row = lookup[target_descriptor]
                    columns[column][row] = (
                        columns[column][row] + scalar
                    ) % prime
        return source, target, columns

    lower, current, incoming = modular_operator_matrix(degree - 6, 3)
    current_2, upper, outgoing = modular_operator_matrix(degree, 3)
    upper_2, current_3, ninth = modular_operator_matrix(degree + 6, 9)
    assert current == current_2 == current_3
    assert upper == upper_2

    def matvec_mod(columns, vector):
        return [
            sum(
                vector[column] * columns[column][row]
                for column in range(len(columns))
            )
            % prime
            for row in range(len(columns[0]))
        ]

    lower_levels = BASE.local_levels(lower)
    current_levels = BASE.local_levels(current)
    lower_names = list(dict.fromkeys(name for name, *_ in lower))
    current_names = list(dict.fromkeys(name for name, *_ in current))
    lower_lookup = {
        (name, level): index
        for index, ((name, *_), level) in enumerate(
            zip(lower, lower_levels)
        )
    }
    current_lookup = {
        (name, level): index
        for index, ((name, *_), level) in enumerate(
            zip(current, current_levels)
        )
    }
    block_size = len(lower_names)
    last_level = max(lower_levels)

    def block(source_level, target_level):
        source_indices = [
            lower_lookup[name, source_level] for name in lower_names
        ]
        target_indices = [
            current_lookup[name, target_level] for name in current_names
        ]
        return [
            [incoming[source][target] for source in source_indices]
            for target in target_indices
        ]

    def multiply(left, right):
        return [
            [
                sum(
                    left[row][middle] * right[middle][column]
                    for middle in range(len(right))
                )
                % prime
                for column in range(len(right[0]))
            ]
            for row in range(len(left))
        ]

    def solve(left, right):
        size = len(left)
        width = len(right[0])
        work = [
            [value % prime for value in left[row] + right[row]]
            for row in range(size)
        ]
        for column in range(size):
            pivot = next(
                row
                for row in range(column, size)
                if work[row][column]
            )
            work[column], work[pivot] = work[pivot], work[column]
            inverse = pow(work[column][column], prime - 2, prime)
            work[column] = [
                value * inverse % prime for value in work[column]
            ]
            for row in range(size):
                if row == column or not work[row][column]:
                    continue
                value = work[row][column]
                work[row] = [
                    (left_value - value * right_value) % prime
                    for left_value, right_value in zip(
                        work[row], work[column]
                    )
                ]
        return [row[size : size + width] for row in work]

    endpoint = BASE.endpoint_index(
        lower, lower_levels, (lower[-1][0], 0)
    )
    returned = matvec_mod(
        ninth, matvec_mod(outgoing, incoming[endpoint])
    )
    previous = [[0] * (block_size + 1) for _ in range(block_size)]
    state = [
        [int(row == column) for column in range(block_size)] + [0]
        for row in range(block_size)
    ]
    for level in range(last_level):
        backward = block(level + 1, level)
        diagonal = block(level, level)
        forward = (
            [[0] * block_size for _ in range(block_size)]
            if level == 0
            else block(level - 1, level)
        )
        left_part = multiply(forward, previous)
        right_part = multiply(diagonal, state)
        rhs = [
            [
                (
                    left_part[row][column]
                    + right_part[row][column]
                    + (
                        returned[current_lookup[
                            current_names[row], level
                        ]]
                        if column == block_size
                        else 0
                    )
                )
                % prime
                for column in range(block_size + 1)
            ]
            for row in range(block_size)
        ]
        next_state = [
            [(-value) % prime for value in row]
            for row in solve(backward, rhs)
        ]
        previous, state = state, next_state
    diagonal = block(last_level, last_level)
    forward = (
        [[0] * block_size for _ in range(block_size)]
        if last_level == 0
        else block(last_level - 1, last_level)
    )
    left = multiply(forward, previous)
    right = multiply(diagonal, state)
    rows = [
        [
            (
                left[row][column]
                + right[row][column]
                + (
                    returned[current_lookup[
                        current_names[row], last_level
                    ]]
                    if column == block_size
                    else 0
                )
            )
            % prime
            for column in range(block_size + 1)
        ]
        for row in range(block_size)
    ]
    final_index = next(
        index
        for index, level in enumerate(current_levels)
        if level == last_level + 1
    )
    final_row = []
    for column in range(block_size + 1):
        value = returned[final_index] if column == block_size else 0
        for row, source_name in enumerate(lower_names):
            source = lower_lookup[source_name, last_level]
            value += incoming[source][final_index] * state[row][column]
        final_row.append(value % prime)
    rows.append(final_row)
    determinant = 1
    for column in range(block_size + 1):
        pivot = next(
            row
            for row in range(column, block_size + 1)
            if rows[row][column]
        )
        if pivot != column:
            rows[column], rows[pivot] = rows[pivot], rows[column]
            determinant = -determinant
        value = rows[column][column]
        determinant = determinant * value % prime
        inverse = pow(value, prime - 2, prime)
        for row in range(column + 1, block_size + 1):
            multiplier = rows[row][column] * inverse % prime
            rows[row] = [
                (left_value - multiplier * right_value) % prime
                for left_value, right_value in zip(
                    rows[row], rows[column]
                )
            ]
    return determinant % prime


def rational_ratio_fit(values, maximum_total_degree=20):
    ratios = [
        Fraction(right, left)
        for left, right in zip(values, values[1:])
    ]
    points = list(range(1, len(values)))
    for total in range(maximum_total_degree + 1):
        for numerator_degree in range(total + 1):
            denominator_degree = total - numerator_degree
            unknowns = total + 1
            if len(points) < unknowns + 2:
                continue
            rows = []
            right = []
            for q, ratio in zip(points[:unknowns], ratios[:unknowns]):
                rows.append(
                    [Fraction(q**power) for power in range(numerator_degree + 1)]
                    + [
                        -ratio * q**power
                        for power in range(denominator_degree)
                    ]
                )
                right.append(ratio * q**denominator_degree)
            try:
                solution = solve_square(rows, right)
            except StopIteration:
                continue
            numerator = solution[: numerator_degree + 1]
            denominator = (
                solution[numerator_degree + 1 :] + [Fraction(1)]
            )
            if all(
                polynomial_value(numerator, q)
                == ratio * polynomial_value(denominator, q)
                for q, ratio in zip(points, ratios)
            ):
                return numerator, denominator
    return None


def modular_rational_ratio_degree(
    values, prime=1000000007, maximum_total_degree=40
):
    def reduce_fraction(value):
        value = Fraction(value)
        return (
            value.numerator
            * pow(value.denominator % prime, prime - 2, prime)
        ) % prime

    ratios = [
        reduce_fraction(Fraction(right, left))
        for left, right in zip(values, values[1:])
    ]
    points = list(range(1, len(values)))
    for total in range(maximum_total_degree + 1):
        for numerator_degree in range(total + 1):
            denominator_degree = total - numerator_degree
            unknowns = total + 1
            if len(points) < unknowns + 2:
                continue
            work = []
            for q, ratio in zip(points[:unknowns], ratios[:unknowns]):
                work.append(
                    [pow(q, power, prime)
                     for power in range(numerator_degree + 1)]
                    + [
                        -ratio * pow(q, power, prime) % prime
                        for power in range(denominator_degree)
                    ]
                    + [
                        ratio
                        * pow(q, denominator_degree, prime)
                        % prime
                    ]
                )
            failed = False
            for column in range(unknowns):
                pivot = next(
                    (
                        row
                        for row in range(column, unknowns)
                        if work[row][column] % prime
                    ),
                    None,
                )
                if pivot is None:
                    failed = True
                    break
                work[column], work[pivot] = work[pivot], work[column]
                inverse = pow(work[column][column], prime - 2, prime)
                work[column] = [
                    value * inverse % prime for value in work[column]
                ]
                for row in range(unknowns):
                    if row == column or not work[row][column] % prime:
                        continue
                    value = work[row][column]
                    work[row] = [
                        (left - value * right) % prime
                        for left, right in zip(work[row], work[column])
                    ]
            if failed:
                continue
            solution = [work[row][-1] for row in range(unknowns)]
            numerator = solution[: numerator_degree + 1]
            denominator = solution[numerator_degree + 1 :] + [1]
            if all(
                sum(
                    numerator[power] * pow(q, power, prime)
                    for power in range(len(numerator))
                )
                % prime
                == ratio
                * sum(
                    denominator[power] * pow(q, power, prime)
                    for power in range(len(denominator))
                )
                % prime
                for q, ratio in zip(points, ratios)
            ):
                return numerator_degree, denominator_degree
    return None


def modular_polynomial_recurrence(
    values, prime=1000000007, maximum_order=10, maximum_degree=10
):
    for order in range(1, maximum_order + 1):
        for degree in range(maximum_degree + 1):
            unknowns = (order + 1) * (degree + 1)
            equation_count = len(values) - order
            if equation_count < unknowns + 5:
                continue
            work = []
            for index in range(equation_count):
                q = index + 1
                work.append(
                    [
                        values[index + shift]
                        * pow(q, power, prime)
                        % prime
                        for shift in range(order + 1)
                        for power in range(degree + 1)
                    ]
                )
            pivot_columns = []
            pivot_row = 0
            for column in range(unknowns):
                pivot = next(
                    (
                        row
                        for row in range(pivot_row, equation_count)
                        if work[row][column]
                    ),
                    None,
                )
                if pivot is None:
                    continue
                work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
                inverse = pow(work[pivot_row][column], prime - 2, prime)
                work[pivot_row] = [
                    value * inverse % prime for value in work[pivot_row]
                ]
                for row in range(equation_count):
                    if row == pivot_row or not work[row][column]:
                        continue
                    value = work[row][column]
                    work[row] = [
                        (left - value * right) % prime
                        for left, right in zip(
                            work[row], work[pivot_row]
                        )
                    ]
                pivot_columns.append(column)
                pivot_row += 1
            free_columns = [
                column
                for column in range(unknowns)
                if column not in pivot_columns
            ]
            if len(free_columns) != 1:
                continue
            vector = [0] * unknowns
            vector[free_columns[0]] = 1
            for row, pivot in reversed(list(enumerate(pivot_columns))):
                vector[pivot] = -sum(
                    work[row][column] * vector[column]
                    for column in range(pivot + 1, unknowns)
                ) % prime
            assert all(
                sum(left * right for left, right in zip(row, vector))
                % prime
                == 0
                for row in work
            )
            return {
                "order": order,
                "degree": degree,
                "coefficients": [
                    vector[
                        shift * (degree + 1) :
                        (shift + 1) * (degree + 1)
                    ]
                    for shift in range(order + 1)
                ],
            }
    return None


def backward_block_determinant(label, degree, level, operators):
    lower, current, incoming = BASE.operator_matrix(
        label, degree - 6, 3, operators
    )
    lower_levels = [row[2] // 3 for row in lower]
    current_levels = [row[2] // 3 for row in current]
    lower_names = list(dict.fromkeys(name for name, *_ in lower))
    current_names = list(dict.fromkeys(name for name, *_ in current))
    lower_lookup = {
        (name, row_level): index
        for index, ((name, *_), row_level) in enumerate(
            zip(lower, lower_levels)
        )
    }
    current_lookup = {
        (name, row_level): index
        for index, ((name, *_), row_level) in enumerate(
            zip(current, current_levels)
        )
    }
    source = [lower_lookup[name, level] for name in lower_names]
    target = [
        current_lookup[name, level - 1] for name in current_names
    ]
    columns = [
        [incoming[column][row] for row in target] for column in source
    ]
    return BASE.determinant_columns(columns)


def factor_value(label, phase_class, level):
    out = Fraction(1)
    for numerator, multiplicity in FACTOR_ROOTS[label][
        phase_class
    ].items():
        root = Fraction(numerator, 3)
        out *= (Fraction(level) - root) ** multiplicity
    return out


def backward_factor_certificate(label, residue, operators):
    block_size = {"4": 4, "4s": 4, "5": 5, "6": 6}[label]
    degree_bound = 3 * block_size
    level_values = list(range(1, degree_bound + 2))
    phases = {}
    for phase_class in range(3):
        sample_q = degree_bound + 3
        sample_r = 3 * sample_q + phase_class
        first = backward_block_determinant(
            label, residue + 20 * sample_r, 1, operators
        )
        constant = first / factor_value(label, phase_class, 1)
        q_values = list(
            range(sample_q, sample_q + degree_bound + 1)
        )
        for quotient in q_values:
            r = 3 * quotient + phase_class
            degree = residue + 20 * r
            for level in level_values:
                assert backward_block_determinant(
                    label, degree, level, operators
                ) == constant * factor_value(
                    label, phase_class, level
                )
        phases[str(phase_class)] = {
            "constant": str(constant),
            "roots": [
                {
                    "root": str(Fraction(numerator, 3)),
                    "multiplicity": multiplicity,
                }
                for numerator, multiplicity in sorted(
                    FACTOR_ROOTS[label][phase_class].items()
                )
            ],
            "identity_grid": {
                "q": [q_values[0], q_values[-1]],
                "level": [level_values[0], level_values[-1]],
            },
        }
    return {
        "block_size": block_size,
        "polynomial_degree_bound": degree_bound,
        "phases_by_r_mod_3": phases,
        "identity_grid_reason": (
            "in each phase the determinant has degree at most 3b "
            "separately in (q,j), so the exact rectangular grid proves "
            "the displayed bivariate identity"
        ),
        "integer_interior_conclusion": (
            "nonzero for every integer level j>=1"
        ),
    }


def generate_certificate(operators):
    results = {}
    for label, residue in TYPES:
        backward = backward_factor_certificate(
            label, residue, operators
        )
        rows = []
        exact_lines = []
        sizes = {}
        for r in range(6, 36):
            row = mod20_block_schur(
                label, residue + 20 * r, operators
            )
            value = row["determinant"]
            phase = r % 3
            sizes.setdefault(str(phase), row["schur_size"])
            assert sizes[str(phase)] == row["schur_size"]
            rows.append(
                {
                    "r": r,
                    "schur_size": row["schur_size"],
                    "sign": (value > 0) - (value < 0),
                }
            )
            exact_lines.append(
                f"{r}:{value.numerator}/{value.denominator}\n"
            )
        digest = hashlib.sha256(
            "".join(exact_lines).encode("ascii")
        ).hexdigest()
        results[f"{label}_{residue}"] = {
            "module": label,
            "entrance_degrees": f"n={residue}+20r, r>=6",
            "global_level": "floor(h_exponent/3)",
            "backward_block": backward,
            "schur_sizes_by_r_mod_3": sizes,
            "finite_exact_audit": {
                "r_range": [6, 35],
                "count": len(rows),
                "rows": rows,
                "exact_fraction_stream_sha256": digest,
                "conclusion": (
                    "the selected endpoint Schur determinant is nonzero "
                    "through r=35"
                ),
            },
        }
    return {
        "schema": "c682-exceptional-monotone-schur-v1",
        "types": results,
        "derived_statement": (
            "For every exceptional modulo-20 entrance, ordering by "
            "floor(h/3) makes the incoming third-transvectant block "
            "tridiagonal. Its backward blocks are invertible at every "
            "integral interior level. Eliminating them leaves the "
            "recorded fixed signed block Schur complement."
        ),
        "finite_claim": (
            "All 120 selected endpoint Schur determinants for "
            "6<=r<=35 are exactly nonzero."
        ),
        "not_claimed": (
            "No all-r endpoint nonvanishing theorem is claimed; a "
            "signed invariant cone or equivalent global transfer "
            "argument remains necessary."
        ),
        "trusted_boundary": (
            "The checker imports the previously verified exact global "
            "Weyl operators. The backward determinant identity is "
            "proved within its formal bivariate degree bound; the "
            "Schur audit has the explicit finite stop r=35."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    operators = json.loads(OPERATORS.read_text(encoding="utf-8"))
    rendered = json.dumps(
        generate_certificate(operators), indent=2, sort_keys=True
    ) + "\n"
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")
        return
    assert CERTIFICATE.read_text(encoding="utf-8") == rendered
    print("PASS: exceptional monotone signed block Schur complements")


if __name__ == "__main__":
    main()
