#!/usr/bin/env python3
"""Independent dense-list replay of the C682 Klein E8 operator algebra."""

from __future__ import annotations

from fractions import Fraction
from itertools import permutations
from math import comb, factorial


SCALE = 87_278_400


def trim(values: list[int]) -> list[int]:
    while len(values) > 1 and values[-1] == 0:
        values.pop()
    return values


def derivative(values: list[int], x_count: int, y_count: int) -> list[int]:
    degree = len(values) - 1
    if degree < x_count + y_count:
        return [0]
    out = [0] * (degree - x_count - y_count + 1)
    for y_degree, coefficient in enumerate(values):
        x_degree = degree - y_degree
        if x_degree < x_count or y_degree < y_count:
            continue
        multiplier = 1
        for offset in range(x_count):
            multiplier *= x_degree - offset
        for offset in range(y_count):
            multiplier *= y_degree - offset
        out[y_degree - y_count] += coefficient * multiplier
    return trim(out)


def product(left: list[int], right: list[int]) -> list[int]:
    out = [0] * (len(left) + len(right) - 1)
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            out[left_index + right_index] += left_value * right_value
    return trim(out)


def transvectant(left: list[int], right: list[int], order: int) -> list[int]:
    degree = len(left) + len(right) - 2 - 2 * order
    out = [0] * (degree + 1)
    for index in range(order + 1):
        term = product(
            derivative(left, order - index, index),
            derivative(right, index, order - index),
        )
        scalar = (-1) ** index * comb(order, index)
        for term_index, value in enumerate(term):
            out[term_index] += scalar * value
    return trim(out)


F = [0, 1, 0, 0, 0, 0, 11, 0, 0, 0, 0, -1, 0]


def delta(degree: int, form: list[int] = F) -> list[list[Fraction]]:
    columns = []
    for index in range(degree + 1):
        basis = [0] * (degree + 1)
        basis[index] = 1
        column = transvectant(basis, form, 3)
        column += [0] * (degree + 7 - len(column))
        columns.append(column)
    return [
        [Fraction(columns[column][row]) for column in range(degree + 1)]
        for row in range(degree + 7)
    ]


def unit(size: int) -> list[list[Fraction]]:
    return [
        [Fraction(row == column) for column in range(size)]
        for row in range(size)
    ]


def add(
    left: list[list[Fraction]],
    right: list[list[Fraction]],
    right_scale: Fraction = Fraction(1),
) -> list[list[Fraction]]:
    return [
        [
            left[row][column] + right_scale * right[row][column]
            for column in range(len(left[0]))
        ]
        for row in range(len(left))
    ]


def scale(
    matrix: list[list[Fraction]],
    scalar: Fraction,
) -> list[list[Fraction]]:
    return [[scalar * value for value in row] for row in matrix]


def compose(
    left: list[list[Fraction]],
    right: list[list[Fraction]],
) -> list[list[Fraction]]:
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


def rank(matrix: list[list[Fraction]]) -> int:
    work = [row[:] for row in matrix]
    pivot_row = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        pivot_value = work[pivot_row][column]
        work[pivot_row] = [value / pivot_value for value in work[pivot_row]]
        for row in range(len(work)):
            if row == pivot_row or not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                value - multiplier * pivot_value
                for value, pivot_value in zip(work[row], work[pivot_row])
            ]
        pivot_row += 1
    return pivot_row


def fischer_adjoint(
    matrix: list[list[Fraction]],
    degree: int,
) -> list[list[Fraction]]:
    return [
        [
            matrix[target][source]
            * Fraction(
                factorial(degree + 6 - target) * factorial(target),
                factorial(degree - source) * factorial(source),
            )
            for target in range(degree + 7)
        ]
        for source in range(degree + 1)
    ]


def apolar_adjoint(
    matrix: list[list[Fraction]],
    degree: int,
) -> list[list[Fraction]]:
    target_degree = degree + 6
    return [
        [
            Fraction(
                (-1 if (source - target) % 2 else 1) * comb(degree, source),
                comb(target_degree, target),
            )
            * matrix[target_degree - target][degree - source]
            for target in range(target_degree + 1)
        ]
        for source in range(degree + 1)
    ]


def return_word(degree: int, length: int) -> list[list[Fraction]]:
    up = unit(degree + 1)
    edges = []
    current = degree
    for _ in range(length):
        edge = delta(current)
        edges.append((current, edge))
        up = compose(edge, up)
        current += 6
    down = unit(current + 1)
    for edge_degree, edge in reversed(edges):
        down = compose(fischer_adjoint(edge, edge_degree), down)
    return compose(down, up)


def evaluate_polynomial(
    operator: list[list[Fraction]],
    coefficients: list[Fraction],
) -> list[list[Fraction]]:
    size = len(operator)
    out = scale(unit(size), coefficients[0])
    for coefficient in coefficients[1:]:
        out = add(compose(out, operator), scale(unit(size), coefficient))
    return out


def algebra_dimension(generators: list[list[list[Fraction]]]) -> int:
    size = len(generators[0])
    basis = [unit(size)]
    pending = [unit(size)]
    while pending:
        word = pending.pop()
        for generator in generators:
            for candidate in (compose(word, generator), compose(generator, word)):
                flattened = [
                    [value for row in matrix for value in row]
                    for matrix in basis + [candidate]
                ]
                if rank(flattened) > len(basis):
                    basis.append(candidate)
                    pending.append(candidate)
    return len(basis)


