#!/usr/bin/env python3
"""Independent modular replay of the global C682 Weyl operators."""

import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-29-c682-nontrivial-plateau-controllability-replay.py"
CERTIFICATE = HERE / "2026-07-29-c682-global-weyl-operators.json"
PRIMES = (1_000_000_007, 1_000_000_009)


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load(BASE_PATH, "global_weyl_modular_base")


def falling(value, order, prime):
    out = 1
    for offset in range(order):
        out = out * (value - offset) % prime
    return out


def coefficient_mod_prime(value, prime):
    rational = Fraction(value)
    return (
        rational.numerator
        * pow(rational.denominator, -1, prime)
    ) % prime


def direct_transition(
    label,
    order,
    f_power,
    h_power,
    generator_index,
    prime,
):
    tools = BASE.load_base()
    data = BASE.build_data(label, tools, prime)
    klein, hessian, generators = data
    name, generator_degree, generator = generators[generator_index]
    coefficient = tools.multiply(
        BASE.polynomial_power(klein, f_power, tools, prime),
        BASE.polynomial_power(hessian, h_power, tools, prime),
        prime,
    )
    source = tools.multiply(coefficient, generator, prime)
    target = tools.transvectant(source, klein, order, prime)
    target_degree = (
        generator_degree
        + 12 * f_power
        + 20 * h_power
        + 12
        - 2 * order
    )
    candidates = BASE.candidates(
        target_degree, data, tools, prime
    )
    target_columns = [
        tools.coefficient_vector(polynomial, target_degree)
        for _, _, _, polynomial in candidates
    ]
    solution = BASE.solve_columns(
        target_columns,
        tools.coefficient_vector(target, target_degree),
        prime,
    )
    return {
        (target_name, target_f, target_h): value
        for (
            target_name,
            target_f,
            target_h,
            _,
        ), value in zip(candidates, solution)
        if value
    }


def predicted_transition(
    operator,
    source_name,
    f_power,
    h_power,
    prime,
):
    predicted = {}
    for term in operator["terms"]:
        if term["source"] != source_name:
            continue
        scalar = (
            coefficient_mod_prime(term["coefficient"], prime)
            * falling(f_power, term["dF_order"], prime)
            * falling(h_power, term["dH_order"], prime)
        ) % prime
        if not scalar:
            continue
        key = (
            term["target"],
            f_power
            - term["dF_order"]
            + term["F_multiplier"],
            h_power
            - term["dH_order"]
            + term["H_multiplier"],
        )
        predicted[key] = (predicted.get(key, 0) + scalar) % prime
    return {
        key: value for key, value in predicted.items() if value
    }


def main():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    for prime in PRIMES:
        for label, operators in certificate["operators"].items():
            for order_text, operator in operators.items():
                order = int(order_text)
                points = (
                    (order + 3, order + 4),
                    (order + 4, order + 3),
                )
                for generator_index, source_name in enumerate(
                    operator["generator_names"]
                ):
                    for f_power, h_power in points:
                        assert direct_transition(
                            label,
                            order,
                            f_power,
                            h_power,
                            generator_index,
                            prime,
                        ) == predicted_transition(
                            operator,
                            source_name,
                            f_power,
                            h_power,
                            prime,
                        )
    print("PASS: independent modular C682 global Weyl replay")


if __name__ == "__main__":
    main()
