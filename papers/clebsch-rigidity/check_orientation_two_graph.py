#!/usr/bin/env python3
"""Exact Paper I replay for the support-cubic/continuation two-graph."""

from __future__ import annotations

import itertools
from fractions import Fraction


Permutation = tuple[int, ...]


def compose(left: Permutation, right: Permutation) -> Permutation:
    return tuple(left[right[i]] for i in range(len(left)))


def parity(permutation: Permutation) -> int:
    return sum(
        permutation[i] > permutation[j]
        for i in range(len(permutation))
        for j in range(i + 1, len(permutation))
    ) % 2


def generated(*generators: Permutation) -> frozenset[Permutation]:
    identity = tuple(range(len(generators[0])))
    group = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            product = compose(element, generator)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return frozenset(group)


def powers(generator: Permutation) -> frozenset[Permutation]:
    return generated(generator)


def left_cosets(
    group: tuple[Permutation, ...], subgroup: frozenset[Permutation]
) -> tuple[frozenset[Permutation], ...]:
    unseen = set(group)
    cosets = []
    while unseen:
        representative = min(unseen)
        coset = frozenset(compose(representative, h) for h in subgroup)
        cosets.append(coset)
        unseen -= coset
    return tuple(sorted(cosets, key=min))


def coset_action(
    group: tuple[Permutation, ...],
    cosets: tuple[frozenset[Permutation], ...],
) -> dict[Permutation, Permutation]:
    lookup = {element: i for i, coset in enumerate(cosets) for element in coset}
    representatives = [min(coset) for coset in cosets]
    return {
        g: tuple(lookup[compose(g, representative)] for representative in representatives)
        for g in group
    }


def stabilizer_orbits(
    action: dict[Permutation, Permutation], point: int
) -> list[list[int]]:
    stabilizer = [image for image in action.values() if image[point] == point]
    unseen = set(range(len(next(iter(action.values())))))
    orbits = []
    while unseen:
        start = min(unseen)
        orbit = {image[start] for image in stabilizer}
        orbits.append(sorted(orbit))
        unseen -= orbit
    return sorted(orbits, key=lambda orbit: (len(orbit), orbit))


def orbital_matrix(
    action: dict[Permutation, Permutation], point: int, neighbor: int
) -> list[list[int]]:
    degree = len(next(iter(action.values())))
    matrix = [[0] * degree for _ in range(degree)]
    for image in action.values():
        i, j = image[point], image[neighbor]
        matrix[i][j] = matrix[j][i] = 1
    return matrix


def matrix_product(
    left: list[list[int]], right: list[list[int]]
) -> list[list[int]]:
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def determinant(matrix: list[list[int]]) -> int:
    if not matrix:
        return 1
    return sum(
        (-1) ** column
        * matrix[0][column]
        * determinant(
            [
                row[:column] + row[column + 1 :]
                for row in matrix[1:]
            ]
        )
        for column in range(len(matrix))
    )


Polynomial = dict[tuple[int, ...], Fraction]

Quadratic = tuple[Fraction, Fraction]


def q(value: int | Fraction) -> Quadratic:
    return (Fraction(value), Fraction(0))


def q_add(left: Quadratic, right: Quadratic) -> Quadratic:
    return (left[0] + right[0], left[1] + right[1])


def q_neg(value: Quadratic) -> Quadratic:
    return (-value[0], -value[1])


def q_mul(left: Quadratic, right: Quadratic) -> Quadratic:
    return (
        left[0] * right[0] + 5 * left[1] * right[1],
        left[0] * right[1] + left[1] * right[0],
    )


def q_sum(values: list[Quadratic]) -> Quadratic:
    result = q(0)
    for value in values:
        result = q_add(result, value)
    return result


def determinant_of_linear_matrix(
    matrix: list[list[list[Quadratic]]], variables: int
) -> dict[tuple[int, ...], Quadratic]:
    result: dict[tuple[int, ...], Quadratic] = {}
    for permutation in itertools.permutations(range(3)):
        permutation_sign = -1 if parity(permutation) else 1
        for indices in itertools.product(range(variables), repeat=3):
            coefficient = q(permutation_sign)
            for row, variable in enumerate(indices):
                coefficient = q_mul(
                    coefficient, matrix[row][permutation[row]][variable]
                )
            exponent = tuple(indices.count(i) for i in range(variables))
            result[exponent] = q_add(result.get(exponent, q(0)), coefficient)
    return {exponent: coefficient for exponent, coefficient in result.items() if coefficient != q(0)}


