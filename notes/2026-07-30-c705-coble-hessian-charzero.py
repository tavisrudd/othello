#!/usr/bin/env python3
"""Exact characteristic-zero certificate for the Coble Hessian identity.

For the fixed rational Burkhardt parameter (6,17,1,-7,-19), reconstruct the
dual Coble sextic in the 43-dimensional Heisenberg-invariant orbit basis from
exact rational conormal points.  The coefficient vector is normalized by
making its first nonzero entry one.  Evaluate the inverse-polar scalar at one
rational point and compare it with the source Hessian determinant.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import math
from pathlib import Path

import sympy as sp
from sympy.ntheory.modular import crt
from sympy.polys.domains import ZZ
from sympy.polys.modulargcd import _integer_rational_reconstruction

ALPHA = (6, 17, 1, -7, -19)
PRIME = 101
STEM = Path(__file__).with_suffix("")
JSON_PATH = STEM.with_suffix(".json")
SINGULAR_PATH = STEM.with_suffix(".sing")
FINITE_SCRIPT = Path(__file__).with_name("2026-07-30-c705-coble-mixed-jacobian.py")


def load_finite_module():
    spec = importlib.util.spec_from_file_location("c705_coble_finite", FINITE_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def add_term(poly, exp, coefficient):
    if coefficient:
        poly[exp] = poly.get(exp, 0) + coefficient
        if not poly[exp]:
            del poly[exp]


def monomial(indices):
    exp = [0] * 9
    for index in indices:
        exp[index] += 1
    return tuple(exp)


def coble_cubic():
    poly = {}
    for index in range(9):
        exp = [0] * 9
        exp[index] = 3
        add_term(poly, tuple(exp), ALPHA[0])
    line_families = [
        [(3 * row, 3 * row + 1, 3 * row + 2) for row in range(3)],
        [(column, 3 + column, 6 + column) for column in range(3)],
        [(0, 4, 8), (1, 5, 6), (2, 3, 7)],
        [(0, 5, 7), (1, 3, 8), (2, 4, 6)],
    ]
    for parameter, lines in zip(ALPHA[1:], line_families):
        for line in lines:
            add_term(poly, monomial(line), 6 * parameter)
    return poly


def evaluate(poly, point):
    return sum(
        coefficient
        * math.prod(point[index] ** exponent for index, exponent in enumerate(exp))
        for exp, coefficient in poly.items()
    )


def derivative(poly, index):
    out = {}
    for exp, coefficient in poly.items():
        if exp[index]:
            reduced = list(exp)
            reduced[index] -= 1
            add_term(out, tuple(reduced), coefficient * exp[index])
    return out


def orbit_evaluate(orbit, point):
    return sum(
        math.prod(point[index] ** exponent for index, exponent in enumerate(exp))
        for exp in orbit
    )


def orbit_derivative_evaluate(orbit, index, point):
    total = 0
    for exp in orbit:
        if not exp[index]:
            continue
        total += exp[index] * math.prod(
            point[j] ** (power - (1 if j == index else 0))
            for j, power in enumerate(exp)
        )
    return total


def primitive(vector):
    divisor = math.gcd(*vector)
    if divisor:
        vector = [value // divisor for value in vector]
    first = next((value for value in vector if value), 1)
    if first < 0:
        vector = [-value for value in vector]
    return vector


def rational_conormal_samples(cubic, count):
    derivatives = [derivative(cubic, index) for index in range(9)]
    hessian_polys = [
        [derivative(derivatives[i], j) for j in range(9)] for i in range(9)
    ]
    base = (2, -2, -2, -4, 2, 2, -3, -1, -3)
    assert evaluate(cubic, base) == 0
    base_gradient = [evaluate(poly, base) for poly in derivatives]
    pivot = next(index for index, value in enumerate(base_gradient) if value)
    samples = []
    counter = 0
    while len(samples) < count:
        digest = hashlib.sha256(f"c705-coble-charzero-{counter}".encode()).digest()
        counter += 1
        raw = [digest[index] % 7 - 3 for index in range(9)]
        raw[pivot] = 0
        direction = [value * base_gradient[pivot] for value in raw]
        direction[pivot] = -sum(
            base_gradient[index] * raw[index] for index in range(9)
        )
        quadratic = sum(
            direction[i]
            * evaluate(hessian_polys[i][j], base)
            * direction[j]
            for i in range(9)
            for j in range(9)
        ) // 2
        cubic_value = evaluate(cubic, direction)
        if not quadratic or not cubic_value:
            continue
        point = primitive(
            [cubic_value * base[i] - quadratic * direction[i] for i in range(9)]
        )
        if not any(point) or evaluate(cubic, point):
            continue
        # Keep the literal gradient normalization: the inverse-polar scalar
        # has weight five in this conormal coordinate.
        gradient = [evaluate(poly, point) for poly in derivatives]
        pair = (tuple(point), tuple(gradient))
        if pair not in samples:
            samples.append(pair)
    return samples, derivatives, hessian_polys


def rational_mod(value, prime):
    value = sp.Rational(value)
    return int(value.p % prime) * pow(int(value.q % prime), prime - 2, prime) % prime


def polynomial_string(poly, variables):
    terms = []
    for exp, coefficient in sorted(poly.items(), reverse=True):
        if not coefficient:
            continue
        monomial = "*".join(
            f"{variable}^{power}" if power != 1 else variable
            for variable, power in zip(variables, exp)
            if power
        )
        terms.append(f"({coefficient})" + (f"*{monomial}" if monomial else ""))
    return "+".join(terms) or "0"


def singular_certificate(cubic, orbits, coefficients):
    cleared = [int(27 * coefficient) for coefficient in coefficients]
    dual = {}
    for orbit, coefficient in zip(orbits, cleared):
        for exp in orbit:
            add_term(dual, exp, coefficient)
    yvars = [f"y{index}" for index in range(9)]
    xvars = [f"x{index}" for index in range(9)]
    return f"""// Generated by {Path(__file__).name}; do not edit.
