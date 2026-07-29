#!/usr/bin/env python3
"""Independent replay of the C682 mod-11 transvectant--matching bridge."""

from __future__ import annotations

import importlib.util
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPOSITORY = HERE.parent
EVIDENCE = REPOSITORY / "papers" / "clebsch-factorization" / "verification" / "evidence"
REPLAY_PATH = EVIDENCE / "matching_module_replay.py"
C651_REPLAY_PATH = HERE / "2026-07-26-c651-hitchin-tensor-bridge-replay.py"
SCOUT_PATH = EVIDENCE / "matching_orbit_scout.json"
CERTIFICATE_PATH = HERE / "2026-07-28-c682-mod11-transvectant-matching-bridge.json"
Q = 11


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


R = load_module("c682_mod11_independent_matching", REPLAY_PATH)
C651R = load_module("c682_mod11_independent_c651", C651_REPLAY_PATH)


def pgl_matrix_data(points):
    point_index = {point: index for index, point in enumerate(points)}
    data = {}
    for entries in itertools.product(range(Q), repeat=4):
        a, b, c, d = entries
        determinant = (a * d - b * c) % Q
        if not determinant:
            continue
        pivot = next(value for value in entries if value)
        if pivot != 1:
            continue
        permutation = []
        for x, y in points:
            image = ((a * x + b * y) % Q, (c * x + d * y) % Q)
            scale = pow(next(value for value in image if value), -1, Q)
            permutation.append(
                point_index[(image[0] * scale % Q, image[1] * scale % Q)]
            )
        data[tuple(permutation)] = (entries, determinant)
    return data


def poly_action(degree, matrix):
    a, b, c, d = matrix
    result = [[0] * (degree + 1) for _ in range(degree + 1)]
    for column in range(degree + 1):
        for i in range(degree - column + 1):
            for j in range(column + 1):
                row = i + j
                result[row][column] = (
                    result[row][column]
                    + math.comb(degree - column, i)
                    * pow(a, degree - column - i, Q)
                    * pow(b, i, Q)
                    * math.comb(column, j)
                    * pow(c, column - j, Q)
                    * pow(d, j, Q)
                ) % Q
    return result


