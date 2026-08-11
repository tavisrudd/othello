#!/usr/bin/env sage
"""Independent Sage replay of the marked charge-two Brauer dimensions."""

import importlib.util
from itertools import combinations
from pathlib import Path


SOURCE = Path.cwd() / "notes/2026-08-10-c904-minimal-class-divisor-replay.py"
SPEC = importlib.util.spec_from_file_location("c904_minimal_replay", SOURCE)
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)

F = GF(2)
PAIRS = list(combinations(range(10), 2))


def axis_action(permutation):
    result = matrix(ZZ, 5, 5)
    for source in range(5):
        target = permutation[source]
        column = vector(ZZ, [-1] * 5) if target == 5 else vector(
            ZZ, [ZZ(i == target) for i in range(5)]
        )
        result.set_column(source, column)
    return result


def block_diagonal(a, b):
    return block_matrix(ZZ, [[a, 0], [0, b]])


def induced_principal(ambient):
    basis = matrix(QQ, BASE.PRINCIPAL_BASIS)
    induced = basis * ambient.transpose() * basis.inverse()
    assert induced.base_ring() is QQ and all(value.denominator() == 1
                                               for value in induced.list())
    return induced.change_ring(F)


def wedge_action(linear):
    columns = []
    for source_i, source_j in PAIRS:
        form = matrix(F, 10, 10)
        form[source_i, source_j] = 1
        form[source_j, source_i] = 1
        image = linear * form * linear.transpose()
        columns.append(vector(F, [image[i, j] for i, j in PAIRS]))
    return matrix(F, columns).transpose()


def ns_basis():
    rows = []
    for sparse in BASE.divisor_forms():
        rows.append(vector(F, [sparse.get(pair, 0) for pair in PAIRS]))
    space = span(rows, F)
    assert space.dimension() == 15
    return list(space.basis())


def quotient_actions(actions, subspace):
    basis_vectors = list(subspace)
    running = span(basis_vectors, F)
    for standard in VectorSpace(F, 45).basis():
        if standard not in running:
            basis_vectors.append(standard)
            running = span(basis_vectors, F)
    assert len(basis_vectors) == 45
    change = matrix(F, basis_vectors).transpose()
    transported = [change.inverse() * action * change for action in actions]
    for action in transported:
        assert action[15:45, 0:15].is_zero()
    return [action[15:45, 15:45] for action in transported]


def fixed_dimension(actions):
    equations = block_matrix(F, len(actions), 1,
                             [action + identity_matrix(F, action.nrows())
                              for action in actions])
    return equations.right_kernel().dimension()


def matrix_order_bounded(value):
    product_value = identity_matrix(F, value.nrows())
    for order_value in range(1, 121):
        product_value *= value
        if product_value.is_one():
            return order_value
    raise AssertionError("order exceeds audit bound")


def generated_group(generators):
    one = identity_matrix(F, generators[0].nrows())
    elements = {tuple(one.list()): one}
    frontier = [one]
    while frontier:
        value = frontier.pop()
        for generator in generators:
            product_value = value * generator
            key = tuple(product_value.list())
            if key not in elements:
                elements[key] = product_value
                frontier.append(product_value)
    return list(elements.values())


def hilbert_degree(m):
    chi_e = (m - 1) * m * (m + 1)
    k = m - 2
    twice_chi_o = k^3 + 3 * k^2 + 4 * k + 2
    return chi_e - twice_chi_o


translation = [1, 2, 3, 4, 0, 5]
inversion = [5, 4, 2, 3, 1, 0]
a5_h1 = [induced_principal(block_diagonal(axis_action(p), axis_action(p)))
         for p in [translation, inversion]]
assert len(generated_group(a5_h1)) == 60

i5 = identity_matrix(ZZ, 5)
z5 = zero_matrix(ZZ, 5)
c3_h1 = induced_principal(block_matrix(ZZ, [[-i5, -i5], [i5, z5]]))
assert matrix_order_bounded(c3_h1) == 3
assert all(c3_h1 * generator == generator * c3_h1 for generator in a5_h1)

quotient = quotient_actions([wedge_action(g) for g in a5_h1] +
                            [wedge_action(c3_h1)], ns_basis())
a5_br = quotient[:2]
c3_br = quotient[2]
group = generated_group(a5_br)
orders = {}
for element in group:
    order_value = matrix_order_bounded(element)
    orders[order_value] = orders.get(order_value, 0) + 1

degrees = [hilbert_degree(m) for m in range(-4, 7)]
assert all(degree == (m - 1) * (3 * m - 2)
           for m, degree in zip(range(-4, 7), degrees))

print("independent Sage marked charge-two Brauer replay")
print("  dimensions H2, NS/2, Br[2]=45,15,30")
print(f"  fixed dimensions A5,C3,joint={fixed_dimension(a5_br)},"
      f"{fixed_dimension([c3_br])},{fixed_dimension(a5_br + [c3_br])}")
print(f"  quotient A5 image order={len(group)} classes={sorted(orders.items())}")
print(f"  Hilbert determinant sampled gcd={gcd(degrees)} all_even="
      f"{all(degree % 2 == 0 for degree in degrees)}")
assert fixed_dimension(a5_br + [c3_br]) == 2
assert len(group) == 60 and sorted(orders.items()) == [(1, 1), (2, 15), (3, 20), (5, 24)]
assert gcd(degrees) == 2
print("PASS")
