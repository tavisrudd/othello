#!/usr/bin/env python3

import argparse
import itertools
import math
from collections import Counter, defaultdict

from three_centre_probe import (
    centres,
    conic_point,
    determinant,
    generated_group,
    grundy,
    projective_line,
    residual_graph,
    sigma,
)


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


def permutation_order(permutation):
    seen = [False] * len(permutation)
    order = 1
    for start in range(len(permutation)):
        if seen[start]:
            continue
        vertex = start
        length = 0
        while not seen[vertex]:
            seen[vertex] = True
            vertex = permutation[vertex]
            length += 1
        order = math.lcm(order, length)
    return order


def pair_orders(generators):
    return tuple(
        sorted(
            permutation_order(compose(left, right))
            for left, right in itertools.combinations(generators, 2)
        )
    )


def find_s4(points, permutations):
    patterns = {(3, 3, 3), (3, 4, 4), (2, 3, 3), (2, 3, 4)}
    for triple in itertools.combinations(points, 3):
        generators = tuple(permutations[point] for point in triple)
        if pair_orders(generators) not in patterns:
            continue
        group = generated_group(generators)
        if len(group) == 24:
            return group
    raise RuntimeError("no S4 subgroup found")


def residual_value(selected, parameters, conic, q):
    dead, adjacency, _ = residual_graph(selected, parameters, conic, q)
    value = grundy(adjacency, (1 << len(adjacency)) - 1)
    return len(dead), value


def probe(q):
    parameters = projective_line(q)
    conic = tuple(conic_point(t, q) for t in parameters)
    points = centres(q)
    permutations = {
        point: tuple(parameters.index(sigma(point, t, q)) for t in parameters)
        for point in points
    }
    point_for_permutation = {permutation: point for point, permutation in permutations.items()}
    group = find_s4(points, permutations)
    identity = tuple(range(q + 1))
    involutions = tuple(
        element
        for element in group
        if element != identity and compose(element, element) == identity
    )
    subgroup_points = {point_for_permutation[element] for element in involutions}
    labels = {(3, 3, 3): "A", (3, 4, 4): "B", (2, 3, 3): "C", (2, 3, 4): "D"}
    representatives = {}
    for triple in itertools.combinations(involutions, 3):
        if len(generated_group(triple)) != 24:
            continue
        representatives.setdefault(labels[pair_orders(triple)], tuple(point_for_permutation[x] for x in triple))

    print(f"q={q}")
    for label in "ABCD":
        selected = representatives[label]
        internal = 0
        escape = 0
        generated_orders = Counter()
        escape_values = Counter()
        signature_values = defaultdict(set)
        for candidate in points:
            if candidate in selected:
                continue
            if any(
                determinant((left, right, candidate), q) == 0
                for left, right in itertools.combinations(selected, 2)
            ):
                continue
            generators = tuple(permutations[point] for point in (*selected, candidate))
            if candidate in subgroup_points:
                internal += 1
                continue
            escape += 1
            generated_orders[len(generated_group(generators))] += 1
            _, value = residual_value((*selected, candidate), parameters, conic, q)
            escape_values[value] += 1
            signature = tuple(
                sorted(
                    permutation_order(compose(permutations[candidate], permutations[point]))
                    for point in selected
                )
            )
            signature_values[signature].add(value)
        ambiguous_signatures = sum(len(values) > 1 for values in signature_values.values())
        print(
            f"  {label}: internal={internal} escape={escape} "
            f"generated_orders={dict(sorted(generated_orders.items()))} "
            f"escape_grundy={dict(sorted(escape_values.items()))} "
            f"order_signatures={len(signature_values)} ambiguous={ambiguous_signatures}"
        )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("q", type=int, nargs="+", help="odd primes")
    args = parser.parse_args()
    for q in args.q:
        if q < 3 or any(q % divisor == 0 for divisor in range(2, int(q**0.5) + 1)):
            parser.error(f"{q} is not prime")
        probe(q)


if __name__ == "__main__":
    main()
