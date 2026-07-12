#!/usr/bin/env python3

import argparse
import functools
import itertools


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def inverse(permutation):
    return tuple(permutation.index(i) for i in range(len(permutation)))


def permutation_order(permutation):
    identity = tuple(range(len(permutation)))
    power = identity
    for order in range(1, 2 * len(permutation) + 1):
        power = compose(power, permutation)
        if power == identity:
            return order
    raise ValueError(permutation)


def cycle_type(permutation):
    seen = set()
    lengths = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        vertex = start
        length = 0
        while vertex not in seen:
            seen.add(vertex)
            vertex = permutation[vertex]
            length += 1
        if length > 1:
            lengths.append(length)
    return tuple(sorted(lengths, reverse=True))


def generated_group(generators):
    identity = tuple(range(len(generators[0])))
    group = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            product = compose(element, generator)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return frozenset(group)


def conjugate(element, by):
    return compose(compose(by, element), inverse(by))


def left_coset_action(group, stabilizer):
    unseen = set(group)
    cosets = []
    while unseen:
        representative = next(iter(unseen))
        coset = frozenset(compose(representative, element) for element in stabilizer)
        cosets.append(coset)
        unseen -= coset
    index = {element: i for i, coset in enumerate(cosets) for element in coset}
    action = {
        element: tuple(index[compose(element, next(iter(coset)))] for coset in cosets)
        for element in group
    }
    return action


@functools.cache
def grundy(adjacency, remaining):
    if remaining == 0:
        return 0
    options = set()
    vertices = remaining
    while vertices:
        bit = vertices & -vertices
        vertex = bit.bit_length() - 1
        options.add(grundy(adjacency, remaining & ~bit & ~adjacency[vertex]))
        vertices ^= bit
    value = 0
    while value in options:
        value += 1
    return value


def residual_template(group, generators, stabilizer):
    action = left_coset_action(group, stabilizer)
    size = len(next(iter(action.values())))
    dead = {
        vertex
        for left, right in itertools.combinations(generators, 2)
        for vertex, image in enumerate(action[compose(left, right)])
        if vertex == image
    }
    live = tuple(vertex for vertex in range(size) if vertex not in dead)
    live_index = {vertex: i for i, vertex in enumerate(live)}
    adjacency = [0] * len(live)
    for generator in generators:
        permutation = action[generator]
        for vertex in live:
            image = permutation[vertex]
            if image in live_index and image != vertex:
                adjacency[live_index[vertex]] |= 1 << live_index[image]
    adjacency = tuple(adjacency)
    return len(dead), adjacency, grundy(adjacency, (1 << len(adjacency)) - 1)


def component_profile(adjacency):
    unseen = (1 << len(adjacency)) - 1
    components = []
    while unseen:
        frontier = unseen & -unseen
        component = 0
        while frontier:
            component |= frontier
            unseen &= ~frontier
            neighbours = 0
            vertices = frontier
            while vertices:
                bit = vertices & -vertices
                neighbours |= adjacency[bit.bit_length() - 1]
                vertices ^= bit
            frontier = neighbours & unseen
        members = tuple(i for i in range(len(adjacency)) if component >> i & 1)
        degrees = tuple(sorted((adjacency[i] & component).bit_count() for i in members))
        edges = sum(degrees) // 2
        components.append((len(members), edges, degrees))
    return tuple(sorted(components))


def s4_templates():
    group = tuple(itertools.permutations(range(4)))
    identity = tuple(range(4))
    involutions = tuple(
        element
        for element in group
        if element != identity and compose(element, element) == identity
    )
    triples = {
        frozenset(triple)
        for triple in itertools.combinations(involutions, 3)
        if len(generated_group(triple)) == 24
    }
    classes = {}
    unseen = set(triples)
    labels = {(3, 3, 3): "A", (3, 4, 4): "B", (2, 3, 3): "C", (2, 3, 4): "D"}
    while unseen:
        triple = unseen.pop()
        orbit = {
            frozenset(conjugate(generator, element) for generator in triple)
            for element in group
        }
        unseen -= orbit
        pair_orders = tuple(
            sorted(permutation_order(compose(left, right)) for left, right in itertools.combinations(triple, 2))
        )
        classes[labels[pair_orders]] = (triple, len(orbit))

    representatives = {
        "O4": next(element for element in group if cycle_type(element) == (4,)),
        "O3": next(element for element in group if cycle_type(element) == (3,)),
        "O2": next(element for element in group if cycle_type(element) == (2,)),
    }
    stabilizers = {
        name: generated_group((representative,))
        for name, representative in representatives.items()
    }
    stabilizers["free"] = frozenset((identity,))

    for label in "ABCD":
        triple, class_size = classes[label]
        generator_types = tuple(sorted((cycle_type(generator) for generator in triple), key=repr))
        pair_orders = tuple(
            sorted(permutation_order(compose(left, right)) for left, right in itertools.combinations(triple, 2))
        )
        print(f"S4 class {label}: size={class_size} generators={generator_types} pair_orders={pair_orders}")
        for orbit_name in ("O4", "O3", "O2", "free"):
            dead, adjacency, value = residual_template(group, triple, stabilizers[orbit_name])
            print(
                f"  {orbit_name}: order={len(adjacency) + dead} dead={dead} "
                f"components={component_profile(adjacency)} grundy={value}"
            )


def d8_profile(q):
    residue = q % 8
    if residue == 1:
        return (((q - 1) // 8, 0, 2), ((q - 9) // 8, 2, 6))
    if residue == 3:
        return (((q - 3) // 8, 1, 2),)
    if residue == 5:
        return (((q - 5) // 8, 1, 4),)
    if residue == 7:
        return (((q + 1) // 8, 0, 0), ((q - 7) // 8, 2, 4))
    raise ValueError("q must be odd")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("q", type=int, nargs="*", help="odd prime powers for the D8 profile")
    parser.add_argument("--s4", action="store_true")
    args = parser.parse_args()
    for q in args.q:
        for a, b, dead in d8_profile(q):
            print(f"D8 q={q}: a={a} b={b} dead={dead} grundy={(a + b) % 2}")
    if args.s4:
        s4_templates()


if __name__ == "__main__":
    main()
