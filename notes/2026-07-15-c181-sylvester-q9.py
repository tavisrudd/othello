#!/usr/bin/env python3
"""Exact q=9 certificate for the Sylvester-graph exclusion in C181.

This dependency-free checker constructs F_9 = F_3[i]/(i^2+1), PG(2,9),
the conic XZ-Y^2=0 and its polarity.  On the 36 internal points it builds
the conjugacy graph H, P~Q iff Q lies on P^perp, and verifies:

* H has intersection array {5,4,2;1,1,4};
* two internal points have passant join iff they are at H-distance two;
* the exact-distance-two graph has clique number five.

The last assertion uses a complete bitset Bron--Kerbosch search, not a
precomputed graph or a third-party graph library.
"""

from __future__ import annotations

from collections import deque
from itertools import combinations


Q = 9


def digits(x: int) -> tuple[int, int]:
    """Decode x as a+b*i, with a,b in F_3 and i^2=-1=2."""
    return x % 3, x // 3


def encode(a: int, b: int) -> int:
    return (a % 3) + 3 * (b % 3)


def add(x: int, y: int) -> int:
    a, b = digits(x)
    c, d = digits(y)
    return encode(a + c, b + d)


def neg(x: int) -> int:
    a, b = digits(x)
    return encode(-a, -b)


def sub(x: int, y: int) -> int:
    return add(x, neg(y))


def mul(x: int, y: int) -> int:
    a, b = digits(x)
    c, d = digits(y)
    return encode(a * c + 2 * b * d, a * d + b * c)


def inv(x: int) -> int:
    assert x != 0
    return next(y for y in range(1, Q) if mul(x, y) == 1)


def scale(x: int, y: int) -> int:
    return mul(x, inv(y))


Point = tuple[int, int, int]


def normalize(point: Point) -> Point:
    pivot = next(x for x in point if x != 0)
    return tuple(scale(x, pivot) for x in point)  # type: ignore[return-value]


def projective_points() -> list[Point]:
    points = (
        [(1, y, z) for y in range(Q) for z in range(Q)]
        + [(0, 1, z) for z in range(Q)]
        + [(0, 0, 1)]
    )
    assert len(points) == Q * Q + Q + 1 == 91
    assert len(set(points)) == len(points)
    return points


def quadratic(point: Point) -> int:
    x, y, z = point
    return sub(mul(x, z), mul(y, y))


def polar_pair(left: Point, right: Point) -> int:
    """Polar form of XZ-Y^2; in characteristic 3, -2=1."""
    x, y, z = left
    X, Y, Z = right
    return add(add(mul(x, Z), mul(z, X)), mul(y, Y))


def line_coefficients(left: Point, right: Point) -> Point:
    x, y, z = left
    X, Y, Z = right
    return (
        sub(mul(y, Z), mul(z, Y)),
        sub(mul(z, X), mul(x, Z)),
        sub(mul(x, Y), mul(y, X)),
    )


def line_pole(left: Point, right: Point) -> Point:
    """The pole of ax+by+cz=0 is (c,b,a) for this polar form."""
    a, b, c = line_coefficients(left, right)
    return normalize((c, b, a))


NONZERO_SQUARES = {mul(x, x) for x in range(1, Q)}


def is_internal(point: Point) -> bool:
    value = quadratic(point)
    return value != 0 and value not in NONZERO_SQUARES


def all_distances(neighbors: list[int], start: int) -> list[int]:
    distance = [-1] * len(neighbors)
    distance[start] = 0
    queue = deque([start])
    while queue:
        vertex = queue.popleft()
        unseen = neighbors[vertex]
        while unseen:
            bit = unseen & -unseen
            unseen ^= bit
            nxt = bit.bit_length() - 1
            if distance[nxt] == -1:
                distance[nxt] = distance[vertex] + 1
                queue.append(nxt)
    return distance


