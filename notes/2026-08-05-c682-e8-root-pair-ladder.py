#!/usr/bin/env python3
"""Exact E8 root-pair code and its root-link fold to the E7 bitangent code."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-05-c682-e8-root-pair-ladder.json"
E7_SOURCE = HERE / "2026-08-04-c682-e7-bitangent-extension.py"


def parity(value):
    return value.bit_count() & 1


def quadratic(vector):
    return parity((vector & 15) & (vector >> 4))


def symplectic(left, right):
    left_x, left_y = left & 15, left >> 4
    right_x, right_y = right & 15, right >> 4
    return parity(left_x & right_y) ^ parity(left_y & right_x)


def span(basis):
    words = []
    for coefficients in range(1 << len(basis)):
        word = 0
        for index, vector in enumerate(basis):
            if (coefficients >> index) & 1:
                word ^= vector
        words.append(word)
    return tuple(sorted(words))


def enumerator(words):
    return {
        str(weight): count
        for weight, count in sorted(
            Counter(word.bit_count() for word in words).items()
        )
    }


def binary_basis(vectors):
    pivots = {}
    basis = []
    for original in vectors:
        value = original
        for pivot in sorted(pivots, reverse=True):
            if (value >> pivot) & 1:
                value ^= pivots[pivot]
        if not value:
            continue
        pivot = value.bit_length() - 1
        pivots[pivot] = value
        basis.append(original)
    return tuple(basis)


def coordinates(vector, basis):
    for coefficients in range(1 << len(basis)):
        value = 0
        for index, element in enumerate(basis):
            if (coefficients >> index) & 1:
                value ^= element
        if value == vector:
            return coefficients
    raise AssertionError("vector outside basis span")


def affine_code(points, ambient_dimension):
    rows = [(1 << len(points)) - 1]
    for bit in range(ambient_dimension):
        rows.append(
            sum(((point >> bit) & 1) << index for index, point in enumerate(points))
        )
    return tuple(rows), span(rows)


def fold_at_root(points, code, alpha):
    neighbors = tuple(point for point in points if symplectic(alpha, point) == 1)
    assert len(neighbors) == 56
    neighbor_set = set(neighbors)
    pairs = []
    seen = set()
    for point in neighbors:
        if point in seen:
            continue
        mate = point ^ alpha
        assert mate in neighbor_set and mate != point
        pair = tuple(sorted((point, mate)))
        pairs.append(pair)
        seen.update(pair)
    pairs = tuple(sorted(pairs))
    assert len(pairs) == 28
    point_index = {point: index for index, point in enumerate(points)}
    folded = []
    for word in code:
        values = [
            (
                (word >> point_index[left]) & 1,
                (word >> point_index[right]) & 1,
            )
            for left, right in pairs
        ]
        if all(left == right for left, right in values):
            folded.append(
                sum(left << index for index, (left, _) in enumerate(values))
            )
    return pairs, tuple(sorted(set(folded)))


def quotient_model(alpha, pairs):
    u0 = pairs[0][0]
    alpha_perp = [vector for vector in range(256) if symplectic(alpha, vector) == 0]
    quotient_basis = binary_basis([alpha] + alpha_perp)
    assert len(quotient_basis) == 7 and quotient_basis[0] == alpha
    six_basis = quotient_basis[1:]
    pair_coordinates = []
    for left, right in pairs:
        displacement = left ^ u0
        if symplectic(alpha, displacement):
            raise AssertionError("displacement outside alpha perpendicular")
        coefficients = coordinates(displacement, quotient_basis)
        quotient_coordinate = coefficients >> 1
        # Choosing the other member changes only the discarded alpha bit.
        other_coefficients = coordinates(right ^ u0, quotient_basis)
        assert (other_coefficients >> 1) == quotient_coordinate
        pair_coordinates.append(quotient_coordinate)
    assert len(set(pair_coordinates)) == 28

    def quotient_quadratic(coordinate):
        vector = 0
        for index, basis_vector in enumerate(six_basis):
            if (coordinate >> index) & 1:
                vector ^= basis_vector
        return quadratic(vector) ^ symplectic(u0, vector)

    zero_set = {coordinate for coordinate in range(64) if quotient_quadratic(coordinate) == 0}
    assert len(zero_set) == 28
    assert set(pair_coordinates) == zero_set
    rows, code = affine_code(tuple(pair_coordinates), 6)
    return pair_coordinates, rows, code


def certificate():
    points = tuple(vector for vector in range(256) if quadratic(vector) == 1)
    assert len(points) == 120
    rows, code = affine_code(points, 8)
    assert len(code) == 512
    assert enumerator(code) == {"0": 1, "56": 255, "64": 255, "120": 1}
    assert all((left & right).bit_count() % 2 == 0 for left in rows for right in rows)

    minimum_shell = tuple(word for word in code if word.bit_count() == 56)
    assert len(minimum_shell) == 255
    point_degrees = {
        sum((word >> point) & 1 for word in minimum_shell)
        for point in range(120)
    }
    assert point_degrees == {119}
    pair_degrees = {
        sum(
            ((word >> left) & 1) and ((word >> right) & 1)
            for word in minimum_shell
        )
        for left, right in itertools.combinations(range(120), 2)
    }
    assert pair_degrees == {55}

    generator_columns = tuple(1 | (point << 1) for point in points)
    dual_tetrads = tuple(
        indices
        for indices in itertools.combinations(range(120), 4)
        if generator_columns[indices[0]]
        ^ generator_columns[indices[1]]
        ^ generator_columns[indices[2]]
        ^ generator_columns[indices[3]]
        == 0
    )
    assert len(dual_tetrads) == 32130

    fold_enumerators = Counter()
    for alpha in points:
        _, folded = fold_at_root(points, code, alpha)
        fold_enumerators[tuple(enumerator(folded).items())] += 1
    expected_e7_enumerator = {"0": 1, "12": 63, "16": 63, "28": 1}
    assert fold_enumerators == Counter(
        {tuple(expected_e7_enumerator.items()): 120}
    )

    alpha = points[0]
    pairs, folded = fold_at_root(points, code, alpha)
    pair_coordinates, quotient_rows, quotient_code = quotient_model(alpha, pairs)
    assert folded == quotient_code
    assert len(quotient_rows) == 7
    assert len({word for word in folded if word.bit_count() == 12}) == 63

    return {
        "e8_code": {
            "carrier": "120 nonsingular vectors of O_8^+(2), equivalently E8 root pairs",
            "parameters": [120, 9, 56],
            "weight_enumerator": enumerator(code),
            "minimum_shell_size": len(minimum_shell),
            "minimum_shell_design": "2-(120,56,55)",
            "self_orthogonal": True,
            "dual_parameters": [120, 111, 4],
            "dual_tetrad_count": len(dual_tetrads),
            "css_parameters": [120, 102, 4],
        },
        "root_link_fold": {
            "all_roots_checked": 120,
            "neighbor_slice_size": 56,
            "antipodal_pair_count": 28,
            "parameters": [28, 7, 12],
            "weight_enumerator": expected_e7_enumerator,
            "fixed_alpha": alpha,
            "quotient_zero_set_size": len(set(pair_coordinates)),
            "exact_affine_quadric_code_equality": True,
        },
        "series_ladder": [
            "E8 [120,9,56] root-pair code",
            "E7 [28,7,12] bitangent code by root-link antipodal fold",
            "E6 [27,6,12] tritangent code by shortening",
        ],
        "input_sha256": {
            E7_SOURCE.name: hashlib.sha256(E7_SOURCE.read_bytes()).hexdigest()
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized()
    if args.write:
        OUTPUT.write_text(payload)
    if args.check:
        assert OUTPUT.read_text() == payload
    if not args.write and not args.check:
        print(payload, end="")


if __name__ == "__main__":
    main()
