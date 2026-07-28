#!/usr/bin/env python3
"""Exact first-failure certificate for the Klein E8 return algebra."""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-28-c682-klein-e8-operator-algebra.py"
CERTIFICATE = HERE / "2026-07-28-c682-klein-e8-first-failure.json"


def load_base():
    spec = importlib.util.spec_from_file_location("klein_e8_base", BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {BASE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def flattened(matrix):
    return [entry for row in matrix for entry in row]


def balanced_loop_span(base, degree: int, maximum_length: int) -> tuple[int, int]:
    states = [(degree, base.identity(degree + 1))]
    loops = []
    for length in range(1, maximum_length + 1):
        next_states = []
        for current_degree, operator in states:
            next_states.append(
                (
                    current_degree + 6,
                    base.matrix_multiply(
                        base.delta_matrix(current_degree),
                        operator,
                    ),
                )
            )
            if current_degree >= 6:
                next_states.append(
                    (
                        current_degree - 6,
                        base.matrix_multiply(
                            base.adjoint(
                                base.delta_matrix(current_degree - 6),
                                current_degree - 6,
                            ),
                            operator,
                        ),
                    )
                )
        states = next_states
        if length % 2 == 0:
            loops.extend(
                operator
                for current_degree, operator in states
                if current_degree == degree
            )
    return len(loops), base.matrix_rank([flattened(operator) for operator in loops])


def build_certificate() -> dict[str, object]:
    base = load_base()
    rows = []
    for degree in range(23):
        decomposition = base.mckay_decomposition(degree)
        commutant_dimension = sum(
            multiplicity * multiplicity
            for multiplicity in decomposition.values()
        )
        first_return = base.round_trip_operator(degree, 1)
        second_return = base.round_trip_operator(degree, 2)
        return_dimension = base.generated_algebra_dimension(
            [first_return, second_return]
        )
        rows.append(
            {
                "degree": degree,
                "decomposition": decomposition,
                "commutant_dimension": commutant_dimension,
                "two_return_dimension": return_dimension,
            }
        )

    if any(
        row["commutant_dimension"] != row["two_return_dimension"]
        for row in rows[:22]
    ):
        raise AssertionError("saturation failed before degree 22")
    if rows[22] != {
        "degree": 22,
        "decomposition": {"3": 2, "5": 2, "3p": 1, "4": 1},
        "commutant_dimension": 10,
        "two_return_dimension": 8,
    }:
        raise AssertionError("unexpected degree-22 failure")

    degree = 22
    first_return = base.round_trip_operator(degree, 1)
    second_return = base.round_trip_operator(degree, 2)
    commutator = base.matrix_subtract(
        base.matrix_multiply(first_return, second_return),
        base.matrix_multiply(second_return, first_return),
    )
    commutator_rank = base.matrix_rank(commutator)
    if commutator_rank != 10:
        raise AssertionError("the degree-22 commutator should resolve only the doubled 5")

    third_return_dimension = base.generated_algebra_dimension(
        [
            first_return,
            second_return,
            base.round_trip_operator(degree, 3),
        ]
    )
    if third_return_dimension != 8:
        raise AssertionError("the third straight return should not repair degree 22")

    loop_count, loop_span_dimension = balanced_loop_span(base, degree, 8)
    if (loop_count, loop_span_dimension) != (97, 7):
        raise AssertionError("unexpected bounded balanced-word span")

    adjacent_decompositions = {
        str(neighbor): base.mckay_decomposition(neighbor)
        for neighbor in (16, 22, 28)
    }
    if adjacent_decompositions != {
        "16": {"5": 2, "3p": 1, "4": 1},
        "22": {"3": 2, "5": 2, "3p": 1, "4": 1},
        "28": {"3": 1, "5": 3, "3p": 1, "4": 2},
    }:
        raise AssertionError("unexpected adjacent affine-E8 multiplicities")
    bottlenecks = []
    for current_degree in range(23):
        current = base.mckay_decomposition(current_degree)
        lower = (
            base.mckay_decomposition(current_degree - 6)
            if current_degree >= 6
            else {}
        )
        upper = base.mckay_decomposition(current_degree + 6)
        for module, multiplicity in current.items():
            if (
                multiplicity >= 2
                and lower.get(module, 0) == 0
                and upper.get(module, 0) == 1
            ):
                bottlenecks.append(
                    {
                        "degree": current_degree,
                        "module": module,
                        "multiplicity": multiplicity,
                    }
                )
    if bottlenecks != [{"degree": 22, "module": "3", "multiplicity": 2}]:
        raise AssertionError("degree 22 should be the first local bottleneck")

    return {
        "schema": "c682-klein-e8-first-failure-v1",
        "field": "exact matrices over Q; commutant comparison after base change to C",
        "operator": "delta=(.,Phi_12)_3 with positive Fischer adjoint",
        "tested_degrees": [0, 22],
        "return_generators": [
            "C_n=delta_n^dagger delta_n",
            "D_n=(delta_n^dagger)^2 delta_n^2",
        ],
        "rows": rows,
        "first_failure": {
            "degree": 22,
            "decomposition": "3^2 direct_sum 5^2 direct_sum 3p direct_sum 4",
            "full_commutant_over_C": "Mat_2(C) direct_sum Mat_2(C) direct_sum C direct_sum C",
            "full_commutant_dimension": 10,
            "return_algebra_over_C": "C^2 direct_sum Mat_2(C) direct_sum C direct_sum C",
            "return_algebra_dimension": 8,
            "commutator_rank": commutator_rank,
            "unresolved_block": "the doubled 3",
        },
        "structural_obstruction": {
            "adjacent_affine_E8_decompositions": adjacent_decompositions,
            "downward_3_multiplicity": 0,
            "current_3_multiplicity": 2,
            "upward_3_multiplicity": 1,
            "corner_on_3_multiplicity_space": "span{I,A^dagger A}, dimension 2",
            "bottlenecks_through_degree_22": bottlenecks,
            "conclusion": (
                "Every primitive downward excursion vanishes on the doubled 3. "
                "Every primitive upward excursion factors through the "
                "one-dimensional 3-multiplicity space in degree 28 and is a "
                "scalar multiple of A^dagger A. Hence every closed word in "
                "delta and delta^dagger is commutative on this block, so the "
                "full graded corner cannot contain Mat_2(Q)."
            ),
        },
        "bounded_word_cross_check": {
            "maximum_word_length": 8,
            "balanced_nonempty_words": loop_count,
            "nonunital_span_dimension": loop_span_dimension,
            "unital_span_dimension": loop_span_dimension + 1,
            "third_straight_return_algebra_dimension": third_return_dimension,
        },
        "claim_boundary": [
            "Degree 22 is the first failure among every integer degree n >= 0.",
            "Saturation through degree 21 is exact for the two shortest returns.",
            "The affine-E8 neighbor obstruction proves failure of the full graded corner at degree 22.",
            "No claim is made about the complete presentation or later failure pattern.",
        ],
    }


def canonical_json(data: dict[str, object]) -> str:
    return json.dumps(data, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = canonical_json(build_certificate())
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(CERTIFICATE)
        return
    if not CERTIFICATE.exists():
        raise SystemExit(f"missing certificate: {CERTIFICATE}")
    if CERTIFICATE.read_text(encoding="utf-8") != rendered:
        raise SystemExit("certificate is stale")
    print("c682 Klein E8 first-failure certificate: PASS")


if __name__ == "__main__":
    main()
