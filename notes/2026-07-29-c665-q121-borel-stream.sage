#!/usr/bin/env sage
"""Streaming Borel obstruction scan for the q=121 C665 pullback.

For each genuine ordinary contraction order 1 <= r < 11, restrict the image
of the q=121 pullback cocycle to the split Borel.  The cocycle has already
been normalized to vanish on the split torus.  A coboundary must therefore
come from a torus-equivariant map L(6) -> Sym^(118-2r)(L(2)).

The earlier draft materialized a large sparse matrix twice to compare its
coefficient and augmented ranks.  This checker emits the identical equations
one target row at a time and performs exact sparse elimination immediately.
An inconsistent row proves that the restricted image class, hence the global
pullback class, is nonzero.
"""

import argparse
import hashlib
import importlib.machinery
import importlib.util
import json
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
DETECTOR_PATH = HERE / "2026-07-28-c665-q121-contraction-detector.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q121-borel-stream.json"


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
R = detector.R
X, Y, Z = detector.X, detector.Y, detector.Z
HALF = FIELD(2) ** -1


def partial(polynomial, dx, dy, dz):
    answer = polynomial
    if dx:
        answer = answer.derivative(X, dx)
    if dy:
        answer = answer.derivative(Y, dy)
    if dz:
        answer = answer.derivative(Z, dz)
    return answer


def ordinary_contraction(left, right, order):
    """Power of d_X d_Z' - (1/2)d_Y d_Y' + d_Z d_X'."""
    answer = R.zero()
    for pair_xz in range(order + 1):
        for pair_yy in range(order - pair_xz + 1):
            pair_zx = order - pair_xz - pair_yy
            coefficient = (
                comb(order, pair_xz)
                * comb(order - pair_xz, pair_yy)
                * (-HALF) ** pair_yy
            )
            answer += coefficient * partial(
                left, pair_xz, pair_yy, pair_zx
            ) * partial(right, pair_zx, pair_yy, pair_xz)
    return answer


def pullback_inputs():
    group_elements = (
        (1, 1, 0, 1),
        (1, A, 0, 1),
    )
    generator_data = [pullback.action_data(g) for g in group_elements]
    primitive = FIELD.multiplicative_generator()
    torus_element = (primitive, 0, 0, primitive**-1)
    torus_data = pullback.action_data(torus_element)
    _, _, adjusted_cocycles = pullback.split_torus_fixed_lift(
        generator_data, torus_data
    )
    _, embedding_columns, all_simple_actions = pullback.embedding_polynomials()
    simple_actions = all_simple_actions[:2]
    embedded_images = []
    for simple_action in simple_actions:
        columns = []
        for simple_column in range(base.SIMPLE_DEGREE + 1):
            columns.append(
                sum(
                    (
                        simple_action[source_simple, simple_column]
                        * embedding_columns[source_simple]
                        for source_simple in range(base.SIMPLE_DEGREE + 1)
                        if simple_action[source_simple, simple_column]
                    ),
                    R.zero(),
                )
            )
        embedded_images.append(columns)
    return adjusted_cocycles, embedded_images, simple_actions


class StreamingConsistency:
    """Exact sparse Gaussian elimination with a distinguished RHS column."""

    def __init__(self, variable_count):
        self.variable_count = variable_count
        self.pivots = {}
        self.equations = 0
        self.max_row_width = 0
        self.inconsistent = False

    def add(self, row):
        self.equations += 1
        row = {column: value for column, value in row.items() if value}
        while True:
            variable_columns = [
                column for column in row if column < self.variable_count
            ]
            if not variable_columns:
                if row.get(self.variable_count, FIELD.zero()):
                    self.inconsistent = True
                return
            pivot_column = min(variable_columns)
            coefficient = row[pivot_column]
            pivot = self.pivots.get(pivot_column)
            if pivot is None:
                inverse = coefficient**-1
                normalized = {
                    column: value * inverse for column, value in row.items()
                }
                self.pivots[pivot_column] = normalized
                self.max_row_width = max(self.max_row_width, len(normalized))
                return
            for column, value in pivot.items():
                updated = row.get(column, FIELD.zero()) - coefficient * value
                if updated:
                    row[column] = updated
                else:
                    row.pop(column, None)

    def solution(self):
        if self.inconsistent:
            raise ValueError("an inconsistent system has no solution")
        answer = [FIELD.zero()] * self.variable_count
        for pivot_column in sorted(self.pivots, reverse=True):
            row = self.pivots[pivot_column]
            residual = row.get(self.variable_count, FIELD.zero())
            residual += sum(
                (
                    coefficient * answer[column]
                    for column, coefficient in row.items()
                    if pivot_column < column < self.variable_count
                ),
                FIELD.zero(),
            )
            answer[pivot_column] = -residual
        return answer