def polynomial_add(left: Polynomial, right: Polynomial) -> Polynomial:
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, Fraction(0)) + coefficient
        if result[monomial] == 0:
            del result[monomial]
    return result


def polynomial_scale(polynomial: Polynomial, scalar: Fraction) -> Polynomial:
    return {
        monomial: scalar * coefficient
        for monomial, coefficient in polynomial.items()
        if scalar * coefficient
    }


def polynomial_monomial_multiply(
    polynomial: Polynomial, exponent: tuple[int, ...], scalar: Fraction
) -> Polynomial:
    return {
        tuple(a + b for a, b in zip(monomial, exponent)): scalar * coefficient
        for monomial, coefficient in polynomial.items()
        if scalar * coefficient
    }


def polynomial_reduce(polynomial: Polynomial, basis: list[Polynomial]) -> Polynomial:
    remainder: Polynomial = {}
    work = dict(polynomial)
    while work:
        leading = max(work)
        coefficient = work[leading]
        divisor = next(
            (
                candidate
                for candidate in basis
                if all(a <= b for a, b in zip(max(candidate), leading))
            ),
            None,
        )
        if divisor is None:
            remainder[leading] = coefficient
            del work[leading]
            continue
        divisor_leading = max(divisor)
        exponent = tuple(a - b for a, b in zip(leading, divisor_leading))
        scalar = coefficient / divisor[divisor_leading]
        work = polynomial_add(
            work, polynomial_scale(polynomial_monomial_multiply(divisor, exponent, 1), -scalar)
        )
    return remainder


def reduced_groebner_basis(generators: list[Polynomial]) -> list[Polynomial]:
    basis = [polynomial_scale(g, 1 / g[max(g)]) for g in generators if g]
    basis = list({tuple(sorted(polynomial.items())): polynomial for polynomial in basis}.values())
    pairs = list(itertools.combinations(range(len(basis)), 2))
    while pairs:
        i, j = pairs.pop(0)
        left_leading = max(basis[i])
        right_leading = max(basis[j])
        lcm = tuple(max(a, b) for a, b in zip(left_leading, right_leading))
        left_multiplier = tuple(a - b for a, b in zip(lcm, left_leading))
        right_multiplier = tuple(a - b for a, b in zip(lcm, right_leading))
        s_polynomial = polynomial_add(
            polynomial_monomial_multiply(basis[i], left_multiplier, 1),
            polynomial_monomial_multiply(basis[j], right_multiplier, -1),
        )
        remainder = polynomial_reduce(s_polynomial, basis)
        if remainder:
            remainder = polynomial_scale(remainder, 1 / remainder[max(remainder)])
            if tuple(sorted(remainder.items())) in {
                tuple(sorted(polynomial.items())) for polynomial in basis
            }:
                continue
            new_index = len(basis)
            pairs.extend((old_index, new_index) for old_index in range(new_index))
            basis.append(remainder)
    reduced = []
    for i, polynomial in enumerate(basis):
        remainder = polynomial_reduce(
            polynomial, [candidate for j, candidate in enumerate(basis) if i != j]
        )
        if remainder:
            reduced.append(polynomial_scale(remainder, 1 / remainder[max(remainder)]))
    unique = {tuple(sorted(polynomial.items())): polynomial for polynomial in reduced}
    return sorted(unique.values(), key=lambda polynomial: max(polynomial), reverse=True)


def chart_gradient_polynomials(
    signs: dict[tuple[int, int, int], int], chart: int
) -> list[Polynomial]:
    """Gradient after x_0=0, later y's=0, and y_chart=1."""
    variables = chart
    result = []
    for derivative in range(1, 6):
        polynomial: Polynomial = {}
        for triple, sign in signs.items():
            if derivative not in triple or 0 in triple:
                continue
            factors = [vertex - 1 for vertex in triple if vertex != derivative]
            if any(factor > chart for factor in factors):
                continue
            exponent = [0] * variables
            for factor in factors:
                if factor < chart:
                    exponent[factor] += 1
            monomial = tuple(exponent)
            polynomial[monomial] = polynomial.get(monomial, Fraction(0)) + sign
        result.append({monomial: value for monomial, value in polynomial.items() if value})
    return result


