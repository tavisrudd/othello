#!/usr/bin/env python3
"""Exact checks for the C682 transvectant-isotropic Fano ladder."""

from __future__ import annotations

from fractions import Fraction
from math import comb, factorial, gcd


def falling(n: int, r: int) -> int:
    if r < 0 or r > n:
        return 0
    return factorial(n) // factorial(n - r)


def transvectant(
    left: list[int | Fraction],
    right: list[int | Fraction],
    order: int,
) -> list[Fraction]:
    """Ordinary-derivative transvectant in the monomial bases."""
    left_degree = len(left) - 1
    right_degree = len(right) - 1
    output = [
        Fraction(0)
        for _ in range(left_degree + right_degree - 2 * order + 1)
    ]
    for i, left_coefficient in enumerate(left):
        for j, right_coefficient in enumerate(right):
            for a in range(order + 1):
                coefficient = (
                    (-1) ** a
                    * comb(order, a)
                    * falling(left_degree - i, order - a)
                    * falling(i, a)
                    * falling(right_degree - j, a)
                    * falling(j, order - a)
                )
                output_index = i + j - order
                if 0 <= output_index < len(output):
                    output[output_index] += (
                        left_coefficient * right_coefficient * coefficient
                    )
    return output


def rref(
    matrix: list[list[int | Fraction]],
) -> tuple[int, list[int], list[list[Fraction]]]:
    rows = [[Fraction(entry) for entry in row] for row in matrix]
    row_count = len(rows)
    column_count = len(rows[0]) if rows else 0
    pivot_columns: list[int] = []
    pivot_row = 0
    for column in range(column_count):
        nonzero_row = next(
            (
                row
                for row in range(pivot_row, row_count)
                if rows[row][column] != 0
            ),
            None,
        )
        if nonzero_row is None:
            continue
        rows[pivot_row], rows[nonzero_row] = (
            rows[nonzero_row],
            rows[pivot_row],
        )
        pivot = rows[pivot_row][column]
        rows[pivot_row] = [entry / pivot for entry in rows[pivot_row]]
        for row in range(row_count):
            if row == pivot_row or rows[row][column] == 0:
                continue
            multiplier = rows[row][column]
            rows[row] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(rows[row], rows[pivot_row])
            ]
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == row_count:
            break

    free_columns = [
        column
        for column in range(column_count)
        if column not in pivot_columns
    ]
    kernel: list[list[Fraction]] = []
    for free_column in free_columns:
        vector = [Fraction(0) for _ in range(column_count)]
        vector[free_column] = 1
        for row, column in reversed(list(enumerate(pivot_columns))):
            vector[column] = -sum(
                rows[row][other_column] * vector[other_column]
                for other_column in free_columns
            )
        kernel.append(vector)
    return len(pivot_columns), pivot_columns, kernel


