#!/usr/bin/env python3
"""Independent one-variable Dickson replay for C689."""

import argparse
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c689-shared-radial.json"


def rank_mod(matrix, prime):
    rows = [[entry % prime for entry in row] for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next(
            (
                row
                for row in range(rank, len(rows))
                if rows[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inverse = pow(rows[rank][column], -1, prime)
        rows[rank] = [entry * inverse % prime for entry in rows[rank]]
        for row in range(len(rows)):
            if row != rank and rows[row][column]:
                factor = rows[row][column]
                rows[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(rows[row], rows[rank])
                ]
        rank += 1
    return rank


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
    assert design["skew_paley_core"]
    assert design["skew_core_square"] == "-q*I+J"
    assert design["characteristic_zero_augmentation_polynomial"] == "x^2+q"
    signed = [
        [
            2 * int((column - row) % q in normalized_support) - 1
            for column in range(q)
        ]
        for row in range(q)
    ]
    skew = [
        [signed[row][column] - int(row == column) for column in range(q)]
        for row in range(q)
    ]
    half = (q - 1) // 2
    taylor_coefficients = [
        sum(
            skew[0][value] * math.comb(value, degree)
            for value in range(q)
        )
        % q
        for degree in range(q)
    ]
    leading_coefficient = -pow(math.factorial(half), -1, q) % q
    assert taylor_coefficients[:half] == [0] * half
    assert taylor_coefficients[half] == leading_coefficient
    assert design["translation_group_algebra"] == "F_q[t]/(t^q), t=T-1"
    assert design["quadratic_character_t_adic_order"] == half
    assert (
        design["quadratic_character_leading_coefficient"]
        == leading_coefficient
    )
    assert (
        design["quadratic_character_leading_formula"]
        == "-1/(((q-1)/2)!)"
    )
    assert design["full_image_augmentation_ideal_power"] == half
    assert design["full_kernel_augmentation_ideal_power"] == half + 1
    assert design["augmentation_image_kernel_ideal_power"] == half + 1
    assert (
        design["middle_quotient_isomorphism"]
        == "I/I^((q+1)/2) ~= I^((q+1)/2)"
    )
    assert all(
        skew[
            (multiplier * row) % q
        ][
            (multiplier * column) % q
        ]
        == (
            (1 if multiplier in squares else -1)
            * skew[row][column]
        )
        for multiplier in range(1, q)
        for row in range(q)
        for column in range(q)
    )
    assert design["dilation_conjugation_character"] == "quadratic"
    assert design["middle_quotient_twist"] == "quadratic orientation character"
    augmentation_basis = [
        [int(column == index) - int(column == q - 1) for column in range(q)]
        for index in range(q - 1)
    ]
    images = [
        [
            sum(skew[row][column] * vector[column] for column in range(q))
            % q
            for row in range(q)
        ]
        for vector in augmentation_basis
    ]
    assert rank_mod(skew, q) == design["defining_characteristic_full_rank"]
    assert design["defining_characteristic_full_rank"] == (q + 1) // 2
    skew_square = [
        [
            sum(skew[row][index] * skew[index][column] for index in range(q))
            % q
            for column in range(q)
        ]
        for row in range(q)
    ]
    skew_cube = [
        [
            sum(
                skew_square[row][index] * skew[index][column]
                for index in range(q)
            )
            % q
            for column in range(q)
        ]
        for row in range(q)
    ]
    assert rank_mod(skew_square, q) == 1
    assert not any(any(row) for row in skew_cube)
    assert design["defining_characteristic_full_nilpotency_index"] == 3
    assert design["defining_characteristic_full_jordan_blocks"] == (
        [3] + [2] * ((q - 3) // 2)
    )
    assert design["defining_characteristic_augmentation_dimension"] == q - 1
    assert rank_mod(images, q) == (
        design["defining_characteristic_augmentation_rank"]
    )
    assert design["defining_characteristic_augmentation_rank"] == (q - 1) // 2
    assert all(sum(vector) % q == 0 for vector in images)
    assert all(
        sum(skew[row][column] * vector[column] for column in range(q)) % q
        == 0
        for vector in images
        for row in range(q)
    )
    assert design["defining_characteristic_square_zero"]
    assert design["defining_characteristic_image_equals_kernel"]
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
