#!/usr/bin/env sage
"""High-contraction detectors for the q=121 C665 pullback class.

The polynomial-multiplication channel is blind.  This checker applies the
divided contraction channels

  C_r: Sym^2(Sym^59(L(2))) -> Sym^(118-2r)(L(2))

for r=59,58,... .  Each image cocycle is tested by an exact inhomogeneous
torus-block solve.  The first inconsistent channel certifies that the
original quadratic pullback is nonsplit.
"""

import argparse
import importlib.machinery
import importlib.util
import json
from math import comb
from pathlib import Path

from sage.all import PolynomialRing


HERE = Path(__file__).resolve().parent
PULLBACK_PATH = HERE / "2026-07-28-c665-q121-pullback-support.sage"
CERTIFICATE = HERE / "2026-07-28-c665-q121-contraction-detector.json"


def load_pullback():
    loader = importlib.machinery.SourceFileLoader(
        "c665_q121_pullback_base", str(PULLBACK_PATH)
    )
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {PULLBACK_PATH}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


pullback = load_pullback()
base = pullback.base
FIELD = pullback.FIELD
A = pullback.A
R = pullback.R
X, Y, Z = pullback.X, pullback.Y, pullback.Z
HALF = FIELD(2)**-1


def divided_contraction(left, right, contraction_order):
    remaining_degree = base.DEGREE - contraction_order
    remaining_exponents = tuple(
        (i, j, remaining_degree - i - j)
        for i in range(remaining_degree + 1)
        for j in range(remaining_degree - i + 1)
    )
    answer = R.zero()
    for left_exponent, left_coefficient in left.dict().items():
        left_i, left_j, left_k = map(int, tuple(left_exponent))
        for right_exponent, right_coefficient in right.dict().items():
            right_i, right_j, right_k = map(int, tuple(right_exponent))
            for ux, uy, uz in remaining_exponents:
                pair_xz = left_i - ux
                pair_zx = left_k - uz
                pair_yy = left_j - uy
                if min(pair_xz, pair_zx, pair_yy) < 0:
                    continue
                vx = right_i - pair_zx
                vy = right_j - pair_yy
                vz = right_k - pair_xz
                if min(vx, vy, vz) < 0:
                    continue
                if vx + vy + vz != remaining_degree:
                    continue
                coefficient = (
                    left_coefficient
                    * right_coefficient
                    * comb(left_i, pair_xz)
                    * comb(left_k, pair_zx)
                    * comb(left_j, pair_yy)
                    * comb(right_k, pair_xz)
                    * comb(right_i, pair_zx)
                    * comb(right_j, pair_yy)
                    * (-HALF) ** pair_yy
                )
                answer += coefficient * (
                    X ** (ux + vx)
                    * Y ** (uy + vy)
                    * Z ** (uz + vz)
                )
    return answer


def top_pairing(left, right):
    """Closed monomial formula for the order-59 scalar contraction."""
    right_coefficients = {
        tuple(exponent): coefficient
        for exponent, coefficient in right.dict().items()
    }
    answer = FIELD.zero()
    for exponent, coefficient in left.dict().items():
        i, j, k = map(int, tuple(exponent))
        answer += (
            coefficient
            * right_coefficients.get((k, j, i), FIELD.zero())
            * (-HALF) ** j
        )
    return answer


def homogeneous_exponents(degree):
    return tuple(
        (i, j, degree - i - j)
        for i in range(degree + 1)
        for j in range(degree - i + 1)
    )


def translation_column(exponent, parameter, exponent_index):
    i, j, k = exponent
    answer = {}
    for y_from_x in range(i + 1):
        for z_from_x in range(i - y_from_x + 1):
            x_from_x = i - y_from_x - z_from_x
            x_coefficient = (
                comb(i, y_from_x)
                * comb(i - y_from_x, z_from_x)
                * (-2 * parameter) ** y_from_x
                * parameter ** (2 * z_from_x)
            )
            for z_from_y in range(j + 1):
                target = (
                    x_from_x,
                    y_from_x + j - z_from_y,
                    z_from_x + z_from_y + k,
                )
                coefficient = (
                    x_coefficient
                    * comb(j, z_from_y)
                    * (-parameter) ** z_from_y
                )
                target_index = exponent_index[target]
                answer[target_index] = (
                    answer.get(target_index, FIELD.zero()) + coefficient
                )
    return {
        target: coefficient
        for target, coefficient in answer.items()
        if coefficient
    }


