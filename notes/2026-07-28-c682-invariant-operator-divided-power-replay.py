#!/usr/bin/env python3
"""Independent replay of the C682 characteristic-11 operator bridge."""

from __future__ import annotations

import hashlib
import itertools
import json
import math
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
CERTIFICATE_PATH = Path(__file__).with_name(
    "2026-07-28-c682-invariant-operator-divided-power.json"
)
PRIME = 11


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def poly(records: list[dict[str, int]]) -> dict[tuple[int, int], int]:
    return {(record["x"], record["y"]): record["coefficient"] for record in records}


def clean(form: dict[tuple[int, int], int]) -> dict[tuple[int, int], int]:
    return {exponent: coefficient for exponent, coefficient in form.items() if coefficient}


def derivative(
    form: dict[tuple[int, int], int], x_order: int, y_order: int
) -> dict[tuple[int, int], int]:
    answer = {}
    for (x_degree, y_degree), coefficient in form.items():
        if x_degree >= x_order and y_degree >= y_order:
            answer[(x_degree - x_order, y_degree - y_order)] = (
                coefficient
                * math.prod(range(x_degree - x_order + 1, x_degree + 1))
                * math.prod(range(y_degree - y_order + 1, y_degree + 1))
            )
    return clean(answer)


def hasse(
    form: dict[tuple[int, int], int], x_order: int, y_order: int
) -> dict[tuple[int, int], int]:
    return clean(
        {
            (x_degree - x_order, y_degree - y_order): (
                coefficient
                * math.comb(x_degree, x_order)
                * math.comb(y_degree, y_order)
            )
            for (x_degree, y_degree), coefficient in form.items()
            if x_degree >= x_order and y_degree >= y_order
        }
    )


def product(
    left: dict[tuple[int, int], int],
    right: dict[tuple[int, int], int],
) -> dict[tuple[int, int], int]:
    answer: dict[tuple[int, int], int] = {}
    for (left_x, left_y), left_coefficient in left.items():
        for (right_x, right_y), right_coefficient in right.items():
            exponent = (left_x + right_x, left_y + right_y)
            answer[exponent] = answer.get(exponent, 0) + left_coefficient * right_coefficient
    return clean(answer)


def transvectant(
    form: dict[tuple[int, int], int],
    klein: dict[tuple[int, int], int],
) -> dict[tuple[int, int], int]:
    answer: dict[tuple[int, int], int] = {}
    for index in range(4):
        term = product(
            derivative(form, 3 - index, index),
            derivative(klein, index, 3 - index),
        )
        scale = (-1) ** index * math.comb(3, index)
        for exponent, coefficient in term.items():
            answer[exponent] = answer.get(exponent, 0) + scale * coefficient
    return clean(answer)


def mod(form: dict[tuple[int, int], int]) -> dict[tuple[int, int], int]:
    return clean({exponent: coefficient % PRIME for exponent, coefficient in form.items()})


def bockstein_operator(
    form: dict[tuple[int, int], int],
    terms: list[dict[str, object]],
) -> dict[tuple[int, int], int]:
    answer: dict[tuple[int, int], int] = {}
    for term in terms:
        orders = term["f_hasse_orders"]
        summand = product(hasse(form, orders[0], orders[1]), poly(term["B_polynomial"]))
        for exponent, coefficient in summand.items():
            answer[exponent] = (
                answer.get(exponent, 0)
                + term["coefficient_mod_11"] * coefficient
            )
    return mod(answer)


