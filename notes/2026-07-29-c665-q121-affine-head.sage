#!/usr/bin/env sage
"""Test whether the q=121 affine class survives in the L(6) head.

The adjacent affine-socle certificate gives unique maps

    i : L(6) -> F,    pi : F -> L(6),    pi i = 0.

This checker pushes the torus-normalized affine cocycle through pi and
tests whether the resulting L(6)-valued cocycle is a coboundary.  Because
the cocycle vanishes on the split torus, a cobounding vector must lie in
the one-dimensional torus-fixed line of L(6).
"""

import argparse
import importlib.machinery
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
DETECTOR_PATH = HERE / "2026-07-28-c665-q121-contraction-detector.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q121-affine-head.json"


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


def projection_data():
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
        parameters, (6,)
    )
    projection, variables, kernel = base.projection_hom_dimension(
        generator_columns, simple_actions, simple_weights
    )
    assert projection["dimension"] == 1
    return (
        variables,
        kernel.basis()[0],
        simple_actions,
        simple_weights,
    )


def projected_cocycles(variables, projection_vector):
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
    exponent_index = {
        exponent: index for index, exponent in enumerate(base.EXPONENTS)
    }
    answer = []
    for cocycle in adjusted:
        vector = [FIELD.zero()] * (base.SIMPLE_DEGREE + 1)
        for exponent, coefficient in cocycle.dict().items():
            f_index = exponent_index[tuple(exponent)]
            for simple_row in range(base.SIMPLE_DEGREE + 1):
                variable = variables.get((simple_row, f_index))
                if variable is not None:
                    vector[simple_row] += (
                        projection_vector[variable] * coefficient
                    )
        answer.append(vector)
    return answer


def calculate():
    (
        variables,
        projection_vector,
        simple_actions,
        simple_weights,
    ) = projection_data()
    cocycles = projected_cocycles(variables, projection_vector)
    fixed_columns = [
        column
        for column, weight in enumerate(simple_weights)
        if weight % base.TORUS_MODULUS == 0
    ]
    assert len(fixed_columns) == 1
    fixed_column = fixed_columns[0]

    coefficient_entries = []
    augmented_entries = []
    for action, cocycle in zip(simple_actions, cocycles):
        for row in range(base.SIMPLE_DEGREE + 1):
            coefficient = action[row, fixed_column]
            if row == fixed_column:
                coefficient -= 1
            coefficient_entries.append(coefficient)
            augmented_entries.append(cocycle[row])

    coefficient_nonzero = [
        index
        for index, value in enumerate(coefficient_entries)
        if value
    ]
    if coefficient_nonzero:
        pivot = coefficient_nonzero[0]
        candidate = (
            -augmented_entries[pivot] / coefficient_entries[pivot]
        )
        residuals = [
            coefficient * candidate + augmented
            for coefficient, augmented in zip(
                coefficient_entries, augmented_entries
            )
        ]
        coboundary = all(residual == 0 for residual in residuals)
    else:
        candidate = FIELD.zero()
        residuals = list(augmented_entries)
        coboundary = all(residual == 0 for residual in residuals)

    return {
        "schema": 1,
        "q": base.Q,
        "p": base.P,
        "field_modulus": str(FIELD.modulus()),
        "simple": "L(6)",
        "simple_dimension": base.SIMPLE_DEGREE + 1,
        "projection_hom_dimension": 1,
        "torus_fixed_dimension": len(fixed_columns),
        "projected_cocycle_nonzero_entries": [
            sum(bool(value) for value in cocycle)
            for cocycle in cocycles
        ],
        "coboundary": coboundary,
        "candidate_scalar": str(candidate),
        "nonzero_residuals": sum(bool(value) for value in residuals),
        "conclusion": (
            "the affine class dies in the L(6) head"
            if coboundary
            else "the affine class survives in the L(6) head"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = calculate()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
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
