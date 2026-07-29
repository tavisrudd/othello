#!/usr/bin/env python3
"""Independent finite-field replay of the C682 deformation/incidence map."""

from __future__ import annotations

import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-28-c682-transvectant-deformation-map.json"
DIVIDED_CERTIFICATE = HERE / "2026-07-28-c682-invariant-operator-divided-power.json"
CORRECTED_CERTIFICATE = HERE / "2026-07-28-c682-corrected-bridge-mod-1331.json"
P = 11
P2 = 121
F = [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0]
R = (1, 3, 3, 6)


def inverse_matrix2(matrix, modulus):
    a, b, c, d = matrix
    inverse_determinant = pow((a * d - b * c) % modulus, -1, modulus)
    return (
        d * inverse_determinant % modulus,
        -b * inverse_determinant % modulus,
        -c * inverse_determinant % modulus,
        a * inverse_determinant % modulus,
    )


def symmetric_action(matrix, degree, twist, modulus):
    a, b, c, d = inverse_matrix2(matrix, modulus)
    determinant = (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % modulus
    scale = pow(determinant, twist, modulus)
    output = [[0] * (degree + 1) for _ in range(degree + 1)]
    for column in range(degree + 1):
        for left_y in range(degree - column + 1):
            for right_y in range(column + 1):
                row = left_y + right_y
                output[row][column] += (
                    scale
                    * math.comb(degree - column, left_y)
                    * pow(a, degree - column - left_y, modulus)
                    * pow(b, left_y, modulus)
                    * math.comb(column, right_y)
                    * pow(c, column - right_y, modulus)
                    * pow(d, right_y, modulus)
                )
                output[row][column] %= modulus
    return output


def matmul(left, right, modulus=P):
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right))) % modulus
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def matvec(matrix, vector, modulus):
    return [
        sum(matrix[i][j] * vector[j] for j in range(len(vector))) % modulus
        for i in range(len(matrix))
    ]


def falling(number, order):
    if number < order:
        return 0
    return math.factorial(number) // math.factorial(number - order)


def third_matrix(right):
    output = [[0] * 7 for _ in range(13)]
    for output_y in range(13):
        for input_y in range(7):
            total = 0
            for index in range(4):
                right_y = output_y - input_y + 3
                if not 0 <= right_y <= 12:
                    continue
                total += (
                    (-1) ** index
                    * math.comb(3, index)
                    * falling(6 - input_y, 3 - index)
                    * falling(input_y, index)
                    * right[right_y]
                    * falling(12 - right_y, index)
                    * falling(right_y, 3 - index)
                )
            output[output_y][input_y] = total % P
    return output


