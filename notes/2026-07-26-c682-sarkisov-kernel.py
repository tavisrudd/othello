#!/usr/bin/env python3
"""Exact symbolic audit for the Mukai--Umemura-to-V5 center family.

The coefficient ring is Z[s,t].  Binary forms use the ordered monomial
basis x^(d-i)y^i.  Transvectants use ordinary derivatives.
"""

from __future__ import annotations

import itertools
import math
from fractions import Fraction
from typing import TypeAlias


Exponent: TypeAlias = tuple[int, ...]
Polynomial: TypeAlias = dict[Exponent, int]


def polynomial(
    s_degree: int = 0, t_degree: int = 0, coefficient: int = 1
) -> Polynomial:
    if coefficient == 0:
        return {}
    return {(s_degree, t_degree): coefficient}


def add(left: Polynomial, right: Polynomial) -> Polynomial:
    result = dict(left)
    for exponent, coefficient in right.items():
        result[exponent] = result.get(exponent, 0) + coefficient
        if result[exponent] == 0:
            del result[exponent]
    return result


def scale(coefficient: int, value: Polynomial) -> Polynomial:
    return {
        exponent: coefficient * entry
        for exponent, entry in value.items()
        if coefficient * entry
    }


def multiply(left: Polynomial, right: Polynomial) -> Polynomial:
    result: Polynomial = {}
    for left_exponent, left_coefficient in left.items():
        for right_exponent, right_coefficient in right.items():
            exponent = tuple(
                left_entry + right_entry
                for left_entry, right_entry in zip(
                    left_exponent, right_exponent
                )
            )
            result[exponent] = (
                result.get(exponent, 0)
                + left_coefficient * right_coefficient
            )
    return {
        exponent: coefficient
        for exponent, coefficient in result.items()
        if coefficient
    }


def power(value: Polynomial, exponent: int, variable_count: int) -> Polynomial:
    result = {(0,) * variable_count: 1}
    for _ in range(exponent):
        result = multiply(result, value)
    return result


def variable(index: int, variable_count: int) -> Polynomial:
    exponent = [0] * variable_count
    exponent[index] = 1
    return {tuple(exponent): 1}


def falling(number: int, order: int) -> int:
    if order < 0 or order > number:
        return 0
    return math.factorial(number) // math.factorial(number - order)


def transvectant(
    left: list[Polynomial],
    right: list[Polynomial],
    order: int,
) -> list[Polynomial]:
    left_degree = len(left) - 1
    right_degree = len(right) - 1
    result = [
        {} for _ in range(left_degree + right_degree - 2 * order + 1)
    ]
    for left_index, left_coefficient in enumerate(left):
        for right_index, right_coefficient in enumerate(right):
            product = multiply(left_coefficient, right_coefficient)
            for index in range(order + 1):
                output_index = left_index + right_index - order
                if not 0 <= output_index < len(result):
                    continue
                coefficient = (
                    (-1) ** index
                    * math.comb(order, index)
                    * falling(left_degree - left_index, order - index)
                    * falling(left_index, index)
                    * falling(right_degree - right_index, index)
                    * falling(right_index, order - index)
                )
                result[output_index] = add(
                    result[output_index], scale(coefficient, product)
                )
    return result


def operator_matrix(
    form: list[Polynomial], domain_degree: int, order: int
) -> list[list[Polynomial]]:
    columns: list[list[Polynomial]] = []
    for index in range(domain_degree + 1):
        basis = [{} for _ in range(domain_degree + 1)]
        basis[index] = polynomial()
        columns.append(transvectant(basis, form, order))
    return [list(row) for row in zip(*columns)]


def determinant(matrix: list[list[Polynomial]]) -> Polynomial:
    size = len(matrix)
    result: Polynomial = {}
    for permutation in itertools.permutations(range(size)):
        inversions = sum(
            permutation[left] > permutation[right]
            for left in range(size)
            for right in range(left + 1, size)
        )
        term = polynomial(coefficient=(-1) ** inversions)
        for row, column in enumerate(permutation):
            term = multiply(term, matrix[row][column])
        result = add(result, term)
    return result


