#!/usr/bin/env python3
"""C237: support-identical U(3,8) ideal LSSSs separated by strong MPC."""

from __future__ import annotations

import argparse
from collections import Counter
from itertools import combinations
import json
from pathlib import Path


P = 101

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def inv(value: int) -> int:
    assert value % P
    return pow(value, P - 2, P)


def rank(vectors) -> int:
    if not vectors:
        return 0
    matrix = [[value % P for value in vector] for vector in vectors]
    pivot_row = 0
    for column in range(len(matrix[0])):
        pivot = next(
            (row for row in range(pivot_row, len(matrix)) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        scale = inv(matrix[pivot_row][column])
        matrix[pivot_row] = [(scale * value) % P for value in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row == pivot_row or not matrix[row][column]:
                continue
            scale = matrix[row][column]
            matrix[row] = [
                (value - scale * pivot_value) % P
                for value, pivot_value in zip(matrix[row], matrix[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return pivot_row


def symmetric_square(vector):
    x, y, z = vector
    return (x * x % P, x * y % P, x * z % P, y * y % P, y * z % P, z * z % P)


def in_span(target, vectors) -> bool:
    return rank(vectors) == rank([*vectors, target])


def transform(vector, matrix):
    return tuple(
        sum(vector[row] * matrix[row][column] for row in range(3)) % P
        for column in range(3)
    )


def determinant(matrix) -> int:
    (a, b, c), (d, e, f), (g, h, i) = matrix
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % P


def grs_points():
    return tuple((1, parameter, parameter * parameter % P) for parameter in range(8))


def generic_points():
    # A fixed projective frame followed by the first seeded bounded-scout hit.
    return (
        (1, 0, 0),
        (0, 1, 0),
        (0, 0, 1),
        (1, 1, 1),
        (1, 79, 63),
        (1, 21, 30),
        (1, 53, 7),
        (1, 89, 22),
    )


def adversary_sets(participants):
    return tuple(
        subset
        for size in range(3)
        for subset in combinations(participants, size)
    )


def verify_support_u38(points) -> None:
    assert len(set(points)) == 8
    assert all(rank(subset) == 3 for subset in combinations(points, 3))


def dealer_profile(points, dealer: int):
    participants = tuple(index for index in range(8) if index != dealer)
    squares = tuple(symmetric_square(point) for point in points)
    deletion_profiles = []
    for adversary in adversary_sets(participants):
        remaining = tuple(index for index in participants if index not in adversary)
        remaining_squares = [squares[index] for index in remaining]
        before = rank(remaining_squares)
        after = rank([*remaining_squares, squares[dealer]])
        deletion_profiles.append(
            {
                "adversary": list(adversary),
                "adversary_size": len(adversary),
                "remaining_count": len(remaining),
                "remaining_square_rank": before,
                "rank_with_dealer_square": after,
                "dealer_product_reconstructs": before == after,
            }
        )
    assert len(deletion_profiles) == 29
    return deletion_profiles


def representation_profile(name, points, expected_square_rank, expected_strong):
    verify_support_u38(points)
    squares = tuple(symmetric_square(point) for point in points)
    assert rank(squares) == expected_square_rank
    if name == "generic":
        assert all(rank(subset) == 6 for subset in combinations(squares, 6))
        square_matroid = "U(6,8)"
    else:
        assert all(rank(subset) == min(len(subset), 5) for size in range(1, 6) for subset in combinations(squares, size))
        square_matroid = "rank-5 rational-normal-curve evaluation matroid U(5,8)"

    profiles = [dealer_profile(points, dealer) for dealer in range(8)]
    ordinary = all(profile[0]["dealer_product_reconstructs"] for profile in profiles)
    strong = all(item["dealer_product_reconstructs"] for profile in profiles for item in profile)
    assert ordinary
    assert strong == expected_strong
    histogram = Counter(
        (item["adversary_size"], item["dealer_product_reconstructs"])
        for profile in profiles
        for item in profile
    )
    first_failure = next(
        (
            {"dealer": dealer, **item}
            for dealer, profile in enumerate(profiles)
            for item in profile
            if not item["dealer_product_reconstructs"]
        ),
        None,
    )
    return {
        "name": name,
        "points": [list(point) for point in points],
        "support_matroid": "U(3,8)",
        "square_dimension": expected_square_rank,
        "square_matroid": square_matroid,
        "ordinary_multiplicative_every_dealer": ordinary,
        "strongly_multiplicative_every_dealer": strong,
        "checked_dealer_adversary_pairs": sum(len(profile) for profile in profiles),
        "outcome_histogram": {
            f"adversary_size_{size}_{'pass' if passed else 'fail'}": count
            for (size, passed), count in sorted(histogram.items())
        },
        "first_failure": first_failure,
    }


def gauge_replay(name, points, expected_square_rank, expected_strong):
    coordinate_scales = (2, 3, 5, 7, 11, 13, 17, 19)
    scaled = tuple(
        tuple(scale * value % P for value in point)
        for scale, point in zip(coordinate_scales, points)
    )
    matrix = ((1, 2, 3), (0, 1, 4), (5, 6, 0))
    assert determinant(matrix)
    transformed = tuple(transform(point, matrix) for point in scaled)
    replay = representation_profile(name, transformed, expected_square_rank, expected_strong)
    return {
        "coordinate_scales": list(coordinate_scales),
        "global_information_basis_change": [list(row) for row in matrix],
        "support_matroid": replay["support_matroid"],
        "square_dimension": replay["square_dimension"],
        "strongly_multiplicative_every_dealer": replay[
            "strongly_multiplicative_every_dealer"
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    grs = grs_points()
    generic = generic_points()
    representations = (
        representation_profile("GRS", grs, 5, True),
        representation_profile("generic", generic, 6, False),
    )
    certificate = {
        "task": "C237",
        "field": "GF(101)",
        "dealer_convention": (
            "one of eight represented forms is the dealer; the other seven are ideal shares"
        ),
        "access_structure": "3-of-7 for every dealer in support matroid U(3,8)",
        "unqualified_adversaries": "all participant subsets of size at most two",
        "multiplicativity_criterion": (
            "the dealer symmetric square lies in the span of the surviving participant squares"
        ),
        "result": (
            "support-identical ideal LSSSs are separated by strong multiplicativity"
        ),
        "representations": representations,
        "gauge_replays": (
            gauge_replay("GRS", grs, 5, True),
            gauge_replay("generic", generic, 6, False),
        ),
        "exhaustive_scope": {
            "dealer_choices_per_representation": 8,
            "unqualified_adversaries_per_dealer": 29,
            "dealer_adversary_checks_including_gauge_replay": 928,
        },
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
