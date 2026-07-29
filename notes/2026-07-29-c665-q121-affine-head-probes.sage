#!/usr/bin/env sage
"""Probe the q=121 affine class in the L(8) digit heads."""

import argparse
import importlib.machinery
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
DETECTOR_PATH = HERE / "2026-07-28-c665-q121-contraction-detector.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q121-affine-head-probes.json"


def load_module(name, path):
    loader = importlib.machinery.SourceFileLoader(name, str(path))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


detector = load_module("c665_q121_detector_support", DETECTOR_PATH)
pullback = detector.pullback
base = detector.base
FIELD = detector.FIELD
A = detector.A


def affine_cocycles():
    group_elements = (
        (1, 1, 0, 1),
        (1, A, 0, 1),
        (0, -1, 1, 0),
    )
    generator_data = [pullback.action_data(g) for g in group_elements]
    primitive = FIELD.multiplicative_generator()
    torus_data = pullback.action_data(
        (primitive, 0, 0, primitive**-1)
    )
    _, _, adjusted = pullback.split_torus_fixed_lift(
        generator_data, torus_data
    )
    return adjusted


def project(cocycle, variables, projection_vector, simple_dimension):
    exponent_index = {
        exponent: index for index, exponent in enumerate(base.EXPONENTS)
    }
    vector = [FIELD.zero()] * simple_dimension
    for exponent, coefficient in cocycle.dict().items():
        f_index = exponent_index[tuple(exponent)]
        for simple_row in range(simple_dimension):
            variable = variables.get((simple_row, f_index))
            if variable is not None:
                vector[simple_row] += (
                    projection_vector[variable] * coefficient
                )
    return vector


def probe(digits, adjusted_cocycles):
    parameters = (FIELD.one(), A)
    translation_columns = [
        [
            base.translation_column(exponent, parameter)
            for exponent in base.EXPONENTS
        ]
        for parameter in parameters
    ]
    inversion_columns = [
        base.inversion_column(exponent) for exponent in base.EXPONENTS
    ]
    generator_columns = translation_columns + [inversion_columns]
    simple_actions, simple_weights = base.digit_simple_actions(
        parameters, digits
    )
    projection, variables, kernel = base.projection_hom_dimension(
        generator_columns, simple_actions, simple_weights
    )
    fixed_columns = [
        column
        for column, weight in enumerate(simple_weights)
        if weight % base.TORUS_MODULUS == 0
    ]
    records = []
    for basis_index, projection_vector in enumerate(kernel.basis()):
        cocycles = [
            project(
                cocycle,
                variables,
                projection_vector,
                len(simple_weights),
            )
            for cocycle in adjusted_cocycles
        ]
        if len(fixed_columns) != 1:
            raise ValueError("the probe expects one torus-fixed line")
        fixed_column = fixed_columns[0]
        coefficients = []
        augmented = []
        for action, cocycle in zip(simple_actions, cocycles):
            for row in range(len(simple_weights)):
                coefficient = action[row, fixed_column]
                if row == fixed_column:
                    coefficient -= 1
                coefficients.append(coefficient)
                augmented.append(cocycle[row])
        pivot = next(
            (index for index, value in enumerate(coefficients) if value),
            None,
        )
        if pivot is None:
            candidate = FIELD.zero()
        else:
            candidate = -augmented[pivot] / coefficients[pivot]
        residuals = [
            coefficient * candidate + value
            for coefficient, value in zip(coefficients, augmented)
        ]
        records.append(
            {
                "basis_index": basis_index,
                "projected_cocycle_nonzero_entries": [
                    sum(bool(value) for value in cocycle)
                    for cocycle in cocycles
                ],
                "candidate_scalar": str(candidate),
                "nonzero_residuals": sum(
                    bool(residual) for residual in residuals
                ),
                "coboundary": all(residual == 0 for residual in residuals),
            }
        )
    return {
        "digits": list(digits),
        "highest_weight": sum(
            digit * base.P**position
            for position, digit in enumerate(digits)
        ),
        "simple_dimension": len(simple_weights),
        "projection_hom_dimension": projection["dimension"],
        "torus_fixed_dimension": len(fixed_columns),
        "projection_records": records,
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    adjusted_cocycles = affine_cocycles()
    result = {
        "schema": 1,
        "q": base.Q,
        "p": base.P,
        "field_modulus": str(FIELD.modulus()),
        "probes": [
            probe((8,), adjusted_cocycles),
            probe((0, 8), adjusted_cocycles),
        ],
    }
    encoded = json.dumps(result, default=int, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(encoded)
        print(f"wrote {CERTIFICATE.name}")
    elif args.check:
        assert CERTIFICATE.read_text() == encoded
        print(f"checked {CERTIFICATE.name}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
