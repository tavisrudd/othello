#!/usr/bin/env python3
"""Exact Newton data for the C756 q=47 quadratic-through-octic carrier."""

from __future__ import annotations

import argparse
from collections import defaultdict
import json
import math
from pathlib import Path


Q = 47
MIN_GENERATOR = 2
MAX_GENERATOR = 8
MAX_MOMENT = 11
ZERO = (0,) * (MAX_GENERATOR - MIN_GENERATOR + 1)


def add(*polynomials):
    result = defaultdict(int)
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            result[monomial] += coefficient
    return {monomial: coefficient for monomial, coefficient in result.items()
            if coefficient}


def scale(polynomial, scalar):
    return {
        monomial: scalar * coefficient
        for monomial, coefficient in polynomial.items()
        if scalar * coefficient
    }


def generator(index):
    if not MIN_GENERATOR <= index <= MAX_GENERATOR:
        return {}
    exponent = [0] * len(ZERO)
    exponent[index - MIN_GENERATOR] = 1
    return {tuple(exponent): 1}


def multiply(left, right):
    result = defaultdict(int)
    for left_monomial, left_coefficient in left.items():
        for right_monomial, right_coefficient in right.items():
            monomial = tuple(
                left_exponent + right_exponent
                for left_exponent, right_exponent
                in zip(left_monomial, right_monomial)
            )
            result[monomial] += left_coefficient * right_coefficient
    return {monomial: coefficient for monomial, coefficient in result.items()
            if coefficient}


def newton_moments():
    """Return p_d in Z[e_2,...,e_8], imposing e_1=e_9=e_10=e_11=0."""
    moments = {0: {ZERO: 55}, 1: {}}
    for degree in range(2, MAX_MOMENT + 1):
        terms = []
        for index in range(2, degree):
            terms.append(
                scale(
                    multiply(generator(index), moments[degree - index]),
                    (-1) ** (index - 1),
                )
            )
        if degree <= MAX_GENERATOR:
            terms.append(scale(generator(degree), (-1) ** (degree - 1) * degree))
        moments[degree] = add(*terms)
    return moments


def weighted_degree(monomial):
    return sum(
        (index + MIN_GENERATOR) * exponent
        for index, exponent in enumerate(monomial)
    )


def monomial_name(monomial):
    factors = []
    for offset, exponent in enumerate(monomial):
        if not exponent:
            continue
        name = f"e_{offset + MIN_GENERATOR}"
        factors.append(name if exponent == 1 else f"{name}^{exponent}")
    return " ".join(factors) if factors else "1"


def rows(polynomial):
    return [
        {
            "coefficient_over_Z": coefficient,
            "coefficient_mod_47": coefficient % Q,
            "monomial": monomial_name(monomial),
            "exponents_e2_through_e8": list(monomial),
        }
        for monomial, coefficient in sorted(
            polynomial.items(), key=lambda item: (sum(item[0]), item[0])
        )
    ]


def verify(moments):
    if Q <= MAX_MOMENT:
        raise AssertionError("ordinary polarization denominator vanishes")
    for degree in range(1, MAX_MOMENT + 1):
        residual_terms = [moments[degree]]
        for index in range(1, degree):
            elementary = {} if index == 1 else generator(index)
            residual_terms.append(
                scale(
                    multiply(elementary, moments[degree - index]),
                    (-1) ** index,
                )
            )
        elementary_degree = generator(degree)
        residual_terms.append(
            scale(elementary_degree, (-1) ** degree * degree)
        )
        if add(*residual_terms):
            raise AssertionError((degree, add(*residual_terms)))
        for monomial in moments[degree]:
            if weighted_degree(monomial) != degree:
                raise AssertionError((degree, monomial))


def exact_output():
    moments = newton_moments()
    verify(moments)
    return {
        "schema": "c756-q47-octic-carrier-v1",
        "q": Q,
        "node_count_over_Z": 55,
        "node_count_mod_q": 55 % Q,
        "centered_elementary_form": "e_1=0",
        "forced_zero_elementary_forms": [9, 10, 11],
        "carrier_elementary_forms": list(range(2, 9)),
        "carrier_binary_coefficient_count": sum(degree + 1 for degree in range(2, 9)),
        "maximum_moment_degree": MAX_MOMENT,
        "polarization_factorial_inverses_mod_q": {
            str(degree): pow(math.factorial(degree), -1, Q)
            for degree in range(MAX_MOMENT + 1)
        },
        "power_sum_formulas": {
            str(degree): rows(moments[degree])
            for degree in range(2, MAX_MOMENT + 1)
        },
        "interfaces": {
            "partition_value_degree": 11,
            "generator_gradient_degree": 10,
            "separator_hessian_degree": 9,
            "arrangement_line_count": 11,
            "separator_count": 55,
        },
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--check", type=Path)
    parser.add_argument("--output", type=Path)
    arguments = parser.parse_args()
    if arguments.exact == (arguments.check is not None):
        parser.error("select exactly one of --exact or --check FILE")
    rendered = json.dumps(exact_output(), indent=2, sort_keys=True) + "\n"
    if arguments.check is not None:
        if rendered != arguments.check.read_text():
            raise SystemExit(f"certificate mismatch: {arguments.check}")
        print(f"certificate ok: {arguments.check}")
    elif arguments.output is not None:
        arguments.output.write_text(rendered)
        print(f"wrote {arguments.output}")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
