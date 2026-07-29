#!/usr/bin/env python3
"""Independent replay of the C682 target-side U_22 linear section."""

from __future__ import annotations

import hashlib
import itertools
import json
import math
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
RANK_CERTIFICATE = NOTES / "2026-07-28-c682-rank-four-resolvent.json"
TARGET_CERTIFICATE = NOTES / "2026-07-28-c682-u22-linear-section.json"
PRIME = 11
TRIPLES = list(itertools.combinations(range(7), 3))


def rank(matrix):
    work = [[value % PRIME for value in row] for row in matrix]
    row = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, PRIME)
        work[row] = [inverse * value % PRIME for value in work[row]]
        for index in range(len(work)):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                (left - scale * right) % PRIME
                for left, right in zip(work[index], work[row])
            ]
        row += 1
        if row == len(work):
            break
    return row


def nullspace(matrix):
    work = [[value % PRIME for value in row] for row in matrix]
    rows = len(work)
    columns = len(work[0]) if rows else 0
    pivot_columns = []
    row = 0
    for column in range(columns):
        pivot = next(
            (index for index in range(row, rows) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, PRIME)
        work[row] = [inverse * value % PRIME for value in work[row]]
        for index in range(rows):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                (left - scale * right) % PRIME
                for left, right in zip(work[index], work[row])
            ]
        pivot_columns.append(column)
        row += 1
    free_columns = [
        column for column in range(columns) if column not in pivot_columns
    ]
    basis = []
    for free in free_columns:
        vector = [0] * columns
        vector[free] = 1
        for pivot_row in range(len(pivot_columns) - 1, -1, -1):
            pivot = pivot_columns[pivot_row]
            vector[pivot] = (
                -sum(
                    work[pivot_row][column] * vector[column]
                    for column in free_columns
                )
            ) % PRIME
        basis.append(vector)
    return basis


def determinant3(matrix):
    return (
        matrix[0][0]
        * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1]
        * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2]
        * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % PRIME


def plucker(plane):
    return [
        determinant3(
            [[plane[row][column] for column in columns] for row in range(3)]
        )
        for columns in TRIPLES
    ]


def normalize(vector):
    pivot = next(value for value in vector if value % PRIME)
    inverse = pow(pivot, -1, PRIME)
    return [value * inverse % PRIME for value in vector]


def falling(value, order):
    answer = 1
    for offset in range(order):
        answer *= value - offset
    return answer


def fifth_coefficient(left_y, right_y, output_y):
    value = 0
    for index in range(6):
        if left_y - index + right_y - (5 - index) != output_y:
            continue
        value += (
            (-1) ** index
            * math.comb(5, index)
            * falling(6 - left_y, 5 - index)
            * falling(left_y, index)
            * falling(6 - right_y, index)
            * falling(right_y, 5 - index)
        )
    return value % PRIME


def fifth_forms():
    return [
        [
            [
                fifth_coefficient(left, right, output)
                for right in range(7)
            ]
            for left in range(7)
        ]
        for output in range(3)
    ]


def contraction_equations(forms):
    return [
        [
            (
                form[left][middle] * int(output == right)
                - form[left][right] * int(output == middle)
                + form[middle][right] * int(output == left)
            )
            % PRIME
            for left, middle, right in TRIPLES
        ]
        for form in forms
        for output in range(7)
    ]


def row_basis(rows):
    basis = []
    for row in rows:
        if rank(basis + [row]) > len(basis):
            basis.append(row)
    return basis


def reduced_row_basis(matrix):
    work = [[value % PRIME for value in row] for row in matrix]
    pivot_columns = []
    row = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next(
            (index for index in range(row, len(work)) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, PRIME)
        work[row] = [inverse * value % PRIME for value in work[row]]
        for index in range(len(work)):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                (left - scale * right) % PRIME
                for left, right in zip(work[index], work[row])
            ]
        pivot_columns.append(column)
        row += 1
        if row == len(work):
            break
    return [work[index] for index in range(row)], pivot_columns


def wedge_sign(indices):
    if len(set(indices)) < len(indices):
        return 0, None
    inversions = sum(
        indices[left] > indices[right]
        for left in range(len(indices))
        for right in range(left + 1, len(indices))
    )
    return (-1 if inversions % 2 else 1), tuple(sorted(indices))


