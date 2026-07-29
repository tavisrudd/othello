#!/usr/bin/env python3
"""Independent replay of the C682 corrected bridge modulo 11^3."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
CERTIFICATE = Path(__file__).with_name(
    "2026-07-28-c682-corrected-bridge-mod-1331.json"
)
PREVIOUS_CERTIFICATE = Path(__file__).with_name(
    "2026-07-28-c682-invariant-operator-divided-power.json"
)
PRIME = 11
MODULUS = PRIME**3
OPERATOR_MODULUS = PRIME**2
F_VECTOR = [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0]
FROBENIUS_INDICES = {0, 1, 11, 12}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def matmul(left, right, modulus: int):
    return [
        [
            sum(a * b for a, b in zip(row, column)) % modulus
            for column in zip(*right)
        ]
        for row in left
    ]


def matrix_power(matrix, exponent: int, modulus: int):
    answer = [
        [int(row == column) for column in range(len(matrix))]
        for row in range(len(matrix))
    ]
    for _ in range(exponent):
        answer = matmul(answer, matrix, modulus)
    return answer


def inverse_2x2(entries, modulus: int):
    a, b, c, d = entries
    inverse_determinant = pow((a * d - b * c) % modulus, -1, modulus)
    return (
        d * inverse_determinant % modulus,
        -b * inverse_determinant % modulus,
        -c * inverse_determinant % modulus,
        a * inverse_determinant % modulus,
    )


def symmetric_action(entries, degree: int, modulus: int):
    a, b, c, d = inverse_2x2(entries, modulus)
    action = [[0] * (degree + 1) for _ in range(degree + 1)]
    for column in range(degree + 1):
        left_degree = degree - column
        right_degree = column
        for left_y in range(left_degree + 1):
            for right_y in range(right_degree + 1):
                row = left_y + right_y
                coefficient = (
                    math.comb(left_degree, left_y)
                    * pow(a, left_degree - left_y, modulus)
                    * pow(b, left_y, modulus)
                    * math.comb(right_degree, right_y)
                    * pow(c, right_degree - right_y, modulus)
                    * pow(d, right_y, modulus)
                )
                action[row][column] = (
                    action[row][column] + coefficient
                ) % modulus
    return action


def clean(poly):
    return {exponent: coefficient for exponent, coefficient in poly.items() if coefficient}


def derivative(poly, x_order: int, y_order: int):
    answer = {}
    for (x_degree, y_degree), coefficient in poly.items():
        if x_degree < x_order or y_degree < y_order:
            continue
        answer[(x_degree - x_order, y_degree - y_order)] = (
            coefficient
            * math.factorial(x_degree)
            // math.factorial(x_degree - x_order)
            * math.factorial(y_degree)
            // math.factorial(y_degree - y_order)
        )
    return clean(answer)


def multiply(left, right):
    answer = {}
    for (left_x, left_y), left_coefficient in left.items():
        for (right_x, right_y), right_coefficient in right.items():
            exponent = (left_x + right_x, left_y + right_y)
            answer[exponent] = (
                answer.get(exponent, 0) + left_coefficient * right_coefficient
            )
    return clean(answer)


def add_scaled(target, source, scale: int):
    for exponent, coefficient in source.items():
        target[exponent] = target.get(exponent, 0) + scale * coefficient
        if not target[exponent]:
            del target[exponent]


def third_transvectant(left, right):
    answer = {}
    for index in range(4):
        term = multiply(
            derivative(left, 3 - index, index),
            derivative(right, index, 3 - index),
        )
        add_scaled(answer, term, (-1) ** index * math.comb(3, index))
    return clean(answer)


def transvectant_matrix(right_vector, modulus: int):
    right = {
        (12 - row, row): value
        for row, value in enumerate(right_vector)
        if value
    }
    answer = [[0] * 7 for _ in range(13)]
    for column in range(7):
        image = third_transvectant({(6 - column, column): 1}, right)
        for row in range(13):
            answer[row][column] = image.get((12 - row, row), 0) % modulus
    return answer


def vector_from_terms(terms):
    answer = [0] * 13
    for term in terms:
        assert term["x"] + term["y"] == 12
        answer[term["y"]] = term["coefficient"]
    return answer


def rank_mod_prime(matrix):
    work = [[value % PRIME for value in row] for row in matrix]
    rank = 0
    columns = len(work[0])
    for column in range(columns):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, PRIME)
        work[rank] = [value * inverse % PRIME for value in work[rank]]
        for row in range(len(work)):
            if row == rank or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [
                (left - scale * right) % PRIME
                for left, right in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def replay():
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    previous = json.loads(PREVIOUS_CERTIFICATE.read_text(encoding="utf-8"))
    assert certificate["schema"] == "c682-corrected-bridge-mod-1331-v1"
    assert certificate["prime"] == PRIME
    assert certificate["dodecic_modulus"] == MODULUS
    assert certificate["operator_modulus"] == OPERATOR_MODULUS
    for relative, record in certificate["inputs"].items():
        path = REPOSITORY / relative
        assert path.stat().st_size == record["bytes"]
        assert sha256(path) == record["sha256"]

    presentation = certificate["presentation"]
    left_entries = tuple(presentation["S_mod_1331"])
    right_entries = tuple(presentation["T_mod_1331"])
    left = [list(left_entries[:2]), list(left_entries[2:])]
    right = [list(right_entries[:2]), list(right_entries[2:])]
    identity = [[1, 0], [0, 1]]
    minus_identity = [[MODULUS - 1, 0], [0, MODULUS - 1]]
    assert (left_entries[0] * left_entries[3] - left_entries[1] * left_entries[2]) % MODULUS == 1
    assert (right_entries[0] * right_entries[3] - right_entries[1] * right_entries[2]) % MODULUS == 1
    assert matrix_power(left, 2, MODULUS) == minus_identity
    assert matrix_power(right, 3, MODULUS) == minus_identity
    assert matrix_power(matmul(left, right, MODULUS), 5, MODULUS) == identity
    trace_five = presentation["trace_ST_mod_1331"]
    assert (trace_five * trace_five + trace_five - 1) % MODULUS == 0
    golden = certificate["golden_character_field"]
    assert golden["selected_trace_root_mod_1331"] == trace_five == 1294
    assert golden["conjugate_trace_root_mod_1331"] == 36
    assert golden["selected_sqrt5_mod_1331"] == (2 * trace_five + 1) % MODULUS == 1258
    assert golden["conjugate_sqrt5_mod_1331"] == 73
    assert golden["selected_sqrt5_mod_1331"] ** 2 % MODULUS == 5
    assert golden["conjugate_sqrt5_mod_1331"] ** 2 % MODULUS == 5
    assert golden["selected_sqrt5_mod_11"] == 4
    assert golden["conjugate_sqrt5_mod_11"] == 7
    assert golden["one_incidence_orientation_scalar_mod_11"] == 4

    invariant = vector_from_terms(
        certificate["normalized_invariant_dodecic_mod_1331"]
    )
    first_digit = vector_from_terms(
        certificate["first_correction_digit_from_F"]
    )
    second_digit = vector_from_terms(
        certificate["second_correction_digit_from_F"]
    )
    reconstructed = [
        (F_VECTOR[row] + PRIME * first_digit[row] + PRIME**2 * second_digit[row])
        % MODULUS
        for row in range(13)
    ]
    assert reconstructed == invariant
    assert invariant[1] == 1
    target_actions_1331 = [
        symmetric_action(entries, 12, MODULUS)
        for entries in (left_entries, right_entries)
    ]
    assert all(
        [
            sum(action[row][column] * invariant[column] for column in range(13))
            % MODULUS
            for row in range(13)
        ]
        == invariant
        for action in target_actions_1331
    )

    prior_k = vector_from_terms(previous["tt_repair_polynomial_K"])
    difference = [
        (first_digit[row] - prior_k[row]) % PRIME for row in range(13)
    ]
    assert difference == vector_from_terms(
        certificate["first_digit_minus_prior_K"]
    )
    assert all(not value or row in FROBENIUS_INDICES for row, value in enumerate(difference))

    quotient = [
        (first_digit[row] + PRIME * second_digit[row]) % OPERATOR_MODULUS
        for row in range(13)
    ]
    raw_correction = transvectant_matrix(quotient, OPERATOR_MODULUS)
    inverse_240 = pow(240, -1, OPERATOR_MODULUS)
    primitive = previous["sym6_primitive_matrix"]
    operator = [
        [
            (
                primitive[row][column]
                + inverse_240 * raw_correction[row][column]
            )
            % OPERATOR_MODULUS
            for column in range(7)
        ]
        for row in range(13)
    ]
    assert operator == certificate["corrected_operator_mod_121"]
    assert rank_mod_prime(operator) == 4
    source_actions = [
        symmetric_action(entries, 6, OPERATOR_MODULUS)
        for entries in (left_entries, right_entries)
    ]
    target_actions = [
        symmetric_action(entries, 12, OPERATOR_MODULUS)
        for entries in (left_entries, right_entries)
    ]
    assert all(
        matmul(target, operator, OPERATOR_MODULUS)
        == matmul(operator, source, OPERATOR_MODULUS)
        for source, target in zip(source_actions, target_actions)
    )
    assert certificate["operator_rank_mod_11"] == 4
    assert certificate["operator_kernel_dimension_mod_11"] == 3
    assert certificate["operator_cokernel_dimension_mod_11"] == 9
    bockstein = certificate["operator_kernel_bockstein_matrix"]
    assert len(bockstein) == 9 and all(len(row) == 3 for row in bockstein)
    assert all(not value for row in bockstein for value in row)
    assert certificate["operator_kernel_bockstein_rank"] == 0
    lifted_kernel = certificate["operator_kernel_mod_121"]
    assert len(lifted_kernel) == 3
    assert rank_mod_prime(lifted_kernel) == 3
    assert all(
        all(
            sum(operator[row][column] * vector[column] for column in range(7))
            % OPERATOR_MODULUS
            == 0
            for row in range(13)
        )
        for vector in lifted_kernel
    )
    assert certificate["operator_flat_rank_through_mod_121"] == 4

    four_actions = certificate["marked_four_actions_mod_121"]
    identity_four = [
        [int(row == column) for column in range(4)] for row in range(4)
    ]
    assert matrix_power(four_actions[0], 2, OPERATOR_MODULUS) == identity_four
    assert matrix_power(four_actions[1], 3, OPERATOR_MODULUS) == identity_four
    assert matrix_power(
        matmul(four_actions[0], four_actions[1], OPERATOR_MODULUS),
        5,
        OPERATOR_MODULUS,
    ) == identity_four
    source_chart = certificate["source_four_chart_mod_121"]
    target_chart = certificate["target_four_chart_mod_121"]
    assert [[value % PRIME for value in row] for row in source_chart] == previous[
        "c651_four_chart_in_sym6"
    ]
    assert [[value % PRIME for value in row] for row in target_chart] == previous[
        "c651_equivariant_target_four_chart"
    ]
    assert all(
        matmul(source, source_chart, OPERATOR_MODULUS)
        == matmul(source_chart, four, OPERATOR_MODULUS)
        for source, four in zip(source_actions, four_actions)
    )
    assert all(
        matmul(target, target_chart, OPERATOR_MODULUS)
        == matmul(target_chart, four, OPERATOR_MODULUS)
        for target, four in zip(target_actions, four_actions)
    )
    transported = matmul(operator, source_chart, OPERATOR_MODULUS)
    scalar = certificate["marked_bridge_scalar_mod_121"]
    assert scalar % PRIME == previous["tt_repaired_pair_to_target_scalar"]
    assert certificate["target_chart_rescaling_to_keep_scalar_5"] == 23
    assert 5 * 23 % OPERATOR_MODULUS == scalar
    assert transported == [
        [scalar * value % OPERATOR_MODULUS for value in row]
        for row in target_chart
    ]
    gate = certificate["all_order_hensel_gate"]
    assert gate["binary_group_order"] == 120
    assert gate["prime_is_coprime_to_group_order"]
    assert gate["presentation_constraint_count"] == 5
    assert gate["presentation_jacobian_rank_mod_11"] == 5
    assert gate["normalized_invariant_unknown_count"] == 13
    assert gate["normalized_invariant_rank_mod_11"] == 13
    return scalar, difference


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", required=True)
    parser.parse_args()
    scalar, difference = replay()
    support = [row for row, value in enumerate(difference) if value]
    print(
        "C682 independent mod-1331 replay: OK "
        f"(bridge scalar mod 121 = {scalar}; first-digit gauge rows = {support})"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
