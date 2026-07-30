#!/usr/bin/env python3
"""Independent invariant replay for the all-degree golden Weyl descent."""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-28-c682-klein-e8-operator-algebra.py"
CERTIFICATE = HERE / "2026-07-30-c682-golden-e8-weyl-descent.json"
BASE_SHA256 = "53b233ebe6bad4e1bcd6fcd40b20ac2329fabb0d69610ecd375d093826bcf963"


def load_base():
    if hashlib.sha256(BASE_PATH.read_bytes()).hexdigest() != BASE_SHA256:
        raise AssertionError("base checker hash changed")
    spec = importlib.util.spec_from_file_location("c682_weyl_replay_base", BASE_PATH)
    if spec is None or spec.loader is None:
        raise AssertionError("could not load base checker")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def multiply(left, right):
    return [
        [
            sum(left[row][middle] * right[middle][column] for middle in range(len(right)))
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def block(a, b):
    rows = len(a)
    columns = len(a[0])
    return (
        [a[row] + [5 * entry for entry in b[row]] for row in range(rows)]
        + [b[row] + a[row] for row in range(rows)]
    )


def golden(rows):
    return [
        [
            Fraction(
                5 * int(row < rows and column == rows + row)
                + int(row >= rows and column == row - rows)
            )
            for column in range(2 * rows)
        ]
        for row in range(2 * rows)
    ]


def rank_mod_two(matrix):
    work = [[entry % 2 for entry in row] for row in matrix]
    rank = 0
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        for row in range(len(work)):
            if row != rank and work[row][column]:
                work[row] = [
                    entry ^ pivot_entry
                    for entry, pivot_entry in zip(work[row], work[rank])
                ]
        rank += 1
    return rank


def determinant(matrix):
    work = [[Fraction(entry) for entry in row] for row in matrix]
    answer = Fraction(1)
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            return Fraction(0)
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            answer = -answer
        value = work[column][column]
        answer *= value
        work[column] = [entry / value for entry in work[column]]
        for row in range(column + 1, len(work)):
            factor = work[row][column]
            work[row] = [
                entry - factor * pivot_entry
                for entry, pivot_entry in zip(work[row], work[column])
            ]
    return answer


def concatenation_sign(left, right):
    values = left + right
    return (-1) ** sum(
        values[i] > values[j]
        for i in range(len(values))
        for j in range(i + 1, len(values))
    )


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text(encoding="utf-8"))
    base = load_base()
    split = certificate["axis_klein_split"]
    form_zero = {
        (12 - int(index), int(index)): coefficient
        for index, coefficient in split["F0_coefficients_by_y_exponent"].items()
    }
    form_one = {
        (12 - int(index), int(index)): coefficient
        for index, coefficient in split["F1_coefficients_by_y_exponent"].items()
    }
    for degree in (0, 10, 22, 60):
        delta_zero = base.delta_matrix(degree, form_zero)
        delta_one = base.delta_matrix(degree, form_one)
        descended = block(delta_zero, delta_one)
        if multiply(golden(degree + 7), descended) != multiply(
            descended,
            golden(degree + 1),
        ):
            raise AssertionError(f"replay intertwining failed in degree {degree}")

    comparison_data = certificate["degree_ten_integral_comparison"]
    conference = comparison_data["conference_matrix"]
    comparison = comparison_data["comparison_matrix"]
    companion = comparison_data["companion_matrix"]
    if multiply(conference, comparison) != multiply(comparison, companion):
        raise AssertionError("replay comparison identity failed")
    if determinant(comparison) != 4:
        raise AssertionError("replay comparison determinant failed")
    if rank_mod_two(comparison) != 4:
        raise AssertionError("replay comparison Smith nullity failed")
    quotient = comparison_data["cokernel_coordinates_mod_2"]
    quotient_on_comparison = [
        [entry % 2 for entry in row]
        for row in multiply(quotient, comparison)
    ]
    if quotient_on_comparison != [[0] * 6 for _ in range(2)]:
        raise AssertionError("replay quotient does not kill comparison lattice")
    quotient_after_conference = [
        [entry % 2 for entry in row]
        for row in multiply(quotient, conference)
    ]
    if quotient_after_conference != quotient:
        raise AssertionError("replay quotient action is not identity")
    determinant_signs = []
    for triple in itertools.combinations(range(6), 3):
        columns = [
            [int(row == column) for row in range(6)]
            for column in triple
        ] + [
            [conference[row][column] for row in range(6)]
            for column in triple
        ]
        triple_comparison = [
            [columns[column][row] for column in range(6)]
            for row in range(6)
        ]
        triple_determinant = determinant(triple_comparison)
        triangle_sign = (
            conference[triple[0]][triple[1]]
            * conference[triple[1]][triple[2]]
            * conference[triple[2]][triple[0]]
        )
        if triple_determinant != -4 * triangle_sign:
            raise AssertionError("replay Krylov/cubic determinant failed")
        determinant_signs.append(triple_determinant)
    if determinant_signs.count(4) != 10 or determinant_signs.count(-4) != 10:
        raise AssertionError("replay determinant orientation split failed")

    triples = list(itertools.combinations(range(6), 3))
    triple_index = {triple: index for index, triple in enumerate(triples)}
    exterior_cube = [
        [
            determinant(
                [
                    [conference[row][column] for column in source]
                    for row in target
                ]
            )
            for source in triples
        ]
        for target in triples
    ]
    hodge_star = [[0] * 20 for _ in range(20)]
    for source in triples:
        complement = tuple(index for index in range(6) if index not in source)
        hodge_star[triple_index[complement]][triple_index[source]] = (
            concatenation_sign(source, complement)
        )
    middle = multiply(hodge_star, exterior_cube)
    if multiply(middle, middle) != [
        [125 * int(row == column) for column in range(20)]
        for row in range(20)
    ]:
        raise AssertionError("replay middle exterior square failed")
    middle_diagonal = [middle[index][index] for index in range(20)]
    cubic_signs = [
        (
            conference[triple[0]][triple[1]]
            * conference[triple[1]][triple[2]]
            * conference[triple[2]][triple[0]]
        )
        for triple in triples
    ]
    if middle_diagonal != [4 * sign for sign in cubic_signs]:
        raise AssertionError("replay middle exterior diagonal failed")
    odd_adjacency = [
        [
            int(row != column and middle[row][column] % 2 != 0)
            for column in range(20)
        ]
        for row in range(20)
    ]
    for row, left in enumerate(triples):
        if sum(odd_adjacency[row]) != 9:
            raise AssertionError("replay odd graph degree failed")
        for column, right in enumerate(triples):
            if odd_adjacency[row][column] != int(
                row != column and len(set(left) & set(right)) == 1
            ):
                raise AssertionError("replay odd graph relation failed")
        zero_common = [
            column
            for column in range(20)
            if column != row
            and sum(
                odd_adjacency[row][middle_index]
                * odd_adjacency[column][middle_index]
                for middle_index in range(20)
            )
            == 0
        ]
        complement = tuple(index for index in range(6) if index not in left)
        if zero_common != [triples.index(complement)]:
            raise AssertionError("replay complement recovery failed")
    shifted_conference = [
        [entry - int(row == column) for column, entry in enumerate(values)]
        for row, values in enumerate(conference)
    ]
    shifted_companion = [
        [entry - int(row == column) for column, entry in enumerate(values)]
        for row, values in enumerate(companion)
    ]
    if (rank_mod_two(shifted_conference), rank_mod_two(shifted_companion)) != (
        1,
        3,
    ):
        raise AssertionError("replay mod-two obstruction failed")
    print(
        "PASS: independent degrees 0,10,22,60 satisfy golden Weyl "
        "intertwining; CP=PJ with determinant 4 and quotient (Z/2)^2; "
        "mod-2 Jordan ranks are 1 and 3; C acts trivially on the quotient; "
        "all 20 Krylov determinants recover the cubic signs; "
        "the middle exterior operator squares to 125 and its parity "
        "recovers the full triple-intersection scheme"
    )


if __name__ == "__main__":
    main()
