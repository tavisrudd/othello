#!/usr/bin/env python3
"""Independent modular replay of the C682 nontrivial block recurrences."""

import importlib.util
import json
from fractions import Fraction
from functools import reduce
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
CERTIFICATE = (
    HERE / "2026-07-29-c682-nontrivial-plateau-controllability.json"
)
PRIMES = (1_000_000_007, 1_000_000_009)
FAMILIES = {"2": 63, "3": 72, "3p": 70}
MONOMIALS_3 = [
    (q_degree, j_degree)
    for total in range(4)
    for q_degree in range(total + 1)
    for j_degree in [total - q_degree]
]


def load_base():
    spec = importlib.util.spec_from_file_location(
        "nontrivial_plateau_modular_base",
        BASE,
    )
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def primitive(polynomial):
    content = reduce(gcd, (abs(value) for value in polynomial.values()))
    return {
        monomial: coefficient // content
        for monomial, coefficient in polynomial.items()
    }


def reduce_polynomial(polynomial, prime):
    return {
        monomial: coefficient % prime
        for monomial, coefficient in polynomial.items()
        if coefficient % prime
    }


def polynomial_power(base, exponent, tools, prime):
    out = {(0, 0): 1}
    factor = base
    while exponent:
        if exponent & 1:
            out = tools.multiply(out, factor, prime)
        exponent //= 2
        if exponent:
            factor = tools.multiply(factor, factor, prime)
    return out


def build_data(label, tools, prime):
    klein_z = tools.KLEIN
    raw_hessian_z = tools.transvectant_z(klein_z, klein_z, 2)
    hessian_z = primitive(raw_hessian_z)
    raw_jacobian_z = tools.transvectant_z(
        klein_z,
        raw_hessian_z,
        1,
    )
    jacobian_z = primitive(raw_jacobian_z)
    if label == "2":
        seed = {(1, 0): 1}
        generators_z = [
            ("g1", 1, seed),
            ("g11", 11, primitive(tools.transvectant_z(seed, klein_z, 1))),
            ("g19", 19, primitive(tools.transvectant_z(seed, hessian_z, 1))),
            ("g29", 29, primitive(tools.transvectant_z(seed, jacobian_z, 1))),
        ]
    elif label == "3":
        seed = {(2, 0): 1}
        generators_z = [
            ("g2", 2, seed),
            ("g10", 10, primitive(tools.derivative_z(klein_z, 0, 2))),
            ("g12", 12, primitive(tools.transvectant_z(seed, klein_z, 1))),
            ("g18", 18, primitive(tools.derivative_z(hessian_z, 0, 2))),
            ("g20", 20, primitive(tools.transvectant_z(seed, hessian_z, 1))),
            ("g28", 28, primitive(tools.derivative_z(jacobian_z, 0, 2))),
        ]
    elif label == "3p":
        seed = {(3, 3): 1}
        generators_z = [
            ("g6", 6, seed),
            ("g10", 10, primitive(tools.transvectant_z(seed, klein_z, 4))),
            ("g14", 14, primitive(tools.transvectant_z(seed, klein_z, 2))),
            ("g16", 16, primitive(tools.transvectant_z(seed, hessian_z, 5))),
            ("g20", 20, primitive(tools.transvectant_z(seed, hessian_z, 3))),
            ("g24", 24, primitive(tools.transvectant_z(seed, jacobian_z, 6))),
        ]
    else:
        raise ValueError(label)
    return (
        reduce_polynomial(klein_z, prime),
        reduce_polynomial(hessian_z, prime),
        [
            (name, degree, reduce_polynomial(generator, prime))
            for name, degree, generator in generators_z
        ],
    )


def candidates(degree, data, tools, prime):
    klein, hessian, generators = data
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
                polynomial_power(klein, f_power, tools, prime),
                polynomial_power(hessian, h_power, tools, prime),
                prime,
            )
            out.append(
                (
                    name,
                    f_power,
                    h_power,
                    tools.multiply(coefficient, generator, prime),
                )
            )
    return out


def solve_columns(columns, target, prime):
    rows = len(target)
    unknowns = len(columns)
    work = [
        [columns[column][row] for column in range(unknowns)]
        + [target[row]]
        for row in range(rows)
    ]
    pivot_row = 0
    pivots = []
    for column in range(unknowns):
        pivot = next(
            (
                row
                for row in range(pivot_row, rows)
                if work[row][column] % prime
            ),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [
            value * inverse % prime for value in work[pivot_row]
        ]
        for row in range(rows):
            if row == pivot_row or not work[row][column] % prime:
                continue
            value = work[row][column]
            work[row] = [
                (left - value * right) % prime
                for left, right in zip(work[row], work[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    if pivots != list(range(unknowns)):
        raise AssertionError("candidate columns are dependent")
    if any(
        not any(row[:unknowns]) and row[-1] % prime
        for row in work[pivot_row:]
    ):
        raise AssertionError("target is outside candidate span")
    return [work[row][-1] % prime for row in range(unknowns)]


def local_levels(basis):
    counts = {}
    out = []
    for name, _, _, _ in basis:
        out.append(counts.get(name, 0))
        counts[name] = counts.get(name, 0) + 1
    return out


def evaluate(coefficients, q, level, prime):
    return sum(
        (
            Fraction(value).numerator
            * pow(Fraction(value).denominator, -1, prime)
        )
        * pow(q, q_degree, prime)
        * pow(level, j_degree, prime)
        for (q_degree, j_degree), value
        in zip(MONOMIALS_3, coefficients)
    ) % prime


def replay(label, prime, certificate):
    tools = load_base()
    data = build_data(label, tools, prime)
    q = 7
    degree = FAMILIES[label] + 60 * q
    current = candidates(degree, data, tools, prime)
    lower = candidates(degree - 6, data, tools, prime)
    assert len(current) == len(lower) + 1
    current_columns = [
        tools.coefficient_vector(polynomial, degree)
        for _, _, _, polynomial in current
    ]
    current_levels = local_levels(current)
    lower_levels = local_levels(lower)
    current_lookup = {
        (name, level): index
        for index, ((name, _, _, _), level)
        in enumerate(zip(current, current_levels))
    }
    recurrence = certificate["incoming_block_recurrences"][label][
        "couplings"
    ]
    for (source, _, _, source_polynomial), level in zip(
        lower, lower_levels
    ):
        target = tools.transvectant(
            source_polynomial,
            data[0],
            3,
            prime,
        )
        coordinates = solve_columns(
            current_columns,
            tools.coefficient_vector(target, degree),
            prime,
        )
        for target_name in dict.fromkeys(row[0] for row in current):
            for offset in (-1, 0, 1):
                target_index = current_lookup.get(
                    (target_name, level + offset)
                )
                if target_index is None:
                    continue
                key = f"{source}->{target_name}@{offset:+d}"
                coefficients = recurrence.get(key, ["0"] * 10)
                expected = evaluate(coefficients, q, level, prime)
                assert coordinates[target_index] == expected
        allowed = {
            current_lookup[target_key]
            for target_key in current_lookup
            if abs(target_key[1] - level) <= 1
        }
        assert all(
            not value or index in allowed
            for index, value in enumerate(coordinates)
        )


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    for prime in PRIMES:
        for label in FAMILIES:
            replay(label, prime, certificate)
    print("PASS: independent modular C682 block-recurrence replay")


if __name__ == "__main__":
    main()
