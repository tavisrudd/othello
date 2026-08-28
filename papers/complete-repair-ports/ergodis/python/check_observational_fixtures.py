#!/usr/bin/env python3
"""Independent exact oracle for the finite observational compiler fixtures."""

from __future__ import annotations

import json
from collections import Counter, deque
from itertools import combinations_with_replacement, product
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "tests" / "fixtures" / "observational_compilation.json"
LIMIT = 4
INF = 5
WEIGHTS = (
    ((0, 1, 1), (1, 0, 1), (2, 0, 2), (2, 2, 1)),
    ((0, 1, 0), (1, 0, 2)),
    ((0, 2, 2), (1, 1, 0), (1, 2, 0), (2, 1, 2), (2, 2, 2)),
)


def sat(*values: int) -> int:
    total = sum(values)
    return INF if total > LIMIT else total


def wta_product(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(
        min(sat(left[lhs], right[rhs], weight) for lhs, rhs, weight in rules)
        for rules in WEIGHTS
    )


def wta_observe(value: tuple[int, ...]) -> int:
    return min(sat(entry, final) for entry, final in zip(value, (1, 1, 3)))


def refine(
    sorts: list[list[object]],
    observations: list[list[int]],
    generators: list[list[tuple[int, int, int]]],
) -> tuple[list[list[int]], int]:
    classes: list[list[int]] = []
    next_class = 0
    for states, outputs in zip(sorts, observations):
        labels: dict[tuple[int, ...], int] = {}
        local = []
        for output in outputs:
            labels.setdefault((output,), next_class + len(labels))
            local.append(labels[(output,)])
        next_class += len(labels)
        classes.append(local)
    rounds = 0
    while True:
        next_classes: list[list[int]] = []
        next_class = 0
        for sort, (states, outputs) in enumerate(zip(sorts, observations)):
            labels = {}
            local = []
            outgoing = [entry for entry in generators if entry[0][0] == sort]
            for state, output in enumerate(outputs):
                signature = [output, classes[sort][state]]
                for records in outgoing:
                    _, target_sort, target = records[state]
                    signature.append(classes[target_sort][target])
                key = tuple(signature)
                labels.setdefault(key, next_class + len(labels))
                local.append(labels[key])
            next_class += len(labels)
            next_classes.append(local)
        if next_classes == classes:
            return classes, rounds
        classes = next_classes
        rounds += 1


def shortest_separator_stats(
    observations: list[list[int]],
    generators: list[list[tuple[int, int, int]]],
    classes: list[list[int]],
) -> tuple[int, int]:
    certificates = 0
    steps = 0
    for sort, outputs in enumerate(observations):
        outgoing = [entry for entry in generators if entry[0][0] == sort]
        for left in range(len(outputs)):
            for right in range(left + 1, len(outputs)):
                if classes[sort][left] == classes[sort][right]:
                    continue
                certificates += 1
                queue = deque([(sort, left, right, 0)])
                seen = {(sort, left, right)}
                while queue:
                    current_sort, lhs, rhs, depth = queue.popleft()
                    if observations[current_sort][lhs] != observations[current_sort][rhs]:
                        steps += depth
                        break
                    for records in generators:
                        if records[0][0] != current_sort:
                            continue
                        _, target_sort, next_lhs = records[lhs]
                        _, _, next_rhs = records[rhs]
                        key = (target_sort, next_lhs, next_rhs)
                        if key not in seen:
                            seen.add(key)
                            queue.append((*key, depth + 1))
    return certificates, steps


def wta_oracle() -> dict[str, object]:
    closure = {(3, INF, 1), (1, 3, 0), (3, 3, 4)}
    while True:
        old = sorted(closure)
        closure.update(wta_product(left, right) for left in old for right in old)
        if len(old) == len(closure):
            break
    states = sorted(closure)
    ids = {state: index for index, state in enumerate(states)}
    generators = []
    for coargument in states:
        generators.append(
            [(0, 0, ids[wta_product(state, coargument)]) for state in states]
        )
        generators.append(
            [(0, 0, ids[wta_product(coargument, state)]) for state in states]
        )
    observations = [[wta_observe(state) for state in states]]
    classes, rounds = refine([states], observations, generators)
    sizes = sorted(Counter(classes[0]).values(), reverse=True)
    separators, separator_steps = shortest_separator_stats(observations, generators, classes)
    left = ids[(1, 3, 0)]
    right = ids[(1, 4, 2)]
    generator = 2 * left
    named = [
        observations[0][generators[generator][left][2]],
        observations[0][generators[generator][right][2]],
    ]
    return {
        "carrier": len(states),
        "observation_fibres": len(set(observations[0])),
        "quotient": len(set(classes[0])),
        "class_sizes": sizes,
        "refinement_rounds": rounds,
        "separators": separators,
        "separator_steps": separator_steps,
        "named_separator_outputs": named,
    }


PROFILES = list(combinations_with_replacement(range(5), 3))
PROFILE_IDS = {profile: index for index, profile in enumerate(PROFILES)}


def resource_step(subset: int, job: int) -> int:
    result = 0
    for index, profile in enumerate(PROFILES):
        if not subset & (1 << index):
            continue
        for slot in range(3):
            if profile[slot] + job <= LIMIT:
                successor = list(profile)
                successor[slot] += job
                result |= 1 << PROFILE_IDS[tuple(sorted(successor))]
    return result


def resource_observe(subset: int) -> int:
    values = [profile[-1] for index, profile in enumerate(PROFILES) if subset & (1 << index)]
    return min(values, default=INF)


def assignment(profile: tuple[int, ...], jobs: tuple[int, ...]):
    if not jobs:
        return profile[-1], []
    candidates = []
    for slot in range(3):
        if profile[slot] + jobs[0] > LIMIT:
            continue
        successor = list(profile)
        successor[slot] += jobs[0]
        tail = assignment(tuple(sorted(successor)), jobs[1:])
        if tail is not None:
            candidates.append((tail[0], [slot, *tail[1]]))
    return min(candidates, default=None)


def resource_oracle() -> dict[str, object]:
    sorts = [[1 << index for index in range(len(PROFILES))]]
    for _ in range(2):
        sorts.append(sorted({resource_step(state, job) for state in sorts[-1] for job in (1, 2)}))
    ids = [{state: index for index, state in enumerate(states)} for states in sorts]
    generators = []
    for depth in range(2):
        for job in (1, 2):
            generators.append(
                [
                    (depth, depth + 1, ids[depth + 1][resource_step(state, job)])
                    for state in sorts[depth]
                ]
            )
    observations = [[resource_observe(state) for state in states] for states in sorts]
    classes, rounds = refine(sorts, observations, generators)
    separators, separator_steps = shortest_separator_stats(observations, generators, classes)
    cases = [
        ((0, 0, 0), (2, 2)),
        ((0, 1, 3), (2, 1)),
        ((2, 3, 4), (1, 2)),
        ((0, 3, 3), (2, 2)),
        ((4, 4, 4), (1,)),
    ]
    witnesses = []
    for profile, jobs in cases:
        answer = assignment(profile, jobs)
        witnesses.append(
            {
                "profile": list(profile),
                "jobs": list(jobs),
                "cost": INF if answer is None else answer[0],
                "slots": None if answer is None else answer[1],
            }
        )
    return {
        "carrier_by_sort": [len(states) for states in sorts],
        "quotient_by_sort": [len(set(partition)) for partition in classes],
        "refinement_rounds": rounds,
        "separators": separators,
        "separator_steps": separator_steps,
        "witnesses": witnesses,
    }


RECOVERY_COLUMNS = ((1, 0), (0, 1), (1, 1))


def recovery_solution(state: int) -> tuple[int, list[int], list[int], list[int]]:
    demand = tuple((state >> bit) & 1 for bit in range(4))
    for support_mask in sorted(range(8), key=lambda mask: (mask.bit_count(), mask)):
        support = [helper for helper in range(3) if support_mask & (1 << helper)]
        for coefficient_bits in range(1 << (2 * len(support))):
            coefficients = [
                (coefficient_bits >> bit) & 1 for bit in range(2 * len(support))
            ]
            if any(
                not any(coefficients[2 * index : 2 * index + 2])
                for index in range(len(support))
            ):
                continue
            rebuilt = []
            for row in range(2):
                for column in range(2):
                    value = 0
                    for index, helper in enumerate(support):
                        value ^= RECOVERY_COLUMNS[helper][row] * coefficients[2 * index + column]
                    rebuilt.append(value)
            if tuple(rebuilt) == demand:
                loads = [int(helper in support) for helper in range(3)]
                return len(support), support, coefficients, loads
    raise AssertionError("every triangle-gauge demand must be recoverable")


def recovery_oracle() -> dict[str, object]:
    observations = [[recovery_solution(state)[0] for state in range(16)]]
    generators = [
        [(0, 0, state & mask) for state in range(16)] for mask in (0b0101, 0b1010)
    ]
    classes, rounds = refine([list(range(16))], observations, generators)
    separators, separator_steps = shortest_separator_stats(observations, generators, classes)
    witnesses = []
    for state in (0, 3, 12, 15, 9):
        cost, support, coefficients, loads = recovery_solution(state)
        witnesses.append(
            {
                "state": state,
                "cost": cost,
                "support": support,
                "coefficients": coefficients,
                "helper_loads": loads,
            }
        )
    return {
        "carrier": 16,
        "observation_fibres": len(set(observations[0])),
        "quotient": len(set(classes[0])),
        "class_sizes": sorted(Counter(classes[0]).values(), reverse=True),
        "refinement_rounds": rounds,
        "separators": separators,
        "separator_steps": separator_steps,
        "witnesses": witnesses,
    }


HIERARCHY_CONTEXTS = ((1, 0), (0, 1), (1, 1))


def hierarchy_step(profile: tuple[int, ...], context: int) -> tuple[int, ...]:
    ordinary = profile[:2]
    target = profile[2:]
    left, right = HIERARCHY_CONTEXTS[context]

    def compose(first, second, output):
        return min(
            first[x] + second[y]
            for x in range(2)
            for y in range(2)
            if (left * x) ^ (right * y) == output
        )

    return tuple(compose(ordinary, ordinary, output) for output in range(2)) + tuple(
        compose(target, ordinary, output) for output in range(2)
    )


def hierarchy_oracle() -> dict[str, object]:
    sorts = [
        sorted((0, ordinary, zero_sector, 0) for ordinary in range(1, 4) for zero_sector in range(1, 4))
    ]
    for _ in range(2):
        sorts.append(
            sorted(
                {
                    hierarchy_step(profile, context)
                    for profile in sorts[-1]
                    for context in range(3)
                }
            )
        )
    ids = [{profile: index for index, profile in enumerate(sort)} for sort in sorts]
    generators = []
    for depth in range(2):
        for context in range(3):
            generators.append(
                [
                    (depth, depth + 1, ids[depth + 1][hierarchy_step(profile, context)])
                    for profile in sorts[depth]
                ]
            )
    observations = [[profile[3] for profile in sort] for sort in sorts]
    classes, rounds = refine(sorts, observations, generators)
    separators, separator_steps = shortest_separator_stats(observations, generators, classes)
    cases = [
        ((0, 1, 1, 0), ()),
        ((0, 2, 3, 0), (0,)),
        ((0, 2, 3, 0), (1,)),
        ((0, 2, 3, 0), (2,)),
        ((0, 3, 2, 0), (2, 2)),
        ((0, 1, 3, 0), (0, 1)),
    ]
    response_cases = []
    for seed, contexts in cases:
        profile = seed
        for context in contexts:
            profile = hierarchy_step(profile, context)
        response_cases.append(
            {
                "seed": list(seed),
                "contexts": list(contexts),
                "profile": list(profile),
                "observation": profile[3],
            }
        )
    return {
        "carrier_by_sort": [len(sort) for sort in sorts],
        "quotient_by_sort": [len(set(partition)) for partition in classes],
        "refinement_rounds": rounds,
        "separators": separators,
        "separator_steps": separator_steps,
        "response_cases": response_cases,
    }


def main() -> None:
    expected = {
        "schema": "ergodis-observational-v2",
        "wta": wta_oracle(),
        "resource": resource_oracle(),
        "recovery": recovery_oracle(),
        "hierarchy": hierarchy_oracle(),
    }
    actual = json.loads(FIXTURE.read_text())
    if actual != expected:
        raise SystemExit("observational fixture is stale")
    print("observational fixture matches independent exact oracle")


if __name__ == "__main__":
    main()
