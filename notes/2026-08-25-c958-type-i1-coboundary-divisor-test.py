#!/usr/bin/env python3
"""Test whether the residual type-I1 coboundary can be Cox-monomial."""

import argparse
import hashlib
import json
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).resolve().parents[1]
ACTION_INPUT = ROOT / "notes/2026-08-24-c958-type-i1-exceptional-sections.json"
ACTION_SHA256 = "cb7ad6fbd78b44f692d28c057c6d591ffcca87e6f0973a50ad23d002c17fab24"
COCYCLE_INPUT = ROOT / "notes/2026-08-25-c958-type-i1-cox-descent-cocycle.json"
COCYCLE_SHA256 = "c7057b2471d76873e1cf358d7044241e64da76ae8e0bb44ae1c8c51d191accd7"


def build():
    action_bytes = ACTION_INPUT.read_bytes()
    cocycle_bytes = COCYCLE_INPUT.read_bytes()
    assert hashlib.sha256(action_bytes).hexdigest() == ACTION_SHA256
    assert hashlib.sha256(cocycle_bytes).hexdigest() == COCYCLE_SHA256
    actions = json.loads(action_bytes)["generator_actions"]
    cocycle = json.loads(cocycle_bytes)
    assert cocycle["pulled_back_residual_characters"] == ["E1-E3", "E2-E3"]

    labels = [f"E{index}" for index in range(1, 6)]
    labels += [f"L{left}{right}" for left in range(1, 6) for right in range(left + 1, 6)]
    labels += ["Q"]
    lookup = {label: index for index, label in enumerate(labels)}
    size = len(labels)

    def permutation_matrix(generator):
        matrix = sp.zeros(size)
        for label in labels:
            matrix[lookup[actions[generator][label]], lookup[label]] = 1
        return matrix

    sigma, tau, iota = [permutation_matrix(name) for name in ("sigma", "tau", "iota")]
    identity = sp.eye(size)
    zero = sp.zeros(size)

    def divisor_vector(entries):
        result = sp.zeros(size, 1)
        for label, coefficient in entries.items():
            result[lookup[label]] = coefficient
        return result

    iota_first = divisor_vector({"L23": 1, "E3": 1, "L12": -1, "E1": -1})
    iota_second = divisor_vector({"L13": 1, "E3": 1, "L12": -1, "E2": -1})
    tau_first = divisor_vector({"L14": 1, "E1": 1, "L24": -1, "E2": -1})
    tau_second = divisor_vector({"L34": 1, "E3": 1, "L24": -1, "E2": -1})

    picard = sp.zeros(6, size)
    for label in labels:
        column = lookup[label]
        if label.startswith("E"):
            picard[int(label[1]), column] = 1
        elif label.startswith("L"):
            picard[0, column] = 1
            picard[int(label[1]), column] = -1
            picard[int(label[2]), column] = -1
        else:
            picard[0, column] = 2
            for index in range(1, 6):
                picard[index, column] = -1
    picard_zero = sp.zeros(6, size)

    common_rows = [
        sp.Matrix.hstack(iota - identity, zero),
        sp.Matrix.hstack(zero, iota - identity),
        sp.Matrix.hstack(tau + identity, -identity),
        sp.Matrix.hstack(zero, tau - identity),
        sp.Matrix.hstack(picard, picard_zero),
        sp.Matrix.hstack(picard_zero, picard),
    ]
    right_hand_side = sp.Matrix.vstack(
        iota_first,
        iota_second,
        tau_first,
        tau_second,
        sp.zeros(6, 1),
        sp.zeros(6, 1),
    )

    direct_sigma_rows = [
        sp.Matrix.hstack(sigma, identity),
        sp.Matrix.hstack(-identity, sigma + identity),
    ]
    dual_sigma_rows = [
        sp.Matrix.hstack(sigma + identity, -identity),
        sp.Matrix.hstack(identity, sigma),
    ]
    direct_system = sp.Matrix.vstack(*direct_sigma_rows, *common_rows)
    dual_system = sp.Matrix.vstack(*dual_sigma_rows, *common_rows)
    full_rhs = sp.Matrix.vstack(sp.zeros(size, 1), sp.zeros(size, 1), right_hand_side)
    direct_ranks = (direct_system.rank(), direct_system.row_join(full_rhs).rank())
    dual_ranks = (dual_system.rank(), dual_system.row_join(full_rhs).rank())
    assert direct_ranks == (31, 32)
    assert dual_ranks == (31, 31)

    solution = next(iter(sp.linsolve((dual_system, full_rhs))))
    parameters = sorted(set().union(*(entry.free_symbols for entry in solution)), key=str)
    assert len(parameters) == 1
    parameter = parameters[0]
    first_E1 = sp.factor(solution[lookup["E1"]])
    first_E2 = sp.factor(solution[lookup["E2"]])
    assert sp.simplify(first_E1 - (sp.Rational(1, 2) - parameter)) == 0, first_E1
    assert sp.simplify(first_E2 - (2 * parameter + sp.Rational(1, 2))) == 0, first_E2

    # If first_E1 is integral, parameter is 1/2 modulo Z; then first_E2 is
    # 3/2 modulo Z.  Hence no integral exponent vector exists.
    zero_parameter_solution = [sp.factor(entry.subs(parameter, 0)) for entry in solution]

    def sparse(entries):
        return {
            labels[index]: str(entries[index])
            for index in range(size)
            if entries[index] != 0
        }

    return {
        "schema": "c958-type-i1-coboundary-divisor-test-v1",
        "input_sha256": {"exceptional_sections": ACTION_SHA256, "cox_descent": COCYCLE_SHA256},
        "direct_sigma_system_ranks": list(direct_ranks),
        "dual_sigma_system_ranks": list(dual_ranks),
        "solution_dimension": 1,
        "parameter": str(parameter),
        "parity_witness": {
            "first_coordinate_E1": str(first_E1),
            "first_coordinate_E2": str(first_E2),
            "argument": "integrality of E1 forces parameter=1/2 mod Z, making E2=3/2 mod Z",
        },
        "sample_half_integral_solution": {
            "first_coordinate": sparse(zero_parameter_solution[:size]),
            "second_coordinate": sparse(zero_parameter_solution[size:]),
        },
        "certified": [
            "the geometric marked-plane sigma action is dual to the recorded cocharacter action",
            "the direct sigma convention makes the coboundary divisor equations inconsistent",
            "the dual convention gives a one-dimensional rational solution space",
            "no integral solution exists, by the displayed two-coordinate parity witness",
            "there is no coboundary which is a Laurent monomial in the sixteen standard Cox forms",
        ],
        "not_certified": [
            "nonexistence of a general rational coboundary",
            "an additive Hilbert-90 formula",
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
