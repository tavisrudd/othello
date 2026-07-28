#!/usr/bin/env python3
"""Exact Fischer-adjoint calculations for the Klein E8 operator.

This is the primary generator for the C682 operator-algebra certificate.
It uses only the Python standard library.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from itertools import permutations
from math import comb, factorial, sqrt
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-28-c682-klein-e8-operator-algebra.json"
DELTA_SCALE = 87_278_400

Polynomial = dict[tuple[int, int], int]
Matrix = list[list[Fraction]]


def derivative(polynomial: Polynomial, dx: int, dy: int) -> Polynomial:
    out: Polynomial = {}
    for (x_degree, y_degree), coefficient in polynomial.items():
        if x_degree < dx or y_degree < dy:
            continue
        multiplier = 1
        for offset in range(dx):
            multiplier *= x_degree - offset
        for offset in range(dy):
            multiplier *= y_degree - offset
        out[(x_degree - dx, y_degree - dy)] = coefficient * multiplier
    return out


def multiply(left: Polynomial, right: Polynomial) -> Polynomial:
    out: Polynomial = {}
    for (lx, ly), lc in left.items():
        for (rx, ry), rc in right.items():
            monomial = (lx + rx, ly + ry)
            out[monomial] = out.get(monomial, 0) + lc * rc
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def add_scaled(
    left: Polynomial,
    right: Polynomial,
    scale: int,
) -> Polynomial:
    out = dict(left)
    for monomial, coefficient in right.items():
        out[monomial] = out.get(monomial, 0) + scale * coefficient
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def transvectant(left: Polynomial, right: Polynomial, order: int) -> Polynomial:
    out: Polynomial = {}
    for index in range(order + 1):
        term = multiply(
            derivative(left, order - index, index),
            derivative(right, index, order - index),
        )
        out = add_scaled(out, term, (-1) ** index * comb(order, index))
    return out


KLEIN_F: Polynomial = {
    (11, 1): 1,
    (6, 6): 11,
    (1, 11): -1,
}


def delta_matrix(source_degree: int, form: Polynomial = KLEIN_F) -> Matrix:
    """Matrix of raw delta=(.,f)_3 from Sym^n to Sym^(n+6)."""
    columns = [
        transvectant({(source_degree - index, index): 1}, form, 3)
        for index in range(source_degree + 1)
    ]
    return [
        [
            Fraction(column.get((source_degree + 6 - row, row), 0))
            for column in columns
        ]
        for row in range(source_degree + 7)
    ]


def fischer_norm(degree: int, index: int) -> int:
    """Squared Fischer norm of X^(degree-index)Y^index."""
    return factorial(degree - index) * factorial(index)


def adjoint(matrix: Matrix, source_degree: int) -> Matrix:
    """Fischer adjoint of a matrix Sym^n -> Sym^(n+6)."""
    return [
        [
            matrix[target_index][source_index]
            * Fraction(
                fischer_norm(source_degree + 6, target_index),
                fischer_norm(source_degree, source_index),
            )
            for target_index in range(source_degree + 7)
        ]
        for source_index in range(source_degree + 1)
    ]


def apolar_adjoint(matrix: Matrix, source_degree: int) -> Matrix:
    """Adjoint for <p,q>_n=(p,q)_n/(n!)^2."""
    target_degree = source_degree + 6
    return [
        [
            Fraction(
                (-1 if (source_index - target_index) % 2 else 1)
                * comb(source_degree, source_index),
                comb(target_degree, target_index),
            )
            * matrix[target_degree - target_index][source_degree - source_index]
            for target_index in range(target_degree + 1)
        ]
        for source_index in range(source_degree + 1)
    ]


def fischer_adjoint_direct(source_degree: int) -> Matrix:
    """Direct Weyl-algebra formula for delta^dagger."""
    columns = []
    for target_index in range(source_degree + 7):
        target = {(source_degree + 6 - target_index, target_index): 1}
        out: Polynomial = {}
        for index in range(4):
            coefficient_polynomial = derivative(KLEIN_F, index, 3 - index)
            differentiated: Polynomial = {}
            for (dx, dy), coefficient in coefficient_polynomial.items():
                differentiated = add_scaled(
                    differentiated,
                    derivative(target, dx, dy),
                    coefficient,
                )
            shifted = multiply(
                {(3 - index, index): 1},
                differentiated,
            )
            out = add_scaled(out, shifted, (-1) ** index * comb(3, index))
        columns.append(out)
    return [
        [
            Fraction(column.get((source_degree - row, row), 0))
            for column in columns
        ]
        for row in range(source_degree + 1)
    ]


def identity(size: int) -> Matrix:
    return [
        [Fraction(int(row == column)) for column in range(size)]
        for row in range(size)
    ]


def matrix_add(left: Matrix, right: Matrix) -> Matrix:
    return [
        [a + b for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def matrix_scale(matrix: Matrix, scalar: Fraction) -> Matrix:
    return [[scalar * entry for entry in row] for row in matrix]


def matrix_subtract(left: Matrix, right: Matrix) -> Matrix:
    return [
        [a - b for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def matrix_multiply(left: Matrix, right: Matrix) -> Matrix:
    if not left or not right:
        return []
    return [
        [
            sum(
                (left[row][inner] * right[inner][column] for inner in range(len(right))),
                Fraction(0),
            )
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def matrix_trace(matrix: Matrix) -> Fraction:
    return sum((matrix[index][index] for index in range(len(matrix))), Fraction(0))


def matrix_rank(matrix: Matrix) -> int:
    work = [row[:] for row in matrix]
    rank = 0
    column_count = len(work[0]) if work else 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        pivot_value = work[rank][column]
        work[rank] = [entry / pivot_value for entry in work[rank]]
        for row in range(len(work)):
            if row == rank or not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(work[row], work[rank])
            ]
        rank += 1
    return rank


def generated_algebra_dimension(generators: list[Matrix]) -> int:
    size = len(generators[0])
    basis = [identity(size)]
    frontier = [identity(size)]
    while frontier:
        current = frontier.pop(0)
        for generator in generators:
            for candidate in (
                matrix_multiply(current, generator),
                matrix_multiply(generator, current),
            ):
                vectors = [
                    [entry for row in matrix for entry in row]
                    for matrix in basis + [candidate]
                ]
                if matrix_rank(vectors) == len(basis) + 1:
                    basis.append(candidate)
                    frontier.append(candidate)
    return len(basis)


def kramer_operator(degree: int) -> Matrix:
    """Kramer's symmetrized degree-six icosahedral generalized Casimir."""
    size = degree + 1
    plus = [[Fraction(0) for _ in range(size)] for _ in range(size)]
    minus = [[Fraction(0) for _ in range(size)] for _ in range(size)]
    third = [[Fraction(0) for _ in range(size)] for _ in range(size)]
    for index in range(size):
        third[index][index] = Fraction(degree, 2) - index
        if index:
            plus[index - 1][index] = index
        if index < degree:
            minus[index + 1][index] = degree - index
    generators = {"+": plus, "-": minus, "3": third}

    def symmetrized(word: str) -> Matrix:
        distinct_words = sorted(set(permutations(word)))
        total = [[Fraction(0) for _ in range(size)] for _ in range(size)]
        for ordered_word in distinct_words:
            term = identity(size)
            for letter in ordered_word:
                term = matrix_multiply(term, generators[letter])
            total = matrix_add(total, term)
        return matrix_scale(total, Fraction(1, len(distinct_words)))

    return matrix_add(
        matrix_add(
            matrix_scale(
                matrix_add(symmetrized("+++++3"), symmetrized("3-----")),
                Fraction(-42, 2**5),
            ),
            symmetrized("333333"),
        ),
        matrix_add(
            matrix_scale(symmetrized("+-3333"), Fraction(-30, 2**2)),
            matrix_add(
                matrix_scale(symmetrized("++--33"), Fraction(90, 2**4)),
                matrix_scale(symmetrized("+++---"), Fraction(-20, 2**6)),
            ),
        ),
    )


