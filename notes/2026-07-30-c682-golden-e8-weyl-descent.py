#!/usr/bin/env python3
"""All-degree rational Weyl descent for the golden pair of E8 McKay towers."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-28-c682-klein-e8-operator-algebra.py"
GOLDEN_PATH = HERE / "2026-07-30-c682-golden-e8-descent.json"
CERTIFICATE = HERE / "2026-07-30-c682-golden-e8-weyl-descent.json"
BASE_SHA256 = "53b233ebe6bad4e1bcd6fcd40b20ac2329fabb0d69610ecd375d093826bcf963"
GOLDEN_SHA256 = "c81bff612916eb6e07256056b016019778bf5a51060e858fdebbed7d57b8e5c8"

Matrix = list[list[Fraction]]


def load_base():
    if hashlib.sha256(BASE_PATH.read_bytes()).hexdigest() != BASE_SHA256:
        raise AssertionError("base Klein checker hash changed")
    spec = importlib.util.spec_from_file_location("c682_weyl_descent_base", BASE_PATH)
    if spec is None or spec.loader is None:
        raise AssertionError("could not load base Klein checker")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def identity(rows: int, columns: int | None = None) -> Matrix:
    if columns is None:
        columns = rows
    return [
        [Fraction(int(row == column)) for column in range(columns)]
        for row in range(rows)
    ]


def zero_matrix(rows: int, columns: int) -> Matrix:
    return [[Fraction(0)] * columns for _ in range(rows)]


def matrix_scale(matrix: Matrix, scalar: int | Fraction) -> Matrix:
    scalar = Fraction(scalar)
    return [[scalar * entry for entry in row] for row in matrix]


def block_matrix(
    upper_left: Matrix,
    upper_right: Matrix,
    lower_left: Matrix,
    lower_right: Matrix,
) -> Matrix:
    return [
        upper_left[row] + upper_right[row]
        for row in range(len(upper_left))
    ] + [
        lower_left[row] + lower_right[row]
        for row in range(len(lower_left))
    ]


def rationalize(matrix_zero: Matrix, matrix_one: Matrix) -> Matrix:
    """Matrix of A+B*sqrt(5) on restriction of scalars."""
    return block_matrix(
        matrix_zero,
        matrix_scale(matrix_one, 5),
        matrix_one,
        matrix_zero,
    )


def golden_operator(size: int) -> Matrix:
    zero = zero_matrix(size, size)
    unit = identity(size)
    return block_matrix(zero, matrix_scale(unit, 5), unit, zero)


def matrix_multiply(left: Matrix, right: Matrix) -> Matrix:
    return [
        [
            sum(left[row][middle] * right[middle][column] for middle in range(len(right)))
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def fischer_norm(degree: int, index: int) -> int:
    from math import factorial

    return factorial(degree - index) * factorial(index)


def weighted_fischer_adjoint(matrix: Matrix, source_degree: int) -> Matrix:
    """Adjoint for Fischer tensor the trace form diag(1,5)."""
    source_size = source_degree + 1
    target_size = source_degree + 7
    if len(matrix) != 2 * target_size or len(matrix[0]) != 2 * source_size:
        raise AssertionError("unexpected descended Weyl matrix shape")
    source_weights = (1, 5)
    target_weights = (1, 5)
    return [
        [
            matrix[target_half * target_size + target_index][
                source_half * source_size + source_index
            ]
            * Fraction(
                target_weights[target_half]
                * fischer_norm(source_degree + 6, target_index),
                source_weights[source_half]
                * fischer_norm(source_degree, source_index),
            )
            for target_half in range(2)
            for target_index in range(target_size)
        ]
        for source_half in range(2)
        for source_index in range(source_size)
    ]


def split_axis_klein_forms() -> tuple[dict[tuple[int, int], int], dict[tuple[int, int], int]]:
    """F_axis=F0+sqrt(5)*F1 after t=(1+sqrt(5))/2."""
    rational_coefficients = {
        0: -5,
        2: 44,
        4: 165,
        6: -88,
        8: 165,
        10: 44,
        12: -5,
    }
    golden_coefficients = {
        0: -2,
        2: 22,
        4: 66,
        6: -44,
        8: 66,
        10: 22,
        12: -2,
    }
    return (
        {(12 - index, index): value for index, value in rational_coefficients.items()},
        {(12 - index, index): value for index, value in golden_coefficients.items()},
    )


def matrix_rank_mod_prime(matrix: list[list[int]], prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    rank = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], -1, prime)
        work[rank] = [(inverse * entry) % prime for entry in work[rank]]
        for row in range(len(work)):
            if row == rank:
                continue
            factor = work[row][column]
            work[row] = [
                (entry - factor * pivot_entry) % prime
                for entry, pivot_entry in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def determinant_integer(matrix: list[list[int]]) -> int:
    work = [list(row) for row in matrix]
    sign = 1
    previous = 1
    for column in range(len(work) - 1):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            sign *= -1
        value = work[column][column]
        for row in range(column + 1, len(work)):
            for target in range(column + 1, len(work)):
                work[row][target] = (
                    work[row][target] * value
                    - work[row][column] * work[column][target]
                ) // previous
        previous = value
    return sign * work[-1][-1]


def integer_matrix_multiply(
    left: list[list[int]],
    right: list[list[int]],
) -> list[list[int]]:
    return [
        [
            sum(left[row][middle] * right[middle][column] for middle in range(len(right)))
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def subtract_identity_mod_two_rank(matrix: list[list[int]]) -> int:
    shifted = [
        [
            entry - int(row == column)
            for column, entry in enumerate(matrix[row])
        ]
        for row in range(len(matrix))
    ]
    return matrix_rank_mod_prime(shifted, 2)


def build_certificate() -> dict[str, object]:
    base = load_base()
    if hashlib.sha256(GOLDEN_PATH.read_bytes()).hexdigest() != GOLDEN_SHA256:
        raise AssertionError("golden descent certificate hash changed")
    golden = json.loads(GOLDEN_PATH.read_text(encoding="utf-8"))
    conference = golden["six_axis_harmonic_model"]["conference_matrix"]
    form_zero, form_one = split_axis_klein_forms()

    checked_degrees = list(range(25)) + [30, 40, 60]
    checked_shapes = []
    for degree in checked_degrees:
        delta_zero = base.delta_matrix(degree, form_zero)
        delta_one = base.delta_matrix(degree, form_one)
        descended_delta = rationalize(delta_zero, delta_one)
        source_golden = golden_operator(degree + 1)
        target_golden = golden_operator(degree + 7)
        if (
            matrix_multiply(target_golden, descended_delta)
            != matrix_multiply(descended_delta, source_golden)
        ):
            raise AssertionError(f"golden intertwining failed in degree {degree}")

        descended_adjoint = weighted_fischer_adjoint(descended_delta, degree)
        expected_adjoint = rationalize(
            base.adjoint(delta_zero, degree),
            base.adjoint(delta_one, degree),
        )
        if descended_adjoint != expected_adjoint:
            raise AssertionError(f"weighted adjoint failed in degree {degree}")
        if (
            matrix_multiply(source_golden, descended_adjoint)
            != matrix_multiply(descended_adjoint, target_golden)
        ):
            raise AssertionError(f"adjoint intertwining failed in degree {degree}")

        descended_return = matrix_multiply(descended_adjoint, descended_delta)
        if (
            matrix_multiply(source_golden, descended_return)
            != matrix_multiply(descended_return, source_golden)
        ):
            raise AssertionError(f"return commutator failed in degree {degree}")
        checked_shapes.append(
            {
                "degree": degree,
                "raising_shape": [
                    len(descended_delta),
                    len(descended_delta[0]),
                ],
            }
        )

    seeds = [0, 1, 2]
    seed_columns = [
        [int(row == column) for row in range(6)]
        for column in seeds
    ]
    image_columns = [
        [conference[row][column] for row in range(6)]
        for column in seeds
    ]
    columns = seed_columns + image_columns
    comparison = [
        [columns[column][row] for column in range(6)]
        for row in range(6)
    ]
    companion = [
        [int(row >= 3 and column == row - 3) + 5 * int(row < 3 and column == row + 3)
         for column in range(6)]
        for row in range(6)
    ]
    if integer_matrix_multiply(conference, comparison) != integer_matrix_multiply(
        comparison,
        companion,
    ):
        raise AssertionError("conference/companion comparison failed")
    five_identity = [
        [5 * int(row == column) for column in range(6)]
        for row in range(6)
    ]
    if (
        integer_matrix_multiply(conference, conference) != five_identity
        or integer_matrix_multiply(companion, companion) != five_identity
    ):
        raise AssertionError("golden square relation failed")
    comparison_determinant = determinant_integer(comparison)
    if comparison_determinant != 4:
        raise AssertionError("unexpected comparison lattice index")
    conference_mod_two_rank = subtract_identity_mod_two_rank(conference)
    companion_mod_two_rank = subtract_identity_mod_two_rank(companion)
    if (conference_mod_two_rank, companion_mod_two_rank) != (1, 3):
        raise AssertionError("unexpected mod-two Jordan ranks")
    comparison_mod_two_rank = matrix_rank_mod_prime(comparison, 2)
    if comparison_mod_two_rank != 4:
        raise AssertionError("unexpected mod-two comparison rank")
    smith_invariants = [1, 1, 1, 1, 2, 2]
    quotient_coordinates = [
        [0, 0, 0, 1, 1, 0],
        [0, 0, 0, 1, 0, 1],
    ]
    quotient_on_comparison = [
        [
            sum(
                quotient_coordinates[row][middle] * comparison[middle][column]
                for middle in range(6)
            )
            % 2
            for column in range(6)
        ]
        for row in range(2)
    ]
    quotient_after_conference = [
        [
            sum(
                quotient_coordinates[row][middle] * conference[middle][column]
                for middle in range(6)
            )
            % 2
            for column in range(6)
        ]
        for row in range(2)
    ]
    if quotient_on_comparison != [[0] * 6 for _ in range(2)]:
        raise AssertionError("quotient coordinates do not kill the sublattice")
    if quotient_after_conference != quotient_coordinates:
        raise AssertionError("conference action on the quotient is not scalar")
    conference_mod_five_rank = matrix_rank_mod_prime(conference, 5)
    companion_mod_five_rank = matrix_rank_mod_prime(companion, 5)
    comparison_mod_five_rank = matrix_rank_mod_prime(comparison, 5)
    if (
        conference_mod_five_rank,
        companion_mod_five_rank,
        comparison_mod_five_rank,
    ) != (3, 3, 6):
        raise AssertionError("unexpected mod-five comparison")

    triple_determinants = []
    for triple in itertools.combinations(range(6), 3):
        triple_seed_columns = [
            [int(row == column) for row in range(6)]
            for column in triple
        ]
        triple_image_columns = [
            [conference[row][column] for row in range(6)]
            for column in triple
        ]
        triple_columns = triple_seed_columns + triple_image_columns
        triple_comparison = [
            [triple_columns[column][row] for column in range(6)]
            for row in range(6)
        ]
        determinant = determinant_integer(triple_comparison)
        triangle_sign = (
            conference[triple[0]][triple[1]]
            * conference[triple[1]][triple[2]]
            * conference[triple[2]][triple[0]]
        )
        if determinant != -4 * triangle_sign:
            raise AssertionError("Krylov determinant/cubic identity failed")
        triple_determinants.append(
            {
                "triple": list(triple),
                "determinant": determinant,
                "triangle_sign": triangle_sign,
            }
        )

    return {
        "schema": "c682-golden-e8-weyl-descent-v1",
        "inputs": {
            BASE_PATH.name: {
                "sha256": BASE_SHA256,
                "bytes": len(BASE_PATH.read_bytes()),
            },
            GOLDEN_PATH.name: {
                "sha256": GOLDEN_SHA256,
                "bytes": len(GOLDEN_PATH.read_bytes()),
            },
        },
        "axis_klein_split": {
            "field": "Q(sqrt(5))",
            "form": "F_axis=F0+sqrt(5)*F1",
            "F0_coefficients_by_y_exponent": {
                str(y): coefficient for (x, y), coefficient in sorted(form_zero.items())
            },
            "F1_coefficients_by_y_exponent": {
                str(y): coefficient for (x, y), coefficient in sorted(form_one.items())
            },
        },
        "all_degree_weyl_descent": {
            "Delta_hat": "[[Delta0,5*Delta1],[Delta1,Delta0]]",
            "golden_operator": "J=[[0,5*I],[I,0]]",
            "golden_relation": "J^2=5*I",
            "intertwining": "J_target*Delta_hat=Delta_hat*J_source",
            "trace_pairing": "Fischer tensor diag(1,5)",
            "weighted_adjoint": (
                "Delta_hat^dagger="
                "[[Delta0^dagger,5*Delta1^dagger],"
                "[Delta1^dagger,Delta0^dagger]]"
            ),
            "return_commutator": "[J,Delta_hat^dagger*Delta_hat]=0",
            "proof_scope": (
                "all degrees, by coefficientwise 2x2 block multiplication; "
                "finite rebuilds are implementation checks, not extrapolation"
            ),
            "implementation_check_degrees": checked_degrees,
            "implementation_check_shapes": checked_shapes,
        },
        "degree_ten_integral_comparison": {
            "conference_matrix": conference,
            "companion_matrix": companion,
            "comparison_matrix_columns": (
                "e0,e1,e2,C*e0,C*e1,C*e2"
            ),
            "comparison_matrix": comparison,
            "identity": "C*P=P*J",
            "determinant_P": comparison_determinant,
            "sublattice_index": abs(comparison_determinant),
            "rank_mod_2_P": comparison_mod_two_rank,
            "smith_invariants_P": smith_invariants,
            "lattice_quotient": "(Z/2)^2",
            "cokernel_coordinates_mod_2": quotient_coordinates,
            "induced_C_on_cokernel": "I_2",
            "cokernel_interpretation": (
                "two independent parity directions; golden multiplication "
                "collapses to the scalar sqrt(5)=1 mod 2"
            ),
            "over_Z_invertible_conjugacy": False,
            "over_Z_one_half_conjugacy": True,
            "rank_mod_2_C_minus_I": conference_mod_two_rank,
            "rank_mod_2_J_minus_I": companion_mod_two_rank,
            "integral_obstruction": (
                "different mod-2 Jordan ranks forbid GL(6,Z) conjugacy"
            ),
            "rank_mod_5_C": conference_mod_five_rank,
            "rank_mod_5_J": companion_mod_five_rank,
            "rank_mod_5_P": comparison_mod_five_rank,
            "prime_five_boundary": (
                "C and J both have rank 3 and square zero mod 5, while P "
                "remains invertible; prime 5 is ramification of the golden "
                "algebra, not a comparison-lattice defect"
            ),
            "all_twenty_triples": {
                "identity": (
                    "det(e_i,e_j,e_k,C*e_i,C*e_j,C*e_k)="
                    "-4*C_ij*C_jk*C_ki"
                ),
                "absolute_determinant": 4,
                "positive_determinants": sum(
                    row["determinant"] == 4 for row in triple_determinants
                ),
                "negative_determinants": sum(
                    row["determinant"] == -4 for row in triple_determinants
                ),
                "rows": triple_determinants,
                "cubic_recovery": (
                    "C_Clebsch(x)=-(1/4)*sum_S det(P_S)*prod_{i in S}x_i"
                ),
            },
        },
        "conclusion": {
            "all_degree_upgrade": (
                "The paired natural-2/natural-2p E8 towers have an explicit "
                "rational all-degree third-transvectant Weyl presentation "
                "commuting with multiplication by sqrt(5)."
            ),
            "degree_ten_specialization": (
                "On the first balanced 3+3p slice, the universal companion "
                "operator becomes the Clebsch conference matrix."
            ),
            "prime_two_meaning": (
                "The comparison has index 4 and becomes invertible after "
                "inverting 2; its mod-2 rank mismatch is the integral "
                "conductor obstruction."
            ),
            "comparison_quotient": "(Z/2)^2",
            "orientation_upgrade": (
                "The Clebsch cubic is the normalized determinant tensor of "
                "the three-seed Krylov lattices for the descended golden "
                "E8 operator."
            ),
        },
    }


def canonical_bytes(data: object) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    arguments = parser.parse_args()
    rendered = canonical_bytes(build_certificate())
    if arguments.write:
        CERTIFICATE.write_bytes(rendered)
        print(f"WROTE: {CERTIFICATE}")
    elif CERTIFICATE.exists():
        if CERTIFICATE.read_bytes() != rendered:
            raise AssertionError("stored certificate differs from exact rebuild")
        print("PASS: stored all-degree golden Weyl descent reproduced exactly")
    else:
        print(rendered.decode(), end="")


if __name__ == "__main__":
    main()
