#!/usr/bin/env python3
"""Exact GF(9) verifier for C255's cheap-coefficient gauge cost."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import combinations, product
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
C203_VERIFIER = HERE / "2026-07-15-c203-q9-coefficient-verifier.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_c203():
    spec = importlib.util.spec_from_file_location("c203_coefficient_verifier", C203_VERIFIER)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def primitive_element(field):
    for candidate in range(1, field.q):
        powers = {field.pow(candidate, exponent) for exponent in range(field.q - 1)}
        if powers == set(range(1, field.q)):
            return candidate
    raise AssertionError("no primitive element found")


def circuit_edges(field, c203, points):
    """Return (circuit, coordinate, coefficient) for all four U(2,4) triples."""

    edges = []
    supports = list(combinations(range(4), 3))
    for circuit, support in enumerate(supports):
        coefficients = c203.kernel_generator(field, [points[index] for index in support])
        assert all(coefficient != 0 for coefficient in coefficients)
        edges.extend(
            (circuit, coordinate, coefficient)
            for coordinate, coefficient in zip(support, coefficients)
        )
    return supports, edges


def first_four_cycle_holonomy(field, edges):
    coefficient = {(circuit, coordinate): value for circuit, coordinate, value in edges}
    numerator = field.mul(coefficient[0, 0], coefficient[1, 1])
    denominator = field.mul(coefficient[1, 0], coefficient[0, 1])
    return field.mul(numerator, field.inv(denominator))


def optimum_quotient_cost(field, edges, cheap):
    """Exhaust vertex switchings in K*/cheap and minimize nontrivial edge cosets."""

    generator = primitive_element(field)
    logarithm = {field.pow(generator, exponent): exponent for exponent in range(field.q - 1)}
    cheap_exponents = {logarithm[value] for value in cheap}
    assert cheap_exponents == {0, 4}
    quotient_order = 4
    edge_exponents = [
        (circuit, 4 + coordinate, logarithm[value] % quotient_order)
        for circuit, coordinate, value in edges
    ]

    best_cost = len(edges) + 1
    best_potential = None
    best_labels = None
    cost_histogram = Counter()
    # The incidence graph is connected. Fix circuit vertex zero to remove the global switch.
    for tail in product(range(quotient_order), repeat=7):
        potential = (0,) + tail
        labels = tuple(
            (value + potential[circuit] - potential[coordinate]) % quotient_order
            for circuit, coordinate, value in edge_exponents
        )
        cost = sum(label != 0 for label in labels)
        cost_histogram[cost] += 1
        if cost < best_cost:
            best_cost = cost
            best_potential = potential
            best_labels = labels

    assert sum(cost_histogram.values()) == quotient_order**7
    assert best_potential is not None and best_labels is not None
    return {
        "optimum": best_cost,
        "best_vertex_potential_mod_cheap": list(best_potential),
        "best_edge_labels_mod_cheap": list(best_labels),
        "optimum_assignment_count": cost_histogram[best_cost],
        "switchings_checked": quotient_order**7,
    }


def optimum_directed_multiplier_cost(field, edges, cheap):
    """Minimize noncheap recovery ratios over coordinate gauges; row gauges cancel."""

    generator = primitive_element(field)
    logarithm = {field.pow(generator, exponent): exponent for exponent in range(field.q - 1)}
    assert {logarithm[value] for value in cheap} == {0, 4}
    quotient_order = 4
    by_circuit = [[] for _ in range(4)]
    for circuit, coordinate, value in edges:
        by_circuit[circuit].append((coordinate, logarithm[value] % quotient_order))

    best_cost = 49
    best_potential = None
    cost_histogram = Counter()
    # Fix coordinate zero: a common coordinate switch changes no coefficient ratio.
    for tail in product(range(quotient_order), repeat=3):
        potential = (0,) + tail
        cost = 0
        for row in by_circuit:
            labels = [(value - potential[coordinate]) % quotient_order for coordinate, value in row]
            cost += sum(left != right for left in labels for right in labels)
        cost_histogram[cost] += 1
        if cost < best_cost:
            best_cost = cost
            best_potential = potential

    assert sum(cost_histogram.values()) == quotient_order**3
    assert best_potential is not None
    return {
        "directed_multiplier_optimum": best_cost,
        "directed_multiplier_best_coordinate_potential_mod_cheap": list(best_potential),
        "directed_multiplier_optimum_assignment_count": cost_histogram[best_cost],
        "directed_multiplier_switchings_checked": quotient_order**3,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    c203 = load_c203()
    base = c203.load_base()
    field = base.FIELDS[1]
    assert field.q == 9
    all_points, _labels = base.completed_points(field)
    axis_offset = field.q + 1
    cheap = {1, field.sub(0, 1)}
    assert cheap == {1, 2}

    examples = []
    for parameters, expected_holonomy in (((0, 1, 3, 4), 2), ((0, 1, 2, 8), 3)):
        points = [all_points[axis_offset + parameter] for parameter in parameters]
        supports, edges = circuit_edges(field, c203, points)
        holonomy = first_four_cycle_holonomy(field, edges)
        assert holonomy == expected_holonomy
        optimum = optimum_quotient_cost(field, edges, cheap)
        multiplier_optimum = optimum_directed_multiplier_cost(field, edges, cheap)
        examples.append(
            {
                "axis_parameters": list(parameters),
                "circuit_supports": [list(support) for support in supports],
                "cross_ratio_holonomy": holonomy,
                "holonomy_is_cheap": holonomy in cheap,
                **optimum,
                **multiplier_optimum,
            }
        )

    optima = tuple(example["optimum"] for example in examples)
    assert optima == (0, 4), optima
    multiplier_optima = tuple(example["directed_multiplier_optimum"] for example in examples)
    assert multiplier_optima == (0, 14), multiplier_optima
    assert examples[0]["holonomy_is_cheap"]
    assert not examples[1]["holonomy_is_cheap"]

    certificate = {
        "field": "GF(9)=GF(3)[z]/(z^2+1)",
        "cheap_subgroup": sorted(cheap),
        "quotient": "GF(9)^*/GF(3)^* = C4",
        "examples": examples,
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output is not None:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