def mckay_decomposition(degree: int) -> dict[str, int]:
    nodes = ["1", "2", "3", "4s", "5", "6", "3p", "4", "2p"]
    edges = [
        ("1", "2"),
        ("2", "3"),
        ("3", "4s"),
        ("4s", "5"),
        ("5", "6"),
        ("6", "3p"),
        ("6", "4"),
        ("4", "2p"),
    ]
    adjacency = {node: [] for node in nodes}
    for left, right in edges:
        adjacency[left].append(right)
        adjacency[right].append(left)
    rows = [
        {node: int(node == "1") for node in nodes},
        {node: int(node == "2") for node in nodes},
    ]
    for current_degree in range(1, degree):
        tensor = {node: 0 for node in nodes}
        for node, multiplicity in rows[current_degree].items():
            for neighbor in adjacency[node]:
                tensor[neighbor] += multiplicity
        rows.append(
            {
                node: tensor[node] - rows[current_degree - 1][node]
                for node in nodes
            }
        )
    return {
        node: multiplicity
        for node, multiplicity in rows[degree].items()
        if multiplicity
    }


def characteristic_polynomial(matrix: Matrix) -> list[Fraction]:
    """Return descending coefficients via Faddeev--LeVerrier."""
    size = len(matrix)
    coefficients = [Fraction(1)]
    auxiliary = identity(size)
    for index in range(1, size + 1):
        auxiliary = matrix_multiply(matrix, auxiliary)
        coefficient = -matrix_trace(auxiliary) / index
        coefficients.append(coefficient)
        auxiliary = matrix_add(auxiliary, matrix_scale(identity(size), coefficient))
    return coefficients


