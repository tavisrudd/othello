#!/usr/bin/env python3
"""Deterministic finite-field grid check for the C958 generic identity."""

import argparse
import itertools
import json
from pathlib import Path
import sys

from flint import nmod_mpoly_ctx

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


def determinant3(matrix):
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    )


def horner(terms, variable, rho, ctx):
    if not terms:
        return ctx.constant(0)
    if variable == 5:
        return sum((term[0] for term in terms), ctx.constant(0))
    groups = [[] for _ in range(6)]
    for term in terms:
        groups[term[1][variable]].append(term)
    maximum = max(index for index, group in enumerate(groups) if group)
    answer = horner(groups[maximum], variable + 1, rho, ctx)
    for exponent in reversed(range(maximum)):
        answer *= rho[variable]
        if groups[exponent]:
            answer += horner(groups[exponent], variable + 1, rho, ctx)
    return answer


def parameter_value(terms, t_value, base, prime):
    a_value = pow(t_value, base, prime)
    return sum(
        int(term["coefficient"])
        * pow(a_value, term["parameter_exponents"][0], prime)
        * pow(t_value, term["parameter_exponents"][1], prime)
        for term in terms
    ) % prime


def check_at_t(forward, inverse, ctx, prime, base, t_value, exponent_order):
    e1, e2, e4, e5 = ctx.gens()
    one = ctx.constant(1)
    a = ctx.constant(pow(t_value, base, prime))
    b = ctx.constant(t_value)
    slices = [[ctx.constant(parameter_value(entry, t_value, base, prime))
               for entry in row] for row in forward["slice_rows"]]
    tangents = [[ctx.constant(parameter_value(entry, t_value, base, prime))
                 for entry in row] for row in forward["tangent_rows"]]
    product = e1 * e2 * e4 * e5
    constants = [product * e1, product * e2, product, product * e4, product * e5]
    linear = [[ctx.constant(0) for _ in range(3)] for _ in range(16)]
    fixed = [
        (5, e4 * e5, (0, 0, 1)), (6, e2 * e4 * e5, (0, 1, 0)),
        (7, e2 * e5, (0, 1, -1)), (9, e1 * e4 * e5, (1, 0, 0)),
        (10, e1 * e5, (1, 0, -1)), (12, e1 * e2 * e5, (1, -1, 0)),
    ]
    for index, monomial, coefficients in fixed:
        linear[index] = [coefficient * monomial for coefficient in coefficients]
    linear[8] = [ctx.constant(0), b * e2 * e4, -a * e2 * e4]
    linear[11] = [b * e1 * e4, ctx.constant(0), -e1 * e4]
    linear[13] = [a * e1 * e2 * e4, -e1 * e2 * e4, ctx.constant(0)]
    linear[14] = [
        (b - a) * e1 * e2, (1 - b) * e1 * e2, (a - 1) * e1 * e2,
    ]
    matrix = [[ctx.constant(0) for _ in range(3)] for _ in range(3)]
    rhs = [ctx.constant(0) for _ in range(3)]
    for row in range(3):
        rhs[row] = -sum(
            (slices[row][index] * constants[index] for index in range(5)),
            ctx.constant(0),
        )
        for variable in range(3):
            matrix[row][variable] = sum(
                (slices[row][index] * linear[index][variable] for index in range(16)),
                ctx.constant(0),
            )
        assert not slices[row][15]
    delta = determinant3(matrix)
    z_values = []
    for column in range(3):
        replaced = [row[:] for row in matrix]
        for row in range(3):
            replaced[row][column] = rhs[row]
        z_values.append(determinant3(replaced))
    scaled_cox = [ctx.constant(0) for _ in range(16)]
    for index in range(5):
        scaled_cox[index] = constants[index] * delta * delta
    for index in range(5, 15):
        scaled_cox[index] = sum(
            (linear[index][variable] * z_values[variable] * delta
             for variable in range(3)),
            ctx.constant(0),
        )
    scaled_cox[15] = (
        b * (1 - a) * z_values[0] * z_values[1]
        + a * (b - 1) * z_values[0] * z_values[2]
        + (a - b) * z_values[1] * z_values[2]
    )
    rho = [sum(
        (coefficient * coordinate for coefficient, coordinate in zip(row, scaled_cox)),
        ctx.constant(0),
    ) for row in tangents]
    e_coordinates = [e1, e2, e4, e5]
    for target, vector in enumerate(inverse["vectors"]):
        terms = []
        for item in vector:
            index = item["inverse_vector_index"]
            affine = exponent_order[index % 126]
            coefficient = ctx.constant(parameter_value(
                item["coefficient_polynomial"], t_value, base, prime,
            ))
            if index >= 126:
                coefficient *= -e_coordinates[target]
            terms.append((coefficient, (5 - sum(affine), *affine)))
        residual = horner(terms, 0, rho, ctx)
        if residual:
            raise AssertionError(f"nonzero residual at t={t_value}, target={target}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("forward", type=Path)
    parser.add_argument("inverse", type=Path)
    parser.add_argument("--prime", type=int, required=True)
    parser.add_argument("--base", type=int, default=89)
    parser.add_argument("--start", type=int, default=0)
    parser.add_argument("--stop", type=int, default=6230)
    parser.add_argument("--milestone", type=int, default=500)
    arguments = parser.parse_args()
    assert 0 <= arguments.start < arguments.stop <= arguments.prime
    forward = json.loads(arguments.forward.read_text())
    inverse = json.loads(arguments.inverse.read_text())
    ctx = nmod_mpoly_ctx.get(("e1", "e2", "e4", "e5"), modulus=arguments.prime)
    exponent_order = [entries for entries in itertools.product(range(6), repeat=4)
                      if sum(entries) <= 5]
    for t_value in range(arguments.start, arguments.stop):
        check_at_t(
            forward, inverse, ctx, arguments.prime, arguments.base, t_value,
            exponent_order,
        )
        completed = t_value + 1
        if arguments.milestone and completed % arguments.milestone == 0:
            print(f"prime={arguments.prime} checked_through_t={t_value}", flush=True)
    print(
        f"prime={arguments.prime} zero_grid=[{arguments.start},{arguments.stop}) "
        f"kronecker_base={arguments.base}",
        flush=True,
    )


if __name__ == "__main__":
    main()
