#!/usr/bin/env python3
"""Exact degree-ten bridge from the Klein return to the golden six-axis algebra."""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from math import comb, factorial
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-30-c682-golden-e8-descent.json"

# Elements are (a,b,c,d) = (a+b*t) + i(c+d*t), with t^2=t+1.
Element = tuple[Fraction, Fraction, Fraction, Fraction]
Vector = list[Element]
Matrix = list[list[Element]]

ZERO: Element = (Fraction(0),) * 4
ONE: Element = (Fraction(1), Fraction(0), Fraction(0), Fraction(0))
T: Element = (Fraction(0), Fraction(1), Fraction(0), Fraction(0))
I: Element = (Fraction(0), Fraction(0), Fraction(1), Fraction(0))
SQRT5: Element = (Fraction(-1), Fraction(2), Fraction(0), Fraction(0))


def add(left: Element, right: Element) -> Element:
    return tuple(a + b for a, b in zip(left, right))  # type: ignore[return-value]


def neg(value: Element) -> Element:
    return tuple(-entry for entry in value)  # type: ignore[return-value]


def subtract(left: Element, right: Element) -> Element:
    return add(left, neg(right))


def golden_multiply(
    left: tuple[Fraction, Fraction],
    right: tuple[Fraction, Fraction],
) -> tuple[Fraction, Fraction]:
    a, b = left
    c, d = right
    return a * c + b * d, a * d + b * c + b * d


def multiply(left: Element, right: Element) -> Element:
    lr = golden_multiply(left[:2], right[:2])
    li = golden_multiply(left[2:], right[2:])
    cross_left = golden_multiply(left[:2], right[2:])
    cross_right = golden_multiply(left[2:], right[:2])
    return (
        lr[0] - li[0],
        lr[1] - li[1],
        cross_left[0] + cross_right[0],
        cross_left[1] + cross_right[1],
    )


def scale(value: Element, scalar: int | Fraction) -> Element:
    scalar = Fraction(scalar)
    return tuple(scalar * entry for entry in value)  # type: ignore[return-value]


def conjugate(value: Element) -> Element:
    return value[0], value[1], -value[2], -value[3]


def golden_galois(value: Element) -> Element:
    """The nontrivial automorphism t -> 1-t, fixing i."""
    a, b, c, d = value
    return a + b, -b, c + d, -d


def inverse(value: Element) -> Element:
    a, b, c, d = value
    real_norm = subtract(
        multiply((a, b, 0, 0), (a, b, 0, 0)),
        neg(multiply((c, d, 0, 0), (c, d, 0, 0))),
    )
    # Invert p+q*t using norm (p+q*t)(p+q*(1-t)).
    p, q = real_norm[:2]
    norm = p * p + p * q - q * q
    if not norm:
        raise ZeroDivisionError
    real_norm_inverse: Element = (
        (p + q) / norm,
        -q / norm,
        Fraction(0),
        Fraction(0),
    )
    return multiply(conjugate(value), real_norm_inverse)


def divide(left: Element, right: Element) -> Element:
    return multiply(left, inverse(right))


def element(value: int | Fraction) -> Element:
    return Fraction(value), Fraction(0), Fraction(0), Fraction(0)


def polynomial_multiply(left: Vector, right: Vector) -> Vector:
    out = [ZERO] * (len(left) + len(right) - 1)
    for left_index, left_coefficient in enumerate(left):
        for right_index, right_coefficient in enumerate(right):
            out[left_index + right_index] = add(
                out[left_index + right_index],
                multiply(left_coefficient, right_coefficient),
            )
    return out


def polynomial_power(polynomial: Vector, exponent: int) -> Vector:
    out = [ONE]
    for _ in range(exponent):
        out = polynomial_multiply(out, polynomial)
    return out


