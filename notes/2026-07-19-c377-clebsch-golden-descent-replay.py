#!/usr/bin/env python3
"""Independent finite/symbolic replay of the C377 certificate."""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path

CERTIFICATE = Path(__file__).with_name("2026-07-19-c377-clebsch-golden-descent.json")
Pair = tuple[int, int]
Vector = tuple[Pair, Pair, Pair]


def add(x: Pair, y: Pair) -> Pair:
    return x[0] + y[0], x[1] + y[1]


def neg(x: Pair) -> Pair:
    return -x[0], -x[1]


def mul(x: Pair, y: Pair) -> Pair:
    return x[0] * y[0] + x[1] * y[1], x[0] * y[1] + x[1] * y[0] + x[1] * y[1]


def sigma(x: Pair) -> Pair:
    return x[0] + x[1], -x[1]


def total(values) -> Pair:
    answer = (0, 0)
    for value in values:
        answer = add(answer, value)
    return answer


def matrix_vector(matrix, vector: Vector) -> Vector:
    return tuple(total(mul(matrix[i][j], vector[j]) for j in range(3)) for i in range(3))  # type: ignore[return-value]


def determinant(columns: list[Vector]) -> Pair:
    matrix = tuple(tuple(columns[j][i] for j in range(3)) for i in range(3))
    return add(
        add(
            mul(matrix[0][0], add(mul(matrix[1][1], matrix[2][2]), neg(mul(matrix[1][2], matrix[2][1])))),
            neg(mul(matrix[0][1], add(mul(matrix[1][0], matrix[2][2]), neg(mul(matrix[1][2], matrix[2][0]))))),
        ),
        mul(matrix[0][2], add(mul(matrix[1][0], matrix[2][1]), neg(mul(matrix[1][1], matrix[2][0])))),
    )


def symbolic_replay(certificate):
    z, o, t = (0, 0), (1, 0), (0, 1)
    s = add(o, neg(t))
    points: list[Vector] = [
        (z, o, s), (z, o, neg(s)), (o, s, z),
        (o, neg(s), z), (o, z, neg(t)), (o, z, t),
    ]
    conjugates = [tuple(sigma(value) for value in point) for point in points]
    matrix = ((o, z, z), (z, z, neg(o)), (z, neg(o), z))
    permutation = (1, 0, 4, 5, 2, 3)
    scales = (add(t, neg(o)), s, o, o, o, o)
    for index, point in enumerate(points):
        target = tuple(mul(scales[index], value) for value in conjugates[permutation[index]])
        assert matrix_vector(matrix, point) == target
    squared = tuple(
        tuple(total(mul(sigma(matrix[i][k]), matrix[k][j]) for k in range(3)) for j in range(3))
        for i in range(3)
    )
    assert squared == ((o, z, z), (z, o, z), (z, z, o))
    ledger = certificate["pluecker"]["ledger"]
    assert len(ledger) == 20
    for row in ledger:
        triple = tuple(row["source"])
        target = tuple(row["target"])
        assert list(determinant([points[i] for i in triple])) == row["source_minor"]
        assert list(determinant([conjugates[i] for i in target])) == row["target_minor"]


def inv(value: int, q: int) -> int:
    assert value % q
    return pow(value % q, q - 2, q)


def normalize(vector, q: int):
    reduced = tuple(value % q for value in vector)
    scale = inv(next(value for value in reduced if value), q)
    return tuple(value * scale % q for value in reduced)


def mat_vec(matrix, vector, q: int):
    return tuple(sum(matrix[i][j] * vector[j] for j in range(3)) % q for i in range(3))


def mat_mul(left, right, q: int):
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(3)) % q for j in range(3))
        for i in range(3)
    )


