#!/usr/bin/env python3
"""Identify the C958 type-I3 residual torus with a cubic norm-one torus."""

import argparse
import hashlib
import json
from pathlib import Path
import types

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "papers/cubic-stabilization-irrationality/verification/derive_slice_cover.py"


def load_source():
    source_text = SOURCE.read_text().split("parser = argparse.ArgumentParser", 1)[0]
    module = types.ModuleType("c956_slice")
    module.__file__ = str(SOURCE)
    exec(compile(source_text, str(SOURCE), "exec"), module.__dict__)
    return module


def key(matrix):
    return tuple(int(entry) for entry in matrix)


def generated_group(generators):
    identity = sp.eye(generators[0].rows)
    group = {key(identity): identity}
    queue = [identity]
    while queue:
        value = queue.pop()
        for generator in generators:
            for product in (value * generator, generator * value):
                if key(product) not in group:
                    group[key(product)] = product
                    queue.append(product)
    return group


def build():
    source = load_source()
    completion = sp.Matrix.hstack(
        sp.eye(5).col(2), sp.eye(5).col(3), sp.eye(5).col(4),
        sp.eye(5).col(0), sp.eye(5).col(1),
    )
    full_group = generated_group(source.COCHARACTER_GENERATORS)
    residual_cocharacter_generators = []
    for generator in source.COCHARACTER_GENERATORS:
        changed = completion.inv() * generator * completion
        assert changed[3:5, 0:3] == sp.zeros(2, 3)
        residual_cocharacter_generators.append(changed[3:5, 3:5])
    residual_group = generated_group(residual_cocharacter_generators)
    assert len(full_group) == 24
    assert len(residual_group) == 6
    assert len(full_group) // len(residual_group) == 4

    augmentation_generators = [
        sp.Matrix([[-1, -1], [1, 0]]),
        sp.Matrix([[1, 0], [-1, -1]]),
    ]
    augmentation_group = generated_group(augmentation_generators)
    conjugation = sp.Matrix([[-1, -1], [-1, 0]])
    assert abs(int(conjugation.det())) == 1
    conjugated = {
        key(conjugation.inv() * matrix * conjugation)
        for matrix in residual_group.values()
    }
    assert conjugated == set(augmentation_group)

    a, beta, t = sp.symbols("a beta t")
    cubic = t**3 - a**2 * t + a**3 + beta
    discriminant = sp.factor(sp.discriminant(cubic, t))
    assert discriminant == -23 * a**6 - 54 * a**3 * beta - 27 * beta**2

    def matrices(values):
        return [[[int(entry) for entry in row] for row in matrix.tolist()]
                for matrix in values]

    return {
        "schema": "c958-type-i3-residual-norm-torus-v1",
        "input_sha256": {
            str(SOURCE.relative_to(ROOT)): hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
        },
        "full_type_i3_group_order": len(full_group),
        "residual_group_order": len(residual_group),
        "residual_kernel_order": len(full_group) // len(residual_group),
        "residual_cocharacter_generators": matrices(residual_cocharacter_generators),
        "augmentation_generators": matrices(augmentation_generators),
        "unimodular_conjugation_to_augmentation_group": matrices([conjugation])[0],
        "cubic_etale_algebra": "E3=K[rho]/(rho^3-a^2*rho+a^3+beta)",
        "cubic_discriminant": str(discriminant),
        "uniform_norm_torus_specialization": {"p": "-a^2", "q": "a^3+beta"},
        "conclusion": (
            "The type-I3 quotient cocharacter lattice is the S3 augmentation "
            "lattice, so T0/T3 is R^1_{E3/K}(Gm); the order-four kernel acts "
            "trivially on this residual torus."
        ),
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