def maximum_clique(neighbors: list[int]) -> tuple[list[int], int]:
    """Complete Bron--Kerbosch search with a cardinality bound."""
    best: list[int] = []
    calls = 0

    def search(clique: list[int], candidates: int) -> None:
        nonlocal best, calls
        calls += 1
        if len(clique) + candidates.bit_count() <= len(best):
            return
        if not candidates:
            best = clique.copy()
            return

        # A deterministic high-degree-first branch order reduces the tree but
        # does not alter exhaustiveness: every candidate is included once and
        # then removed before the next branch.
        ordered = []
        remaining = candidates
        while remaining:
            bit = remaining & -remaining
            remaining ^= bit
            vertex = bit.bit_length() - 1
            ordered.append((-(neighbors[vertex] & candidates).bit_count(), vertex))
        for _, vertex in sorted(ordered):
            bit = 1 << vertex
            if not candidates & bit:
                continue
            search(clique + [vertex], candidates & neighbors[vertex])
            candidates ^= bit
            if len(clique) + candidates.bit_count() <= len(best):
                return

    search([], (1 << len(neighbors)) - 1)
    return best, calls


def fmt(point: Point) -> str:
    return "(" + ",".join(f"{a}+{b}i" for a, b in map(digits, point)) + ")"


def main() -> None:
    # Freeze the field model before doing geometry.
    assert NONZERO_SQUARES == {1, 2, 3, 6}
    assert all(add(x, 0) == x and mul(x, 1) == x for x in range(Q))
    assert all(mul(x, inv(x)) == 1 for x in range(1, Q))

    points = projective_points()
    conic = [point for point in points if quadratic(point) == 0]
    internal = [point for point in points if is_internal(point)]
    assert len(conic) == Q + 1 == 10
    assert len(internal) == Q * (Q - 1) // 2 == 36

    # H is the polarity-conjugacy graph on internal points.
    h_neighbors = [0] * len(internal)
    for left, right in combinations(range(len(internal)), 2):
        if polar_pair(internal[left], internal[right]) == 0:
            h_neighbors[left] |= 1 << right
            h_neighbors[right] |= 1 << left
    assert {mask.bit_count() for mask in h_neighbors} == {5}

    distances = [all_distances(h_neighbors, vertex) for vertex in range(36)]
    assert all(-1 not in row and max(row) == 3 for row in distances)
    assert {
        tuple(row.count(distance) for distance in range(4)) for row in distances
    } == {(1, 5, 20, 10)}

    # Verify the full intersection array, not just one base vertex.
    intersection_profiles: dict[int, set[tuple[int, int, int]]] = {
        distance: set() for distance in range(4)
    }
    for base in range(36):
        for vertex in range(36):
            distance = distances[base][vertex]
            counts = [0, 0, 0]
            adjacent = h_neighbors[vertex]
            while adjacent:
                bit = adjacent & -adjacent
                adjacent ^= bit
                neighbor = bit.bit_length() - 1
                delta = distances[base][neighbor] - distance
                assert delta in (-1, 0, 1)
                counts[delta + 1] += 1
            intersection_profiles[distance].add(tuple(counts))
    assert intersection_profiles == {
        0: {(0, 0, 5)},
        1: {(1, 0, 4)},
        2: {(1, 2, 2)},
        3: {(4, 1, 0)},
    }

    # Polarity sends an internal point to a passant line.  Check directly,
    # for every pair, that this is precisely the distance-two relation in H.
    distance_two_neighbors = [0] * 36
    passant_pairs = 0
    for left, right in combinations(range(36), 2):
        passant = is_internal(line_pole(internal[left], internal[right]))
        at_distance_two = distances[left][right] == 2
        assert passant == at_distance_two
        if at_distance_two:
            passant_pairs += 1
            distance_two_neighbors[left] |= 1 << right
            distance_two_neighbors[right] |= 1 << left
    assert passant_pairs == 36 * 20 // 2 == 360
    assert {mask.bit_count() for mask in distance_two_neighbors} == {20}

    clique, calls = maximum_clique(distance_two_neighbors)
    assert len(clique) == 5
    assert all(
        (distance_two_neighbors[left] >> right) & 1
        for left, right in combinations(clique, 2)
    )

    print("field=F3[i]/(i^2+1) projective_points=91 conic_points=10")
    print("internal_points=36 H_degree=5 distance_layers=(1,5,20,10)")
    print("intersection_array={5,4,2;1,1,4}")
    print("passant_joins=360 passant_iff_H_distance_2=PASS")
    print(
        "distance_2_clique_number=5 "
        f"search_calls={calls} witness="
        + "[" + ",".join(fmt(internal[index]) for index in clique) + "]"
    )
    print("C181_SYLVESTER_Q9_PASS")


if __name__ == "__main__":
    main()
