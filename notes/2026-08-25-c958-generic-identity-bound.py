#!/usr/bin/env python3
"""Prove safe degree and coefficient bounds for the C958 generic residual."""

import argparse
import hashlib
import itertools
import json
import math
from pathlib import Path
import sys

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


PRIMES = [
    9223372036854775837, 9223372036854775907,
    9223372036854775931, 9223372036854775939,
    9223372036854775963, 9223372036854776063,
    9223372036854776077, 9223372036854776167,
    9223372036854776243, 9223372036854776257,
    9223372036854776261, 9223372036854776293,
    9223372036854776299, 9223372036854776351,
]


def is_prime_u64(value):
    """Deterministic Miller--Rabin for unsigned 64-bit integers."""
    if value < 2:
        return False
    small_primes = (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37)
    for prime in small_primes:
        if value % prime == 0:
            return value == prime
    odd_part = value - 1
    power_of_two = 0
    while odd_part % 2 == 0:
        odd_part //= 2
        power_of_two += 1
    for base in (2, 325, 9375, 28178, 450775, 9780504, 1795265022):
        residue = pow(base % value, odd_part, value)
        if residue in (1, value - 1):
            continue
        for _ in range(power_of_two - 1):
            residue = residue * residue % value
            if residue == value - 1:
                break
        else:
            return False
    return True


def determinant_bound(matrix, add, multiply):
    return add(*[
        multiply(matrix[0][permutation[0]], matrix[1][permutation[1]],
                 matrix[2][permutation[2]])
        for permutation in itertools.permutations(range(3))
    ])


def input_measure(terms, measure):
    return measure(terms)


def forward_bounds(forward, measure, zero, one, a_value, b_value, add, multiply):
    slices = [[input_measure(entry, measure) for entry in row]
              for row in forward["slice_rows"]]
    tangents = [[input_measure(entry, measure) for entry in row]
                for row in forward["tangent_rows"]]
    constants = [one] * 5
    linear = [[zero] * 3 for _ in range(16)]
    fixed = [
        (5, (0, 0, 1)), (6, (0, 1, 0)), (7, (0, 1, -1)),
        (9, (1, 0, 0)), (10, (1, 0, -1)), (12, (1, -1, 0)),
    ]
    for index, coefficients in fixed:
        linear[index] = [one if coefficient else zero for coefficient in coefficients]
    linear[8] = [b_value, b_value, a_value]
    linear[11] = [b_value, zero, one]
    linear[13] = [a_value, one, zero]
    linear[14] = [add(a_value, b_value), add(one, b_value), add(a_value, one)]
    matrix = [[
        add(*[multiply(slices[row][index], linear[index][variable])
              for index in range(16)])
        for variable in range(3)
    ] for row in range(3)]
    rhs = [add(*[slices[row][index] for index in range(5)]) for row in range(3)]
    delta = determinant_bound(matrix, add, multiply)
    z_values = []
    for column in range(3):
        replaced = [row[:] for row in matrix]
        for row in range(3):
            replaced[row][column] = rhs[row]
        z_values.append(determinant_bound(replaced, add, multiply))
    scaled_cox = [multiply(delta, delta)] * 5 + [zero] * 11
    for index in range(5, 15):
        scaled_cox[index] = add(*[
            multiply(linear[index][variable], z_values[variable], delta)
            for variable in range(3)
        ])
    scaled_cox[15] = add(
        multiply(b_value, add(one, a_value), z_values[0], z_values[1]),
        multiply(a_value, add(one, b_value), z_values[0], z_values[2]),
        multiply(add(a_value, b_value), z_values[1], z_values[2]),
    )
    return [add(*[
        multiply(coefficient, coordinate)
        for coefficient, coordinate in zip(row, scaled_cox)
    ]) for row in tangents]


