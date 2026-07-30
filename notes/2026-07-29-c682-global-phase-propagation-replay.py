#!/usr/bin/env python3
"""Independent modular replay for the C682 global phase quotients."""

import importlib.util
import json
from fractions import Fraction
from functools import reduce
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
GLOBAL_REPLAY_PATH = HERE / "2026-07-29-c682-global-weyl-operators-replay.py"
GLOBAL_CERTIFICATE = HERE / "2026-07-29-c682-global-weyl-operators.json"
TRIVIAL_OPERATORS = HERE / "2026-07-29-c682-global-phase-trivial-operators.json"
BOUNDARY = HERE / "2026-07-29-c682-global-phase-boundary.json"
CERTIFICATE = HERE / "2026-07-29-c682-global-phase-propagation.json"
PRIMES = (1_000_000_007, 1_000_000_009)
GENERATOR_DEGREES = {
    "1": {"g0": 0, "g30": 30},
    "2": {"g1": 1, "g11": 11, "g19": 19, "g29": 29},
    "3": {
        "g2": 2,
        "g10": 10,
        "g12": 12,
        "g18": 18,
        "g20": 20,
        "g28": 28,
    },
    "3p": {
        "g6": 6,
        "g10": 10,
        "g14": 14,
        "g16": 16,
        "g20": 20,
        "g24": 24,
    },
}
EXPECTED_PEAKS = {
    "1": [0, 12, 20, 32, 40, 52],
    "2": [1, 11, 21, 31, 41, 51],
    "3": [2, 10, 22, 30, 42, 50],
    "3p": [6, 26, 46],
}


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


GLOBAL_REPLAY = load(GLOBAL_REPLAY_PATH, "phase_global_replay")
ORIGINAL_BUILD_DATA = GLOBAL_REPLAY.BASE.build_data


def primitive(polynomial):
    content = reduce(gcd, (abs(value) for value in polynomial.values()))
    return {
        monomial: coefficient // content
        for monomial, coefficient in polynomial.items()
    }


def build_data(label, tools, prime):
    if label != "1":
        return ORIGINAL_BUILD_DATA(label, tools, prime)
    klein_z = tools.KLEIN
    raw_hessian_z = tools.transvectant_z(klein_z, klein_z, 2)
    hessian_z = primitive(raw_hessian_z)
    raw_jacobian_z = tools.transvectant_z(
        klein_z, raw_hessian_z, 1
    )
    jacobian_z = primitive(raw_jacobian_z)
    reduce_mod = lambda polynomial: {
        monomial: coefficient % prime
        for monomial, coefficient in polynomial.items()
        if coefficient % prime
    }
    return (
        reduce_mod(klein_z),
        reduce_mod(hessian_z),
        [
            ("g0", 0, {(0, 0): 1}),
            ("g30", 30, reduce_mod(jacobian_z)),
        ],
    )


GLOBAL_REPLAY.BASE.build_data = build_data


def coefficient_mod(value, prime):
    rational = Fraction(value)
    return (
        rational.numerator * pow(rational.denominator, -1, prime)
    ) % prime


def falling(value, order, prime):
    out = 1
    for offset in range(order):
        out = out * (value - offset) % prime
    return out