def pgl_action(degree, matrix, determinant):
    scalar = pow(determinant, -(degree // 2), Q)
    return [
        [scalar * entry % Q for entry in row]
        for row in poly_action(degree, matrix)
    ]


def falling(n, k):
    if n < k:
        return 0
    result = 1
    for value in range(n - k + 1, n + 1):
        result *= value
    return result


def primitive_transvectant():
    terms = ((1, 11, 1), (11, 6, 6), (-1, 1, 11))
    matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        px, py = 6 - column, column
        for i in range(4):
            left = (
                (-1) ** i
                * math.comb(3, i)
                * falling(px, 3 - i)
                * falling(py, i)
            )
            for coefficient, fx, fy in terms:
                right = coefficient * falling(fx, i) * falling(fy, 3 - i)
                row = py - i + fy - (3 - i)
                if left and right:
                    matrix[row][column] += left * right
    divisor = math.gcd(*(entry for row in matrix for entry in row))
    assert divisor == 2640
    return [[entry // divisor % Q for entry in row] for row in matrix]


def projective(matrix):
    flattened = [entry % Q for row in matrix for entry in row]
    inverse = pow(next(entry for entry in flattened if entry), -1, Q)
    return tuple(inverse * entry % Q for entry in flattened)


def moved(binary_map, element, actions6, actions12):
    return R.matrix_product(
        R.matrix_product(actions12[element], binary_map, Q),
        R.matrix_inverse(actions6[element], Q),
        Q,
    )


def image_action(image_basis, ambient_action):
    _reduced, rows = R.row_reduce(R.transpose(image_basis), Q)
    square = [image_basis[row] for row in rows]
    target = R.matrix_product(ambient_action, image_basis, Q)
    answer = R.matrix_product(
        R.matrix_inverse(square, Q),
        [target[row] for row in rows],
        Q,
    )
    assert R.matrix_product(image_basis, answer, Q) == target
    return answer


def standard_four(permutation):
    return [
        [
            (int(row == permutation[column]) - int(row == permutation[4])) % Q
            for column in range(4)
        ]
        for row in range(4)
    ]


def hom_dimension(left_actions, right_actions):
    equations = []
    for left, right in zip(left_actions, right_actions):
        for row in range(4):
            for column in range(4):
                equation = [0] * 16
                for middle in range(4):
                    equation[middle * 4 + column] += left[row][middle]
                    equation[row * 4 + middle] -= right[middle][column]
                equations.append([value % Q for value in equation])
    return len(R.nullspace(equations, Q))


def matching_workspace():
    scout = json.loads(SCOUT_PATH.read_text(encoding="utf-8"))
    record = next(item for item in scout["types"] if item["type"] == "H3")
    points, pgl, psl = R.mobius_groups(Q)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted({R.image_matching(element, base) for element in pgl})
    stabilizer = {
        element for element in pgl if R.image_matching(element, base) == base
    }
    base_product = R.secant_product(base, points, Q)
    vectors = []
    for matching in orbit:
        product = R.secant_product(matching, points, Q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % Q
            for exponent in set(product) | set(base_product)
        }
        vectors.append(R.conic_quotient(difference, 4, Q))
    _reduced, coordinate_rows = R.row_reduce(vectors, Q)
    coordinates = [[vector[index] for index in coordinate_rows] for vector in vectors]
    first_sheet = {R.image_matching(element, min(orbit)) for element in psl}
    signs = [1 if matching in first_sheet else -1 % Q for matching in orbit]
    powers = [R.power_coordinates(vector, 3, Q) for vector in coordinates]
    cubic = [
        sum(sign * power[index] for sign, power in zip(signs, powers)) % Q
        for index in range(220)
    ]
    orbit_index = {matching: index for index, matching in enumerate(orbit)}
    _reduced, point_indices = R.row_reduce(R.transpose(coordinates), Q)
    point_basis = R.transpose([coordinates[index] for index in point_indices])
    point_inverse = R.matrix_inverse(point_basis, Q)
    base_index = orbit_index[base]

    def action(element):
        permutation = [
            orbit_index[R.image_matching(element, matching)]
            for matching in orbit
        ]
        moved_base = permutation[base_index]
        target = R.transpose(
            [
                [
                    (
                        coordinates[permutation[index]][coordinate]
                        - coordinates[moved_base][coordinate]
                    )
                    % Q
                    for coordinate in range(10)
                ]
                for index in point_indices
            ]
        )
        return R.matrix_product(target, point_inverse, Q)

    return points, pgl, psl, stabilizer, base, orbit, first_sheet, signs, coordinates, cubic, action


def matching_cubic_after(action, coordinates, signs):
    powers = [
        R.power_coordinates(R.matrix_vector(action, vector, Q), 3, Q)
        for vector in coordinates
    ]
    return [
        sum(sign * power[index] for sign, power in zip(signs, powers)) % Q
        for index in range(220)
    ]


def main():
    certificate = json.loads(CERTIFICATE_PATH.read_text(encoding="utf-8"))
    (
        points,
        pgl,
        psl,
        stabilizer,
        base,
        orbit,
        first_sheet,
        signs,
        coordinates,
        cubic,
        matching_action,
    ) = matching_workspace()
    assert (len(pgl), len(psl), len(stabilizer), len(orbit)) == (1320, 660, 60, 22)
    matrix_data = pgl_matrix_data(points)
    assert set(matrix_data) == pgl
    squares = {value * value % Q for value in range(1, Q)}
    character = {
        element: 1 if matrix_data[element][1] in squares else -1 % Q
        for element in pgl
    }
    actions6 = {}
    actions12 = {}
    for element in pgl:
        matrix, determinant = matrix_data[R.invert(element)]
        actions6[element] = pgl_action(6, matrix, determinant)
        actions12[element] = pgl_action(12, matrix, determinant)

    binary_map = primitive_transvectant()
    assert binary_map == certificate["primitive_transvectant_matrix"]
    assert R.matrix_rank(binary_map, Q) == 4
    conjugator = tuple(certificate["marking_conjugator"])
    marked = moved(binary_map, conjugator, actions6, actions12)
    assert marked == certificate["marked_transvectant_matrix"]
    marked_stabilizer = {
        element
        for element in pgl
        if projective(moved(marked, element, actions6, actions12)) == projective(marked)
    }
    assert marked_stabilizer == stabilizer

    correspondence = {}
    for element in pgl:
        matching = R.image_matching(element, base)
        image = projective(moved(marked, element, actions6, actions12))
        if matching in correspondence:
            assert correspondence[matching] == image
        correspondence[matching] = image
    assert len(correspondence) == len(set(correspondence.values())) == 22
    matching_sheet = {R.image_matching(element, base) for element in psl}
    transvectant_sheet = {
        projective(moved(marked, element, actions6, actions12))
        for element in psl
    }
    assert {correspondence[item] for item in matching_sheet} == transvectant_sheet

    pivots = certificate["image_basis_pivot_columns"]
    image_basis = [[marked[row][column] for column in pivots] for row in range(13)]
    five_actions = C651R.five_action(stabilizer)
    generators = R.group_generators(stabilizer)
    left = [image_action(image_basis, actions12[element]) for element in generators]
    right = [standard_four(five_actions[element]) for element in generators]
    assert hom_dimension(left, right) == 1

    assert all(
        matching_cubic_after(
            matching_action(element),
            coordinates,
            signs,
        )
        == [character[element] * entry % Q for entry in cubic]
        for element in pgl
    )
    exchanger = tuple(certificate["exchanger_permutation"])
    assert character[exchanger] == -1 % Q
    assert {
        R.image_matching(exchanger, matching)
        for matching in first_sheet
    } == set(orbit) - first_sheet
    assert {
        projective(moved(marked, exchanger, actions6, actions12))
    } <= set(correspondence.values()) - transvectant_sheet

    print(
        "independent C682 mod-11 bridge replay: OK "
        "(22 matched orbit points, Hom dimension 1, common sheet exchange)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
