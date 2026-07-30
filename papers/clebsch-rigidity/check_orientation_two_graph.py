#!/usr/bin/env python3
"""Exact Paper I replay for the support-cubic/continuation two-graph."""

from __future__ import annotations

import itertools


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
    print("mod2_rank_one_square_zero=ok")


if __name__ == "__main__":
    main()