def plucker_quadrics_on_section(section_basis):
    triple_index = {triple: index for index, triple in enumerate(TRIPLES)}
    monomials = list(itertools.combinations_with_replacement(range(11), 2))
    monomial_index = {
        monomial: index for index, monomial in enumerate(monomials)
    }
    rows = []
    for pair in itertools.combinations(range(7), 2):
        for quadruple in itertools.combinations(range(7), 4):
            relation = [0] * len(monomials)
            for position, moving in enumerate(quadruple):
                sign, first = wedge_sign(pair + (moving,))
                if not sign:
                    continue
                second = tuple(index for index in quadruple if index != moving)
                coefficient = (-1) ** position * sign
                for left in range(11):
                    for right in range(11):
                        monomial = tuple(sorted((left, right)))
                        relation[monomial_index[monomial]] = (
                            relation[monomial_index[monomial]]
                            + coefficient
                            * section_basis[left][triple_index[first]]
                            * section_basis[right][triple_index[second]]
                        ) % PRIME
            if any(relation):
                rows.append(relation)
    basis, pivots = reduced_row_basis(rows)
    return rows, monomials, basis, pivots


def multiply_basis(basis, old_monomials, degree):
    monomials = list(
        itertools.combinations_with_replacement(range(11), degree)
    )
    monomial_index = {
        monomial: index for index, monomial in enumerate(monomials)
    }
    rows = []
    for polynomial in basis:
        for variable in range(11):
            row = [0] * len(monomials)
            for index, coefficient in enumerate(polynomial):
                if coefficient:
                    monomial = tuple(
                        sorted(old_monomials[index] + (variable,))
                    )
                    row[monomial_index[monomial]] = coefficient
            rows.append(row)
    reduced, pivots = reduced_row_basis(rows)
    return monomials, reduced, pivots


def multiplication_rank(
    source_monomials,
    source_pivots,
    target_monomials,
    target_basis,
    target_pivots,
    coefficients,
):
    source_nonpivots = [
        index
        for index in range(len(source_monomials))
        if index not in set(source_pivots)
    ]
    target_nonpivots = [
        index
        for index in range(len(target_monomials))
        if index not in set(target_pivots)
    ]
    target_index = {
        monomial: index for index, monomial in enumerate(target_monomials)
    }
    columns = []
    for source in source_nonpivots:
        vector = [0] * len(target_monomials)
        for variable, coefficient in enumerate(coefficients):
            if coefficient:
                monomial = tuple(
                    sorted(source_monomials[source] + (variable,))
                )
                vector[target_index[monomial]] = coefficient
        for row, pivot in zip(target_basis, target_pivots):
            if vector[pivot]:
                scale = vector[pivot]
                vector = [
                    (left - scale * right) % PRIME
                    for left, right in zip(vector, row)
                ]
        columns.append([vector[index] for index in target_nonpivots])
    return (
        len(source_nonpivots),
        len(target_nonpivots),
        rank(columns),
    )


def normalize_plane(plane):
    work = [[value % PRIME for value in row] for row in plane]
    pivot_columns = []
    row = 0
    for column in range(7):
        pivot = next(
            (index for index in range(row, 3) if work[index][column]),
            None,
        )
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, PRIME)
        work[row] = [inverse * value % PRIME for value in work[row]]
        for index in range(3):
            if index == row or not work[index][column]:
                continue
            scale = work[index][column]
            work[index] = [
                (left - scale * right) % PRIME
                for left, right in zip(work[index], work[row])
            ]
        pivot_columns.append(column)
        row += 1
        if row == 3:
            break
    assert row == 3
    return work, pivot_columns


def tangent_check(plane, forms, section_basis):
    normalized, pivots = normalize_plane(plane)
    complement = [column for column in range(7) if column not in pivots]
    variables = [(row, column) for row in range(3) for column in complement]
    equations = []
    for left, right in itertools.combinations(range(3), 2):
        for form in forms:
            equations.append(
                [
                    (
                        int(moving_row == left)
                        * sum(
                            form[moving_column][column]
                            * normalized[right][column]
                            for column in range(7)
                        )
                        + int(moving_row == right)
                        * sum(
                            normalized[left][column]
                            * form[column][moving_column]
                            for column in range(7)
                        )
                    )
                    % PRIME
                    for moving_row, moving_column in variables
                ]
            )
    parameters = nullspace(equations)
    derivatives = []
    for parameter in parameters:
        variation = [[0] * 7 for _ in range(3)]
        for index, (row, column) in enumerate(variables):
            variation[row][column] = parameter[index]
        derivative = []
        for columns in TRIPLES:
            value = 0
            for moving_row in range(3):
                rows = [row[:] for row in normalized]
                rows[moving_row] = variation[moving_row]
                value += determinant3(
                    [[rows[row][column] for column in columns] for row in range(3)]
                )
            derivative.append(value % PRIME)
        derivatives.append(derivative)
    point = plucker(normalized)
    return (
        rank(equations),
        len(parameters),
        rank([point] + derivatives),
        rank(section_basis + [point] + derivatives),
    )


