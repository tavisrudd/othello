#!/usr/bin/env python3
"""Independent replay of the C682 monotone entrance quotients."""

import importlib.util
import json
from functools import reduce
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
GLOBAL_REPLAY_PATH = HERE / "2026-07-29-c682-global-weyl-operators-replay.py"
PHASE_REPLAY_PATH = HERE / "2026-07-29-c682-global-phase-propagation-replay.py"
OPERATORS = HERE / "2026-07-29-c682-monotone-weyl-operators.json"
BOUNDARY = HERE / "2026-07-29-c682-monotone-entrance-boundary.json"
PRIMES = (1_000_000_007, 1_000_000_009)
GENERATOR_NAMES = {
    "2p": ["g7", "g13", "g17", "g23"],
    "4": ["g6", "g8", "g12", "g14", "g16", "g18", "g22", "g24"],
    "4s": ["g3", "g9", "g11", "g13", "g17", "g19", "g21", "g27"],
    "5": [
        "g4",
        "g8",
        "g10",
        "g12",
        "g14",
        "g16",
        "g18",
        "g20",
        "g22",
        "g26",
    ],
    "6": [
        "g5",
        "g7",
        "g9",
        "g11",
        "g13",
        "g15a",
        "g15b",
        "g17",
        "g19",
        "g21",
        "g23",
        "g25",
    ],
}
GENERATOR_DEGREES = {
    "2p": [7, 13, 17, 23],
    "4": [6, 8, 12, 14, 16, 18, 22, 24],
    "4s": [3, 9, 11, 13, 17, 19, 21, 27],
    "5": [4, 8, 10, 12, 14, 16, 18, 20, 22, 26],
    "6": [5, 7, 9, 11, 13, 15, 15, 17, 19, 21, 23, 25],
}


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


GLOBAL_REPLAY = load(GLOBAL_REPLAY_PATH, "monotone_global_replay")
PHASE_REPLAY = load(PHASE_REPLAY_PATH, "monotone_phase_replay")
ORIGINAL_BUILD_DATA = GLOBAL_REPLAY.BASE.build_data


def primitive(polynomial):
    content = reduce(gcd, (abs(value) for value in polynomial.values()))
    return {
        monomial: coefficient // content
        for monomial, coefficient in polynomial.items()
    }


def build_data(label, tools, prime):
    if label not in GENERATOR_NAMES:
        return ORIGINAL_BUILD_DATA(label, tools, prime)
    klein_z = tools.KLEIN
    raw_hessian_z = tools.transvectant_z(klein_z, klein_z, 2)
    hessian_z = primitive(raw_hessian_z)
    raw_jacobian_z = tools.transvectant_z(
        klein_z, raw_hessian_z, 1
    )
    jacobian_z = primitive(raw_jacobian_z)
    if label == "2p":
        seed = {(7, 0): 1, (2, 5): -7}
        specifications = [
            (7, None, 0),
            (13, klein_z, 3),
            (17, hessian_z, 5),
            (23, jacobian_z, 7),
        ]
    elif label == "4":
        seed = {(4, 2): 1}
        specifications = [
            (6, None, 0),
            (8, klein_z, 5),
            (12, klein_z, 3),
            (14, klein_z, 2),
            (16, klein_z, 1),
            (18, hessian_z, 4),
            (22, hessian_z, 2),
            (24, hessian_z, 1),
        ]
    elif label == "4s":
        seed = {(3, 0): 1}
        specifications = [
            (3, None, 0),
            (9, klein_z, 3),
            (11, klein_z, 2),
            (13, klein_z, 1),
            (17, hessian_z, 3),
            (19, hessian_z, 2),
            (21, hessian_z, 1),
            (27, jacobian_z, 3),
        ]
    elif label == "5":
        seed = {(4, 0): 1}
        specifications = [
            (4, None, 0),
            (8, klein_z, 4),
            (10, klein_z, 3),
            (12, klein_z, 2),
            (14, klein_z, 1),
            (16, hessian_z, 4),
            (18, hessian_z, 3),
            (20, hessian_z, 2),
            (22, hessian_z, 1),
            (26, jacobian_z, 4),
        ]
    else:
        seed = {(5, 0): 1}
        specifications = [
            (5, None, 0),
            (7, klein_z, 5),
            (9, klein_z, 4),
            (11, klein_z, 3),
            (13, klein_z, 2),
            (15, klein_z, 1),
            (15, hessian_z, 5),
            (17, hessian_z, 4),
            (19, hessian_z, 3),
            (21, hessian_z, 2),
            (23, hessian_z, 1),
            (25, jacobian_z, 5),
        ]
    generators_z = [
        (
            name,
            degree,
            seed
            if invariant is None
            else primitive(
                tools.transvectant_z(seed, invariant, order)
            ),
        )
        for name, (degree, invariant, order) in zip(
            GENERATOR_NAMES[label], specifications
        )
    ]
    reduce_mod = lambda polynomial: {
        monomial: coefficient % prime
        for monomial, coefficient in polynomial.items()
        if coefficient % prime
    }
    return (
        reduce_mod(klein_z),
        reduce_mod(hessian_z),
        [
            (name, degree, reduce_mod(generator))
            for name, degree, generator in generators_z
        ],
    )


