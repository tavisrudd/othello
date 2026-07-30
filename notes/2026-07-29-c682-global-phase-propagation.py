#!/usr/bin/env python3
"""Evaluate the sixteen C682 global-Weyl phase quotients."""

from __future__ import annotations

import argparse
import importlib.util
import json
import multiprocessing
from fractions import Fraction
from functools import cache
from math import comb, lcm
from pathlib import Path


HERE = Path(__file__).resolve().parent
GLOBAL_PATH = HERE / "2026-07-29-c682-global-weyl-operators.py"
GLOBAL_CERTIFICATE = HERE / "2026-07-29-c682-global-weyl-operators.json"
TRIVIAL_OPERATORS = HERE / "2026-07-29-c682-global-phase-trivial-operators.json"
BOUNDARY = HERE / "2026-07-29-c682-global-phase-boundary.json"
CERTIFICATE = HERE / "2026-07-29-c682-global-phase-propagation.json"
PHASES = {
    "1": [24, 44],
    "2": [23, 33, 43, 53],
    "3": [32, 34, 52, 54],
    "3p": [30, 34, 38, 50, 54, 58],
}
GENERATORS = {
    "1": [("g0", 0), ("g30", 30)],
    "2": [("g1", 1), ("g11", 11), ("g19", 19), ("g29", 29)],
    "3": [
        ("g2", 2),
        ("g10", 10),
        ("g12", 12),
        ("g18", 18),
        ("g20", 20),
        ("g28", 28),
    ],
    "3p": [
        ("g6", 6),
        ("g10", 10),
        ("g14", 14),
        ("g16", 16),
        ("g20", 20),
        ("g24", 24),
    ],
}
PEAKS = {
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


GLOBAL = load(GLOBAL_PATH, "global_phase_weyl")
ORIGINAL_MODULE_DATA = GLOBAL.MODULE_DATA.module_data


@cache
def module_data(label):
    if label != "1":
        return ORIGINAL_MODULE_DATA(label)
    exact = load(
        HERE / "2026-07-28-c682-klein-e8-free-covariant.py",
        "global_phase_trivial",
    )
    tools, klein, hessian, jacobian, _ = exact.build_data()
    return (
        exact,
        tools,
        klein,
        hessian,
        [
            ("g0", 0, {(0, 0): 1}),
            ("g30", 30, jacobian),
        ],
    )


GLOBAL.MODULE_DATA.module_data = module_data


def falling(value, order):
    out = 1
    for offset in range(order):
        out *= value - offset
    return out


def descriptors(label, degree):
    out = []
    for name, generator_degree in GENERATORS[label]:
        remainder = degree - generator_degree
        if remainder < 0:
            continue
        for h_power in range(remainder // 20 + 1):
            residual = remainder - 20 * h_power
            if residual % 12 == 0:
                out.append((name, residual // 12, h_power))
    return out


def operator_matrix(label, degree, order, operators):
    source = descriptors(label, degree)
    target = descriptors(label, degree + 12 - 2 * order)
    lookup = {descriptor: index for index, descriptor in enumerate(target)}
    columns = [[Fraction(0)] * len(target) for _ in source]
    terms_by_source = {}
    for term in operators[label][str(order)]["terms"]:
        terms_by_source.setdefault(term["source"], []).append(term)
    for column, (source_name, f_power, h_power) in enumerate(source):
        for term in terms_by_source.get(source_name, []):
            scalar = (
                Fraction(term["coefficient"])
                * falling(f_power, term["dF_order"])
                * falling(h_power, term["dH_order"])
            )
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
                columns[column][lookup[target_descriptor]] += scalar
    return source, target, columns


def matvec(columns, vector):
    if not columns:
        return []
    return [
        sum(
            vector[column] * columns[column][row]
            for column in range(len(columns))
        )
        for row in range(len(columns[0]))
    ]


def rank_columns(columns):
    if not columns:
        return 0
    rows = [
        [Fraction(columns[column][row]) for column in range(len(columns))]
        for row in range(len(columns[0]))
    ]
    rank = 0
    for column in range(len(columns)):
        pivot = next(
            (
                row
                for row in range(rank, len(rows))
                if rows[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        value = rows[rank][column]
        rows[rank] = [entry / value for entry in rows[rank]]
        for row in range(rank + 1, len(rows)):
            if rows[row][column]:
                value = rows[row][column]
                rows[row] = [
                    left - value * right
                    for left, right in zip(rows[row], rows[rank])
                ]
        rank += 1
    return rank


def determinant_columns(columns):
    size = len(columns)
    if any(len(column) != size for column in columns):
        return Fraction(0)
    rows = [
        [Fraction(columns[column][row]) for column in range(size)]
        for row in range(size)
    ]
    out = Fraction(1)
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
            return Fraction(0)
        if pivot != column:
            rows[column], rows[pivot] = rows[pivot], rows[column]
            out = -out
        value = rows[column][column]
        out *= value
        rows[column] = [entry / value for entry in rows[column]]
        for row in range(column + 1, size):
            if rows[row][column]:
                value = rows[row][column]
                rows[row] = [
                    left - value * right
                    for left, right in zip(rows[row], rows[column])
                ]
    return out


def determinant_columns_integer(columns):
    size = len(columns)
    if any(len(column) != size for column in columns):
        return 0
    rows = [
        [int(columns[column][row]) for column in range(size)]
        for row in range(size)
    ]
    sign = 1
    denominator = 1
    for column in range(size - 1):
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
            sign = -sign
        pivot_value = rows[column][column]
        for row in range(column + 1, size):
            for target_column in range(column + 1, size):
                numerator = (
                    rows[row][target_column] * pivot_value
                    - rows[row][column] * rows[column][target_column]
                )
                assert numerator % denominator == 0
                rows[row][target_column] = numerator // denominator
            rows[row][column] = 0
        denominator = pivot_value
    return sign * rows[-1][-1]


def operator_denominator(label, order, operators):
    return lcm(
        *(
            Fraction(term["coefficient"]).denominator
            for term in operators[label][str(order)]["terms"]
        )
    )


def scale_columns(columns, scale):
    return [
        [int(value * scale) for value in column]
        for column in columns
    ]


def local_levels(rows):
    counts = {}
    levels = []
    for name, *_ in rows:
        levels.append(counts.get(name, 0))
        counts[name] = counts.get(name, 0) + 1
    return levels


def endpoint_key(rows, levels, index):
    maxima = {}
    for (name, *_), level in zip(rows, levels):
        maxima[name] = max(maxima.get(name, -1), level)
    name = rows[index][0]
    return name, maxima[name] - levels[index]


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


def relative_key(rows, index):
    levels = local_levels(rows)
    return endpoint_key(rows, levels, index)


def relative_index(rows, key):
    levels = local_levels(rows)
    return endpoint_index(rows, levels, key)


def compose(left, right):
    return [matvec(left, column) for column in right]


def boundary_data(label, phase, q, operators, endpoint_keys=None):
    degree = 60 + phase + 60 * q
    lower, current, incoming = operator_matrix(
        label, degree - 6, 3, operators
    )
    current_2, upper, outgoing = operator_matrix(
        label, degree, 3, operators
    )
    upper_2, current_3, ninth = operator_matrix(
        label, degree + 6, 9, operators
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    third_denominator = operator_denominator(
        label, 3, operators
    )
    ninth_denominator = operator_denominator(
        label, 9, operators
    )
    incoming = scale_columns(incoming, third_denominator)
    outgoing = scale_columns(outgoing, third_denominator)
    ninth = scale_columns(ninth, ninth_denominator)
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
    incoming_rank = rank_columns(local_incoming)
    assert incoming_rank == len(local_incoming)
    quotient_dimension = len(tail) - incoming_rank

    def returned(index):
        vector = matvec(ninth, matvec(outgoing, incoming[index]))
        assert all(
            not value or position in tail_set
            for position, value in enumerate(vector)
        )
        return [vector[position] for position in tail]

    if endpoint_keys is None:
        selected = []
        columns = list(local_incoming)
        rank = incoming_rank
        for index in reversed(range(len(lower))):
            try:
                column = returned(index)
            except AssertionError:
                continue
            new_rank = rank_columns(columns + [column])
            if new_rank > rank:
                selected.append(index)
                columns.append(column)
                rank = new_rank
            if rank == len(tail):
                break
        assert len(selected) == quotient_dimension
        endpoint_keys = [
            endpoint_key(lower, lower_levels, index) for index in selected
        ]
    else:
        selected = [
            endpoint_index(lower, lower_levels, tuple(key))
            for key in endpoint_keys
        ]
        columns = local_incoming + [returned(index) for index in selected]
    determinant = determinant_columns_integer(columns)
    assert determinant
    return {
        "degree": degree,
        "tail_dimension": len(tail),
        "quotient_dimension": quotient_dimension,
        "endpoint_keys": endpoint_keys,
        "incoming_denominator_scale": third_denominator,
        "return_denominator_scale": (
            third_denominator**2 * ninth_denominator
        ),
        "determinant": determinant,
    }


def newton_coefficients(values):
    differences = values
    out = []
    while differences:
        out.append(differences[0])
        differences = [
            right - left
            for left, right in zip(differences, differences[1:])
        ]
    while out and not out[-1]:
        out.pop()
    return out


def newton_to_monomial(coefficients):
    result = [Fraction(0)]
    basis = [Fraction(1)]
    factorial = 1
    for index, value in enumerate(coefficients):
        if index:
            basis = multiply_polynomials(
                basis, [Fraction(-(index - 1)), Fraction(1)]
            )
            factorial *= index
        if len(result) < len(basis):
            result.extend([Fraction(0)] * (len(basis) - len(result)))
        for degree, coefficient in enumerate(basis):
            result[degree] += value * coefficient / factorial
    while len(result) > 1 and not result[-1]:
        result.pop()
    return result


def multiply_polynomials(left, right):
    out = [Fraction(0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            out[i + j] += a * b
    return out


def polynomial_value(coefficients, value):
    out = Fraction(0)
    for coefficient in reversed(coefficients):
        out = out * value + coefficient
    return out


def divide_linear(coefficients, root):
    quotient = [Fraction(0)] * (len(coefficients) - 1)
    carry = coefficients[-1]
    quotient[-1] = carry
    for degree in range(len(coefficients) - 2, 0, -1):
        carry = coefficients[degree] + root * carry
        quotient[degree - 1] = carry
    assert coefficients[0] + root * carry == 0
    return quotient


def shifted_coefficients(coefficients, shift):
    out = [Fraction(0)] * len(coefficients)
    for degree, value in enumerate(coefficients):
        for new_degree in range(degree + 1):
            out[new_degree] += (
                value
                * comb(degree, new_degree)
                * shift ** (degree - new_degree)
            )
    return out


def uniform_sign(coefficients):
    signs = {(value > 0) - (value < 0) for value in coefficients if value}
    return signs.pop() if len(signs) == 1 else 0


def generate_trivial_operators():
    return {
        "1": {
            str(order): GLOBAL.fit_operator("1", order)
            for order in GLOBAL.ORDERS
        }
    }


def operators():
    data = json.loads(GLOBAL_CERTIFICATE.read_text(encoding="utf-8"))[
        "operators"
    ]
    data.update(json.loads(TRIVIAL_OPERATORS.read_text(encoding="utf-8")))
    return data


def generate_boundary_family(arguments):
    label, phase, operator_data = arguments
    family = f"{label}_{phase}"
    first = boundary_data(label, phase, 10, operator_data)
    degree_bound = (
        3
        * (first["tail_dimension"] - first["quotient_dimension"])
        + 15 * first["quotient_dimension"]
    )
    endpoint_keys = first["endpoint_keys"]
    values = [
        boundary_data(
            label, phase, q, operator_data, endpoint_keys
        )["determinant"]
        for q in range(10, 10 + degree_bound + 1)
    ]
    coefficients = newton_coefficients(values)
    return family, {
        "module": label,
        "phase": phase,
        "base_degree": 60 + phase,
        "base_q": 10,
        "tail_dimension": first["tail_dimension"],
        "quotient_dimension": first["quotient_dimension"],
        "endpoint_keys": endpoint_keys,
        "incoming_denominator_scale": first[
            "incoming_denominator_scale"
        ],
        "return_denominator_scale": first[
            "return_denominator_scale"
        ],
        "degree_bound": degree_bound,
        "degree": len(coefficients) - 1,
        "newton_coefficients": [str(value) for value in coefficients],
    }


def generate_boundary(operator_data):
    arguments = [
        (label, phase, operator_data)
        for label, phases in PHASES.items()
        for phase in phases
    ]
    with multiprocessing.Pool(processes=4) as pool:
        rows = pool.map(generate_boundary_family, arguments)
    return dict(sorted(rows))


def coefficient_count(k):
    if k < 0:
        return 0
    return sum(
        1
        for h_power in range(k // 20 + 1)
        if (k - 20 * h_power) % 12 == 0
    )


def multiplicity(label, degree):
    return sum(
        coefficient_count(degree - generator_degree)
        for _, generator_degree in GENERATORS[label]
    )


def peak_composition_entry(
    label, residue, q, operator_data, source_key, target_key
):
    degree = 60 + residue + 60 * q
    source, current, incoming = operator_matrix(
        label, degree - 6, 3, operator_data
    )
    current_2, target, outgoing = operator_matrix(
        label, degree, 3, operator_data
    )
    assert current == current_2
    composition = compose(outgoing, incoming)
    source_index = relative_index(source, source_key)
    target_index = relative_index(target, target_key)
    return composition[source_index][target_index]


def peak_witness(label, residue, operator_data):
    degree = 60 + residue + 60
    source, current, incoming = operator_matrix(
        label, degree - 6, 3, operator_data
    )
    current_2, target, outgoing = operator_matrix(
        label, degree, 3, operator_data
    )
    assert current == current_2
    composition = compose(outgoing, incoming)
    candidates = [
        (relative_key(source, column), relative_key(target, row))
        for column, values in enumerate(composition)
        for row, value in enumerate(values)
        if value
    ]
    for source_key, target_key in candidates:
        values = [
            peak_composition_entry(
                label,
                residue,
                q,
                operator_data,
                source_key,
                target_key,
            )
            for q in range(1, 9)
        ]
        coefficients = newton_to_monomial(
            newton_coefficients(values[:7])
        )
        if polynomial_value(coefficients, 7) != values[7]:
            continue
        shift = next(
            (
                candidate
                for candidate in range(101)
                if uniform_sign(
                    shifted_coefficients(coefficients, candidate)
                )
            ),
            None,
        )
        if shift is None:
            continue
        finite = [
            peak_composition_entry(
                label,
                residue,
                q,
                operator_data,
                source_key,
                target_key,
            )
            for q in range(1, 1 + shift)
        ]
        if all(finite):
            return {
                "source_key": source_key,
                "target_key": target_key,
                "degree_bound": 6,
                "exact_degree": len(coefficients) - 1,
                "positivity_threshold_q": 1 + shift,
                "shifted_coefficient_sign": uniform_sign(
                    shifted_coefficients(coefficients, shift)
                ),
                "finite_prefix_signs": [
                    (value > 0) - (value < 0) for value in finite
                ],
                "newton_coefficients_at_q1": [
                    str(value)
                    for value in newton_coefficients(values[:7])
                ],
            }
    raise AssertionError((label, residue, "no peak composition witness"))


def peak_audit(operator_data):
    rows = {}
    for label, residues in PEAKS.items():
        label_rows = []
        for residue in residues:
            degree = 120 + residue
            profile = [
                multiplicity(label, degree + shift)
                for shift in (-6, 0, 6)
            ]
            assert profile[1] > max(profile[0], profile[2])
            assert profile[0] + profile[2] > profile[1]
            label_rows.append(
                {
                    "residue_mod_60": residue,
                    "base_profile": profile,
                    "nonorthogonality": (
                        "certified by a nonzero two-step composition"
                    ),
                    "composition_witness": peak_witness(
                        label, residue, operator_data
                    ),
                }
            )
        rows[label] = label_rows
    return {
        "period": 60,
        "families": rows,
        "family_count": sum(map(len, PEAKS.values())),
        "argument": (
            "The sixteen phase quotients anchor every previously "
            "unanchored equal-rank plateau component. At each eventual "
            "strict peak both neighboring corners have smaller "
            "multiplicity; the lower-hyperplane propagation lemma applies, "
            "the all-weight two-sided-defect theorem makes the supported "
            "lower and upper images span, and the displayed global-Weyl "
            "two-step witness makes them nonorthogonal."
        ),
        "claim_boundary": (
            "This closes eventual strict peaks in the full graded path "
            "corner. It does not prove the remaining off-peak propagation "
            "step or identify the full path corner with the algebra of the "
            "three local returns."
        ),
    }


def generate_certificate(operator_data, boundary_rows):
    results = {}
    for family, row in boundary_rows.items():
        polynomial = newton_to_monomial(
            [Fraction(value) for value in row["newton_coefficients"]]
        )
        roots = []
        residual = polynomial
        for root in range(-1000, 0):
            while (
                len(residual) > 1
                and not polynomial_value(residual, root)
            ):
                roots.append(root)
                residual = divide_linear(residual, Fraction(root))
        shift = next(
            candidate
            for candidate in range(1001)
            if uniform_sign(shifted_coefficients(residual, candidate))
        )
        threshold = row["base_q"] + shift
        finite = [
            boundary_data(
                row["module"],
                row["phase"],
                q,
                operator_data,
                row["endpoint_keys"],
            )["determinant"]
            for q in range(row["base_q"], threshold)
        ]
        low = [
            boundary_data(
                row["module"], row["phase"], q, operator_data
            )
            for q in range(1, row["base_q"])
        ]
        assert all(finite)
        results[family] = {
            "module": row["module"],
            "family": f"n={row['base_degree']}+60q",
            "phase_mod_60": row["phase"],
            "tail_dimension": row["tail_dimension"],
            "quotient_dimension": row["quotient_dimension"],
            "endpoint_keys": row["endpoint_keys"],
            "degree_bound": row["degree_bound"],
            "exact_degree": row["degree"],
            "linear_roots_in_x_equals_q_minus_10": roots,
            "residual_degree": len(residual) - 1,
            "positivity_threshold_q": threshold,
            "shifted_residual_sign": uniform_sign(
                shifted_coefficients(residual, shift)
            ),
            "finite_boundary_signs": [
                (value > 0) - (value < 0) for value in finite
            ],
            "low_q_quotient_dimensions": [
                entry["quotient_dimension"] for entry in low
            ],
            "low_q_determinant_signs": [
                (entry["determinant"] > 0)
                - (entry["determinant"] < 0)
                for entry in low
            ],
            "conclusion": (
                "the complete local boundary quotient is spanned for every "
                "integer q>=1"
            ),
        }
    return {
        "schema": "c682-global-phase-propagation-v1",
        "phase_count": len(results),
        "phases": results,
        "peak_propagation": peak_audit(operator_data),
        "claim": (
            "All sixteen previously open modulo-60 plateau phases are "
            "boundary-surjective for every integer q>=1, and these anchors "
            "propagate through all twenty-one eventual strict peak families "
            "in the full graded path corner."
        ),
        "trusted_boundary": (
            "Boundary determinants are evaluated from the exact global "
            "falling-factorial Weyl operators. Polynomial identity uses the "
            "formal differential-order degree bound, exact Newton data, "
            "coefficientwise one-sign residuals, and exact finite prefixes. "
            "Peak propagation uses the previously proved lower-hyperplane "
            "and supported-two-subspace lemmas."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write-trivial-operators", action="store_true")
    mode.add_argument("--write-boundary", action="store_true")
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    if arguments.write_trivial_operators:
        rendered = json.dumps(
            generate_trivial_operators(), indent=2, sort_keys=True
        ) + "\n"
        TRIVIAL_OPERATORS.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {TRIVIAL_OPERATORS}")
        return
    operator_data = operators()
    if arguments.write_boundary:
        rendered = json.dumps(
            generate_boundary(operator_data), indent=2, sort_keys=True
        ) + "\n"
        BOUNDARY.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {BOUNDARY}")
        return
    if arguments.check:
        expected_trivial = json.dumps(
            generate_trivial_operators(), indent=2, sort_keys=True
        ) + "\n"
        assert (
            TRIVIAL_OPERATORS.read_text(encoding="utf-8")
            == expected_trivial
        )
        expected_boundary = json.dumps(
            generate_boundary(operator_data), indent=2, sort_keys=True
        ) + "\n"
        assert BOUNDARY.read_text(encoding="utf-8") == expected_boundary
    boundary_rows = json.loads(BOUNDARY.read_text(encoding="utf-8"))
    rendered = json.dumps(
        generate_certificate(operator_data, boundary_rows),
        indent=2,
        sort_keys=True,
    ) + "\n"
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")
    else:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 global phase propagation")


if __name__ == "__main__":
    main()
