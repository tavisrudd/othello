#!/usr/bin/env python3
"""Independent direct replay of C376's finite-field certificate."""

from __future__ import annotations

import itertools
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
CERTIFICATE = ROOT / "2026-07-19-c376-clebsch-cubic-chirality.json"


def inv(value: int, q: int) -> int:
    return pow(value % q, q - 2, q)


def normalize(vector, q: int):
    reduced = tuple(value % q for value in vector)
    pivot = next(value for value in reduced if value)
    scale = inv(pivot, q)
    return tuple(value * scale % q for value in reduced)


def eliminate(rows, q: int):
    matrix = [[value % q for value in row] for row in rows]
    pivot_row = 0
    pivots = []
    for column in range(len(matrix[0]) if matrix else 0):
        choice = next((r for r in range(pivot_row, len(matrix)) if matrix[r][column]), None)
        if choice is None:
            continue
        matrix[pivot_row], matrix[choice] = matrix[choice], matrix[pivot_row]
        scale = inv(matrix[pivot_row][column], q)
        matrix[pivot_row] = [value * scale % q for value in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row == pivot_row:
                continue
            multiple = matrix[row][column]
            if multiple:
                matrix[row] = [
                    (matrix[row][index] - multiple * matrix[pivot_row][index]) % q
                    for index in range(len(matrix[row]))
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return matrix, pivots


def rank(rows, q: int) -> int:
    return len(eliminate(rows, q)[1])


def inverse3(matrix, q: int):
    augmented = [list(row) + [int(row_index == column) for column in range(3)] for row_index, row in enumerate(matrix)]
    reduced, pivots = eliminate(augmented, q)
    assert pivots[:3] == [0, 1, 2]
    return tuple(tuple(row[3:]) for row in reduced[:3])


def mat_vec(matrix, vector, q: int):
    return tuple(sum(matrix[row][column] * vector[column] for column in range(3)) % q for row in range(3))


def mat_mul(left, right, q: int):
    return tuple(
        tuple(sum(left[row][middle] * right[middle][column] for middle in range(3)) % q for column in range(3))
        for row in range(3)
    )


def columns_matrix(columns):
    return tuple(tuple(columns[column][row] for column in range(3)) for row in range(3))


def frame_map(source, target, q: int):
    source_matrix = columns_matrix(source[:3])
    target_matrix = columns_matrix(target[:3])
    source_inverse = inverse3(source_matrix, q)
    target_inverse = inverse3(target_matrix, q)
    source_fourth = mat_vec(source_inverse, source[3], q)
    target_fourth = mat_vec(target_inverse, target[3], q)
    diagonal = tuple(
        tuple((target_fourth[row] * inv(source_fourth[row], q)) % q if row == column else 0 for column in range(3))
        for row in range(3)
    )
    return mat_mul(mat_mul(target_matrix, diagonal, q), source_inverse, q)


def projective_equivalences(source, target, q: int):
    result = set()
    for permutation in itertools.permutations(range(6)):
        matrix = frame_map(source[:4], [target[permutation[index]] for index in range(4)], q)
        if all(normalize(mat_vec(matrix, source[index], q), q) == target[permutation[index]] for index in range(6)):
            result.add(permutation)
    return result


def compose(left, right):
    return tuple(left[right[index]] for index in range(6))


def inverse_permutation(permutation):
    inverse = [0] * 6
    for index, image in enumerate(permutation):
        inverse[image] = index
    return tuple(inverse)


def monomial_value(exponents, point, q: int):
    value = 1
    for exponent, coordinate in zip(exponents, point):
        value = value * pow(coordinate, exponent, q) % q
    return value


def evaluate(coefficients, monomials, point, q: int):
    return sum(coefficient * monomial_value(exponents, point, q) for coefficient, exponents in zip(coefficients, monomials)) % q


def derivative(coefficients, monomials, point, variable: int, q: int):
    total = 0
    for coefficient, exponents in zip(coefficients, monomials):
        if exponents[variable] == 0:
            continue
        lowered = list(exponents)
        factor = lowered[variable]
        lowered[variable] -= 1
        total += coefficient * factor * monomial_value(lowered, point, q)
    return total % q


def projective_points(dimension: int, q: int):
    for pivot in range(dimension):
        for suffix in itertools.product(range(q), repeat=dimension - pivot - 1):
            yield (0,) * pivot + (1,) + suffix


def line_points(rows, q: int):
    first, second = rows
    points = {
        normalize(tuple(first[index] + scale * second[index] for index in range(4)), q)
        for scale in range(q)
    }
    points.add(normalize(second, q))
    assert len(points) == q + 1
    return points


def main() -> None:
    payload = json.loads(CERTIFICATE.read_text())
    q = payload["field"]
    source = [tuple(point) for point in payload["source_points"]]
    cremona = payload["quintic_cremona"]
    second = [tuple(point) for point in cremona["second_points"]]
    monomials = [tuple(exponents) for exponents in cremona["monomials"]]
    quintics = [tuple(coefficients) for coefficients in cremona["linear_system_basis"]]
    conic_monomials = [(2, 0, 0), (1, 1, 0), (1, 0, 1), (0, 2, 0), (0, 1, 1), (0, 0, 2)]
    conics = [tuple(coefficients) for coefficients in cremona["five_point_conics"]]

    derivative_constraints = [
        [
            derivative(tuple(int(index == coefficient) for index in range(len(monomials))), monomials, point, variable, q)
            for coefficient in range(len(monomials))
        ]
        for point in source
        for variable in range(3)
    ]
    assert rank(derivative_constraints, q) == 18
    assert rank(quintics, q) == 3
    assert all(derivative(polynomial, monomials, point, variable, q) == 0 for polynomial in quintics for point in source for variable in range(3))

    plane = list(projective_points(3, q))
    for omitted, conic in enumerate(conics):
        locus = [point for point in plane if evaluate(conic, conic_monomials, point, q) == 0]
        assert len(locus) == q + 1
        assert source[omitted] not in locus
        images = {
            normalize(tuple(evaluate(polynomial, monomials, point, q) for polynomial in quintics), q)
            for point in locus
            if point not in source
        }
        assert images == {second[omitted]}

    a5 = projective_equivalences(source, source, q)
    source_to_second = projective_equivalences(source, second, q)
    assert len(a5) == len(source_to_second) == 60
    normalizer = set()
    for permutation in itertools.permutations(range(6)):
        inverse = inverse_permutation(permutation)
        if {compose(compose(permutation, element), inverse) for element in a5} == a5:
            normalizer.add(permutation)
    assert len(normalizer) == 120
    assert source_to_second == normalizer - a5

    surface = payload["cubic_surface"]
    cubic = tuple(surface["equation_coefficients"])
    cubic_monomials = [tuple(exponents) for exponents in surface["equation_monomials"]]
    lines = {name: tuple(tuple(row) for row in rows) for name, rows in surface["lines"].items()}
    points_on_lines = {name: line_points(rows, q) for name, rows in lines.items()}
    assert all(evaluate(cubic, cubic_monomials, point, q) == 0 for points in points_on_lines.values() for point in points)
    assert not [
        point
        for point in projective_points(4, q)
        if evaluate(cubic, cubic_monomials, point, q) == 0
        and all(derivative(cubic, cubic_monomials, point, variable, q) == 0 for variable in range(4))
    ]

    names = sorted(lines)
    intersect = {
        tuple(sorted((left, right)))
        for left, right in itertools.combinations(names, 2)
        if points_on_lines[left] & points_on_lines[right]
    }
    assert len(intersect) == 135
    tritangents = [
        triple
        for triple in itertools.combinations(names, 3)
        if all(tuple(sorted(pair)) in intersect for pair in itertools.combinations(triple, 2))
    ]
    eckardt = [
        triple
        for triple in tritangents
        if set.intersection(*(points_on_lines[name] for name in triple))
    ]
    assert len(tritangents) == 45 and len(eckardt) == 10
    assert all(all(name.startswith("L") for name in triple) for triple in eckardt)

    skew = {
        tuple(sorted((left, right)))
        for left, right in itertools.combinations(names, 2)
        if tuple(sorted((left, right))) not in intersect
    }
    sixers = [
        combination
        for combination in itertools.combinations(names, 6)
        if all(tuple(sorted(pair)) in skew for pair in itertools.combinations(combination, 2))
    ]
    assert len(sixers) == 72
    double_sixes = set()
    for first_index, first in enumerate(sixers):
        for second in sixers[first_index + 1 :]:
            if set(first) & set(second):
                continue
            if all(sum(tuple(sorted((line, other))) in intersect for other in second) == 5 for line in first):
                double_sixes.add((first, second))
    assert len(double_sixes) == 36
    assert any(set(pair) == {tuple(f"E{i}" for i in range(6)), tuple(f"Q{i}" for i in range(6))} for pair in double_sixes)
    print("C376 independent replay passed")


if __name__ == "__main__":
    main()
