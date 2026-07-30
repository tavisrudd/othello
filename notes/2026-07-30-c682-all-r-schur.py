#!/usr/bin/env python3
"""All-length analysis for the four exceptional C682 Schur sequences."""

from __future__ import annotations

import argparse
import importlib.util
import json
from functools import cache, reduce
from fractions import Fraction
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
SCHUR_PATH = HERE / "2026-07-30-c682-exceptional-monotone-schur.py"
CERTIFICATE = HERE / "2026-07-30-c682-all-r-schur.json"
PRIMES = (1000000007, 1000000009)
ENDPOINT_COEFFICIENTS = {
    "4": ((-1, 1, -1, 1), (1, -1, 1, -1), (1, 1, -1, 0)),
    "4s": ((1, -1, -1, 0), (-1, 1, 0, -1), (1, 1, -1, 0)),
    "5": ((-1, 0, 1, -1, 0), (-1, 1, 0, 0, 1), (-1, 1, -1, 0, 0)),
    "6": (
        (0, 1, -1, -1, 0, 1),
        (1, 1, 0, 0, -1, -1),
        (1, -1, -1, 1, 0, 0),
    ),
}
CHAIN_RESIDUES = {"4": 4, "4s": 2, "5": 2, "6": 0}
DENOMINATOR_ROOTS = {
    "4": (Fraction(5, 6),),
    "4s": (Fraction(11, 12), Fraction(7, 12)),
    "5": (Fraction(14, 15),),
    "6": (Fraction(49, 60), Fraction(29, 60)),
}
C5_WEIGHTS = {
    "1": {0},
    "2": {-1, 1},
    "2p": {-2, 2},
    "3": {-2, 0, 2},
    "3p": {-1, 0, 1},
    "4": {-2, -1, 1, 2},
    "4s": {-2, -1, 1, 2},
    "5": {-2, -1, 0, 1, 2},
    "6": {-2, -1, 0, 1, 2},
}


