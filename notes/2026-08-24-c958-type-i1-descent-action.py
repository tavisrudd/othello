#!/usr/bin/env python3
"""Conjugate the Proposition 5.1 type-I1 action into the C956 type-I3 marking."""

import argparse
import itertools
import json
from pathlib import Path


IDENTITY = tuple(range(5))


def permute_mask(permutation, mask):
    answer = 0
    for index in range(5):
        if mask & (1 << index):
            answer |= 1 << permutation[index]
    return answer


def compose(left, right):
    """Compose affine odd-subset actions: apply right, then left."""
    left_perm, left_flip = left
    right_perm, right_flip = right
    permutation = tuple(left_perm[right_perm[index]] for index in range(5))
    flip = left_flip ^ permute_mask(left_perm, right_flip)
    return permutation, flip


def inverse(element):
    permutation, flip = element
    inverse_permutation = tuple(permutation.index(index) for index in range(5))
    return inverse_permutation, permute_mask(inverse_permutation, flip)


def cycle(*indices):
    permutation = list(IDENTITY)
    for left, right in zip(indices, indices[1:] + indices[:1]):
        permutation[left - 1] = right - 1
    return tuple(permutation)


def product_of_disjoint_cycles(*cycles):
    permutation = IDENTITY
    for indices in cycles:
        permutation = compose((cycle(*indices), 0), (permutation, 0))[0]
    return permutation


def flip(*indices):
    return sum(1 << (index - 1) for index in indices)


def generate(generators):
    identity = (IDENTITY, 0)
    group = {identity}
    queue = [identity]
    while queue:
        value = queue.pop()
        for generator in generators:
            for product in (compose(value, generator), compose(generator, value)):
                if product not in group:
                    group.add(product)
                    queue.append(product)
    return frozenset(group)


def conjugate(element, by):
    return compose(compose(by, element), inverse(by))


def act(element, mask):
    permutation, flipped = element
    return permute_mask(permutation, mask) ^ flipped


def coordinate_dictionary():
    all_five = (1 << 5) - 1
    result = {1 << index: f"E{index + 1}" for index in range(5)}
    for left in range(5):
        for right in range(left + 1, 5):
            result[all_five ^ (1 << left) ^ (1 << right)] = f"L{left + 1}{right + 1}"
    result[all_five] = "Q"
    assert len(result) == 16 and all(mask.bit_count() % 2 == 1 for mask in result)
    return result


def element_json(element):
    permutation, flipped = element
    return {
        "permutation_images_1_based": [value + 1 for value in permutation],
        "flipped_indices_1_based": [index + 1 for index in range(5) if flipped & (1 << index)],
    }


