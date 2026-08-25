#!/usr/bin/env python3
"""Independent stdlib replay of the specialized C958 quintic inverse."""

import argparse
import hashlib
import json
import random
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PRIME = 1_000_033


def residue(value):
    rational = Fraction(value)
    return rational.numerator * pow(rational.denominator, -1, PRIME) % PRIME


def inverse_matrix_3(matrix):
    augmented = [row[:] + [int(index == column) for column in range(3)]
                 for index, row in enumerate(matrix)]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if augmented[row][column])
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = pow(augmented[column][column], -1, PRIME)
        augmented[column] = [value * scale % PRIME for value in augmented[column]]
        for row in range(3):
            if row == column:
                continue
            factor = augmented[row][column]
            augmented[row] = [
                (augmented[row][index] - factor * augmented[column][index]) % PRIME
                for index in range(6)
            ]
    return [row[3:] for row in augmented]


def point_values(e, z_values):
    e1, e2, e4, e5 = e
    z1, z2, z3 = z_values
    inv = lambda value: pow(value % PRIME, -1, PRIME)
    values = [e1, e2, 1, e4, e5]
    values += [
        z3*inv(e1*e2), z2*inv(e1), (z2-z3)*inv(e1*e4),
        (3*z2-2*z3)*inv(e1*e5), z1*inv(e2),
        (z1-z3)*inv(e2*e4), (3*z1-z3)*inv(e2*e5),
        (z1-z2)*inv(e4), (2*z1-z2)*inv(e5),
        (z1-2*z2+z3)*inv(e4*e5),
        (-3*z1*z2+4*z1*z3-z2*z3)*inv(e1*e2*e4*e5),
    ]
    return [value % PRIME for value in values]


def dot(row, values):
    return sum(left*right for left, right in zip(row, values)) % PRIME


def forward(e, slices, tangents):
    origin = point_values(e, (0, 0, 0))
    constants = [dot(row, origin) for row in slices]
    matrix = []
    for row, constant in zip(slices, constants):
        matrix.append([
            (dot(row, point_values(e, tuple(int(index == column) for index in range(3))))
             - constant) % PRIME
            for column in range(3)
        ])
    inverse = inverse_matrix_3(matrix)
    z_values = [
        -sum(inverse[row][column]*constants[column] for column in range(3)) % PRIME
        for row in range(3)
    ]
    coordinates = [dot(row, point_values(e, z_values)) for row in tangents]
    scale = pow(coordinates[0], -1, PRIME)
    return tuple(value*scale % PRIME for value in coordinates[1:])


def polynomial(terms, point):
    total = 0
    for term in terms:
        value = int(term["coefficient"]) % PRIME
        for coordinate, exponent in zip(point, term["exponents"]):
            value = value * pow(coordinate, exponent, PRIME) % PRIME
        total += value
    return total % PRIME


def inverse(point, numerators, denominator):
    denominator_value = polynomial(denominator, point)
    scale = pow(denominator_value, -1, PRIME)
    return tuple(polynomial(numerator, point)*scale % PRIME for numerator in numerators)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    arguments = parser.parse_args()
    data = json.loads(arguments.certificate.read_text())
    assert data["schema"] == "c958-type-i1-specialized-tangent-inverse-v1"
    assert data["inverse_degree"] == 5
    assert data["exact_lift"]["common_denominator_verified"] is True
    for relative, expected in data["input_sha256"].items():
        assert hashlib.sha256((ROOT / relative).read_bytes()).hexdigest() == expected

    forms = data["forward_linear_forms"]
    assert forms["cox_coordinate_order"] == [
        "E1", "E2", "E3", "E4", "E5", "L12", "L13", "L14",
        "L15", "L23", "L24", "L25", "L34", "L35", "L45", "Q",
    ]
    slices = [[residue(value) for value in row] for row in forms["slice_rows"]]
    tangents = [[residue(value) for value in row] for row in forms["tangent_rows"]]
    numerators = data["numerators"]
    denominator = data["common_denominator"]

    rng = random.Random(20260825)
    checked_forward_inverse = 0
    while checked_forward_inverse < 200:
        e = tuple(rng.randrange(1, PRIME) for _ in range(4))
        try:
            image = forward(e, slices, tangents)
            recovered = inverse(image, numerators, denominator)
        except (StopIteration, ValueError):
            continue
        assert recovered == e
        checked_forward_inverse += 1

    checked_inverse_forward = 0
    while checked_inverse_forward < 200:
        point = tuple(rng.randrange(PRIME) for _ in range(4))
        try:
            e = inverse(point, numerators, denominator)
            recovered = forward(e, slices, tangents)
        except (StopIteration, ValueError):
            continue
        assert recovered == point
        checked_inverse_forward += 1


if __name__ == "__main__":
    main()
