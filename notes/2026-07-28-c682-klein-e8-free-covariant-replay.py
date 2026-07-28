#!/usr/bin/env python3
"""Independent modular replay of the Klein free 3-covariant presentation."""

from __future__ import annotations

import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPLAY_BASE = HERE / "2026-07-28-c682-klein-e8-first-failure-replay.py"
CERTIFICATE = HERE / "2026-07-28-c682-klein-e8-free-covariant.json"
PRIMES = (1_000_000_007, 1_000_000_009)


def load_replay_base():
    spec = importlib.util.spec_from_file_location("klein_modular_base", REPLAY_BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {REPLAY_BASE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def polynomial_scale(polynomial, scalar, prime):
    return {
        monomial: coefficient * scalar % prime
        for monomial, coefficient in polynomial.items()
        if coefficient * scalar % prime
    }


def polynomial_add(left, right, prime):
    out = dict(left)
    for monomial, coefficient in right.items():
        out[monomial] = (out.get(monomial, 0) + coefficient) % prime
        if not out[monomial]:
            del out[monomial]
    return out


def polynomial_power(polynomial, exponent, tools, prime):
    out = {(0, 0): 1}
    for _ in range(exponent):
        out = tools.multiply(out, polynomial, prime)
    return out


def falling(value, order):
    out = 1
    for offset in range(order):
        out *= value - offset
    return out


def fraction_mod(text, prime):
    value = Fraction(text)
    return value.numerator * pow(value.denominator, -1, prime) % prime


def exact_divide_mod(polynomial, divisor, prime):
    inverse = pow(divisor, -1, prime)
    return polynomial_scale(polynomial, inverse, prime)


def determinant_mod(matrix, prime):
    work = [row[:] for row in matrix]
    determinant = 1
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            determinant = -determinant
        pivot_value = work[column][column]
        determinant = determinant * pivot_value % prime
        inverse = pow(pivot_value, -1, prime)
        for row in range(column + 1, len(work)):
            multiplier = work[row][column] * inverse % prime
            for index in range(column, len(work)):
                work[row][index] = (
                    work[row][index] - multiplier * work[column][index]
                ) % prime
    return determinant % prime


def build_generators(tools, prime):
    klein = {
        monomial: coefficient % prime
        for monomial, coefficient in tools.KLEIN.items()
    }
    raw_hessian = tools.transvectant(klein, klein, 2, prime)
    hessian = exact_divide_mod(raw_hessian, 242, prime)
    raw_jacobian = tools.transvectant(klein, raw_hessian, 1, prime)
    jacobian = exact_divide_mod(raw_jacobian, 4840, prime)
    x_squared = {(2, 0): 1}
    generators = {
        "g2": x_squared,
        "g10": exact_divide_mod(
            tools.derivative(klein, 0, 2, prime),
            110,
            prime,
        ),
        "g12": exact_divide_mod(
            tools.transvectant(x_squared, klein, 1, prime),
            2,
            prime,
        ),
        "g18": exact_divide_mod(
            tools.derivative(hessian, 0, 2, prime),
            380,
            prime,
        ),
        "g20": exact_divide_mod(
            tools.transvectant(x_squared, hessian, 1, prime),
            40,
            prime,
        ),
        "g28": exact_divide_mod(
            tools.derivative(jacobian, 0, 2, prime),
            870,
            prime,
        ),
    }
    return klein, hessian, jacobian, generators


def replay_prime(certificate, prime):
    tools = load_replay_base()
    klein, hessian, jacobian, generators = build_generators(tools, prime)
    klein_relation = polynomial_add(
        tools.multiply(jacobian, jacobian, prime),
        tools.multiply(
            tools.multiply(hessian, hessian, prime),
            hessian,
            prime,
        ),
        prime,
    )
    klein_relation = polynomial_add(
        klein_relation,
        polynomial_scale(
            polynomial_power(klein, 5, tools, prime),
            -1728 % prime,
            prime,
        ),
        prime,
    )
    if klein_relation:
        raise SystemExit(f"primitive Klein relation failed modulo {prime}")
    terms_by_source = {name: [] for name in generators}
    for term in certificate["operator_terms"]:
        terms_by_source[term["source"]].append(term)
    inverse_132 = pow(132, -1, prime)
    checks = 0
    for source_name, source_generator in generators.items():
        for f_power in range(7):
            for h_power in range(7):
                coefficient = tools.multiply(
                    polynomial_power(klein, f_power, tools, prime),
                    polynomial_power(hessian, h_power, tools, prime),
                    prime,
                )
                source = tools.multiply(coefficient, source_generator, prime)
                direct = polynomial_scale(
                    tools.transvectant(source, klein, 3, prime),
                    inverse_132,
                    prime,
                )
                predicted = {}
                for term in terms_by_source[source_name]:
                    f_order = term["dF_order"]
                    h_order = term["dh_order"]
                    scalar = (
                        fraction_mod(term["coefficient"], prime)
                        * falling(f_power, f_order)
                        * falling(h_power, h_order)
                    ) % prime
                    if not scalar:
                        continue
                    coefficient_term = tools.multiply(
                        polynomial_power(
                            klein,
                            f_power - f_order + term["F_multiplier"],
                            tools,
                            prime,
                        ),
                        polynomial_power(
                            hessian,
                            h_power - h_order + term["h_multiplier"],
                            tools,
                            prime,
                        ),
                        prime,
                    )
                    contribution = tools.multiply(
                        coefficient_term,
                        generators[term["target"]],
                        prime,
                    )
                    predicted = polynomial_add(
                        predicted,
                        polynomial_scale(contribution, scalar, prime),
                        prime,
                    )
                if predicted != direct:
                    raise SystemExit(
                        "free-covariant replay failed modulo "
                        f"{prime} at {source_name} F^{f_power} h^{h_power}"
                    )
                checks += 1
    names = [
        row["name"]
        for row in certificate["free_3_covariant_basis"]
    ]
    principal_checks = 0
    for f_value, h_value, xi_value, eta_value in (
        (2, 3, 5, 7),
        (3, 5, 7, 11),
        (5, 7, 11, 13),
    ):
        matrix = [[0] * 6 for _ in range(6)]
        for term in certificate["operator_terms"]:
            if term["dF_order"] + term["dh_order"] != 3:
                continue
            source = names.index(term["source"])
            target = names.index(term["target"])
            value = (
                fraction_mod(term["coefficient"], prime)
                * pow(f_value, term["F_multiplier"], prime)
                * pow(h_value, term["h_multiplier"], prime)
                * pow(xi_value, term["dF_order"], prime)
                * pow(eta_value, term["dh_order"], prime)
            ) % prime
            matrix[target][source] = (matrix[target][source] + value) % prime
        scalar_symbol = (
            2 * f_value * xi_value**3
            + 5 * h_value * xi_value**2 * eta_value
            - 8000 * f_value**3 * eta_value**3
        ) % prime
        discriminant = (h_value**3 - 1728 * f_value**5) % prime
        expected = (
            1_000_000
            * pow(scalar_symbol, 6, prime)
            * pow(discriminant, 3, prime)
        ) % prime
        if determinant_mod(matrix, prime) != expected:
            raise SystemExit(f"principal determinant replay failed modulo {prime}")
        principal_checks += 1
    return checks, principal_checks


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    if (
        certificate["operator"]["raw_presentation_content"] != 132
        or certificate["operator_term_count"] != 103
    ):
        raise SystemExit("unexpected certificate identity")
    rows = []
    for prime in PRIMES:
        monomial_checks, principal_checks = replay_prime(certificate, prime)
        rows.append(
            {
                "prime": prime,
                "monomial_actions_checked": monomial_checks,
                "principal_determinant_checks": principal_checks,
                "grid": "six generators times 0<=a,b<=6",
            }
        )
    print(
        json.dumps(
            {
                "independent_replay": "PASS",
                "primitive_operator": "Delta/132",
                "rows": rows,
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
