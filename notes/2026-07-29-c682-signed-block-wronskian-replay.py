#!/usr/bin/env python3
"""Independent modular replay of the C682 signed boundary Wronskians."""

import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-29-c682-nontrivial-plateau-controllability-replay.py"
OPERATORS = HERE / "2026-07-29-c682-signed-block-wronskian-operators.json"
PRIMES = (1_000_000_007, 1_000_000_009)
FAMILIES = {"2": 63, "3": 72, "3p": 70}
GENERATORS = {
    "2": (("g1", 1), ("g11", 11), ("g19", 19), ("g29", 29)),
    "3": (
        ("g2", 2),
        ("g10", 10),
        ("g12", 12),
        ("g18", 18),
        ("g20", 20),
        ("g28", 28),
    ),
    "3p": (
        ("g6", 6),
        ("g10", 10),
        ("g14", 14),
        ("g16", 16),
        ("g20", 20),
        ("g24", 24),
    ),
}
EXPECTED_SMITH_VALUATIONS = {
    "2": [0] * 17 + [3, 4, 6],
    "3": [0] * 26 + [3, 4, 4, 6],
    "3p": [0] * 26 + [3, 3, 4, 8],
}
SPECS = {
    "incoming": ("lower", "current", 3),
    "outgoing": ("current", "upper", 3),
    "ninth": ("upper", "current", 9),
}


