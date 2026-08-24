#!/usr/bin/env python3
"""Exact restriction of Tschinkel--Zhang's I3 permutation resolution to I1.

This is an exact certificate for C925.  It reconstructs the Picard action
from Lemma 4.2, finds the unique C2 x S3 subgroup of the displayed I3
permutation group, enumerates every transitive permutation lattice and every
rational-character candidate of target rank below eleven, and rejects all
such candidates by exact modular group-algebra ranks.  It also tests the
smallest rational-character candidate

    Pic(Sbar) + Z  ~  Z[H/K4] + Z[H/K3]

integrally by computing the determinant form of every equivariant map.

It proves optimality of target rank eleven only within the direct stable-
permutation resolution method.  It does not prove that the del Pezzo surface
or cubic cannot become rational after fewer stabilizations by a nonlinear
birational construction.
"""

import argparse
import itertools
import json
import math
from pathlib import Path

import sympy as sp


def permutation(n, cycles):
    out = list(range(n))
    for cycle in cycles:
        for i, value in enumerate(cycle):
            out[value] = cycle[(i + 1) % len(cycle)]
    return tuple(out)


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def inverse(value):
    out = [0] * len(value)
    for i, image in enumerate(value):
        out[image] = i
    return tuple(out)


def multiply(left, right):
    return compose(left[0], right[0]), compose(left[1], right[1])


IDENTITY = permutation(5, ()), permutation(11, ())
G1 = (
    permutation(5, ((1, 2), (3, 4))),
    permutation(11, ((0, 1), (2, 4), (3, 5), (6, 7), (8, 9))),
)
G2 = (
    permutation(5, ((0, 2, 1),)),
    permutation(11, ((0, 5, 2), (1, 4, 3), (7, 8))),
)


def closure(generators):
    elements = {IDENTITY}
    queue = [IDENTITY]
    while queue:
        value = queue.pop()
        for generator in generators:
            for product in (multiply(value, generator), multiply(generator, value)):
                if product not in elements:
                    elements.add(product)
                    queue.append(product)
    return sorted(elements)


def element_order(value):
    product = IDENTITY
    for order in range(1, 49):
        product = multiply(product, value)
        if product == IDENTITY:
            return order
    raise AssertionError("order bound exceeded")


def permutation_matrix(value):
    matrix = sp.zeros(len(value))
    for column, row in enumerate(value):
        matrix[row, column] = 1
    return matrix


group_i3 = closure((G1, G2))
assert len(group_i3) == 24
subgroups_order_12 = {
    frozenset(closure((left, right)))
    for left, right in itertools.combinations_with_replacement(group_i3, 2)
    if len(closure((left, right))) == 12
}
group_i1 = next(
    sorted(subgroup)
    for subgroup in subgroups_order_12
    if sum(element_order(value) == 2 for value in subgroup) == 7
)
assert {order: sum(element_order(value) == order for value in group_i1)
        for order in (1, 2, 3, 6)} == {1: 1, 2: 7, 3: 2, 6: 2}

# Columns are b1,...,b11 in the old basis
# H,E1,...,E5,w0,w1,w2,q0,q1 from Lemma 4.2.
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
change_of_basis = sp.Matrix.hstack(*(sp.Matrix(column) for column in B_COLUMNS))
assert change_of_basis.det() == -1
change_of_basis_inverse = change_of_basis.inv()

old_actions = {
    value: change_of_basis * permutation_matrix(value[1]) * change_of_basis_inverse
    for value in group_i1
}
assert all(
    matrix[:6, 6:] == sp.zeros(6, 5)
    and matrix[6:, :6] == sp.zeros(5, 6)
    for matrix in old_actions.values()
)
picard_plus_trivial_actions = {
    value: sp.diag(matrix[:6, :6], sp.ones(1))
    for value, matrix in old_actions.items()
}


def conjugate_subgroup(subgroup, value):
    value_inverse = (inverse(value[0]), inverse(value[1]))
    return frozenset(multiply(multiply(value, member), value_inverse)
                     for member in subgroup)


all_subgroups = set()
for left, right in itertools.combinations_with_replacement(group_i1, 2):
    candidate = closure((left, right))
    if all(value in group_i1 for value in candidate):
        all_subgroups.add(frozenset(candidate))
brute_subgroups = set()
nonidentity = [value for value in group_i1 if value != IDENTITY]
for mask in range(1 << len(nonidentity)):
    subset = {IDENTITY}
    subset.update(value for index, value in enumerate(nonidentity)
                  if mask & (1 << index))
    if all(multiply(left, right) in subset
           for left in subset for right in subset):
        brute_subgroups.add(frozenset(subset))
assert all_subgroups == brute_subgroups
subgroup_representatives = []
for subgroup in all_subgroups:
    if not any(
        any(conjugate_subgroup(representative, value) == subgroup
            for value in group_i1)
        for representative in subgroup_representatives
    ):
        subgroup_representatives.append(subgroup)
