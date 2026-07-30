#!/usr/bin/env python3
"""Independent one-variable Dickson replay for C689."""

import argparse
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c689-shared-radial.json"


def dickson_difference(q, parameter):
    n = (q - 1) // 2
    coefficients = []
    for index in range((n - 1) // 2 + 1):
        lucas = n * math.comb(n - index, index) // (n - index)
        coefficients.append(
            (
                2
                * (-1) ** index
                * lucas
                * pow(parameter, index, q)
                * pow(1 + parameter, n - 2 * index, q)
            )
            % q
        )
    assert sum(coefficients) % q == 0
    return coefficients


def divide_by_x_minus_one(coefficients, q):
    quotient = [-coefficients[0] % q]
    for coefficient in coefficients[1:-1]:
        quotient.append((quotient[-1] - coefficient) % q)
    assert quotient[-1] == coefficients[-1]
    return quotient


def deepest_trace(coefficients, degree, q):
    current = coefficients
    current_degree = degree
    while current_degree > 1:
        following = [0] * max(1, len(current) - 1)
        for index, coefficient in enumerate(current):
            if index:
                following[index - 1] = (
                    following[index - 1]
                    + 4 * index * index * coefficient
                ) % q
            y_degree = current_degree - 2 * index
            if y_degree >= 2 and index < len(following):
                following[index] = (
                    following[index]
                    - y_degree * (y_degree - 1) * coefficient
                ) % q
        current = following
        current_degree -= 2
    assert len(current) == 1
    return current[0]


def replay(field):
    q = field["q"]
    torus = field["torus_normal_form"]
    parameter = torus["parameter"]
    assert 4 * parameter * parameter % q == 1
    assert pow(parameter, (q - 1) // 2, q) == q - 1
    difference = dickson_difference(q, parameter)
    assert difference == torus["difference_coefficients"]
    quotient = divide_by_x_minus_one(difference, q)
    trace = deepest_trace(quotient, (q - 5) // 2, q)
    assert trace == torus["deepest_cofactor_trace"][1]
    assert trace

    design = field["cross_incidence_design"]
    assert design["k"] * (design["k"] - 1) == (
        design["lambda"] * (design["v"] - 1)
    )
    assert 4 * design["lambda"] % q == 1
    assert design["invertible_in_characteristic_q"]
    assert design["inverse_formula"] == "4*A^T*(I-J)"
    normalized_support = set(
        design["paley_affine_normalization"]["normalized_support"]
    )
    squares = {value * value % q for value in range(1, q)}
    assert normalized_support == squares | {0}
    assert design["paley_complement"]
    assert design["nonzero_paley_multiplier"] == 4
    assert design["bordered_paley_hadamard_order"] == q + 1
    assert design["bordered_paley_hadamard"]
    assert pow(4, (q - 1) // 2, q) == 1
    assert all(
        pow(4, exponent, q) != 1
        for exponent in range(1, (q - 1) // 2)
    )
    assert field["incident_pair_cycle_lengths"] == [q - 1]
    assert field["old_witness"]["radial_scalar"] in (4, 10)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", required=True)
    parser.parse_args()
    certificate = json.loads(CERTIFICATE.read_text())
    assert [field["q"] for field in certificate["fields"]] == [7, 11]
    for field in certificate["fields"]:
        replay(field)
    assert certificate["fields"][0]["old_witness"]["radial_scalar"] == 4
    assert certificate["fields"][1]["old_witness"]["radial_scalar"] == 10
    print("C689 independent Dickson replay OK")


if __name__ == "__main__":
    main()
