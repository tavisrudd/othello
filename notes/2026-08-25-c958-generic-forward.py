#!/usr/bin/env python3
"""Export denominator-cleared generic C958 slice and tangent rows."""

import argparse
import functools
import hashlib
import importlib.util
import json
import math
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
GENERATOR = ROOT / "notes/2026-08-24-c958-generic-split-parametrization.py"
CERTIFICATE = ROOT / "notes/2026-08-24-c958-generic-split-parametrization.json"
TANGENT_ROW_INDICES = [0, 1, 2, 4, 7]


def load_generator():
    spec = importlib.util.spec_from_file_location("c958_split", GENERATOR)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sparse(poly, scale):
    return [
        {"coefficient": str(int(coefficient * scale)), "parameter_exponents": list(exponents)}
        for exponents, coefficient in sorted(poly.terms()) if coefficient
    ]


def clear_parameter_denominators(expressions, a, b):
    denominators = [sp.Poly(sp.denom(sp.cancel(expression)), a, b, domain=sp.QQ).monic()
                    for expression in expressions]
    common = sp.Poly(1, a, b, domain=sp.QQ)
    for denominator in denominators:
        common = sp.lcm(common, denominator).monic()
    polynomials = [sp.Poly(sp.cancel(expression * common.as_expr()), a, b, domain=sp.QQ)
                   for expression in expressions]
    return common, polynomials


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path, required=True)
    arguments = parser.parse_args()
    generic = load_generator()
    source = generic.load_source()
    lattice = source.type_i3_lattice_data()
    cox_names = lattice["cox_names"]
    symbols, _, _, jacobian, rows, _ = source.cox_data(cox_names)
    a, b, z1, z2, z3 = symbols
    split = json.loads(CERTIFICATE.read_text())
    slice_expressions = [[sp.sympify(entry, locals={"a": a, "b": b}) for entry in row]
                         for row in split["slice_hyperplane_coefficients"]]
    slice_cleared = [clear_parameter_denominators(row, a, b) for row in slice_expressions]
    slice_denominators = [item[0] for item in slice_cleared]
    slice_rows = [item[1] for item in slice_cleared]
    tangent_matrix = jacobian[list(rows), :].subs({z1: 1, z2: 3, z3: 7})
    tangent_expressions = [
        [tangent_matrix[index, column] for column in range(16)]
        for index in TANGENT_ROW_INDICES
    ]
    tangent_denominator, tangent_flat = clear_parameter_denominators(
        [entry for row in tangent_expressions for entry in row], a, b)
    tangent_rows = [tangent_flat[index:index + 16]
                    for index in range(0, len(tangent_flat), 16)]
    slice_scales = [math.lcm(*(int(value.q) for poly in row for _, value in poly.terms()))
                    for row in slice_rows]
    tangent_scale = math.lcm(*(
        int(value.q) for row in tangent_rows for poly in row for _, value in poly.terms()
    ))
    scaled_slice_rows = [[poly.mul_ground(scale) for poly in row]
                         for row, scale in zip(slice_rows, slice_scales)]
    scaled_tangent_rows = [[poly.mul_ground(tangent_scale) for poly in row]
                           for row in tangent_rows]
    slice_gcds = [functools.reduce(sp.gcd, row).monic() for row in scaled_slice_rows]
    tangent_gcd = functools.reduce(sp.gcd, [poly for row in scaled_tangent_rows for poly in row]).monic()
    rho_factor = sp.Poly(1, a, b, domain=sp.QQ)
    for row_gcd in slice_gcds:
        rho_factor *= row_gcd**2
    rho_factor *= tangent_gcd
    assert all(value.q == 1 for _, value in rho_factor.terms())
    payload = {
        "schema": "c958-generic-forward-v1",
        "input_sha256": {
            str(GENERATOR.relative_to(ROOT)): hashlib.sha256(GENERATOR.read_bytes()).hexdigest(),
            str(CERTIFICATE.relative_to(ROOT)): hashlib.sha256(CERTIFICATE.read_bytes()).hexdigest(),
        },
        "cox_coordinate_order": cox_names,
        "tangent_z": [1, 3, 7],
        "tangent_row_indices": TANGENT_ROW_INDICES,
        "common_rho_factor": sparse(rho_factor, 1),
        "slice_rows": [
            [sparse(poly, 1) for poly in row] for row in scaled_slice_rows
        ],
        "tangent_rows": [[sparse(poly, 1) for poly in row] for row in scaled_tangent_rows],
        "row_scaling": "each slice row independently; one common scale for all tangent rows",
    }
    arguments.write.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"slice_scales={slice_scales} tangent_scale={tangent_scale}")


if __name__ == "__main__":
    main()
