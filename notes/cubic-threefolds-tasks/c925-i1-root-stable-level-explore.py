#!/usr/bin/env python3
"""Explore small stable-permutation resolutions of the type-I1 root torus."""

import runpy

import sympy as sp


d = runpy.run_path(
    "notes/cubic-threefolds-tasks/c925-i1-permutation-resolution-check.py"
)
group = d["group_i1"]
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

transitive_actions = d["transitive_actions"]
transitive_sizes = d["transitive_sizes"]
transitive_characters = d["transitive_characters"]
all_combinations = d["all_combinations"]
combination_rank = d["combination_rank"]
combination_character = d["combination_character"]
first_mismatch = d["first_group_algebra_rank_mismatch"]


def direct_sum(counts, root_variant=None):
    result = {}
    for value in group:
        blocks = []
        if root_variant == "column":
            blocks.append(root_actions[value])
        elif root_variant == "dual":
            blocks.append(root_actions[value].inv().T)
        for count, actions in zip(counts, transitive_actions):
            blocks.extend([actions[value]] * count)
        result[value] = sp.diag(*blocks)
    return result


by_rank_character = {}
for counts in all_combinations:
    by_rank_character.setdefault(
        (combination_rank(counts), combination_character(counts)), []
    ).append(counts)

for variant in ("column", "dual"):
    root_character = tuple(
        int(direct_sum((0,) * len(transitive_sizes), variant)[value].trace())
        for value in group
    )
    print("VARIANT", variant)
    for source_counts in all_combinations:
        source_rank = combination_rank(source_counts)
        if source_rank > 4:
            continue
        source_character = combination_character(source_counts)
        target_character = tuple(
            left + right for left, right in zip(root_character, source_character)
        )
        targets = by_rank_character.get(
            (source_rank + 5, target_character), ()
        )
        for target_counts in targets:
            source = direct_sum(source_counts, variant)
            target = direct_sum(target_counts)
            obstruction = next(
                (
                    (prime, mismatch)
                    for prime in (2, 3, 5, 7)
                    if (mismatch := first_mismatch(source, target, prime))
                    is not None
                ),
                None,
            )
            print(
                "CANDIDATE",
                "source_rank=", source_rank,
                "source=", source_counts,
                "target=", target_counts,
                "obstruction=", obstruction,
            )
