#!/usr/bin/env python3
"""Independent syndrome-DP replay for the C708 finite code tables."""

from __future__ import annotations

from itertools import combinations


DUADS = tuple(combinations(range(6), 2))
PARTITIONS = tuple(frozenset(q) for q in combinations(range(6), 3) if 0 in q)


def matchings(remaining=frozenset(range(6))):
    if not remaining:
        return ((),)
    first = min(remaining)
    answer = []
    for second in sorted(remaining - {first}):
        for tail in matchings(remaining - {first, second}):
            answer.append(((first, second),) + tail)
    return tuple(answer)


MATCHINGS = matchings()


def rref(matrix, prime):
    work = [[x % prime for x in row] for row in matrix]
    row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next((i for i in range(row, len(work)) if work[i][column]), None)
        if pivot is None:
            continue
        work[row], work[pivot] = work[pivot], work[row]
        scale = pow(work[row][column], -1, prime)
        work[row] = [scale * x % prime for x in work[row]]
        for i in range(len(work)):
            if i != row and work[i][column]:
                scale = work[i][column]
                work[i] = [
                    (work[i][j] - scale * work[row][j]) % prime
                    for j in range(len(work[0]))
                ]
        pivots.append(column)
        row += 1
    return work[:row], pivots


def parity_check(generator, prime):
    reduced, pivots = rref(generator, prime)
    free = [j for j in range(len(generator[0])) if j not in pivots]
    result = []
    for column in free:
        word = [0] * len(generator[0])
        word[column] = 1
        for i, pivot in enumerate(pivots):
            word[pivot] = -reduced[i][column] % prime
        result.append(word)
    return result


def syndrome_enumerator(generator, prime):
    check = parity_check(generator, prime)
    zero = (0,) * len(check)
    states = {(zero, 0): 1}
    for column in range(len(generator[0])):
        updated = {}
        contribution = tuple(row[column] for row in check)
        for (syndrome, weight), count in states.items():
            for value in range(prime):
                target = tuple(
                    (syndrome[i] + value * contribution[i]) % prime
                    for i in range(len(check))
                )
                key = (target, weight + (value != 0))
                updated[key] = updated.get(key, 0) + count
        states = updated
    return tuple(states.get((zero, weight), 0) for weight in range(16))


def main():
    context_point = [
        [int(duad in matching) for duad in DUADS] for matching in MATCHINGS
    ]
    grid_point = [
        [int((a in q) != (b in q)) for a, b in DUADS] for q in PARTITIONS
    ]
    grid_context = [
        [
            int(all((a in q) != (b in q) for a, b in matching))
            for matching in MATCHINGS
        ]
        for q in PARTITIONS
    ]
    matrices = (context_point, grid_point, grid_context)
    expected = {
        2: ((10, 3), (5, 5), (5, 6)),
        3: ((10, 3), (9, 4), (10, 3)),
        5: ((10, 3), (10, 3), (10, 3)),
    }
    for prime in (2, 3, 5):
        for matrix, (dimension, distance) in zip(matrices, expected[prime]):
            generator, _ = rref(matrix, prime)
            enumerator = syndrome_enumerator(generator, prime)
            assert len(generator) == dimension
            assert next(i for i, count in enumerate(enumerator) if i and count) == distance
            assert sum(enumerator) == prime**dimension
    print("C708 independent syndrome-DP replay: PASS")


if __name__ == "__main__":
    main()
