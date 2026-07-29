#!/usr/bin/env python3
"""Test the corrected C682 bridge over Z/11^3 and its operator mod 11^2."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
PREVIOUS_SCRIPT = NOTES / "2026-07-28-c682-invariant-operator-divided-power.py"
PREVIOUS_CERTIFICATE = PREVIOUS_SCRIPT.with_suffix(".json")
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11
MODULUS = PRIME**3
OPERATOR_MODULUS = PRIME**2
F_VECTOR = [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0]
FROBENIUS_INDICES = (0, 1, 11, 12)


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


PREVIOUS = load_module("c682_divided_power", PREVIOUS_SCRIPT)
MM = PREVIOUS.MM
C651 = PREVIOUS.C651


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


def matdiff(left, right, modulus: int):
    return [
        [
            (left[row][column] - right[row][column]) % modulus
            for column in range(len(left[0]))
        ]
        for row in range(len(left))
    ]


def matrix_power(matrix, exponent: int, modulus: int):
    answer = [[1, 0], [0, 1]]
    for _ in range(exponent):
        answer = matmul(answer, matrix, modulus)
    return answer


def tuple_matrix(entries):
    return [[entries[0], entries[1]], [entries[2], entries[3]]]


def matrix_tuple(matrix):
    return tuple(value for row in matrix for value in row)


def solve_mod_prime(equations, rhs):
    assert len(equations) == len(rhs)
    augmented = [
        [value % PRIME for value in equation] + [value % PRIME]
        for equation, value in zip(equations, rhs)
    ]
    reduced, pivots = MM.rref(augmented, PRIME)
    unknowns = len(equations[0])
    assert unknowns not in pivots
    solution = [0] * unknowns
    for row, pivot in enumerate(pivots):
        if pivot < unknowns:
            solution[pivot] = reduced[row][unknowns]
    assert all(
        sum(a * b for a, b in zip(equation, solution)) % PRIME == value % PRIME
        for equation, value in zip(equations, rhs)
    )
    return solution, len(pivots)


def permutation_product(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def permutation_power(element, exponent: int):
    answer = tuple(range(len(element)))
    for _ in range(exponent):
        answer = permutation_product(answer, element)
    return answer


def permutation_order(element):
    identity = tuple(range(len(element)))
    for exponent in range(1, 61):
        if permutation_power(element, exponent) == identity:
            return exponent
    raise AssertionError("permutation order exceeds 60")


def presentation_pair(parent_group):
    ordered = sorted(parent_group)
    involution = next(
        left
        for left in ordered
        if permutation_order(left) == 2
        and any(
            permutation_order(right) == 3
            and permutation_order(permutation_product(left, right)) == 5
            for right in ordered
        )
    )
    cubic = next(
        right
        for right in ordered
        if permutation_order(right) == 3
        and permutation_order(permutation_product(involution, right)) == 5
    )
    return involution, cubic


def lift_root(root: int, modulus: int):
    new_modulus = modulus * PRIME
    candidates = [
        root + modulus * digit
        for digit in range(PRIME)
        if (root + modulus * digit) ** 2 + (root + modulus * digit) - 1
        == 0
        or (
            (root + modulus * digit) ** 2
            + (root + modulus * digit)
            - 1
        )
        % new_modulus
        == 0
    ]
    assert len(candidates) == 1
    return candidates[0]


def presentation_constraints(left, right, trace_five: int, modulus: int):
    product = matmul(left, right, modulus)
    return [
        (left[0][0] + left[1][1]) % modulus,
        (left[0][0] * left[1][1] - left[0][1] * left[1][0] - 1) % modulus,
        (right[0][0] + right[1][1] - 1) % modulus,
        (
            right[0][0] * right[1][1]
            - right[0][1] * right[1][0]
            - 1
        )
        % modulus,
        (product[0][0] + product[1][1] - trace_five) % modulus,
    ]


def lift_presentation(left, right, trace_five: int, modulus: int):
    new_modulus = modulus * PRIME
    new_trace = lift_root(trace_five, modulus)
    base = presentation_constraints(left, right, new_trace, new_modulus)
    assert all(value % modulus == 0 for value in base)
    equations = [[0] * 8 for _ in base]
    for variable in range(8):
        perturbed_left = [row[:] for row in left]
        perturbed_right = [row[:] for row in right]
        target = perturbed_left if variable < 4 else perturbed_right
        local = variable if variable < 4 else variable - 4
        target[local // 2][local % 2] += modulus
        changed = presentation_constraints(
            perturbed_left, perturbed_right, new_trace, new_modulus
        )
        for row in range(len(base)):
            equations[row][variable] = (
                (changed[row] - base[row]) % new_modulus
            ) // modulus
    rhs = [-(value // modulus) % PRIME for value in base]
    correction, rank = solve_mod_prime(equations, rhs)
    lifted_left = [
        [
            (left[row][column] + modulus * correction[2 * row + column])
            % new_modulus
            for column in range(2)
        ]
        for row in range(2)
    ]
    lifted_right = [
        [
            (
                right[row][column]
                + modulus * correction[4 + 2 * row + column]
            )
            % new_modulus
            for column in range(2)
        ]
        for row in range(2)
    ]
    assert presentation_constraints(
        lifted_left, lifted_right, new_trace, new_modulus
    ) == [0] * 5
    return lifted_left, lifted_right, new_trace, rank


def lift_fixed_vector(vector, actions, modulus: int, normalization_index: int):
    new_modulus = modulus * PRIME
    equations = []
    rhs = []
    for action in actions:
        residual = [
            (
                sum(action[row][column] * vector[column] for column in range(13))
                - vector[row]
            )
            % new_modulus
            for row in range(13)
        ]
        assert all(value % modulus == 0 for value in residual)
        reduced_action = [
            [value % PRIME for value in row]
            for row in action
        ]
        for row in range(13):
            equations.append(
                [
                    (
                        reduced_action[row][column]
                        - int(row == column)
                    )
                    % PRIME
                    for column in range(13)
                ]
            )
            rhs.append(-(residual[row] // modulus) % PRIME)
    normalization = [0] * 13
    normalization[normalization_index] = 1
    equations.append(normalization)
    rhs.append(0)
    correction, rank = solve_mod_prime(equations, rhs)
    lifted = [
        (value + modulus * digit) % new_modulus
        for value, digit in zip(vector, correction)
    ]
    assert lifted[normalization_index] == vector[normalization_index]
    return lifted, rank


def four_action(permutation, modulus: int):
    action = [[0] * 4 for _ in range(4)]
    for column in range(4):
        vector = [0] * 5
        vector[column] = 1
        vector[4] = -1
        moved = [0] * 5
        for index, value in enumerate(vector):
            moved[permutation[index]] = value
        for row in range(4):
            action[row][column] = moved[row] % modulus
    return action


def lift_intertwiner(base, left_actions, right_actions):
    rows = len(base)
    columns = len(base[0])
    equations = []
    rhs = []
    for left, right in zip(left_actions, right_actions):
        residual = matdiff(
            matmul(left, base, OPERATOR_MODULUS),
            matmul(base, right, OPERATOR_MODULUS),
            OPERATOR_MODULUS,
        )
        assert all(value % PRIME == 0 for row in residual for value in row)
        left_mod = [[value % PRIME for value in row] for row in left]
        right_mod = [[value % PRIME for value in row] for row in right]
        for row in range(rows):
            for column in range(columns):
                equation = [0] * (rows * columns)
                for middle in range(rows):
                    equation[middle * columns + column] += left_mod[row][middle]
                for middle in range(columns):
                    equation[row * columns + middle] -= right_mod[middle][column]
                equations.append([value % PRIME for value in equation])
                rhs.append(-residual[row][column] // PRIME % PRIME)
    pivot = next(
        row * columns + column
        for row in range(rows)
        for column in range(columns)
        if base[row][column] % PRIME
    )
    normalization = [0] * (rows * columns)
    normalization[pivot] = 1
    equations.append(normalization)
    rhs.append(0)
    correction, rank = solve_mod_prime(equations, rhs)
    lifted = [
        [
            (
                base[row][column]
                + PRIME * correction[row * columns + column]
            )
            % OPERATOR_MODULUS
            for column in range(columns)
        ]
        for row in range(rows)
    ]
    assert all(
        matmul(left, lifted, OPERATOR_MODULUS)
        == matmul(lifted, right, OPERATOR_MODULUS)
        for left, right in zip(left_actions, right_actions)
    )
    return lifted, rank, pivot


def serialize_vector(vector):
    return [
        {"x": 12 - row, "y": row, "coefficient": value}
        for row, value in enumerate(vector)
        if value
    ]


def transvectant_matrix(right_vector, modulus: int):
    right = {
        (12 - row, row): value
        for row, value in enumerate(right_vector)
        if value
    }
    matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        image = PREVIOUS.raw_third_transvectant_with_right(
            {(6 - column, column): 1}, right
        )
        for row in range(13):
            matrix[row][column] = image.get((12 - row, row), 0) % modulus
    return matrix


def build_certificate():
    previous = json.loads(PREVIOUS_CERTIFICATE.read_text(encoding="utf-8"))
    workspace = C651.h3_workspace()
    parent_group = workspace["parent_group"]
    _subgroups, five_actions = C651.natural_five_action(parent_group)
    involution, cubic = presentation_pair(parent_group)
    parameters = tuple(MM.COXETER.conic_parameterization(PRIME)[1])
    raw_left = PREVIOUS.recover_pgl_matrix(involution, parameters)
    raw_right = PREVIOUS.recover_pgl_matrix(cubic, parameters)
    left = tuple_matrix(raw_left)
    determinant = (raw_right[0] * raw_right[3] - raw_right[1] * raw_right[2]) % PRIME
    scale = next(
        value
        for value in range(1, PRIME)
        if value * value * determinant % PRIME == 1
    )
    right = tuple_matrix(tuple(scale * value % PRIME for value in raw_right))
    trace_five = 7
    assert presentation_constraints(left, right, trace_five, PRIME) == [0] * 5
    presentation_ranks = []
    for modulus in (PRIME, PRIME**2):
        left, right, trace_five, rank = lift_presentation(
            left, right, trace_five, modulus
        )
        presentation_ranks.append(rank)
    assert trace_five * trace_five + trace_five - 1 == 0 or (
        trace_five * trace_five + trace_five - 1
    ) % MODULUS == 0
    minus_identity = [[MODULUS - 1, 0], [0, MODULUS - 1]]
    identity = [[1, 0], [0, 1]]
    assert matrix_power(left, 2, MODULUS) == minus_identity
    assert matrix_power(right, 3, MODULUS) == minus_identity
    assert matrix_power(matmul(left, right, MODULUS), 5, MODULUS) == identity

    invariant = [value % PRIME for value in F_VECTOR]
    invariant_lift_ranks = []
    for modulus in (PRIME, PRIME**2):
        new_modulus = modulus * PRIME
        actions = [
            PREVIOUS.symmetric_action_mod(
                matrix_tuple(matrix), 12, 0, new_modulus
            )
            for matrix in (left, right)
        ]
        invariant, rank = lift_fixed_vector(invariant, actions, modulus, 1)
        invariant_lift_ranks.append(rank)
    assert invariant[1] == 1
    invariant_actions_1331 = [
        PREVIOUS.symmetric_action_mod(matrix_tuple(matrix), 12, 0, MODULUS)
        for matrix in (left, right)
    ]
    assert all(
        [
            sum(action[row][column] * invariant[column] for column in range(13))
            % MODULUS
            for row in range(13)
        ]
        == invariant
        for action in invariant_actions_1331
    )

    quotient = [
        ((invariant[row] - F_VECTOR[row]) % MODULUS) // PRIME
        for row in range(13)
    ]
    assert all(
        (invariant[row] - F_VECTOR[row]) % MODULUS % PRIME == 0
        for row in range(13)
    )
    first_digit = [value % PRIME for value in quotient]
    second_digit = [value // PRIME for value in quotient]
    prior_k = [0] * 13
    for term in previous["tt_repair_polynomial_K"]:
        prior_k[term["y"]] = term["coefficient"]
    gauge_difference = [
        (first_digit[row] - prior_k[row]) % PRIME for row in range(13)
    ]
    assert all(
        not value or row in FROBENIUS_INDICES
        for row, value in enumerate(gauge_difference)
    )

    primitive = previous["sym6_primitive_matrix"]
    correction_matrix = transvectant_matrix(quotient, OPERATOR_MODULUS)
    inverse_240 = pow(240, -1, OPERATOR_MODULUS)
    operator = [
        [
            (
                primitive[row][column]
                + inverse_240 * correction_matrix[row][column]
            )
            % OPERATOR_MODULUS
            for column in range(7)
        ]
        for row in range(13)
    ]
    source_actions = [
        PREVIOUS.symmetric_action_mod(
            matrix_tuple(matrix), 6, 0, OPERATOR_MODULUS
        )
        for matrix in (left, right)
    ]
    target_actions = [
        PREVIOUS.symmetric_action_mod(
            matrix_tuple(matrix), 12, 0, OPERATOR_MODULUS
        )
        for matrix in (left, right)
    ]
    assert all(
        matmul(target, operator, OPERATOR_MODULUS)
        == matmul(operator, source, OPERATOR_MODULUS)
        for source, target in zip(source_actions, target_actions)
    )

    four_actions = [
        four_action(five_actions[element], OPERATOR_MODULUS)
        for element in (involution, cubic)
    ]
    source_chart, source_rank, source_pivot = lift_intertwiner(
        previous["c651_four_chart_in_sym6"],
        source_actions,
        four_actions,
    )
    target_chart, target_rank, target_pivot = lift_intertwiner(
        previous["c651_equivariant_target_four_chart"],
        target_actions,
        four_actions,
    )
    transported = matmul(operator, source_chart, OPERATOR_MODULUS)
    comparison_scalar = next(
        transported[row][column]
        * pow(target_chart[row][column], -1, OPERATOR_MODULUS)
        % OPERATOR_MODULUS
        for row in range(13)
        for column in range(4)
        if target_chart[row][column] % PRIME
    )
    assert comparison_scalar % PRIME == 5
    assert transported == [
        [comparison_scalar * value % OPERATOR_MODULUS for value in row]
        for row in target_chart
    ]

    inputs = (
        PREVIOUS_SCRIPT,
        PREVIOUS_CERTIFICATE,
        PREVIOUS.MATCHING_MODULE_PATH,
        PREVIOUS.C651_SCRIPT_PATH,
        PREVIOUS.C651_CERTIFICATE_PATH,
    )
    return {
        "schema": "c682-corrected-bridge-mod-1331-v1",
        "prime": PRIME,
        "dodecic_modulus": MODULUS,
        "operator_modulus": OPERATOR_MODULUS,
        "presentation": {
            "relations": "S^2=T^3=-I, (ST)^5=I",
            "S_permutation": list(involution),
            "T_permutation": list(cubic),
            "S_mod_1331": matrix_tuple(left),
            "T_mod_1331": matrix_tuple(right),
            "trace_ST_mod_1331": trace_five,
            "trace_polynomial": "u^2+u-1",
            "hensel_linear_ranks": presentation_ranks,
        },
        "normalized_invariant_dodecic_mod_1331": serialize_vector(invariant),
        "normalization": "coefficient of X^11 Y is exactly 1",
        "invariant_hensel_linear_ranks": invariant_lift_ranks,
        "first_correction_digit_from_F": serialize_vector(first_digit),
        "second_correction_digit_from_F": serialize_vector(second_digit),
        "prior_K_representative": serialize_vector(prior_k),
        "first_digit_minus_prior_K": serialize_vector(gauge_difference),
        "first_digit_matches_prior_class_modulo": (
            "span{X^12,X^11Y,XY^11,Y^12}=V^(1) tensor V"
        ),
        "corrected_operator_mod_121": operator,
        "operator_formula": (
            "P_F + 240^(-1) * ((-,(I-F)/11)_3) modulo 121"
        ),
        "operator_is_A5_equivariant_mod_121": True,
        "marked_four_actions_mod_121": four_actions,
        "source_four_chart_mod_121": source_chart,
        "target_four_chart_mod_121": target_chart,
        "source_chart_lift_rank_with_normalization": source_rank,
        "target_chart_lift_rank_with_normalization": target_rank,
        "source_chart_normalization_index": source_pivot,
        "target_chart_normalization_index": target_pivot,
        "marked_bridge_scalar_mod_121": comparison_scalar,
        "target_chart_rescaling_to_keep_scalar_5": (
            comparison_scalar * pow(5, -1, OPERATOR_MODULUS)
            % OPERATOR_MODULUS
        ),
        "marked_bridge_identity": (
            "corrected_operator * source_chart = scalar * target_chart mod 121"
        ),
        "all_order_hensel_gate": {
            "binary_group_order": 120,
            "prime_is_coprime_to_group_order": True,
            "presentation_constraint_count": 5,
            "presentation_jacobian_rank_mod_11": presentation_ranks[0],
            "normalized_invariant_unknown_count": 13,
            "normalized_invariant_rank_mod_11": invariant_lift_ranks[0],
            "interpretation": (
                "The presentation point is smooth and the normalized "
                "invariant line has a unit minor.  Together with exact "
                "Reynolds averaging (11 does not divide 120), this extends "
                "the compatible branch to all 11-adic orders."
            ),
        },
        "conclusion": (
            "The corrected mod-121 dodecic class extends to a normalized "
            "A5-invariant dodecic modulo 1331.  Its divided third "
            "transvectant is equivariant modulo 121, and the marked bridge "
            "lifts with the recorded unit scalar."
        ),
        "inputs": {
            str(path.relative_to(REPOSITORY)): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in inputs
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered, encoding="utf-8")
        print(f"wrote {OUTPUT.relative_to(REPOSITORY)}")
        return 0
    if not OUTPUT.is_file() or OUTPUT.read_text(encoding="utf-8") != rendered:
        raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
    print("C682 corrected bridge mod 11^3 certificate: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
