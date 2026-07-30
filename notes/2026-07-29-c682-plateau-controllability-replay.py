#!/usr/bin/env python3
"""Independent modular replay of the C682 trivial plateau witness."""

from __future__ import annotations

import importlib.util
import json
from functools import reduce
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
ENGINE = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
CERTIFICATE = HERE / "2026-07-29-c682-plateau-controllability.json"
PRIMES = (1_000_000_007, 1_000_000_009)


def load_engine():
    spec = importlib.util.spec_from_file_location("plateau_replay_engine", ENGINE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {ENGINE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def primitive_invariants(engine):
    klein = engine.KLEIN
    raw_hessian = engine.transvectant_z(klein, klein, 2)
    hessian_content = reduce(gcd, (abs(value) for value in raw_hessian.values()))
    hessian = {
        monomial: value // hessian_content
        for monomial, value in raw_hessian.items()
    }
    raw_jacobian = engine.transvectant_z(klein, raw_hessian, 1)
    jacobian_content = reduce(gcd, (abs(value) for value in raw_jacobian.values()))
    jacobian = {
        monomial: value // jacobian_content
        for monomial, value in raw_jacobian.items()
    }
    return klein, hessian, jacobian


def power(base, exponent, engine, prime):
    out = {(0, 0): 1}
    reduced = {
        monomial: coefficient % prime
        for monomial, coefficient in base.items()
    }
    for _ in range(exponent):
        out = engine.multiply(out, reduced, prime)
    return out


def ring_monomial(
    f_power,
    h_power,
    engine,
    klein,
    hessian,
    prime,
    jacobian=None,
):
    out = engine.multiply(
        power(klein, f_power, engine, prime),
        power(hessian, h_power, engine, prime),
        prime,
    )
    if jacobian is not None:
        out = engine.multiply(
            {monomial: value % prime for monomial, value in jacobian.items()},
            out,
            prime,
        )
    return out


def vector(polynomial, degree):
    return [
        polynomial.get((degree - index, index), 0)
        for index in range(degree + 1)
    ]


def solve_columns(columns, target, prime):
    row_count = len(target)
    column_count = len(columns)
    work = [
        [columns[column][row] % prime for column in range(column_count)]
        + [target[row] % prime]
        for row in range(row_count)
    ]
    pivots = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [
            entry * inverse % prime
            for entry in work[pivot_row]
        ]
        for row in range(row_count):
            if row == pivot_row or not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                (entry - multiplier * pivot_entry) % prime
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    assert len(pivots) == column_count
    solution = [0] * column_count
    for row, column in enumerate(pivots):
        solution[column] = work[row][-1]
    return solution


def left_null(columns, prime):
    size = len(columns) + 1
    matrix = [
        [column[row] % prime for row in range(size)]
        for column in columns
    ]
    work = [row + [0] for row in matrix]
    pivots = []
    pivot_row = 0
    for column in range(size):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, prime)
        work[pivot_row] = [
            entry * inverse % prime
            for entry in work[pivot_row]
        ]
        for row in range(len(work)):
            if row == pivot_row or not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                (entry - multiplier * pivot_entry) % prime
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    free = next(column for column in range(size) if column not in pivots)
    out = [0] * size
    out[free] = 1
    for row, pivot in reversed(list(enumerate(pivots))):
        out[pivot] = -sum(
            work[row][column] * out[column]
            for column in range(pivot + 1, size)
        ) % prime
    return out


def boundary_scalar(q, prime, engine, invariants):
    klein, hessian, jacobian = invariants
    degree = 64 + 60 * q
    current_polynomials = [
        ring_monomial(
            2 + 5 * index,
            2 + 3 * (q - index),
            engine,
            klein,
            hessian,
            prime,
        )
        for index in range(q + 1)
    ]
    current_columns = [
        vector(polynomial, degree)
        for polynomial in current_polynomials
    ]
    incoming_polynomials = [
        engine.transvectant(
            ring_monomial(
                4 + 5 * index,
                3 * (q - index) - 1,
                engine,
                klein,
                hessian,
                prime,
                jacobian,
            ),
            {monomial: value % prime for monomial, value in klein.items()},
            3,
            prime,
        )
        for index in range(q)
    ]
    incoming = [
        solve_columns(
            current_columns,
            vector(polynomial, degree),
            prime,
        )
        for polynomial in incoming_polynomials
    ]
    last_return = engine.transvectant(
        engine.transvectant(
            incoming_polynomials[-1],
            {monomial: value % prime for monomial, value in klein.items()},
            3,
            prime,
        ),
        {monomial: value % prime for monomial, value in klein.items()},
        9,
        prime,
    )
    returned = solve_columns(
        current_columns,
        vector(last_return, degree),
        prime,
    )
    null = left_null(incoming, prime)
    return sum(left * right for left, right in zip(null, returned)) % prime


def evaluate(coefficients, value, prime):
    out = 0
    for coefficient in reversed(coefficients):
        out = (out * value + coefficient) % prime
    return out


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    symbolic = certificate["symbolic_reduction"]
    numerator = symbolic["mixing_numerator_coefficients_ascending"]
    denominator = symbolic["mixing_denominator_coefficients_ascending"]
    engine = load_engine()
    invariants = primitive_invariants(engine)
    for prime in PRIMES:
        for q in range(1, 6):
            assert boundary_scalar(q, prime, engine, invariants)
        for q in (22, 23):
            observed = boundary_scalar(q, prime, engine, invariants)
            predicted_denominator = evaluate(denominator, q, prime)
            assert predicted_denominator
            predicted = (
                evaluate(numerator, q, prime)
                * pow(predicted_denominator, -1, prime)
                % prime
            )
            assert observed == predicted
    print("PASS: C682 trivial plateau controllability replay")


if __name__ == "__main__":
    main()