def contraction_system(defects, simple_actions, target_degree):
    exponents = homogeneous_exponents(target_degree)
    exponent_index = {
        exponent: index for index, exponent in enumerate(exponents)
    }
    weights = tuple(2 * (k - i) for i, j, k in exponents)
    variables = {}
    for target_row, target_weight in enumerate(weights):
        for simple_column, simple_weight in enumerate(base.SIMPLE_WEIGHTS):
            if pullback.same_torus_character(target_weight, simple_weight):
                variables[(target_row, simple_column)] = len(variables)
    augmented_column = len(variables)
    target_actions = []
    for parameter in (FIELD.one(), A):
        target_actions.append(
            {
                target_source: translation_column(
                    exponents[target_source], parameter, exponent_index
                )
                for target_source, simple_column in variables
            }
        )
    target_actions.append(
        {
            target_source: {
                exponent_index[
                    (
                        exponents[target_source][2],
                        exponents[target_source][1],
                        exponents[target_source][0],
                    )
                ]: FIELD(-1) ** exponents[target_source][1]
            }
            for target_source, simple_column in variables
        }
    )
    rows = []
    for action_columns, simple_action, generator_defects in zip(
        target_actions, simple_actions, defects
    ):
        for simple_column in range(base.SIMPLE_DEGREE + 1):
            equations = {}
            for target_source in range(len(exponents)):
                variable = variables.get((target_source, simple_column))
                if variable is None:
                    continue
                for target_row, coefficient in action_columns[
                    target_source
                ].items():
                    equation = equations.setdefault(target_row, {})
                    base.add_entry(equation, variable, coefficient)
            for source_simple in range(base.SIMPLE_DEGREE + 1):
                coefficient = simple_action[source_simple, simple_column]
                if not coefficient:
                    continue
                for target_row in range(len(exponents)):
                    variable = variables.get((target_row, source_simple))
                    if variable is None:
                        continue
                    equation = equations.setdefault(target_row, {})
                    base.add_entry(equation, variable, -coefficient)
            for exponent, coefficient in generator_defects[
                simple_column
            ].dict().items():
                target_row = exponent_index[tuple(exponent)]
                equation = equations.setdefault(target_row, {})
                base.add_entry(equation, augmented_column, coefficient)
            rows.extend(equations.values())
    full_system = base.sparse_system(rows, augmented_column + 1)
    coefficient_system = full_system[:, :augmented_column]
    coefficient_rank = coefficient_system.rank()
    augmented_rank = full_system.rank()
    return {
        "target_degree": target_degree,
        "target_dimension": len(exponents),
        "torus_block_variables": augmented_column,
        "equations": full_system.nrows(),
        "coefficient_rank": coefficient_rank,
        "augmented_rank": augmented_rank,
        "solvable": coefficient_rank == augmented_rank,
    }


def calculate(max_remaining_degree=5):
    group_elements = (
        (1, 1, 0, 1),
        (1, A, 0, 1),
        (0, -1, 1, 0),
    )
    generator_data = [pullback.action_data(g) for g in group_elements]
    primitive = FIELD.multiplicative_generator()
    torus_element = (primitive, 0, 0, primitive**-1)
    torus_data = pullback.action_data(torus_element)
    _, _, adjusted_cocycles = pullback.split_torus_fixed_lift(
        generator_data, torus_data
    )
    _, embedding_columns, simple_actions = pullback.embedding_polynomials()
    embedded_images = []
    for simple_action in simple_actions:
        columns = []
        for simple_column in range(base.SIMPLE_DEGREE + 1):
            columns.append(
                sum(
                    (
                        simple_action[source_simple, simple_column]
                        * embedding_columns[source_simple]
                        for source_simple in range(
                            base.SIMPLE_DEGREE + 1
                        )
                        if simple_action[source_simple, simple_column]
                    ),
                    R.zero(),
                )
            )
        embedded_images.append(columns)
    records = []
    for remaining_degree in range(max_remaining_degree + 1):
        contraction_order = base.DEGREE - remaining_degree
        defects = []
        for cocycle, image_columns in zip(
            adjusted_cocycles, embedded_images
        ):
            generator_defects = []
            for image in image_columns:
                defect = divided_contraction(
                    cocycle, image, contraction_order
                )
                if contraction_order == base.DEGREE:
                    assert defect == R(top_pairing(cocycle, image))
                    assert top_pairing(cocycle, image) == top_pairing(
                        image, cocycle
                    )
                generator_defects.append(defect)
            defects.append(generator_defects)
        nonzero_defect_columns = sum(
            bool(defect)
            for generator_defects in defects
            for defect in generator_defects
        )
        target_degree = 2 * remaining_degree
        if nonzero_defect_columns:
            system = contraction_system(
                defects, simple_actions, target_degree
            )
        else:
            system = {
                "target_degree": target_degree,
                "target_dimension": (
                    (target_degree + 1) * (target_degree + 2) // 2
                ),
                "torus_block_variables": 0,
                "equations": 0,
                "coefficient_rank": 0,
                "augmented_rank": 0,
                "solvable": True,
            }
        system["contraction_order"] = contraction_order
        system["nonzero_defect_columns"] = nonzero_defect_columns
        records.append(system)
        if not system["solvable"]:
            break
    detecting = next(
        (record for record in records if not record["solvable"]), None
    )
    return {
        "schema": 1,
        "q": base.Q,
        "p": base.P,
        "field_modulus": str(FIELD.modulus()),
        "channels": records,
        "detecting_contraction_order": (
            None if detecting is None else detecting["contraction_order"]
        ),
        "conclusion": (
            "the first inconsistent divided-contraction channel detects "
            "the q=121 pullback class"
            if detecting is not None
            else "the checked high-contraction channels are blind"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-remaining-degree", type=int, default=5)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = calculate(args.max_remaining_degree)
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