def rational_rank(matrix: list[list[int]]) -> int:
    rows = [[Fraction(value) for value in row] for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(rank, len(rows)) if rows[row][column]), None
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        scale = rows[rank][column]
        rows[rank] = [value / scale for value in rows[rank]]
        for row in range(len(rows)):
            if row != rank and rows[row][column]:
                scale = rows[row][column]
                rows[row] = [
                    value - scale * pivot_value
                    for value, pivot_value in zip(rows[row], rows[rank])
                ]
        rank += 1
    return rank



def main() -> None:
    group = tuple(
        permutation
        for permutation in itertools.permutations(range(5))
        if parity(permutation) == 0
    )
    five_cycle = (1, 2, 3, 4, 0)
    reflection = (0, 4, 3, 2, 1)
    c5 = powers(five_cycle)
    d5 = generated(five_cycle, reflection)
    assert (len(group), len(c5), len(d5)) == (60, 5, 10)

    c5_cosets = left_cosets(group, c5)
    d5_cosets = left_cosets(group, d5)
    continuation_action = coset_action(group, c5_cosets)
    axis_action = coset_action(group, d5_cosets)

    suborbits = stabilizer_orbits(continuation_action, 0)
    antipode = next(orbit[0] for orbit in suborbits if len(orbit) == 1 and orbit != [0])
    five_orbits = [orbit for orbit in suborbits if len(orbit) == 5]
    assert len(five_orbits) == 2
    adjacency = orbital_matrix(continuation_action, 0, five_orbits[0][0])
    antipodal = orbital_matrix(continuation_action, 0, antipode)

    c5_to_axis = {
        i: next(j for j, axis in enumerate(d5_cosets) if coset <= axis)
        for i, coset in enumerate(c5_cosets)
    }
    fibres = [
        tuple(i for i in range(12) if c5_to_axis[i] == axis)
        for axis in range(6)
    ]
    assert all(len(fibre) == 2 for fibre in fibres)
    assert all(antipodal[fibre[0]][fibre[1]] for fibre in fibres)

    operator = [[0] * 6 for _ in range(6)]
    for j, (positive, negative) in enumerate(fibres):
        vector = [0] * 12
        vector[positive], vector[negative] = 1, -1
        image = [
            sum(adjacency[i][k] * vector[k] for k in range(12))
            for i in range(12)
        ]
        for i, (positive_i, negative_i) in enumerate(fibres):
            assert image[negative_i] == -image[positive_i]
            operator[i][j] = image[positive_i]

    assert all(operator[i][i] == 0 for i in range(6))
    assert all(
        operator[i][j] == operator[j][i]
        and (i == j or operator[i][j] in (-1, 1))
        for i in range(6)
        for j in range(6)
    )
    square = matrix_product(operator, operator)
    assert square == [[5 * int(i == j) for j in range(6)] for i in range(6)]

    triples = tuple(itertools.combinations(range(6), 3))
    signs = {
        triple: operator[triple[0]][triple[1]]
        * operator[triple[1]][triple[2]]
        * operator[triple[2]][triple[0]]
        for triple in triples
    }
    assert sorted(signs.values()) == [-1] * 10 + [1] * 10
    assert all(
        signs[triple] == -signs[tuple(i for i in range(6) if i not in triple)]
        for triple in triples
    )
    assert all(
        signs[tuple(sorted(image[i] for i in triple))] == sign
        for image in axis_action.values()
        for triple, sign in signs.items()
    )
    assert all(
        (
            signs[i, j, k]
            * signs[i, j, ell]
            * signs[i, k, ell]
            * signs[j, k, ell]
        )
        == 1
        for i, j, k, ell in itertools.combinations(range(6), 4)
    )

    gauge = [[0] * 6 for _ in range(6)]
    for i in range(1, 6):
        gauge[0][i] = gauge[i][0] = 1
    for i, j in itertools.combinations(range(1, 6), 2):
        gauge[i][j] = gauge[j][i] = signs[0, i, j]
    gauge_signs = {
        triple: gauge[triple[0]][triple[1]]
        * gauge[triple[1]][triple[2]]
        * gauge[triple[2]][triple[0]]
        for triple in triples
    }
    assert gauge_signs == signs
    assert all(
        sum(signs[tuple(sorted((i, j, k)))] for k in range(6) if k not in (i, j))
        == 0
        for i, j in itertools.combinations(range(6), 2)
    )
    assert all(
        sum(sign for triple, sign in signs.items() if i in triple) == 0
        for i in range(6)
    )
    assert sum(signs.values()) == 0

    balanced_gauges = 0
    for positive_edges in itertools.product((-1, 1), repeat=10):
        candidate = [[0] * 6 for _ in range(6)]
        for i in range(1, 6):
            candidate[0][i] = candidate[i][0] = 1
        for sign, (i, j) in zip(
            positive_edges, itertools.combinations(range(1, 6), 2)
        ):
            candidate[i][j] = candidate[j][i] = sign
        if matrix_product(candidate, candidate) == [
            [5 * int(i == j) for j in range(6)] for i in range(6)
        ]:
            balanced_gauges += 1
            assert all(
                sum(candidate[i][j] == 1 for j in range(1, 6) if j != i) == 2
                for i in range(1, 6)
            )
    assert balanced_gauges == 12

    expected_bases: dict[int, list[Polynomial]] = {
        0: [],
        1: [{(1,): Fraction(1)}],
        2: [
            {(1, 0): Fraction(1)},
            {(0, 1): Fraction(1)},
        ],
        3: [
            {(1, 0, 0): Fraction(1)},
            {(0, 1, 0): Fraction(1)},
            {(0, 0, 1): Fraction(1)},
        ],
        4: [
            {
                (1, 0, 0, 0): Fraction(1),
                (0, 0, 0, 1): Fraction(-1),
            },
            {
                (0, 1, 0, 0): Fraction(1),
                (0, 0, 0, 1): Fraction(-1),
            },
            {
                (0, 0, 1, 0): Fraction(1),
                (0, 0, 0, 1): Fraction(-1),
            },
            {
                (0, 0, 0, 2): Fraction(1),
                (0, 0, 0, 1): Fraction(-1),
            },
        ],
    }
    polynomial_key = lambda polynomial: tuple(sorted(polynomial.items()))
    for chart in range(5):
        basis = reduced_groebner_basis(chart_gradient_polynomials(signs, chart))
        actual = {polynomial_key(p) for p in basis}
        expected = {polynomial_key(p) for p in expected_bases[chart]}
        assert actual == expected, (chart, actual, expected)

    def cubic_gradient(point: list[int]) -> list[int]:
        gradient = [0] * 6
        for (i, j, k), sign in signs.items():
            gradient[i] += sign * point[j] * point[k]
            gradient[j] += sign * point[i] * point[k]
            gradient[k] += sign * point[i] * point[j]
        return gradient

    def cubic_hessian(point: list[int]) -> list[list[int]]:
        hessian = [[0] * 6 for _ in range(6)]
        for (i, j, k), sign in signs.items():
            hessian[i][j] += sign * point[k]
            hessian[j][i] += sign * point[k]
            hessian[i][k] += sign * point[j]
            hessian[k][i] += sign * point[j]
            hessian[j][k] += sign * point[i]
            hessian[k][j] += sign * point[i]
        return hessian

    nodes = [
        [1 - 6 * int(i == axis) for i in range(6)]
        for axis in range(6)
    ]
    assert all(cubic_gradient(point) == [0] * 6 for point in nodes)
    assert [rational_rank(cubic_hessian(point)) for point in nodes] == [4] * 6
    quotient_nodes = [
        [point[i] - point[0] for i in range(1, 6)]
        for point in nodes
    ]
    assert all(
        rational_rank([quotient_nodes[i] for i in subset]) == 5
        for subset in itertools.combinations(range(6), 5)
    )

    oriented_automorphisms = 0
    line_automorphisms = 0
    for permutation in itertools.permutations(range(6)):
        transported = {
            tuple(sorted(permutation[i] for i in triple)): sign
            for triple, sign in signs.items()
        }
        if transported == signs:
            oriented_automorphisms += 1
            line_automorphisms += 1
        elif transported == {triple: -sign for triple, sign in signs.items()}:
            line_automorphisms += 1
    assert (oriented_automorphisms, line_automorphisms) == (60, 120)

    principal_minors = {}
    for size in range(7):
        principal_minors[size] = {
            subset: determinant(
                [[operator[i][j] for j in subset] for i in subset]
            )
            for subset in itertools.combinations(range(6), size)
        }
    assert {
        size: sorted(set(values.values()))
        for size, values in principal_minors.items()
    } == {
        0: [1],
        1: [0],
        2: [-1],
        3: [-2, 2],
        4: [5],
        5: [0],
        6: [-125],
    }
    assert all(
        principal_minors[3][triple] == 2 * signs[triple]
        for triple in triples
    )
    assert all(
        principal_minors[3][tuple(i for i in range(6) if i not in triple)]
        == -2 * signs[triple]
        for triple in triples
    )

    root_five: Quadratic = (Fraction(0), Fraction(1))
    t_plus: Quadratic = (Fraction(1, 2), Fraction(1, 2))
    t_minus: Quadratic = (Fraction(1, 2), Fraction(-1, 2))

    def golden_basis(t: Quadratic) -> list[list[Quadratic]]:
        return [
            [t, t, q(-1)],
            [t, q(1), q_neg(t)],
            [q(1), t, q_neg(t)],
            [q(1), q(0), q(0)],
            [q(0), q(1), q(0)],
            [q(0), q(0), q(1)],
        ]

    basis_plus = golden_basis(t_plus)
    basis_minus = golden_basis(t_minus)
    for eigenvalue, basis in ((root_five, basis_plus), (q_neg(root_five), basis_minus)):
        assert all(
            q_sum([q_mul(q(gauge[i][k]), basis[k][j]) for k in range(6)])
            == q_mul(eigenvalue, basis[i][j])
            for i in range(6)
            for j in range(3)
        )
    assert all(
        q_sum([q_mul(basis_minus[i][a], basis_plus[i][b]) for i in range(6)])
        == q(0)
        for a in range(3)
        for b in range(3)
    )

    cross_matrix = [
        [
            [q_mul(basis_minus[i][row], basis_plus[i][column]) for i in range(6)]
            for column in range(3)
        ]
        for row in range(3)
    ]
    cross_determinant = determinant_of_linear_matrix(cross_matrix, 6)
    expected_cross = {}
    for triple in triples:
        exponent = tuple(int(i in triple) for i in range(6))
        expected_cross[exponent] = q(-signs[triple])
    assert cross_determinant == expected_cross

    a_coefficients: list[Quadratic] = [
        (Fraction(-1), Fraction(1)),
        (Fraction(3, 2), Fraction(-1, 2)),
        (Fraction(-5, 2), Fraction(1, 2)),
        (Fraction(-1), Fraction(1)),
    ]
    b_coefficients: list[Quadratic] = [
        (Fraction(-5, 2), Fraction(1, 2)),
        (Fraction(1), Fraction(-1)),
        (Fraction(-1), Fraction(1)),
        (Fraction(-3, 2), Fraction(1, 2)),
    ]
    dual_basis = []
    for index in range(4):
        matrix = [[q(0) for _ in range(3)] for _ in range(3)]
        matrix[0][1] = a_coefficients[index]
        matrix[0][2] = b_coefficients[index]
        if index == 0:
            matrix[1][0] = q(1)
        elif index == 1:
            matrix[1][2] = q(1)
        elif index == 2:
            matrix[2][0] = q(1)
        else:
            matrix[2][1] = q(1)
        dual_basis.append(matrix)
    assert all(
        q_sum(
            [
                q_mul(cross_matrix[row][column][variable], dual[column][row])
                for row in range(3)
                for column in range(3)
            ]
        )
        == q(0)
        for variable in range(6)
        for dual in dual_basis
    )
    dual_matrix = [
        [[dual_basis[i][row][column] for i in range(4)] for column in range(3)]
        for row in range(3)
    ]
    dual_determinant = determinant_of_linear_matrix(dual_matrix, 4)
    assert dual_determinant
    assert any(coefficient != q(0) for coefficient in dual_determinant.values())

    mod_two = [[entry % 2 for entry in row] for row in operator]
    nilpotent = [
        [mod_two[i][j] ^ int(i == j) for j in range(6)]
        for i in range(6)
    ]
    assert all(
        entry % 2 == 0
        for row in matrix_product(nilpotent, nilpotent)
        for entry in row
    )
    assert len({tuple(row) for row in nilpotent}) == 1

    print("group_order=60 continuation_degree=12 axis_degree=6")
    print("support_orbits=10+10 triangle_products=20 four_point_identities=15")
    print("operator_square=5I inverse_switching_gauge=ok balanced_gauges=12")
    print("pair_moments=0 augmentation_descent=ok diagonal_pencil=ok")
    print("cross_determinant=-support_cubic trace_dual=V4 dual_cubic=nonzero")
    print("projective_nodes=6 ordinary_nodes=6 frame=ok aut_projective=120")
    print("mod2_rank_one_square_zero=ok")


if __name__ == "__main__":
    main()
