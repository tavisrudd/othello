#!/usr/bin/env python3
"""Signed block Wronskians and all-q endpoint mixing for C682."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from functools import cache, reduce
from math import comb, gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-29-c682-nontrivial-plateau-controllability.py"
CERTIFICATE = HERE / "2026-07-29-c682-signed-block-wronskian.json"
OPERATORS = HERE / "2026-07-29-c682-signed-block-wronskian-operators.json"
BOUNDARY = HERE / "2026-07-29-c682-signed-block-wronskian-boundary.json"
FAMILIES = {"2": 63, "3": 72, "3p": 70}
OPERATOR_SPECS = {
    "incoming": ("lower", "current", 3, 3, 6),
    "outgoing": ("current", "upper", 3, 3, 6),
    "ninth": ("upper", "current", 9, 9, 12),
}


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


@cache
def base():
    return load(BASE_PATH, "signed_block_wronskian_base")


def monomials(total_degree):
    return [
        (q_degree, j_degree)
        for total in range(total_degree + 1)
        for q_degree in range(total + 1)
        for j_degree in [total - q_degree]
    ]


def descriptors(label, degree):
    generators = base().module_data(label)[-1]
    out = []
    for name, generator_degree, _ in generators:
        remainder = degree - generator_degree
        if remainder < 0:
            continue
        for h_power in range(remainder // 20 + 1):
            residual = remainder - 20 * h_power
            if residual % 12 == 0:
                out.append((name, residual // 12, h_power))
    return out


def local_levels(rows):
    counts = {}
    out = []
    for name, *_ in rows:
        out.append(counts.get(name, 0))
        counts[name] = counts.get(name, 0) + 1
    return out


@cache
def exact_spaces(label, q):
    data = base().module_data(label)
    degree = FAMILIES[label] + 60 * q
    return {
        "lower": base().candidates(degree - 6, data),
        "current": base().candidates(degree, data),
        "upper": base().candidates(degree + 6, data),
    }


@cache
def exact_operator(label, q, operator):
    source_kind, target_kind, order, _, _ = OPERATOR_SPECS[operator]
    data = base().module_data(label)
    exact, tools, klein, _, _ = data
    spaces = exact_spaces(label, q)
    source = spaces[source_kind]
    target = spaces[target_kind]
    target_degree = FAMILIES[label] + 60 * q + {
        "lower": -6,
        "current": 0,
        "upper": 6,
    }[target_kind]
    target_columns = [
        exact.coefficient_vector(polynomial, target_degree)
        for _, _, _, polynomial in target
    ]
    columns = []
    for _, _, _, polynomial in source:
        image = tools.transvectant(polynomial, klein, order)
        columns.append(
            exact.solve_columns(
                target_columns,
                exact.coefficient_vector(image, target_degree),
            )
        )
    return columns


def solve_overdetermined(rows, unknowns):
    work = [[Fraction(value) for value in row] for row in rows]
    pivot_row = 0
    pivots = []
    for column in range(unknowns):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(work))
                if work[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        value = work[pivot_row][column]
        work[pivot_row] = [entry / value for entry in work[pivot_row]]
        for row in range(len(work)):
            if row == pivot_row or not work[row][column]:
                continue
            value = work[row][column]
            work[row] = [
                left - value * right
                for left, right in zip(work[row], work[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    assert pivots == list(range(unknowns))
    assert all(
        not any(row[:unknowns]) and not row[-1]
        for row in work[pivot_row:]
    )
    return [work[row][-1] for row in range(unknowns)]


def universal_operator(label, operator):
    source_kind, target_kind, _, degree_bound, sample_q_max = (
        OPERATOR_SPECS[operator]
    )
    mons = monomials(degree_bound)
    samples = {}
    patterns = set()
    for q in range(1, sample_q_max + 1):
        spaces = exact_spaces(label, q)
        source = spaces[source_kind]
        target = spaces[target_kind]
        source_levels = local_levels(source)
        target_levels = local_levels(target)
        target_lookup = {
            (name, level): index
            for index, ((name, _, _, _), level) in enumerate(
                zip(target, target_levels)
            )
        }
        target_names = list(dict.fromkeys(row[0] for row in target))
        columns = exact_operator(label, q, operator)
        for column, ((source_name, _, _, _), level) in enumerate(
            zip(source, source_levels)
        ):
            nonzero_indices = {
                index for index, value in enumerate(columns[column]) if value
            }
            accounted = set()
            for target_name in target_names:
                for target_level in range(max(target_levels) + 1):
                    target_index = target_lookup.get((target_name, target_level))
                    if target_index is None:
                        continue
                    value = columns[column][target_index]
                    offset = target_level - level
                    key = (source_name, target_name, offset)
                    if value:
                        patterns.add(key)
                        accounted.add(target_index)
                    samples.setdefault(key, []).append((q, level, value))
            assert nonzero_indices == accounted
    couplings = {}
    for key in sorted(patterns):
        rows = []
        for q, level, value in samples[key]:
            rows.append(
                [
                    Fraction(q) ** q_degree
                    * Fraction(level) ** j_degree
                    for q_degree, j_degree in mons
                ]
                + [value]
            )
        coefficients = solve_overdetermined(rows, len(mons))
        couplings[f"{key[0]}->{key[1]}@{key[2]:+d}"] = [
            str(value) for value in coefficients
        ]
    return {
        "source": source_kind,
        "target": target_kind,
        "order": OPERATOR_SPECS[operator][2],
        "degree_bound": degree_bound,
        "coefficient_monomials": [
            f"q^{q_degree}j^{j_degree}" for q_degree, j_degree in mons
        ],
        "sample_q_values": list(range(1, sample_q_max + 1)),
        "couplings": couplings,
    }


def evaluate(coefficients, mons, q, level):
    return sum(
        Fraction(value) * q**q_degree * level**j_degree
        for (q_degree, j_degree), value in zip(mons, coefficients)
    )


def operator_matrix(label, q, operator, universal):
    source_kind, target_kind, _, degree_bound, _ = OPERATOR_SPECS[operator]
    degree = FAMILIES[label] + 60 * q
    degrees = {"lower": degree - 6, "current": degree, "upper": degree + 6}
    source = descriptors(label, degrees[source_kind])
    target = descriptors(label, degrees[target_kind])
    source_levels = local_levels(source)
    target_levels = local_levels(target)
    target_lookup = {
        (name, level): index
        for index, ((name, _, _), level) in enumerate(zip(target, target_levels))
    }
    mons = monomials(degree_bound)
    columns = [[Fraction(0)] * len(target) for _ in source]
    for column, ((source_name, _, _), level) in enumerate(
        zip(source, source_levels)
    ):
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
                columns[column][target_index] = evaluate(
                    coefficients, mons, q, level
                )
    return source, target, columns


def homogeneous_null(equations, unknowns, normalize_index):
    work = [
        [Fraction(value) for value in row] + [Fraction(0)]
        for row in equations
    ]
    pivot_row = 0
    pivots = []
    determinant = Fraction(1)
    for column in range(unknowns):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(work))
                if work[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        if pivot != pivot_row:
            determinant = -determinant
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        value = work[pivot_row][column]
        determinant *= value
        work[pivot_row] = [entry / value for entry in work[pivot_row]]
        for row in range(pivot_row + 1, len(work)):
            if not work[row][column]:
                continue
            value = work[row][column]
            work[row] = [
                left - value * right
                for left, right in zip(work[row], work[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    free = [column for column in range(unknowns) if column not in pivots]
    assert len(free) == 1
    vector = [Fraction(0)] * unknowns
    vector[free[0]] = Fraction(1)
    for row, pivot in reversed(list(enumerate(pivots))):
        vector[pivot] = -sum(
            work[row][column] * vector[column]
            for column in range(pivot + 1, unknowns)
        )
    assert vector[normalize_index]
    scale = vector[normalize_index]
    return [value / scale for value in vector], determinant


def endpoint_pairing(label, q, operators):
    lower, current, incoming = operator_matrix(
        label, q, "incoming", operators[label]["incoming"]
    )
    current_2, upper, outgoing = operator_matrix(
        label, q, "outgoing", operators[label]["outgoing"]
    )
    upper_2, current_3, ninth = operator_matrix(
        label, q, "ninth", operators[label]["ninth"]
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    endpoint = [Fraction(0)] * len(lower)
    endpoint[-1] = Fraction(1)
    incoming_endpoint = matvec(incoming, endpoint)
    returned = matvec(ninth, matvec(outgoing, incoming_endpoint))

    current_levels = local_levels(current)
    lower_levels = local_levels(lower)
    variable_order = sorted(
        range(len(current)),
        key=lambda index: (current_levels[index], current[index][0]),
    )
    equation_order = sorted(
        range(len(lower)),
        key=lambda index: (lower_levels[index], lower[index][0]),
    )
    equations = [
        [incoming[column][index] for index in variable_order]
        for column in equation_order
    ]
    normalize_index = variable_order.index(len(current) - 1)
    ordered_null, reference_minor = homogeneous_null(
        equations, len(current), normalize_index
    )
    null = [Fraction(0)] * len(current)
    for position, index in enumerate(variable_order):
        null[index] = ordered_null[position]
    pairing = dot(null, returned)
    assert pairing
    return {
        "lower_dimension": len(lower),
        "current_dimension": len(current),
        "tail_dimension": len(current),
        "return_support": sum(bool(value) for value in returned),
        "pairing": pairing,
        "left_normalized_pairing": pairing / null[0],
        "signed_wronskian": pairing * reference_minor,
    }


def matvec(columns, vector):
    assert len(columns) == len(vector)
    if not columns:
        return []
    return [
        sum(vector[column] * columns[column][row] for column in range(len(columns)))
        for row in range(len(columns[0]))
    ]


def determinant_columns(columns):
    size = len(columns)
    work = [
        [Fraction(columns[column][row]) for column in range(size)]
        for row in range(size)
    ]
    determinant = Fraction(1)
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
            return Fraction(0)
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            determinant = -determinant
        value = work[column][column]
        determinant *= value
        work[column] = [entry / value for entry in work[column]]
        for row in range(column + 1, size):
            if not work[row][column]:
                continue
            value = work[row][column]
            work[row] = [
                left - value * right
                for left, right in zip(work[row], work[column])
            ]
    return determinant


def boundary_wronskian(label, q, operators):
    lower, current, incoming = operator_matrix(
        label, q, "incoming", operators[label]["incoming"]
    )
    _, upper, outgoing = operator_matrix(
        label, q, "outgoing", operators[label]["outgoing"]
    )
    upper_2, _, ninth = operator_matrix(
        label, q, "ninth", operators[label]["ninth"]
    )
    assert upper == upper_2
    current_levels = local_levels(current)
    lower_levels = local_levels(lower)
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
    endpoint_candidates = [
        index
        for index, ((name, _, _), level) in enumerate(
            zip(lower, lower_levels)
        )
        if level >= lower_maxima[name] - depth + 1
    ]
    quotient_dimension = len(tail) - len(local_incoming)
    endpoint_indices = endpoint_candidates[:quotient_dimension]
    returned = [
        matvec(ninth, matvec(outgoing, incoming[index]))
        for index in endpoint_indices
    ]
    assert all(
        all(not value or index in tail_set for index, value in enumerate(column))
        for column in returned
    )
    square_columns = [
        [column[index] for index in tail]
        for column in local_incoming + returned
    ]
    assert len(square_columns) == len(tail)
    return {
        "determinant": determinant_columns(square_columns),
        "tail_dimension": len(tail),
        "quotient_dimension": quotient_dimension,
        "endpoint_indices": endpoint_indices,
    }


def polynomial_value(coefficients, value):
    out = Fraction(0)
    for coefficient in reversed(coefficients):
        out = out * value + coefficient
    return out


def shifted_coefficients(coefficients, shift):
    out = [0] * len(coefficients)
    for degree, value in enumerate(coefficients):
        for new_degree in range(degree + 1):
            out[new_degree] += value * comb(degree, new_degree) * shift ** (
                degree - new_degree
            )
    return out


def uniform_sign(coefficients):
    signs = {(value > 0) - (value < 0) for value in coefficients if value}
    return signs.pop() if len(signs) == 1 else 0


def green_identity_check(label, recurrence):
    mons = monomials(3)
    q = 13
    j = 4
    couplings = recurrence["couplings"]
    source_names = []
    target_names = []
    for key in couplings:
        source, rest = key.split("->")
        target = rest.split("@")[0]
        if source not in source_names:
            source_names.append(source)
        if target not in target_names:
            target_names.append(target)

    def block(offset, level):
        return [
            [
                evaluate(
                    couplings.get(
                        f"{source}->{target}@{offset:+d}",
                        ["0"] * len(mons),
                    ),
                    mons,
                    q,
                    level,
                )
                for target in target_names
            ]
            for source in source_names
        ]

    size = len(source_names)
    x_minus = [Fraction(k + 1) for k in range(size)]
    x_zero = [Fraction(2 * k + 3) for k in range(size)]
    x_plus = [Fraction(3 * k + 2) for k in range(size)]
    y_minus = [Fraction(5 * k + 1) for k in range(size)]
    y_zero = [Fraction(7 * k + 4) for k in range(size)]
    y_plus = [Fraction(11 * k + 3) for k in range(size)]
    a_j, b_j, c_j = block(-1, j), block(0, j), block(1, j)
    c_prev = block(1, j - 1)
    a_next = block(-1, j + 1)
    lx = add(matvec_rows(a_j, x_minus), matvec_rows(b_j, x_zero), matvec_rows(c_j, x_plus))
    lstary = add(
        matvec_rows(transpose(c_prev), y_minus),
        matvec_rows(transpose(b_j), y_zero),
        matvec_rows(transpose(a_next), y_plus),
    )
    left = dot(y_zero, lx) - dot(lstary, x_zero)
    w_j = dot(y_zero, matvec_rows(c_j, x_plus)) - dot(
        y_plus, matvec_rows(a_next, x_zero)
    )
    w_prev = dot(y_minus, matvec_rows(c_prev, x_zero)) - dot(
        y_zero, matvec_rows(a_j, x_minus)
    )
    assert left == w_j - w_prev
    return {
        "formula": (
            "W_j(y,x)=y_j^T C_j x_{j+1}"
            "-y_{j+1}^T A_{j+1}x_j"
        ),
        "green_identity": (
            "W_j-W_{j-1}=y_j^T(Lx)_j-(L^*y)_j^T x_j"
        ),
        "checked_at": {"q": q, "j": j},
    }


def matvec_rows(matrix, vector):
    return [sum(left * right for left, right in zip(row, vector)) for row in matrix]


def transpose(matrix):
    return [list(column) for column in zip(*matrix)]


def add(*vectors):
    return [sum(entries) for entries in zip(*vectors)]


def dot(left, right):
    return sum(a * b for a, b in zip(left, right))


def generate_operators():
    return {
        label: {
            operator: universal_operator(label, operator)
            for operator in OPERATOR_SPECS
        }
        for label in FAMILIES
    }


def generate_boundary(operators):
    out = {}
    for label in FAMILIES:
        first = boundary_wronskian(label, 10, operators)
        size = first["tail_dimension"]
        quotient = first["quotient_dimension"]
        degree_bound = 3 * (size - quotient) + 15 * quotient
        values = [
            boundary_wronskian(label, q, operators)["determinant"]
            for q in range(10, 10 + degree_bound + 1)
        ]
        differences = values
        coefficients = []
        while differences:
            coefficients.append(differences[0])
            differences = [
                right - left
                for left, right in zip(differences, differences[1:])
            ]
        while coefficients and not coefficients[-1]:
            coefficients.pop()
        out[label] = {
            "base_q": 10,
            "tail_dimension": size,
            "quotient_dimension": quotient,
            "endpoint_indices_at_q10": first["endpoint_indices"],
            "degree_bound": degree_bound,
            "degree": len(coefficients) - 1,
            "newton_coefficients": [str(value) for value in coefficients],
        }
    return out


def polynomial_add_univariate(left, right):
    out = [Fraction(0)] * max(len(left), len(right))
    for index, value in enumerate(left):
        out[index] += value
    for index, value in enumerate(right):
        out[index] += value
    while out and not out[-1]:
        out.pop()
    return out


def polynomial_multiply_univariate(left, right):
    out = [Fraction(0)] * (len(left) + len(right) - 1)
    for left_degree, left_value in enumerate(left):
        for right_degree, right_value in enumerate(right):
            out[left_degree + right_degree] += left_value * right_value
    return out


def newton_to_monomial(coefficients):
    out = []
    basis = [Fraction(1)]
    for degree, coefficient in enumerate(coefficients):
        out = polynomial_add_univariate(
            out, [coefficient * value for value in basis]
        )
        basis = polynomial_multiply_univariate(
            basis,
            [Fraction(-degree, degree + 1), Fraction(1, degree + 1)],
        )
    return out


def divide_linear(polynomial, root):
    quotient = [Fraction(0)] * (len(polynomial) - 1)
    carry = polynomial[-1]
    for degree in range(len(polynomial) - 2, -1, -1):
        quotient[degree] = carry
        carry = polynomial[degree] + root * carry
    assert not carry
    while quotient and not quotient[-1]:
        quotient.pop()
    return quotient


def certificate(operators, boundary_data):
    results = {}
    for label in FAMILIES:
        row = boundary_data[label]
        base_q = row["base_q"]
        polynomial = newton_to_monomial(
            [Fraction(value) for value in row["newton_coefficients"]]
        )
        roots = []
        residual = polynomial
        for root in range(-500, 0):
            while (
                len(residual) > 1
                and not polynomial_value(residual, root)
            ):
                roots.append(root)
                residual = divide_linear(residual, Fraction(root))
        shift = next(
            candidate
            for candidate in range(501)
            if uniform_sign(shifted_coefficients(residual, candidate))
        )
        threshold = base_q + shift
        shifted_residual = shifted_coefficients(residual, shift)
        finite_boundary = [
            boundary_wronskian(label, q, operators)["determinant"]
            for q in range(base_q, threshold)
        ]
        low_pairings = [
            endpoint_pairing(label, q, operators)["pairing"]
            for q in range(1, base_q)
        ]
        assert all(finite_boundary)
        assert all(low_pairings)
        results[label] = {
            "family": f"n={FAMILIES[label]}+60q",
            "tail_dimension": row["tail_dimension"],
            "quotient_dimension": row["quotient_dimension"],
            "degree_bound": row["degree_bound"],
            "exact_degree": row["degree"],
            "linear_roots_in_x_equals_q_minus_10": roots,
            "residual_degree": len(residual) - 1,
            "positivity_threshold_q": threshold,
            "shifted_residual_coefficient_sign": uniform_sign(
                shifted_residual
            ),
            "shifted_residual_nonzero_coefficients": sum(
                bool(value) for value in shifted_residual
            ),
            "finite_boundary_signs_q10_to_threshold_minus_1": [
                (value > 0) - (value < 0)
                for value in finite_boundary
            ],
            "low_endpoint_pairing_signs_q1_to_9": [
                (value > 0) - (value < 0) for value in low_pairings
            ],
            "conclusion": (
                "the boundary return map is onto the local quotient for "
                "every q>=10, and an endpoint return mixes for every q>=1"
            ),
        }
    incoming = {
        label: operators[label]["incoming"] for label in FAMILIES
    }
    return {
        "schema": "c682-signed-block-wronskian-v1",
        "operator_summary": {
            label: {
                operator: {
                    "degree_bound": data["degree_bound"],
                    "couplings": len(data["couplings"]),
                }
                for operator, data in operators[label].items()
            }
            for label in FAMILIES
        },
        "signed_block_wronskians": {
            label: green_identity_check(label, incoming[label])
            for label in FAMILIES
        },
        "boundary_quotient_wronskians": results,
        "claim": (
            "At least one fixed endpoint return has nonzero contraction "
            "for every integer q>=1 in each first 2, 3, and 3' plateau."
        ),
        "trusted_boundary": (
            "The operator coefficients are interpolated only within formal "
            "differential-order bounds 3,3,9. The boundary determinants are "
            "fixed polynomial matrices: their degree bounds plus the stored "
            "Newton coefficients prove the identities, and coefficientwise "
            "signs after the recorded shifts prove all-q nonvanishing."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write-operators", action="store_true")
    mode.add_argument("--write-boundary", action="store_true")
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    if arguments.write_operators:
        rendered = json.dumps(generate_operators(), indent=2, sort_keys=True) + "\n"
        OPERATORS.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {OPERATORS}")
        return
    operators = json.loads(OPERATORS.read_text(encoding="utf-8"))
    if arguments.write_boundary:
        rendered = json.dumps(
            generate_boundary(operators), indent=2, sort_keys=True
        ) + "\n"
        BOUNDARY.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {BOUNDARY}")
        return
    if arguments.check:
        operators = generate_operators()
        expected_operators = json.dumps(operators, indent=2, sort_keys=True) + "\n"
        assert OPERATORS.read_text(encoding="utf-8") == expected_operators
        expected_boundary = json.dumps(
            generate_boundary(operators), indent=2, sort_keys=True
        ) + "\n"
        assert BOUNDARY.read_text(encoding="utf-8") == expected_boundary
    boundary_data = json.loads(BOUNDARY.read_text(encoding="utf-8"))
    rendered = json.dumps(
        certificate(operators, boundary_data), indent=2, sort_keys=True
    ) + "\n"
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")
    elif arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 signed block Wronskians and all-q endpoint mixing")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
