#!/usr/bin/env python3
"""Derive the generic split Cox orbit section used by C958."""

import argparse
import hashlib
import json
from pathlib import Path
import types

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
SOURCE = (
    ROOT
    / "papers/cubic-stabilization-irrationality/verification/derive_slice_cover.py"
)


def load_source():
    source_text = SOURCE.read_text()
    library_text = source_text.split("parser = argparse.ArgumentParser", 1)[0]
    module = types.ModuleType("c956_slice")
    module.__file__ = str(SOURCE)
    exec(compile(library_text, str(SOURCE), "exec"), module.__dict__)
    return module


def normalized_weights(module, cox_names):
    cox_classes = []
    for index in range(5):
        divisor = [0] * 6
        divisor[index + 1] = 1
        cox_classes.append(sp.Matrix(divisor))
    for left in range(5):
        for right in range(left + 1, 5):
            divisor = [1] + [0] * 5
            divisor[left + 1] = divisor[right + 1] = -1
            cox_classes.append(sp.Matrix(divisor))
    cox_classes.append(sp.Matrix([2, -1, -1, -1, -1, -1]))

    rank_three_basis = sp.Matrix.hstack(
        sp.eye(5).col(2), sp.eye(5).col(3), sp.eye(5).col(4)
    )
    lifts = []
    for column in range(3):
        variables = sp.symbols("u0:6")
        equations = [
            sum(
                variables[row] * module.ROOT_BASIS[row, root]
                for row in range(6)
            )
            - rank_three_basis[root, column]
            for root in range(5)
        ] + [variables[5]]
        solution = next(iter(sp.linsolve(equations, variables)))
        lifts.append(sp.Matrix(1, 6, solution))
    raw = [
        tuple(int((lift * divisor)[0]) for lift in lifts)
        for divisor in cox_classes
    ]
    minima = tuple(min(weight[i] for weight in raw) for i in range(3))
    weights = [
        tuple(weight[i] - minima[i] for i in range(3)) for weight in raw
    ]
    return dict(zip(cox_names, weights))


def point_values(coordinate_by_name, a, b, orbit_e, orbit_z):
    ee1, ee2, ee3, ee4, ee5 = orbit_e
    zz1, zz2, zz3 = orbit_z
    return {
        coordinate_by_name["E1"]: ee1,
        coordinate_by_name["E2"]: ee2,
        coordinate_by_name["E3"]: ee3,
        coordinate_by_name["E4"]: ee4,
        coordinate_by_name["E5"]: ee5,
        coordinate_by_name["L12"]: sp.Rational(zz3, ee1 * ee2),
        coordinate_by_name["L13"]: sp.Rational(zz2, ee1 * ee3),
        coordinate_by_name["L14"]: sp.Rational(zz2 - zz3, ee1 * ee4),
        coordinate_by_name["L15"]: (b * zz2 - a * zz3) / (ee1 * ee5),
        coordinate_by_name["L23"]: sp.Rational(zz1, ee2 * ee3),
        coordinate_by_name["L24"]: sp.Rational(zz1 - zz3, ee2 * ee4),
        coordinate_by_name["L25"]: (b * zz1 - zz3) / (ee2 * ee5),
        coordinate_by_name["L34"]: sp.Rational(zz1 - zz2, ee3 * ee4),
        coordinate_by_name["L35"]: (a * zz1 - zz2) / (ee3 * ee5),
        coordinate_by_name["L45"]: (
            (b - a) * zz1 + (1 - b) * zz2 + (a - 1) * zz3
        ) / (ee4 * ee5),
        coordinate_by_name["Q"]: (
            b * (1 - a) * zz1 * zz2
            + a * (b - 1) * zz1 * zz3
            + (a - b) * zz2 * zz3
        ) / (ee1 * ee2 * ee3 * ee4 * ee5),
    }


def text(expr):
    return sp.sstr(sp.factor(sp.together(expr)))