GLOBAL_REPLAY.BASE.build_data = build_data
for label in GENERATOR_NAMES:
    PHASE_REPLAY.GENERATOR_DEGREES[label] = dict(
        zip(GENERATOR_NAMES[label], GENERATOR_DEGREES[label])
    )


def phase_determinant(row, q, operators, prime):
    label = row["module"]
    degree = row["base_degree"] + 60 * q
    lower, current, incoming = PHASE_REPLAY.operator_matrix(
        label, degree - 6, 3, operators, prime
    )
    _, upper, outgoing = PHASE_REPLAY.operator_matrix(
        label, degree, 3, operators, prime
    )
    upper_2, current_2, ninth = PHASE_REPLAY.operator_matrix(
        label, degree + 6, 9, operators, prime
    )
    assert upper == upper_2 and current == current_2
    current_levels = PHASE_REPLAY.local_levels(current)
    lower_levels = PHASE_REPLAY.local_levels(lower)
    maxima = {}
    for (name, *_), level in zip(current, current_levels):
        maxima[name] = max(maxima.get(name, -1), level)
    width = row["tail_width"]
    tail = [
        index
        for index, ((name, *_), level) in enumerate(
            zip(current, current_levels)
        )
        if level >= maxima[name] - width + 1
    ]
    tail_set = set(tail)
    local_incoming = [
        [value[index] for index in tail]
        for value in incoming
        if (
            (support := {
                index for index, entry in enumerate(value) if entry
            })
            and support <= tail_set
        )
    ]
    selected = [
        PHASE_REPLAY.endpoint_index(lower, lower_levels, key)
        for key in row["endpoint_keys"]
    ]
    returned = []
    for index in selected:
        vector = PHASE_REPLAY.matvec(
            ninth,
            PHASE_REPLAY.matvec(
                outgoing, incoming[index], prime
            ),
            prime,
        )
        assert all(
            not value or position in tail_set
            for position, value in enumerate(vector)
        )
        returned.append([vector[position] for position in tail])
    return PHASE_REPLAY.determinant(local_incoming + returned, prime)


def main():
    operators = json.loads(OPERATORS.read_text(encoding="utf-8"))
    boundary = json.loads(BOUNDARY.read_text(encoding="utf-8"))
    for prime in PRIMES:
        for label, module_operators in operators.items():
            for order_text, operator in module_operators.items():
                order = int(order_text)
                for generator_index, source_name in enumerate(
                    operator["generator_names"]
                ):
                    for f_power, h_power in (
                        (order + 3, order + 4),
                        (order + 4, order + 3),
                    ):
                        assert GLOBAL_REPLAY.direct_transition(
                            label,
                            order,
                            f_power,
                            h_power,
                            generator_index,
                            prime,
                        ) == GLOBAL_REPLAY.predicted_transition(
                            operator,
                            source_name,
                            f_power,
                            h_power,
                            prime,
                        )
        for row in boundary.values():
            assert phase_determinant(row, 13, operators, prime)
            assert phase_determinant(row, 17, operators, prime)
    print("PASS: independent C682 monotone entrance replay")


if __name__ == "__main__":
    main()
