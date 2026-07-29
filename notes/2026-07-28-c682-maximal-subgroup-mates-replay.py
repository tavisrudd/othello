#!/usr/bin/env python3
"""Independent replay of the C682 finite normalizer-mate calculation."""

from __future__ import annotations

import itertools
import json
import math
from pathlib import Path


CERTIFICATE = Path(__file__).with_name(
    "2026-07-28-c682-maximal-subgroup-mates.json"
)
PRIME = 11


def canonical(entries):
    entries = tuple(value % PRIME for value in entries)
    pivot = next(value for value in entries if value)
    inverse = pow(pivot, -1, PRIME)
    return tuple(value * inverse % PRIME for value in entries)


def determinant(entries):
    a, b, c, d = entries
    return (a * d - b * c) % PRIME


def multiply(left, right):
    a, b, c, d = left
    e, f, g, h = right
    return canonical(
        (
            a * e + b * g,
            a * f + b * h,
            c * e + d * g,
            c * f + d * h,
        )
    )


def inverse(entries):
    a, b, c, d = entries
    return canonical((d, -b, -c, a))


def conjugate(element, member):
    return multiply(multiply(element, member), inverse(element))


def pgl2():
    return {
        canonical(entries)
        for entries in itertools.product(range(PRIME), repeat=4)
        if any(entries) and determinant(entries)
    }


def rank(matrix):
    rows = [[value % PRIME for value in row] for row in matrix]
    row = 0
    for column in range(len(rows[0]) if rows else 0):
        pivot = next(
            (candidate for candidate in range(row, len(rows)) if rows[candidate][column]),
            None,
        )
        if pivot is None:
            continue
        rows[row], rows[pivot] = rows[pivot], rows[row]
        inverse_pivot = pow(rows[row][column], -1, PRIME)
        rows[row] = [value * inverse_pivot % PRIME for value in rows[row]]
        for other in range(len(rows)):
            if other == row or not rows[other][column]:
                continue
            factor = rows[other][column]
            rows[other] = [
                (left - factor * right) % PRIME
                for left, right in zip(rows[other], rows[row], strict=True)
            ]
        row += 1
    return row


def same_space(left, right):
    return rank(left) == rank(right) == rank(left + right) == 3


def symmetric_action(entries, degree=6, twist=3):
    a, b, c, d = inverse(entries)
    scale = pow(determinant(entries), twist, PRIME)
    action = [[0] * (degree + 1) for _ in range(degree + 1)]
    for column in range(degree + 1):
        x_degree = degree - column
        y_degree = column
        for left_y in range(x_degree + 1):
            for right_y in range(y_degree + 1):
                row = left_y + right_y
                coefficient = (
                    math.comb(x_degree, left_y)
                    * a ** (x_degree - left_y)
                    * b**left_y
                    * math.comb(y_degree, right_y)
                    * c ** (y_degree - right_y)
                    * d**right_y
                )
                action[row][column] = (
                    action[row][column] + scale * coefficient
                ) % PRIME
    return action


def transform(kernel, element):
    action = symmetric_action(element)
    return [
        [
            sum(action[row][column] * vector[column] for column in range(7))
            % PRIME
            for row in range(7)
        ]
        for vector in kernel
    ]


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    ambient = pgl2()
    assert len(ambient) == 1320
    identity = (1, 0, 0, 1)
    base = certificate["groups"]["base_kernel_rref"]

    summary = []
    for row in certificate["normalizer_mates"]:
        subgroup = {tuple(element) for element in row["subgroup_matrices"]}
        tau = tuple(row["normalizer_coset_representative"])
        mate = row["mate_kernel_rref"]

        assert identity in subgroup
        assert {inverse(element) for element in subgroup} == subgroup
        assert {
            multiply(left, right) for left in subgroup for right in subgroup
        } == subgroup

        normalizer = {
            element
            for element in ambient
            if {conjugate(element, member) for member in subgroup} == subgroup
        }
        assert len(normalizer) == row["ambient_normalizer_order"]
        assert subgroup < normalizer
        assert len(normalizer - subgroup) == len(subgroup)
        assert tau in normalizer - subgroup
        assert multiply(tau, tau) in subgroup

        assert same_space(transform(base, tau), mate)
        assert same_space(transform(mate, tau), base)
        assert all(
            same_space(transform(base, representative), mate)
            for representative in normalizer - subgroup
        )
        summary.append(
            f"{row['type']}:{len(subgroup)}<{len(normalizer)}"
            f" -> orbit {row['index']}"
        )

    incidence = certificate["intrinsic_D5_S3_incidence"]
    d5_points = incidence["D5_points"]
    s3_points = incidence["S3_points"]
    dimensions = [
        [
            6 - rank(left["kernel_rref"] + right["kernel_rref"])
            for right in s3_points
        ]
        for left in d5_points
    ]
    assert dimensions == incidence["kernel_intersection_dimension_matrix"]
    assert all(value in (0, 1) for row in dimensions for value in row)
    assert [sum(row) for row in dimensions] == [5] * 6
    assert [
        sum(dimensions[row][column] for row in range(6))
        for column in range(10)
    ] == [3] * 10
    observed_pairs = [
        [d5_points[row]["point_index"], s3_points[column]["point_index"]]
        for row in range(6)
        for column in range(10)
        if dimensions[row][column] == 1
    ]
    assert observed_pairs == incidence["incident_point_index_pairs"]

    print("independent maximal-subgroup mate replay: ok")
    print(", ".join(summary))
    print("kernel incidence: (6_5,10_3)")


if __name__ == "__main__":
    main()