def descriptors(label, degree):
    out = []
    for name, generator_degree in GENERATOR_DEGREES[label].items():
        remainder = degree - generator_degree
        if remainder < 0:
            continue
        for h_power in range(remainder // 20 + 1):
            residual = remainder - 20 * h_power
            if residual % 12 == 0:
                out.append((name, residual // 12, h_power))
    return out


def operator_matrix(label, degree, order, operators, prime):
    source = descriptors(label, degree)
    target = descriptors(label, degree + 12 - 2 * order)
    lookup = {descriptor: index for index, descriptor in enumerate(target)}
    columns = [[0] * len(target) for _ in source]
    for column, (source_name, f_power, h_power) in enumerate(source):
        for term in operators[label][str(order)]["terms"]:
            if term["source"] != source_name:
                continue
            scalar = (
                coefficient_mod(term["coefficient"], prime)
                * falling(f_power, term["dF_order"], prime)
                * falling(h_power, term["dH_order"], prime)
            ) % prime
            target_descriptor = (
                term["target"],
                f_power
                - term["dF_order"]
                + term["F_multiplier"],
                h_power
                - term["dH_order"]
                + term["H_multiplier"],
            )
            if scalar and target_descriptor in lookup:
                index = lookup[target_descriptor]
                columns[column][index] = (
                    columns[column][index] + scalar
                ) % prime
    return source, target, columns


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
    rows = [
        [columns[column][row] % prime for column in range(size)]
        for row in range(size)
    ]
    out = 1
    for column in range(size):
        pivot = next(
            (
                row
                for row in range(column, size)
                if rows[row][column]
            ),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            rows[column], rows[pivot] = rows[pivot], rows[column]
            out = -out % prime
        value = rows[column][column]
        out = out * value % prime
        inverse = pow(value, -1, prime)
        rows[column] = [
            entry * inverse % prime for entry in rows[column]
        ]
        for row in range(column + 1, size):
            if rows[row][column]:
                value = rows[row][column]
                rows[row] = [
                    (left - value * right) % prime
                    for left, right in zip(rows[row], rows[column])
                ]
    return out


def local_levels(rows):
    counts = {}
    levels = []
    for name, *_ in rows:
        levels.append(counts.get(name, 0))
        counts[name] = counts.get(name, 0) + 1
    return levels


def endpoint_index(rows, levels, key):
    maxima = {}
    for (name, *_), level in zip(rows, levels):
        maxima[name] = max(maxima.get(name, -1), level)
    name, depth = key
    return next(
        index
        for index, ((row_name, *_), level) in enumerate(zip(rows, levels))
        if row_name == name and maxima[name] - level == depth
    )


def phase_determinant(row, q, operators, prime):
    label = row["module"]
    degree = row["base_degree"] + 60 * q
    lower, current, incoming = operator_matrix(
        label, degree - 6, 3, operators, prime
    )
    _, upper, outgoing = operator_matrix(
        label, degree, 3, operators, prime
    )
    upper_2, current_2, ninth = operator_matrix(
        label, degree + 6, 9, operators, prime
    )
    assert upper == upper_2 and current == current_2
    current_levels = local_levels(current)
    lower_levels = local_levels(lower)
    maxima = {}
    for (name, *_), level in zip(current, current_levels):
        maxima[name] = max(maxima.get(name, -1), level)
    tail = [
        index
        for index, ((name, *_), level) in enumerate(
            zip(current, current_levels)
        )
        if level >= maxima[name] - 9
    ]
    tail_set = set(tail)
    local_incoming = [
        [value[index] for index in tail]
        for value in incoming
        if (
            (support := {
                index for index, entry in enumerate(value) if entry
            })
            and support <= tail_set
        )
    ]
    selected = [
        endpoint_index(lower, lower_levels, key)
        for key in row["endpoint_keys"]
    ]
    returned = []
    for index in selected:
        vector = matvec(
            ninth,
            matvec(outgoing, incoming[index], prime),
            prime,
        )
        assert all(
            not value or position in tail_set
            for position, value in enumerate(vector)
        )
        returned.append([vector[position] for position in tail])
    return determinant(local_incoming + returned, prime)


def relative_index(rows, key):
    return endpoint_index(rows, local_levels(rows), key)


def peak_composition_entry(
    label, residue, q, source_key, target_key, operators, prime
):
    degree = 60 + residue + 60 * q
    source, current, incoming = operator_matrix(
        label, degree - 6, 3, operators, prime
    )
    current_2, target, outgoing = operator_matrix(
        label, degree, 3, operators, prime
    )
    assert current == current_2
    source_index = relative_index(source, source_key)
    target_index = relative_index(target, target_key)
    middle = matvec(incoming, [
        1 if index == source_index else 0
        for index in range(len(source))
    ], prime)
    result = matvec(outgoing, middle, prime)
    return result[target_index]


def coefficient_count(k):
    if k < 0:
        return 0
    return sum(
        (k - 20 * h_power) % 12 == 0
        for h_power in range(k // 20 + 1)
    )


def multiplicity(label, degree):
    return sum(
        coefficient_count(degree - generator_degree)
        for generator_degree in GENERATOR_DEGREES[label].values()
    )


def replay_peaks():
    for label, expected in EXPECTED_PEAKS.items():
        actual = []
        for degree in range(120, 180):
            profile = [
                multiplicity(label, degree + shift)
                for shift in (-6, 0, 6)
            ]
            if profile[1] > max(profile[0], profile[2]):
                assert profile[0] + profile[2] > profile[1]
                actual.append(degree % 60)
        assert actual == expected


def main():
    operators = json.loads(
        GLOBAL_CERTIFICATE.read_text(encoding="utf-8")
    )["operators"]
    trivial = json.loads(
        TRIVIAL_OPERATORS.read_text(encoding="utf-8")
    )
    operators.update(trivial)
    boundary = json.loads(BOUNDARY.read_text(encoding="utf-8"))
    certificate = json.loads(
        CERTIFICATE.read_text(encoding="utf-8")
    )
    for prime in PRIMES:
        for order_text, operator in trivial["1"].items():
            order = int(order_text)
            for generator_index, source_name in enumerate(
                operator["generator_names"]
            ):
                for f_power, h_power in (
                    (order + 3, order + 4),
                    (order + 4, order + 3),
                ):
                    assert GLOBAL_REPLAY.direct_transition(
                        "1",
                        order,
                        f_power,
                        h_power,
                        generator_index,
                        prime,
                    ) == GLOBAL_REPLAY.predicted_transition(
                        operator,
                        source_name,
                        f_power,
                        h_power,
                        prime,
                    )
        for row in boundary.values():
            assert phase_determinant(row, 13, operators, prime)
            assert phase_determinant(row, 17, operators, prime)
        for label, rows in certificate["peak_propagation"][
            "families"
        ].items():
            for row in rows:
                witness = row["composition_witness"]
                for q in (13, 17):
                    assert peak_composition_entry(
                        label,
                        row["residue_mod_60"],
                        q,
                        witness["source_key"],
                        witness["target_key"],
                        operators,
                        prime,
                    )
    replay_peaks()
    print("PASS: independent modular C682 global phase replay")


if __name__ == "__main__":
    main()