def main():
    rank_certificate = json.loads(RANK_CERTIFICATE.read_text(encoding="utf-8"))
    target_certificate = json.loads(
        TARGET_CERTIFICATE.read_text(encoding="utf-8")
    )
    assert target_certificate["schema"] == "c682-u22-linear-section-v1"

    for relative, expected in target_certificate["inputs"].items():
        actual = hashlib.sha256((REPOSITORY / relative).read_bytes()).hexdigest()
        assert actual == expected

    operator_basis = rank_certificate["operator_pencil"]["operator_basis"]
    source_rows = rank_certificate["explicit_resolvent"]["points"]
    assert len(operator_basis) == 10 and len(source_rows) == 22
    planes = []
    for source_row in source_rows:
        point = source_row["extended_normal_line"]
        matrix = [
            [
                sum(
                    point[index] * operator_basis[index][row][column]
                    for index in range(10)
                )
                % PRIME
                for column in range(7)
            ]
            for row in range(13)
        ]
        kernel = nullspace(matrix)
        assert len(kernel) == 3
        assert rank(kernel + source_row["kernel_rref"]) == 3
        planes.append(kernel)
    target_points = [normalize(plucker(plane)) for plane in planes]
    recomputed_by_parameter = {
        (source_row["parameter_t"], source_row["sheet_s"]): point
        for source_row, point in zip(source_rows, target_points)
    }
    recorded_by_parameter = {
        (row["t"], row["s"]): normalize(row["plucker"])
        for row in target_certificate["linear_section"]["target_points"]
    }
    assert recomputed_by_parameter == recorded_by_parameter

    forms = fifth_forms()
    contractions = contraction_equations(forms)
    assert rank(contractions) == 21
    assert len(nullspace(contractions)) == 14
    assert all(
        sum(equation[index] * point[index] for index in range(35))
        % PRIME
        == 0
        for equation in contractions
        for point in target_points
    )
    section_basis = row_basis(target_points)
    assert len(section_basis) == 11

    expected_extra = []
    for terms in (
        {(0, 1, 2): 1},
        {(0, 1, 3): 1, (3, 5, 6): 1},
        {(4, 5, 6): 1},
    ):
        expected_extra.append([terms.get(triple, 0) for triple in TRIPLES])
    assert all(
        sum(form[index] * point[index] for index in range(35))
        % PRIME
        == 0
        for form in expected_extra
        for point in target_points
    )
    assert rank(contractions + expected_extra) == 24
    assert len(nullspace(contractions + expected_extra)) == 11

    u_terms = {(0, 3, 6): 5, (0, 4, 5): 8}
    v_terms = {(0, 1, 3): 10, (3, 5, 6): 1}
    u_form = [u_terms.get(triple, 0) for triple in TRIPLES]
    v_form = [v_terms.get(triple, 0) for triple in TRIPLES]
    sheet_counts = {1: 0, PRIME - 1: 0}
    for source_row, point in zip(source_rows, target_points):
        u_value = sum(
            u_form[index] * point[index] for index in range(35)
        ) % PRIME
        v_value = sum(
            v_form[index] * point[index] for index in range(35)
        ) % PRIME
        assert v_value
        sheet = u_value * pow(v_value, -1, PRIME) % PRIME
        assert sheet == source_row["sheet_s"]
        assert (u_value * u_value - v_value * v_value) % PRIME == 0
        sheet_counts[sheet] += 1
    assert sheet_counts == {1: 11, PRIME - 1: 11}

    relation_rows, monomials_two, basis_two, pivots_two = (
        plucker_quadrics_on_section(section_basis)
    )
    monomials_three, basis_three, pivots_three = multiply_basis(
        basis_two, monomials_two, 3
    )
    monomials_four, basis_four, pivots_four = multiply_basis(
        basis_three, monomials_three, 4
    )
    assert (len(relation_rows), len(basis_two)) == (516, 45)
    assert (
        len(monomials_two) - len(basis_two),
        len(monomials_three) - len(basis_three),
        len(monomials_four) - len(basis_four),
    ) == (21, 22, 22)
    v_on_section = [
        sum(v_form[index] * section_basis[variable][index] for index in range(35))
        % PRIME
        for variable in range(11)
    ]
    assert multiplication_rank(
        monomials_three,
        pivots_three,
        monomials_four,
        basis_four,
        pivots_four,
        v_on_section,
    ) == (22, 22, 22)

    tangent_rows = {
        tangent_check(plane, forms, section_basis) for plane in planes
    }
    assert tangent_rows == {(9, 3, 4, 14)}
    print(
        "C682 independent U22 replay: PASS "
        "(target Hilbert length 22, transverse, 11+11 sheets)"
    )


if __name__ == "__main__":
    main()