def load(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


SCHUR = load(SCHUR_PATH, "c682_exceptional_schur")
BASE = SCHUR.BASE


def reduce_value(value, prime):
    value = Fraction(value)
    return (
        value.numerator
        * pow(value.denominator % prime, prime - 2, prime)
    ) % prime


def operator_matrix_mod(label, degree, order, operators, prime):
    source = BASE.descriptors(label, degree)
    target = BASE.descriptors(label, degree + 12 - 2 * order)
    lookup = {descriptor: index for index, descriptor in enumerate(target)}
    columns = [[0] * len(target) for _ in source]
    terms_by_source = {}
    for term in operators[label][str(order)]["terms"]:
        terms_by_source.setdefault(term["source"], []).append(term)
    for column, (source_name, f_power, h_power) in enumerate(source):
        for term in terms_by_source.get(source_name, []):
            scalar = (
                reduce_value(term["coefficient"], prime)
                * BASE.falling(f_power, term["dF_order"])
                * BASE.falling(h_power, term["dH_order"])
            ) % prime
            if not scalar:
                continue
            descriptor = (
                term["target"],
                f_power - term["dF_order"] + term["F_multiplier"],
                h_power - term["dH_order"] + term["H_multiplier"],
            )
            if descriptor in lookup:
                row = lookup[descriptor]
                columns[column][row] = (
                    columns[column][row] + scalar
                ) % prime
    return source, target, columns


def matvec_mod(columns, vector, prime):
    return [
        sum(
            vector[column] * columns[column][row]
            for column in range(len(columns))
        )
        % prime
        for row in range(len(columns[0]))
    ]


def determinant_columns_mod(columns, prime):
    size = len(columns)
    rows = [
        [columns[column][row] % prime for column in range(size)]
        for row in range(size)
    ]
    determinant = 1
    for column in range(size):
        pivot = next(
            (row for row in range(column, size) if rows[row][column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            rows[column], rows[pivot] = rows[pivot], rows[column]
            determinant = -determinant
        value = rows[column][column]
        determinant = determinant * value % prime
        inverse = pow(value, prime - 2, prime)
        for row in range(column + 1, size):
            if not rows[row][column]:
                continue
            multiplier = rows[row][column] * inverse % prime
            rows[row] = [
                (left - multiplier * right) % prime
                for left, right in zip(rows[row], rows[column])
            ]
    return determinant % prime


def solve_mod(left, right, prime):
    size = len(left)
    width = len(right[0])
    work = [
        [value % prime for value in left[row] + right[row]]
        for row in range(size)
    ]
    for column in range(size):
        pivot = next(
            row for row in range(column, size) if work[row][column]
        )
        work[column], work[pivot] = work[pivot], work[column]
        inverse = pow(work[column][column], prime - 2, prime)
        work[column] = [
            value * inverse % prime for value in work[column]
        ]
        for row in range(size):
            if row == column or not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                (left_value - multiplier * right_value) % prime
                for left_value, right_value in zip(
                    work[row], work[column]
                )
            ]
    return [row[size : size + width] for row in work]


def fast_schur_columns(
    lower,
    current,
    incoming,
    returned,
    solve,
    zero,
    normalize,
    trace=None,
):
    lower_levels = [row[2] // 3 for row in lower]
    current_levels = [row[2] // 3 for row in current]
    lower_names = list(dict.fromkeys(name for name, *_ in lower))
    level_counts = {
        level: lower_levels.count(level) for level in set(lower_levels)
    }
    block_size = max(level_counts.values())
    full_levels = sorted(
        level
        for level, count in level_counts.items()
        if count == block_size
    )
    assert full_levels == list(range(max(full_levels) + 1))
    last_full_level = max(full_levels)
    pivot_by_level = {
        level: [
            index
            for name in lower_names
            for index, row in enumerate(lower)
            if row[0] == name and lower_levels[index] == level
        ]
        for level in range(1, last_full_level + 1)
    }
    rows_by_level = {
        level: [
            index
            for index, row_level in enumerate(current_levels)
            if row_level == level
        ]
        for level in set(current_levels)
    }
    residual_indices = [
        index
        for index, level in enumerate(lower_levels)
        if level == 0 or level > last_full_level
    ]
    residual = [
        list(incoming[index]) for index in residual_indices
    ] + [list(returned)]
    for level in range(last_full_level):
        rows = rows_by_level[level]
        pivots = pivot_by_level[level + 1]
        assert len(rows) == len(pivots) == block_size
        backward = [
            [incoming[column][row] for column in pivots]
            for row in rows
        ]
        right = [
            [residual[column][row] for column in range(len(residual))]
            for row in rows
        ]
        coefficients = solve(backward, right)
        for residual_column in range(len(residual)):
            for pivot_column, coefficient in zip(
                pivots,
                [
                    coefficients[row][residual_column]
                    for row in range(block_size)
                ],
            ):
                if coefficient == zero:
                    continue
                for row, right_value in enumerate(
                    incoming[pivot_column]
                ):
                    if right_value != zero:
                        residual[residual_column][row] = normalize(
                            residual[residual_column][row]
                            - coefficient * right_value
                        )
        if trace is not None:
            trace(
                level,
                rows_by_level,
                residual,
                block_size,
                last_full_level,
            )
    tail = [
        index
        for index, level in enumerate(current_levels)
        if level >= last_full_level
    ]
    assert len(residual) == len(tail)
    assert all(
        residual[column][row] == zero
        for column in range(len(residual))
        for level in range(last_full_level)
        for row in rows_by_level[level]
    )
    return [[column[row] for row in tail] for column in residual]


def augmented_determinant_mod(label, degree, operators, prime):
    lower, current, incoming = operator_matrix_mod(
        label, degree - 6, 3, operators, prime
    )
    current_2, upper, outgoing = operator_matrix_mod(
        label, degree, 3, operators, prime
    )
    upper_2, current_3, ninth = operator_matrix_mod(
        label, degree + 6, 9, operators, prime
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    endpoint = BASE.endpoint_index(
        lower, BASE.local_levels(lower), (lower[-1][0], 0)
    )
    unit = [0] * len(lower)
    unit[endpoint] = 1
    returned = matvec_mod(
        ninth,
        matvec_mod(outgoing, matvec_mod(incoming, unit, prime), prime),
        prime,
    )
    return determinant_columns_mod(incoming + [returned], prime)


def fast_schur_determinant_mod(label, degree, operators, prime):
    lower, current, incoming = operator_matrix_mod(
        label, degree - 6, 3, operators, prime
    )
    current_2, upper, outgoing = operator_matrix_mod(
        label, degree, 3, operators, prime
    )
    upper_2, current_3, ninth = operator_matrix_mod(
        label, degree + 6, 9, operators, prime
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    lower_levels = [row[2] // 3 for row in lower]
    lower_names = list(dict.fromkeys(row[0] for row in lower))
    name_order = {
        name: index
        for index, name in enumerate(lower_names)
    }
    endpoint = max(
        range(len(lower)),
        key=lambda index: (
            lower_levels[index], name_order[lower[index][0]]
        ),
    )
    unit = [0] * len(lower)
    unit[endpoint] = 1
    returned = matvec_mod(
        ninth,
        matvec_mod(outgoing, matvec_mod(incoming, unit, prime), prime),
        prime,
    )
    columns = fast_schur_columns(
        lower,
        current,
        incoming,
        returned,
        lambda left, right: solve_mod(left, right, prime),
        0,
        lambda value: value % prime,
    )
    return determinant_columns_mod(columns, prime)


def fast_schur_data(
    label,
    degree,
    operators,
    trace=None,
    endpoint_offset=0,
    endpoint_coefficients=None,
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
    lower_levels = [row[2] // 3 for row in lower]
    lower_names = list(dict.fromkeys(row[0] for row in lower))
    name_order = {
        name: index
        for index, name in enumerate(lower_names)
    }
    endpoint_order = sorted(
        range(len(lower)),
        key=lambda index: (
            lower_levels[index], name_order[lower[index][0]]
        ),
        reverse=True,
    )
    if endpoint_coefficients is None:
        endpoint_coefficients = [Fraction(0)] * len(lower_names)
        endpoint_coefficients[endpoint_offset] = Fraction(1)
    assert len(endpoint_coefficients) == len(lower_names)
    endpoint_vector = [
        sum(
            Fraction(coefficient) * incoming[index][row]
            for coefficient, index in zip(
                endpoint_coefficients,
                endpoint_order[: len(lower_names)],
            )
        )
        for row in range(len(current))
    ]
    returned = BASE.matvec(
        ninth, BASE.matvec(outgoing, endpoint_vector)
    )
    columns = fast_schur_columns(
        lower,
        current,
        incoming,
        returned,
        SCHUR.matrix_solve,
        Fraction(0),
        lambda value: value,
        trace,
    )
    return {
        "columns": columns,
        "block_size": max(
            [row[2] // 3 for row in lower].count(level)
            for level in set(row[2] // 3 for row in lower)
        ),
        "determinant": BASE.determinant_columns(columns),
    }


def fast_schur_determinant(label, degree, operators):
    return fast_schur_data(label, degree, operators)["determinant"]


def polynomial_scale(polynomial, scalar):
    return {
        monomial: scalar * coefficient
        for monomial, coefficient in polynomial.items()
        if scalar * coefficient
    }


def polynomial_add(*polynomials):
    out = {}
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            out[monomial] = out.get(monomial, 0) + coefficient
    return {
        monomial: coefficient
        for monomial, coefficient in out.items()
        if coefficient
    }


def polynomial_power(base, exponent, tools):
    out = {(0, 0): 1}
    for _ in range(exponent):
        out = tools.multiply(out, base)
    return out


@cache
def component_generators(label):
    exact, tools, klein, hessian, generators = (
        SCHUR.MONOTONE.module_data(label)
    )
    if label != "6":
        return exact, tools, klein, hessian, {
            name: polynomial
            for name, _, polynomial in generators
        }
    _, _, _, jacobian, _ = exact.build_data()
    seed = {(5, 0): 1}
    # The weight-zero component has multiplicity two on the six-module.
    # The y^3 component lies instead on the simple residue-zero C5 chain.
    alternate = {(2, 3): 1}
    specifications = (
        ("g5", None, 0),
        ("g7", klein, 5),
        ("g9", klein, 4),
        ("g11", klein, 3),
        ("g13", klein, 2),
        ("g15a", klein, 1),
        ("g15b", hessian, 5),
        ("g17", hessian, 4),
        ("g19", hessian, 3),
        ("g21", hessian, 2),
        ("g23", hessian, 1),
        ("g25", jacobian, 5),
    )
    out = {}
    for name, invariant, order in specifications:
        raw = (
            seed
            if invariant is None
            else tools.transvectant(seed, invariant, order)
        )
        alternate_raw = (
            alternate
            if invariant is None
            else tools.transvectant(alternate, invariant, order)
        )
        content = reduce(gcd, (abs(value) for value in raw.values()))
        out[name] = {
            monomial: Fraction(value, content)
            for monomial, value in alternate_raw.items()
        }
    return exact, tools, klein, hessian, out


def signed_endpoint_polynomial(label, residue, r):
    degree = residue + 20 * r
    phase = r % 3
    _, tools, klein, hessian, generators = component_generators(label)
    lower = BASE.descriptors(label, degree - 6)
    levels = [row[2] // 3 for row in lower]
    names = list(dict.fromkeys(row[0] for row in lower))
    name_order = {name: index for index, name in enumerate(names)}
    endpoint_order = sorted(
        range(len(lower)),
        key=lambda index: (
            levels[index], name_order[lower[index][0]]
        ),
        reverse=True,
    )[: len(names)]
    summands = []
    for coefficient, index in zip(
        ENDPOINT_COEFFICIENTS[label][phase], endpoint_order
    ):
        if not coefficient:
            continue
        name, f_power, h_power = lower[index]
        summands.append(
            polynomial_scale(
                tools.multiply(
                    tools.multiply(
                        generators[name],
                        polynomial_power(klein, f_power, tools),
                    ),
                    polynomial_power(hessian, h_power, tools),
                ),
                coefficient,
            )
        )
    return tools, klein, polynomial_add(*summands)


def falling(value, order):
    out = 1
    for offset in range(order):
        out *= value - offset
    return out


def chain_coefficients(degree, index):
    complement = degree - index
    return (
        330 * falling(index, 2) * (degree - 4 * index + 6),
        660
        * (
            2 * falling(complement, 3)
            - 9 * falling(complement, 2) * index
            + 9 * complement * falling(index, 2)
            - 2 * falling(index, 3)
        ),
        -330
        * falling(complement, 2)
        * (3 * degree - 4 * index - 6),
    )


def coefficient_chain_matrix(degree, residue):
    source = list(range(residue, degree + 1, 5))
    target_residue = (residue + 3) % 5
    target = list(range(target_residue, degree + 7, 5))
    lookup = {index: row for row, index in enumerate(target)}
    rows = [[0] * len(source) for _ in target]
    for column, index in enumerate(source):
        for target_index, value in zip(
            (index - 2, index + 3, index + 8),
            chain_coefficients(degree, index),
        ):
            if target_index in lookup:
                rows[lookup[target_index]][column] = value
    return source, target, rows


def transvectant_monomial_coefficient(
    source_degree, source_index, form_index, form_coefficient, order
):
    from math import comb

    out = 0
    for index in range(order + 1):
        out += (
            (-1) ** index
            * comb(order, index)
            * falling(source_degree - source_index, order - index)
            * falling(source_index, index)
            * falling(12 - form_index, index)
            * falling(form_index, order - index)
            * form_coefficient
        )
    return out


def transvectant_chain_matrix(degree, residue, order):
    source = list(range(residue, degree + 1, 5))
    target_degree = degree + 12 - 2 * order
    shift = (1 - order) % 5
    target_residue = (residue + shift) % 5
    target = list(range(target_residue, target_degree + 1, 5))
    lookup = {index: row for row, index in enumerate(target)}
    rows = [[0] * len(source) for _ in target]
    for column, source_index in enumerate(source):
        for form_index, form_coefficient in ((1, 1), (6, 11), (11, -1)):
            target_index = source_index + form_index - order
            if target_index in lookup:
                rows[lookup[target_index]][column] = (
                    transvectant_monomial_coefficient(
                        degree,
                        source_index,
                        form_index,
                        form_coefficient,
                        order,
                    )
                )
    return source, target, rows


def matrix_multiply_rows(left, right):
    return [
        [
            sum(
                left[row][middle] * right[middle][column]
                for middle in range(len(right))
            )
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def boundary_null_values(rows, side, width=6):
    row_count = len(rows)
    column_count = len(rows[0])
    values = {}
    if side == "left":
        support = [
            row for row in range(row_count) if rows[row][0]
        ]
        assert support == [0, 1]
        values[0] = Fraction(rows[1][0])
        values[1] = Fraction(-rows[0][0])
        for column in range(1, column_count):
            support = [
                row for row in range(row_count) if rows[row][column]
            ]
            new_row = max(support)
            if new_row in values:
                continue
            values[new_row] = -sum(
                Fraction(rows[row][column]) * values[row]
                for row in support
                if row in values
            ) / rows[new_row][column]
            if len(values) >= width:
                break
    else:
        support = [
            row for row in range(row_count) if rows[row][-1]
        ]
        assert support == [row_count - 2, row_count - 1]
        values[row_count - 2] = Fraction(rows[-1][-1])
        values[row_count - 1] = Fraction(-rows[-2][-1])
        for column in range(column_count - 2, -1, -1):
            support = [
                row for row in range(row_count) if rows[row][column]
            ]
            new_row = min(support)
            if new_row in values:
                continue
            values[new_row] = -sum(
                Fraction(rows[row][column]) * values[row]
                for row in support
                if row in values
            ) / rows[new_row][column]
            if len(values) >= width:
                break
    return values


def boundary_eigen_obstruction(label, residue, r):
    degree = residue + 20 * r
    source_residue = CHAIN_RESIDUES[label]
    _, current, incoming = transvectant_chain_matrix(
        degree - 6, source_residue, 3
    )
    current_residue = current[0] % 5
    current, upper, outgoing = transvectant_chain_matrix(
        degree, current_residue, 3
    )
    upper_2, current_2, ninth = transvectant_chain_matrix(
        degree + 6, upper[0] % 5, 9
    )
    assert current == current_2
    assert upper == upper_2
    side = "left" if label == "6" else "right"
    null = boundary_null_values(incoming, side)
    indices = sorted(null)
    pair = indices[:2] if side == "left" else indices[-2:]

    def transpose_action(column):
        return sum(
            Fraction(
                sum(
                    ninth[row][middle] * outgoing[middle][column]
                    for middle in range(len(upper))
                    if outgoing[middle][column]
                    and ninth[row][middle]
                )
            )
            * null[row]
            for row in indices
        )

    first, second = pair
    for column in pair:
        transfer_support = {
            row
            for row in range(len(current))
            if any(
                outgoing[middle][column] and ninth[row][middle]
                for middle in range(len(upper))
            )
        }
        assert transfer_support <= set(indices)
    obstruction = (
        transpose_action(first) * null[second]
        - transpose_action(second) * null[first]
    )
    return {
        "degree": degree,
        "side": side,
        "indices": pair,
        "null_values": [null[index] for index in pair],
        "obstruction": obstruction,
    }


def polynomial_value(coefficients, value):
    out = Fraction(0)
    for coefficient in reversed(coefficients):
        out = out * value + coefficient
    return out


def polynomial_multiply(left, right):
    out = [Fraction(0)] * (len(left) + len(right) - 1)
    for left_degree, left_value in enumerate(left):
        for right_degree, right_value in enumerate(right):
            out[left_degree + right_degree] += left_value * right_value
    return out


def shifted_coefficients(coefficients, shift):
    from math import comb

    out = [Fraction(0)] * len(coefficients)
    for degree, coefficient in enumerate(coefficients):
        for new_degree in range(degree + 1):
            out[new_degree] += (
                coefficient
                * comb(degree, new_degree)
                * shift ** (degree - new_degree)
            )
    return out


def rational_function_fit(points, maximum_total_degree=24):
    for total_degree in range(maximum_total_degree + 1):
        for numerator_degree in range(total_degree + 1):
            denominator_degree = total_degree - numerator_degree
            unknown_count = total_degree + 1
            if len(points) < unknown_count + 2:
                continue
            rows = []
            right = []
            for value, image in points[:unknown_count]:
                rows.append(
                    [
                        Fraction(value**degree)
                        for degree in range(numerator_degree + 1)
                    ]
                    + [
                        -image * value**degree
                        for degree in range(denominator_degree)
                    ]
                )
                right.append(image * value**denominator_degree)
            try:
                solution = SCHUR.solve_square(rows, right)
            except StopIteration:
                continue
            numerator = solution[: numerator_degree + 1]
            denominator = (
                solution[numerator_degree + 1 :] + [Fraction(1)]
            )
            if all(
                polynomial_value(numerator, value)
                == image * polynomial_value(denominator, value)
                for value, image in points
            ):
                return numerator, denominator
    raise AssertionError("no bounded rational formula found")


def lcm(left, right):
    return left * right // gcd(left, right)


def primitive_coefficients(coefficients):
    denominator = reduce(
        lcm, (value.denominator for value in coefficients), 1
    )
    integers = [int(value * denominator) for value in coefficients]
    content = reduce(gcd, (abs(value) for value in integers if value))
    return [value // content for value in integers], Fraction(
        content, denominator
    )


def multiplicity(label, degree):
    total = 0
    for _, generator_degree in BASE.GENERATORS[label]:
        remainder = degree - generator_degree
        if remainder < 0:
            continue
        for h_power in range(remainder // 20 + 1):
            if (remainder - 20 * h_power) % 12 == 0:
                total += 1
    return total


def centered_weight(residue):
    return residue if residue <= 2 else residue - 5


def entrance_weight_audit(label, residue):
    current_chain_residue = (CHAIN_RESIDUES[label] + 3) % 5
    weight = centered_weight(
        (residue - 2 * current_chain_residue) % 5
    )
    phases = {}
    for r in range(6, 9):
        degree = residue + 20 * r
        deltas = {
            module: multiplicity(module, degree)
            - multiplicity(module, degree - 6)
            for module in sorted(BASE.GENERATORS)
        }
        positive_at_weight = [
            module
            for module, delta in deltas.items()
            if delta > 0 and weight in C5_WEIGHTS[module]
        ]
        assert positive_at_weight == [label]
        phases[str(r % 3)] = {
            "r": r,
            "nonzero_multiplicity_deltas": {
                module: delta
                for module, delta in deltas.items()
                if delta
            },
            "positive_delta_modules_at_selected_weight": positive_at_weight,
        }
    return {
        "source_chain_residue": CHAIN_RESIDUES[label],
        "current_chain_residue": current_chain_residue,
        "C5_weight": weight,
        "three_phase_audit": phases,
        "periodicity_reason": (
            "after r>=6, translation r->r+3 adds degree 60; every "
            "compatible 12a+20b generator ray gains one term on both "
            "sides, so the displayed multiplicity deltas repeat"
        ),
        "conclusion": (
            f"the selected coefficient chain has a unique new "
            f"{label}-weight line"
        ),
    }


def denominator_from_roots(roots):
    out = [Fraction(1)]
    for root in roots:
        out = polynomial_multiply(out, [-root, Fraction(1)])
    return out


def add_degree_bounds(left, right):
    left_numerator, left_denominator = left
    right_numerator, right_denominator = right
    return (
        max(
            left_numerator + right_denominator,
            right_numerator + left_denominator,
        ),
        left_denominator + right_denominator,
    )


def multiply_degree_bounds(left, right):
    return left[0] + right[0], left[1] + right[1]


def formal_obstruction_degree_bounds():
    edge = (3, 0)
    boundary = (3, 0)
    second = add_degree_bounds(
        multiply_degree_bounds(edge, boundary),
        multiply_degree_bounds(edge, boundary),
    )
    second = (second[0], second[1] + 3)
    third = add_degree_bounds(
        multiply_degree_bounds(edge, boundary),
        multiply_degree_bounds(edge, second),
    )
    third = (third[0], third[1] + 3)
    transfer = (12, 0)
    action = multiply_degree_bounds(transfer, boundary)
    action = add_degree_bounds(
        action, multiply_degree_bounds(transfer, boundary)
    )
    action = add_degree_bounds(
        action, multiply_degree_bounds(transfer, second)
    )
    action = add_degree_bounds(
        action, multiply_degree_bounds(transfer, third)
    )
    product = multiply_degree_bounds(action, boundary)
    return add_degree_bounds(product, product)


def obstruction_certificate(label, residue):
    # Each transvectant edge has degree at most 3 or 9.  The two tested
    # boundary columns of T have support on at most four null coordinates,
    # reached after at most two scalar recurrence divisions.  Straight
    # rational degree bookkeeping gives true bounds 36/18.  Against the
    # fitted degree <=18/2 formula, the cleared difference has degree at
    # most 38, so the 105 exact points below more than prove identity.
    points = [
        (
            r,
            boundary_eigen_obstruction(label, residue, r)["obstruction"],
        )
        for r in range(6, 111)
    ]
    numerator, denominator = rational_function_fit(points)
    expected_denominator = denominator_from_roots(
        DENOMINATOR_ROOTS[label]
    )
    assert denominator == expected_denominator
    shifted = shifted_coefficients(numerator, 6)
    primitive, scale = primitive_coefficients(shifted)
    assert scale > 0
    assert all(value < 0 for value in primitive)
    assert all(
        polynomial_value(numerator, r)
        == value * polynomial_value(denominator, r)
        for r, value in points
    )
    true_numerator_bound, true_denominator_bound = (
        formal_obstruction_degree_bounds()
    )
    cleared_difference_bound = max(
        len(numerator) - 1 + true_denominator_bound,
        len(denominator) - 1 + true_numerator_bound,
    )
    assert (
        true_numerator_bound,
        true_denominator_bound,
    ) == (36, 18)
    assert cleared_difference_bound <= 38
    assert len(points) > cleared_difference_bound
    return {
        "boundary_side": "left" if label == "6" else "right",
        "fitted_degrees": {
            "numerator": len(numerator) - 1,
            "denominator": len(denominator) - 1,
        },
        "formal_true_degree_bounds": {
            "numerator": true_numerator_bound,
            "denominator": true_denominator_bound,
            "cleared_difference_against_formula": (
                cleared_difference_bound
            ),
        },
        "identity_grid": [6, 110],
        "identity_grid_count": len(points),
        "denominator_roots": [
            str(root) for root in DENOMINATOR_ROOTS[label]
        ],
        "shifted_numerator_primitive_coefficients": primitive,
        "shifted_numerator_positive_scale": str(scale),
        "sign_conclusion": "strictly negative for every real r>=6",
    }


def generate_certificate():
    types = {}
    for label, residue in SCHUR.TYPES:
        types[f"{label}_{residue}"] = {
            "module": label,
            "entrance_degrees": f"n={residue}+20r, r>=6",
            "selected_chain": entrance_weight_audit(label, residue),
            "boundary_eigen_obstruction": obstruction_certificate(
                label, residue
            ),
        }
    return {
        "schema": "c682-all-r-signed-schur-v1",
        "types": types,
        "theorem": (
            "At every exceptional entrance 4_6, 4s_3, 5_4, and 6_5 "
            "with r>=6, T=D_n^dagger D_n does not preserve the incoming "
            "hyperplane im(D_{n-6}). Hence an endpoint x has a nonzero "
            "signed Schur contraction, and all twelve modulo-60 "
            "entrances are transverse."
        ),
        "canonical_positive_endpoint": (
            "For a Fischer-unit cokernel vector y, take "
            "x=D_{n-6}^dagger T y. The certified obstruction makes x "
            "nonzero, and <y,T D_{n-6}x>=<x,x>>0."
        ),
        "trusted_boundary": (
            "The primary proof uses the closed monomial transvectant "
            "formula, the already proved all-weight maximal-rank theorem, "
            "and the exact Kostant generator degrees. The 105-point "
            "identity grids are proofs within the recorded formal rational "
            "degree bounds, not finite nonvanishing samples."
        ),
    }


def chain_return_data(label, residue, r):
    degree = residue + 20 * r
    tools, klein, endpoint = signed_endpoint_polynomial(label, residue, r)
    returned = tools.transvectant(endpoint, klein, 3)
    returned = tools.transvectant(returned, klein, 3)
    returned = tools.transvectant(returned, klein, 9)
    endpoint_residue = next(iter(endpoint))[1] % 5
    source, target, rows = coefficient_chain_matrix(
        degree - 6, endpoint_residue
    )
    assert len(target) == len(source) + 1
    returned_column = [
        returned.get((degree - index, index), 0) for index in target
    ]
    return {
        "degree": degree,
        "source": source,
        "target": target,
        "rows": rows,
        "returned": returned_column,
    }


def left_null_vector(rows):
    source_size = len(rows[0])
    assert len(rows) == source_size + 1
    square_transpose = [
        [rows[row][column] for row in range(source_size)]
        for column in range(source_size)
    ]
    right = [-rows[-1][column] for column in range(source_size)]
    return SCHUR.solve_square(square_transpose, right) + [Fraction(1)]


def chain_contraction(label, residue, r):
    data = chain_return_data(label, residue, r)
    null = left_null_vector(data["rows"])
    terms = [
        left * right for left, right in zip(null, data["returned"])
    ]
    return {
        **data,
        "null": null,
        "terms": terms,
        "contraction": sum(terms),
    }


def polynomial_recurrence(values, prime, maximum_order, maximum_degree):
    return SCHUR.modular_polynomial_recurrence(
        values,
        prime=prime,
        maximum_order=maximum_order,
        maximum_degree=maximum_degree,
    )


def probe(count, maximum_order, maximum_degree):
    operators = json.loads(SCHUR.OPERATORS.read_text(encoding="utf-8"))
    for label, residue in SCHUR.TYPES:
        print(f"{label}_{residue}")
        for phase in range(3):
            first = 6 + (phase - 6) % 3
            values = [
                fast_schur_determinant_mod(
                    label,
                    residue + 20 * (first + 3 * index),
                    operators,
                    PRIMES[0],
                )
                for index in range(count)
            ]
            recurrence = polynomial_recurrence(
                values, PRIMES[0], maximum_order, maximum_degree
            )
            shape = (
                None
                if recurrence is None
                else (recurrence["order"], recurrence["degree"])
            )
            print(f"  phase={phase} recurrence={shape}")


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--probe", action="store_true")
    parser.add_argument("--count", type=int, default=100)
    parser.add_argument("--maximum-order", type=int, default=8)
    parser.add_argument("--maximum-degree", type=int, default=8)
    arguments = parser.parse_args()
    if arguments.probe:
        probe(
            arguments.count,
            arguments.maximum_order,
            arguments.maximum_degree,
        )
        return
    rendered = json.dumps(
        generate_certificate(), indent=2, sort_keys=True
    ) + "\n"
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")
        return
    assert CERTIFICATE.read_text(encoding="utf-8") == rendered
    print("PASS: all-r exceptional signed Schur transversality")


if __name__ == "__main__":
    main()