def load_base():
    spec = importlib.util.spec_from_file_location(
        "signed_wronskian_modular_base", BASE
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def monomials(total_degree):
    return [
        (q_degree, j_degree)
        for total in range(total_degree + 1)
        for q_degree in range(total + 1)
        for j_degree in [total - q_degree]
    ]


def evaluate(coefficients, degree, q, level, prime):
    return sum(
        (
            Fraction(value).numerator
            * pow(Fraction(value).denominator, -1, prime)
            * pow(q, q_degree, prime)
            * pow(level, j_degree, prime)
        )
        for (q_degree, j_degree), value in zip(
            monomials(degree), coefficients
        )
    ) % prime


def direct_operators(label, q, prime, certificate):
    replay = load_base()
    tools = replay.load_base()
    data = replay.build_data(label, tools, prime)
    degree = FAMILIES[label] + 60 * q
    spaces = {
        "lower": replay.candidates(degree - 6, data, tools, prime),
        "current": replay.candidates(degree, data, tools, prime),
        "upper": replay.candidates(degree + 6, data, tools, prime),
    }
    matrices = {}
    for operator, (source_kind, target_kind, order) in SPECS.items():
        source = spaces[source_kind]
        target = spaces[target_kind]
        target_degree = degree + {
            "lower": -6,
            "current": 0,
            "upper": 6,
        }[target_kind]
        target_columns = [
            tools.coefficient_vector(polynomial, target_degree)
            for _, _, _, polynomial in target
        ]
        target_levels = replay.local_levels(target)
        source_levels = replay.local_levels(source)
        target_lookup = {
            (name, level): index
            for index, ((name, _, _, _), level) in enumerate(
                zip(target, target_levels)
            )
        }
        universal = certificate[label][operator]
        columns = []
        for (source_name, _, _, polynomial), level in zip(
            source, source_levels
        ):
            image = tools.transvectant(polynomial, data[0], order, prime)
            coordinates = replay.solve_columns(
                target_columns,
                tools.coefficient_vector(image, target_degree),
                prime,
            )
            expected = [0] * len(target)
            prefix = f"{source_name}->"
            for key, coefficients in universal["couplings"].items():
                if not key.startswith(prefix):
                    continue
                rest = key.split("->", 1)[1]
                target_name, offset_text = rest.split("@")
                target_index = target_lookup.get(
                    (target_name, level + int(offset_text))
                )
                if target_index is not None:
                    expected[target_index] = evaluate(
                        coefficients,
                        universal["degree_bound"],
                        q,
                        level,
                        prime,
                    )
            assert coordinates == expected
            columns.append(coordinates)
        matrices[operator] = columns
    return spaces, matrices


def matvec(columns, vector, prime):
    return [
        sum(
            vector[column] * columns[column][row]
            for column in range(len(columns))
        )
        % prime
        for row in range(len(columns[0]))
    ]


def determinant(columns, prime):
    size = len(columns)
    work = [
        [columns[column][row] % prime for column in range(size)]
        for row in range(size)
    ]
    out = 1
    for column in range(size):
        pivot = next(
            (
                row
                for row in range(column, size)
                if work[row][column]
            ),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            out = -out
        value = work[column][column]
        out = out * value % prime
        inverse = pow(value, -1, prime)
        work[column] = [
            entry * inverse % prime for entry in work[column]
        ]
        for row in range(column + 1, size):
            if not work[row][column]:
                continue
            value = work[row][column]
            work[row] = [
                (left - value * right) % prime
                for left, right in zip(work[row], work[column])
            ]
    return out % prime


def descriptors(label, degree):
    out = []
    for name, generator_degree in GENERATORS[label]:
        remainder = degree - generator_degree
        for h_power in range(max(-1, remainder // 20) + 1):
            residual = remainder - 20 * h_power
            if residual >= 0 and residual % 12 == 0:
                out.append((name, residual // 12, h_power))
    return out


def levels(rows):
    counts = {}
    out = []
    for name, *_ in rows:
        out.append(counts.get(name, 0))
        counts[name] = counts.get(name, 0) + 1
    return out


def formula_operators(label, q, prime, operators):
    degree = FAMILIES[label] + 60 * q
    spaces = {
        "lower": descriptors(label, degree - 6),
        "current": descriptors(label, degree),
        "upper": descriptors(label, degree + 6),
    }
    matrices = {}
    for operator, (source_kind, target_kind, _) in SPECS.items():
        source = spaces[source_kind]
        target = spaces[target_kind]
        target_lookup = {
            (name, level): index
            for index, ((name, _, _), level) in enumerate(
                zip(target, levels(target))
            )
        }
        universal = operators[label][operator]
        columns = []
        for (source_name, _, _), level in zip(source, levels(source)):
            column = [0] * len(target)
            prefix = f"{source_name}->"
            for key, coefficients in universal["couplings"].items():
                if not key.startswith(prefix):
                    continue
                rest = key.split("->", 1)[1]
                target_name, offset_text = rest.split("@")
                target_index = target_lookup.get(
                    (target_name, level + int(offset_text))
                )
                if target_index is not None:
                    column[target_index] = evaluate(
                        coefficients,
                        universal["degree_bound"],
                        q,
                        level,
                        prime,
                    )
            columns.append(column)
        matrices[operator] = columns
    return spaces, matrices


def boundary_columns(label, spaces, matrices, prime):
    lower = spaces["lower"]
    current = spaces["current"]
    incoming = matrices["incoming"]
    current_levels = levels(current)
    lower_levels = levels(lower)
    current_maxima = {}
    lower_maxima = {}
    for (name, _, _), level in zip(current, current_levels):
        current_maxima[name] = max(current_maxima.get(name, -1), level)
    for (name, _, _), level in zip(lower, lower_levels):
        lower_maxima[name] = max(lower_maxima.get(name, -1), level)
    tail = [
        index
        for index, ((name, _, _), level) in enumerate(
            zip(current, current_levels)
        )
        if level >= current_maxima[name] - 9
    ]
    tail_set = set(tail)
    local_incoming = [
        column
        for column in incoming
        if (
            (support := {
                index for index, value in enumerate(column) if value
            })
            and support <= tail_set
        )
    ]
    depth = {"2": 2, "3": 2, "3p": 3}[label]
    candidates = [
        index
        for index, ((name, _, _), level) in enumerate(
            zip(lower, lower_levels)
        )
        if level >= lower_maxima[name] - depth + 1
    ]
    endpoint_indices = candidates[: len(tail) - len(local_incoming)]
    returned = [
        matvec(
            matrices["ninth"],
            matvec(matrices["outgoing"], incoming[index], prime),
            prime,
        )
        for index in endpoint_indices
    ]
    return [
        [column[index] for index in tail]
        for column in local_incoming + returned
    ], len(local_incoming)


def polynomial_coefficients(values, prime):
    differences = values
    newton = []
    while differences:
        newton.append(differences[0])
        differences = [
            (right - left) % prime
            for left, right in zip(differences, differences[1:])
        ]
    out = [0] * len(values)
    basis = [1]
    for degree, coefficient in enumerate(newton):
        for index, value in enumerate(basis):
            out[index] = (out[index] + coefficient * value) % prime
        inverse = pow(degree + 1, -1, prime)
        factor = [(-degree * inverse) % prime, inverse]
        product = [0] * (len(basis) + 1)
        for left_degree, left_value in enumerate(basis):
            for right_degree, right_value in enumerate(factor):
                product[left_degree + right_degree] = (
                    product[left_degree + right_degree]
                    + left_value * right_value
                ) % prime
        basis = product
    return out


def smith_valuations_at_infinity(label, prime, operators):
    samples = []
    local_count = None
    for q in range(10, 26):
        spaces, matrices = formula_operators(
            label, q, prime, operators
        )
        columns, local_count = boundary_columns(
            label, spaces, matrices, prime
        )
        samples.append(columns)
    size = len(samples[0])
    degrees = [3] * local_count + [15] * (size - local_count)
    precision = 24
    matrix = []
    for row in range(size):
        series_row = []
        for column, degree in enumerate(degrees):
            polynomial = polynomial_coefficients(
                [
                    samples[sample][column][row]
                    for sample in range(degree + 1)
                ],
                prime,
            )
            polynomial += [0] * (degree + 1 - len(polynomial))
            series_row.append(
                list(reversed(polynomial))
                + [0] * (precision - degree)
            )
        matrix.append(series_row)

    def valuation(series):
        return next(
            (index for index, value in enumerate(series) if value),
            len(series),
        )

    def multiply(left, right):
        out = [0] * len(left)
        for left_degree, left_value in enumerate(left):
            for right_degree, right_value in enumerate(
                right[: len(out) - left_degree]
            ):
                out[left_degree + right_degree] = (
                    out[left_degree + right_degree]
                    + left_value * right_value
                ) % prime
        return out

    def quotient(numerator, denominator):
        shift = valuation(denominator)
        assert valuation(numerator) >= shift
        numerator = numerator[shift:] + [0] * shift
        denominator = denominator[shift:] + [0] * shift
        out = [0] * len(numerator)
        inverse = pow(denominator[0], -1, prime)
        for degree in range(len(out)):
            value = numerator[degree]
            for lower_degree in range(1, degree + 1):
                value -= (
                    denominator[lower_degree]
                    * out[degree - lower_degree]
                )
            out[degree] = value * inverse % prime
        return out

    valuations = []
    for pivot_index in range(size):
        value, pivot_row, pivot_column = min(
            (
                valuation(matrix[row][column]),
                row,
                column,
            )
            for row in range(pivot_index, size)
            for column in range(pivot_index, size)
        )
        assert value <= precision
        matrix[pivot_index], matrix[pivot_row] = (
            matrix[pivot_row],
            matrix[pivot_index],
        )
        for row in matrix:
            row[pivot_index], row[pivot_column] = (
                row[pivot_column],
                row[pivot_index],
            )
        valuations.append(value)
        for row in range(pivot_index + 1, size):
            if valuation(matrix[row][pivot_index]) > precision:
                continue
            multiplier = quotient(
                matrix[row][pivot_index],
                matrix[pivot_index][pivot_index],
            )
            for column in range(pivot_index, size):
                product = multiply(
                    multiplier, matrix[pivot_index][column]
                )
                matrix[row][column] = [
                    (left - right) % prime
                    for left, right in zip(
                        matrix[row][column], product
                    )
                ]
    return valuations


def boundary_determinant(label, spaces, matrices, prime):
    replay = load_base()
    lower = spaces["lower"]
    current = spaces["current"]
    incoming = matrices["incoming"]
    current_levels = replay.local_levels(current)
    lower_levels = replay.local_levels(lower)
    current_maxima = {}
    lower_maxima = {}
    for (name, _, _, _), level in zip(current, current_levels):
        current_maxima[name] = max(current_maxima.get(name, -1), level)
    for (name, _, _, _), level in zip(lower, lower_levels):
        lower_maxima[name] = max(lower_maxima.get(name, -1), level)
    tail = [
        index
        for index, ((name, _, _, _), level) in enumerate(
            zip(current, current_levels)
        )
        if level >= current_maxima[name] - 9
    ]
    tail_set = set(tail)
    local_incoming = [
        column
        for column in incoming
        if (
            (support := {
                index for index, value in enumerate(column) if value
            })
            and support <= tail_set
        )
    ]
    depth = {"2": 2, "3": 2, "3p": 3}[label]
    candidates = [
        index
        for index, ((name, _, _, _), level) in enumerate(
            zip(lower, lower_levels)
        )
        if level >= lower_maxima[name] - depth + 1
    ]
    quotient_dimension = len(tail) - len(local_incoming)
    endpoint_indices = candidates[:quotient_dimension]
    returned = [
        matvec(
            matrices["ninth"],
            matvec(
                matrices["outgoing"],
                incoming[index],
                prime,
            ),
            prime,
        )
        for index in endpoint_indices
    ]
    square = [
        [column[index] for index in tail]
        for column in local_incoming + returned
    ]
    assert len(square) == len(tail)
    return determinant(square, prime)


def main():
    operators = json.loads(OPERATORS.read_text(encoding="utf-8"))
    q = 13
    for prime in PRIMES:
        for label in FAMILIES:
            spaces, matrices = direct_operators(
                label, q, prime, operators
            )
            assert boundary_determinant(
                label, spaces, matrices, prime
            )
            assert smith_valuations_at_infinity(
                label, prime, operators
            ) == EXPECTED_SMITH_VALUATIONS[label]
    print("PASS: independent modular C682 signed-Wronskian replay")


if __name__ == "__main__":
    main()