def polynomial_multiply(
    left: list[Fraction],
    right: list[Fraction],
) -> list[Fraction]:
    out = [Fraction(0)] * (len(left) + len(right) - 1)
    for left_index, left_coefficient in enumerate(left):
        for right_index, right_coefficient in enumerate(right):
            out[left_index + right_index] += left_coefficient * right_coefficient
    return out


def polynomial_power(coefficients: list[Fraction], exponent: int) -> list[Fraction]:
    out = [Fraction(1)]
    for _ in range(exponent):
        out = polynomial_multiply(out, coefficients)
    return out


def polynomial_divide_linear(
    coefficients: list[Fraction],
    root: Fraction,
) -> tuple[list[Fraction], Fraction]:
    quotient = [coefficients[0]]
    for coefficient in coefficients[1:-1]:
        quotient.append(coefficient + root * quotient[-1])
    remainder = coefficients[-1] + root * quotient[-1]
    return quotient, remainder


def format_factorization(
    coefficients: list[Fraction],
    candidate_roots: list[Fraction],
) -> tuple[list[tuple[Fraction, int]], list[Fraction]]:
    factors = []
    remainder = coefficients
    for root in candidate_roots:
        multiplicity = 0
        while len(remainder) > 1:
            quotient, value = polynomial_divide_linear(remainder, root)
            if value:
                break
            remainder = quotient
            multiplicity += 1
        if multiplicity:
            factors.append((root, multiplicity))
    return factors, remainder


def gram_operator(source_degree: int) -> Matrix:
    raising = delta_matrix(source_degree)
    lowering = adjoint(raising, source_degree)
    return matrix_multiply(lowering, raising)


def round_trip_operator(source_degree: int, steps: int) -> Matrix:
    raising = identity(source_degree + 1)
    current_degree = source_degree
    edge_matrices = []
    for _ in range(steps):
        edge = delta_matrix(current_degree)
        edge_matrices.append((current_degree, edge))
        raising = matrix_multiply(edge, raising)
        current_degree += 6
    lowering = identity(current_degree + 1)
    for edge_degree, edge in reversed(edge_matrices):
        lowering = matrix_multiply(adjoint(edge, edge_degree), lowering)
    return matrix_multiply(lowering, raising)


