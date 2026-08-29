#!/usr/bin/env python3
"""Exhaust signed-permutation models for the type-I1 rank-seven lattice."""

import itertools
import runpy

import sympy as sp


d = runpy.run_path(
    "notes/cubic-threefolds-tasks/c925-i1-permutation-resolution-check.py"
)
group = d["group_i1"]
identity = d["IDENTITY"]
multiply = d["multiply"]
inverse = d["inverse"]
element_order = d["element_order"]
subgroups = d["subgroup_representatives"]
first_mismatch = d["first_group_algebra_rank_mismatch"]

root_basis = sp.Matrix.hstack(
    sp.Matrix([0, 1, 0, 0, 0, -1]),
    sp.Matrix([0, 0, 1, 0, 0, -1]),
    sp.Matrix([0, 0, 0, 1, 0, -1]),
    sp.Matrix([0, 0, 0, 0, 1, -1]),
    sp.Matrix([1, 0, 0, 0, 0, -3]),
)
root_left_inverse = (root_basis.T * root_basis).inv() * root_basis.T
root_actions = {
    value: root_left_inverse * d["old_actions"][value][:6, :6] * root_basis
    for value in group
}


def augmentation_three(permutation_action):
    return sp.Matrix.hstack(
        permutation_action[:2, 0] - permutation_action[:2, 2],
        permutation_action[:2, 1] - permutation_action[:2, 2],
    )


i_actions = {
    value: augmentation_three(d["old_actions"][value][6:9, 6:9])
    for value in group
}


def characters_of_subgroup(subgroup):
    members = sorted(subgroup)
    result = []
    for bits in itertools.product((-1, 1), repeat=len(members)):
        character = dict(zip(members, bits))
        if character[identity] != 1:
            continue
        if all(
            character[multiply(left, right)]
            == character[left] * character[right]
            for left in members for right in members
        ):
            result.append(character)
    return result


def coset_representatives(subgroup):
    unseen = set(group)
    representatives = []
    while unseen:
        representative = min(unseen)
        representatives.append(representative)
        unseen -= {multiply(representative, member) for member in subgroup}
    return representatives


def signed_coset_actions(subgroup, character):
    representatives = coset_representatives(subgroup)
    subgroup_set = set(subgroup)
    result = {}
    for value in group:
        matrix = sp.zeros(len(representatives))
        for column, representative in enumerate(representatives):
            image = multiply(value, representative)
            row, correction = next(
                (index, multiply(
                    (inverse(candidate[0]), inverse(candidate[1])), image
                ))
                for index, candidate in enumerate(representatives)
                if multiply(
                    (inverse(candidate[0]), inverse(candidate[1])), image
                ) in subgroup_set
            )
            matrix[row, column] = character[correction]
        result[value] = matrix
    return result


types = []
seen = set()
for subgroup in subgroups:
    for character in characters_of_subgroup(subgroup):
        actions = signed_coset_actions(subgroup, character)
        key = tuple(
            tuple(int(entry) for entry in actions[value]) for value in group
        )
        if key in seen:
            continue
        seen.add(key)
        types.append({
            "rank": next(iter(actions.values())).rows,
            "actions": actions,
            "character": tuple(int(actions[value].trace()) for value in group),
        })
types.sort(key=lambda item: item["rank"])
print("SIGNED_TRANSITIVE_TYPES", {
    rank: sum(item["rank"] == rank for item in types)
    for rank in sorted({item["rank"] for item in types})
})


def combinations_of_rank(rank):
    result = []

    def visit(index, remaining, counts):
        if remaining == 0:
            result.append(tuple(counts))
            return
        for type_index in range(index, len(types)):
            size = types[type_index]["rank"]
            if size > remaining:
                break
            counts[type_index] += 1
            visit(type_index, remaining - size, counts)
            counts[type_index] -= 1

    visit(0, rank, [0] * len(types))
    return result


def actions_for_combination(counts):
    return {
        value: sp.diag(*[
            item["actions"][value]
            for count, item in zip(counts, types)
            for _ in range(count)
        ])
        for value in group
    }


for variant in ("column", "dual"):
    source = {}
    for value in group:
        root = root_actions[value]
        if variant == "dual":
            root = root.inv().T
        source[value] = sp.diag(root, i_actions[value])
    source_character = tuple(int(source[value].trace()) for value in group)
    candidates = []
    for counts in combinations_of_rank(7):
        target_character = tuple(
            sum(
                count * item["character"][index]
                for count, item in zip(counts, types)
            )
            for index in range(len(group))
        )
        if target_character != source_character:
            continue
        target = actions_for_combination(counts)
        obstruction = next(
            (
                (prime, mismatch)
                for prime in (2, 3, 5, 7)
                if (mismatch := first_mismatch(source, target, prime))
                is not None
            ),
            None,
        )
        candidates.append((counts, obstruction))
    print("VARIANT", variant, "CHARACTER_CANDIDATES", len(candidates))
    print("UNOBSTRUCTED", [item for item in candidates if item[1] is None])
    print("OBSTRUCTIONS", [item[1] for item in candidates])

for variant in ("column", "dual"):
    source = {}
    for value in group:
        picard = d["old_actions"][value][:6, :6]
        if variant == "dual":
            picard = picard.inv().T
        source[value] = picard
    source_character = tuple(int(source[value].trace()) for value in group)
    candidates = []
    for counts in combinations_of_rank(6):
        target_character = tuple(
            sum(
                count * item["character"][index]
                for count, item in zip(counts, types)
            )
            for index in range(len(group))
        )
        if target_character != source_character:
            continue
        target = actions_for_combination(counts)
        obstruction = next(
            (
                (prime, mismatch)
                for prime in (2, 3, 5, 7)
                if (mismatch := first_mismatch(source, target, prime))
                is not None
            ),
            None,
        )
        candidates.append((counts, obstruction))
    print("PICARD_VARIANT", variant, "CHARACTER_CANDIDATES", len(candidates))
    print("PICARD_UNOBSTRUCTED", [item for item in candidates if item[1] is None])
    print("PICARD_OBSTRUCTIONS", [item[1] for item in candidates])
