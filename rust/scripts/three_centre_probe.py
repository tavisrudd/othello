#!/usr/bin/env python3

import argparse
import functools
import itertools
from collections import Counter


INF = None


def inv(a, q):
    return pow(a % q, q - 2, q)


def normalize(point, q):
    for coordinate in point:
        if coordinate % q:
            scale = inv(coordinate, q)
            return tuple(value * scale % q for value in point)
    raise ValueError("zero projective point")


def determinant(rows, q):
    (a, b, c), (d, e, f), (g, h, i) = rows
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % q


def projective_line(q):
    return tuple(range(q)) + (INF,)


def conic_point(t, q):
    return (1, 0, 0) if t is INF else (t * t % q, t, 1)


def centres(q):
    points = {
        normalize(point, q)
        for point in itertools.product(range(q), repeat=3)
        if point != (0, 0, 0)
    }
    return tuple(sorted(point for point in points if point[0] * point[2] % q != point[1] ** 2 % q))


def sigma(center, t, q):
    a, b, c = center
    if t is INF:
        return INF if c == 0 else b * inv(c, q) % q
    numerator = (b * t - a) % q
    denominator = (c * t - b) % q
    return INF if denominator == 0 else numerator * inv(denominator, q) % q


def selected_triple_is_legal(triple, q):
    return determinant(triple, q) != 0


def dead_vertices(triple, parameters, conic, q):
    return {
        i
        for x, y in itertools.combinations(triple, 2)
        for i, point in enumerate(conic)
        if determinant((x, y, point), q) == 0
    }


def residual_graph(triple, parameters, conic, q):
    dead = dead_vertices(triple, parameters, conic, q)
    live = tuple(i for i in range(len(parameters)) if i not in dead)
    index = {old: new for new, old in enumerate(live)}
    parameter_index = {t: i for i, t in enumerate(parameters)}
    edges = {}
    for colour, center in enumerate(triple):
        for old_i in live:
            old_j = parameter_index[sigma(center, parameters[old_i], q)]
            if old_i == old_j or old_j not in index:
                continue
            edge = tuple(sorted((index[old_i], index[old_j])))
            edges.setdefault(edge, set()).add(colour)
    parallel = {edge: colours for edge, colours in edges.items() if len(colours) > 1}
    if parallel:
        raise AssertionError((triple, dead, parallel))
    adjacency = [0] * len(live)
    coloured_edges = []
    for (u, v), colour in edges.items():
        adjacency[u] |= 1 << v
        adjacency[v] |= 1 << u
        coloured_edges.append((u, v, next(iter(colour))))
    return dead, tuple(adjacency), tuple(coloured_edges)


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


def component_sizes(adjacency):
    unseen = (1 << len(adjacency)) - 1
    sizes = []
    while unseen:
        frontier = unseen & -unseen
        component = 0
        while frontier:
            component |= frontier
            unseen &= ~frontier
            neighbours = 0
            bits = frontier
            while bits:
                bit = bits & -bits
                neighbours |= adjacency[bit.bit_length() - 1]
                bits ^= bit
            frontier = neighbours & unseen
        sizes.append(component.bit_count())
    return tuple(sorted(sizes))


def triangle_count(adjacency):
    return sum(
        1
        for u in range(len(adjacency))
        for v in range(u + 1, len(adjacency))
        for w in range(v + 1, len(adjacency))
        if adjacency[u] >> v & 1 and adjacency[v] >> w & 1 and adjacency[w] >> u & 1
    )


def compose(left, right):
    return tuple(left[right[i]] for i in range(len(left)))


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


def probe(q, include_group_orders=False):
    parameters = projective_line(q)
    conic = tuple(conic_point(t, q) for t in parameters)
    external = centres(q)
    distributions = {
        "dead": Counter(),
        "degree_sequence": Counter(),
        "components": Counter(),
        "triangles": Counter(),
        "grundy": Counter(),
    }
    permutations = {
        center: tuple(parameters.index(sigma(center, t, q)) for t in parameters)
        for center in external
    }
    generated_subgroups = Counter()
    legal = 0
    for triple in itertools.combinations(external, 3):
        if not selected_triple_is_legal(triple, q):
            continue
        legal += 1
        dead, adjacency, _ = residual_graph(triple, parameters, conic, q)
        distributions["dead"][len(dead)] += 1
        distributions["degree_sequence"][tuple(sorted(mask.bit_count() for mask in adjacency))] += 1
        distributions["components"][component_sizes(adjacency)] += 1
        distributions["triangles"][triangle_count(adjacency)] += 1
        distributions["grundy"][grundy(adjacency, (1 << len(adjacency)) - 1)] += 1
        if include_group_orders:
            generated_subgroups[generated_group(tuple(permutations[x] for x in triple))] += 1
    print(f"q={q} centres={len(external)} legal_triples={legal}")
    for name, distribution in distributions.items():
        print(name)
        for value, count in sorted(distribution.items(), key=lambda item: repr(item[0])):
            print(f"  {value}: {count}")
    if include_group_orders:
        profiles = Counter((len(group), multiplicity) for group, multiplicity in generated_subgroups.items())
        print("generated_group (order, triples_per_subgroup): subgroup_count")
        for profile, count in sorted(profiles.items()):
            print(f"  {profile}: {count}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("q", type=int, nargs="+", help="odd primes")
    parser.add_argument("--group-orders", action="store_true")
    args = parser.parse_args()
    for q in args.q:
        if q < 3 or any(q % divisor == 0 for divisor in range(2, int(q**0.5) + 1)):
            parser.error(f"{q} is not prime")
        probe(q, args.group_orders)


if __name__ == "__main__":
    main()