def rref(matrix):
    work = [[value % P for value in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next((i for i in range(row, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        inverse = pow(work[row][column], -1, P)
        work[row] = [value * inverse % P for value in work[row]]
        for index in range(len(work)):
            if index == row:
                continue
            scale = work[index][column]
            work[index] = [
                (work[index][j] - scale * work[row][j]) % P
                for j in range(len(work[0]))
            ]
        pivots.append(column)
        row += 1
    return work, pivots


def rank(matrix):
    return len(rref(matrix)[1])


def nullspace(matrix):
    work, pivots = rref(matrix)
    free = [column for column in range(len(matrix[0])) if column not in pivots]
    output = []
    for column in free:
        vector = [0] * len(matrix[0])
        vector[column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -work[row][column] % P
        output.append(vector)
    return output


def fifth_pair(left, right):
    output = [0, 0, 0]
    for left_y, left_value in enumerate(left):
        for right_y, right_value in enumerate(right):
            for index in range(6):
                output_y = left_y - index + right_y - (5 - index)
                if 0 <= output_y <= 2:
                    output[output_y] += (
                        (-1) ** index
                        * math.comb(5, index)
                        * left_value
                        * falling(6 - left_y, 5 - index)
                        * falling(left_y, index)
                        * right_value
                        * falling(6 - right_y, index)
                        * falling(right_y, 5 - index)
                    )
    return [value % P for value in output]


def apolar_annihilator(plane):
    equations = [
        [
            vector[6 - column]
            * (-1) ** (6 - column)
            * math.factorial(6 - column)
            * math.factorial(column)
            % P
            for column in range(7)
        ]
        for vector in plane
    ]
    return nullspace(equations)


def decode_form(entries, degree):
    vector = [0] * (degree + 1)
    for entry in entries:
        vector[entry["y"]] = entry["coefficient"]
    return vector


def projective_points():
    points = []
    for x in range(P):
        for y in range(P):
            for z in range(P):
                if (x, y, z) == (0, 0, 0):
                    continue
                pivot = next(value for value in (x, y, z) if value)
                inverse = pow(pivot, -1, P)
                point = tuple(value * inverse % P for value in (x, y, z))
                if point not in points:
                    points.append(point)
    return sorted(points)


def conic_parameterization():
    conic = [point for point in projective_points() if sum(x * x for x in point) % P == 0]
    base = conic[0]
    pencil = [line for line in projective_points() if sum(line[i] * base[i] for i in range(3)) % P == 0]
    first = pencil[0]
    second = next(line for line in pencil[1:] if line != first)
    parameters = [(1, value) for value in range(P)] + [(0, 1)]
    output = []
    for left, right in parameters:
        line = tuple((left * first[i] + right * second[i]) % P for i in range(3))
        incident = [
            point
            for point in conic
            if sum(line[i] * point[i] for i in range(3)) % P == 0
        ]
        output.append(base if len(incident) == 1 else next(point for point in incident if point != base))
    return output, parameters


def main():
    result = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    divided = json.loads(DIVIDED_CERTIFICATE.read_text(encoding="utf-8"))
    corrected = json.loads(CORRECTED_CERTIFICATE.read_text(encoding="utf-8"))
    primitive = divided["sym6_primitive_matrix"]
    correction = decode_form(corrected["first_correction_digit_from_F"], 12)

    lifted = [(F[i] + P * correction[i]) % P2 for i in range(13)]
    transformed = matvec(symmetric_action(R, 12, 1, P2), lifted, P2)
    transformed = [value * pow(transformed[1], -1, P2) % P2 for value in transformed]
    conjugate = [((transformed[i] - F[i]) % P2) // P for i in range(13)]
    assert conjugate == decode_form(result["normal_lines"]["conjugate_K"], 12)

    def operator(vector):
        direction = third_matrix(vector)
        return [
            [(primitive[i][j] + 5 * direction[i][j]) % P for j in range(7)]
            for i in range(13)
        ]

    selected_operator = operator(correction)
    conjugate_operator = operator(conjugate)
    assert rank(selected_operator) == rank(conjugate_operator) == 4
    selected_kernel = nullspace(selected_operator)
    conjugate_kernel = nullspace(conjugate_operator)
    assert selected_kernel == result["kernel_map"]["selected_kernel"]
    assert conjugate_kernel == result["kernel_map"]["conjugate_kernel"]
    assert rank(selected_kernel + conjugate_kernel) == 6
    assert all(
        fifth_pair(plane[left], plane[right]) == [0, 0, 0]
        for plane in (selected_kernel, conjugate_kernel)
        for left in range(3)
        for right in range(left + 1, 3)
    )

    source_action = symmetric_action(R, 6, 3, P)
    target_action = symmetric_action(R, 12, 1, P)
    inverse_source = symmetric_action(inverse_matrix2(R, P), 6, 3, P)
    assert matmul(matmul(target_action, selected_operator), inverse_source) == conjugate_operator

    common = apolar_annihilator(selected_kernel + conjugate_kernel)
    assert common == [[1, 0, 6, 0, 6, 0, 1]]
    assert matvec(source_action, common[0], P) == [10, 0, 5, 0, 5, 0, 10]

    conic, parameters = conic_parameterization()
    permutation = []
    for x, y, z in conic:
        image = (x, -z % P, y)
        pivot = next(value for value in image if value)
        image = tuple(value * pow(pivot, -1, P) % P for value in image)
        permutation.append(conic.index(image))
    assert permutation == result["exchanger"]["parameter_permutation"]
    for index, (u, v) in enumerate(parameters):
        image = (R[0] * u + R[1] * v, R[2] * u + R[3] * v)
        pivot = next(value % P for value in image if value % P)
        image = tuple(value * pow(pivot, -1, P) % P for value in image)
        assert parameters[permutation[index]] == image

    equations = []
    for point, (u, v) in zip(conic, parameters):
        monomials = [u * u % P, u * v % P, v * v % P]
        equations.append(
            [
                *(value * point[1] % P for value in monomials),
                *(-value * point[0] % P for value in monomials),
                0,
                0,
                0,
            ]
        )
        equations.append(
            [
                *(value * point[2] % P for value in monomials),
                0,
                0,
                0,
                *(-value * point[0] % P for value in monomials),
            ]
        )
    quadratic = nullspace(equations)
    assert len(quadratic) == 1
    coordinate_forms = [
        quadratic[0][offset : offset + 3] for offset in (0, 3, 6)
    ]

    def multiply(left, right):
        output = [0] * (len(left) + len(right) - 1)
        for i, left_value in enumerate(left):
            for j, right_value in enumerate(right):
                output[i + j] = (output[i + j] + left_value * right_value) % P
        return output

    xyz = multiply(multiply(coordinate_forms[0], coordinate_forms[1]), coordinate_forms[2])
    assert xyz == result["incidence_map"]["xyz_restriction_to_parameter_conic"]
    assert xyz == [6 * value % P for value in common[0]]

    directions = [third_matrix([int(i == basis) for i in range(13)]) for basis in range(13)]
    ordinary_rows = [
        [directions[basis][row][column] for basis in range(13)]
        for row in range(13)
        for column in range(7)
    ]
    augmented_rows = [
        [primitive[row][column]]
        + [5 * directions[basis][row][column] % P for basis in range(13)]
        for row in range(13)
        for column in range(7)
    ]
    assert rank(ordinary_rows) == 9
    assert rank(augmented_rows) == 10
    quotient_indices = result["normal_lines"]["quotient_coordinate_indices"]
    quotient_directions = [directions[index] for index in quotient_indices]
    quotient_pair = result["normal_lines"]["quotient_coordinate_pair"]
    for plane, expected in zip(
        (selected_kernel, conjugate_kernel), quotient_pair
    ):
        equations = []
        for vector in plane:
            for output in range(13):
                equations.append(
                    [
                        sum(
                            primitive[output][column] * vector[column]
                            for column in range(7)
                        )
                        % P
                    ]
                    + [
                        5
                        * sum(
                            direction[output][column] * vector[column]
                            for column in range(7)
                        )
                        % P
                        for direction in quotient_directions
                    ]
                )
        recovered = nullspace(equations)
        assert len(recovered) == 1
        scale = pow(recovered[0][0], -1, P)
        assert [scale * value % P for value in recovered[0]] == [1] + expected

    operator_basis = [primitive] + [
        [[5 * value % P for value in row] for row in direction]
        for direction in quotient_directions
    ]
    coordinate_matrix = [
        [
            operator_basis[basis][row][column]
            for basis in range(len(operator_basis))
        ]
        for row in range(13)
        for column in range(7)
    ]

    def solve_coordinates(vector):
        augmented = [
            row + [vector[index]] for index, row in enumerate(coordinate_matrix)
        ]
        reduced, pivots = rref(augmented)
        assert len(pivots) == 10 and 10 not in pivots
        solution = [0] * 10
        for row, column in enumerate(pivots):
            solution[column] = reduced[row][-1]
        return solution

    ten_pair = result["ej_ten_pair_carrier"]
    intertwiner = ten_pair["intertwiner_pair_to_extended_normal"]
    assert rank(intertwiner) == 10
    assert [sum(row) % P for row in intertwiner] == [1] + quotient_pair[0]
    generator_actions = []
    for generator in ten_pair["generators"]:
        binary = tuple(generator["binary_PGL2_matrix"])
        left_action = symmetric_action(binary, 12, 1, P)
        inverse_right_action = symmetric_action(
            inverse_matrix2(binary, P), 6, 3, P
        )
        columns = []
        for basis in operator_basis:
            transformed = matmul(matmul(left_action, basis), inverse_right_action)
            columns.append(
                solve_coordinates(
                    [value for row in transformed for value in row]
                )
            )
        extended_action = [list(row) for row in zip(*columns)]
        assert extended_action == generator["extended_normal_action"]
        generator_actions.append(extended_action)
        permutation = generator["pair_permutation"]
        pair_action = [
            [int(row == permutation[column]) for column in range(10)]
            for row in range(10)
        ]
        assert matmul(extended_action, intertwiner) == matmul(
            intertwiner, pair_action
        )

    def normalize_line(vector):
        pivot = next(value for value in vector if value)
        inverse = pow(pivot, -1, P)
        return tuple(inverse * value % P for value in vector)

    selected_line = tuple(
        result["kernel_map"]["selected_recovered_extended_normal_line"]
    )
    conjugate_line = tuple(
        result["kernel_map"]["conjugate_recovered_extended_normal_line"]
    )
    assert all(
        normalize_line(matvec(action, selected_line, P)) == selected_line
        for action in generator_actions
    )
    orbit = {conjugate_line}
    frontier = list(orbit)
    while frontier:
        line = frontier.pop()
        for action in generator_actions:
            image = normalize_line(matvec(action, line, P))
            if image not in orbit:
                orbit.add(image)
                frontier.append(image)
    assert len(orbit) == 5

    def line_operator(line):
        return [
            [
                sum(
                    line[index] * operator_basis[index][row][column]
                    for index in range(10)
                )
                % P
                for column in range(7)
            ]
            for row in range(13)
        ]

    def tangent_equation_rank(matrix):
        right_kernel = nullspace(matrix)
        left_kernel = nullspace([list(column) for column in zip(*matrix)])
        equations = []
        for left in left_kernel:
            for right in right_kernel:
                equations.append(
                    [
                        sum(
                            left[row]
                            * sum(
                                basis[row][column] * right[column]
                                for column in range(7)
                            )
                            for row in range(13)
                        )
                        % P
                        for basis in operator_basis
                    ]
                )
        return rank(equations)

    rows = []
    for line in sorted(orbit):
        matrix = line_operator(line)
        assert rank(matrix) == 4
        line_kernel = nullspace(matrix)
        intersection = apolar_annihilator(selected_kernel + line_kernel)
        assert len(intersection) == 1
        rows.append(
            {
                "extended_normal_line": list(line),
                "operator_rank": 4,
                "rank_locus_tangent_equation_rank": tangent_equation_rank(matrix),
                "intersection_with_selected_annihilator": list(
                    normalize_line(intersection[0])
                ),
            }
        )
    incidence_line = result["incidence_map"]["common_incidence_line"]
    base = next(
        row
        for row in rows
        if row["intersection_with_selected_annihilator"] == incidence_line
    )
    rows = [base] + [row for row in rows if row is not base]
    rank_drop = result["ej_rank_drop_clebsch_frame"]
    assert rows == rank_drop["conjugate_orbit_rows"]
    intersection_lines = [
        row["intersection_with_selected_annihilator"] for row in rows
    ]
    assert rank(intersection_lines) == 4
    relation = nullspace([list(column) for column in zip(*intersection_lines)])
    assert relation == [rank_drop["raw_intersection_relation"]]
    global_scale = pow(relation[0][0], -1, P)
    frame = [
        [
            global_scale * relation[0][index] * value % P
            for value in line
        ]
        for index, line in enumerate(intersection_lines)
    ]
    assert frame == rank_drop["clebsch_frame_with_first_vector_xyz_and_sum_zero"]
    assert tangent_equation_rank(selected_operator) == 9
    print("PASS: independent transvectant deformation-map replay")


if __name__ == "__main__":
    main()