def build():
    type_i1_generators = [
        (cycle(1, 2, 3), 0),
        (cycle(2, 3), flip(1, 2, 3, 5)),
        (IDENTITY, flip(4, 5)),
    ]
    type_i3_generators = [
        (cycle(2, 5), flip(1, 2, 3, 5)),
        (product_of_disjoint_cycles((3, 4), (1, 5, 2)), flip(3, 4)),
    ]
    type_i1 = generate(type_i1_generators)
    type_i3 = generate(type_i3_generators)
    assert len(type_i1) == 12
    assert len(type_i3) == 24

    all_weyl = [
        (permutation, flipped)
        for permutation in itertools.permutations(range(5))
        for flipped in range(1 << 5)
        if flipped.bit_count() % 2 == 0
    ]
    assert len(all_weyl) == 1920
    conjugators = [
        element
        for element in all_weyl
        if frozenset(conjugate(value, element) for value in type_i1) <= type_i3
    ]
    assert conjugators
    chosen = min(conjugators)

    coordinate_by_mask = coordinate_dictionary()
    mask_by_coordinate = {name: mask for mask, name in coordinate_by_mask.items()}
    target_blocks = [
        ["L13", "L23", "L35"],
        ["L14", "L24", "L45"],
        ["E1", "E2", "E5"],
        ["L12", "L15", "L25"],
    ]
    chosen_inverse = inverse(chosen)
    source_blocks = [
        sorted(coordinate_by_mask[act(chosen_inverse, mask_by_coordinate[name])] for name in block)
        for block in target_blocks
    ]
    source_boundary = sorted(
        coordinate_by_mask[act(chosen_inverse, mask_by_coordinate[name])]
        for name in ["E3", "E4", "L34", "Q"]
    )
    block_lookup = {
        name: block_index for block_index, block in enumerate(source_blocks) for name in block
    }
    assert len(block_lookup) == 12

    generator_coordinate_actions = []
    generator_block_actions = []
    for generator in type_i1_generators:
        coordinate_action = {
            name: coordinate_by_mask[act(generator, mask)]
            for mask, name in coordinate_by_mask.items()
        }
        generator_coordinate_actions.append(coordinate_action)
        block_action = []
        for block in source_blocks:
            image_indices = {block_lookup[coordinate_action[name]] for name in block}
            assert len(image_indices) == 1
            block_action.append(next(iter(image_indices)))
        generator_block_actions.append(block_action)
        assert {coordinate_action[name] for name in source_boundary} == set(source_boundary)

    coordinate_orbits = []
    remaining = set(coordinate_by_mask.values())
    while remaining:
        start = min(remaining)
        start_mask = mask_by_coordinate[start]
        orbit = sorted({coordinate_by_mask[act(element, start_mask)] for element in type_i1})
        coordinate_orbits.append(orbit)
        remaining -= set(orbit)

    selected_start = source_blocks[0][0]
    selected_stabilizer = [
        element
        for element in type_i1
        if coordinate_by_mask[act(element, mask_by_coordinate[selected_start])] == selected_start
    ]
    boundary_start = source_boundary[0]
    boundary_stabilizer = [
        element
        for element in type_i1
        if coordinate_by_mask[act(element, mask_by_coordinate[boundary_start])] == boundary_start
    ]
    all_block_actions = set()
    block_kernel = []
    for element in type_i1:
        action_on_blocks = []
        for block in source_blocks:
            images = {
                block_lookup[coordinate_by_mask[act(element, mask_by_coordinate[name])]]
                for name in block
            }
            assert len(images) == 1
            action_on_blocks.append(next(iter(images)))
        all_block_actions.add(tuple(action_on_blocks))
        if tuple(action_on_blocks) == tuple(range(4)):
            block_kernel.append(element)
    assert len(selected_stabilizer) == 1
    assert len(boundary_stabilizer) == 3
    assert len(all_block_actions) == 4
    assert len(block_kernel) == 3

    return {
        "schema": "c958-type-i1-descent-action-v1",
        "action_convention": "an element (p,F) sends an odd subset I to p(I) symmetric-difference F",
        "type_i1_order": len(type_i1),
        "type_i3_order": len(type_i3),
        "number_of_conjugators_into_type_i3": len(conjugators),
        "chosen_conjugator": element_json(chosen),
        "type_i1_generators": [element_json(value) for value in type_i1_generators],
        "type_i1_generator_coordinate_actions": generator_coordinate_actions,
        "pulled_back_selected_blocks": source_blocks,
        "pulled_back_boundary": source_boundary,
        "type_i1_generator_block_actions_zero_based": generator_block_actions,
        "coordinate_orbits": sorted(coordinate_orbits, key=lambda orbit: (len(orbit), orbit)),
        "permutation_module_structure": {
            "selected_twelve_stabilizer_order": len(selected_stabilizer),
            "selected_twelve_is_regular": True,
            "boundary_four_stabilizer_order": len(boundary_stabilizer),
            "four_block_action_image_order": len(all_block_actions),
            "four_block_action_kernel_order": len(block_kernel),
            "interpretation": "the selected coordinates are the regular G-set; the boundary and four blocks are G/C3",
        },
        "certified": [
            "the Proposition 5.1 group has order 12",
            "the C956 type-I3 group has order 24",
            "the chosen W(D5) conjugation embeds the former into the latter",
            "the pulled-back four-block set and boundary are type-I1 stable",
            "the displayed coordinate and block permutations follow from the odd-subset action",
            "the selected twelve coordinates form a regular type-I1 G-set and the boundary is G/C3",
        ],
        "not_certified": [
            "scalar normalization of Cox generators under semilinear Galois descent",
            "a ground-field tangent point or orbit-test point",
            "ground-field signed-minor formulas",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--write", type=Path)
    group.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    payload = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if arguments.write:
        arguments.write.write_text(payload)
    else:
        assert arguments.check.read_text() == payload


if __name__ == "__main__":
    main()
