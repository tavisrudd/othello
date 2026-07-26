#!/usr/bin/env python3
"""Independent exact replay of the Gorenstein/self-association gate."""

from __future__ import annotations

import importlib.util
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = json.loads((HERE / "gorenstein.json").read_text())
SCOUT = json.loads((HERE / "matching_orbit_scout.json").read_text())
REPLAY_PATH = HERE / "matching_module_replay.py"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


REPLAY = load_module("matching_replay_for_gorenstein", REPLAY_PATH)


def inverse(value: int, prime: int) -> int:
    return pow(value % prime, prime - 2, prime)


def rref(matrix: list[list[int]], prime: int) -> tuple[list[list[int]], list[int]]:
    result = [[entry % prime for entry in row] for row in matrix]
    if not result:
        return result, []
    row = 0
    pivots = []
    for column in range(len(result[0])):
        pivot = next(
            (index for index in range(row, len(result)) if result[index][column]),
            None,
        )
        if pivot is None:
            continue
        result[row], result[pivot] = result[pivot], result[row]
        scale = inverse(result[row][column], prime)
        result[row] = [scale * entry % prime for entry in result[row]]
        for index in range(len(result)):
            if index == row or not result[index][column]:
                continue
            factor = result[index][column]
            result[index] = [
                (left - factor * right) % prime
                for left, right in zip(result[index], result[row])
            ]
        pivots.append(column)
        row += 1
        if row == len(result):
            break
    return result, pivots


def rank(matrix: list[list[int]], prime: int) -> int:
    return len(rref(matrix, prime)[1])


def transpose(matrix: list[list[int]]) -> list[list[int]]:
    return [list(column) for column in zip(*matrix)] if matrix else []


def monomials(count: int, degree: int) -> list[tuple[int, ...]]:
    result = []
    for selection in itertools.combinations_with_replacement(range(count), degree):
        exponent = [0] * count
        for index in selection:
            exponent[index] += 1
        result.append(tuple(exponent))
    return result


def evaluate(point: list[int], exponent: tuple[int, ...], prime: int) -> int:
    result = 1
    for coordinate, power in zip(point, exponent):
        result = result * pow(coordinate, power, prime) % prime
    return result


def evaluations(
    points: list[list[int]], degree: int, prime: int
) -> list[list[int]]:
    basis = monomials(len(points[0]), degree)
    return [[evaluate(point, exponent, prime) for exponent in basis] for point in points]


def row_basis(matrix: list[list[int]], prime: int) -> list[list[int]]:
    reduced, _ = rref(matrix, prime)
    return [row for row in reduced if any(row)]


def complement(
    larger: list[list[int]], smaller: list[list[int]], prime: int
) -> list[list[int]]:
    basis = row_basis(smaller, prime)
    answer = []
    old_rank = len(basis)
    for vector in row_basis(larger, prime):
        new_rank = rank(basis + [vector], prime)
        if new_rank > old_rank:
            basis.append(vector)
            answer.append(vector)
            old_rank = new_rank
    return answer


def reconstruct(record: dict) -> tuple[list[list[int]], list[int]]:
    prime = record["field_order"]
    endpoints, pgl, psl = REPLAY.mobius_groups(prime)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted({REPLAY.image_matching(element, base) for element in pgl})
    base_product = REPLAY.secant_product(base, endpoints, prime)
    quotient_degree = (prime + 1) // 2 - 2
    vectors = []
    for matching in orbit:
        product = REPLAY.secant_product(matching, endpoints, prime)
        difference = {
            exponent: (
                product.get(exponent, 0) - base_product.get(exponent, 0)
            )
            % prime
            for exponent in set(product) | set(base_product)
        }
        vectors.append(REPLAY.conic_quotient(difference, quotient_degree, prime))
    _reduced, pivots = rref(vectors, prime)
    points = [[vector[index] for index in pivots] for vector in vectors]
    assert len(pivots) == prime - 1

    unseen = set(orbit)
    sheets = []
    while unseen:
        representative = min(unseen)
        sheet = {REPLAY.image_matching(element, representative) for element in psl}
        unseen -= sheet
        sheets.append(sheet)
    signs = [1 if matching in sheets[0] else prime - 1 for matching in orbit]
    return points, signs


def polynomial_product(left: list[int], right: list[int]) -> list[int]:
    result = [0] * (len(left) + len(right) - 1)
    for i, first in enumerate(left):
        for j, second in enumerate(right):
            result[i + j] += first * second
    return result