def apolar_gram_operator(source_degree: int, form: Polynomial = KLEIN_F) -> Matrix:
    raising = delta_matrix(source_degree, form)
    return matrix_multiply(apolar_adjoint(raising, source_degree), raising)


def numerical_singular_squares(source_degree: int) -> list[float]:
    raising = delta_matrix(source_degree)
    size = source_degree + 1
    symmetric = [[0.0 for _ in range(size)] for _ in range(size)]
    for left in range(size):
        for right in range(left, size):
            value = 0.0
            for target in range(source_degree + 7):
                value += (
                    float(raising[target][left])
                    * float(raising[target][right])
                    * fischer_norm(source_degree + 6, target)
                    / sqrt(
                        fischer_norm(source_degree, left)
                        * fischer_norm(source_degree, right)
                    )
                    / DELTA_SCALE**2
                )
            symmetric[left][right] = value
            symmetric[right][left] = value
    tolerance = 1e-12
    for _ in range(100 * size * size):
        row, column = max(
            (
                (row, column)
                for row in range(size)
                for column in range(row + 1, size)
            ),
            key=lambda pair: abs(symmetric[pair[0]][pair[1]]),
        )
        if abs(symmetric[row][column]) <= tolerance * max(
            1.0,
            max(abs(symmetric[index][index]) for index in range(size)),
        ):
            break
        difference = symmetric[column][column] - symmetric[row][row]
        theta = difference / (2 * symmetric[row][column])
        tangent = (
            1.0
            if theta == 0
            else (1 if theta > 0 else -1) / (abs(theta) + sqrt(1 + theta * theta))
        )
        cosine = 1 / sqrt(1 + tangent * tangent)
        sine = tangent * cosine
        for index in range(size):
            if index in (row, column):
                continue
            old_row = symmetric[index][row]
            old_column = symmetric[index][column]
            symmetric[index][row] = symmetric[row][index] = (
                cosine * old_row - sine * old_column
            )
            symmetric[index][column] = symmetric[column][index] = (
                sine * old_row + cosine * old_column
            )
        old_row = symmetric[row][row]
        old_column = symmetric[column][column]
        cross = symmetric[row][column]
        symmetric[row][row] = (
            cosine * cosine * old_row
            - 2 * sine * cosine * cross
            + sine * sine * old_column
        )
        symmetric[column][column] = (
            sine * sine * old_row
            + 2 * sine * cosine * cross
            + cosine * cosine * old_column
        )
        symmetric[row][column] = symmetric[column][row] = 0.0
    return sorted(symmetric[index][index] for index in range(size))


def exploratory_spectra() -> None:
    for degree in (6, 12, 18):
        operator = gram_operator(degree)
        print(
            json.dumps(
                {
                    "degree": degree,
                    "dimension": degree + 1,
                    "trace": str(matrix_trace(operator)),
                    "eigenvalues": [
                        f"{value:.17g}"
                        for value in numerical_singular_squares(degree)
                    ],
                },
                sort_keys=True,
            )
        )
    first_return = round_trip_operator(18, 1)
    second_return = round_trip_operator(18, 2)
    return_commutator = matrix_subtract(
        matrix_multiply(first_return, second_return),
        matrix_multiply(second_return, first_return),
    )
    print(
        json.dumps(
            {
                "degree": 18,
                "first_second_return_commutator_rank": matrix_rank(return_commutator),
                "return_algebra_dimension": generated_algebra_dimension(
                    [first_return, second_return]
                ),
            },
            sort_keys=True,
        )
    )
    for degree in (6, 12, 18):
        kramer = kramer_operator(degree)
        gram = gram_operator(degree)
        commutator = matrix_subtract(
            matrix_multiply(kramer, gram),
            matrix_multiply(gram, kramer),
        )
        print(
            json.dumps(
                {
                    "degree": degree,
                    "kramer_commutator_rank": matrix_rank(commutator),
                },
                sort_keys=True,
            )
        )
    for name, form in (
        ("open", KLEIN_F),
        ("boundary_2d", {(11, 1): 1}),
        ("closed_1d", {(12, 0): 1}),
    ):
        coefficients = characteristic_polynomial(apolar_gram_operator(6, form))
        operator = apolar_gram_operator(6, form)
        powers = []
        power = identity(7)
        for _ in range(1, 8):
            power = matrix_multiply(power, operator)
            powers.append(matrix_rank(power))
        print(
            json.dumps(
                {
                    "apolar_orbit": name,
                    "charpoly": [str(coefficient) for coefficient in coefficients],
                    "power_ranks": powers,
                },
                sort_keys=True,
            )
        )


