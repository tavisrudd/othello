#!/usr/bin/env python3
"""Independent replay for the C418 seven-point witness."""

from __future__ import annotations

import json
from collections import Counter, defaultdict
from itertools import combinations, product
from pathlib import Path

P = 7
Vector = tuple[int, int, int]
CERT = Path(__file__).with_name("2026-07-20-c418-c419-c410-successors.json")


def norm(v: Vector) -> Vector:
    k = next(i for i, x in enumerate(v) if x % P)
    z = pow(v[k], -1, P)
    return tuple(z * x % P for x in v)  # type: ignore[return-value]


GEOMETRY = tuple(sorted({norm(v) for v in product(range(P), repeat=3) if any(v)}))


def inner(a: Vector, b: Vector) -> int:
    return sum(x * y for x, y in zip(a, b)) % P


def meet(a: Vector, b: Vector) -> Vector:
    return norm(
        (
            a[1] * b[2] - a[2] * b[1],
            a[2] * b[0] - a[0] * b[2],
            a[0] * b[1] - a[1] * b[0],
        )
    )


LINE_POINTS = {
    line: frozenset(point for point in GEOMETRY if inner(line, point) == 0)
    for line in GEOMETRY
}


def row_rank(matrix: list[list[int]]) -> int:
    a = [[x % P for x in row] for row in matrix]
    r = 0
    for c in range(len(a[0]) if a else 0):
        pivot = next((i for i in range(r, len(a)) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        a[r] = [x * pow(a[r][c], -1, P) % P for x in a[r]]
        for i, row in enumerate(a):
            if i != r and row[c]:
                z = row[c]
                a[i] = [(x - z * y) % P for x, y in zip(row, a[r])]
        r += 1
    return r


def support_ranks(
    legs: tuple[tuple[tuple[int, ...], ...], tuple[tuple[int, ...], ...]], width: int
) -> tuple[list[int], int, int]:
    parts = []
    for leg in legs:
        inv = pow(len(leg), -1, P)
        mean = [sum(j in block for block in leg) * inv % P for j in range(width)]
        parts.append(
            [[(int(j in block) - mean[j]) % P for j in range(width)] for block in leg]
        )
    rows = parts[0] + parts[1]
    moment = [
        [sum(row[i] * row[j] for row in rows) % P for j in range(width)]
        for i in range(width)
    ]
    return [row_rank(part) for part in parts], row_rank(rows), row_rank(moment)


def external_lines(points: frozenset[Vector]) -> tuple[Vector, ...]:
    return tuple(line for line in GEOMETRY if LINE_POINTS[line].isdisjoint(points))


def singular_data(lines: tuple[Vector, ...]) -> dict[Vector, tuple[int, ...]]:
    answer = {}
    for point in GEOMETRY:
        indices = tuple(i for i, line in enumerate(lines) if inner(line, point) == 0)
        if len(indices) >= 2:
            answer[point] = indices
    return answer


def global_invariant(points: frozenset[Vector]) -> tuple[object, ...]:
    lines = external_lines(points)
    singular = singular_data(lines)
    s = sum(len(indices) - 1 for indices in singular.values())
    characteristic = (len(lines) - 1 - s, s, -len(lines), 1)
    adjoint = tuple(sorted(singular))
    weights = tuple(len(singular[line]) - 1 for line in adjoint)
    intersections: dict[Vector, set[int]] = defaultdict(set)
    for i, j in combinations(range(len(adjoint)), 2):
        point = meet(adjoint[i], adjoint[j])
        intersections[point].update((i, j))
    incident = [set() for _ in adjoint]
    for point, indices in intersections.items():
        for i in indices:
            incident[i].add(point)
    coeffs: dict[int, list[int]] = {
        0: [
            1,
            1 - len(adjoint),
            1 - len(adjoint) + sum(len(indices) - 1 for indices in intersections.values()),
        ]
    }
    for i, weight in enumerate(weights):
        coeffs.setdefault(weight, [0, 0, 0])
        coeffs[weight][1] += 1
        coeffs[weight][2] += 1 - len(incident[i])
    correction = Counter()
    for indices in intersections.values():
        depth = sum(weights[i] for i in indices)
        correction[depth] += 1
        coeffs.setdefault(depth, [0, 0, 0])
        coeffs[depth][2] += 1
    direct = Counter(
        sum(weight for line, weight in zip(adjoint, weights) if inner(line, point) == 0)
        for point in GEOMETRY
    )
    evaluated = Counter(
        {depth: P * P * poly[0] + P * poly[1] + poly[2] for depth, poly in coeffs.items()}
    )
    assert direct == evaluated
    return (
        characteristic,
        tuple((d, tuple(v)) for d, v in sorted(coeffs.items()) if any(v)),
        tuple(sorted(correction.items())),
    )


def pointed_invariant(points: frozenset[Vector]) -> tuple[object, ...]:
    sizes = {line: len(points & LINE_POINTS[line]) for line in GEOMETRY}
    coordinate = []
    syndrome = []
    for point in GEOMETRY:
        through = [line for line in GEOMETRY if point in LINE_POINTS[line]]
        if point in points:
            coordinate.append(
                (
                    sum((sizes[line] - 1) * (sizes[line] - 2) // 2 for line in through),
                    sum((sizes[line] - 1) // 2 for line in through),
                )
            )
        else:
            syndrome.append(
                sum(sizes[line] * (sizes[line] - 1) // 2 for line in through)
            )
    return tuple(sorted(coordinate)), tuple(sorted(syndrome))


def triple_degrees(points: frozenset[Vector]) -> list[int]:
    triples = [points & LINE_POINTS[line] for line in GEOMETRY if len(points & LINE_POINTS[line]) == 3]
    return sorted(sum(point in triple for triple in triples) for point in points)


def moments(left: tuple[int, ...], right: tuple[int, ...]) -> list[int]:
    difference = Counter(left)
    difference.subtract(right)
    return [sum(count * value**j for value, count in difference.items()) for j in range(4)]


def secant_loads(points: frozenset[Vector]) -> dict[Vector, int]:
    sizes = {line: len(points & LINE_POINTS[line]) for line in GEOMETRY}
    return {
        point: sum(
            sizes[line] * (sizes[line] - 1) // 2
            for line in GEOMETRY
            if point in LINE_POINTS[line]
        )
        for point in GEOMETRY
    }


def concurrence_three(points: frozenset[Vector]) -> int:
    multiplicity = {
        line: len(points & LINE_POINTS[line]) * (len(points & LINE_POINTS[line]) - 1) // 2
        for line in GEOMETRY
    }
    return sum(
        sum(
            multiplicity[a] * multiplicity[b] * multiplicity[c]
            for a, b, c in combinations(
                [line for line in GEOMETRY if point in LINE_POINTS[line]], 3
            )
        )
        for point in GEOMETRY
    )


def scan(base: tuple[Vector, ...]) -> list[tuple[frozenset[Vector], object, object]]:
    base_set = frozenset(base)
    return [
        (base_set | {point}, global_invariant(base_set | {point}), pointed_invariant(base_set | {point}))
        for point in GEOMETRY
        if point not in base_set
    ]


def summary(records: list[tuple[frozenset[Vector], object, object]]) -> tuple[int, int, int, int]:
    fibres: dict[object, list[object]] = defaultdict(list)
    for _, u, pointed in records:
        fibres[u].append(pointed)
    return (
        len(records),
        len(fibres),
        max(map(len, fibres.values())),
        sum(len(set(values)) > 1 for values in fibres.values()),
    )


def main() -> None:
    pasch_plus = ((0, 1, 2), (0, 3, 4), (1, 3, 5), (2, 4, 5))
    pasch_minus = ((0, 1, 3), (0, 2, 4), (1, 2, 5), (3, 4, 5))
    endpoint_plus = ((0, 1, 4), (2, 3, 5))
    endpoint_minus = ((0, 2, 4), (1, 3, 5))
    switch_plus = ((0, 2), (1, 3))
    switch_minus = ((0, 3), (1, 2))
    assert support_ranks((pasch_plus, pasch_minus), 6) == ([3, 3], 3, 3)
    assert support_ranks((endpoint_plus, endpoint_minus), 6) == ([1, 1], 2, 2)
    assert support_ranks((switch_plus, switch_minus), 4) == ([1, 1], 2, 2)
    core_legs = (
        tuple(block + (6,) for block in pasch_plus),
        tuple(block + (6,) for block in pasch_minus),
    )
    assert support_ranks(core_legs, 7) == ([3, 3], 3, 3)

    frame_lines = ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))
    pasch_base = tuple(meet(frame_lines[i], frame_lines[j]) for i, j in combinations(range(4), 2))
    disjoint = (
        (1, 0, 0),
        (1, 1, 0),
        (1, 2, 0),
        (1, 3, 1),
        (1, 4, 1),
        (1, 5, 1),
    )
    shared = (
        (1, 0, 0),
        (1, 1, 0),
        (1, 2, 0),
        (1, 0, 1),
        (1, 0, 2),
        (1, 1, 2),
    )
    pasch_records = scan(pasch_base)
    disjoint_records = scan(disjoint)
    shared_records = scan(shared)
    assert summary(pasch_records) == (51, 6, 12, 0)
    assert summary(disjoint_records) == (51, 11, 8, 0)
    assert summary(disjoint_records + shared_records) == (102, 27, 14, 4)

    left = frozenset(
        {
            (0, 1, 2),
            (1, 0, 0),
            (1, 1, 0),
            (1, 2, 0),
            (1, 3, 1),
            (1, 4, 1),
            (1, 5, 1),
        }
    )
    right = frozenset(
        {
            (1, 0, 0),
            (1, 0, 1),
            (1, 0, 2),
            (1, 1, 0),
            (1, 1, 2),
            (1, 2, 0),
            (1, 3, 6),
        }
    )
    assert global_invariant(left) == global_invariant(right)
    left_pointed = pointed_invariant(left)
    right_pointed = pointed_invariant(right)
    assert left_pointed != right_pointed
    assert triple_degrees(left) == [1, 1, 2, 2, 2, 2, 2]
    assert triple_degrees(right) == [1, 1, 1, 2, 2, 2, 3]
    assert moments(tuple(x[0] for x in left_pointed[0]), tuple(x[0] for x in right_pointed[0])) == [
        0,
        0,
        -2,
        -12,
    ]
    assert moments(left_pointed[1], right_pointed[1]) == [0, 0, 2, 36]
    left_loads = secant_loads(left)
    right_loads = secant_loads(right)
    assert moments(tuple(left_loads.values()), tuple(right_loads.values())) == [0, 0, 0, -12]
    assert sorted(left_loads[p] for p in left) == sorted(6 + r for r, _ in left_pointed[0])
    assert sorted(right_loads[p] for p in right) == sorted(6 + r for r, _ in right_pointed[0])
    assert sorted(left_loads[p] for p in GEOMETRY if p not in left) == list(left_pointed[1])
    assert sorted(right_loads[p] for p in GEOMETRY if p not in right) == list(right_pointed[1])
    assert concurrence_three(left) == 166
    assert concurrence_three(right) == 168
    assert 6 * (concurrence_three(left) - concurrence_three(right)) == -12
    assert len(external_lines(left)) == len(external_lines(right)) == 18
    certificate = json.loads(CERT.read_text())
    assert certificate["kernel_witness"]["left"]["points"] == [list(x) for x in sorted(left)]
    assert certificate["kernel_witness"]["right"]["points"] == [list(x) for x in sorted(right)]
    print(
        json.dumps(
            {
                "status": "ok",
                "pasch_candidates": 51,
                "common_core_candidates": 102,
                "witness_U_equal": True,
                "witness_P_equal": False,
            },
            sort_keys=True,
            separators=(",", ":"),
        )
    )


if __name__ == "__main__":
    main()
