#!/usr/bin/env python3
"""Exact q=3,5 boundary for the mixed-class regular PGL2 Cayley scar."""

from __future__ import annotations

import argparse
import functools
import itertools
import json
import math
from collections import Counter
from pathlib import Path


Point = tuple[int, int, int]
Permutation = tuple[int, ...]
Adjacency = tuple[int, ...]


def inverse_mod(value: int, q: int) -> int:
    return pow(value % q, q - 2, q)


def normalize(point: Point, q: int) -> Point:
    for coordinate in point:
        if coordinate % q:
            scale = inverse_mod(coordinate, q)
            return tuple(value * scale % q for value in point)  # type: ignore[return-value]
    raise ValueError("zero projective point")


def determinant(rows: tuple[Point, Point, Point], q: int) -> int:
    (a, b, c), (d, e, f), (g, h, i) = rows
    return (
        a * (e * i - f * h)
        - b * (d * i - f * g)
        + c * (d * h - e * g)
    ) % q


def projective_line(q: int) -> tuple[int | None, ...]:
    return tuple(range(q)) + (None,)


def centres(q: int) -> tuple[Point, ...]:
    points = {
        normalize(point, q)
        for point in itertools.product(range(q), repeat=3)
        if point != (0, 0, 0)
    }
    return tuple(
        sorted(point for point in points if point[0] * point[2] % q != point[1] ** 2 % q)
    )


def sigma(center: Point, parameter: int | None, q: int) -> int | None:
    a, b, c = center
    if parameter is None:
        return None if c == 0 else b * inverse_mod(c, q) % q
    numerator = (b * parameter - a) % q
    denominator = (c * parameter - b) % q
    return None if denominator == 0 else numerator * inverse_mod(denominator, q) % q


def compose(left: Permutation, right: Permutation) -> Permutation:
    return tuple(left[right[index]] for index in range(len(left)))


def inverse_permutation(permutation: Permutation) -> Permutation:
    inverse = [0] * len(permutation)
    for source, target in enumerate(permutation):
        inverse[target] = source
    return tuple(inverse)


def generated_group(generators: tuple[Permutation, ...]) -> frozenset[Permutation]:
    identity = tuple(range(len(generators[0])))
    group = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            product = compose(generator, element)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return frozenset(group)


def permutation_order(permutation: Permutation) -> int:
    unseen = set(range(len(permutation)))
    order = 1
    while unseen:
        start = min(unseen)
        point = start
        length = 0
        while point in unseen:
            unseen.remove(point)
            point = permutation[point]
            length += 1
        order = order * length // math.gcd(order, length)
    return order


def pair_product_orders(generators: tuple[Permutation, ...]) -> tuple[int, int, int]:
    return tuple(
        sorted(
            permutation_order(compose(first, second))
            for first, second in itertools.combinations(generators, 2)
        )
    )  # type: ignore[return-value]


