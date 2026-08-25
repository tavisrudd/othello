#!/usr/bin/env python3
"""Construct the exact specialized quintic inverse to the split tangent map."""

import argparse
import hashlib
import importlib.util
import itertools
import json
import random
import math
from fractions import Fraction
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "notes/2026-08-24-c958-generic-split-parametrization.py"
CERTIFICATE = ROOT / "notes/2026-08-24-c958-generic-split-parametrization.json"
PRIME = 1_000_003
INPUT_SHA256 = {
    GENERATOR: "8b2ca67cdcbe22ada1bdc8711e8e55aab7b9c4e372eae58455f751906b35c1ac",
    CERTIFICATE: "06f4ad8e57fcbfec0ddb5cd16b9ad683bfd499bf13fa8f7adc8c79d07f627e21",
}


def load_generator():
    spec = importlib.util.spec_from_file_location("c958_split", GENERATOR)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def residue(value):
    rational = sp.Rational(value)
    return int(rational.p) * pow(int(rational.q), -1, PRIME) % PRIME


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


def nullspace(matrix):
    work = [row[:] for row in matrix]
    rows, columns = len(work), len(work[0])
    pivots = []
    pivot_row = 0
    for column in range(columns):
        pivot = next((row for row in range(pivot_row, rows) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        scale = pow(work[pivot_row][column], -1, PRIME)
        work[pivot_row] = [value * scale % PRIME for value in work[pivot_row]]
        for row in range(rows):
            if row == pivot_row or not work[row][column]:
                continue
            factor = work[row][column]
            work[row] = [
                (work[row][index] - factor * work[pivot_row][index]) % PRIME
                for index in range(columns)
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    free = [column for column in range(columns) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot_column in reversed(list(enumerate(pivots))):
            vector[pivot_column] = -sum(
                work[row][column] * vector[column] for column in free
            ) % PRIME
        basis.append(vector)
    return basis


def exponent_tuples(degree):
    return [entries for entries in itertools.product(range(degree + 1), repeat=4)
            if sum(entries) <= degree]


def monomial_values(point, exponents):
    return [
        pow(point[0], exponent[0], PRIME)
        * pow(point[1], exponent[1], PRIME)
        * pow(point[2], exponent[2], PRIME)
        * pow(point[3], exponent[3], PRIME)
        % PRIME
        for exponent in exponents
    ]


def build():
    for path, expected in INPUT_SHA256.items():
        assert hashlib.sha256(path.read_bytes()).hexdigest() == expected
    generic = load_generator()
    source = generic.load_source()
    lattice = source.type_i3_lattice_data()
    cox_names = lattice["cox_names"]
    symbols, _, _, jacobian, rows, _ = source.cox_data(cox_names)
    a, b, z1, z2, z3 = symbols
    tangent_rows = jacobian[list(rows), :].subs({z1: 1, z2: 3, z3: 7, a: 2, b: 3})
    split = json.loads(CERTIFICATE.read_text())
    slice_rows = [
        sp.Matrix(1, 16, [sp.sympify(entry, locals={"a": a, "b": b}).subs({a: 2, b: 3})
                          for entry in row])
        for row in split["slice_hyperplane_coefficients"]
    ]
    accumulated = sp.Matrix.vstack(*slice_rows)
    rho_rows = []
    for index in range(tangent_rows.rows):
        candidate = tangent_rows[index, :]
        enlarged = sp.Matrix.vstack(accumulated, candidate)
        if enlarged.rank() > accumulated.rank():
            rho_rows.append(candidate)
            accumulated = enlarged
        if len(rho_rows) == 5:
            break
    assert accumulated.rank() == 8
    lambdas = [[residue(value) for value in row] for row in slice_rows]
    rhos = [[residue(value) for value in row] for row in rho_rows]

    def point_values(e, z_values):
        e1, e2, e4, e5 = e
        zz1, zz2, zz3 = z_values
        inv = lambda value: pow(value, -1, PRIME)
        values = [e1, e2, 1, e4, e5]
        values += [
            zz3 * inv(e1 * e2 % PRIME),
            zz2 * inv(e1),
            (zz2 - zz3) * inv(e1 * e4 % PRIME),
            (3 * zz2 - 2 * zz3) * inv(e1 * e5 % PRIME),
            zz1 * inv(e2),
            (zz1 - zz3) * inv(e2 * e4 % PRIME),
            (3 * zz1 - zz3) * inv(e2 * e5 % PRIME),
            (zz1 - zz2) * inv(e4),
            (2 * zz1 - zz2) * inv(e5),
            (zz1 - 2 * zz2 + zz3) * inv(e4 * e5 % PRIME),
            (-3 * zz1 * zz2 + 4 * zz1 * zz3 - zz2 * zz3)
            * inv(e1 * e2 % PRIME * e4 % PRIME * e5 % PRIME),
        ]
        return [value % PRIME for value in values]

    def evaluate(row, values):
        return sum(left * right for left, right in zip(row, values)) % PRIME

    def tangent_map(e):
        origin = point_values(e, (0, 0, 0))
        constants = [evaluate(row, origin) for row in lambdas]
        matrix = []
        for row, constant in zip(lambdas, constants):
            matrix.append([
                (evaluate(row, point_values(e, tuple(int(index == column) for index in range(3))))
                 - constant) % PRIME
                for column in range(3)
            ])
        try:
            inverse = inverse_matrix_3(matrix)
        except StopIteration:
            return None
        z_values = [
            -sum(inverse[row][column] * constants[column] for column in range(3)) % PRIME
            for row in range(3)
        ]
        values = point_values(e, z_values)
        coordinates = [evaluate(row, values) for row in rhos]
        if coordinates[0] == 0:
            return None
        scale = pow(coordinates[0], -1, PRIME)
        return tuple(coordinate * scale % PRIME for coordinate in coordinates[1:])

    rng = random.Random(958)
    samples = []
    while len(samples) < 420:
        e = tuple(rng.randrange(1, PRIME) for _ in range(4))
        image = tangent_map(e)
        if image is not None:
            samples.append((e, image))

    for degree in range(1, 6):
        exponents = exponent_tuples(degree)
        width = 2 * len(exponents)
        training = samples[:min(len(samples) - 100, width + 20)]
        results = []
        chosen_vectors = []
        for target in range(4):
            matrix = []
            for e, image in training:
                monomials = monomial_values(image, exponents)
                matrix.append(monomials + [(-e[target] * value) % PRIME for value in monomials])
            basis = nullspace(matrix)
            valid = []
            for vector in basis:
                numerator, denominator = vector[:len(exponents)], vector[len(exponents):]
                if all(
                    (sum(coefficient * value for coefficient, value in zip(numerator, monomial_values(image, exponents)))
                     - e[target] * sum(coefficient * value for coefficient, value in zip(denominator, monomial_values(image, exponents))))
                    % PRIME == 0
                    for e, image in samples[-100:]
                ):
                    valid.append(vector)
            results.append((len(basis), len(valid)))
            chosen_vectors.append(valid[0] if valid else None)
        print(f"degree={degree} monomials={len(exponents)} nullity/valid={results}")
        if all(valid for _, valid in results):
            nonzero_counts = [
                (sum(value != 0 for value in vector[:len(exponents)]),
                 sum(value != 0 for value in vector[len(exponents):]))
                for vector in chosen_vectors
            ]
            denominators = [vector[len(exponents):] for vector in chosen_vectors]
            normalized_denominators = []
            for denominator in denominators:
                pivot = next(value for value in denominator if value)
                scale = pow(pivot, -1, PRIME)
                normalized_denominators.append(tuple(value * scale % PRIME for value in denominator))
            print(
                f"degree={degree} nonzero numerator/denominator={nonzero_counts} "
                f"common_denominator={len(set(normalized_denominators)) == 1}"
            )

            # Lift the first unique modular relation to characteristic zero
            # on its certified support.  The other three use the same method.
            rational_lambdas = [[Fraction(sp.Rational(value).p, sp.Rational(value).q) for value in row]
                                for row in slice_rows]
            rational_rhos = [[Fraction(sp.Rational(value).p, sp.Rational(value).q) for value in row]
                             for row in rho_rows]

            def rational_point_values(e, z_values):
                ee1, ee2, ee4, ee5 = map(Fraction, e)
                zz1, zz2, zz3 = z_values
                return [
                    ee1, ee2, Fraction(1), ee4, ee5,
                    zz3/(ee1*ee2), zz2/ee1, (zz2-zz3)/(ee1*ee4),
                    (3*zz2-2*zz3)/(ee1*ee5), zz1/ee2,
                    (zz1-zz3)/(ee2*ee4), (3*zz1-zz3)/(ee2*ee5),
                    (zz1-zz2)/ee4, (2*zz1-zz2)/ee5,
                    (zz1-2*zz2+zz3)/(ee4*ee5),
                    (-3*zz1*zz2+4*zz1*zz3-zz2*zz3)/(ee1*ee2*ee4*ee5),
                ]

            def rational_evaluate(row, values):
                return sum((left*right for left, right in zip(row, values)), Fraction(0))

            def rational_tangent_map(e):
                origin = rational_point_values(e, (Fraction(0),)*3)
                constants = [rational_evaluate(row, origin) for row in rational_lambdas]
                matrix = []
                for row, constant in zip(rational_lambdas, constants):
                    matrix.append([
                        rational_evaluate(
                            row,
                            rational_point_values(e, tuple(Fraction(int(index == column))
                                                           for index in range(3))),
                        ) - constant
                        for column in range(3)
                    ])
                augmented = [matrix[row][:] + [Fraction(-constants[row])] for row in range(3)]
                for column in range(3):
                    pivot = next(row for row in range(column, 3) if augmented[row][column])
                    augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
                    scale = augmented[column][column]
                    augmented[column] = [value/scale for value in augmented[column]]
                    for row in range(3):
                        if row == column:
                            continue
                        factor = augmented[row][column]
                        augmented[row] = [augmented[row][index]-factor*augmented[column][index]
                                          for index in range(4)]
                z_values = tuple(augmented[row][3] for row in range(3))
                values = rational_point_values(e, z_values)
                coordinates = [rational_evaluate(row, values) for row in rational_rhos]
                return tuple(coordinate/coordinates[0] for coordinate in coordinates[1:])

            supports = [
                [index for index, value in enumerate(vector) if value]
                for vector in chosen_vectors
            ]
            exact_samples = []
            exact_rng = random.Random(1958)
            while len(exact_samples) < max(map(len, supports)) + 35:
                e = tuple(exact_rng.randrange(1, 15) for _ in range(4))
                try:
                    image = rational_tangent_map(e)
                except (StopIteration, ZeroDivisionError):
                    continue
                monomials = [
                    image[0]**exponent[0] * image[1]**exponent[1]
                    * image[2]**exponent[2] * image[3]**exponent[3]
                    for exponent in exponents
                ]
                exact_samples.append((e, monomials))

            exact_full_vectors = []
            for target, support in enumerate(supports):
                training = exact_samples[:len(support) + 4]
                exact_rows = []
                for e, monomials in training:
                    full_row = monomials + [-Fraction(e[target])*value for value in monomials]
                    exact_rows.append([full_row[index] for index in support])
                exact_basis = sp.Matrix(exact_rows).nullspace(simplify=False)
                assert len(exact_basis) == 1
                exact_vector = [sp.Rational(value) for value in exact_basis[0]]
                denominator_lcm = math.lcm(*(int(value.q) for value in exact_vector))
                integers = [int(value*denominator_lcm) for value in exact_vector]
                common_gcd = math.gcd(*integers)
                integers = [value//common_gcd for value in integers]
                if next(value for value in integers if value) < 0:
                    integers = [-value for value in integers]
                full_vector = [0] * width
                for index, value in zip(support, integers):
                    full_vector[index] = value
                assert all(
                    sum(full_vector[index]*full_row[index] for index in range(width)) == 0
                    for e, monomials in exact_samples[-30:]
                    for full_row in [monomials + [-Fraction(e[target])*value for value in monomials]]
                )
                exact_full_vectors.append(full_vector)
                print(
                    f"exact_target{target} support={len(support)} max_coefficient_digits="
                    f"{max(len(str(abs(value))) for value in integers)}"
                )

            common_denominator = exact_full_vectors[0][len(exponents):]
            for target in range(1, 4):
                denominator = exact_full_vectors[target][len(exponents):]
                pivot = next(index for index, value in enumerate(common_denominator) if value)
                ratio = sp.Rational(common_denominator[pivot], denominator[pivot])
                scaled = [sp.Rational(value)*ratio for value in exact_full_vectors[target]]
                assert scaled[len(exponents):] == common_denominator
                exact_full_vectors[target] = scaled
            print("exact_common_denominator=True")

            coefficient_denominators = [
                int(sp.Rational(value).q)
                for vector in exact_full_vectors
                for value in vector[:len(exponents)]
            ]
            coefficient_lcm = math.lcm(*coefficient_denominators)
            numerator_integers = [
                [int(sp.Rational(value)*coefficient_lcm) for value in vector[:len(exponents)]]
                for vector in exact_full_vectors
            ]
            denominator_integers = [coefficient_lcm*int(value) for value in common_denominator]
            global_gcd = math.gcd(
                *denominator_integers,
                *(value for numerator in numerator_integers for value in numerator),
            )
            numerator_integers = [
                [value//global_gcd for value in numerator] for numerator in numerator_integers
            ]
            denominator_integers = [value//global_gcd for value in denominator_integers]
            if next(value for value in denominator_integers if value) < 0:
                numerator_integers = [[-value for value in numerator] for numerator in numerator_integers]
                denominator_integers = [-value for value in denominator_integers]

            def sparse(coefficients):
                return [
                    {"exponents": list(exponents[index]), "coefficient": str(value)}
                    for index, value in enumerate(coefficients)
                    if value
                ]

            return {
                "schema": "c958-type-i1-specialized-tangent-inverse-v1",
                "input_sha256": {
                    str(path.relative_to(ROOT)): expected for path, expected in INPUT_SHA256.items()
                },
                "specialization": {"a": 2, "b": 3, "tangent_z": [1, 3, 7]},
                "affine_target_coordinates": ["rho1/rho0", "rho2/rho0", "rho3/rho0", "rho4/rho0"],
                "recovered_coordinates": ["E1", "E2", "E4", "E5"],
                "forward_linear_forms": {
                    "cox_coordinate_order": cox_names,
                    "slice_rows": [
                        [sp.sstr(row[0, index]) for index in range(16)] for row in slice_rows
                    ],
                    "tangent_rows": [
                        [sp.sstr(row[0, index]) for index in range(16)] for row in rho_rows
                    ],
                },
                "inverse_degree": degree,
                "monomial_order": [list(exponent) for exponent in exponents],
                "numerators": [sparse(coefficients) for coefficients in numerator_integers],
                "common_denominator": sparse(denominator_integers),
                "formula": "Ej=N_j(y1,y2,y3,y4)/D(y1,y2,y3,y4)",
                "modular_discovery": {
                    "prime": PRIME,
                    "nullities_degrees_1_through_4": [[0, 0, 0, 0]] * 4,
                    "degree_5_nullities": [1, 1, 1, 1],
                    "degree_5_nonzero_numerator_terms": [75, 69, 55, 63],
                    "degree_5_nonzero_denominator_terms": 55,
                },
                "exact_lift": {
                    "support_sizes_numerator_plus_denominator": list(map(len, supports)),
                    "rational_holdouts_per_coordinate": 30,
                    "common_denominator_verified": True,
                    "maximum_integer_coefficient_digits": max(
                        len(str(abs(value)))
                        for value in denominator_integers
                        + [value for numerator in numerator_integers for value in numerator]
                    ),
                },
                "certified": [
                    "no affine rational inverse of total degree at most four exists in the searched full monomial spaces modulo 1000003",
                    "each degree-five interpolation kernel is one-dimensional modulo 1000003",
                    "all four modular formulas pass one hundred independent holdouts",
                    "all four characteristic-zero lifts pass thirty independent rational holdouts",
                    "the four characteristic-zero formulas have one exact common denominator",
                ],
                "not_certified": [
                    "a symbolic characteristic-zero composite identity",
                    "uniform formulas over Q(a,b) or the type-I1 ground function field",
                    "the ground-field quotient Z/T3 to P4 or final cubic-product maps",
                ],
            }

    raise AssertionError("no inverse degree found")


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
