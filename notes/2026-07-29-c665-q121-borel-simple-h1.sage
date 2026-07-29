#!/usr/bin/env sage
"""Compute split-Borel H^1 for the predicted q=121 simple head factors.

The cocycle is normalized to vanish on the split torus.  Its remaining
values on u(1) and u(a) satisfy the two order relations, commutation, and
the two torus-conjugation relations.  Coboundaries come from the
torus-fixed subspace.
"""

import argparse
import json
import importlib.machinery
import importlib.util
from pathlib import Path

from sage.all import block_matrix, identity_matrix, matrix


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-28-c665-q121-affine-socle.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q121-borel-simple-h1.json"


def load_module(name, path):
    loader = importlib.machinery.SourceFileLoader(name, str(path))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


base = load_module("c665_q121_affine_base", BASE_PATH)
FIELD = base.FIELD
A = base.A
P = base.P


def power_sum(action, exponent):
    answer = action.parent().zero()
    power = action.parent().one()
    for _ in range(exponent):
        answer += power
        power *= action
    return answer


def field_coordinates(value):
    coefficients = value.polynomial().list()
    coefficients += [value.base_ring().zero()] * (2 - len(coefficients))
    return tuple(int(coefficient) for coefficient in coefficients[:2])


def additive_cocycle_coefficients(parameter, u1, ua):
    c0, c1 = field_coordinates(parameter)
    first = power_sum(u1, c0)
    second = (u1**c0) * power_sum(ua, c1)
    return first, second


def calculate_one(digits, torus_multiplier):
    actions, weights = base.digit_simple_actions((FIELD.one(), A), digits)
    u1, ua = actions[:2]
    dimension = u1.nrows()
    identity = identity_matrix(FIELD, dimension)
    primitive = FIELD.multiplicative_generator()
    torus = matrix(
        FIELD,
        dimension,
        dimension,
        {
            (index, index): primitive**weight
            for index, weight in enumerate(weights)
        },
    )
    assert torus * u1 * torus**-1 == base.digit_simple_actions(
        (torus_multiplier,), digits
    )[0][0]

    norm1 = power_sum(u1, P)
    norma = power_sum(ua, P)
    lambda_one = torus_multiplier
    lambda_a = torus_multiplier * A
    one_left, one_right = additive_cocycle_coefficients(
        lambda_one, u1, ua
    )
    a_left, a_right = additive_cocycle_coefficients(
        lambda_a, u1, ua
    )
    relations = block_matrix(
        FIELD,
        [
            [norm1, matrix(FIELD, dimension, dimension)],
            [matrix(FIELD, dimension, dimension), norma],
            [identity - ua, u1 - identity],
            [torus - one_left, -one_right],
            [-a_left, torus - a_right],
        ],
        subdivide=False,
    )
    cocycle_dimension = 2 * dimension - relations.rank()
    fixed_columns = [
        index
        for index, weight in enumerate(weights)
        if weight % base.TORUS_MODULUS == 0
    ]
    coboundary = block_matrix(
        FIELD,
        [[u1 - identity], [ua - identity]],
        subdivide=False,
    )[:, fixed_columns]
    assert relations * coboundary == 0
    coboundary_dimension = coboundary.rank()
    return {
        "digits": list(digits),
        "highest_weight": sum(
            digit * P**position
            for position, digit in enumerate(digits)
        ),
        "simple_dimension": dimension,
        "torus_fixed_dimension": len(fixed_columns),
        "normalized_cocycle_dimension": cocycle_dimension,
        "normalized_coboundary_dimension": coboundary_dimension,
        "borel_h1_dimension": cocycle_dimension - coboundary_dimension,
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    primitive = FIELD.multiplicative_generator()
    candidate_multipliers = (primitive**2, primitive**-2)
    sample_actions, _ = base.digit_simple_actions(
        (FIELD.one(),), (1,)
    )
    sample_u = sample_actions[0]
    sample_weights = base.digit_simple_actions((), (1,))[1]
    sample_torus = matrix(
        FIELD,
        2,
        2,
        {
            (index, index): primitive**weight
            for index, weight in enumerate(sample_weights)
        },
    )
    torus_multiplier = next(
        multiplier
        for multiplier in candidate_multipliers
        if sample_torus * sample_u * sample_torus**-1
        == base.digit_simple_actions((multiplier,), (1,))[0][0]
    )
    top_candidates = (
        (10, 8),
        (10, 4),
        (10, 0),
        (6, 8),
        (6, 4),
        (6, 0),
        (2, 8),
        (2, 4),
        (2, 0),
        (8, 6),
        (8, 2),
        (4, 6),
        (4, 2),
        (0, 6),
        (0, 2),
    )
    middle_candidates = tuple(
        (left, right)
        for left in (9, 7, 5, 3, 1)
        for right in (9, 7, 5, 3, 1)
    )
    bottom_candidates = (
        (8, 10),
        (8, 6),
        (8, 2),
        (4, 10),
        (4, 6),
        (4, 2),
        (0, 10),
        (0, 6),
        (0, 2),
        (6, 8),
        (6, 4),
        (6, 0),
        (2, 8),
        (2, 4),
        (2, 0),
    )
    result = {
        "schema": 2,
        "q": base.Q,
        "p": P,
        "field_modulus": str(FIELD.modulus()),
        "torus_translation_multiplier": str(torus_multiplier),
        "top_candidates": [
            calculate_one(digits, torus_multiplier)
            for digits in top_candidates
        ],
        "middle_candidates": [
            calculate_one(digits, torus_multiplier)
            for digits in middle_candidates
        ],
        "bottom_candidates": [
            calculate_one(digits, torus_multiplier)
            for digits in bottom_candidates
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
