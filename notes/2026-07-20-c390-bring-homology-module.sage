#!/usr/bin/env sage
"""Exact certificate for the Bring-curve J[2] module and S3 centralizer.

The integral matrices below were produced from the genus-four S5 action of
signature (0; 2,4,5), with generating vector
    (1,2), (2,5,4,3), (1,2,3,4,5),
using ``polyB.sage`` at commit e9d1c8d311a2463fc0a06fd510cb2c78adadbd86
of https://github.com/rojas-ani/sage-routines.  They are frozen here so that
the certificate itself has no dependency on that research code or KBMAG.
"""

import itertools
import json
import sys
from collections import Counter
from pathlib import Path

from sage.all import GF, block_diagonal_matrix, identity_matrix, matrix, vector
from sage.env import SAGE_VERSION


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "notes/2026-07-20-c390-bring-homology-module.json"
F2 = GF(2)

# Integral homology action for generators of orders 2, 4, and 5.
SOURCE_INTEGRAL = (
    ((0, 0, 0, 1, 0, 0, 0, -1), (-1, -1, 0, -1, 0, 0, 0, 1),
     (0, 0, -1, 0, 0, 0, 0, 0), (0, 0, 1, 0, 1, -1, 0, 0),
     (0, 0, 1, 1, 0, -1, 0, 0), (0, 0, 0, 0, 0, -1, 0, 0),
     (-1, 0, 0, -1, 0, 0, -1, 1), (-1, 0, 1, 0, 1, -1, 0, 0)),
    ((0, 0, 0, 0, 0, 1, 0, 0), (-1, 0, 0, -1, 0, 0, -1, 1),
     (1, 0, 0, 0, 0, 0, 0, 0), (0, 0, -1, 0, 0, 0, 1, -1),
     (-1, -1, -1, -1, 0, 1, 0, 0), (0, 0, 0, 0, 0, 1, 0, -1),
     (0, 0, 0, 0, 1, 0, 0, -1), (0, 0, -1, 0, 0, 1, 0, -1)),
    ((0, 0, -1, 0, 0, 0, 0, 0), (-1, -1, 0, -1, 1, 0, 0, 0),
     (1, 0, -1, 0, -1, 0, 0, 0), (0, 1, 1, 1, 0, 1, 0, -1),
     (-1, 0, 0, 0, 0, 1, -1, 0), (0, 0, 0, 1, 0, 0, 0, -1),
     (1, 0, 0, 1, 0, 0, 0, -1), (0, 0, 0, 1, 0, 1, 0, -1)),
)


def key(value):
    return tuple(int(entry) for entry in value.list())


def closure(generators):
    identity = identity_matrix(F2, 8)
    known = {key(identity): identity}
    frontier = [identity]
    while frontier:
        left = frontier.pop()
        for right in generators:
            product = left * right
            encoded = key(product)
            if encoded not in known:
                known[encoded] = product
                frontier.append(product)
    return tuple(known.values())


def element_order(value):
    identity = identity_matrix(F2, 8)
    product = identity
    for exponent in range(1, 121):
        product *= value
        if product == identity:
            return exponent
    raise AssertionError("unexpected order")


def deleted_permutation_matrix(permutation):
    columns = []
    for basis_index in range(4):
        source = [0] * 5
        source[basis_index] = source[4] = 1
        target = [0] * 5
        for old, new in enumerate(permutation):
            target[new] = source[old]
        columns.append(vector(F2, target[:4]))
    return matrix(F2, 4, 4, lambda row, column: columns[column][row])


def constraint_kernel(left_generators, right_generators):
    equations = []
    for left, right in zip(left_generators, right_generators):
        for row in range(8):
            for column in range(8):
                equation = vector(F2, 64)
                for source in range(8):
                    if left[source, column]:
                        equation[row * 8 + source] += 1
                    if right[row, source]:
                        equation[source * 8 + column] += 1
                equations.append(equation)
    return matrix(F2, equations).right_kernel()


def unpack(value):
    return matrix(F2, 8, 8, list(value))


def expand_deleted(value):
    return vector(F2, list(value) + [sum(value)])


def target_quadratic(value):
    return expand_deleted(value[:4]).dot_product(expand_deleted(value[4:]))


def matrix_rows(value):
    return [[int(entry) for entry in row] for row in value.rows()]


