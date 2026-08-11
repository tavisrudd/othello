#!/usr/bin/env sage
"""Independent exact replay for two non-scalar Lefschetz defects.

Unlike the exhaustive census, this checker works in a graph chart and builds
the Neron--Severi congruence lattice directly from the centralizer condition

    C = p D,  D A = A D (mod p).

It then computes divisor products in the principal graph basis.  The two
examples certify genuine defects of orders 2 and 3.
"""

from itertools import combinations, combinations_with_replacement


def symmetric_positions(rank):
    return [(i, j) for i in range(rank) for j in range(i, rank)]


def symmetric_matrix(coordinates, rank):
    answer = zero_matrix(coordinates.base_ring(), rank)
    for value, (i, j) in zip(coordinates, symmetric_positions(rank)):
        answer[i, j] = answer[j, i] = value
    return answer


def graph_ns_basis(prime, slope):
    field = GF(prime)
    rank = slope.nrows()
    positions = symmetric_positions(rank)
    columns = []
    for index in range(len(positions)):
        coordinates = vector(field, [field(i == index) for i in range(len(positions))])
        coefficient = symmetric_matrix(coordinates, rank)
        columns.append(vector(field, (coefficient * slope - slope * coefficient).list()))
    commutator = matrix(field, columns).transpose()
    centralizer = commutator.right_kernel().basis_matrix()

    generators = []
    for row in centralizer.rows():
        generators.append(prime * vector(ZZ, [ZZ(value) for value in row]))
    for index in range(len(positions)):
        generators.append(prime ** 2 * vector(ZZ,
            [ZZ(i == index) for i in range(len(positions))]))
    lattice = span(ZZ, generators)
    assert lattice.rank() == len(positions)
    return lattice.basis_matrix().LLL()


def graph_principal_basis(prime, slope):
    rank = slope.nrows()
    identity = identity_matrix(QQ, rank)
    zero = zero_matrix(QQ, rank)
    return block_matrix(QQ, [[identity / prime, slope.change_ring(QQ) / prime],
                              [zero, identity]])


def two_form(value):
    return {(i, j): ZZ(value[i, j])
            for i in range(value.nrows()) for j in range(i + 1, value.ncols())
            if value[i, j]}


def wedge(left, right):
    answer = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for right_indices, right_value in right.items():
            if left_set.intersection(right_indices):
                continue
            inversions = sum(i > j for i in left_indices for j in right_indices)
            indices = tuple(sorted(left_indices + right_indices))
            answer[indices] = answer.get(indices, 0) + ((-1) ** inversions
                                                         * left_value
                                                         * right_value)
    return {indices: value for indices, value in answer.items() if value}


def graph_divisor_forms(prime, slope):
    rank = slope.nrows()
    basis = graph_principal_basis(prime, slope)
    ns_basis = graph_ns_basis(prime, slope)
    zero = zero_matrix(QQ, rank)
    forms = []
    for coordinates in ns_basis.rows():
        coefficient = symmetric_matrix(coordinates, rank)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        pulled = basis * source * basis.transpose()
        assert pulled.denominator() == 1
        forms.append(two_form(pulled.change_ring(ZZ)))
    return forms


def minimal_order(prime, slope):
    rank = slope.nrows()
    forms = graph_divisor_forms(prime, slope)
    target_indices = list(combinations(range(2 * rank), 2 * rank - 2))
    principal = block_matrix(ZZ, [
        [zero_matrix(ZZ, rank), identity_matrix(ZZ, rank)],
        [-identity_matrix(ZZ, rank), zero_matrix(ZZ, rank)],
    ])
    theta = two_form(principal)
    target_form = {tuple(): ZZ.one()}
    for _ in range(rank - 1):
        target_form = wedge(target_form, theta)
    target_factorial = factorial(rank - 1)
    assert all(value % target_factorial == 0 for value in target_form.values())
    target = vector(ZZ, [target_form.get(indices, 0) // target_factorial
                         for indices in target_indices])

    products = []
    for monomial in combinations_with_replacement(range(len(forms)), rank - 1):
        value = {tuple(): ZZ.one()}
        for index in monomial:
            value = wedge(value, forms[index])
        products.append(vector(ZZ, [value.get(indices, 0)
                                    for indices in target_indices]))
    product_lattice = span(ZZ, products)
    assert target in span(QQ, products)
    coordinates = product_lattice.coordinate_vector(target)
    order = lcm(value.denominator() for value in coordinates)
    return int(order), len(forms), product_lattice.rank(), len(products)


def main():
    examples = [
        (2, matrix(GF(2), [
            [0, 0, 1],
            [0, 0, 1],
            [1, 1, 0],
        ]), 2),
        (3, matrix(GF(3), [
            [1, 1, 0, 0],
            [1, 1, 2, 2],
            [0, 2, 1, 0],
            [0, 2, 0, 1],
        ]), 3),
    ]
    print("C904 graph-gluing minimal-class defect replay")
    for prime, slope, expected_order in examples:
        assert slope == slope.transpose()
        order, ns_rank, product_rank, monomials = minimal_order(prime, slope)
        assert order == expected_order
        print(f"p={prime} g={slope.nrows()} ns_rank={ns_rank} "
              f"product_rank={product_rank} monomials={monomials} "
              f"minimal_order={order}")
    print("PASS")


if __name__ == "__main__":
    main()