def equation_rows(
    exponents,
    exponent_index,
    variables,
    defects,
    simple_actions,
    augmented_column,
):
    for parameter, simple_action, generator_defects in zip(
        (FIELD.one(), A), simple_actions, defects
    ):
        for simple_column in range(base.SIMPLE_DEGREE + 1):
            equations = {}
            for target_source in range(len(exponents)):
                variable = variables.get((target_source, simple_column))
                if variable is None:
                    continue
                action_column = detector.translation_column(
                    exponents[target_source], parameter, exponent_index
                )
                for target_row, coefficient in action_column.items():
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
            for target_row in sorted(equations):
                yield equations[target_row]


def canonical_field_vector(vector):
    answer = []
    degree = FIELD.degree()
    for value in vector:
        coefficients = [
            int(coefficient) for coefficient in value.polynomial().list()
        ]
        answer.append(coefficients + [0] * (degree - len(coefficients)))
    return answer


def test_order(order, adjusted_cocycles, embedded_images, simple_actions):
    defects = []
    for cocycle, image_columns in zip(adjusted_cocycles, embedded_images):
        defects.append(
            [
                ordinary_contraction(cocycle, image, order)
                for image in image_columns
            ]
        )
    nonzero_defect_columns = sum(
        bool(defect)
        for generator_defects in defects
        for defect in generator_defects
    )
    target_degree = 2 * (base.DEGREE - order)
    exponents = detector.homogeneous_exponents(target_degree)
    exponent_index = {
        exponent: index for index, exponent in enumerate(exponents)
    }
    weights = tuple(2 * (k - i) for i, j, k in exponents)
    variables = {}
    for target_row, target_weight in enumerate(weights):
        for simple_column, simple_weight in enumerate(base.SIMPLE_WEIGHTS):
            if pullback.same_torus_character(target_weight, simple_weight):
                variables[(target_row, simple_column)] = len(variables)
    solver = StreamingConsistency(len(variables))

    rows = equation_rows(
        exponents,
        exponent_index,
        variables,
        defects,
        simple_actions,
        solver.variable_count,
    )
    for row in rows:
        solver.add(row)
        if solver.inconsistent:
            break

    solution_sha256 = None
    verified_equations = 0
    if not solver.inconsistent:
        solution = solver.solution()
        encoded_solution = json.dumps(
            canonical_field_vector(solution),
            separators=(",", ":"),
        ).encode()
        solution_sha256 = hashlib.sha256(encoded_solution).hexdigest()
        verification_rows = equation_rows(
            exponents,
            exponent_index,
            variables,
            defects,
            simple_actions,
            solver.variable_count,
        )
        for row in verification_rows:
            residual = row.get(solver.variable_count, FIELD.zero())
            residual += sum(
                (
                    coefficient * solution[column]
                    for column, coefficient in row.items()
                    if column < solver.variable_count
                ),
                FIELD.zero(),
            )
            assert residual == 0
            verified_equations += 1

    return {
        "contraction_order": order,
        "target_degree": target_degree,
        "target_dimension": len(exponents),
        "torus_block_variables": solver.variable_count,
        "equations_processed": solver.equations,
        "coefficient_rank": len(solver.pivots),
        "max_reduced_row_width": solver.max_row_width,
        "nonzero_defect_columns": nonzero_defect_columns,
        "solution_sha256": solution_sha256,
        "solvable": not solver.inconsistent,
        "verified_equations": verified_equations,
    }


def parse_orders(specification):
    if "-" in specification and "," not in specification:
        start, stop = map(int, specification.split("-", 1))
        return tuple(range(start, stop + 1))
    return tuple(int(value) for value in specification.split(","))


def calculate(orders):
    adjusted_cocycles, embedded_images, simple_actions = pullback_inputs()
    channels = []
    for order in orders:
        record = test_order(
            order, adjusted_cocycles, embedded_images, simple_actions
        )
        channels.append(record)
        if not record["solvable"]:
            break
    detecting = next(
        (record for record in channels if not record["solvable"]), None
    )
    return {
        "schema": 1,
        "q": base.Q,
        "p": base.P,
        "field_modulus": str(FIELD.modulus()),
        "subgroup": "split Borel",
        "subgroup_index_mod_p": (base.Q + 1) % base.P,
        "ordinary_contraction_orders": list(orders),
        "channels": channels,
        "detecting_contraction_order": (
            None if detecting is None else detecting["contraction_order"]
        ),
        "conclusion": (
            "a valid ordinary contraction detects the restricted pullback"
            if detecting is not None
            else "the checked valid ordinary contractions are Borel-blind"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--orders", default="1-10")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    orders = parse_orders(args.orders)
    if not orders or any(order < 1 or order >= base.P for order in orders):
        raise ValueError("orders must lie between 1 and p-1")
    result = calculate(orders)
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