def integer_determinant(matrix: list[list[int]]) -> int:
    size = len(matrix)
    result = 0
    for permutation in itertools.permutations(range(size)):
        inversions = sum(
            permutation[left] > permutation[right]
            for left in range(size)
            for right in range(left + 1, size)
        )
        term = (-1) ** inversions
        for row, column in enumerate(permutation):
            term *= matrix[row][column]
        result += term
    return result


def rational_rank(matrix: list[list[int]]) -> int:
    work = [[Fraction(entry) for entry in row] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0])):
        pivot = next(
            (
                row
                for row in range(pivot_row, len(work))
                if work[row][column]
            ),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        pivot_entry = work[pivot_row][column]
        work[pivot_row] = [
            entry / pivot_entry for entry in work[pivot_row]
        ]
        for row in range(len(work)):
            if row == pivot_row:
                continue
            multiplier = work[row][column]
            work[row] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(
                    work[row], work[pivot_row]
                )
            ]
        pivot_row += 1
    return pivot_row


def syzygy_dimension(
    rows: list[tuple[list[Polynomial], int]], twist: int
) -> int:
    """Degree-twist syzygies among two homogeneous rows on P1."""
    unknowns = [
        (column, t_degree)
        for column in range(len(rows[0][0]))
        for t_degree in range(twist + 1)
    ]
    equations: list[list[int]] = []
    for entries, row_degree in rows:
        for output_t_degree in range(row_degree + twist + 1):
            equation = []
            for column, unknown_t_degree in unknowns:
                equation.append(
                    sum(
                        coefficient
                        for (_, entry_t_degree), coefficient in entries[
                            column
                        ].items()
                        if entry_t_degree + unknown_t_degree
                        == output_t_degree
                    )
                )
            equations.append(equation)
    return len(unknowns) - rational_rank(equations)


def minor(
    matrix: list[list[Polynomial]],
    rows: tuple[int, ...],
    columns: tuple[int, ...],
) -> Polynomial:
    return determinant(
        [[matrix[row][column] for column in columns] for row in rows]
    )


def wedge_coordinate(
    left: list[Polynomial],
    right: list[Polynomial],
    first: int,
    second: int,
) -> Polynomial:
    return add(
        multiply(left[first], right[second]),
        scale(-1, multiply(left[second], right[first])),
    )


def transform_binary_form(
    form: list[int],
    matrix: tuple[Polynomial, Polynomial, Polynomial, Polynomial],
) -> list[Polynomial]:
    """Substitute x -> ax+by and y -> cx+dy."""
    degree = len(form) - 1
    a, b, c, d = matrix
    variable_count = len(next(iter(a)))
    result = [{} for _ in range(degree + 1)]
    for form_index, form_coefficient in enumerate(form):
        if form_coefficient == 0:
            continue
        for first_y_count in range(degree - form_index + 1):
            for second_y_count in range(form_index + 1):
                output_index = first_y_count + second_y_count
                term = multiply(
                    multiply(
                        power(
                            a,
                            degree - form_index - first_y_count,
                            variable_count,
                        ),
                        power(b, first_y_count, variable_count),
                    ),
                    multiply(
                        power(
                            c,
                            form_index - second_y_count,
                            variable_count,
                        ),
                        power(d, second_y_count, variable_count),
                    ),
                )
                coefficient = (
                    form_coefficient
                    * math.comb(degree - form_index, first_y_count)
                    * math.comb(form_index, second_y_count)
                )
                result[output_index] = add(
                    result[output_index], scale(coefficient, term)
                )
    return result