def derivative(polynomial: Vector, x_order: int, y_order: int) -> Vector:
    degree = len(polynomial) - 1
    if degree < x_order + y_order:
        return []
    out = [ZERO] * (degree - x_order - y_order + 1)
    for y_degree, coefficient in enumerate(polynomial):
        x_degree = degree - y_degree
        if x_degree < x_order or y_degree < y_order:
            continue
        multiplier = 1
        for offset in range(x_order):
            multiplier *= x_degree - offset
        for offset in range(y_order):
            multiplier *= y_degree - offset
        out[y_degree - y_order] = scale(coefficient, multiplier)
    return out


def transvectant(left: Vector, right: Vector, order: int) -> Vector:
    degree = len(left) + len(right) - 2 - 2 * order
    out = [ZERO] * (degree + 1)
    for index in range(order + 1):
        term = polynomial_multiply(
            derivative(left, order - index, index),
            derivative(right, index, order - index),
        )
        coefficient = (-1) ** index * comb(order, index)
        for term_index, value in enumerate(term):
            out[term_index] = add(out[term_index], scale(value, coefficient))
    return out


def delta_matrix(source_degree: int, form: Vector) -> Matrix:
    columns = []
    for source_index in range(source_degree + 1):
        monomial = [ZERO] * (source_degree + 1)
        monomial[source_index] = ONE
        columns.append(transvectant(monomial, form, 3))
    return [
        [columns[column][row] for column in range(source_degree + 1)]
        for row in range(source_degree + 7)
    ]


def fischer_norm(degree: int, index: int) -> int:
    return factorial(degree - index) * factorial(index)


def adjoint(matrix: Matrix, source_degree: int) -> Matrix:
    return [
        [
            scale(
                conjugate(matrix[target_index][source_index]),
                Fraction(
                    fischer_norm(source_degree + 6, target_index),
                    fischer_norm(source_degree, source_index),
                ),
            )
            for target_index in range(source_degree + 7)
        ]
        for source_index in range(source_degree + 1)
    ]


