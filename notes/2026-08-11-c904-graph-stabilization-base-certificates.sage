#!/usr/bin/env sage
"""Exact base certificates for the C904 graph-stabilization towers.

For each displayed graph Lagrangian this reconstructs the complete integral
Néron--Severi lattice, the ordinary divisor-product lattices in curve and top
degree, and the exact order of the relevant divided polarization powers.
This is a finite certificate for the bases of the uniform theorem, not a
census of graph slopes.
"""

from itertools import combinations, combinations_with_replacement


def alternating_matrix(rank):
    identity = identity_matrix(ZZ, rank)
    zero = zero_matrix(ZZ, rank)
    return block_matrix(ZZ, [[zero, identity], [-identity, zero]])


def graph_lattice(prime, slope):
    rank = slope.nrows()
    slope_q = slope.change_ring(ZZ).change_ring(QQ)
    basis = block_matrix(QQ, [
        [identity_matrix(QQ, rank) / prime, slope_q / prime],
        [zero_matrix(QQ, rank), identity_matrix(QQ, rank)],
    ])
    principal = basis * (prime * alternating_matrix(rank)) * basis.transpose()
    assert principal.denominator() == 1
    principal = principal.change_ring(ZZ)
    assert abs(principal.det()) == 1
    return basis, principal


def ns_lattice(basis):
    """Complete coefficient lattice of integral rational Hodge two-forms."""
    rank = basis.nrows() // 2
    positions = [(i, j) for i in range(rank) for j in range(i, rank)]
    columns = []
    zero = zero_matrix(QQ, rank)
    for i, j in positions:
        coefficient = zero_matrix(QQ, rank)
        coefficient[i, j] = coefficient[j, i] = 1
        form = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        columns.append(vector(QQ, (basis * form * basis.transpose()).list()))
    linear = matrix(QQ, columns).transpose()
    denominator = lcm(value.denominator() for value in linear.list())
    integral = (denominator * linear).change_ring(ZZ)
    augmented = integral.augment(-denominator * identity_matrix(ZZ,
                                                                 linear.nrows()))
    kernel = augmented.right_kernel().basis_matrix()
    projected = [vector(ZZ, row[:linear.ncols()]) for row in kernel.rows()]
    lattice = span(ZZ, projected)
    assert lattice.rank() == len(positions)
    return positions, lattice


def coefficient_matrix(coordinates, positions, rank):
    answer = zero_matrix(ZZ, rank)
    for value, (i, j) in zip(coordinates, positions):
        answer[i, j] = answer[j, i] = value
    return answer


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
            answer[indices] = answer.get(indices, 0) + (
                (-1) ** inversions * left_value * right_value)
    return {indices: value for indices, value in answer.items() if value}


def divided_power(form, degree, targets):
    value = {tuple(): ZZ.one()}
    for _ in range(degree):
        value = wedge(value, form)
    divisor = factorial(degree)
    assert all(coefficient % divisor == 0 for coefficient in value.values())
    return vector(ZZ, [value.get(target, 0) // divisor for target in targets])


def product_data(divisors, rank, degree, target_class):
    targets = list(combinations(range(2 * rank), 2 * degree))
    rows = []
    for indices in combinations_with_replacement(range(len(divisors)), degree):
        value = {tuple(): ZZ.one()}
        for index in indices:
            value = wedge(value, divisors[index])
        rows.append(vector(ZZ, [value.get(target, 0) for target in targets]))
    product_lattice = span(ZZ, rows)
    saturation = product_lattice.saturation()
    inclusion = matrix(ZZ, [saturation.coordinate_vector(value)
                            for value in product_lattice.basis()])
    elementary = [int(value) for value in inclusion.elementary_divisors()
                  if value != 1]
    coordinates = product_lattice.coordinate_vector(target_class)
    order = lcm(value.denominator() for value in coordinates)
    return product_lattice.rank(), product_lattice.index_in(saturation), elementary, int(order)


def certify(label, prime, entries, scalar):
    rank = Integer(len(entries)).sqrt()
    assert rank in ZZ
    rank = int(rank)
    field = GF(prime)
    slope = matrix(field, rank, rank, entries)
    assert slope.is_symmetric()
    basis, principal = graph_lattice(prime, slope)
    positions, coefficient_lattice = ns_lattice(basis)
    zero = zero_matrix(QQ, rank)
    divisors = []
    for coordinates in coefficient_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions, rank)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        form = basis * source * basis.transpose()
        assert form.denominator() == 1
        divisors.append(two_form(form.change_ring(ZZ)))

    theta = two_form(principal)
    curve_targets = list(combinations(range(2 * rank), 2 * rank - 2))
    top_targets = [tuple(range(2 * rank))]
    curve = divided_power(theta, rank - 1, curve_targets)
    top = divided_power(theta, rank, top_targets)
    curve_data = product_data(divisors, rank, rank - 1, curve)
    top_data = product_data(divisors, rank, rank, top)
    sylvester = scalar * identity_matrix(field, rank) - slope

    print(label)
    print(f"  p={prime} g={rank} slope_charpoly={slope.charpoly()} "
          f"scalar={scalar} sylvester_det={sylvester.det()}")
    if slope.charpoly() == polygen(field) ** rank:
        nilpotence_index = min(k for k in range(1, rank + 1) if slope ** k == 0)
        print(f"  nilpotence_index={nilpotence_index}")
    print(f"  ns_rank={coefficient_lattice.rank()} "
          f"ns_coefficient_index={abs(coefficient_lattice.basis_matrix().det())}")
    print(f"  curve_product_rank={curve_data[0]} saturation_index={curve_data[1]} "
          f"elementary={curve_data[2]} divided_power_order={curve_data[3]}")
    print(f"  top_product_rank={top_data[0]} saturation_index={top_data[1]} "
          f"elementary={top_data[2]} divided_power_order={top_data[3]}")


certify(
    "dyadic-order-two-base",
    2,
    [0, 0, 1,
     0, 0, 1,
     1, 1, 0],
    GF(2)(1),
)

certify(
    "triadic-order-three-base",
    3,
    [1, 1, 0, 0,
     1, 1, 2, 2,
     0, 2, 1, 0,
     0, 2, 0, 1],
    GF(3)(0),
)

certify(
    "dyadic-order-four-base",
    2,
    [0, 1, 0, 1, 1,
     1, 0, 1, 0, 0,
     0, 1, 0, 0, 0,
     1, 0, 0, 0, 0,
     1, 0, 0, 0, 0],
    GF(2)(1),
)
