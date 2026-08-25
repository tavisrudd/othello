#!/usr/bin/env python3
"""Identify the type-I1 residual rank-two torus with a cubic norm-one torus."""

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
ACTION_SOURCE = ROOT / "notes/2026-08-24-c958-type-i1-descent-action.py"
ACTION_SHA256 = "a5719a9afe2465d8135b89d5d7242bb7f695d33030dd47f595806cc768dda8c7"
C956_SOURCE = ROOT / "papers/cubic-stabilization-irrationality/verification/derive_slice_cover.py"
C956_SHA256 = "89eee9a9d04cb555e45c8b4f461bbf20ccb6b1d38cfabdad2b8ce67c1ff42373"


def pinned_module():
    assert hashlib.sha256(ACTION_SOURCE.read_bytes()).hexdigest() == ACTION_SHA256
    assert hashlib.sha256(C956_SOURCE.read_bytes()).hexdigest() == C956_SHA256
    specification = importlib.util.spec_from_file_location("c958_weyl", ACTION_SOURCE)
    module = importlib.util.module_from_spec(specification)
    specification.loader.exec_module(module)
    return module


def divisor(name):
    value = sp.zeros(6, 1)
    if name.startswith("E"):
        value[int(name[1])] = 1
    elif name.startswith("L"):
        value[0] = 1
        value[int(name[1])] = -1
        value[int(name[2])] = -1
    else:
        value[0] = 2
        for index in range(1, 6):
            value[index] = -1
    return value


def permutation_matrix_on_augmentation(permutation):
    ambient = sp.zeros(3)
    for source, target in enumerate(permutation):
        ambient[target, source] = 1
    basis = sp.Matrix([[1, 0], [0, 1], [-1, -1]])
    return sp.Matrix.hstack(
        *(basis.gauss_jordan_solve(ambient * basis[:, column])[0] for column in range(2))
    )