ring s=0,({','.join(yvars)}),dp;
poly H={polynomial_string(dual, yvars)};
ideal dH=jacob(H);
ring r=0,({','.join(xvars)}),dp;
poly F={polynomial_string(cubic, xvars)};
matrix HessF=jacob(jacob(F));
poly Delta=det(HessF);
ideal IF=F;
ideal GB=std(IF);
map polar=s,diff(F,x0),diff(F,x1),diff(F,x2),diff(F,x3),diff(F,x4),
  diff(F,x5),diff(F,x6),diff(F,x7),diff(F,x8);
ideal polar_dH=polar(dH);
poly rem;
for (int i=1; i<=9; i++)
{{
  rem=reduce(2592*polar_dH[i]+Delta*var(i),GB);
  if (rem!=0) {{ print(\"FAIL component \"+string(i)); exit(1); }}
}}
print(\"PASS 9 exact characteristic-zero components\");
"""


def modular_nullvector(rows, prime):
    matrix = [[value % prime for value in row] for row in rows]
    pivots = []
    rank = 0
    for column in range(len(matrix[0])):
        pivot = next(
            (row for row in range(rank, len(matrix)) if matrix[row][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], prime - 2, prime)
        matrix[rank] = [value * inverse % prime for value in matrix[rank]]
        for row in range(len(matrix)):
            if row != rank and matrix[row][column]:
                multiplier = matrix[row][column]
                matrix[row] = [
                    (left - multiplier * right) % prime
                    for left, right in zip(matrix[row], matrix[rank])
                ]
        pivots.append(column)
        rank += 1
    free = [column for column in range(len(matrix[0])) if column not in pivots]
    assert rank == len(rows) and len(free) == 1
    vector = [0] * len(matrix[0])
    vector[free[0]] = 1
    for row in range(rank - 1, -1, -1):
        vector[pivots[row]] = -sum(
            matrix[row][column] * vector[column]
            for column in range(len(vector))
        ) % prime
    first = next(value for value in vector if value)
    inverse = pow(first, prime - 2, prime)
    return [value * inverse % prime for value in vector]


def compute():
    finite = load_finite_module()
    orbits = finite.invariant_orbits()
    assert len(orbits) == 43
    cubic = coble_cubic()
    samples, derivatives, hessian_polys = rational_conormal_samples(cubic, 60)
    rows = []
    for _, conormal in samples:
        rows.append(primitive([orbit_evaluate(orbit, conormal) for orbit in orbits]))

    primes = (1000000007, 1000000009, 1000000033)
    modular_vectors = [modular_nullvector(rows[:42], prime) for prime in primes]
    modulus = math.prod(primes)
    coefficients = []
    for index in range(43):
        residue = int(crt(primes, [vector[index] for vector in modular_vectors])[0])
        value = _integer_rational_reconstruction(residue, modulus, ZZ)
        assert value is not None
        coefficients.append(sp.Rational(value))
    assert all(
        sum(coefficient * value for coefficient, value in zip(coefficients, row)) == 0
        for row in rows
    )

    base, base_conormal = samples[0]
    polar_back = [
        sum(
            coefficient * orbit_derivative_evaluate(orbit, index, base_conormal)
            for coefficient, orbit in zip(coefficients, orbits)
        )
        for index in range(9)
    ]
    pivot = next(index for index, value in enumerate(base) if value)
    inverse_scalar = sp.cancel(polar_back[pivot] / base[pivot])
    assert all(
        polar_back[index] == inverse_scalar * base[index] for index in range(9)
    )
    hessian = sp.Matrix(
        [
            [evaluate(hessian_polys[i][j], base) for j in range(9)]
            for i in range(9)
        ]
    )
    hessian_determinant = hessian.det(method="domain-ge")
    proportionality_scalar = sp.cancel(inverse_scalar / hessian_determinant)

    finite_coefficients = finite.compute()["dual_sextic_orbit_coefficients"]
    reduced = [rational_mod(value, PRIME) for value in coefficients]
    scale = next(
        finite_coefficients[index] * pow(reduced[index], PRIME - 2, PRIME) % PRIME
        for index in range(43)
        if reduced[index]
    )
    assert all(
        finite_coefficients[index] == scale * reduced[index] % PRIME
        for index in range(43)
    )
    assert rational_mod(proportionality_scalar, PRIME) == 45 * pow(scale, PRIME - 2, PRIME) % PRIME

    result = {
        "schema": "c705-coble-hessian-charzero-v1",
        "alpha": ALPHA,
        "cubic_normalization": "3 times Nguyen equation (5)",
        "dual_sextic_normalization": "first nonzero Heisenberg-orbit coefficient equals 1",
        "orbit_basis_dimension": len(orbits),
        "exact_conormal_samples": len(samples),
        "interpolation_rows": 42,
        "interpolation_rank": 42,
        "reconstruction_primes": primes,
        "held_out_rows": len(rows) - 42,
        "dual_sextic_orbit_coefficients": [str(value) for value in coefficients],
        "scalar_witness": {
            "x": base,
            "y": base_conormal,
            "inverse_polar_scalar": str(inverse_scalar),
            "source_hessian_determinant": str(hessian_determinant),
            "lambda_over_hessian_determinant": str(proportionality_scalar),
        },
        "mod_101_cross_check": {
            "finite_vector_scale_from_charzero_vector": scale,
            "finite_lambda_over_hessian_determinant": 45,
            "checked_coefficients": len(coefficients),
        },
        "symbolic_identity_on_coble_cubic": (
            "69984*grad(H)(grad(F)) + det(Hess(F))*x = 0 mod (F)"
        ),
    }
    return result, singular_certificate(cubic, orbits, coefficients)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result, singular_text = compute()
    text = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        JSON_PATH.write_text(text)
        SINGULAR_PATH.write_text(singular_text)
    elif args.check:
        if (
            not JSON_PATH.exists()
            or JSON_PATH.read_text() != text
            or not SINGULAR_PATH.exists()
            or SINGULAR_PATH.read_text() != singular_text
        ):
            raise SystemExit(f"certificate mismatch: regenerate with {Path(__file__).name} --write")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