def primitive(vector: list[Fraction]) -> list[int]:
    denominator = 1
    for entry in vector:
        denominator = (
            denominator * entry.denominator
            // gcd(denominator, entry.denominator)
        )
    values = [int(entry * denominator) for entry in vector]
    divisor = 0
    for value in values:
        divisor = gcd(divisor, abs(value))
    if divisor:
        values = [value // divisor for value in values]
    first = next((value for value in values if value), 1)
    if first < 0:
        values = [-value for value in values]
    return values


def operator_matrix(
    form: list[int],
    domain_degree: int,
    order: int,
) -> list[list[Fraction]]:
    columns: list[list[Fraction]] = []
    for index in range(domain_degree + 1):
        basis_vector = [0 for _ in range(domain_degree + 1)]
        basis_vector[index] = 1
        columns.append(transvectant(basis_vector, form, order))
    return [list(row) for row in zip(*columns)]


def annihilator_rank(
    plane: list[list[Fraction]],
    form_degree: int,
    order: int,
) -> int:
    equations: list[list[Fraction]] = []
    values_by_plane_vector: list[list[list[Fraction]]] = []
    for plane_vector in plane:
        values: list[list[Fraction]] = []
        for form_index in range(form_degree + 1):
            basis_form = [0 for _ in range(form_degree + 1)]
            basis_form[form_index] = 1
            values.append(transvectant(plane_vector, basis_form, order))
        values_by_plane_vector.append(values)
    output_dimension = len(values_by_plane_vector[0][0])
    for values in values_by_plane_vector:
        for output_index in range(output_dimension):
            equations.append(
                [
                    values[form_index][output_index]
                    for form_index in range(form_degree + 1)
                ]
            )
    return rref(equations)[0]


def monomial_pairing_coefficient(
    degree: int,
    left_index: int,
    right_index: int,
    order: int,
) -> int:
    return sum(
        (-1) ** a
        * comb(order, a)
        * falling(degree - left_index, order - a)
        * falling(left_index, a)
        * falling(degree - right_index, a)
        * falling(right_index, order - a)
        for a in range(order + 1)
    )


def borel_tangent_dimension(degree: int, order: int) -> int:
    """Tangent dimension at <x^m,x^(m-1)y> in the rank-two zero locus."""
    output_degree = 2 * degree - 2 * order
    outside = list(range(2, degree + 1))
    columns = [(0, index) for index in outside] + [
        (1, index) for index in outside
    ]
    equations: list[list[int]] = []
    for output_index in range(output_degree + 1):
        row: list[int] = []
        for source, target in columns:
            if source == 0:
                coefficient = monomial_pairing_coefficient(
                    degree, target, 1, order
                )
                monomial_index = target + 1 - order
            else:
                coefficient = monomial_pairing_coefficient(
                    degree, 0, target, order
                )
                monomial_index = target - order
            row.append(
                coefficient if monomial_index == output_index else 0
            )
        equations.append(row)
    return len(columns) - rref(equations)[0]


def threefold_balance_solutions(limit: int = 40) -> list[tuple[int, int, int]]:
    solutions: list[tuple[int, int, int]] = []
    for degree in range(2, limit + 1):
        for order in range(1, degree + 1, 2):
            output_dimension = 2 * degree - 2 * order + 1
            for plane_dimension in range(2, degree + 1):
                grassmannian_dimension = plane_dimension * (
                    degree + 1 - plane_dimension
                )
                equation_count = (
                    plane_dimension
                    * (plane_dimension - 1)
                    // 2
                    * output_dimension
                )
                dimension = grassmannian_dimension - equation_count
                index = degree + 1 - (
                    plane_dimension - 1
                ) * output_dimension
                if dimension == 3 and index > 0:
                    solutions.append((degree, plane_dimension, order))
    return solutions


def main() -> None:
    # The octahedral sextic and the two boundary representatives of X_5.
    representatives = {
        "open": [0, 1, 0, 0, 0, -1, 0],
        "surface": [0, 1, 0, 0, 0, 0, 0],
        "closed_curve": [1, 0, 0, 0, 0, 0, 0],
    }
    v5_rows: dict[str, dict[str, object]] = {}
    for name, sextic in representatives.items():
        matrix = operator_matrix(sextic, domain_degree=4, order=2)
        operator_rank, _, kernel = rref(matrix)
        assert operator_rank == 3
        assert len(kernel) == 2
        assert transvectant(kernel[0], kernel[1], 3) == [Fraction(0)] * 3
        common_annihilator_rank = annihilator_rank(
            kernel, form_degree=6, order=2
        )
        assert common_annihilator_rank == 6
        v5_rows[name] = {
            "operator_rank": operator_rank,
            "kernel": [primitive(vector) for vector in kernel],
            "annihilator_rank": common_annihilator_rank,
        }

    # All positive-index, expected-three-dimensional single-transvectant
    # isotropic Grassmannian balances.
    balance = threefold_balance_solutions()
    assert balance == [
        (3, 2, 3),
        (4, 2, 3),
        (5, 2, 3),
        (6, 3, 5),
    ]

    # The rank-two series has dimension 2r-3 and index 2r-m.  Its unique
    # Borel-fixed point is transverse exactly for m=r and m=r+1.
    ladder_rows: list[tuple[int, int, int, int, int]] = []
    for order in range(3, 12, 2):
        expected_dimension = 2 * order - 3
        for degree in range(order, 2 * order):
            index = 2 * order - degree
            tangent_dimension = borel_tangent_dimension(degree, order)
            predicted_tangent_dimension = expected_dimension + max(
                0, degree - order - 1
            )
            assert tangent_dimension == predicted_tangent_dimension
            ladder_rows.append(
                (
                    order,
                    degree,
                    expected_dimension,
                    index,
                    tangent_dimension,
                )
            )

    print("PASS: V5 second-transvectant kernel/annihilator inverse rows")
    for name, row in v5_rows.items():
        print(name, row)
    print("PASS: positive-index threefold balances", balance)
    print(
        "PASS: rank-two ladder Borel tangents; "
        "transverse exactly at m=r,r+1"
    )
    for row in ladder_rows:
        print(
            "order=%d degree=%d expected_dim=%d index=%d borel_tangent=%d"
            % row
        )


if __name__ == "__main__":
    main()
