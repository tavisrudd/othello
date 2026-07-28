#!/usr/bin/env python3
"""Exact first-failure certificate for the Klein E8 return algebra."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from functools import reduce
from math import gcd
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


def coefficient_vector(polynomial, degree: int):
    return [
        polynomial.get((degree - index, index), 0)
        for index in range(degree + 1)
    ]


def nullspace(matrix):
    work = [[Fraction(entry) for entry in row] for row in matrix]
    row_count = len(work)
    column_count = len(work[0]) if work else 0
    pivot_columns = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        pivot_value = work[pivot_row][column]
        work[pivot_row] = [entry / pivot_value for entry in work[pivot_row]]
        for row in range(row_count):
            if row == pivot_row or not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == row_count:
            break
    free_columns = [
        column for column in range(column_count) if column not in pivot_columns
    ]
    basis = []
    for free in free_columns:
        vector = [Fraction(0)] * column_count
        vector[free] = Fraction(1)
        for row, pivot in enumerate(pivot_columns):
            vector[pivot] = -work[row][free]
        basis.append(vector)
    return basis


def covariant_bottleneck(base):
    klein = base.KLEIN_F
    hessian = base.transvectant(klein, klein, 2)
    jacobian = base.transvectant(klein, hessian, 1)
    hessian_content = reduce(gcd, (abs(value) for value in hessian.values()))
    jacobian_content = reduce(gcd, (abs(value) for value in jacobian.values()))
    if (hessian_content, jacobian_content) != (242, 4840):
        raise AssertionError("unexpected contents of the Klein invariants")
    primitive_hessian = {
        monomial: coefficient // hessian_content
        for monomial, coefficient in hessian.items()
    }
    quadratic_basis = [
        {(2, 0): 1},
        {(1, 1): 1},
        {(0, 2): 1},
    ]
    second_polars = [
        base.derivative(klein, 2, 0),
        base.derivative(klein, 1, 1),
        base.derivative(klein, 0, 2),
    ]
    degree_twenty_two = [
        base.multiply(hessian, quadratic)
        for quadratic in quadratic_basis
    ] + [
        base.multiply(klein, polar)
        for polar in second_polars
    ]
    images = [
        base.transvectant(polynomial, klein, 3)
        for polynomial in degree_twenty_two
    ]
    image_matrix = [
        [coefficient_vector(image, 28)[row] for image in images]
        for row in range(29)
    ]
    kernel = nullspace(image_matrix)
    expected_kernel = [
        [
            Fraction(0),
            Fraction(0),
            Fraction(5, 11),
            Fraction(1),
            Fraction(0),
            Fraction(0),
        ],
        [
            Fraction(0),
            Fraction(-5, 11),
            Fraction(0),
            Fraction(0),
            Fraction(1),
            Fraction(0),
        ],
        [
            Fraction(5, 11),
            Fraction(0),
            Fraction(0),
            Fraction(0),
            Fraction(0),
            Fraction(1),
        ],
    ]
    if kernel != expected_kernel:
        raise AssertionError("the degree-22 doubled 3 should map with rank three")
    if any(
        coefficient % 11
        for polar in second_polars
        for coefficient in polar.values()
    ):
        raise AssertionError("the ordinary second polars should vanish modulo 11")
    if not any(coefficient % 11 for coefficient in primitive_hessian.values()):
        raise AssertionError("the primitive Hessian should survive modulo 11")
    target_three = [
        base.derivative(jacobian, 2, 0),
        base.derivative(jacobian, 1, 1),
        base.derivative(jacobian, 0, 2),
    ]
    image_vectors = [coefficient_vector(image, 28) for image in images]
    target_vectors = [coefficient_vector(polynomial, 28) for polynomial in target_three]
    if (
        base.matrix_rank(image_vectors) != 3
        or base.matrix_rank(target_vectors) != 3
        or base.matrix_rank(image_vectors + target_vectors) != 3
    ):
        raise AssertionError("the image should be Pol_2(T_30)")

    nodes = ["1", "2", "3", "4s", "5", "6", "3p", "4", "2p"]
    decompositions = [base.mckay_decomposition(degree) for degree in range(121)]
    numerators = {}
    for module in nodes:
        numerator = []
        for degree in range(121):
            coefficient = decompositions[degree].get(module, 0)
            if degree >= 12:
                coefficient -= decompositions[degree - 12].get(module, 0)
            if degree >= 20:
                coefficient -= decompositions[degree - 20].get(module, 0)
            if degree >= 32:
                coefficient += decompositions[degree - 32].get(module, 0)
            if coefficient:
                numerator.append([degree, coefficient])
        numerators[module] = numerator
    if numerators["3"] != [
        [2, 1],
        [10, 1],
        [12, 1],
        [18, 1],
        [20, 1],
        [28, 1],
    ]:
        raise AssertionError("unexpected Molien numerator for the 3-covariants")
    residue_starts = {
        module: {
            residue: min(
                degree
                for degree, _ in numerator
                if degree % 4 == residue
            )
            for residue in {degree % 4 for degree, _ in numerator}
        }
        for module, numerator in numerators.items()
    }
    positivity_bound = max(
        6 + 32 + max(starts.values())
        for starts in residue_starts.values()
    )
    forced_bottlenecks = []
    for degree in range(positivity_bound):
        current = base.mckay_decomposition(degree)
        lower = base.mckay_decomposition(degree - 6) if degree >= 6 else {}
        upper = base.mckay_decomposition(degree + 6)
        for module, multiplicity in current.items():
            if (
                multiplicity >= 2
                and lower.get(module, 0) == 0
                and upper.get(module, 0) == 1
            ):
                forced_bottlenecks.append([degree, module, multiplicity])
    if forced_bottlenecks != [[22, "3", 2]]:
        raise AssertionError("unexpected all-weight local bottleneck classification")
    return {
        "Molien_series_for_3_covariants": (
            "(t^2+t^10+t^12+t^18+t^20+t^28)"
            "/((1-t^12)(1-t^20))"
        ),
        "degree_22_generators": [
            "H_20 Sym^2",
            "Phi_12 Pol_2(Phi_12)",
        ],
        "H_20": "(Phi_12,Phi_12)_2",
        "Pol_2_basis": [
            "dX^2 Phi_12",
            "dX dY Phi_12",
            "dY^2 Phi_12",
        ],
        "kernel_basis_in_order_HX2_HXY_HY2_FFXX_FFXY_FFYY": [
            [str(entry) for entry in vector]
            for vector in kernel
        ],
        "dark_line": (
            "ker Delta is spanned by "
            "Phi Phi_XX+(5/11)H Y^2, "
            "Phi Phi_XY-(5/11)H XY, "
            "Phi Phi_YY+(5/11)H X^2"
        ),
        "degree_28_target": (
            "Pol_2(T_30), where T_30=(Phi_12,H_20)_1"
        ),
        "bright_line": "Delta^dagger Pol_2(T_30)",
        "integral_normalization": {
            "H_20_content": hessian_content,
            "T_30_content": jacobian_content,
            "primitive_dark_line": (
                "Phi Phi_XX+110 h Y^2, "
                "Phi Phi_XY-110 h XY, "
                "Phi Phi_YY+110 h X^2, where H=242 h"
            ),
            "coupling_factor": "110=2*5*11",
            "mod_11": (
                "Pol_2(Phi_12) vanishes for ordinary derivatives, "
                "while primitive h_20 survives"
            ),
            "boundary": (
                "This diagnoses the need for divided powers; it does not "
                "identify the earlier primitive mod-11 return map."
            ),
        },
        "all_weight_bottleneck_classification": {
            "Molien_numerators_over_Q_Phi12_H20": numerators,
            "semigroup_fact": (
                "every multiple of 4 at least 32 lies in <12,20>"
            ),
            "lower_neighbor_positive_from_degree": positivity_bound,
            "finite_scan": f"0..{positivity_bound - 1}",
            "forced_bottlenecks": forced_bottlenecks,
        },
    }


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
        "schema": "c682-klein-e8-first-failure-v2",
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
        "standard_covariant_identification": covariant_bottleneck(base),
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