def build():
    module = load_source()
    lattice = module.type_i3_lattice_data()
    cox_names = lattice["cox_names"]
    symbols, coordinates, relations, jacobian, rows, _ = module.cox_data(cox_names)
    a, b, z1, z2, z3 = symbols
    by_name = dict(zip(cox_names, coordinates))
    boundary = [cox_names.index(name) for name in lattice["boundary_generators"]]
    tangent_z = (1, 3, 7)
    tangent_rows = jacobian[list(rows), :].subs(dict(zip((z1, z2, z3), tangent_z)))
    coefficient_basis = tangent_rows[:, boundary].T.nullspace()
    hyperplanes = [coefficient.T * tangent_rows for coefficient in coefficient_basis]

    block_names = [
        ["E1", "E2", "E5"],
        ["L14", "L24", "L45"],
        ["L13", "L23", "L35"],
        ["L12", "L15", "L25"],
    ]
    block_weights = [(1, 1, 0), (1, 0, 1), (0, 1, 1), (1, 1, 1)]
    orbit_values = point_values(by_name, a, b, (2, 3, 5, 7, 11), (2, 4, 9))
    assert all(sp.factor(relation.subs(orbit_values)) == 0 for relation in relations)
    evaluation = sp.Matrix([
        [
            sum(
                hyperplane[cox_names.index(name)] * orbit_values[by_name[name]]
                for name in block
            )
            for block in block_names
        ]
        for hyperplane in hyperplanes
    ])
    kernel_rows = sp.Matrix([[-1, 1, 0, 0], [-1, 0, 1, 0], [-1, 0, 0, 1]])
    slice_hyperplanes = [
        sum(
            (
                (kernel_rows * evaluation.inv())[row, column] * hyperplanes[column]
                for column in range(4)
            ),
            sp.zeros(1, len(cox_names)),
        )
        for row in range(3)
    ]
    assert all(
        sp.factor(sum(h[cox_names.index(name)] * orbit_values[by_name[name]] for name in cox_names)) == 0
        for h in slice_hyperplanes
    )
    assert all(h[index] == 0 for h in slice_hyperplanes for index in boundary)

    q = sp.symbols("q0:16")
    block_matrix = sp.Matrix([
        [sum(h[cox_names.index(name)] * q[cox_names.index(name)] for name in block) for block in block_names]
        for h in slice_hyperplanes
    ])
    kappas = [
        (-1) ** omitted
        * block_matrix[:, [j for j in range(4) if j != omitted]].det()
        for omitted in range(4)
    ]
    assert (block_matrix * sp.Matrix(kappas)).applyfunc(sp.factor) == sp.zeros(3, 1)

    differences = sp.Matrix.hstack(*[
        sp.Matrix(weight) - sp.Matrix(block_weights[0]) for weight in block_weights[1:]
    ])
    assert abs(int(differences.det())) == 1
    coordinate_weights = normalized_weights(module, cox_names)
    correction_exponents = {}
    for name in cox_names:
        delta = sp.Matrix(coordinate_weights[name]) - sp.Matrix(block_weights[0])
        exponents = differences.inv() * delta
        assert all(value.q == 1 for value in exponents)
        correction_exponents[name] = [int(value) for value in exponents]
    for block_index, block in enumerate(block_names):
        expected = [0, 0, 0] if block_index == 0 else [int(i == block_index - 1) for i in range(3)]
        assert all(correction_exponents[name] == expected for name in block)

    lambda_strings = [[text(h[index]) for index in range(16)] for h in slice_hyperplanes]
    kappa_strings = [text(value) for value in kappas]
    return {
        "schema": "c958-generic-split-orbit-section-v1",
        "source": str(SOURCE.relative_to(ROOT)),
        "source_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
        "field": "Q(a,b)",
        "witness": {
            "tangent_z": list(tangent_z),
            "orbit_e": [2, 3, 5, 7, 11],
            "orbit_z": [2, 4, 9],
        },
        "cox_coordinate_order": cox_names,
        "block_order": [
            {"weight": list(weight), "coordinates": names}
            for weight, names in zip(block_weights, block_names)
        ],
        "slice_hyperplane_coefficients": lambda_strings,
        "signed_minors": kappa_strings,
        "orbit_correction_ratio_names": ["kappa1/kappa0", "kappa2/kappa0", "kappa3/kappa0"],
        "orbit_correction_exponents": correction_exponents,
        "formula_sizes": {
            "slice_coefficient_characters": [sum(len(entry) for entry in row) for row in lambda_strings],
            "signed_minor_characters": [len(entry) for entry in kappa_strings],
        },
        "certified": [
            "the tangent and orbit-test points satisfy all twenty Cox quadrics",
            "the three slice hyperplanes contain the boundary subspace and vanish at the orbit-test point",
            "the signed maximal minors generate the kernel of the block-evaluation matrix",
            "the weight differences are unimodular and give integral Laurent orbit-correction exponents",
        ],
        "not_certified": [
            "inverse tangent elimination",
            "descent from split blow-up coordinates to either cubic generic fibre",
            "forward or inverse maps for X_j times P2",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    result = build()
    payload = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        args.write.write_text(payload)
    elif args.check:
        assert args.check.read_text() == payload
    else:
        print(payload, end="")


if __name__ == "__main__":
    main()