def main():
    source = tuple(matrix(F2, rows) for rows in SOURCE_INTEGRAL)
    assert tuple(element_order(value) for value in source) == (2, 4, 5)
    assert source[0] * source[1] * source[2] == identity_matrix(F2, 8)
    source_group = closure(source[:2])
    assert len(source_group) == 120
    source_order_spectrum = Counter(element_order(value) for value in source_group)
    assert source_order_spectrum == Counter({1: 1, 2: 25, 3: 20, 4: 30, 5: 24, 6: 20})

    target_first_permutation = (1, 0, 2, 3, 4)
    target_first = block_diagonal_matrix(
        deleted_permutation_matrix(target_first_permutation),
        deleted_permutation_matrix(target_first_permutation),
    )
    selected = None
    for target_second_permutation in itertools.permutations(range(5)):
        target_second = block_diagonal_matrix(
            deleted_permutation_matrix(target_second_permutation),
            deleted_permutation_matrix(target_second_permutation),
        )
        if element_order(target_second) != 4 or element_order(target_first * target_second) != 5:
            continue
        intertwiners = constraint_kernel(source[:2], (target_first, target_second))
        for coefficients in itertools.product((0, 1), repeat=intertwiners.dimension()):
            candidate = unpack(sum((coefficient * basis for coefficient, basis in zip(coefficients, intertwiners.basis())), vector(F2, 64)))
            if candidate.is_invertible():
                selected = (target_second_permutation, target_second, intertwiners, candidate)
                break
        if selected is not None:
            break
    assert selected is not None
    target_second_permutation, target_second, intertwiners, conjugacy = selected
    target_third = (target_first * target_second).inverse()
    target = (target_first, target_second, target_third)
    target_permutations = (target_first_permutation, target_second_permutation)
    assert tuple(element_order(value) for value in target) == (2, 4, 5)
    assert target[0] * target[1] * target[2] == identity_matrix(F2, 8)
    assert len(closure(target[:2])) == 120
    assert intertwiners.dimension() == 4
    assert all(conjugacy * left == right * conjugacy for left, right in zip(source, target))

    all_vectors = tuple(vector(F2, bits) for bits in itertools.product((0, 1), repeat=8))

    def source_quadratic(value):
        return target_quadratic(conjugacy * value)

    assert sum(source_quadratic(value) == 0 for value in all_vectors) == 136
    assert all(source_quadratic(action * value) == source_quadratic(value) for action in source for value in all_vectors)

    # Every refinement of the same polar form differs by a linear functional.
    invariant_refinements = []
    for linear in all_vectors:
        if all(
            source_quadratic(action * value) + linear.dot_product(action * value)
            == source_quadratic(value) + linear.dot_product(value)
            for action in source[:2]
            for value in all_vectors
        ):
            invariant_refinements.append(linear)
    assert len(invariant_refinements) == 1 and invariant_refinements[0].is_zero()

    commutant = constraint_kernel(source[:2], source[:2])
    assert commutant.dimension() == 4
    orthogonal_centralizer = []
    for coefficients in itertools.product((0, 1), repeat=commutant.dimension()):
        candidate = unpack(sum((coefficient * basis for coefficient, basis in zip(coefficients, commutant.basis())), vector(F2, 64)))
        if candidate.is_invertible() and all(source_quadratic(candidate * value) == source_quadratic(value) for value in all_vectors):
            orthogonal_centralizer.append(candidate)
    centralizer_orders = Counter(element_order(value) for value in orthogonal_centralizer)
    assert len(orthogonal_centralizer) == 6
    assert centralizer_orders == Counter({1: 1, 2: 3, 3: 2})

    result = {
        "schema": "othello.c390.bring_homology_module.v2",
        "sage_version": SAGE_VERSION,
        "topological_action": {
            "genus": 4,
            "quotient_signature": [0, [2, 4, 5]],
            "generating_vector": ["(1,2)", "(2,5,4,3)", "(1,2,3,4,5)"],
            "source_commit": "e9d1c8d311a2463fc0a06fd510cb2c78adadbd86",
            "source_repository": "https://github.com/rojas-ani/sage-routines",
            "integral_generators": [[list(row) for row in rows] for rows in SOURCE_INTEGRAL],
        },
        "mod_two_group_order": len(source_group),
        "mod_two_element_order_spectrum": {str(order): count for order, count in sorted(source_order_spectrum.items())},
        "module_model": "W_direct_sum_W for the deleted F2 permutation module W of S5",
        "target_permutation_generators_zero_based": [list(value) for value in target_permutations],
        "intertwiner_space_dimension": intertwiners.dimension(),
        "conjugacy": matrix_rows(conjugacy),
        "quadratic_isometry_verified_on_all_256_vectors": True,
        "invariant_quadratic_refinement_count": len(invariant_refinements),
        "invariant_quadratic_refinement_is_even": True,
        "linear_commutant_dimension": commutant.dimension(),
        "orthogonal_centralizer_order": len(orthogonal_centralizer),
        "orthogonal_centralizer_element_orders": {str(order): count for order, count in sorted(centralizer_orders.items())},
        "normalizer_order_using_AutS5_inner": 120 * len(orthogonal_centralizer),
        "normalizer_quotient_is_S3": True,
    }
    encoded = (json.dumps(result, indent=2, sort_keys=True, default=int) + "\n").encode()
    if "--write" in sys.argv:
        OUTPUT.write_bytes(encoded)
        print(f"wrote {OUTPUT.relative_to(ROOT)}")
    elif "--check" in sys.argv:
        assert OUTPUT.read_bytes() == encoded
        print(f"verified {OUTPUT.relative_to(ROOT)}")
    else:
        print(encoded.decode(), end="")


main()