def mat_inverse(matrix, q: int):
    work = [list(row) + [int(i == j) for j in range(3)] for i, row in enumerate(matrix)]
    for column in range(3):
        choice = next(row for row in range(column, 3) if work[row][column] % q)
        work[column], work[choice] = work[choice], work[column]
        scale = inv(work[column][column], q)
        work[column] = [value * scale % q for value in work[column]]
        for row in range(3):
            if row != column:
                factor = work[row][column]
                work[row] = [(a - factor * b) % q for a, b in zip(work[row], work[column])]
    return tuple(tuple(row[3:]) for row in work)


def frame(points, q: int):
    basis = tuple(tuple(points[j][i] for j in range(3)) for i in range(3))
    coordinates = mat_vec(mat_inverse(basis, q), points[3], q)
    return tuple(tuple(basis[i][j] * coordinates[j] % q for j in range(3)) for i in range(3))


def six(q: int, tau: int):
    return [normalize(point, q) for point in [
        (0, 1, 1 - tau), (0, 1, tau - 1), (1, 1 - tau, 0),
        (1, tau - 1, 0), (1, 0, -tau), (1, 0, tau),
    ]]


def equivalence_permutations(source, target, q: int):
    source_inverse = mat_inverse(frame(source[:4], q), q)
    passing = set()
    for permutation in itertools.permutations(range(6)):
        matrix = mat_mul(frame([target[permutation[i]] for i in range(4)], q), source_inverse, q)
        if all(normalize(mat_vec(matrix, source[i], q), q) == target[permutation[i]] for i in range(6)):
            passing.add(permutation)
    return passing


def parity(permutation) -> int:
    return sum(permutation[i] > permutation[j] for i in range(6) for j in range(i + 1, 6)) % 2


def cycle_type(permutation) -> str:
    unseen = set(range(6)); lengths = []
    while unseen:
        point = min(unseen); length = 0
        while point in unseen:
            unseen.remove(point); length += 1; point = permutation[point]
        lengths.append(length)
    return ".".join(map(str, sorted(lengths, reverse=True)))


def finite_replay(certificate):
    tau8, tau4, tau3 = six(11, 8), six(11, 4), six(5, 3)
    same = equivalence_permutations(tau8, tau8, 11)
    cross = equivalence_permutations(tau8, tau4, 11)
    ramified = equivalence_permutations(tau3, tau3, 5)
    assert len(same) == len(cross) == 60 and len(ramified) == 120
    assert {parity(p) for p in same} == {0} and {parity(p) for p in cross} == {1}
    histogram = dict(sorted(Counter(cycle_type(p) for p in cross).items()))
    assert histogram == certificate["exact_projective_equivalences"]["cross_cycle_types"]
    assert all((x * x + y * y + z * z) % 5 == 0 for x, y, z in tau3)


def line_replay(certificate):
    names = [f"E{i}" for i in range(6)] + [f"L{i}{j}" for i, j in itertools.combinations(range(6), 2)] + [f"Q{i}" for i in range(6)]
    def meet(left, right):
        if left == right: return False
        if left[0] == "E" and right[0] != "E": return meet(right, left)
        if left[0] == "Q" and right[0] == "E": return int(left[1]) != int(right[1])
        if left[0] == "L" and right[0] == "E": return int(right[1]) in {int(left[1]), int(left[2])}
        if left[0] == "L" and right[0] == "Q": return int(right[1]) in {int(left[1]), int(left[2])}
        if left[0] == "Q" and right[0] == "L": return meet(right, left)
        if left[0] == right[0] == "L": return not ({int(left[1]), int(left[2])} & {int(right[1]), int(right[2])})
        return False
    assert sum(meet(a, b) for a, b in itertools.combinations(names, 2)) == 135
    assert certificate["double_six"]["line_count"] == 27
    assert certificate["double_six"]["rows_exchanged"] is False


if __name__ == "__main__":
    payload = json.loads(CERTIFICATE.read_text())
    assert payload["schema"] == "c377-clebsch-golden-descent-v1"
    symbolic_replay(payload)
    finite_replay(payload)
    line_replay(payload)
    print("C377 independent replay passed")
