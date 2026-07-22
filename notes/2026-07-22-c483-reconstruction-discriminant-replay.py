#!/usr/bin/env python3
"""Independent finite-field replay of the C483 Gale/branch classification."""

from __future__ import annotations

import itertools
import json
from pathlib import Path


CERTIFICATE = Path(__file__).with_name("2026-07-22-c483-reconstruction-discriminant.json")


def determinant(matrix, prime):
    matrix = [[value % prime for value in row] for row in matrix]
    answer = 1
    for column in range(len(matrix)):
        pivot = next((row for row in range(column, len(matrix)) if matrix[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            matrix[column], matrix[pivot] = matrix[pivot], matrix[column]
            answer = -answer
        value = matrix[column][column]
        answer = answer * value % prime
        inverse = pow(value, -1, prime)
        matrix[column] = [entry * inverse % prime for entry in matrix[column]]
        for row in range(column + 1, len(matrix)):
            scale = matrix[row][column]
            matrix[row] = [
                (entry - scale * pivot_entry) % prime
                for entry, pivot_entry in zip(matrix[row], matrix[column])
            ]
    return answer % prime


def parent(coordinates):
    a, b, c, d = coordinates
    return ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1), (1, a, b), (1, c, d))


def is_arc(coordinates, prime):
    points = parent(coordinates)
    return all(determinant([points[i], points[j], points[k]], prime) for i, j, k in itertools.combinations(range(6), 3))


def conic_determinant(coordinates, prime):
    rows = []
    for x, y, z in parent(coordinates):
        rows.append((x * x, y * y, z * z, x * y, x * z, y * z))
    return determinant(rows, prime)


def chart_factors(coordinates, prime):
    a, b, c, d = coordinates
    return (
        (b * c + a + d - a * d - b - c) % prime,
        conic_determinant(coordinates, prime),
    )


def inverse3(matrix, prime):
    augmented = [
        [value % prime for value in row] + [int(i == j) for j in range(3)]
        for i, row in enumerate(matrix)
    ]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if augmented[row][column])
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = pow(augmented[column][column], -1, prime)
        augmented[column] = [value * scale % prime for value in augmented[column]]
        for row in range(3):
            if row == column:
                continue
            scale = augmented[row][column]
            augmented[row] = [
                (value - scale * pivot_value) % prime
                for value, pivot_value in zip(augmented[row], augmented[column])
            ]
    return [row[3:] for row in augmented]


def matrix_vector(matrix, vector, prime):
    return [sum(matrix[i][j] * vector[j] for j in range(3)) % prime for i in range(3)]


def gale_associate(coordinates, prime):
    a, b, c, d = coordinates
    gale = ((-1, -1, -1), (-1, -a, -c), (-1, -b, -d), (1, 0, 0), (0, 1, 0), (0, 0, 1))
    basis = [[gale[column][row] for column in range(3)] for row in range(3)]
    inverse = inverse3(basis, prime)
    frame = matrix_vector(inverse, gale[3], prime)
    images = []
    for point in gale[4:]:
        coordinates_in_basis = matrix_vector(inverse, point, prime)
        normalized = [coordinates_in_basis[i] * pow(frame[i], -1, prime) % prime for i in range(3)]
        scale = pow(normalized[0], -1, prime)
        images.append((normalized[1] * scale % prime, normalized[2] * scale % prime))
    return images[0] + images[1]


def replay_prime(prime):
    arcs = conic_arcs = nonconic_arcs = 0
    for coordinates in itertools.product(range(prime), repeat=4):
        if not is_arc(coordinates, prime):
            continue
        arcs += 1
        associate = gale_associate(coordinates, prime)
        if not is_arc(associate, prime):
            raise AssertionError("Gale association left the six-arc locus")
        if gale_associate(associate, prime) != coordinates:
            raise AssertionError("Gale association did not square to the identity")
        on_conic = conic_determinant(coordinates, prime) == 0
        if (associate == coordinates) != on_conic:
            raise AssertionError("fixed locus differs from the conic locus")
        L0, L1 = chart_factors(coordinates, prime)
        L0_associate, L1_associate = chart_factors(associate, prime)
        tau = L1 * pow(L0 * L0 % prime, -1, prime) % prime
        tau_associate = L1_associate * pow(L0_associate * L0_associate % prime, -1, prime) % prime
        if tau_associate != -tau % prime:
            raise AssertionError("Gale sheet-orientation coordinate is not anti-invariant")
        orientation_denominator = (L0 + L0_associate) % prime
        if orientation_denominator:
            eta = L0 * pow(orientation_denominator, -1, prime) % prime
            eta_associate = L0_associate * pow(orientation_denominator, -1, prime) % prime
            if eta_associate != (1 - eta) % prime:
                raise AssertionError("normalized sheet coordinate does not reflect by eta -> 1-eta")
        conic_arcs += on_conic
        nonconic_arcs += not on_conic
    return {"prime": prime, "normalized_six_arcs": arcs, "conic_fixed_arcs": conic_arcs, "nonconic_two_sheet_arcs": nonconic_arcs}


def main():
    certificate = json.loads(CERTIFICATE.read_text())
    if certificate["algebra"]["quadratic_discriminant"] != "L1^2 in every characteristic":
        raise AssertionError("certificate schema drift")
    observed = [replay_prime(prime) for prime in (5, 7, 11)]
    expected = [
        {"prime": 5, "normalized_six_arcs": 6, "conic_fixed_arcs": 6, "nonconic_two_sheet_arcs": 0},
        {"prime": 7, "normalized_six_arcs": 140, "conic_fixed_arcs": 60, "nonconic_two_sheet_arcs": 80},
        {"prime": 11, "normalized_six_arcs": 3096, "conic_fixed_arcs": 504, "nonconic_two_sheet_arcs": 2592},
    ]
    if observed != expected:
        raise AssertionError(f"finite replay drift: {observed}")
    print("ok: independent Gale replay", observed)


if __name__ == "__main__":
    main()