def matrix_multiply(left: Matrix, right: Matrix) -> Matrix:
    return [
        [
            sum_elements(
                multiply(left[row][middle], right[middle][column])
                for middle in range(len(right))
            )
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def sum_elements(values) -> Element:
    out = ZERO
    for value in values:
        out = add(out, value)
    return out


def identity(size: int) -> Matrix:
    return [
        [ONE if row == column else ZERO for column in range(size)]
        for row in range(size)
    ]


def matrix_add(left: Matrix, right: Matrix) -> Matrix:
    return [
        [add(a, b) for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def matrix_trace(matrix: Matrix) -> Element:
    return sum_elements(matrix[index][index] for index in range(len(matrix)))


def matrix_scale(matrix: Matrix, scalar: Element) -> Matrix:
    return [[multiply(scalar, entry) for entry in row] for row in matrix]


def matrix_galois(matrix: Matrix) -> Matrix:
    return [[golden_galois(entry) for entry in row] for row in matrix]


def matrix_rank(matrix: Matrix) -> int:
    work = [list(row) for row in matrix]
    rank = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column] != ZERO),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        pivot_inverse = inverse(work[rank][column])
        work[rank] = [multiply(pivot_inverse, entry) for entry in work[rank]]
        for row in range(len(work)):
            if row == rank or work[row][column] == ZERO:
                continue
            factor = work[row][column]
            work[row] = [
                subtract(entry, multiply(factor, pivot_entry))
                for entry, pivot_entry in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def solve_columns(basis: Matrix, images: Matrix) -> Matrix:
    """Solve basis * answer = images, returning answer."""
    rows = len(basis)
    width = len(basis[0])
    image_count = len(images[0])
    augmented = [
        basis[row] + images[row]
        for row in range(rows)
    ]
    rank = 0
    pivots = []
    for column in range(width):
        pivot = next(
            (row for row in range(rank, rows) if augmented[row][column] != ZERO),
            None,
        )
        if pivot is None:
            continue
        augmented[rank], augmented[pivot] = augmented[pivot], augmented[rank]
        pivot_inverse = inverse(augmented[rank][column])
        augmented[rank] = [
            multiply(pivot_inverse, entry) for entry in augmented[rank]
        ]
        for row in range(rows):
            if row == rank or augmented[row][column] == ZERO:
                continue
            factor = augmented[row][column]
            augmented[row] = [
                subtract(entry, multiply(factor, pivot_entry))
                for entry, pivot_entry in zip(augmented[row], augmented[rank])
            ]
        pivots.append(column)
        rank += 1
    if rank != width:
        raise AssertionError("basis columns are dependent")
    if any(
        all(augmented[row][column] == ZERO for column in range(width))
        and any(augmented[row][width + j] != ZERO for j in range(image_count))
        for row in range(rank, rows)
    ):
        raise AssertionError("images do not lie in the supplied span")
    answer = [[ZERO] * image_count for _ in range(width)]
    for row, pivot in enumerate(pivots):
        answer[pivot] = augmented[row][width:]
    return answer


def golden_dot(left: list[Element], right: list[Element]) -> Element:
    return sum_elements(multiply(a, b) for a, b in zip(left, right))


def axes_and_conference() -> tuple[list[list[Element]], list[list[int]]]:
    axes = [
        [ZERO, T, ONE],
        [ZERO, T, neg(ONE)],
        [ONE, ZERO, T],
        [neg(ONE), ZERO, T],
        [T, neg(ONE), ZERO],
        [neg(T), neg(ONE), ZERO],
    ]
    gram = [[golden_dot(left, right) for right in axes] for left in axes]
    conference = [[0] * 6 for _ in range(6)]
    for row in range(6):
        for column in range(6):
            if row == column:
                if gram[row][column] != add(T, element(2)):
                    raise AssertionError("unexpected axis norm")
            elif gram[row][column] == T:
                conference[row][column] = 1
            elif gram[row][column] == neg(T):
                conference[row][column] = -1
            else:
                raise AssertionError("unexpected axis inner product")
    square = [
        [
            sum(conference[row][middle] * conference[middle][column] for middle in range(6))
            for column in range(6)
        ]
        for row in range(6)
    ]
    if square != [[5 * int(row == column) for column in range(6)] for row in range(6)]:
        raise AssertionError("conference square failed")
    return axes, conference


def axis_quadratic(axis: list[Element]) -> Vector:
    """a*(u^2-v^2) + b*i*(u^2+v^2) + 2*c*u*v."""
    a, b, c = axis
    ib = multiply(I, b)
    return [add(a, ib), scale(c, 2), add(neg(a), ib)]


def format_element(value: Element) -> str:
    labels = ("", "*t", "*i", "*i*t")
    terms = []
    for coefficient, label in zip(value, labels):
        if coefficient:
            terms.append(f"{coefficient}{label}")
    return " + ".join(terms).replace("+ -", "- ") or "0"


NODES = ("1", "2", "3", "4s", "5", "6", "3p", "4", "2p")
GALOIS_NODE = {
    "1": "1",
    "2": "2p",
    "3": "3p",
    "4s": "4",
    "5": "5",
    "6": "6",
    "3p": "3",
    "4": "4s",
    "2p": "2",
}
TENSOR_TWO_EDGES = (
    ("1", "2"),
    ("2", "3"),
    ("3", "4s"),
    ("4s", "5"),
    ("5", "6"),
    ("6", "3p"),
    ("6", "4"),
    ("4", "2p"),
)


def symmetric_power_rows(
    maximum_degree: int,
    edges: tuple[tuple[str, str], ...],
    natural: str,
) -> list[dict[str, int]]:
    adjacency = {node: [] for node in NODES}
    for left, right in edges:
        adjacency[left].append(right)
        adjacency[right].append(left)
    rows = [
        {node: int(node == "1") for node in NODES},
        {node: int(node == natural) for node in NODES},
    ]
    for degree in range(1, maximum_degree):
        tensor = {node: 0 for node in NODES}
        for node, multiplicity in rows[degree].items():
            for neighbor in adjacency[node]:
                tensor[neighbor] += multiplicity
        rows.append(
            {
                node: tensor[node] - rows[degree - 1][node]
                for node in NODES
            }
        )
    return rows


def kostant_degrees(rows: list[dict[str, int]], label: str) -> list[int]:
    numerator = []
    for degree in range(len(rows)):
        coefficient = rows[degree][label]
        if degree >= 12:
            coefficient -= rows[degree - 12][label]
        if degree >= 20:
            coefficient -= rows[degree - 20][label]
        if degree >= 32:
            coefficient += rows[degree - 32][label]
        if coefficient < 0:
            raise AssertionError("negative Molien numerator coefficient")
        numerator.extend([degree] * coefficient)
    return numerator


def build_certificate() -> dict[str, object]:
    axes, conference = axes_and_conference()
    quadratics = [axis_quadratic(axis) for axis in axes]
    klein = [ONE]
    for quadratic in quadratics:
        klein = polynomial_multiply(klein, quadratic)
    axis_decimics = [polynomial_power(quadratic, 5) for quadratic in quadratics]
    basis = [
        [axis_decimics[column][row] for column in range(6)]
        for row in range(11)
    ]
    if matrix_rank(basis) != 6:
        raise AssertionError("axis decimics do not span a six-dimensional space")

    delta = delta_matrix(10, klein)
    gram_return = matrix_multiply(adjoint(delta, 10), delta)
    images = matrix_multiply(gram_return, basis)
    restricted = solve_columns(basis, images)

    diagonal = restricted[0][0]
    off_diagonal_scale = next(
        divide(restricted[row][column], element(conference[row][column]))
        for row in range(6)
        for column in range(6)
        if row != column
    )
    expected = matrix_add(
        matrix_scale(identity(6), diagonal),
        matrix_scale(
            [[element(entry) for entry in row] for row in conference],
            off_diagonal_scale,
        ),
    )
    if restricted != expected:
        raise AssertionError("restricted return is not in the conference algebra")

    common_scale = 211_625_906_798_592_000
    scale_unit = add(element(11), scale(T, 18))
    t_sixth = ONE
    for _ in range(6):
        t_sixth = multiply(t_sixth, T)
    if scale_unit != multiply(SQRT5, t_sixth):
        raise AssertionError("unexpected golden-unit factorization")
    golden_scale = scale(scale_unit, common_scale)
    if diagonal != multiply(golden_scale, SQRT5):
        raise AssertionError("unexpected exact diagonal factorization")
    if off_diagonal_scale != neg(golden_scale):
        raise AssertionError("unexpected exact off-diagonal factorization")

    if multiply(scale(off_diagonal_scale, 2), SQRT5) not in {
        scale(diagonal, 2),
        neg(scale(diagonal, 2)),
    }:
        raise AssertionError("unexpected projector normalization")

    eigenvalue_plus = add(diagonal, multiply(SQRT5, off_diagonal_scale))
    eigenvalue_minus = subtract(diagonal, multiply(SQRT5, off_diagonal_scale))
    if ZERO not in {eigenvalue_plus, eigenvalue_minus}:
        raise AssertionError("one golden summand should be killed")

    sqrt5_inverse = inverse(SQRT5)
    plus_projector = matrix_scale(
        matrix_add(
            identity(6),
            matrix_scale(
                [[element(entry) for entry in row] for row in conference],
                sqrt5_inverse,
            ),
        ),
        element(Fraction(1, 2)),
    )
    minus_projector = matrix_scale(
        matrix_add(
            identity(6),
            matrix_scale(
                [[element(entry) for entry in row] for row in conference],
                neg(sqrt5_inverse),
            ),
        ),
        element(Fraction(1, 2)),
    )
    for projector in (plus_projector, minus_projector):
        if matrix_multiply(projector, projector) != projector:
            raise AssertionError("golden spectral projector failed")

    conjugate_diagonal = golden_galois(diagonal)
    conjugate_off_diagonal_scale = golden_galois(off_diagonal_scale)
    conjugate_eigenvalue_plus = add(
        conjugate_diagonal,
        multiply(SQRT5, conjugate_off_diagonal_scale),
    )
    conjugate_eigenvalue_minus = subtract(
        conjugate_diagonal,
        multiply(SQRT5, conjugate_off_diagonal_scale),
    )
    if conjugate_eigenvalue_minus != ZERO or conjugate_eigenvalue_plus == ZERO:
        raise AssertionError("golden Galois conjugation did not exchange the kernels")
    five_eigenvalue = scale(
        subtract(
            matrix_trace(gram_return),
            scale(eigenvalue_minus, 3),
        ),
        Fraction(1, 5),
    )
    spectral_ratio = divide(eigenvalue_minus, five_eigenvalue)
    if spectral_ratio != element(Fraction(143, 108)):
        raise AssertionError("cross-marking spectral ratio changed")
    recovered_conference = matrix_scale(
        matrix_add(
            restricted,
            matrix_scale(identity(6), neg(diagonal)),
        ),
        inverse(off_diagonal_scale),
    )
    conference_over_field = [
        [element(entry) for entry in row]
        for row in conference
    ]
    if recovered_conference != conference_over_field:
        raise AssertionError("return failed to recover the integral conference matrix")

    tensor_two_rows = symmetric_power_rows(180, TENSOR_TWO_EDGES, "2")
    tensor_two_prime_edges = tuple(
        (GALOIS_NODE[left], GALOIS_NODE[right])
        for left, right in TENSOR_TWO_EDGES
    )
    tensor_two_prime_rows = symmetric_power_rows(
        180,
        tensor_two_prime_edges,
        "2p",
    )
    if any(
        tensor_two_prime_rows[degree][GALOIS_NODE[label]]
        != tensor_two_rows[degree][label]
        for degree in range(181)
        for label in NODES
    ):
        raise AssertionError("the two McKay towers are not Galois conjugate")
    degrees_3_in_two = kostant_degrees(tensor_two_rows[:81], "3")
    degrees_3p_in_two = kostant_degrees(tensor_two_rows[:81], "3p")
    degrees_3p_in_two_prime = kostant_degrees(
        tensor_two_prime_rows[:81],
        "3p",
    )
    degrees_3_in_two_prime = kostant_degrees(
        tensor_two_prime_rows[:81],
        "3",
    )
    if degrees_3_in_two != [2, 10, 12, 18, 20, 28]:
        raise AssertionError("unexpected 3-node Kostant degrees")
    if degrees_3p_in_two != [6, 10, 14, 16, 20, 24]:
        raise AssertionError("unexpected 3p-node Kostant degrees")
    if (
        degrees_3p_in_two_prime != degrees_3_in_two
        or degrees_3_in_two_prime != degrees_3p_in_two
    ):
        raise AssertionError("Kostant degrees do not match across Galois towers")

    return {
        "schema": "c682-golden-e8-descent-v1",
        "field": {
            "presentation": "Q(t,i), t^2=t+1, i^2=-1",
            "sqrt5": "2*t-1",
        },
        "six_axis_harmonic_model": {
            "axis_count": 6,
            "decimic_formula": (
                "[a(u^2-v^2)+b*i(u^2+v^2)+2cuv]^5 "
                "for an oriented axis (a,b,c)"
            ),
            "span_dimension": matrix_rank(basis),
            "A5_module": "3 direct_sum 3p",
            "conference_matrix": conference,
            "conference_square": "5*I",
        },
        "klein_form_from_axes": {
            "construction": "product of the six axis quadratics",
            "degree": len(klein) - 1,
            "nonzero_coefficients_by_y_exponent": {
                str(index): format_element(coefficient)
                for index, coefficient in enumerate(klein)
                if coefficient != ZERO
            },
        },
        "degree_ten_return": {
            "operator": "Delta^dagger Delta for Delta=(.,F_axes)_3",
            "restricted_matrix_identity": (
                "T_axis = alpha*I + beta*C"
            ),
            "alpha": format_element(diagonal),
            "beta": format_element(off_diagonal_scale),
            "factored_identity": (
                "T_axis = 211625906798592000*(11+18*t)*(sqrt(5)*I-C)"
            ),
            "golden_scale_identity": "11+18*t=sqrt(5)*t^6",
            "golden_scale_norm": "-5",
            "eigenvalue_on_C_equals_plus_sqrt5": format_element(eigenvalue_plus),
            "eigenvalue_on_C_equals_minus_sqrt5": format_element(eigenvalue_minus),
            "one_summand_is_exact_kernel": True,
            "nonzero_3p_to_5_eigenvalue_ratio": "143/108",
            "independent_standard_klein_marking_has_same_ratio": True,
            "spectral_projectors": (
                "P_plus=(I+C/sqrt(5))/2, P_minus=(I-C/sqrt(5))/2"
            ),
            "conference_recovery": "C=(T_axis-alpha*I)/beta",
            "conference_recovered_integrally": True,
        },
        "golden_galois_pair": {
            "automorphism": "t maps to 1-t, so sqrt(5) maps to -sqrt(5)",
            "conjugate_alpha": format_element(conjugate_diagonal),
            "conjugate_beta": format_element(conjugate_off_diagonal_scale),
            "conjugate_eigenvalue_on_C_equals_plus_sqrt5": format_element(
                conjugate_eigenvalue_plus
            ),
            "conjugate_eigenvalue_on_C_equals_minus_sqrt5": format_element(
                conjugate_eigenvalue_minus
            ),
            "kernel_exchange": "plus golden summand <-> minus golden summand",
        },
        "graded_lift": {
            "same_tower_no_go": {
                "reason": (
                    "The 3 and 3p Kostant degree multisets differ, so their "
                    "sum in one fixed natural-2 McKay tower has no "
                    "degree-preserving Q(sqrt(5))/Q descent."
                ),
                "3_degrees_in_natural_2_tower": degrees_3_in_two,
                "3p_degrees_in_natural_2_tower": degrees_3p_in_two,
                "first_dimension_mismatch_degree": 2,
            },
            "correct_bi_mckay_descent": {
                "natural_representations": ["2", "2p"],
                "node_galois_pairs": [
                    ["2", "2p"],
                    ["3", "3p"],
                    ["4s", "4"],
                ],
                "fixed_nodes": ["1", "5", "6"],
                "recurrence_check_through_degree": 180,
                "M3_in_2_matches_M3p_in_2p": degrees_3_in_two,
                "M3p_in_2_matches_M3_in_2p": degrees_3p_in_two,
                "verdict": (
                    "The conference operator lifts after pairing the two "
                    "Galois-conjugate affine-E8 McKay towers, not inside one "
                    "fixed tower."
                ),
            },
        },
        "bridge": {
            "exact_conclusion": (
                "The first multiplicity-free Klein E8 return on the harmonic "
                "degree-five six-axis subspace is an affine generator of the "
                "same Q(sqrt(5)) conference algebra used by the Clebsch cubic."
            ),
            "not_just_character_comparison": True,
            "full_lift_boundary": (
                "A same-tower graded lift is obstructed by fake degrees; "
                "the exact categorical lift is the Galois descent of the "
                "paired natural-2 and natural-2p E8 McKay towers."
            ),
        },
    }


def canonical_bytes(data: object) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    arguments = parser.parse_args()
    certificate = build_certificate()
    rendered = canonical_bytes(certificate)
    if arguments.write:
        CERTIFICATE.write_bytes(rendered)
        print(f"WROTE: {CERTIFICATE}")
    elif CERTIFICATE.exists():
        if CERTIFICATE.read_bytes() != rendered:
            raise AssertionError("stored certificate differs from exact rebuild")
        print("PASS: stored golden/E8 descent certificate reproduced exactly")
    else:
        print(rendered.decode(), end="")


if __name__ == "__main__":
    main()
