#!/usr/bin/env python3
"""Exact C654 certificate for the Klein multiplicity relative position."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
import math
from collections import deque
from fractions import Fraction as Q
from pathlib import Path


OUTPUT = Path(__file__).with_suffix(".json")
DEGREE = 12
GENERATORS = (
    bytes((1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 11)),
    bytes((8, 2, 1, 7, 5, 4, 6, 3, 0, 9, 10, 11)),
)


def compose(left: bytes, right: bytes) -> bytes:
    return bytes(left[right[i]] for i in range(DEGREE))


def inverse(permutation: bytes) -> bytes:
    result = bytearray(DEGREE)
    for old, new in enumerate(permutation):
        result[new] = old
    return bytes(result)


def conjugate(element: bytes, by: bytes) -> bytes:
    return compose(by, compose(element, inverse(by)))


def generated_group(generators: tuple[bytes, ...], limit: int = 661) -> frozenset[bytes]:
    identity = bytes(range(DEGREE))
    group = {identity}
    queue = deque((identity,))
    while queue and len(group) <= limit:
        current = queue.popleft()
        for generator in generators:
            target = compose(generator, current)
            if target not in group:
                group.add(target)
                queue.append(target)
    return frozenset(group)


def element_order(element: bytes) -> int:
    identity = bytes(range(DEGREE))
    power = identity
    for order in range(1, 13):
        power = compose(element, power)
        if power == identity:
            return order
    raise AssertionError("unexpected element order")


def transpose(matrix: list[list[Q]]) -> list[list[Q]]:
    return [list(row) for row in zip(*matrix)]


def matrix_add(left: list[list[Q]], right: list[list[Q]]) -> list[list[Q]]:
    return [
        [left[i][j] + right[i][j] for j in range(len(left[0]))]
        for i in range(len(left))
    ]


def matrix_scale(scalar: Q, matrix: list[list[Q]]) -> list[list[Q]]:
    return [[scalar * value for value in row] for row in matrix]


def matrix_multiply(left: list[list[Q]], right: list[list[Q]]) -> list[list[Q]]:
    return [
        [
            sum((left[i][k] * right[k][j] for k in range(len(right))), Q(0))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def identity_matrix(size: int) -> list[list[Q]]:
    return [[Q(i == j) for j in range(size)] for i in range(size)]


def rref(matrix: list[list[Q]]) -> tuple[list[list[Q]], list[int]]:
    result = [row[:] for row in matrix]
    row_count = len(result)
    column_count = len(result[0])
    pivots: list[int] = []
    pivot_row = 0
    for column in range(column_count):
        witness = next(
            (row for row in range(pivot_row, row_count) if result[row][column]),
            None,
        )
        if witness is None:
            continue
        result[pivot_row], result[witness] = result[witness], result[pivot_row]
        scale = result[pivot_row][column]
        result[pivot_row] = [value / scale for value in result[pivot_row]]
        for row in range(row_count):
            if row != pivot_row and result[row][column]:
                scale = result[row][column]
                result[row] = [
                    result[row][j] - scale * result[pivot_row][j]
                    for j in range(column_count)
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == row_count:
            break
    return result, pivots


def nullspace(matrix: list[list[Q]]) -> list[list[Q]]:
    reduced, pivots = rref(matrix)
    free = [column for column in range(len(matrix[0])) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [Q(0)] * len(matrix[0])
        vector[free_column] = Q(1)
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row][free_column]
        basis.append(vector)
    return basis


def determinant(matrix: list[list[Q]]) -> Q:
    reduced = [row[:] for row in matrix]
    result = Q(1)
    for column in range(len(reduced)):
        pivot = next(
            (row for row in range(column, len(reduced)) if reduced[row][column]),
            None,
        )
        if pivot is None:
            return Q(0)
        if pivot != column:
            reduced[column], reduced[pivot] = reduced[pivot], reduced[column]
            result *= -1
        diagonal = reduced[column][column]
        result *= diagonal
        for row in range(column + 1, len(reduced)):
            factor = reduced[row][column] / diagonal
            reduced[row] = [
                reduced[row][j] - factor * reduced[column][j]
                for j in range(len(reduced))
            ]
    return result


def fraction_text(value: Q) -> str:
    return (
        str(value.numerator)
        if value.denominator == 1
        else f"{value.numerator}/{value.denominator}"
    )


def matrix_data(matrix: list[list[Q]]) -> list[list[str]]:
    return [[fraction_text(value) for value in row] for row in matrix]


def flatten(matrix: list[list[Q]]) -> list[Q]:
    return [value for row in matrix for value in row]


def unflatten(vector: list[Q], size: int = 10) -> list[list[Q]]:
    return [
        [vector[size * row + column] for column in range(size)]
        for row in range(size)
    ]


def coordinates(matrix: list[list[Q]], basis: list[list[list[Q]]]) -> list[Q]:
    columns = [flatten(element) for element in basis]
    target = flatten(matrix)
    augmented = [
        [columns[column][row] for column in range(len(columns))] + [target[row]]
        for row in range(len(target))
    ]
    reduced, pivots = rref(augmented)
    result = [Q(0)] * len(columns)
    for row, pivot in enumerate(pivots):
        if pivot < len(columns):
            result[pivot] = reduced[row][-1]
    assert all(
        sum(columns[column][row] * result[column] for column in range(len(columns)))
        == target[row]
        for row in range(len(target))
    )
    return result


def characteristic_polynomial_4(matrix: list[list[Q]]) -> list[Q]:
    def add(left: list[Q], right: list[Q]) -> list[Q]:
        result = [Q(0)] * max(len(left), len(right))
        for index, value in enumerate(left):
            result[index] += value
        for index, value in enumerate(right):
            result[index] += value
        return result

    def multiply(left: list[Q], right: list[Q]) -> list[Q]:
        result = [Q(0)] * (len(left) + len(right) - 1)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                result[i + j] += a * b
        return result

    result = [Q(0)]
    for permutation in itertools.permutations(range(4)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(4)
            for j in range(i + 1, 4)
        )
        term = [Q(-1 if inversions % 2 else 1)]
        for row, column in enumerate(permutation):
            factor = (
                [-matrix[row][column], Q(1)]
                if row == column
                else [-matrix[row][column]]
            )
            term = multiply(term, factor)
        result = add(result, term)
    return result


def build_certificate() -> dict[str, object]:
    group = sorted(generated_group(GENERATORS))
    assert len(group) == 660
    involutions = sorted(g for g in group if element_order(g) == 2)
    assert len(involutions) == 55
    involution_index = {element: index for index, element in enumerate(involutions)}

    commuting_adjacency = [
        [
            int(i != j and element_order(compose(left, right)) == 2)
            for j, right in enumerate(involutions)
        ]
        for i, left in enumerate(involutions)
    ]
    carrier_equations = [
        [
            Q(commuting_adjacency[i][j] + (3 if i == j else 0))
            for j in range(55)
        ]
        for i in range(55)
    ]
    carrier_columns = nullspace(carrier_equations)
    assert len(carrier_columns) == 10
    assert all(value.denominator == 1 for column in carrier_columns for value in column)
    carrier_matrix = transpose(carrier_columns)
    free_rows = [
        row
        for row in range(55)
        if sum(int(carrier_columns[column][row] == 1) for column in range(10)) == 1
        and sum(int(carrier_columns[column][row] != 0) for column in range(10)) == 1
    ]
    assert len(free_rows) == 10

    def representation(element: bytes) -> list[list[Q]]:
        permutation = [
            involution_index[conjugate(involution, element)]
            for involution in involutions
        ]
        image_columns = []
        for column in carrier_columns:
            image = [Q(0)] * 55
            for old, new in enumerate(permutation):
                image[new] = column[old]
            image_columns.append([image[row] for row in free_rows])
        result = transpose(image_columns)
        assert matrix_multiply(carrier_matrix, result) == [
            [
                carrier_matrix[permutation.index(row)][column]
                for column in range(10)
            ]
            for row in range(55)
        ]
        return result

    representations = {element: representation(element) for element in group}
    gram = matrix_multiply(carrier_columns, carrier_matrix)
    assert all(
        matrix_multiply(
            transpose(representations[generator]),
            matrix_multiply(gram, representations[generator]),
        )
        == gram
        for generator in GENERATORS
    )

    order_two = [g for g in group if element_order(g) == 2]
    order_three = [g for g in group if element_order(g) == 3]
    subgroups: dict[tuple[bytes, ...], tuple[frozenset[bytes], tuple[bytes, bytes]]] = {}
    for a in order_two:
        for b in order_three:
            if element_order(compose(a, b)) != 5:
                continue
            subgroup = generated_group((a, b), 60)
            if len(subgroup) == 60:
                subgroups.setdefault(tuple(sorted(subgroup)), (subgroup, (a, b)))
    assert len(subgroups) == 22

    plus, plus_generators = next(
        value for value in subgroups.values() if all(element[0] == 0 for element in value[0])
    )
    minus, minus_generators = next(
        value
        for value in subgroups.values()
        if not any(all(element[point] == point for element in value[0]) for point in range(11))
    )
    assert len(plus & minus) == 10
    assert len(generated_group(tuple(plus | minus))) == 660

    def commutant_basis(generators: tuple[bytes, ...]) -> list[list[list[Q]]]:
        equations: list[list[Q]] = []
        for generator in generators:
            action = representations[generator]
            for row in range(10):
                for column in range(10):
                    equation = [Q(0)] * 100
                    for middle in range(10):
                        equation[10 * row + middle] += action[middle][column]
                        equation[10 * middle + column] -= action[row][middle]
                    equations.append(equation)
        return [unflatten(vector) for vector in nullspace(equations)]

    commutant_plus = commutant_basis(plus_generators)
    commutant_minus = commutant_basis(minus_generators)
    common_commutant = commutant_basis(GENERATORS)
    assert len(commutant_plus) == len(commutant_minus) == 4
    assert len(common_commutant) == 2

    identity = identity_matrix(10)

    def split_idempotent(commutant: list[list[list[Q]]]) -> list[list[Q]]:
        for coefficients in itertools.product(range(-2, 3), repeat=4):
            if not any(coefficients):
                continue
            element = [[Q(0)] * 10 for _ in range(10)]
            for coefficient, basis_element in zip(coefficients, commutant):
                element = matrix_add(
                    element, matrix_scale(Q(coefficient), basis_element)
                )
            if len(rref([flatten(identity), flatten(element)])[1]) != 2:
                continue
            square = matrix_multiply(element, element)
            try:
                scalar, linear = coordinates(square, [identity, element])
            except AssertionError:
                continue
            discriminant = linear * linear + 4 * scalar
            if discriminant <= 0:
                continue
            numerator_root = math.isqrt(discriminant.numerator)
            denominator_root = math.isqrt(discriminant.denominator)
            if (
                numerator_root**2 != discriminant.numerator
                or denominator_root**2 != discriminant.denominator
            ):
                continue
            root = Q(numerator_root, denominator_root)
            first_root = (linear + root) / 2
            second_root = (linear - root) / 2
            idempotent = matrix_scale(
                Q(1, 1) / (first_root - second_root),
                matrix_add(element, matrix_scale(-second_root, identity)),
            )
            if matrix_multiply(idempotent, idempotent) != idempotent:
                continue
            if len(rref(idempotent)[1]) == 5:
                return idempotent
        raise AssertionError("no rational rank-five idempotent found")

    plus_idempotent = split_idempotent(commutant_plus)
    minus_idempotent = split_idempotent(commutant_minus)

    non_scalar = next(
        element
        for element in common_commutant
        if any(
            element[i][j] != (element[0][0] if i == j else 0)
            for i in range(10)
            for j in range(10)
        )
    )
    trace = sum(non_scalar[i][i] for i in range(10))
    centered = matrix_add(non_scalar, matrix_scale(-trace / 10, identity))
    centered_square = matrix_multiply(centered, centered)
    square_scalar = centered_square[0][0]
    assert square_scalar < 0
    assert centered_square == matrix_scale(square_scalar, identity)
    scale_square = Q(-11) / square_scalar
    numerator_root = int(scale_square.numerator**0.5)
    denominator_root = int(scale_square.denominator**0.5)
    assert numerator_root**2 == scale_square.numerator
    assert denominator_root**2 == scale_square.denominator
    cm_operator = matrix_scale(Q(numerator_root, denominator_root), centered)
    assert matrix_multiply(cm_operator, cm_operator) == matrix_scale(Q(-11), identity)
    assert matrix_add(
        matrix_multiply(gram, cm_operator),
        transpose(matrix_multiply(gram, cm_operator)),
    ) == [[Q(0)] * 10 for _ in range(10)]
    polarization = matrix_multiply(gram, cm_operator)
    assert determinant(polarization) != 0

    def reynolds(subgroup: frozenset[bytes], matrix: list[list[Q]]) -> list[list[Q]]:
        result = [[Q(0)] * 10 for _ in range(10)]
        for element in subgroup:
            result = matrix_add(
                result,
                matrix_multiply(
                    matrix_multiply(representations[element], matrix),
                    representations[inverse(element)],
                ),
            )
        return matrix_scale(Q(1, len(subgroup)), result)

    mixed_columns = [
        coordinates(reynolds(plus, reynolds(minus, element)), commutant_plus)
        for element in commutant_plus
    ]
    mixed = transpose(mixed_columns)
    characteristic = characteristic_polynomial_4(mixed)
    expected = [Q(1, 144), Q(-13, 72), Q(193, 144), Q(-13, 6), Q(1)]
    assert characteristic == expected
    assert characteristic == characteristic_polynomial_4(transpose(mixed))

    matrix_payload = {
        "group_generators": [list(generator) for generator in GENERATORS],
        "representation_generators": [matrix_data(representations[g]) for g in GENERATORS],
        "gram": matrix_data(gram),
        "polarization": matrix_data(polarization),
        "cm_operator": matrix_data(cm_operator),
        "A5_plus_generators": [list(g) for g in plus_generators],
        "A5_minus_generators": [list(g) for g in minus_generators],
        "A5_plus_rank_five_idempotent": matrix_data(plus_idempotent),
        "A5_minus_rank_five_idempotent": matrix_data(minus_idempotent),
        "mixed_operator": matrix_data(mixed),
    }
    payload_bytes = json.dumps(
        matrix_payload, sort_keys=True, separators=(",", ":")
    ).encode()
    return {
        "schema": "c654-klein-relative-position-v1",
        "construction": {
            "ambient": "conjugation action on the 55 involutions of PSL(2,11)",
            "carrier": "the -3 eigenspace of the commuting-involution adjacency",
            "dimension": 10,
            "carrier_integral_basis": True,
            "group_order": len(group),
            "involution_count": len(involutions),
            "A5_subgroup_count": len(subgroups),
            "A5_classes": {
                "plus_degree_11_orbits": [1, 10],
                "minus_degree_11_orbits": [5, 6],
                "intersection_order": len(plus & minus),
                "generated_join_order": len(generated_group(tuple(plus | minus))),
            },
        },
        "commutants": {
            "plus_dimension": len(commutant_plus),
            "minus_dimension": len(commutant_minus),
            "plus_is_M2_Q": True,
            "minus_is_M2_Q": True,
            "split_witness": "a rational rank-five idempotent in each four-dimensional semisimple commutant",
            "intersection_dimension": len(common_commutant),
            "cm_minimal_polynomial": "x^2+11",
            "intersection_field": "Q(sqrt(-11))",
            "polarization_is_nondegenerate_alternating": True,
        },
        "relative_position": {
            "definition": "P_plus P_minus P_plus on End_A5plus(V), with P_H the Reynolds projector",
            "matrix": matrix_data(mixed),
            "characteristic_polynomial_low_to_high": [
                fraction_text(value) for value in characteristic
            ],
            "factorization": "(x-1)^2*(x-1/12)^2",
            "spectrum": {"1": 2, "1/12": 2},
            "nontrivial_factor_discriminant": "0",
            "discriminant_five": False,
        },
        "matrix_payload": matrix_payload,
        "matrix_payload_sha256": hashlib.sha256(payload_bytes).hexdigest(),
        "scope": {
            "positive": "exact rational representation, invariant symmetric form and alternating polarization, two A5 commutants, common CM field, and Reynolds mixed spectrum",
            "negative": "this canonical first-order commutant-angle invariant has no discriminant-five lift",
            "not_claimed": "nonexistence of every higher-order or cycle-level discriminant-five invariant",
        },
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(build_certificate())
    if args.check:
        assert OUTPUT.read_bytes() == generated
        print(f"OK {OUTPUT.name} {hashlib.sha256(generated).hexdigest()}")
    else:
        OUTPUT.write_bytes(generated)
        print(f"WROTE {OUTPUT.name} {hashlib.sha256(generated).hexdigest()}")


if __name__ == "__main__":
    main()