assert len(subgroup_representatives) == 10

subgroup_k4 = next(subgroup for subgroup in subgroup_representatives
                   if len(subgroup) == 4)
subgroup_k3 = next(subgroup for subgroup in subgroup_representatives
                   if len(subgroup) == 3)


def coset_representatives(subgroup):
    unseen = set(group_i1)
    representatives = []
    while unseen:
        representative = min(unseen)
        representatives.append(representative)
        unseen -= {multiply(representative, member) for member in subgroup}
    return representatives


reps_k4 = coset_representatives(subgroup_k4)
reps_k3 = coset_representatives(subgroup_k3)
assert len(reps_k4) == 3 and len(reps_k3) == 4


def primitive_fixed_basis(subgroup):
    equations = sp.Matrix.vstack(*(
        picard_plus_trivial_actions[value] - sp.eye(7) for value in subgroup
    ))
    basis = []
    for vector in equations.nullspace():
        denominator = sp.ilcm(*(entry.q for entry in vector))
        integral = (vector * denominator).applyfunc(int)
        divisor = math.gcd(*(abs(int(entry)) for entry in integral if entry))
        basis.append(integral / divisor)
    return basis


fixed_k4 = primitive_fixed_basis(subgroup_k4)
fixed_k3 = primitive_fixed_basis(subgroup_k3)
assert len(fixed_k4) == 3 and len(fixed_k3) == 5

x_variables = sp.symbols("x0:3")
y_variables = sp.symbols("y0:5")
vector_k4 = sum((coefficient * vector
                 for coefficient, vector in zip(x_variables, fixed_k4)), sp.zeros(7, 1))
vector_k3 = sum((coefficient * vector
                 for coefficient, vector in zip(y_variables, fixed_k3)), sp.zeros(7, 1))
intertwiner = sp.Matrix.hstack(
    *(picard_plus_trivial_actions[value] * vector_k4 for value in reps_k4),
    *(picard_plus_trivial_actions[value] * vector_k3 for value in reps_k3),
)
determinant_form = sp.Poly(
    sp.expand(intertwiner.det(method="domain-ge")),
    *x_variables,
    *y_variables,
)
content = math.gcd(*(abs(int(coefficient))
                     for coefficient in determinant_form.coeffs()))

print("I3_order", len(group_i3))
print("I1_order_profile", {order: sum(element_order(value) == order
                                        for value in group_i1)
                            for order in (1, 2, 3, 6)})
print("change_of_basis_det", change_of_basis.det())
print("fixed_ranks", len(fixed_k4), len(fixed_k3))
print("determinant_terms", len(determinant_form.terms()))
print("determinant_content", content)

def coset_action_matrix(subgroup, representatives, value):
    matrix = sp.zeros(len(representatives))
    subgroup_set = set(subgroup)
    for column, representative in enumerate(representatives):
        image = multiply(value, representative)
        row = next(
            index for index, candidate in enumerate(representatives)
            if multiply((inverse(candidate[0]), inverse(candidate[1])), image)
            in subgroup_set
        )
        matrix[row, column] = 1
    return matrix