def determinant_class(center: Point, q: int) -> int:
    a, b, c = center
    value = (a * c - b * b) % q
    character = pow(value, (q - 1) // 2, q)
    assert character in (1, q - 1)
    return int(character == q - 1)


def conjugate(element: Permutation, generator: Permutation) -> Permutation:
    return compose(compose(element, generator), inverse_permutation(element))


def mixed_full_orbits(
    q: int,
    points: tuple[Point, ...],
    permutations: dict[Point, Permutation],
    group: frozenset[Permutation],
) -> tuple[tuple[tuple[Point, ...], int], ...]:
    full = {
        triple
        for triple in itertools.combinations(points, 3)
        if determinant(triple, q) != 0
        and len({determinant_class(point, q) for point in triple}) == 2
        and generated_group(tuple(permutations[point] for point in triple)) == group
    }
    permutation_to_point = {permutation: point for point, permutation in permutations.items()}
    remaining = set(full)
    orbits: list[tuple[tuple[Point, ...], int]] = []
    while remaining:
        seed = min(remaining)
        orbit = {
            tuple(
                sorted(
                    permutation_to_point[conjugate(element, permutations[point])]
                    for point in seed
                )
            )
            for element in group
        }
        assert orbit <= full
        representative = min(orbit)
        orbits.append((representative, len(orbit)))
        remaining -= orbit
    assert sum(size for _, size in orbits) == len(full)
    return tuple(sorted(orbits))


def cayley_graph(
    group: frozenset[Permutation], generators: tuple[Permutation, ...]
) -> tuple[tuple[Permutation, ...], Adjacency]:
    elements = tuple(sorted(group))
    index = {element: position for position, element in enumerate(elements)}
    adjacency = []
    for element in elements:
        mask = 0
        for generator in generators:
            mask |= 1 << index[compose(generator, element)]
        assert mask.bit_count() == 3
        adjacency.append(mask)
    result = tuple(adjacency)
    assert all((result[other] >> vertex) & 1 for vertex, mask in enumerate(result) for other in bits(mask))
    return elements, result


def bits(mask: int):
    while mask:
        bit = mask & -mask
        yield bit.bit_length() - 1
        mask ^= bit


def induced_graph(adjacency: Adjacency, mask: int) -> Adjacency:
    vertices = tuple(bits(mask))
    index = {old: new for new, old in enumerate(vertices)}
    return tuple(
        sum(1 << index[other] for other in vertices if (adjacency[old] >> other) & 1)
        for old in vertices
    )


def stable_colours(adjacency: Adjacency) -> tuple[int, ...]:
    colours = tuple(mask.bit_count() for mask in adjacency)
    while True:
        signatures = tuple(
            (colours[vertex], tuple(sorted(colours[other] for other in bits(mask))))
            for vertex, mask in enumerate(adjacency)
        )
        palette = {signature: colour for colour, signature in enumerate(sorted(set(signatures)))}
        refined = tuple(palette[signature] for signature in signatures)
        if refined == colours:
            return colours
        colours = refined


def pairing_witness(adjacency: Adjacency) -> Permutation | None:
    """Pair-oriented exact search for a nonadjacent fpf involutory automorphism."""
    size = len(adjacency)
    if size % 2:
        return None
    colours = stable_colours(adjacency)
    if any(count % 2 for count in Counter(colours).values()):
        return None
    pairing = [-1] * size

    def compatible(first: int, second: int) -> bool:
        if (
            first == second
            or colours[first] != colours[second]
            or (adjacency[first] >> second) & 1
        ):
            return False
        for source, target in enumerate(pairing):
            if target < 0:
                continue
            if ((adjacency[first] >> source) & 1) != ((adjacency[second] >> target) & 1):
                return False
            if ((adjacency[second] >> source) & 1) != ((adjacency[first] >> target) & 1):
                return False
        return True

    def search() -> bool:
        unpaired = tuple(vertex for vertex, image in enumerate(pairing) if image < 0)
        if not unpaired:
            return True
        choices = []
        for first in unpaired:
            partners = tuple(second for second in unpaired if compatible(first, second))
            choices.append((len(partners), first, partners))
        _, first, partners = min(choices)
        for second in partners:
            pairing[first] = second
            pairing[second] = first
            if search():
                return True
            pairing[first] = -1
            pairing[second] = -1
        return False

    if not search():
        return None
    witness = tuple(pairing)
    verify_pairing(adjacency, witness)
    return witness


def independent_pairing_witness(adjacency: Adjacency) -> Permutation | None:
    """Independent paired-image search using induced-subgraph preservation."""
    size = len(adjacency)
    if size % 2:
        return None
    colours = stable_colours(adjacency)
    if any(count % 2 for count in Counter(colours).values()):
        return None
    image = [-1] * size

    def compatible_pair(first: int, second: int) -> bool:
        if (
            first == second
            or image[second] >= 0
            or colours[first] != colours[second]
            or (adjacency[first] >> second) & 1
        ):
            return False
        image[first] = second
        image[second] = first
        assigned = tuple(vertex for vertex, target in enumerate(image) if target >= 0)
        compatible = all(
            ((adjacency[source] >> target) & 1)
            == ((adjacency[image[source]] >> image[target]) & 1)
            for source in assigned
            for target in assigned
        )
        image[first] = -1
        image[second] = -1
        return compatible

    def search() -> bool:
        unpaired = tuple(vertex for vertex, target in enumerate(image) if target < 0)
        if not unpaired:
            return True
        choices = []
        for first in unpaired:
            partners = tuple(second for second in unpaired if compatible_pair(first, second))
            choices.append((len(partners), -first, first, partners))
        _, _, first, partners = min(choices)
        for second in partners:
            image[first] = second
            image[second] = first
            if search():
                return True
            image[first] = -1
            image[second] = -1
        return False

    if not search():
        return None
    witness = tuple(image)
    verify_pairing(adjacency, witness)
    return witness


def verify_pairing(adjacency: Adjacency, witness: Permutation) -> None:
    size = len(adjacency)
    assert sorted(witness) == list(range(size))
    for vertex in range(size):
        mate = witness[vertex]
        assert mate != vertex
        assert witness[mate] == vertex
        assert not ((adjacency[vertex] >> mate) & 1)
        mapped_neighbours = {witness[other] for other in bits(adjacency[vertex])}
        assert mapped_neighbours == set(bits(adjacency[mate]))


@functools.cache
def grundy(adjacency: Adjacency, remaining: int) -> int:
    if not remaining:
        return 0
    options = {
        grundy(adjacency, remaining & ~(1 << vertex) & ~adjacency[vertex])
        for vertex in bits(remaining)
    }
    value = 0
    while value in options:
        value += 1
    return value


def encode_point(point: Point) -> list[int]:
    return list(point)


def audit_type(
    q: int,
    representative: tuple[Point, ...],
    orbit_size: int,
    group: frozenset[Permutation],
    permutations: dict[Point, Permutation],
) -> dict[str, object]:
    generators = tuple(permutations[point] for point in representative)
    elements, adjacency = cayley_graph(group, generators)
    identity = tuple(range(q + 1))
    identity_index = elements.index(identity)
    full = (1 << len(elements)) - 1
    closed = tuple(mask | (1 << vertex) for vertex, mask in enumerate(adjacency))
    follower = full & ~closed[identity_index]
    pairing_replies = 0
    degree_two_replies = 0
    reply_tests = 0
    first_reply: list[int] | None = None
    first_witness: list[int] | None = None
    grandchild_sizes: list[int] = []
    for reply in bits(follower):
        grandchild_mask = follower & ~closed[reply]
        grandchild = induced_graph(adjacency, grandchild_mask)
        grandchild_sizes.append(len(grandchild))
        primary = pairing_witness(grandchild)
        independent = independent_pairing_witness(grandchild)
        assert (primary is None) == (independent is None)
        if primary is not None:
            pairing_replies += 1
            if first_reply is None:
                first_reply = list(elements[reply])
                first_witness = list(primary)
        if max((mask.bit_count() for mask in grandchild), default=0) <= 2:
            degree_two_replies += 1
        reply_tests += 1
    result: dict[str, object] = {
        "determinant_classes": sorted(determinant_class(point, q) for point in representative),
        "degree_two_reply_count": degree_two_replies,
        "grandchild_vertex_range": [min(grandchild_sizes), max(grandchild_sizes)],
        "orbit_size": orbit_size,
        "pair_product_orders": list(pair_product_orders(generators)),
        "pairing_reply_count": pairing_replies,
        "reply_tests": reply_tests,
        "representative": [encode_point(point) for point in representative],
    }
    if first_reply is not None:
        result["first_pairing_reply"] = first_reply
        result["first_pairing_witness"] = first_witness
    if q == 3:
        grundy.cache_clear()
        result["grundy"] = grundy(adjacency, full)
    return result


def probe(q: int) -> dict[str, object]:
    parameters = projective_line(q)
    parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
    points = centres(q)
    permutations = {
        point: tuple(parameter_index[sigma(point, parameter, q)] for parameter in parameters)
        for point in points
    }
    group = generated_group(tuple(permutations.values()))
    assert len(group) == q * (q * q - 1)
    orbits = mixed_full_orbits(q, points, permutations, group)
    types = [
        audit_type(q, representative, orbit_size, group, permutations)
        for representative, orbit_size in orbits
    ]
    result: dict[str, object] = {
        "field_order": q,
        "group_order": len(group),
        "legal_mixed_full_triples": sum(int(item["orbit_size"]) for item in types),
        "mixed_full_conjugacy_types": len(types),
        "two_ply_pairing_types": sum(int(item["pairing_reply_count"]) > 0 for item in types),
        "two_ply_obstructed_types": sum(int(item["pairing_reply_count"]) == 0 for item in types),
        "types": types,
    }
    if q == 3:
        histogram = Counter()
        for item in types:
            histogram[int(item["grundy"])] += int(item["orbit_size"])
        result["grundy_histogram"] = {str(key): histogram[key] for key in sorted(histogram)}
    return result


def generate() -> dict[str, object]:
    return {
        "cases": [probe(3), probe(5)],
        "conventions": {
            "cayley": "left edges h--s*h; right translations are graph automorphisms",
            "determinant_class": "0=square/PSL2, 1=nonsquare/outside PSL2",
            "pairing": "fixed-point-free nonadjacent involutory abstract graph automorphism",
            "triple_scope": "noncollinear projection-involution triples generating full PGL2(q)",
        },
        "schema": "c294-mixed-scar-obstruction-v1",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    result = generate()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check is not None:
        expected = args.check.read_text()
        if encoded != expected:
            raise SystemExit(f"generated output differs from {args.check}")
    if args.output is not None:
        args.output.write_text(encoded)
    if args.output is None and args.check is None:
        print(encoded, end="")


if __name__ == "__main__":
    main()