def rref(matrix: list[list[int]]) -> tuple[list[list[int]], list[int]]:
    data = [[value % PRIME for value in row] for row in matrix]
    pivots = []
    pivot_row = 0
    for column in range(len(data[0]) if data else 0):
        candidate = next(
            (row for row in range(pivot_row, len(data)) if data[row][column]),
            None,
        )
        if candidate is None:
            continue
        data[pivot_row], data[candidate] = data[candidate], data[pivot_row]
        scale = pow(data[pivot_row][column], -1, PRIME)
        data[pivot_row] = [scale * value % PRIME for value in data[pivot_row]]
        for row in range(len(data)):
            if row != pivot_row and data[row][column]:
                factor = data[row][column]
                data[row] = [
                    (value - factor * pivot) % PRIME
                    for value, pivot in zip(data[row], data[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(data):
            break
    return data, pivots


def rank(matrix: list[list[int]]) -> int:
    return len(rref(matrix)[1])


def nullity(matrix: list[list[int]]) -> int:
    return (len(matrix[0]) if matrix else 0) - rank(matrix)


def matrix_product(
    left: list[list[int]], right: list[list[int]]
) -> list[list[int]]:
    return [
        [
            sum(a * b for a, b in zip(row, column)) % PRIME
            for column in zip(*right)
        ]
        for row in left
    ]


def inverse_2x2_mod(
    entries: list[int], modulus: int
) -> tuple[int, int, int, int]:
    a, b, c, d = entries
    scale = pow((a * d - b * c) % modulus, -1, modulus)
    return (
        d * scale % modulus,
        -b * scale % modulus,
        -c * scale % modulus,
        a * scale % modulus,
    )


def symmetric_action(
    entries: list[int], degree: int, determinant_twist: int
) -> list[list[int]]:
    return symmetric_action_mod(entries, degree, determinant_twist, PRIME)


def symmetric_action_mod(
    entries: list[int], degree: int, determinant_twist: int, modulus: int
) -> list[list[int]]:
    a, b, c, d = inverse_2x2_mod(entries, modulus)
    determinant = (entries[0] * entries[3] - entries[1] * entries[2]) % modulus
    scale = pow(determinant, determinant_twist, modulus)
    matrix = [[0] * (degree + 1) for _ in range(degree + 1)]
    for column in range(degree + 1):
        for left_y in range(degree - column + 1):
            for right_y in range(column + 1):
                row = left_y + right_y
                matrix[row][column] = (
                    matrix[row][column]
                    + scale
                    * math.comb(degree - column, left_y)
                    * pow(a, degree - column - left_y, modulus)
                    * pow(b, left_y, modulus)
                    * math.comb(column, right_y)
                    * pow(c, column - right_y, modulus)
                    * pow(d, right_y, modulus)
                ) % modulus
    return matrix


def permutation_matrix(permutation: list[int]) -> list[list[int]]:
    return [
        [int(row == permutation[column]) for column in range(len(permutation))]
        for row in range(len(permutation))
    ]


def hom_equations(
    left_actions: list[list[list[int]]],
    right_actions: list[list[list[int]]],
) -> list[list[int]]:
    rows = len(left_actions[0])
    columns = len(right_actions[0])
    equations = []
    for left, right in zip(left_actions, right_actions):
        for row in range(rows):
            for column in range(columns):
                equation = [0] * (rows * columns)
                for middle in range(rows):
                    equation[middle * columns + column] += left[row][middle]
                for middle in range(columns):
                    equation[row * columns + middle] -= right[middle][column]
                equations.append([value % PRIME for value in equation])
    return equations


def difference(
    left: list[list[int]], right: list[list[int]]
) -> list[list[int]]:
    return [
        [
            (left[row][column] - right[row][column]) % PRIME
            for column in range(len(left[0]))
        ]
        for row in range(len(left))
    ]


def horizontal_join(
    left: list[list[int]], right: list[list[int]]
) -> list[list[int]]:
    return [left_row + right_row for left_row, right_row in zip(left, right)]


def main() -> int:
    certificate = json.loads(CERTIFICATE_PATH.read_text(encoding="utf-8"))
    assert certificate["schema"] == "clebsch-invariant-operator-divided-power-v1"
    klein = poly(certificate["klein_dodecic"])
    terms = certificate["bockstein_hasse_terms"]
    for index, term in enumerate(terms):
        divided = hasse(klein, index, 3 - index)
        assert all(coefficient % PRIME == 0 for coefficient in divided.values())
        expected = mod(
            {exponent: coefficient // PRIME for exponent, coefficient in divided.items()}
        )
        assert poly(term["B_polynomial"]) == expected
        assert term["coefficient_mod_11"] == (
            (-1) ** index
            * math.factorial(index)
            * math.factorial(3 - index)
            * pow(2, -1, PRIME)
        ) % PRIME
        assert not mod(derivative(klein, index, 3 - index))

    tested = 0
    for degree in range(certificate["monomial_identity_test_max_degree"] + 1):
        for y_degree in range(degree + 1):
            form = {(degree - y_degree, y_degree): 1}
            raw = transvectant(form, klein)
            assert all(coefficient % PRIME == 0 for coefficient in raw.values())
            divided = mod(
                {
                    exponent: coefficient // PRIME * pow(12, -1, PRIME)
                    for exponent, coefficient in raw.items()
                }
            )
            assert bockstein_operator(form, terms) == divided
            tested += 1
    assert tested == certificate["monomial_identity_test_count"]

    raw_matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        image = transvectant({(6 - column, column): 1}, klein)
        for row in range(13):
            raw_matrix[row][column] = image.get((12 - row, row), 0)
    content = math.gcd(*[abs(value) for row in raw_matrix for value in row])
    assert content == certificate["sym6_raw_transvectant_content"] == 2640
    primitive = [[value // content for value in row] for row in raw_matrix]
    assert primitive == certificate["sym6_primitive_matrix"]
    primitive_mod = [[value % PRIME for value in row] for row in primitive]
    assert rank(primitive_mod) == certificate["sym6_primitive_matrix_rank_mod_11"] == 4

    matrices = certificate["a5_pgl2_generators"]
    pair_actions = [
        permutation_matrix(permutation)
        for permutation in certificate["a5_pair_permutations"]
    ]
    source_actions = [symmetric_action(matrix, 6, 3) for matrix in matrices]
    target_actions = [symmetric_action(matrix, 12, 1) for matrix in matrices]
    assert nullity(hom_equations(source_actions, pair_actions)) == 1
    assert nullity(hom_equations(target_actions, pair_actions)) == 3
    source = certificate["pair_to_sym6_intertwiner"]
    transported = certificate["primitive_transvectant_pair_to_sym12"]
    equivariant_target = certificate["equivariant_pair_to_sym12_four_intertwiner"]
    assert matrix_product(primitive_mod, source) == transported
    assert rank(source) == rank(transported) == rank(equivariant_target) == 4
    for source_action, target_action, pair_action in zip(
        source_actions, target_actions, pair_actions
    ):
        assert matrix_product(source_action, source) == matrix_product(source, pair_action)
        assert matrix_product(target_action, equivariant_target) == matrix_product(
            equivariant_target, pair_action
        )
    defects = []
    lift_obstructions = []
    f_vector = [klein.get((12 - row, row), 0) for row in range(13)]
    for generator, (matrix, source_action, target_action, pair_action) in enumerate(
        zip(matrices, source_actions, target_actions, pair_actions)
    ):
        moved = matrix_product(target_action, transported)
        defect = difference(moved, matrix_product(transported, pair_action))
        first = next(
            {
                "row": row,
                "column": column,
                "value": defect[row][column],
            }
            for row in range(13)
            for column in range(10)
            if defect[row][column]
        )
        defects.append(
            {
                "generator": generator,
                "rank": rank(defect),
                "first_nonzero_entry": first,
                "image_closure_rank": rank(horizontal_join(transported, moved)),
            }
        )
        lifted_target = symmetric_action_mod(matrix, 12, 1, PRIME**2)
        transformed_f = [
            sum(
                lifted_target[row][column] * f_vector[column]
                for column in range(13)
            )
            % (PRIME**2)
            for row in range(13)
        ]
        lift_difference = [
            (transformed_f[row] - f_vector[row]) % (PRIME**2)
            for row in range(13)
        ]
        assert all(value % PRIME == 0 for value in lift_difference)
        lift_poly = clean(
            {
                (12 - row, row): value // PRIME
                for row, value in enumerate(lift_difference)
            }
        )
        rho_action = symmetric_action(matrix, 6, 0)
        correction = [[0] * 7 for _ in range(13)]
        determinant = (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % PRIME
        scale = 5 * pow(determinant, 3, PRIME) * pow(12, -1, PRIME) % PRIME
        for column in range(7):
            rho_form = clean(
                {
                    (6 - row, row): rho_action[row][column]
                    for row in range(7)
                }
            )
            image = transvectant(rho_form, lift_poly)
            for row in range(13):
                correction[row][column] = (
                    scale * image.get((12 - row, row), 0)
                ) % PRIME
        full_defect = difference(
            matrix_product(target_action, primitive_mod),
            matrix_product(primitive_mod, source_action),
        )
        assert correction == full_defect
        assert matrix_product(correction, source) == defect
        lift_obstructions.append(
            {
                "generator": generator,
                "F_lift_defect": [
                    {"x": x, "y": y, "coefficient": coefficient}
                    for (x, y), coefficient in sorted(lift_poly.items(), reverse=True)
                ],
                "F_lift_defect_rank_contribution": rank(correction),
                "defect_identity_verified": True,
            }
        )
    assert defects == certificate["a5_equivariance_defects"]
    assert lift_obstructions == certificate["mod_121_lift_obstructions"]
    union_rank = rank(horizontal_join(transported, equivariant_target))
    assert union_rank == certificate["primitive_image_vs_equivariant_image_union_rank"]
    assert 8 - union_rank == certificate[
        "primitive_image_vs_equivariant_image_intersection_dimension"
    ]

    for relative, record in certificate["inputs"].items():
        path = REPOSITORY / relative
        assert path.stat().st_size == record["bytes"]
        assert sha256(path) == record["sha256"]
    c651_path = REPOSITORY / "notes" / "2026-07-26-c651-hitchin-tensor-bridge.json"
    c651 = json.loads(c651_path.read_text(encoding="utf-8"))
    assert c651["clebsch_restriction_scalar"] == certificate[
        "c651_clebsch_restriction_scalar"
    ] == 4
    print("C682 divided-power bridge independent replay: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