def rank_mod_prime(matrix, prime):
    rows = [[int(matrix[row, column]) % prime
             for column in range(matrix.cols)]
            for row in range(matrix.rows)]
    rank = 0
    for column in range(matrix.cols):
        pivot = next((row for row in range(rank, matrix.rows)
                      if rows[row][column]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        scale = pow(rows[rank][column], -1, prime)
        rows[rank] = [(scale * entry) % prime for entry in rows[rank]]
        for row in range(matrix.rows):
            if row == rank or not rows[row][column]:
                continue
            factor = rows[row][column]
            rows[row] = [(entry - factor * pivot_entry) % prime
                         for entry, pivot_entry in zip(rows[row], rows[rank])]
        rank += 1
    return rank


def first_group_algebra_rank_mismatch(source, target, prime):
    size = next(iter(source.values())).rows
    identity = sp.eye(size)
    deltas_source = {value: source[value] - identity for value in group_i1}
    deltas_target = {value: target[value] - identity for value in group_i1}
    for left in group_i1:
        for right in group_i1:
            tests = (
                ("product", deltas_source[left] * deltas_source[right],
                 deltas_target[left] * deltas_target[right]),
                ("sum", deltas_source[left] + deltas_source[right],
                 deltas_target[left] + deltas_target[right]),
            )
            for label, source_test, target_test in tests:
                source_rank = rank_mod_prime(source_test, prime)
                target_rank = rank_mod_prime(target_test, prime)
                if source_rank != target_rank:
                    return label, element_order(left), element_order(right), source_rank, target_rank
    return None


# Exhaust every rational permutation-character identity with auxiliary rank
# at most four (equivalently target rank below eleven), then apply exact
# modular group-algebra rank invariants.  A single mismatch proves that the
# two integral lattices cannot be isomorphic.
transitive_types = sorted(
    subgroup_representatives,
    key=lambda subgroup: (len(group_i1) // len(subgroup), sorted(subgroup)),
)
transitive_representatives = [coset_representatives(subgroup)
                              for subgroup in transitive_types]
transitive_sizes = [len(representatives)
                    for representatives in transitive_representatives]
transitive_actions = [
    {value: coset_action_matrix(subgroup, representatives, value)
     for value in group_i1}
    for subgroup, representatives in zip(
        transitive_types, transitive_representatives
    )
]
transitive_characters = [
    tuple(int(actions[value].trace()) for value in group_i1)
    for actions in transitive_actions
]
picard_character = tuple(int(old_actions[value][:6, :6].trace())
                         for value in group_i1)


def permutation_combinations(maximum_rank):
    combinations = []

    def visit(index, remaining, counts):
        if index == len(transitive_sizes):
            combinations.append(tuple(counts))
            return
        size = transitive_sizes[index]
        for count in range(remaining // size + 1):
            counts[index] = count
            visit(index + 1, remaining - count * size, counts)
        counts[index] = 0

    visit(0, maximum_rank, [0] * len(transitive_sizes))
    return combinations


def combination_rank(counts):
    return sum(count * size for count, size in zip(counts, transitive_sizes))


def combination_character(counts):
    return tuple(
        sum(count * character[index]
            for count, character in zip(counts, transitive_characters))
        for index in range(len(group_i1))
    )


def direct_sum_actions(counts, include_picard=False):
    result = {}
    for value in group_i1:
        blocks = []
        if include_picard:
            blocks.append(old_actions[value][:6, :6])
        for count, actions in zip(counts, transitive_actions):
            blocks.extend([actions[value]] * count)
        result[value] = sp.diag(*blocks)
    return result


all_combinations = permutation_combinations(10)
combinations_by_rank_character = {}
for counts in all_combinations:
    key = combination_rank(counts), combination_character(counts)
    combinations_by_rank_character.setdefault(key, []).append(counts)

rational_candidates = []
for source_counts in all_combinations:
    source_auxiliary_rank = combination_rank(source_counts)
    if source_auxiliary_rank > 4:
        continue
    source_character = combination_character(source_counts)
    target_character = tuple(picard + auxiliary
                             for picard, auxiliary
                             in zip(picard_character, source_character))
    for target_counts in combinations_by_rank_character.get(
        (source_auxiliary_rank + 6, target_character), ()
    ):
        rational_candidates.append((source_counts, target_counts))

candidate_results = []
for source_counts, target_counts in rational_candidates:
    source_actions = direct_sum_actions(source_counts, include_picard=True)
    target_actions = direct_sum_actions(target_counts)
    obstructions = []
    for prime in (2, 3, 5):
        mismatch = first_group_algebra_rank_mismatch(
            source_actions, target_actions, prime
        )
        if mismatch is not None:
            obstructions.append((prime, mismatch))
            break
    candidate_results.append({
        "source_rank": combination_rank(source_counts),
        "target_rank": combination_rank(target_counts),
        "source": source_counts,
        "target": target_counts,
        "obstructions": obstructions,
    })

print("rational_candidates_below_11", len(candidate_results))
print("unobstructed_candidates_below_11", [
    result for result in candidate_results if not result["obstructions"]
])
print("candidate_obstruction_summary", [
    (result["source_rank"], result["target_rank"], result["obstructions"])
    for result in candidate_results
])

certificate = {
    "schema": "c925-i1-permutation-resolution-v1",
    "group": {
        "i3_order": len(group_i3),
        "i1_order_profile": {
            str(order): sum(element_order(value) == order for value in group_i1)
            for order in (1, 2, 3, 6)
        },
        "subgroup_conjugacy_classes": len(subgroup_representatives),
    },
    "source_reconstruction": {
        "lemma_4_2_change_of_basis_determinant": int(change_of_basis.det()),
        "rank_seven_determinant_content": content,
        "rank_seven_determinant_terms": len(determinant_form.terms()),
    },
    "exhaustion": {
        "rational_candidates_target_rank_below_11": len(candidate_results),
        "target_rank_counts": {
            str(rank): sum(result["target_rank"] == rank
                           for result in candidate_results)
            for rank in sorted({result["target_rank"]
                                for result in candidate_results})
        },
        "unobstructed_candidates": sum(not result["obstructions"]
                                        for result in candidate_results),
        "candidates": candidate_results,
    },
    "conclusion": (
        "For the displayed type-I1 Picard lattice, no stable-permutation "
        "identity Pic+P=P' has rank(P')<11. The paper's rank-11 identity is "
        "therefore optimal within this method, not an intrinsic lower bound "
        "on the stable-rationality level."
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
