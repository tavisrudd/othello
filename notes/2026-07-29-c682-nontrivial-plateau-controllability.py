#!/usr/bin/env python3
"""Exact boundary witnesses for the C682 2, 3, and 3' plateaus."""

import argparse
import importlib.util
import json
from fractions import Fraction
from functools import reduce
from functools import cache
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
EXACT_PATH = HERE / "2026-07-28-c682-klein-e8-free-covariant.py"
TRIVIAL_PATH = HERE / "2026-07-29-c682-plateau-controllability.py"
CERTIFICATE = HERE / "2026-07-29-c682-nontrivial-plateau-controllability.json"


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def primitive(polynomial):
    content = reduce(gcd, (abs(value) for value in polynomial.values()))
    return {
        monomial: coefficient // content
        for monomial, coefficient in polynomial.items()
    }


@cache
def module_data(label):
    exact = load(EXACT_PATH, "nontrivial_plateau_exact")
    tools, klein, hessian, jacobian, three_generators = exact.build_data()
    if label == "2":
        seed = {(1, 0): 1}
        generators = [
            ("g1", 1, seed),
            ("g11", 11, primitive(tools.transvectant(seed, klein, 1))),
            ("g19", 19, primitive(tools.transvectant(seed, hessian, 1))),
            ("g29", 29, primitive(tools.transvectant(seed, jacobian, 1))),
        ]
    elif label == "3":
        generators = three_generators
    elif label == "3p":
        seed = {(3, 3): 1}
        generators = [
            ("g6", 6, seed),
            ("g10", 10, primitive(tools.transvectant(seed, klein, 4))),
            ("g14", 14, primitive(tools.transvectant(seed, klein, 2))),
            ("g16", 16, primitive(tools.transvectant(seed, hessian, 5))),
            ("g20", 20, primitive(tools.transvectant(seed, hessian, 3))),
            ("g24", 24, primitive(tools.transvectant(seed, jacobian, 6))),
        ]
    else:
        raise ValueError(f"unknown module: {label}")
    return exact, tools, klein, hessian, generators


