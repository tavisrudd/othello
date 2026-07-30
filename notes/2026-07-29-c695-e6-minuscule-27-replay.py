#!/usr/bin/env python3
"""Independent finite-field replay of the C695 residual-line construction."""

from __future__ import annotations

import importlib.util
import itertools
from pathlib import Path


ROOT = Path(__file__).resolve().parent
BASE_PATH = ROOT / "2026-07-28-c682-operator-schlafli-replay.py"
spec = importlib.util.spec_from_file_location("c682_replay", BASE_PATH)
assert spec and spec.loader
base = importlib.util.module_from_spec(spec)
spec.loader.exec_module(base)


def monomials(variables, degree):
    if variables == 1:
        return [(degree,)]
    return [
        (first,) + rest
        for first in range(degree + 1)
        for rest in monomials(variables - 1, degree - first)
    ]


M2 = monomials(2, 3)
M3 = monomials(3, 3)
M4 = monomials(4, 3)


def coordinates(vector, basis, prime):
    augmented = [
        [basis[column][row] for column in range(len(basis))] + [vector[row]]
        for row in range(len(vector))
    ]
    reduced, pivots = base.rref(augmented, prime)
    assert pivots == list(range(len(basis)))
    result = [0] * len(basis)
    for row, pivot in enumerate(pivots):
        result[pivot] = reduced[row][-1]
    assert [
        sum(result[index] * basis[index][column] for index in range(len(basis)))
        % prime
        for column in range(len(vector))
    ] == [value % prime for value in vector]
    return result


def mul(left, right, prime):
    result = {}
    for left_exp, left_value in left.items():
        for right_exp, right_value in right.items():
            exponent = tuple(a + b for a, b in zip(left_exp, right_exp, strict=True))
            result[exponent] = (
                result.get(exponent, 0) + left_value * right_value
            ) % prime
    return {exponent: value for exponent, value in result.items() if value}


def power(value, exponent, prime):
    variables = len(next(iter(value)))
    result = {(0,) * variables: 1}
    for _ in range(exponent):
        result = mul(result, value, prime)
    return result


def substitute(cubic, linear_forms, targets, prime):
    variables = len(linear_forms[0])
    result = {}
    for coefficient, powers in zip(cubic, M4, strict=True):
        term = {(0,) * variables: coefficient}
        for form, exponent in zip(linear_forms, powers, strict=True):
            if not exponent:
                continue
            polynomial = {
                tuple(1 if index == column else 0 for index in range(variables)): value
                for column, value in enumerate(form)
                if value
            }
            if not polynomial:
                term = {}
                break
            term = mul(term, power(polynomial, exponent, prime), prime)
        for monomial, value in term.items():
            result[monomial] = (result.get(monomial, 0) + value) % prime
    return [result.get(monomial, 0) for monomial in targets]


def cubic_through(lines, prime):
    equations = []
    for line in lines:
        forms = [list(values) for values in zip(*line, strict=True)]
        columns = [
            substitute(
                [1 if index == monomial_index else 0 for index in range(20)],
                forms,
                M2,
                prime,
            )
            for monomial_index in range(20)
        ]
        equations.extend([list(row) for row in zip(*columns, strict=True)])
    kernel = base.nullspace(equations, prime)
    assert len(kernel) == 1 and base.rank(equations, prime) == 19
    return kernel[0]


def linear_polynomial(form):
    return {
        tuple(1 if index == column else 0 for index in range(len(form))): value
        for column, value in enumerate(form)
        if value
    }


def residual(cubic, first, second, ambient, prime):
    plane = base.rref(first + second, prime)[0]
    assert len(plane) == 3
    plane_coordinates = [coordinates(vector, ambient, prime) for vector in plane]
    forms = [list(values) for values in zip(*plane_coordinates, strict=True)]
    restricted = substitute(cubic, forms, M3, prime)
    first_in_plane = [coordinates(vector, plane, prime) for vector in first]
    second_in_plane = [coordinates(vector, plane, prime) for vector in second]
    first_equation = base.nullspace(first_in_plane, prime)[0]
    second_equation = base.nullspace(second_in_plane, prime)[0]
    product = mul(
        linear_polynomial(first_equation),
        linear_polynomial(second_equation),
        prime,
    )
    equations = []
    for monomial in M3:
        equations.append(
            [
                mul(
                    product,
                    linear_polynomial(
                        [1 if index == column else 0 for index in range(3)]
                    ),
                    prime,
                ).get(monomial, 0)
                for column in range(3)
            ]
        )
    augmented = [
        row + [value] for row, value in zip(equations, restricted, strict=True)
    ]
    reduced, pivots = base.rref(augmented, prime)
    assert pivots == [0, 1, 2]
    quotient = [reduced[index][-1] for index in range(3)]
    line_in_plane = base.nullspace([quotient], prime)
    return [
        [
            sum(vector[index] * plane[index][column] for index in range(3))
            % prime
            for column in range(7)
        ]
        for vector in line_in_plane
    ]


def canonical(space, prime):
    return base.rref(space, prime)[0]


def replay(prime):
    zeta = base.primitive_fifth_root(prime)
    plus_kernel = base.nullspace(base.operator(1, prime), prime)
    ambient = base.rref(base.annihilator(plus_kernel, prime), prime)[0]
    axes = [[0, 1, 0]]
    for exponent in range(5):
        value = pow(zeta, exponent, prime)
        axes.append([1, value, -value * value % prime])
    e_lines = []
    e_prime_lines = []
    for axis in axes:
        tangent = [
            base.product(base.power(axis, 2, prime), vector, prime)
            for vector in ([1, 0, 0], [0, 1, 0], [0, 0, 1])
        ]
        e_lines.append(base.intersection(ambient, tangent, prime))
        e_prime_lines.append(
            base.intersection(ambient, base.annihilator(tangent, prime), prime)
        )
    twelve_coordinates = [
        [coordinates(vector, ambient, prime) for vector in line]
        for line in e_lines + e_prime_lines
    ]
    cubic = cubic_through(twelve_coordinates, prime)
    lines = {}
    for left, right in itertools.combinations(range(6), 2):
        forward = residual(
            cubic, e_lines[left], e_prime_lines[right], ambient, prime
        )
        backward = residual(
            cubic, e_lines[right], e_prime_lines[left], ambient, prime
        )
        assert canonical(forward, prime) == canonical(backward, prime)
        lines[(left, right)] = forward
    assert len({str(canonical(line, prime)) for line in lines.values()}) == 15
    assert all(
        base.intersection_dimension(e_lines[index], lines[pair], prime)
        == int(index in pair)
        for index in range(6)
        for pair in lines
    )
    assert all(
        base.intersection_dimension(e_prime_lines[index], lines[pair], prime)
        == int(index in pair)
        for index in range(6)
        for pair in lines
    )
    assert all(
        base.intersection_dimension(lines[first], lines[second], prime)
        == int(set(first).isdisjoint(second))
        for first, second in itertools.combinations(lines, 2)
    )
    return zeta


def main():
    rows = [(prime, replay(prime)) for prime in (31, 41)]
    print(
        "PASS independent C695 finite-field replay "
        + " ".join(f"p={prime}:zeta={zeta}" for prime, zeta in rows)
    )


if __name__ == "__main__":
    main()
