#!/usr/bin/env sage
"""Independent replay of the dyadic g=6 top index.

Unlike the mixed-minor lattice computation, this reconstructs the full
principal graph homology lattice, the complete integral two-form lattice,
and exhausts all 230,230 degree-six divisor-basis monomials by a depth-first
exterior-product recursion.  In particular it retains the commutator carry
block throughout.
"""

from itertools import combinations, combinations_with_replacement
from math import gcd


PRIME = 2
RANK = 6
ENTRIES = [
    0, 1, 0, 1, 0, 0,
    1, 0, 0, 1, 1, 0,
    0, 0, 0, 1, 1, 1,
    1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 1, 1,
    0, 0, 1, 0, 1, 0,
]


def alternating_matrix(rank):
    identity = identity_matrix(ZZ, rank)
    zero = zero_matrix(ZZ, rank)
    return block_matrix(ZZ, [[zero, identity], [-identity, zero]])


def graph_lattice(prime, slope):
    slope_q = slope.change_ring(ZZ).change_ring(QQ)
    rank = slope.nrows()
    basis = block_matrix(QQ, [
        [identity_matrix(QQ, rank) / prime, slope_q / prime],
        [zero_matrix(QQ, rank), identity_matrix(QQ, rank)],
    ])
    principal = basis * (prime * alternating_matrix(rank)) * basis.transpose()
    assert principal.denominator() == 1 and abs(principal.det()) == 1
    return basis, principal.change_ring(ZZ)


def complete_two_form_lattice(basis):
    rank = basis.nrows() // 2
    positions = [(i, j) for i in range(rank) for j in range(i, rank)]
    zero = zero_matrix(QQ, rank)
    columns = []
    for i, j in positions:
        coefficient = zero_matrix(QQ, rank)
        coefficient[i, j] = coefficient[j, i] = 1
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        columns.append(vector(QQ, (basis * source * basis.transpose()).list()))
    linear = matrix(QQ, columns).transpose()
    denominator = lcm(value.denominator() for value in linear.list())
    integral = (denominator * linear).change_ring(ZZ)
    augmented = integral.augment(-denominator * identity_matrix(ZZ,
                                                                 linear.nrows()))
    kernel = augmented.right_kernel().basis_matrix()
    projected = [vector(ZZ, row[:linear.ncols()]) for row in kernel.rows()]
    coefficient_lattice = span(ZZ, projected)
    assert coefficient_lattice.rank() == len(positions)

    divisors = []
    for coordinates in coefficient_lattice.basis_matrix().LLL().rows():
        coefficient = zero_matrix(QQ, rank)
        for value, (i, j) in zip(coordinates, positions):
            coefficient[i, j] = coefficient[j, i] = value
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        form = basis * source * basis.transpose()
        assert form.denominator() == 1
        form = form.change_ring(ZZ)
        divisors.append({(i, j): ZZ(form[i, j])
                         for i in range(2 * rank)
                         for j in range(i + 1, 2 * rank) if form[i, j]})
    return coefficient_lattice, divisors


def wedge(left, right):
    answer = {}
    for left_indices, left_value in left.items():
        left_set = set(left_indices)
        for (i, j), right_value in right.items():
            if i in left_set or j in left_set:
                continue
            inversions = sum(value > i for value in left_indices)
            inversions += sum(value > j for value in left_indices)
            if i > j:
                inversions += 1
            target = tuple(sorted(left_indices + (i, j)))
            answer[target] = answer.get(target, 0) + (
                (-1) ** inversions * left_value * right_value)
    return {target: value for target, value in answer.items() if value}


slope = matrix(GF(PRIME), RANK, RANK, ENTRIES)
assert slope.is_symmetric()
x = polygen(GF(PRIME))
assert slope.charpoly() == x ** RANK and slope ** (RANK - 1) != 0
basis, principal = graph_lattice(PRIME, slope)
coefficient_lattice, divisors = complete_two_form_lattice(basis)
assert len(divisors) == RANK * (RANK + 1) // 2

target = tuple(range(2 * RANK))
curve_targets = list(combinations(range(2 * RANK), 2 * RANK - 2))
curve_rows = []
top_gcd = 0
count = 0
witness = None


def walk(start, depth, form, indices):
    global top_gcd, count, witness
    if depth == RANK - 1:
        curve_rows.append(vector(ZZ, [form.get(target_curve, 0)
                                      for target_curve in curve_targets]))
    if depth == RANK:
        coefficient = form.get(target, 0)
        top_gcd = gcd(top_gcd, abs(int(coefficient)))
        count += 1
        if witness is None and abs(coefficient) == 8:
            witness = indices
        return
    for index in range(start, len(divisors)):
        walk(index, depth + 1, wedge(form, divisors[index]), indices + (index,))


walk(0, 0, {tuple(): ZZ.one()}, tuple())
expected = binomial(len(divisors) + RANK - 1, RANK)
assert count == expected == 230230
assert top_gcd == 8 and witness is not None

theta = {(i, j): ZZ(principal[i, j])
         for i in range(2 * RANK) for j in range(i + 1, 2 * RANK)
         if principal[i, j]}
theta_power = {tuple(): ZZ.one()}
for _ in range(RANK - 1):
    theta_power = wedge(theta_power, theta)
factor = factorial(RANK - 1)
assert all(value % factor == 0 for value in theta_power.values())
minimal_curve = vector(ZZ, [theta_power.get(target_curve, 0) // factor
                            for target_curve in curve_targets])
curve_lattice = span(ZZ, curve_rows)
assert curve_lattice.rank() == RANK * (RANK + 1) // 2
curve_coordinates = curve_lattice.coordinate_vector(minimal_curve)
curve_order = lcm(value.denominator() for value in curve_coordinates)
assert curve_order == 4
print(f"monomials={count}")
print(f"ns_index={abs(coefficient_lattice.basis_matrix().det())}")
print(f"top_gcd={top_gcd}")
print(f"witness={witness}")
print(f"curve_monomials={len(curve_rows)}")
print(f"curve_rank={curve_lattice.rank()}")
print(f"curve_order={curve_order}")
print("PASS")
