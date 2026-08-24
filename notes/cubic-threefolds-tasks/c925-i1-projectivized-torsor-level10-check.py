#!/usr/bin/env python3
"""Exact lattice check behind the C925 type-I1 level-ten bound.

Tschinkel--Zhang Lemma 4.2 gives a unimodular permutation basis b_1,...,b_11
for Pic(Sbar) plus a rank-five permutation lattice.  This script checks that
the primitive anticanonical degree cocharacter has weights

    (2,2,2,2,2,2,-3,-3,-3,-3,4)

in that basis, and that the type-I1 subgroup has orbits of sizes 6, 4, 1.
It also checks the unimodular two-variable monomial change which makes the
resulting one-dimensional torus action visibly rational.
"""

import argparse
import json
import math
from pathlib import Path

import sympy as sp


# Columns are b_1,...,b_11 in the old basis
# H,E_1,...,E_5,w_0,w_1,w_2,q_0,q_1 from Lemma 4.2.
B_COLUMNS = (
    (2, 0, -1, -1, -1, -1, -1, 0, -1, -2, -1),
    (1, -1, 0, 0, 0, 0, -1, -1, 0, -1, -2),
    (2, -1, 0, -1, -1, -1, -1, -1, 0, -2, -1),
    (1, 0, -1, 0, 0, 0, 0, -1, -1, -1, -2),
    (1, 0, 0, 0, 0, -1, -1, 0, -1, -1, -2),
    (2, -1, -1, -1, -1, 0, 0, -1, -1, -2, -1),
    (-3, 1, 1, 2, 1, 1, 1, 1, 1, 3, 1),
    (-2, 1, 1, 0, 0, 1, 1, 1, 1, 1, 3),
    (-1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 3),
    (-3, 1, 1, 1, 2, 1, 1, 1, 1, 3, 1),
    (3, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2),
)


def permutation(n, cycles):
    value = list(range(n))
    for cycle in cycles:
        for index, entry in enumerate(cycle):
            value[entry] = cycle[(index + 1) % len(cycle)]
    return tuple(value)


def compose(left, right):
    return tuple(left[right[index]] for index in range(len(left)))


def closure(generators):
    identity = tuple(range(len(generators[0])))
    group = {identity}
    queue = [identity]
    while queue:
        value = queue.pop()
        for generator in generators:
            for product in (compose(value, generator), compose(generator, value)):
                if product not in group:
                    group.add(product)
                    queue.append(product)
    return sorted(group)


def permutation_order(value):
    identity = tuple(range(len(value)))
    product = identity
    for order in range(1, 13):
        product = compose(product, value)
        if product == identity:
            return order
    raise AssertionError("permutation order exceeds group order")


change_of_basis = sp.Matrix.hstack(
    *(sp.Matrix(column) for column in B_COLUMNS)
)
assert change_of_basis.det() == -1

# d(D)=(-K_S).D is (3,1,1,1,1,1) in the old H,E_i convention.
# It vanishes on the five auxiliary permutation directions.
degree = sp.Matrix([[3, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0]])
weights = tuple(int(entry) for entry in degree * change_of_basis)
expected_weights = (2, 2, 2, 2, 2, 2, -3, -3, -3, -3, 4)
assert weights == expected_weights
assert math.gcd(*weights) == 1

# Two generators of the order-twelve type-I1 subgroup, restricted from the
# displayed I3 permutation action.  Their action on b_1,...,b_11 suffices.
generator_one = permutation(
    11, ((0, 1), (2, 4), (3, 5), (6, 7), (8, 9))
)
generator_two = permutation(
    11, ((0, 3), (1, 2), (4, 5), (6, 8), (7, 9))
)
group = closure((generator_one, generator_two))
assert len(group) == 12
order_profile = {
    order: sum(permutation_order(value) == order for value in group)
    for order in (1, 2, 3, 6)
}
assert order_profile == {1: 1, 2: 7, 3: 2, 6: 2}

unseen = set(range(11))
orbits = []
while unseen:
    representative = min(unseen)
    orbit = sorted({value[representative] for value in group})
    assert all(weights[index] == weights[representative] for index in orbit)
    orbits.append(orbit)
    unseen -= set(orbit)
assert orbits == [list(range(6)), list(range(6, 10)), [10]]

# For coordinates x_1,y_1 of weights 2,-3, the monomials
# t=x_1^2 y_1 and s=x_1^3 y_1^2 form a unimodular change.  The first has
# weight one and the second weight zero.  Thus the remaining ten variables
# are a transcendence basis for the quotient field.
monomial_change = sp.Matrix([[2, 1], [3, 2]])
assert monomial_change.det() == 1
assert tuple(int(entry) for entry in monomial_change * sp.Matrix([2, -3])) == (1, 0)

certificate = {
    "schema": "c925-i1-projectivized-torsor-level10-v1",
    "lemma_4_2_change_of_basis_determinant": int(change_of_basis.det()),
    "type_i1_group_order": len(group),
    "type_i1_order_profile": {
        str(order): count for order, count in order_profile.items()
    },
    "type_i1_orbits": orbits,
    "anticanonical_degree_weights": list(weights),
    "weight_gcd": math.gcd(*weights),
    "monomial_change": [
        [int(entry) for entry in row] for row in monomial_change.tolist()
    ],
    "monomial_change_determinant": int(monomial_change.det()),
    "transformed_weights": [
        int(entry) for entry in monomial_change * sp.Matrix([2, -3])
    ],
    "conclusion": (
        "After quotienting the scalar anticanonical G_m, the rank-eleven "
        "quasi-trivial torus is acted on with orbit weights 2,-3,4. Its "
        "quotient is K-rational, yielding S x A^10 rational and hence the "
        "explicit type-I1 cubic threefold X x P^10 rational."
    ),
}

parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group()
mode.add_argument("--write-certificate", type=Path)
mode.add_argument("--check-certificate", type=Path)
arguments = parser.parse_args()
payload = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
if arguments.write_certificate is not None:
    arguments.write_certificate.write_text(payload, encoding="utf-8")
if arguments.check_certificate is not None:
    assert arguments.check_certificate.read_text(encoding="utf-8") == payload

print(payload, end="")
