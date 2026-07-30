#!/usr/bin/env python3
"""C682 entrance quotients for the five monotone McKay modules."""

from __future__ import annotations

import argparse
import importlib.util
import json
import multiprocessing
from fractions import Fraction
from functools import cache, reduce
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-29-c682-global-phase-propagation.py"
OPERATORS = HERE / "2026-07-29-c682-monotone-weyl-operators.json"
BOUNDARY = HERE / "2026-07-29-c682-monotone-entrance-boundary.json"
CERTIFICATE = HERE / "2026-07-29-c682-monotone-entrance-propagation.json"
PHASES = {
    "2p": [7, 17, 27, 37, 47, 57],
    "4": [6, 8, 16, 18, 26, 28, 36, 38, 46, 48, 56, 58],
    "4s": [1, 3, 11, 13, 21, 23, 31, 33, 41, 43, 51, 53],
    "5": [0, 4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56],
    "6": [5, 7, 9, 15, 17, 19, 25, 27, 29, 35, 37, 39, 45, 47, 49, 55, 57, 59],
}
EXCEPTIONAL_PHASES = {
    "4": {6, 26, 46},
    "4s": {3, 23, 43},
    "5": {4, 24, 44},
    "6": {5, 25, 45},
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


BASE = load(BASE_PATH, "monotone_entrance_base")
ORIGINAL_MODULE_DATA = BASE.GLOBAL.MODULE_DATA.module_data


def primitive(polynomial):
    content = reduce(gcd, (abs(value) for value in polynomial.values()))
    return {
        monomial: coefficient // content
        for monomial, coefficient in polynomial.items()
    }


def transvectant_generators(seed, specifications, tools):
    return [
        (
            f"g{degree}" if suffix is None else f"g{degree}{suffix}",
            degree,
            seed
            if invariant is None
            else primitive(
                tools.transvectant(seed, invariant, order)
            ),
        )
        for degree, invariant, order, suffix in specifications
    ]


@cache
def module_data(label):
    if label not in PHASES:
        return ORIGINAL_MODULE_DATA(label)
    exact = load(
        HERE / "2026-07-28-c682-klein-e8-free-covariant.py",
        f"monotone_exact_{label}",
    )
    tools, klein, hessian, jacobian, _ = exact.build_data()
    if label == "2p":
        seed = {(7, 0): 1, (2, 5): -7}
        specifications = [
            (7, None, 0, None),
            (13, klein, 3, None),
            (17, hessian, 5, None),
            (23, jacobian, 7, None),
        ]
    elif label == "4":
        seed = {(4, 2): 1}
        specifications = [
            (6, None, 0, None),
            (8, klein, 5, None),
            (12, klein, 3, None),
            (14, klein, 2, None),
            (16, klein, 1, None),
            (18, hessian, 4, None),
            (22, hessian, 2, None),
            (24, hessian, 1, None),
        ]
    elif label == "4s":
        seed = {(3, 0): 1}
        specifications = [
            (3, None, 0, None),
            (9, klein, 3, None),
            (11, klein, 2, None),
            (13, klein, 1, None),
            (17, hessian, 3, None),
            (19, hessian, 2, None),
            (21, hessian, 1, None),
            (27, jacobian, 3, None),
        ]
    elif label == "5":
        seed = {(4, 0): 1}
        specifications = [
            (4, None, 0, None),
            (8, klein, 4, None),
            (10, klein, 3, None),
            (12, klein, 2, None),
            (14, klein, 1, None),
            (16, hessian, 4, None),
            (18, hessian, 3, None),
            (20, hessian, 2, None),
            (22, hessian, 1, None),
            (26, jacobian, 4, None),
        ]
    else:
        seed = {(5, 0): 1}
        specifications = [
            (5, None, 0, None),
            (7, klein, 5, None),
            (9, klein, 4, None),
            (11, klein, 3, None),
            (13, klein, 2, None),
            (15, klein, 1, "a"),
            (15, hessian, 5, "b"),
            (17, hessian, 4, None),
            (19, hessian, 3, None),
            (21, hessian, 2, None),
            (23, hessian, 1, None),
            (25, jacobian, 5, None),
        ]
    generators = transvectant_generators(
        seed, specifications, tools
    )
    assert [degree for _, degree, _ in generators] == (
        GENERATOR_DEGREES[label]
    )
    return exact, tools, klein, hessian, generators


BASE.GLOBAL.MODULE_DATA.module_data = module_data
for module_label in PHASES:
    BASE.GENERATORS[module_label] = [
        (name, degree)
        for name, degree, _ in module_data(module_label)[-1]
    ]


def generate_operators():
    return {
        label: {
            str(order): BASE.GLOBAL.fit_operator(label, order)
            for order in BASE.GLOBAL.ORDERS
        }
        for label in PHASES
    }


def boundary_data(
    label,
    phase,
    q,
    operators,
    endpoint_keys=None,
    tail_width=None,
):
    if tail_width is None:
        for candidate in range(1, 11):
            try:
                return boundary_data(
                    label,
                    phase,
                    q,
                    operators,
                    endpoint_keys,
                    candidate,
                )
            except (AssertionError, StopIteration):
                continue
        raise AssertionError((label, phase, q, "no boundary width"))
    degree = 60 + phase + 60 * q
    lower, current, incoming = BASE.operator_matrix(
        label, degree - 6, 3, operators
    )
    current_2, upper, outgoing = BASE.operator_matrix(
        label, degree, 3, operators
    )
    upper_2, current_3, ninth = BASE.operator_matrix(
        label, degree + 6, 9, operators
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    third_denominator = BASE.operator_denominator(
        label, 3, operators
    )
    ninth_denominator = BASE.operator_denominator(
        label, 9, operators
    )
    incoming = BASE.scale_columns(incoming, third_denominator)
    outgoing = BASE.scale_columns(outgoing, third_denominator)
    ninth = BASE.scale_columns(ninth, ninth_denominator)
    current_levels = BASE.local_levels(current)
    lower_levels = BASE.local_levels(lower)
    maxima = {}
    for (name, *_), level in zip(current, current_levels):
        maxima[name] = max(maxima.get(name, -1), level)
    tail = [
        index
        for index, ((name, *_), level) in enumerate(
            zip(current, current_levels)
        )
        if level >= maxima[name] - tail_width + 1
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
    incoming_rank = BASE.rank_columns(local_incoming)
    assert incoming_rank == len(local_incoming)
    quotient_dimension = len(tail) - incoming_rank
    assert quotient_dimension > 0

    def returned(index):
        vector = BASE.matvec(
            ninth, BASE.matvec(outgoing, incoming[index])
        )
        assert all(
            not value or position in tail_set
            for position, value in enumerate(vector)
        )
        return [vector[position] for position in tail]

    if endpoint_keys is None:
        selected = []
        columns = list(local_incoming)
        current_rank = incoming_rank
        for index in reversed(range(len(lower))):
            try:
                column = returned(index)
            except AssertionError:
                continue
            new_rank = BASE.rank_columns(columns + [column])
            if new_rank > current_rank:
                selected.append(index)
                columns.append(column)
                current_rank = new_rank
            if current_rank == len(tail):
                break
        assert len(selected) == quotient_dimension
        endpoint_keys = [
            BASE.endpoint_key(lower, lower_levels, index)
            for index in selected
        ]
    else:
        selected = [
            BASE.endpoint_index(
                lower, lower_levels, tuple(key)
            )
            for key in endpoint_keys
        ]
        columns = local_incoming + [
            returned(index) for index in selected
        ]
    determinant = BASE.determinant_columns_integer(columns)
    assert determinant
    return {
        "degree": degree,
        "tail_width": tail_width,
        "tail_dimension": len(tail),
        "quotient_dimension": quotient_dimension,
        "endpoint_keys": endpoint_keys,
        "incoming_denominator_scale": third_denominator,
        "return_denominator_scale": (
            third_denominator**2 * ninth_denominator
        ),
        "determinant": determinant,
    }


WORKER_OPERATORS = None


def initialize_boundary_workers(operators):
    global WORKER_OPERATORS
    WORKER_OPERATORS = operators


def generate_boundary_family(arguments):
    label, phase = arguments
    operators = WORKER_OPERATORS
    assert operators is not None
    family = f"{label}_{phase}"
    first = boundary_data(label, phase, 10, operators)
    degree_bound = (
        3
        * (first["tail_dimension"] - first["quotient_dimension"])
        + 15 * first["quotient_dimension"]
    )
    endpoint_keys = first["endpoint_keys"]
    values = [
        boundary_data(
            label,
            phase,
            q,
            operators,
            endpoint_keys,
            first["tail_width"],
        )["determinant"]
        for q in range(10, 10 + degree_bound + 1)
    ]
    coefficients = BASE.newton_coefficients(values)
    return family, {
        "module": label,
        "phase": phase,
        "base_degree": 60 + phase,
        "base_q": 10,
        "tail_dimension": first["tail_dimension"],
        "tail_width": first["tail_width"],
        "quotient_dimension": first["quotient_dimension"],
        "endpoint_keys": endpoint_keys,
        "incoming_denominator_scale": first[
            "incoming_denominator_scale"
        ],
        "return_denominator_scale": first[
            "return_denominator_scale"
        ],
        "degree_bound": degree_bound,
        "degree": len(coefficients) - 1,
        "newton_coefficients": [str(value) for value in coefficients],
    }


def generate_boundary(operators):
    arguments = [
        (label, phase)
        for label, phases in PHASES.items()
        for phase in phases
        if phase not in EXCEPTIONAL_PHASES.get(label, set())
    ]
    with multiprocessing.Pool(
        processes=4,
        initializer=initialize_boundary_workers,
        initargs=(operators,),
    ) as pool:
        rows = pool.map(generate_boundary_family, arguments, chunksize=1)
    return dict(sorted(rows))


def generate_certificate(operators, boundary):
    results = {}
    for family, row in boundary.items():
        polynomial = BASE.newton_to_monomial(
            [Fraction(value) for value in row["newton_coefficients"]]
        )
        roots = []
        residual = polynomial
        for root in range(-2000, 0):
            while (
                len(residual) > 1
                and not BASE.polynomial_value(residual, root)
            ):
                roots.append(root)
                residual = BASE.divide_linear(
                    residual, Fraction(root)
                )
        shift = next(
            candidate
            for candidate in range(2001)
            if BASE.uniform_sign(
                BASE.shifted_coefficients(residual, candidate)
            )
        )
        threshold = row["base_q"] + shift
        finite = [
            boundary_data(
                row["module"],
                row["phase"],
                q,
                operators,
                row["endpoint_keys"],
                row["tail_width"],
            )["determinant"]
            for q in range(row["base_q"], threshold)
        ]
        low = [
            boundary_data(
                row["module"], row["phase"], q, operators
            )
            for q in range(1, row["base_q"])
        ]
        assert all(finite)
        results[family] = {
            "module": row["module"],
            "family": f"n={row['base_degree']}+60q",
            "phase_mod_60": row["phase"],
            "tail_dimension": row["tail_dimension"],
            "quotient_dimension": row["quotient_dimension"],
            "endpoint_keys": row["endpoint_keys"],
            "degree_bound": row["degree_bound"],
            "exact_degree": row["degree"],
            "linear_roots_in_x_equals_q_minus_10": roots,
            "residual_degree": len(residual) - 1,
            "positivity_threshold_q": threshold,
            "shifted_residual_sign": BASE.uniform_sign(
                BASE.shifted_coefficients(residual, shift)
            ),
            "finite_boundary_signs": [
                (value > 0) - (value < 0) for value in finite
            ],
            "low_q_quotient_dimensions": [
                entry["quotient_dimension"] for entry in low
            ],
            "low_q_determinant_signs": [
                (entry["determinant"] > 0)
                - (entry["determinant"] < 0)
                for entry in low
            ],
            "conclusion": (
                "the complete local entrance quotient is spanned for "
                "every integer q>=1"
            ),
        }
    return {
        "schema": "c682-monotone-entrance-propagation-v1",
        "phase_count": len(results),
        "exceptional_phases": {
            label: sorted(phases)
            for label, phases in EXCEPTIONAL_PHASES.items()
        },
        "phases": results,
        "modulo_20_types": {
            label: sorted({phase % 20 for phase in phases})
            for label, phases in PHASES.items()
        },
        "claim": (
            "All 51 nonexceptional multiplicity-increase entrances in "
            "the monotone 2',4,4s,5,6 modules are boundary-surjective "
            "for every integer q>=1. With all-weight maximal rank, "
            "their full graded path corners propagate in every weight."
        ),
        "remaining_frontier": {
            label: sorted(phases)
            for label, phases in EXCEPTIONAL_PHASES.items()
        } | {
            "reason": (
                "In these four modulo-20 types the first-return columns "
                "span codimension one in the complete raw local quotient. "
                "The missing direction is removed only by the global "
                "block Schur complement, so a signed block-transfer "
                "argument remains necessary."
            ),
        },
        "trusted_boundary": (
            "Exact global falling-factorial Weyl operators are verified "
            "beyond their training grids. Denominator-cleared boundary "
            "determinants are certified within formal differential-order "
            "degree bounds by exact Newton data, one-sign residuals, and "
            "finite prefixes."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write-operators", action="store_true")
    mode.add_argument("--write-boundary", action="store_true")
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    if arguments.write_operators:
        rendered = json.dumps(
            generate_operators(), indent=2, sort_keys=True
        ) + "\n"
        OPERATORS.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {OPERATORS}")
        return
    operators = json.loads(OPERATORS.read_text(encoding="utf-8"))
    if arguments.write_boundary:
        rendered = json.dumps(
            generate_boundary(operators), indent=2, sort_keys=True
        ) + "\n"
        BOUNDARY.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {BOUNDARY}")
        return
    if arguments.check:
        expected_operators = json.dumps(
            generate_operators(), indent=2, sort_keys=True
        ) + "\n"
        assert OPERATORS.read_text(encoding="utf-8") == expected_operators
        expected_boundary = json.dumps(
            generate_boundary(operators), indent=2, sort_keys=True
        ) + "\n"
        assert BOUNDARY.read_text(encoding="utf-8") == expected_boundary
    boundary = json.loads(BOUNDARY.read_text(encoding="utf-8"))
    rendered = json.dumps(
        generate_certificate(operators, boundary),
        indent=2,
        sort_keys=True,
    ) + "\n"
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")
    else:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 monotone entrance propagation")


if __name__ == "__main__":
    main()