def kramer(degree: int) -> list[list[Fraction]]:
    size = degree + 1
    operators = {
        symbol: [[Fraction(0) for _ in range(size)] for _ in range(size)]
        for symbol in "+-3"
    }
    for index in range(size):
        operators["3"][index][index] = Fraction(degree, 2) - index
        if index:
            operators["+"][index - 1][index] = index
        if index < degree:
            operators["-"][index + 1][index] = degree - index

    def sym(word: str) -> list[list[Fraction]]:
        words = set(permutations(word))
        out = [[Fraction(0) for _ in range(size)] for _ in range(size)]
        for ordering in words:
            term = unit(size)
            for symbol in ordering:
                term = compose(term, operators[symbol])
            out = add(out, term)
        return scale(out, Fraction(1, len(words)))

    out = scale(add(sym("+++++3"), sym("3-----")), Fraction(-42, 32))
    out = add(out, sym("333333"))
    out = add(out, scale(sym("+-3333"), Fraction(-30, 4)))
    out = add(out, scale(sym("++--33"), Fraction(90, 16)))
    return add(out, scale(sym("+++---"), Fraction(-20, 64)))


def mckay_commutant_dimension(degree: int) -> int:
    nodes = "1 2 3 4s 5 6 3p 4 2p".split()
    neighbors = {node: [] for node in nodes}
    for left, right in (
        ("1", "2"),
        ("2", "3"),
        ("3", "4s"),
        ("4s", "5"),
        ("5", "6"),
        ("6", "3p"),
        ("6", "4"),
        ("4", "2p"),
    ):
        neighbors[left].append(right)
        neighbors[right].append(left)
    previous = {node: int(node == "1") for node in nodes}
    current = {node: int(node == "2") for node in nodes}
    for _ in range(1, degree):
        following = {
            node: sum(current[neighbor] for neighbor in neighbors[node]) - previous[node]
            for node in nodes
        }
        previous, current = current, following
    return sum(multiplicity * multiplicity for multiplicity in current.values())


def check_spectra() -> None:
    roots = {
        6: [
            (Fraction(0), 3),
            (Fraction(6_300, 551**2), 4),
        ],
        12: [
            (Fraction(0), 1),
            (Fraction(1_126_125, 551**2), 3),
            (Fraction(2_027_025, 551**2), 5),
            (Fraction(2_217_600, 551**2), 4),
        ],
    }
    for degree, spectral_rows in roots.items():
        operator = scale(return_word(degree, 1), Fraction(1, SCALE**2))
        annihilator = [Fraction(1)]
        for root, multiplicity in spectral_rows:
            nullity = degree + 1 - rank(add(operator, unit(degree + 1), -root))
            assert nullity == multiplicity
            next_coefficients = [Fraction(0)] * (len(annihilator) + 1)
            for index, coefficient in enumerate(annihilator):
                next_coefficients[index] += coefficient
                next_coefficients[index + 1] -= root * coefficient
            annihilator = next_coefficients
        assert not any(value for row in evaluate_polynomial(operator, annihilator) for value in row)

    degree = 18
    operator = scale(return_word(degree, 1), Fraction(1, SCALE**2))
    scalar_rows = [
        (Fraction(37_322_208, 551**2), 3),
        (Fraction(82_976_544, 551**2), 5),
        (Fraction(101_582_208, 551**2), 3),
    ]
    annihilator = [Fraction(1)]
    for root, multiplicity in scalar_rows:
        assert degree + 1 - rank(add(operator, unit(degree + 1), -root)) == multiplicity
        annihilator = [
            *annihilator,
            Fraction(0),
        ]
        for index in range(len(annihilator) - 1, 0, -1):
            annihilator[index] -= root * annihilator[index - 1]
    quadratic = [
        Fraction(1),
        Fraction(-213_325_308, 551**2),
        Fraction(11_035_030_675_818_240, 551**4),
    ]
    quadratic_value = evaluate_polynomial(operator, quadratic)
    assert degree + 1 - rank(quadratic_value) == 8
    full_annihilator = annihilator
    for _ in range(2):
        full_annihilator = [
            sum(
                (
                    full_annihilator[left] * quadratic[right]
                    for left in range(len(full_annihilator))
                    for right in range(len(quadratic))
                    if left + right == total
                ),
                Fraction(0),
            )
            for total in range(len(full_annihilator) + len(quadratic) - 1)
        ]
    assert not any(
        value for row in evaluate_polynomial(operator, full_annihilator) for value in row
    )


def main() -> None:
    check_spectra()
    dimensions = {}
    for degree, expected in ((6, 2), (12, 4), (18, 7)):
        assert mckay_commutant_dimension(degree) == expected
        first = return_word(degree, 1)
        second = return_word(degree, 2)
        dimensions[degree] = algebra_dimension([first, second])
        assert dimensions[degree] == expected
        expected_commutator = 8 if degree == 18 else 0
        assert rank(add(compose(first, second), compose(second, first), -1)) == (
            expected_commutator
        )
        assert rank(add(compose(kramer(degree), first), compose(first, kramer(degree)), -1)) == (
            expected_commutator
        )

    apolar = {}
    for name, form in (
        ("open", F),
        ("boundary_2d", [0, 1] + [0] * 11),
        ("closed_1d", [1] + [0] * 12),
    ):
        raising = delta(6, form)
        assert rank(raising) == 4
        returning = compose(apolar_adjoint(raising, 6), raising)
        if name == "open":
            assert rank(returning) == 4
            assert compose(returning, returning) == scale(returning, Fraction(237_600_000))
        else:
            assert not any(value for row in returning for value in row)
        apolar[name] = rank(returning)

    print(
        "independent replay ok: "
        f"corner dimensions {dimensions}; "
        f"apolar return ranks {apolar}"
    )


if __name__ == "__main__":
    main()
