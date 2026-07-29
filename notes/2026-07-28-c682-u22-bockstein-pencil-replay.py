#!/usr/bin/env python3
"""Independent replay of the C682 U_22 Bockstein pencil certificate."""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
import math
from functools import reduce
from pathlib import Path


P = 11
Q = 121
NOTES = Path(__file__).resolve().parent
EXPECTED_PATH = NOTES / "2026-07-28-c682-u22-bockstein-pencil.json"
U22_PATH = NOTES / "2026-07-28-c682-u22-linear-section.py"
BRIDGE_PATH = NOTES / "2026-07-28-c682-corrected-bridge-mod-1331.json"
DEFORMATION_PATH = (
    NOTES / "2026-07-28-c682-transvectant-deformation-map.json"
)
TRIPLES = list(itertools.combinations(range(7), 3))


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


U22 = load("replay_u22", U22_PATH)
RANK = U22.RANK
MM = U22.MM


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def falling(value, length):
    answer = 1
    for offset in range(length):
        answer *= value - offset
    return answer


def transvectant_tensor(left_degree, right_degree, order):
    output_degree = left_degree + right_degree - 2 * order
    answer = []
    entries = []
    for left in range(left_degree + 1):
        left_rows = []
        for right in range(right_degree + 1):
            row = [0] * (output_degree + 1)
            for index in range(order + 1):
                lx, ly = order - index, index
                rx, ry = index, order - index
                if (
                    left_degree - left < lx
                    or left < ly
                    or right_degree - right < rx
                    or right < ry
                ):
                    continue
                coefficient = (
                    (-1) ** index
                    * math.comb(order, index)
                    * falling(left_degree - left, lx)
                    * falling(left, ly)
                    * falling(right_degree - right, rx)
                    * falling(right, ry)
                )
                remaining_x = (
                    left_degree
                    - left
                    - lx
                    + right_degree
                    - right
                    - rx
                )
                row[output_degree - remaining_x] += coefficient
            left_rows.append(row)
            entries.extend(abs(value) for value in row if value)
        answer.append(left_rows)
    common = reduce(math.gcd, entries)
    return [
        [[value // common for value in row] for row in left_rows]
        for left_rows in answer
    ]


def projection_coefficient(triple):
    first, second, third = triple
    return (
        (second - first)
        * (third - first)
        * (third - second)
        // 2
    )


def invariant_vector():
    bridge = json.loads(BRIDGE_PATH.read_text(encoding="utf-8"))
    vector = [0] * 13
    for term in bridge["normalized_invariant_dodecic_mod_1331"]:
        vector[term["y"]] = term["coefficient"]
    return vector


def divided_rows(order):
    invariant = invariant_vector()
    tensor = transvectant_tensor(12, 12, order)
    output_dimension = 25 - 2 * order
    answer = [[0] * 35 for _ in range(output_dimension)]
    for column, triple in enumerate(TRIPLES):
        source = sum(triple) - 3
        for output in range(output_dimension):
            numerator = projection_coefficient(triple) * sum(
                tensor[source][right][output] * invariant[right]
                for right in range(13)
            )
            assert numerator % P == 0
            answer[output][column] = numerator // P % Q
    return answer


def fifth_forms():
    tensor = transvectant_tensor(6, 6, 5)
    return [
        [
            [
                tensor[left][right][output] % Q
                for right in range(7)
            ]
            for left in range(7)
        ]
        for output in range(3)
    ]


def determinant3(rows, modulus):
    return (
        rows[0][0]
        * (rows[1][1] * rows[2][2] - rows[1][2] * rows[2][1])
        - rows[0][1]
        * (rows[1][0] * rows[2][2] - rows[1][2] * rows[2][0])
        + rows[0][2]
        * (rows[1][0] * rows[2][1] - rows[1][1] * rows[2][0])
    ) % modulus


def plucker(plane, modulus):
    return [
        determinant3(
            [[plane[row][column] for column in triple] for row in range(3)],
            modulus,
        )
        for triple in TRIPLES
    ]


def reverse_chart(plane):
    matrix = [[value % P for value in row] for row in plane]
    row = 0
    pivots = []
    for column in reversed(range(7)):
        pivot = next(
            (index for index in range(row, 3) if matrix[index][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[row], matrix[pivot] = matrix[pivot], matrix[row]
        inverse = pow(matrix[row][column], -1, P)
        matrix[row] = [value * inverse % P for value in matrix[row]]
        for other in range(3):
            if other != row and matrix[other][column]:
                scale = matrix[other][column]
                matrix[other] = [
                    (left - scale * right) % P
                    for left, right in zip(matrix[other], matrix[row])
                ]
        pivots.append(column)
        row += 1
        if row == 3:
            break
    assert len(pivots) == 3
    nonpivots = [column for column in range(7) if column not in pivots]
    values = [
        matrix[row][column]
        for row in range(3)
        for column in nonpivots
    ]
    return pivots, nonpivots, values


def make_plane(pivots, nonpivots, values, modulus):
    plane = [[0] * 7 for _ in range(3)]
    for row, column in enumerate(pivots):
        plane[row][column] = 1
    cursor = 0
    for row in range(3):
        for column in nonpivots:
            plane[row][column] = values[cursor] % modulus
            cursor += 1
    return plane


def equations(plane, forms, quotient):
    rows = []
    for left, right in ((0, 1), (0, 2), (1, 2)):
        for form in forms:
            rows.append(
                sum(
                    plane[left][a]
                    * form[a][b]
                    * plane[right][b]
                    for a in range(7)
                    for b in range(7)
                )
                % Q
            )
    point = plucker(plane, Q)
    rows.extend(
        sum(form[index] * point[index] for index in range(35)) % Q
        for form in quotient
    )
    return rows


def solve(matrix, rhs):
    size = len(matrix)
    work = [
        [value % P for value in matrix[row]] + [rhs[row] % P]
        for row in range(size)
    ]
    for column in range(size):
        pivot = next(
            row for row in range(column, size) if work[row][column]
        )
        work[column], work[pivot] = work[pivot], work[column]
        inverse = pow(work[column][column], -1, P)
        work[column] = [value * inverse % P for value in work[column]]
        for row in range(size):
            if row != column and work[row][column]:
                scale = work[row][column]
                work[row] = [
                    (left - scale * right) % P
                    for left, right in zip(work[row], work[column])
                ]
    return [work[row][-1] for row in range(size)]


def lift_plane(plane, forms, quotient):
    pivots, nonpivots, values = reverse_chart(plane)
    base_plane = make_plane(pivots, nonpivots, values, Q)
    base = equations(base_plane, forms, quotient)
    jacobian = [[0] * 12 for _ in range(12)]
    for variable in range(12):
        moved = values[:]
        moved[variable] += P
        changed = equations(
            make_plane(pivots, nonpivots, moved, Q), forms, quotient
        )
        for row in range(12):
            jacobian[row][variable] = (
                (changed[row] - base[row]) % Q
            ) // P
    correction = solve(
        jacobian, [(-value // P) % P for value in base]
    )
    lifted = make_plane(
        pivots,
        nonpivots,
        [
            value + P * digit
            for value, digit in zip(values, correction)
        ],
        Q,
    )
    assert equations(lifted, forms, quotient) == [0] * 12
    return lifted


def normalize(point, modulus):
    first = next(value for value in point if value % P)
    inverse = pow(first, -1, modulus)
    return tuple(value * inverse % modulus for value in point)


def match(planes, target):
    wanted = normalize(plucker(target, P), P)
    matches = [
        index
        for index, plane in enumerate(planes)
        if normalize(plucker(plane, P), P) == wanted
    ]
    assert len(matches) == 1
    return matches[0]


def main():
    expected = json.loads(EXPECTED_PATH.read_text(encoding="utf-8"))
    for relative, identity in expected["inputs"].items():
        path = NOTES.parent / relative
        assert path.stat().st_size == identity["bytes"]
        assert digest(path) == identity["sha256"]

    expected_projection = expected["primitive_clebsch_gordan_maps"][
        "projection_coefficients_lexicographic_plucker_order"
    ]
    assert [
        projection_coefficient(triple) for triple in TRIPLES
    ] == expected_projection

    quotient = divided_rows(11)
    eta = divided_rows(12)[0]
    epsilon_terms = {
        tuple(term["plucker"]): term["coefficient"]
        for term in expected["global_invariant_pencil"]["epsilon"]["terms"]
    }
    epsilon = [
        epsilon_terms.get(triple, 0) for triple in TRIPLES
    ]
    forms = fifth_forms()

    operator_basis = RANK.operator_basis()
    parameters = [
        (parameter, sheet)
        for sheet in (1, P - 1)
        for parameter in range(P)
    ]
    source = [
        RANK.parameter_point(parameter, sheet)
        for parameter, sheet in parameters
    ]
    planes = [
        MM.nullspace(RANK.operator_at(point, operator_basis), P)
        for point in source
    ]
    lifted = [
        lift_plane(plane, forms, quotient) for plane in planes
    ]

    ratios = []
    for parameter, plane in zip(parameters, lifted):
        point = plucker(plane, Q)
        epsilon_value = sum(
            left * right for left, right in zip(epsilon, point)
        ) % Q
        eta_value = sum(
            left * right for left, right in zip(eta, point)
        ) % Q
        raw = (
            8
            * epsilon_value
            * pow(7 * eta_value % Q, -1, Q)
        ) % Q
        assert raw % P == parameter[1]
        ratios.append(raw)

    histogram = {}
    for ratio in ratios:
        histogram[str(ratio)] = histogram.get(str(ratio), 0) + 1
    assert histogram == expected["global_invariant_pencil"][
        "ratio_histogram_mod_121"
    ]

    bridge = json.loads(BRIDGE_PATH.read_text(encoding="utf-8"))
    deformation = json.loads(
        DEFORMATION_PATH.read_text(encoding="utf-8")
    )
    selected = match(
        planes,
        [
            [value % P for value in row]
            for row in bridge["operator_kernel_mod_121"]
        ],
    )
    conjugate = match(
        planes, deformation["kernel_map"]["conjugate_kernel"]
    )
    comparison = expected["golden_incidence_comparison"]
    assert ratios[selected] == comparison["selected_raw_ratio_mod_121"]
    assert (
        ratios[conjugate]
        == comparison["conjugate_raw_ratio_mod_121"]
    )
    sqrt5 = bridge["golden_character_field"][
        "selected_sqrt5_mod_1331"
    ] % Q
    slope = comparison["slope_mod_121"]
    intercept = comparison["intercept_mod_121"]
    assert (slope * ratios[selected] + intercept) % Q == sqrt5
    assert (
        slope * ratios[conjugate] + intercept
    ) % Q == -sqrt5 % Q
    print("c682 u22 bockstein pencil independent replay: PASS")


if __name__ == "__main__":
    main()
