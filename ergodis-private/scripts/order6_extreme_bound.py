#!/usr/bin/env python3
"""Independent exact count bounds for the q174 extreme-count shell."""

import math
from collections import defaultdict

POSITIONS = 29 * 4
TARGET = 173


def cells(code: int) -> tuple[int, ...]:
    return tuple((code >> (2 * slot)) & 3 for slot in range(6))


def key(values: tuple[int, ...]) -> tuple[int, ...]:
    return (
        values[0] + values[1] + values[2],
        values[3] + values[4] + values[5],
        values[0] + values[3],
        values[1] + values[4],
        values[2] + values[5],
    )


fibres: dict[tuple[int, ...], list[tuple[int, ...]]] = defaultdict(list)
for code in range(1 << 12):
    value = cells(code)
    fibres[key(value)].append(value)

coefficientwise = [0] * 7
best_repeated = 0
best_key = None
for margin, fibre in fibres.items():
    polynomial = [0] * 7
    for value in fibre:
        polynomial[sum(entry in (0, 3) for entry in value)] += 1
    coefficientwise = [max(old, new) for old, new in zip(coefficientwise, polynomial)]
    current = [0] * (TARGET + 1)
    current[0] = 1
    for _ in range(POSITIONS):
        following = [0] * (TARGET + 1)
        for total, count in enumerate(current):
            for added, multiplicity in enumerate(polynomial):
                if total + added <= TARGET:
                    following[total + added] += count * multiplicity
        current = following
    if current[TARGET] > best_repeated:
        best_repeated = current[TARGET]
        best_key = margin

upper = [0] * (TARGET + 1)
upper[0] = 1
for _ in range(POSITIONS):
    following = [0] * (TARGET + 1)
    for total, count in enumerate(upper):
        for added, multiplicity in enumerate(coefficientwise):
            if total + added <= TARGET:
                following[total + added] += count * multiplicity
    upper = following

uniform_numerator = math.comb(6 * POSITIONS, TARGET) << (6 * POSITIONS)
uniform_denominator = len(fibres) ** POSITIONS
uniform_expected = uniform_numerator / uniform_denominator
print(
    "feasible_keys={} coefficientwise={} uniform_expected={:.9e} uniform_bits={:.9f} "
    "best_repeated_key={} best_repeated={} best_repeated_bits={} upper={} upper_bits={}".format(
        len(fibres),
        coefficientwise,
        uniform_expected,
        math.log2(uniform_expected),
        best_key,
        best_repeated,
        math.log2(best_repeated) if best_repeated else float("-inf"),
        upper[TARGET],
        math.log2(upper[TARGET]) if upper[TARGET] else float("-inf"),
    )
)