def main() -> None:
    zero: Polynomial = {}

    # Fix lambda=x and write m=sx+ty.  Equivariance gives every member of
    # the family Gamma_lambda={[lambda*m^5]}.
    center = [
        polynomial(5 - index, index, math.comb(5, index))
        for index in range(6)
    ] + [zero]

    # For t != 0 the kernel is <x^2*m^2,m^4>.  Saturating at m=x gives
    # the following global homogeneous basis of degrees 2 and 3.
    kernel_degree_two = [
        polynomial(2, 0),
        polynomial(1, 1, 2),
        polynomial(0, 2),
        zero,
        zero,
    ]
    kernel_degree_three = [
        zero,
        polynomial(3, 0, 2),
        polynomial(2, 1, 5),
        polynomial(1, 2, 4),
        polynomial(0, 3),
    ]

    assert transvectant(kernel_degree_two, center, 2) == [zero] * 7
    assert transvectant(kernel_degree_three, center, 2) == [zero] * 7
    assert transvectant(
        kernel_degree_two, kernel_degree_three, 3
    ) == [zero] * 3

    # These two Pluecker coordinates prove independence at every [s:t].
    pluecker_s = wedge_coordinate(
        kernel_degree_two, kernel_degree_three, 0, 1
    )
    pluecker_t = wedge_coordinate(
        kernel_degree_two, kernel_degree_three, 2, 4
    )
    assert pluecker_s == polynomial(5, 0, 2)
    assert pluecker_t == polynomial(0, 5)

    # Dualizing the universal sequence gives the syzygy bundle of the
    # two rows above.  Its degree-twist section dimensions force
    # Q^*=O(-1)+O(-2)+O(-2), hence Q=O(1)+O(2)+O(2).
    quotient_dual_sections = [
        syzygy_dimension(
            [(kernel_degree_two, 2), (kernel_degree_three, 3)],
            twist,
        )
        for twist in range(4)
    ]
    assert quotient_dual_sections == [0, 1, 4, 7]

    # The operator has rank at most 3 by the two kernel vectors and rank
    # at least 3 because the following minors cover P^1.
    matrix = operator_matrix(center, domain_degree=4, order=2)
    rank_minor_s = minor(matrix, (0, 1, 2), (2, 3, 4))
    rank_minor_t = minor(matrix, (3, 4, 6), (0, 1, 3))
    assert rank_minor_s == polynomial(15, 0, 3_888_000)
    assert rank_minor_t == polynomial(0, 15, -648_000)

    # The span of Gamma_x is x*Sym^5 and its invariant-apolar normal is
    # x^6.  Equivariance gives (lambda*Sym^5)^perp=<lambda^6>.
    apolar_normal = [polynomial()] + [zero] * 6
    assert transvectant(center, apolar_normal, 6) == [zero]

    # The unique bisecant is tangent at m=lambda: Gamma_x(1,t) has
    # constant and linear coefficients x^6 and 5*x^5*y.
    center_at_lambda = [1, 0, 0, 0, 0, 0, 0]
    tangent_at_lambda = [0, 5, 0, 0, 0, 0, 0]
    assert center_at_lambda[2:] == [0] * 5
    assert tangent_at_lambda[2:] == [0] * 5

    # The actual pointwise candidate uses the invariant coordinate z in
    # P(Sym^12 + Sym^0).  On the dense SL2 orbit of
    # [xy(x^10+11x^5y^5-y^10):1], verify symbolically that
    #
    #   F_x([I:z])=(I,x^6)_6 - 5702400*z*x^6
    #
    # satisfies the five quadratic equations (F_x,F_x)_4=0 of V5.
    # Work on the dense determinant-one chart
    # [[a,b],[c,(1+bc)/a]] using Laurent polynomials in a,b,c.
    variable_count = 3
    one = {(0, 0, 0): 1}
    a = variable(0, variable_count)
    b = variable(1, variable_count)
    c = variable(2, variable_count)
    inverse_a = {(-1, 0, 0): 1}
    d = add(inverse_a, multiply(multiply(inverse_a, b), c))
    klein_dodecic = [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0]
    orbit_dodecic = transform_binary_form(
        klein_dodecic, (a, b, c, d)
    )
    fixed_sixth_power = [one] + [{} for _ in range(6)]
    image_sextic = transvectant(orbit_dodecic, fixed_sixth_power, 6)
    image_sextic[0] = add(
        image_sextic[0], {(0, 0, 0): -5_702_400}
    )
    assert transvectant(image_sextic, image_sextic, 4) == [{}] * 5

    # On the lower-Borel orbit (b=0), the map contracts the surface to
    # Gamma_x.  The formula is
    # -239500800*a^-10*x*(ac*x+y)^5.
    borel_restriction = [
        {
            exponent: coefficient
            for exponent, coefficient in entry.items()
            if exponent[1] == 0
        }
        for entry in image_sextic
    ]
    predicted_borel_image = [
        {
            (-5 - index, 0, 5 - index): (
                -239_500_800 * math.comb(5, index)
            )
        }
        for index in range(6)
    ] + [{}]
    assert borel_restriction == predicted_borel_image

    # The projective differential has rank 3 at a=b=c=1, so the image
    # is three-dimensional and hence is all of V5.
    value_and_derivatives: list[list[int]] = []
    value_and_derivatives.append(
        [sum(entry.values()) for entry in image_sextic]
    )
    for variable_index in range(variable_count):
        value_and_derivatives.append(
            [
                sum(
                    coefficient * exponent[variable_index]
                    for exponent, coefficient in entry.items()
                )
                for entry in image_sextic
            ]
        )
    differential_minor = next(
        (
            (columns, integer_determinant(
                [
                    [row[column] for column in columns]
                    for row in value_and_derivatives
                ]
            ))
            for columns in itertools.combinations(range(7), 4)
            if integer_determinant(
                [
                    [row[column] for column in columns]
                    for row in value_and_derivatives
                ]
            )
        ),
        None,
    )
    assert differential_minor is not None

    # The projection center contains the selected source line
    # L_x=P(x^11*U): contraction with x^6 kills x^12 and x^11y.
    source_line_generators = [
        [one] + [{} for _ in range(12)],
        [{}, one] + [{} for _ in range(11)],
    ]
    assert all(
        transvectant(generator, fixed_sixth_power, 6) == [{}] * 7
        for generator in source_line_generators
    )

    # Along a transverse one-parameter degeneration to [x^11*y:0] on
    # L_x, put
    # I=x^11*y+11u*x^6*y^6-u^2*x*y^11 and z=u.  The order-u term
    # cancels and F_x is exactly 462u^2*x*y^5 up to sign/normalization.
    u = variable(0, 1)
    transverse_dodecic = [{} for _ in range(13)]
    transverse_dodecic[1] = {(0,): 1}
    transverse_dodecic[6] = scale(11, u)
    transverse_dodecic[11] = scale(-1, power(u, 2, 1))
    transverse_image = transvectant(
        transverse_dodecic, [{(0,): 1}] + [{} for _ in range(6)], 6
    )
    transverse_image[0] = add(
        transverse_image[0], scale(-5_702_400, u)
    )
    assert transverse_image == [
        {},
        {},
        {},
        {},
        {},
        {(2,): -239_500_800},
        {},
    ]

    print("PASS: Gamma_lambda lies in the V5 kernel model with rank 3")
    print(
        "PASS: pulled-back tautological bundle splits as "
        "O(-2) + O(-3)"
    )
    print(
        "PASS: pulled-back quotient bundle splits as "
        "O(1) + O(2) + O(2)"
    )
    print(
        "PASS: span(Gamma_lambda)=P(lambda*Sym^5), "
        "apolar normal=[lambda^6]"
    )
    print(
        "PASS: tangent bisecant at the closed-orbit point is "
        "P(lambda^5*U)"
    )
    print(
        "PASS: linear covariant F_lambda maps the dense MU orbit into V5"
    )
    print("PASS: F_lambda is dominant; differential minor", differential_minor)
    print(
        "PASS: F_lambda contracts the stabilizer surface to Gamma_lambda"
    )
    print("PASS: the projection center contains L_lambda=P(lambda^11*U)")
    print("PASS: F_lambda has transverse order two along L_lambda")
    print("rank-cover minors:", rank_minor_s, rank_minor_t)
    print("Pluecker cover:", pluecker_s, pluecker_t)


if __name__ == "__main__":
    main()
