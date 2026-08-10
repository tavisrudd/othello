#!/usr/bin/env python3
"""Exact small cap/autoconvolution probe for C905.

This script writes nothing.  It exhausts caps in F_3^2 and the four-caps in
F_3^3, groups them by their labelled missing-third profile, and checks the
canonical reflection and moment claims recorded in the C905 report.
"""

from collections import Counter, defaultdict
from itertools import combinations, product


def add(*xs):
    return tuple(sum(v[i] for v in xs) % 3 for i in range(len(xs[0])))


def neg(x):
    return tuple(-a % 3 for a in x)


def is_cap(points):
    zero = (0,) * len(points[0]) if points else ()
    return not any(add(x, y, z) == zero for x, y, z in combinations(points, 3))


def profile(points, universe_index):
    out = [0] * len(universe_index)
    for x, y in combinations(points, 2):
        out[universe_index[neg(add(x, y))]] += 1
    return tuple(out)


def moment(points, degree):
    n = len(points[0])
    exponents = [e for e in product(range(degree + 1), repeat=n) if sum(e) == degree]
    return tuple(
        sum(
            product_value(x, exponent)
            for x in points
        ) % 3
        for exponent in exponents
    )


def product_value(x, exponent):
    value = 1
    for coordinate, power in zip(x, exponent):
        value = value * pow(coordinate, power, 3) % 3
    return value


def reflected_mate(points):
    total = tuple(sum(x[i] for x in points) % 3 for i in range(len(points[0])))
    return tuple(sorted(tuple((-total[i] - x[i]) % 3 for i in range(len(total))) for x in points))


def check_plane():
    universe = list(product(range(3), repeat=2))
    index = {x: i for i, x in enumerate(universe)}
    rows = []
    for size in (2, 3, 4):
        fibres = defaultdict(list)
        for choice in combinations(universe, size):
            if is_cap(choice):
                fibres[profile(choice, index)].append(choice)
        histogram = Counter(map(len, fibres.values()))
        rows.append((size, sum(histogram.values()), sorted(histogram.items())))
    assert rows == [
        (2, 9, [(4, 9)]),
        (3, 72, [(1, 72)]),
        (4, 54, [(1, 54)]),
    ]
    return rows


def check_space_four_caps():
    universe = list(product(range(3), repeat=3))
    index = {x: i for i, x in enumerate(universe)}
    fibres = defaultdict(list)
    for choice in combinations(universe, 4):
        if is_cap(choice):
            fibres[profile(choice, index)].append(tuple(sorted(choice)))

    histogram = Counter(map(len, fibres.values()))
    assert histogram == Counter({2: 6318, 1: 2106})
    assert sum(len(fibre) for fibre in fibres.values()) == 14742

    for fibre in fibres.values():
        if len(fibre) == 1:
            assert reflected_mate(fibre[0]) == fibre[0]
            continue
        assert len(fibre) == 2
        left, right = fibre
        assert reflected_mate(left) == right
        assert reflected_mate(right) == left
        assert moment(left, 1) == moment(right, 1)
        assert moment(left, 2) == moment(right, 2)
        assert moment(left, 3) != moment(right, 3)

    return sorted(histogram.items())


def main():
    plane = check_plane()
    space = check_space_four_caps()
    print("F3^2 size/profile-fibre histograms:", plane)
    print("F3^3 four-cap profile-fibre histogram:", space)
    print("PASS")


if __name__ == "__main__":
    main()
