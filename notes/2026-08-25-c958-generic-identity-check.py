#!/usr/bin/env python3
"""FLINT coefficientwise generic identity check for the C958 quintic inverse."""

import argparse
import hashlib
import itertools
import json
from pathlib import Path
import sys

from flint import fmpz_mod_mpoly_ctx, fmpz_mpoly_ctx, nmod_mpoly_ctx

if sys.flags.optimize:
    raise RuntimeError("verification must run with Python assertions enabled")


PRIME = 1_000_133


def determinant3(matrix):
    return (
        matrix[0][0] * (matrix[1][1]*matrix[2][2] - matrix[1][2]*matrix[2][1])
        - matrix[0][1] * (matrix[1][0]*matrix[2][2] - matrix[1][2]*matrix[2][0])
        + matrix[0][2] * (matrix[1][0]*matrix[2][1] - matrix[1][1]*matrix[2][0])
    )


def parameter_polynomial(ctx, terms, modulus, parameter_values, kronecker_base):
    if parameter_values is not None:
        a_value, b_value = parameter_values
        value = sum(
            int(term["coefficient"])
            * a_value**term["parameter_exponents"][0]
            * b_value**term["parameter_exponents"][1]
            for term in terms
        )
        if modulus is not None:
            value %= modulus
        return ctx.constant(value)
    if kronecker_base is not None:
        return ctx.from_dict({
            (term["parameter_exponents"][0] * kronecker_base
             + term["parameter_exponents"][1], 0, 0, 0, 0):
            (int(term["coefficient"]) if modulus is None
             else int(term["coefficient"]) % modulus)
            for term in terms
        })
    return ctx.from_dict({
        (term["parameter_exponents"][0], term["parameter_exponents"][1], 0, 0, 0, 0):
        (int(term["coefficient"]) if modulus is None
         else int(term["coefficient"]) % modulus)
        for term in terms
    })


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


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("forward", type=Path)
    parser.add_argument("inverse", type=Path)
    parser.add_argument(
        "--integer", action="store_true",
        help="check coefficientwise over Z instead of modulo the fresh prime",
    )
    parser.add_argument(
        "--prime", type=int, default=PRIME,
        help="prime modulus for a modular check",
    )
    parser.add_argument(
        "--modulus", type=int,
        help="arbitrary-precision modulus (need not be prime)",
    )
    parser.add_argument(
        "--specialize", nargs=2, type=int, metavar=("A", "B"),
        help="specialize the two parameters before constructing the residual",
    )
    parser.add_argument(
        "--kronecker-base", type=int,
        help="substitute a=t^BASE and b=t for an injective bidegree encoding",
    )
    parser.add_argument(
        "--rho-only", action="store_true",
        help="construct the five forward coordinates and stop before residuals",
    )
    parser.add_argument(
        "--write-rho-summary", type=Path,
        help="write exact term counts and L1 norms (requires --integer --rho-only)",
    )
    arguments = parser.parse_args()
    forward = json.loads(arguments.forward.read_text())
    inverse = json.loads(arguments.inverse.read_text())
    if arguments.specialize is not None and arguments.kronecker_base is not None:
        parser.error("--specialize and --kronecker-base are mutually exclusive")
    if arguments.integer and arguments.modulus is not None:
        parser.error("--integer and --modulus are mutually exclusive")
    modulus = (None if arguments.integer else
               arguments.modulus if arguments.modulus is not None else arguments.prime)
    parameter_values = arguments.specialize
    kronecker_base = arguments.kronecker_base
    if parameter_values is not None:
        names = ("e1", "e2", "e4", "e5")
    elif kronecker_base is not None:
        names = ("t", "e1", "e2", "e4", "e5")
    else:
        names = ("a", "b", "e1", "e2", "e4", "e5")
    if modulus is None:
        ctx = fmpz_mpoly_ctx.get(names)
    elif arguments.modulus is not None:
        ctx = fmpz_mod_mpoly_ctx.get(names, modulus=modulus)
    else:
        ctx = nmod_mpoly_ctx.get(names, modulus=modulus)
    if parameter_values is None and kronecker_base is None:
        a, b, e1, e2, e4, e5 = ctx.gens()
    elif kronecker_base is not None:
        t, e1, e2, e4, e5 = ctx.gens()
        a = t**kronecker_base
        b = t
    else:
        e1, e2, e4, e5 = ctx.gens()
        a = ctx.constant(parameter_values[0])
        b = ctx.constant(parameter_values[1])
    one = ctx.constant(1)
    slices = [[parameter_polynomial(
        ctx, entry, modulus, parameter_values, kronecker_base,
    ) for entry in row]
              for row in forward["slice_rows"]]
    tangents = [[parameter_polynomial(
        ctx, entry, modulus, parameter_values, kronecker_base,
    ) for entry in row]
                for row in forward["tangent_rows"]]
    p = e1*e2*e4*e5
    constants = [p*e1, p*e2, p, p*e4, p*e5]
    linear = [[ctx.constant(0) for _ in range(3)] for _ in range(16)]
    fixed = [
        (5, e4*e5, (0, 0, 1)), (6, e2*e4*e5, (0, 1, 0)),
        (7, e2*e5, (0, 1, -1)), (9, e1*e4*e5, (1, 0, 0)),
        (10, e1*e5, (1, 0, -1)), (12, e1*e2*e5, (1, -1, 0)),
    ]
    for index, monomial, coefficients in fixed:
        linear[index] = [coefficient*monomial for coefficient in coefficients]
    linear[8] = [ctx.constant(0), b*e2*e4, -a*e2*e4]
    linear[11] = [b*e1*e4, ctx.constant(0), -e1*e4]
    linear[13] = [a*e1*e2*e4, -e1*e2*e4, ctx.constant(0)]
    linear[14] = [(b-a)*e1*e2, (1-b)*e1*e2, (a-1)*e1*e2]

    matrix = [[ctx.constant(0) for _ in range(3)] for _ in range(3)]
    rhs = [ctx.constant(0) for _ in range(3)]
    for row in range(3):
        rhs[row] = -sum((slices[row][index]*constants[index] for index in range(5)),
                        ctx.constant(0))
        for variable in range(3):
            matrix[row][variable] = sum(
                (slices[row][index]*linear[index][variable] for index in range(16)),
                ctx.constant(0),
            )
        assert not slices[row][15]
    delta = determinant3(matrix)
    z = []
    for column in range(3):
        replaced = [row[:] for row in matrix]
        for row in range(3):
            replaced[row][column] = rhs[row]
        z.append(determinant3(replaced))
    delta_squared = delta*delta
    scaled_cox = [ctx.constant(0) for _ in range(16)]
    for index in range(5):
        scaled_cox[index] = constants[index]*delta_squared
    for index in range(5, 15):
        scaled_cox[index] = sum(
            (linear[index][variable]*z[variable]*delta for variable in range(3)),
            ctx.constant(0),
        )
    scaled_cox[15] = b*(1-a)*z[0]*z[1] + a*(b-1)*z[0]*z[2] + (a-b)*z[1]*z[2]
    rho = [sum((coefficient*coordinate for coefficient, coordinate in zip(row, scaled_cox)),
               ctx.constant(0)) for row in tangents]
    rho_terms = [len(item) for item in rho]
    print("rho_terms", rho_terms, flush=True)
    if arguments.rho_only:
        if modulus is None:
            rho_l1_norms = [
                sum(abs(int(coefficient)) for _, coefficient in item.terms())
                for item in rho
            ]
            print("rho_l1_norms", rho_l1_norms)
            if arguments.write_rho_summary:
                payload = {
                    "schema": "c958-generic-rho-summary-v1",
                    "forward_sha256": hashlib.sha256(arguments.forward.read_bytes()).hexdigest(),
                    "rho_term_counts": rho_terms,
                    "rho_l1_norms": [str(value) for value in rho_l1_norms],
                }
                arguments.write_rho_summary.write_text(
                    json.dumps(payload, indent=2, sort_keys=True) + "\n"
                )
        elif arguments.write_rho_summary:
            parser.error("--write-rho-summary requires --integer")
        return

    exponent_order = [entries for entries in itertools.product(range(6), repeat=4)
                      if sum(entries) <= 5]
    e_coordinates = [e1, e2, e4, e5]
    for target, vector in enumerate(inverse["vectors"]):
        terms = []
        for item in vector:
            index = item["inverse_vector_index"]
            affine = exponent_order[index % 126]
            coefficient = parameter_polynomial(
                ctx, item["coefficient_polynomial"], modulus, parameter_values,
                kronecker_base,
            )
            if index >= 126:
                coefficient *= -e_coordinates[target]
            terms.append((coefficient, (5-sum(affine), *affine)))
        residual = horner(terms, 0, rho, ctx)
        assert not residual
        if modulus is None:
            print(f"target={target} exact_generic_identity_over=Z")
        else:
            print(f"target={target} exact_generic_identity_modulo={modulus}")


if __name__ == "__main__":
    main()
