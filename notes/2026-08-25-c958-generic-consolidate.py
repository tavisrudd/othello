#!/usr/bin/env python3
"""Consolidate rational C958 coefficients to one polynomial projective vector."""

import argparse
import functools
import json
import math
from pathlib import Path

import sympy as sp


def polynomial(terms, a, b):
    return sp.Poly(sum(
        sp.Rational(term["coefficient"])
        * a**term["parameter_exponents"][0]
        * b**term["parameter_exponents"][1]
        for term in terms
    ), a, b, domain=sp.QQ)


def sparse(poly, scale):
    return [
        {"coefficient": str(int(coefficient * scale)), "parameter_exponents": list(exponents)}
        for exponents, coefficient in sorted(poly.terms()) if coefficient
    ]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    parser.add_argument("--write", type=Path, required=True)
    arguments = parser.parse_args()
    data = json.loads(arguments.certificate.read_text())
    a, b = sp.symbols("a b")
    parsed = []
    denominators = []
    for vector in data["vectors"]:
        parsed_vector = []
        for coefficient in vector:
            numerator = polynomial(coefficient["numerator"], a, b)
            denominator = polynomial(coefficient["denominator"], a, b)
            parsed_vector.append((coefficient["inverse_vector_index"], numerator, denominator))
            denominators.append(denominator.monic())
        parsed.append(parsed_vector)
    unique_denominators = list({tuple(poly.terms()): poly for poly in denominators}.values())
    common = functools.reduce(sp.lcm, unique_denominators).monic()
    assert common.degree_list() == (6, 7)

    consolidated = []
    all_polynomials = [common]
    for vector in parsed:
        result = []
        for index, numerator, denominator in vector:
            expression = sp.cancel(numerator.as_expr() * common.as_expr() / denominator.as_expr())
            coefficient = sp.Poly(expression, a, b, domain=sp.QQ)
            result.append((index, coefficient))
            all_polynomials.append(coefficient)
        consolidated.append(result)
    coefficient_lcm = math.lcm(*(
        int(value.q) for poly in all_polynomials for _, value in poly.terms()
    ))
    integer_values = [int(value * coefficient_lcm)
                      for poly in all_polynomials for _, value in poly.terms()]
    common_gcd = math.gcd(*integer_values)
    scale = sp.Rational(coefficient_lcm, common_gcd)
    if next(value for value in integer_values if value) < 0:
        scale = -scale

    output_vectors = []
    for vector in consolidated:
        output_vectors.append([
            {"inverse_vector_index": index, "coefficient_polynomial": sparse(poly, scale)}
            for index, poly in vector
        ])
    denominator_parts = [
        {item["inverse_vector_index"]: item["coefficient_polynomial"]
         for item in vector if item["inverse_vector_index"] >= 126}
        for vector in output_vectors
    ]
    assert all(part == denominator_parts[0] for part in denominator_parts)
    payload = {
        "schema": "c958-generic-polynomial-inverse-v1",
        "inverse_degree": 5,
        "parameter_degree_bounds": {"a": 6, "b": 7},
        "common_coefficient_denominator": sparse(common, scale),
        "vectors": output_vectors,
        "maximum_integer_coefficient_digits": max(
            len(item["coefficient"].lstrip("-"))
            for vector in output_vectors for coefficient in vector
            for item in coefficient["coefficient_polynomial"]
        ),
        "source_reconstruction_primes": data["reconstruction_primes"],
    }
    arguments.write.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"distinct_denominators={len(unique_denominators)} common_degree={common.degree_list()} ")
    print(f"maximum_integer_coefficient_digits={payload['maximum_integer_coefficient_digits']}")


if __name__ == "__main__":
    main()