def build_certificate() -> dict[str, object]:
    for degree in (6, 12, 18):
        if adjoint(delta_matrix(degree), degree) != fischer_adjoint_direct(degree):
            raise AssertionError("Fischer transpose and Weyl adjoint disagree")

    degree_six = gram_operator(6)
    eigenvalue = matrix_trace(degree_six) / 4
    factors, remainder = format_factorization(
        characteristic_polynomial(degree_six),
        [Fraction(0), eigenvalue],
    )
    if factors != [(Fraction(0), 3), (eigenvalue, 4)] or remainder != [Fraction(1)]:
        raise AssertionError("unexpected degree-six Fischer spectrum")
    normalized_eigenvalue = eigenvalue / DELTA_SCALE**2
    if normalized_eigenvalue != Fraction(6300, 551**2):
        raise AssertionError("unexpected normalized degree-six eigenvalue")

    degree_twelve_roots = [
        (Fraction(0), 1, "1"),
        (Fraction(1_126_125, 551**2), 3, "3"),
        (Fraction(2_027_025, 551**2), 5, "5"),
        (Fraction(2_217_600, 551**2), 4, "4"),
    ]
    factors, remainder = format_factorization(
        characteristic_polynomial(gram_operator(12)),
        [
            root * DELTA_SCALE**2
            for root, _, _ in degree_twelve_roots
        ],
    )
    if (
        factors
        != [
            (root * DELTA_SCALE**2, multiplicity)
            for root, multiplicity, _ in degree_twelve_roots
        ]
        or remainder != [Fraction(1)]
    ):
        raise AssertionError("unexpected degree-twelve Fischer spectrum")

    degree_eighteen_scalar_roots = [
        (Fraction(37_322_208, 551**2), 3, "3"),
        (Fraction(82_976_544, 551**2), 5, "5"),
        (Fraction(101_582_208, 551**2), 3, "3p"),
    ]
    degree_eighteen_sum = Fraction(213_325_308, 551**2)
    degree_eighteen_product = Fraction(11_035_030_675_818_240, 551**4)
    factors, remainder = format_factorization(
        characteristic_polynomial(gram_operator(18)),
        [
            root * DELTA_SCALE**2
            for root, _, _ in degree_eighteen_scalar_roots
        ],
    )
    expected_quadratic = [
        Fraction(1),
        -degree_eighteen_sum * DELTA_SCALE**2,
        degree_eighteen_product * DELTA_SCALE**4,
    ]
    if (
        factors
        != [
            (root * DELTA_SCALE**2, multiplicity)
            for root, multiplicity, _ in degree_eighteen_scalar_roots
        ]
        or remainder != polynomial_power(expected_quadratic, 4)
    ):
        raise AssertionError("unexpected degree-eighteen Fischer spectrum")

    return_dimensions = {}
    expected_decompositions = {
        6: {"3p": 1, "4": 1},
        12: {"1": 1, "3": 1, "5": 1, "4": 1},
        18: {"3": 1, "5": 1, "3p": 1, "4": 2},
    }
    decompositions = {}
    for degree, expected_decomposition in expected_decompositions.items():
        decomposition = mckay_decomposition(degree)
        if decomposition != expected_decomposition:
            raise AssertionError("unexpected affine-E8 decomposition")
        commutant_dimension = sum(
            multiplicity**2 for multiplicity in decomposition.values()
        )
        first_return = round_trip_operator(degree, 1)
        second_return = round_trip_operator(degree, 2)
        dimension = generated_algebra_dimension([first_return, second_return])
        if dimension != commutant_dimension:
            raise AssertionError("return algebra does not saturate the McKay commutant")
        return_dimensions[str(degree)] = dimension
        decompositions[str(degree)] = decomposition
    first_return = round_trip_operator(18, 1)
    second_return = round_trip_operator(18, 2)
    return_commutator_rank = matrix_rank(
        matrix_subtract(
            matrix_multiply(first_return, second_return),
            matrix_multiply(second_return, first_return),
        )
    )
    if return_commutator_rank != 8:
        raise AssertionError("the first two return operators should resolve the doubled 4")

    kramer_commutator_ranks = {}
    for degree, expected_rank in ((6, 0), (12, 0), (18, 8)):
        kramer = kramer_operator(degree)
        first_return = round_trip_operator(degree, 1)
        commutator_rank = matrix_rank(
            matrix_subtract(
                matrix_multiply(kramer, first_return),
                matrix_multiply(first_return, kramer),
            )
        )
        if commutator_rank != expected_rank:
            raise AssertionError("unexpected Kramer comparison")
        kramer_commutator_ranks[str(degree)] = commutator_rank

    apolar_rows = []
    for name, form, expected_kind in (
        ("open_icosahedral_orbit", KLEIN_F, "projector"),
        ("two_dimensional_boundary_orbit", {(11, 1): 1}, "zero"),
        ("one_dimensional_closed_orbit", {(12, 0): 1}, "zero"),
    ):
        raising = delta_matrix(6, form)
        if matrix_rank(raising) != 4:
            raise AssertionError("orbit representative lost transvectant rank four")
        operator = apolar_gram_operator(6, form)
        if expected_kind == "projector":
            apolar_eigenvalue = Fraction(237_600_000)
            factors, remainder = format_factorization(
                characteristic_polynomial(operator),
                [Fraction(0), apolar_eigenvalue],
            )
            if (
                factors != [(Fraction(0), 3), (apolar_eigenvalue, 4)]
                or remainder != [Fraction(1)]
                or matrix_multiply(operator, operator)
                != matrix_scale(operator, apolar_eigenvalue)
            ):
                raise AssertionError("wrong open-orbit apolar return")
            apolar_rows.append(
                {
                    "name": name,
                    "transvectant_rank": 4,
                    "apolar_return": "P^2=237600000 P",
                    "apolar_return_rank": 4,
                }
            )
        else:
            if any(entry for row in operator for entry in row):
                raise AssertionError("boundary apolar return should vanish")
            apolar_rows.append(
                {
                    "name": name,
                    "transvectant_rank": 4,
                    "apolar_return": "P=0",
                    "apolar_return_rank": 0,
                }
            )

    return {
        "schema": "c682-klein-e8-operator-algebra-v1",
        "field": "Q",
        "fischer_form": "<X^aY^b,X^aY^b>=a!b!",
        "operator": "Delta=(.,Phi_12)_3/87278400",
        "formal_adjoint": {
            "matrix_rule": (
                "(Delta^dagger)_{i,j}=Delta_{j,i}"
                " (n+6-j)!j!/((n-i)!i!)"
            ),
            "weyl_rule": (
                "sum_i (-1)^i binom(3,i) X^(3-i)Y^i "
                "(dX^i dY^(3-i) Phi_12)(dX,dY), divided by 87278400"
            ),
            "exact_basis_comparison_degrees": [6, 12, 18],
        },
        "graded_commutators": {
            "[Euler,Delta]": "6 Delta",
            "[Euler,Delta_dagger]": "-6 Delta_dagger",
        },
        "degree_six": {
            "source": "Sym^6 = 3p direct_sum 4",
            "target": "Sym^12 = 1 direct_sum 3 direct_sum 4 direct_sum 5",
            "spectrum_Delta_dagger_Delta": [
                {"eigenvalue": "0", "multiplicity": 3, "module": "3p"},
                {
                    "eigenvalue": str(normalized_eigenvalue),
                    "multiplicity": 4,
                    "module": "4",
                },
            ],
            "nonzero_singular_value": "30 sqrt(7) / 551",
        },
        "degree_twelve": {
            "source": "Sym^12 = 1 direct_sum 3 direct_sum 4 direct_sum 5",
            "spectrum_Delta_dagger_Delta": [
                {
                    "eigenvalue": str(root),
                    "multiplicity": multiplicity,
                    "module": module,
                }
                for root, multiplicity, module in degree_twelve_roots
            ],
        },
        "degree_eighteen": {
            "source": "Sym^18 = 3 direct_sum 5 direct_sum 3p direct_sum 4^2",
            "rational_spectrum_Delta_dagger_Delta": [
                {
                    "eigenvalue": str(root),
                    "multiplicity": multiplicity,
                    "module": module,
                }
                for root, multiplicity, module in degree_eighteen_scalar_roots
            ],
            "four_multiplicity_space_quadratic": (
                "x^2 - (213325308/303601)x "
                "+ 11035030675818240/92173567201"
            ),
            "each_quadratic_root_multiplicity": 4,
            "first_second_return_commutator_rank": return_commutator_rank,
        },
        "graded_corner_algebra": {
            "definition": (
                "degree-n corner generated by Delta^dagger^k Delta^k; "
                "k=1,2 already suffices in the checked weights"
            ),
            "dimensions": return_dimensions,
            "affine_E8_decompositions": decompositions,
            "abstract_algebras_over_C": {
                "6": "C direct_sum C",
                "12": "C^4",
                "18": "C^3 direct_sum Mat_2(C)",
            },
            "commutant_saturation": (
                "These dimensions equal End_(2.A5)(Sym^n) for n=6,12,18."
            ),
        },
        "kramer_comparison": {
            "operator": "Kramer equation (47), exact symmetrization",
            "commutator_ranks_with_first_return": kramer_commutator_ranks,
            "conclusion": (
                "Agreement is forced in the multiplicity-free weights 6 and 12; "
                "rank 8 at weight 18 proves the return operator is independent "
                "on the doubled four-dimensional McKay vertex."
            ),
        },
        "apolar_orbit_comparison": {
            "pairing": "<p,q>_n=(p,q)_n/(n!)^2",
            "rows": apolar_rows,
            "conclusion": (
                "The transvectant rank remains four on all three U_22 orbit "
                "representatives, while the algebraic return is semisimple on "
                "the open orbit and vanishes on both boundary orbits."
            ),
        },
        "claim_boundary": [
            "The positive spectrum uses the Fischer Hermitian form.",
            "The orbit comparison uses the distinct SL2-invariant apolar bilinear form.",
            "The exact corner-algebra statement is proved only for weights 6, 12, and 18.",
            "No global presentation of the infinite graded operator algebra is claimed.",
            "No novelty claim against all invariant-operator literature is certified.",
        ],
    }


def canonical_json(data: dict[str, object]) -> str:
    return json.dumps(data, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--explore", action="store_true")
    arguments = parser.parse_args()
    if arguments.explore:
        exploratory_spectra()
        return
    rendered = canonical_json(build_certificate())
    if arguments.write:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(CERTIFICATE)
        return
    if not CERTIFICATE.exists():
        raise SystemExit(f"missing certificate: {CERTIFICATE}")
    if CERTIFICATE.read_text(encoding="utf-8") != rendered:
        raise SystemExit("certificate is stale")
    print("certificate ok")


if __name__ == "__main__":
    main()