def residual_bounds(forward, inverse, measure, zero, one, a_value, b_value,
                    add, multiply, power):
    rho = forward_bounds(
        forward, measure, zero, one, a_value, b_value, add, multiply,
    )
    exponent_order = [entries for entries in itertools.product(range(6), repeat=4)
                      if sum(entries) <= 5]
    answers = []
    for vector in inverse["vectors"]:
        terms = []
        for item in vector:
            affine = exponent_order[item["inverse_vector_index"] % 126]
            exponents = (5 - sum(affine), *affine)
            terms.append(multiply(
                input_measure(item["coefficient_polynomial"], measure),
                *[power(value, exponent) for value, exponent in zip(rho, exponents)],
            ))
        answers.append(add(*terms))
    return rho, answers


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("forward", type=Path)
    parser.add_argument("inverse", type=Path)
    parser.add_argument("rho_summary", type=Path)
    parser.add_argument("--write", type=Path)
    arguments = parser.parse_args()
    forward = json.loads(arguments.forward.read_text())
    inverse = json.loads(arguments.inverse.read_text())
    rho_summary = json.loads(arguments.rho_summary.read_text())
    assert rho_summary["schema"] == "c958-generic-rho-summary-v1"
    assert rho_summary["forward_sha256"] == hashlib.sha256(
        arguments.forward.read_bytes()
    ).hexdigest()

    degree_zero = (-1, -1)

    def degree_measure(terms):
        return tuple(max((term["parameter_exponents"][index] for term in terms),
                         default=-1) for index in range(2))

    def degree_add(*values):
        return tuple(max(value[index] for value in values) for index in range(2))

    def degree_multiply(*values):
        if any(value == degree_zero for value in values):
            return degree_zero
        return tuple(sum(value[index] for value in values) for index in range(2))

    def degree_power(value, exponent):
        return tuple(component * exponent for component in value)

    rho_degrees, residual_degrees = residual_bounds(
        forward, inverse, degree_measure, degree_zero, (0, 0), (1, 0), (0, 1),
        degree_add, degree_multiply, degree_power,
    )

    def norm_measure(terms):
        return sum(abs(int(term["coefficient"])) for term in terms)

    rho_norms = [int(value) for value in rho_summary["rho_l1_norms"]]
    exponent_order = [entries for entries in itertools.product(range(6), repeat=4)
                      if sum(entries) <= 5]
    residual_norm_bounds = []
    for vector in inverse["vectors"]:
        bound = 0
        for item in vector:
            affine = exponent_order[item["inverse_vector_index"] % 126]
            exponents = (5 - sum(affine), *affine)
            bound += norm_measure(item["coefficient_polynomial"]) * math.prod(
                value**exponent for value, exponent in zip(rho_norms, exponents)
            )
        residual_norm_bounds.append(bound)
    maximum_degree = tuple(max(value[index] for value in residual_degrees)
                           for index in range(2))
    maximum_norm_bound = max(residual_norm_bounds)
    assert all(prime < 2**64 and is_prime_u64(prime) for prime in PRIMES)
    prime_product = math.prod(PRIMES)
    assert maximum_degree == (69, 88), maximum_degree
    assert prime_product > 2 * maximum_norm_bound
    payload = {
        "schema": "c958-generic-identity-bound-v1",
        "input_sha256": {
            str(arguments.forward): hashlib.sha256(arguments.forward.read_bytes()).hexdigest(),
            str(arguments.inverse): hashlib.sha256(arguments.inverse.read_bytes()).hexdigest(),
            str(arguments.rho_summary): hashlib.sha256(
                arguments.rho_summary.read_bytes()
            ).hexdigest(),
        },
        "rho_parameter_degree_bounds": rho_degrees,
        "residual_parameter_degree_bounds": residual_degrees,
        "residual_l1_norm_bounds": [str(value) for value in residual_norm_bounds],
        "kronecker_base": maximum_degree[1] + 1,
        "primes": PRIMES,
        "primality_check": (
            "deterministic Miller-Rabin for n<2^64 with bases "
            "2,325,9375,28178,450775,9780504,1795265022"
        ),
        "prime_product": str(prime_product),
        "twice_maximum_l1_bound": str(2 * maximum_norm_bound),
        "conclusion": (
            "Zero residuals modulo every listed prime after a=t^89,b=t imply "
            "zero residuals over Z: the encoding is injective through bidegree "
            "(69,88), and the prime product exceeds twice every coefficient bound."
        ),
    }
    if arguments.write:
        arguments.write.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"residual_degree_bounds={residual_degrees}")
    print(f"maximum_l1_bound_digits={len(str(maximum_norm_bound))}")
    print(f"prime_product_digits={len(str(prime_product))}")
    print(f"prime_product_margin={prime_product // (2 * maximum_norm_bound)}")


if __name__ == "__main__":
    main()