def build():
    weyl = pinned_module()
    type_i1_generators = [
        (weyl.cycle(1, 2, 3), 0),
        (weyl.cycle(2, 3), weyl.flip(1, 2, 3, 5)),
        (weyl.IDENTITY, weyl.flip(4, 5)),
    ]
    type_i1 = weyl.generate(type_i1_generators)
    type_i3 = weyl.generate(
        [
            (weyl.cycle(2, 5), weyl.flip(1, 2, 3, 5)),
            (weyl.product_of_disjoint_cycles((3, 4), (1, 5, 2)), weyl.flip(3, 4)),
        ]
    )
    all_weyl = [
        (permutation, flipped)
        for permutation in itertools.permutations(range(5))
        for flipped in range(1 << 5)
        if flipped.bit_count() % 2 == 0
    ]
    chosen = min(
        element
        for element in all_weyl
        if {weyl.conjugate(value, element) for value in type_i1} <= type_i3
    )

    coordinate_by_mask = weyl.coordinate_dictionary()
    root_basis = sp.Matrix.hstack(
        sp.Matrix([0, 1, 0, 0, 0, -1]),
        sp.Matrix([0, 0, 1, 0, 0, -1]),
        sp.Matrix([0, 0, 0, 1, 0, -1]),
        sp.Matrix([0, 0, 0, 0, 1, -1]),
        sp.Matrix([1, 0, 0, 0, 0, -3]),
    )

    def character_matrix(element):
        coordinate_action = {
            name: coordinate_by_mask[weyl.act(element, mask)]
            for mask, name in coordinate_by_mask.items()
        }
        picard_action = sp.zeros(6)
        for index in range(1, 6):
            picard_action[:, index] = divisor(coordinate_action[f"E{index}"])
        picard_action[:, 0] = (
            divisor(coordinate_action["L12"])
            + picard_action[:, 1]
            + picard_action[:, 2]
        )
        return sp.Matrix.hstack(
            *(root_basis.gauss_jordan_solve(picard_action * root_basis[:, column])[0] for column in range(5))
        )

    character_actions = []
    cocharacter_actions = []
    residual_actions = []
    for generator in type_i1_generators:
        conjugated = weyl.conjugate(generator, chosen)
        character = character_matrix(conjugated)
        cocharacter = character.inv().T
        assert cocharacter[:2, 2:] == sp.zeros(2, 3)
        character_actions.append(character)
        cocharacter_actions.append(cocharacter)
        residual_actions.append(cocharacter[:2, :2])

    expected_residual = [
        sp.Matrix([[0, -1], [1, -1]]),
        sp.Matrix([[-1, 1], [0, 1]]),
        sp.eye(2),
    ]
    assert residual_actions == expected_residual

    sigma_permutation = (2, 0, 1)
    tau_permutation = (0, 2, 1)
    augmentation_actions = [
        permutation_matrix_on_augmentation(sigma_permutation),
        permutation_matrix_on_augmentation(tau_permutation),
        sp.eye(2),
    ]
    change_of_basis = sp.Matrix([[-1, -1], [-1, 0]])
    assert abs(change_of_basis.det()) == 1
    assert all(
        residual * change_of_basis == change_of_basis * augmentation
        for residual, augmentation in zip(residual_actions, augmentation_actions)
    )

    x0, x1, x2, a, beta, rho = sp.symbols("x0 x1 x2 a beta rho")
    element = x0 + x1 * rho + x2 * rho**2
    multiplication_columns = []
    minimal_polynomial = sp.Poly(rho**3 - 3 * a**2 * rho - beta, rho)
    for multiplier in (1, rho, rho**2):
        reduced = sp.rem(sp.Poly(multiplier * element, rho), minimal_polynomial).as_expr()
        multiplication_columns.append(
            sp.Matrix([sp.expand(reduced).coeff(rho, power) for power in range(3)])
        )
    norm = sp.factor(sp.Matrix.hstack(*multiplication_columns).det())
    expected_norm = (
        x0**3
        + beta * x1**3
        + beta**2 * x2**3
        - 3 * beta * x0 * x1 * x2
        + 6 * a**2 * x0**2 * x2
        - 3 * a**2 * x0 * x1**2
        + 9 * a**4 * x0 * x2**2
        - 3 * a**2 * beta * x1 * x2**2
    )
    assert sp.expand(norm - expected_norm) == 0

    t1, t2, t3 = sp.symbols("t1 t2 t3")
    cayley = [(value - 1) / (value + 1) for value in (t1, t2, t3)]
    cayley_relation = sp.factor(
        (cayley[0] + cayley[1] + cayley[2] + cayley[0] * cayley[1] * cayley[2])
        .subs(t3, 1 / (t1 * t2))
    )
    assert cayley_relation == 0

    return {
        "schema": "c958-type-i1-residual-norm-torus-v1",
        "input_sha256": {"weyl_action": ACTION_SHA256, "c956_lattice_source": C956_SHA256},
        "residual_cocharacter_actions": [
            [[int(entry) for entry in row] for row in matrix.tolist()]
            for matrix in residual_actions
        ],
        "augmentation_actions": [
            [[int(entry) for entry in row] for row in matrix.tolist()]
            for matrix in augmentation_actions
        ],
        "augmentation_change_of_basis": [
            [int(entry) for entry in row] for row in change_of_basis.tolist()
        ],
        "cubic_etale_algebra": "E=K[rho]/(rho^3-3*a^2*rho-beta)",
        "norm_polynomial": str(norm),
        "cayley_split_model": "x1+x2+x3+x1*x2*x3=0, where xi=(ti-1)/(ti+1) and t1*t2*t3=1",
        "certified": [
            "the type-I1 residual cocharacter lattice is the A2 augmentation lattice",
            "the residual torus is the cubic norm-one torus R^1_{E/K}(Gm)",
            "the independent quadratic generator acts trivially on the residual torus",
            "the displayed cubic is the norm polynomial in the basis 1,rho,rho^2",
            "the coordinatewise Cayley transform gives the displayed symmetric split model",
        ],
        "not_certified": [
            "a ground-field rational parametrization of the norm-one cubic surface",
            "an explicit equivariant trivialization S times T_residual to Z/T3",
            "the final stabilized maps for the cubic family",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