def betti_numerator(table: list[list[int]]) -> list[int]:
    result: list[int] = []
    for row, entries in enumerate(table):
        for homological_degree, value in enumerate(entries):
            degree = row + homological_degree
            while len(result) <= degree:
                result.append(0)
            result[degree] += (-1) ** homological_degree * value
    while result and result[-1] == 0:
        result.pop()
    return result


def replay_type(scout: dict, certificate: dict) -> None:
    prime = scout["field_order"]
    points, signs = reconstruct(scout)
    assert points == certificate["affine_points"]
    assert signs == certificate["sheet_sign"]
    projective = [[1] + point for point in points]
    count = len(projective)
    dimension = len(points[0])

    hilbert = [rank(evaluations(projective, degree, prime), prime) for degree in range(5)]
    assert hilbert == certificate["hilbert_function_degrees_0_through_4"]
    quadratic = evaluations(projective, 2, prime)
    assert rank(quadratic, prime) == count - 1
    assert all(
        sum(signs[index] * quadratic[index][column] for index in range(count))
        % prime
        == 0
        for column in range(len(quadratic[0]))
    )
    deletion_ranks = [
        rank(quadratic[:index] + quadratic[index + 1 :], prime)
        for index in range(count)
    ]
    assert deletion_ranks == certificate["quadratic_deletion_ranks"]

    point_matrix = transpose(projective)
    gale = [
        [entry * signs[column] % prime for column, entry in enumerate(row)]
        for row in point_matrix
    ]
    product = [
        [
            sum(
                point_matrix[row][index] * gale[column][index]
                for index in range(count)
            )
            % prime
            for column in range(dimension + 1)
        ]
        for row in range(dimension + 1)
    ]
    assert not any(any(row) for row in product)
    assert rank(gale, prime) == dimension + 1

    filtered_spaces = [
        row_basis(transpose(evaluations(projective, degree, prime)), prime)
        for degree in range(4)
    ]
    graded = [
        filtered_spaces[0],
        *[
            complement(filtered_spaces[degree], filtered_spaces[degree - 1], prime)
            for degree in range(1, 4)
        ],
    ]
    pairing_ranks = []
    for degree in range(4):
        matrix = [
            [
                sum(
                    signs[index] * left[index] * right[index]
                    for index in range(count)
                )
                % prime
                for right in graded[3 - degree]
            ]
            for left in graded[degree]
        ]
        pairing_ranks.append(rank(matrix, prime))
    assert pairing_ranks == [1, dimension, dimension, 1]
    assert pairing_ranks == certificate["artinian_pairing_ranks_degrees_0_through_3"]

    cubic = {}
    for exponent in monomials(dimension, 3):
        coefficient = sum(
            signs[index] * evaluate(points[index], exponent, prime)
            for index in range(count)
        ) % prime
        multiplier = math.factorial(3)
        for power in exponent:
            multiplier //= math.factorial(power)
        coefficient = coefficient * multiplier % prime
        if coefficient:
            cubic[",".join(map(str, exponent))] = coefficient
    assert cubic == certificate["inverse_system_cubic"]

    expected_numerator = [1, dimension, dimension, 1]
    for _ in range(dimension):
        expected_numerator = polynomial_product(expected_numerator, [1, -1])
    while expected_numerator and expected_numerator[-1] == 0:
        expected_numerator.pop()
    macaulay2 = certificate["macaulay2"]
    assert betti_numerator(macaulay2["betti_table"]) == expected_numerator
    table = macaulay2["betti_table"]
    last_shift = dimension + 3
    for row, entries in enumerate(table):
        for homological, value in enumerate(entries):
            degree = row + homological
            mirror_homological = dimension - homological
            mirror_degree = last_shift - degree
            mirror_row = mirror_degree - mirror_homological
            mirror = (
                table[mirror_row][mirror_homological]
                if 0 <= mirror_row < len(table)
                and 0 <= mirror_homological < len(table[mirror_row])
                else 0
            )
            assert value == mirror
    assert macaulay2["cohen_macaulay_type"] == 1
    assert certificate["singular"]["socle_dimension"] == 1
    assert certificate["arithmetically_gorenstein"]
    assert certificate["self_associated"]


def main() -> int:
    by_type = {record["type"]: record for record in CERTIFICATE["types"]}
    for scout in SCOUT["types"]:
        if scout["type"] in by_type:
            replay_type(scout, by_type[scout["type"]])
    assert set(by_type) == {"B3", "H3"}
    print(
        "Gorenstein/self-association independent replay: CHECK OK "
        "(coordinates, CB(2), signed Gale duality, Frobenius pairings, "
        "inverse cubics, and Betti symmetry)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
