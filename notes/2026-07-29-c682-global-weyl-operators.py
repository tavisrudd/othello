#!/usr/bin/env python3
"""Global F,H-Weyl operators for the C682 2, 3, and 3' modules."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
FREE_PATH = HERE / "2026-07-28-c682-klein-e8-free-covariant.py"
MODULE_PATH = HERE / "2026-07-29-c682-nontrivial-plateau-controllability.py"
CERTIFICATE = HERE / "2026-07-29-c682-global-weyl-operators.json"
MODULES = ("2", "3", "3p")
ORDERS = (3, 9)


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


FREE = load(FREE_PATH, "global_weyl_free")
MODULE_DATA = load(MODULE_PATH, "global_weyl_modules")


def transition(data, order, f_power, h_power, generator_index):
    exact, tools, klein, hessian, generators = data
    name, generator_degree, generator = generators[generator_index]
    coefficient = tools.multiply(
        exact.polynomial_power(klein, f_power, tools),
        exact.polynomial_power(hessian, h_power, tools),
    )
    source = tools.multiply(coefficient, generator)
    target = tools.transvectant(source, klein, order)
    target_degree = (
        generator_degree
        + 12 * f_power
        + 20 * h_power
        + 12
        - 2 * order
    )
    if target_degree < 0:
        return {}
    candidates = MODULE_DATA.candidates(target_degree, data)
    solution = exact.solve_columns(
        [
            exact.coefficient_vector(polynomial, target_degree)
            for _, _, _, polynomial in candidates
        ],
        exact.coefficient_vector(target, target_degree),
    )
    names = [row[0] for row in generators]
    return {
        (
            names.index(target_name),
            target_f_power - f_power,
            target_h_power - h_power,
        ): value
        for (
            target_name,
            target_f_power,
            target_h_power,
            _,
        ), value in zip(candidates, solution)
        if value
    }


def fit_operator(label, order):
    data = MODULE_DATA.module_data(label)
    generators = data[-1]
    names = [row[0] for row in generators]
    training_maximum = order + 1
    verification_maximum = order + 2
    training_points = [
        (f_power, h_power)
        for f_power in range(training_maximum + 1)
        for h_power in range(training_maximum + 1)
    ]
    transitions = {}
    signatures = {
        generator_index: set()
        for generator_index in range(len(generators))
    }
    for generator_index in range(len(generators)):
        for f_power, h_power in training_points:
            row = transition(
                data,
                order,
                f_power,
                h_power,
                generator_index,
            )
            transitions[
                (generator_index, f_power, h_power)
            ] = row
            signatures[generator_index].update(row)

    operator_terms = []
    for source_index in range(len(generators)):
        for target_index, f_shift, h_shift in sorted(
            signatures[source_index]
        ):
            descriptors = []
            columns = []
            for f_order in range(order + 1):
                for h_order in range(order + 1 - f_order):
                    f_multiplier = f_shift + f_order
                    h_multiplier = h_shift + h_order
                    if f_multiplier < 0 or h_multiplier < 0:
                        continue
                    descriptors.append(
                        (
                            f_multiplier,
                            h_multiplier,
                            f_order,
                            h_order,
                        )
                    )
                    columns.append(
                        [
                            FREE.falling(f_power, f_order)
                            * FREE.falling(h_power, h_order)
                            for f_power, h_power in training_points
                        ]
                    )
            target = [
                transitions[
                    (source_index, f_power, h_power)
                ].get(
                    (target_index, f_shift, h_shift),
                    Fraction(0),
                )
                for f_power, h_power in training_points
            ]
            solution = FREE.solve_columns(columns, target)
            for descriptor, coefficient in zip(
                descriptors, solution
            ):
                if coefficient:
                    operator_terms.append(
                        (
                            source_index,
                            target_index,
                            *descriptor,
                            coefficient,
                        )
                    )

    for source_index in range(len(generators)):
        for f_power in range(verification_maximum + 1):
            for h_power in range(verification_maximum + 1):
                actual = transition(
                    data,
                    order,
                    f_power,
                    h_power,
                    source_index,
                )
                predicted = {}
                for (
                    term_source,
                    target_index,
                    f_multiplier,
                    h_multiplier,
                    f_order,
                    h_order,
                    coefficient,
                ) in operator_terms:
                    if term_source != source_index:
                        continue
                    scalar = (
                        coefficient
                        * FREE.falling(f_power, f_order)
                        * FREE.falling(h_power, h_order)
                    )
                    if not scalar:
                        continue
                    key = (
                        target_index,
                        f_multiplier - f_order,
                        h_multiplier - h_order,
                    )
                    predicted[key] = predicted.get(
                        key, Fraction(0)
                    ) + scalar
                predicted = {
                    key: value
                    for key, value in predicted.items()
                    if value
                }
                assert predicted == actual, (
                    label,
                    order,
                    names[source_index],
                    f_power,
                    h_power,
                )

    return {
        "order": order,
        "degree_shift": 12 - 2 * order,
        "training_grid": f"0..{training_maximum}",
        "verification_grid": f"0..{verification_maximum}",
        "generator_names": names,
        "generator_degrees": [row[1] for row in generators],
        "term_count": len(operator_terms),
        "pair_count": len(
            {
                (source_index, target_index)
                for source_index, target_index, *_ in operator_terms
            }
        ),
        "terms": [
            {
                "source": names[source_index],
                "target": names[target_index],
                "F_multiplier": f_multiplier,
                "H_multiplier": h_multiplier,
                "dF_order": f_order,
                "dH_order": h_order,
                "coefficient": str(coefficient),
            }
            for (
                source_index,
                target_index,
                f_multiplier,
                h_multiplier,
                f_order,
                h_order,
                coefficient,
            ) in operator_terms
        ],
    }


def certificate():
    return {
        "schema": "c682-global-weyl-operators-v1",
        "operators": {
            label: {
                str(order): fit_operator(label, order)
                for order in ORDERS
            }
            for label in MODULES
        },
        "claim": (
            "The third- and ninth-transvectants are finite Weyl operators "
            "in the invariant exponents F,H on the complete 2,3,3' "
            "Kostant free modules."
        ),
        "trusted_boundary": (
            "Each order-r operator is fitted in the falling-factorial "
            "Weyl basis of total derivative order at most r on the "
            "(r+2)-square training grid and verified by direct exact "
            "transvectants on the strictly larger (r+3)-square grid."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(
        certificate(), indent=2, sort_keys=True
    ) + "\n"
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")
    else:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 global Weyl operators")


if __name__ == "__main__":
    main()