def candidates(degree, data):
    exact, tools, klein, hessian, generators = data
    out = []
    for name, generator_degree, generator in generators:
        remainder = degree - generator_degree
        if remainder < 0:
            continue
        for h_power in range(remainder // 20 + 1):
            residual = remainder - 20 * h_power
            if residual % 12:
                continue
            f_power = residual // 12
            coefficient = tools.multiply(
                exact.polynomial_power(klein, f_power, tools),
                exact.polynomial_power(hessian, h_power, tools),
            )
            out.append(
                (
                    name,
                    f_power,
                    h_power,
                    tools.multiply(coefficient, generator),
                )
            )
    return out


FAMILIES = {
    "2": 63,
    "3": 72,
    "3p": 70,
}


def exact_witness(label, q):
    trivial = linear_algebra()
    system = incoming_system(label, q)
    data = module_data(label)
    exact, tools, klein, _, _ = data
    degree = system["degree"]
    current = system["current"]
    lower = system["lower"]
    current_columns = system["current_columns"]
    incoming_polynomials = system["incoming_polynomials"]
    incoming_coordinates = system["incoming_coordinates"]
    null = trivial.normalized_left_null(incoming_coordinates)
    returned_coordinates = []
    for polynomial in incoming_polynomials:
        returned = tools.transvectant(
            tools.transvectant(polynomial, klein, 3),
            klein,
            9,
        )
        returned_coordinates.append(
            exact.solve_columns(
                current_columns,
                exact.coefficient_vector(returned, degree),
            )
        )
    mixing = [
        sum(left * right for left, right in zip(null, returned))
        for returned in returned_coordinates
    ]
    return {
        "module": label,
        "q": q,
        "degree": degree,
        "current_basis": [
            [name, f_power, h_power]
            for name, f_power, h_power, _ in current
        ],
        "lower_basis": [
            [name, f_power, h_power]
            for name, f_power, h_power, _ in lower
        ],
        "incoming_coordinates": incoming_coordinates,
        "returned_coordinates": returned_coordinates,
        "null": null,
        "mixing": mixing,
    }


@cache
def incoming_system(label, q):
    data = module_data(label)
    exact, tools, klein, _, _ = data
    degree = FAMILIES[label] + 60 * q
    current = candidates(degree, data)
    lower = candidates(degree - 6, data)
    assert len(current) == len(lower) + 1
    current_columns = [
        exact.coefficient_vector(polynomial, degree)
        for _, _, _, polynomial in current
    ]
    incoming_polynomials = [
        tools.transvectant(polynomial, klein, 3)
        for _, _, _, polynomial in lower
    ]
    incoming_coordinates = [
        exact.solve_columns(
            current_columns,
            exact.coefficient_vector(polynomial, degree),
        )
        for polynomial in incoming_polynomials
    ]
    return {
        "degree": degree,
        "current": current,
        "lower": lower,
        "current_columns": current_columns,
        "incoming_polynomials": incoming_polynomials,
        "incoming_coordinates": incoming_coordinates,
    }


@cache
def linear_algebra():
    return load(TRIVIAL_PATH, "nontrivial_plateau_linear_algebra")


MONOMIALS_3 = [
    (q_degree, j_degree)
    for total in range(4)
    for q_degree in range(total + 1)
    for j_degree in [total - q_degree]
]


def solve_overdetermined(rows, unknowns):
    work = [
        [Fraction(value) for value in row]
        for row in rows
    ]
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
        work[pivot_row] = [
            entry / value for entry in work[pivot_row]
        ]
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


def local_levels(basis):
    counts = {}
    out = []
    for name, _, _, _ in basis:
        out.append(counts.get(name, 0))
        counts[name] = counts.get(name, 0) + 1
    return out


def universal_incoming(label):
    systems = {
        q: incoming_system(label, q)
        for q in range(1, 7)
    }
    samples = {}
    all_patterns = set()
    for q, system in systems.items():
        current = system["current"]
        lower = system["lower"]
        current_levels = local_levels(current)
        lower_levels = local_levels(lower)
        coordinates = system["incoming_coordinates"]
        current_lookup = {
            (name, level): index
            for index, ((name, _, _, _), level)
            in enumerate(zip(current, current_levels))
        }
        source_names = list(dict.fromkeys(row[0] for row in lower))
        target_names = list(dict.fromkeys(row[0] for row in current))
        for column, ((source, _, _, _), level) in enumerate(
            zip(lower, lower_levels)
        ):
            for target in target_names:
                for offset in (-1, 0, 1):
                    target_index = current_lookup.get(
                        (target, level + offset)
                    )
                    if target_index is None:
                        continue
                    key = (source, target, offset)
                    value = coordinates[column][target_index]
                    samples.setdefault(key, []).append((q, level, value))
                    if value:
                        all_patterns.add(key)
        assert set(row[0] for row in lower) == set(source_names)
    result = {}
    for key in sorted(all_patterns):
        rows = []
        for q, level, value in samples[key]:
            rows.append(
                [
                    Fraction(q) ** q_degree
                    * Fraction(level) ** j_degree
                    for q_degree, j_degree in MONOMIALS_3
                ]
                + [value]
            )
        coefficients = solve_overdetermined(rows, len(MONOMIALS_3))
        result[f"{key[0]}->{key[1]}@{key[2]:+d}"] = [
            str(value) for value in coefficients
        ]
    return {
        "coefficient_monomials": [
            f"q^{q_degree}j^{j_degree}"
            for q_degree, j_degree in MONOMIALS_3
        ],
        "couplings": result,
        "verified_q_values": list(systems),
    }


def polynomial_add(left, right):
    out = dict(left)
    for monomial, value in right.items():
        out[monomial] = out.get(monomial, Fraction(0)) + value
        if not out[monomial]:
            del out[monomial]
    return out


def polynomial_multiply(left, right):
    out = {}
    for (left_q, left_j), left_value in left.items():
        for (right_q, right_j), right_value in right.items():
            monomial = (left_q + right_q, left_j + right_j)
            out[monomial] = (
                out.get(monomial, Fraction(0))
                + left_value * right_value
            )
    return {monomial: value for monomial, value in out.items() if value}


def polynomial_scale(polynomial, scalar):
    return {
        monomial: Fraction(scalar) * value
        for monomial, value in polynomial.items()
        if scalar * value
    }


def polynomial_determinant(matrix):
    if len(matrix) == 1:
        return matrix[0][0]
    out = {}
    for column in range(len(matrix)):
        minor = [
            row[:column] + row[column + 1:]
            for row in matrix[1:]
        ]
        term = polynomial_multiply(
            matrix[0][column],
            polynomial_determinant(minor),
        )
        out = polynomial_add(
            out,
            polynomial_scale(term, -1 if column % 2 else 1),
        )
    return out


def backward_block_determinant(label, recurrence):
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
    zero = ["0"] * len(MONOMIALS_3)
    matrix = []
    for source in source_names:
        row = []
        for target in target_names:
            coefficients = couplings.get(
                f"{source}->{target}@-1",
                zero,
            )
            row.append(
                {
                    monomial: Fraction(value)
                    for monomial, value
                    in zip(MONOMIALS_3, coefficients)
                    if Fraction(value)
                }
            )
        matrix.append(row)
    determinant = polynomial_determinant(matrix)
    assert all(q_degree == 0 for q_degree, _ in determinant)
    coefficients = {
        j_degree: value
        for (_, j_degree), value in determinant.items()
    }
    first_degree = min(coefficients)
    first = coefficients[first_degree]
    normalized = [
        coefficients.get(degree, Fraction(0)) / first
        for degree in range(first_degree, max(coefficients) + 1)
    ]
    expected = {
        "2": [
            Fraction(1),
            Fraction(9, 2),
            Fraction(-9, 2),
            Fraction(-81, 2),
            Fraction(-81, 2),
        ],
        "3": [
            Fraction(1),
            Fraction(0),
            Fraction(-81, 4),
            Fraction(0),
            Fraction(243, 2),
            Fraction(0),
            Fraction(-729, 4),
        ],
        "3p": [
            Fraction(1),
            Fraction(0),
            Fraction(-81, 4),
            Fraction(0),
            Fraction(243, 2),
            Fraction(0),
            Fraction(-729, 4),
        ],
    }[label]
    assert normalized == expected
    factorization = {
        "2": (
            "-c*j^2*(3j-1)*(3j+1)^2*(3j+2)/2, "
            "c=3468519014400000000"
        ),
        "3": (
            "c*j^3*(1-9j^2)^2*(1-9j^2/4), "
            "c=43953072950476800000000000"
        ),
        "3p": (
            "c*j^3*(1-9j^2)^2*(1-9j^2/4), "
            "c=-15190182011684782080000000000"
        ),
    }[label]
    return {
        "first_degree": first_degree,
        "first_coefficient": str(first),
        "normalized_coefficients_ascending": [
            str(value) for value in normalized
        ],
        "factorization": factorization,
        "integer_nonvanishing_domain": "j>=1",
    }


def certificate():
    low_checks = {}
    for label in FAMILIES:
        rows = []
        for q in range(1, 4):
            witness = exact_witness(label, q)
            rows.append(
                {
                    "q": q,
                    "degree": witness["degree"],
                    "lower_dimension": len(witness["lower_basis"]),
                    "current_dimension": len(witness["current_basis"]),
                    "nonzero_mixing_coordinates": sum(
                        bool(value) for value in witness["mixing"]
                    ),
                    "last_mixing_sign": (
                        (witness["mixing"][-1] > 0)
                        - (witness["mixing"][-1] < 0)
                    ),
                }
            )
        low_checks[label] = rows
    recurrences = {
        label: universal_incoming(label)
        for label in FAMILIES
    }
    return {
        "schema": "c682-nontrivial-plateau-block-recurrence-v1",
        "families": {
            label: f"n={base}+60q, q>=1"
            for label, base in FAMILIES.items()
        },
        "free_generator_degrees": {
            label: [degree for _, degree, _ in module_data(label)[-1]]
            for label in FAMILIES
        },
        "incoming_block_recurrences": recurrences,
        "backward_block_determinants": {
            label: backward_block_determinant(label, recurrences[label])
            for label in FAMILIES
        },
        "low_q_checks": low_checks,
        "conclusion": (
            "The incoming annihilator equations on the 2, 3, and 3' "
            "plateau families are exact block three-term recurrences with "
            "coefficient entries polynomial of total degree at most 3 in "
            "(q,j). Their backward blocks are invertible at every integer "
            "level j>=1. Exact mixing holds for q=1,2,3."
        ),
        "claim_boundary": (
            "This constructs the block recurrence input but does not yet "
            "prove all-q boundary mixing."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    parser.add_argument("module", choices=sorted(FAMILIES), nargs="?")
    parser.add_argument("q", type=int, nargs="?")
    arguments = parser.parse_args()
    if arguments.write or arguments.check:
        rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
        if arguments.write:
            CERTIFICATE.write_text(rendered, encoding="utf-8")
            print(f"WROTE: {CERTIFICATE}")
        else:
            assert CERTIFICATE.read_text(encoding="utf-8") == rendered
            print("PASS: C682 nontrivial plateau block recurrences")
        return
    if arguments.module is None or arguments.q is None:
        parser.error("module and q are required outside --write/--check")
    row = exact_witness(arguments.module, arguments.q)
    nonzero = [
        (index, value)
        for index, value in enumerate(row["mixing"])
        if value
    ]
    print(
        f"{row['module']} degree={row['degree']} "
        f"{len(row['lower_basis'])}->{len(row['current_basis'])} "
        f"nonzero={len(nonzero)} first={nonzero[:1]} "
        f"last={nonzero[-1:]}"
    )
    print(f"current_basis={row['current_basis']}")
    print(f"lower_basis={row['lower_basis']}")
    print(
        "last_incoming_support="
        f"{[(index, value) for index, value in enumerate(row['incoming_coordinates'][-1]) if value]}"
    )
    print(
        "last_return_support="
        f"{[(index, value) for index, value in enumerate(row['returned_coordinates'][-1]) if value]}"
    )
    print(f"null={row['null']}")


if __name__ == "__main__":
    main()
