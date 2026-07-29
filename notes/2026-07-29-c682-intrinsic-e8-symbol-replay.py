#!/usr/bin/env python3
"""Independent modular replay of the C682 E8 radial symbol identity."""

from __future__ import annotations

import importlib.util
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
PRIMES = (1_000_000_007, 1_000_000_009)


def load_base():
    spec = importlib.util.spec_from_file_location("klein_e8_modular_base", BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load the independent modular engine")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def falling(value, order):
    result = 1
    for offset in range(order):
        result *= value - offset
    return result


def polynomial_scale(polynomial, scalar, prime):
    return {
        monomial: coefficient * scalar % prime
        for monomial, coefficient in polynomial.items()
        if coefficient * scalar % prime
    }


def polynomial_add(left, right, prime):
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = (result.get(monomial, 0) + coefficient) % prime
        if result[monomial] == 0:
            del result[monomial]
    return result


def polynomial_power(polynomial, exponent, tools, prime):
    result = {(0, 0): 1}
    while exponent:
        if exponent & 1:
            result = tools.multiply(result, polynomial, prime)
        polynomial = tools.multiply(polynomial, polynomial, prime)
        exponent //= 2
    return result


def exact_divide(polynomial, divisor, prime):
    inverse = pow(divisor, -1, prime)
    return polynomial_scale(polynomial, inverse, prime)


def replay_at_prime(prime):
    tools = load_base()
    klein = {
        monomial: coefficient % prime
        for monomial, coefficient in tools.KLEIN.items()
    }
    raw_hessian = tools.transvectant(klein, klein, 2, prime)
    hessian = exact_divide(raw_hessian, 242, prime)
    raw_jacobian = tools.transvectant(klein, raw_hessian, 1, prime)
    jacobian = exact_divide(raw_jacobian, 4840, prime)

    checks = 0
    for a in range(7):
        for b in range(7):
            source = tools.multiply(
                polynomial_power(klein, a, tools, prime),
                polynomial_power(hessian, b, tools, prime),
                prime,
            )
            direct = exact_divide(
                tools.transvectant(source, klein, 3, prime),
                132,
                prime,
            )

            radial = {}
            first_coefficient = (
                20 * falling(a, 3)
                + 50 * falling(a, 2) * b
                + 55 * falling(a, 2)
            )
            if first_coefficient:
                first = tools.multiply(
                    polynomial_power(klein, a - 2, tools, prime),
                    polynomial_power(hessian, b, tools, prime),
                    prime,
                )
                radial = polynomial_scale(first, first_coefficient, prime)
            second_coefficient = -80000 * falling(b, 3)
            if second_coefficient:
                second = tools.multiply(
                    polynomial_power(klein, a + 3, tools, prime),
                    polynomial_power(hessian, b - 3, tools, prime),
                    prime,
                )
                radial = polynomial_add(
                    radial,
                    polynomial_scale(second, second_coefficient, prime),
                    prime,
                )
            expected = (
                tools.multiply(jacobian, radial, prime) if radial else {}
            )
            assert direct == expected
            checks += 1
    return checks


def main():
    checks = {prime: replay_at_prime(prime) for prime in PRIMES}
    assert checks == {prime: 49 for prime in PRIMES}
    print(
        "PASS: independent modular radial-symbol replay "
        "(49 monomials at each of two primes)"
    )


if __name__ == "__main__":
    main()
