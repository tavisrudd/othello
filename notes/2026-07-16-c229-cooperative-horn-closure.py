#!/usr/bin/env python3
"""Independent finite checks for C229's cooperative/Horn-closure claims."""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path


P = 5
RADIUS = 2
NAMES = ("a", "b", "c", "x", "y", "w")
COLUMNS = (
    (1, 0, 0),
    (0, 1, 0),
    (0, 0, 1),
    (1, 1, 0),
    (1, 1, 1),
    (1, 2, 3),
)


def subsets(items: tuple[int, ...]):
    for size in range(len(items) + 1):
        yield from itertools.combinations(items, size)


def rank(indices: tuple[int, ...] | frozenset[int]) -> int:
    rows = [[COLUMNS[j][i] % P for j in indices] for i in range(3)]
    ncols = len(indices)
    pivot_row = 0
    for col in range(ncols):
        pivot = next((row for row in range(pivot_row, 3) if rows[row][col]), None)
        if pivot is None:
            continue
        rows[pivot_row], rows[pivot] = rows[pivot], rows[pivot_row]
        inv = pow(rows[pivot_row][col], -1, P)
        rows[pivot_row] = [(inv * value) % P for value in rows[pivot_row]]
        for row in range(3):
            if row == pivot_row or rows[row][col] == 0:
                continue
            factor = rows[row][col]
            rows[row] = [
                (left - factor * right) % P
                for left, right in zip(rows[row], rows[pivot_row])
            ]
        pivot_row += 1
        if pivot_row == 3:
            break
    return pivot_row


def spans(helper_set: frozenset[int], target: int) -> bool:
    return rank(helper_set | {target}) == rank(helper_set)


def matroid_closure(seed: frozenset[int]) -> frozenset[int]:
    return frozenset(i for i in range(len(NAMES)) if spans(seed, i))


def one_shot(seed: frozenset[int], radius: int) -> frozenset[int]:
    result = set(seed)
    ordered = tuple(sorted(seed))
    for target in range(len(NAMES)):
        if target in seed:
            continue
        if any(
            spans(frozenset(helper_set), target)
            for size in range(radius + 1)
            for helper_set in itertools.combinations(ordered, size)
        ):
            result.add(target)
    return frozenset(result)


def sequential_closure(seed: frozenset[int], radius: int) -> frozenset[int]:
    result = seed
    while True:
        enlarged = one_shot(result, radius)
        if enlarged == result:
            return result
        result = enlarged


def all_circuits() -> tuple[frozenset[int], ...]:
    circuits = []
    ground = tuple(range(len(NAMES)))
    for candidate_tuple in subsets(ground):
        candidate = frozenset(candidate_tuple)
        if not candidate or rank(candidate) == len(candidate):
            continue
        if all(rank(candidate - {element}) == len(candidate) - 1 for element in candidate):
            circuits.append(candidate)
    return tuple(circuits)


CIRCUITS = all_circuits()


def horn_closure(seed: frozenset[int], max_circuit_size: int | None) -> frozenset[int]:
    result = set(seed)
    while True:
        old_size = len(result)
        for circuit in CIRCUITS:
            if max_circuit_size is not None and len(circuit) > max_circuit_size:
                continue
            missing = circuit - result
            if len(missing) == 1:
                result.update(missing)
        if len(result) == old_size:
            return frozenset(result)


def minimal_helpers(target: int, universe: frozenset[int]) -> tuple[frozenset[int], ...]:
    result: list[frozenset[int]] = []
    for helper_tuple in subsets(tuple(sorted(universe))):
        helper_set = frozenset(helper_tuple)
        if spans(helper_set, target) and not any(old <= helper_set for old in result):
            result.append(helper_set)
    return tuple(result)


def minimal_joint_helpers(
    targets: frozenset[int], universe: frozenset[int]
) -> tuple[frozenset[int], ...]:
    result: list[frozenset[int]] = []
    for helper_tuple in subsets(tuple(sorted(universe))):
        helper_set = frozenset(helper_tuple)
        if all(spans(helper_set, target) for target in targets) and not any(
            old <= helper_set for old in result
        ):
            result.append(helper_set)
    return tuple(result)


def minimal_unions(
    targets: frozenset[int], universe: frozenset[int]
) -> tuple[frozenset[int], ...]:
    families = [minimal_helpers(target, universe) for target in sorted(targets)]
    if any(not family for family in families):
        return ()
    candidates = sorted(
        {frozenset().union(*choice) for choice in itertools.product(*families)},
        key=lambda value: (len(value), tuple(sorted(value))),
    )
    return tuple(
        candidate
        for candidate in candidates
        if not any(other < candidate for other in candidates)
    )


def named(items: frozenset[int]) -> list[str]:
    return [NAMES[index] for index in sorted(items)]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).with_suffix(".json"),
    )
    args = parser.parse_args()

    ground = frozenset(range(len(NAMES)))
    closure_checks = 0
    joint_checks = 0
    for seed_tuple in subsets(tuple(range(len(NAMES)))):
        seed = frozenset(seed_tuple)
        full = matroid_closure(seed)
        assert horn_closure(seed, None) == full
        assert one_shot(seed, len(NAMES)) == full
        assert horn_closure(seed, RADIUS + 1) == sequential_closure(seed, RADIUS)
        assert one_shot(seed, RADIUS) <= sequential_closure(seed, RADIUS) <= full
        closure_checks += 1

    for target_tuple in subsets(tuple(range(len(NAMES)))):
        targets = frozenset(target_tuple)
        if not targets:
            continue
        universe = ground - targets
        direct = set(minimal_joint_helpers(targets, universe))
        predicted = set(minimal_unions(targets, universe))
        assert direct == predicted
        for helper_tuple in subsets(tuple(sorted(universe))):
            helpers = frozenset(helper_tuple)
            joint = targets <= matroid_closure(helpers)
            conjunction = all(target in matroid_closure(helpers) for target in targets)
            assert joint == conjunction
            joint_checks += 1

    seed = frozenset(NAMES.index(name) for name in ("a", "b", "c"))
    parallel = one_shot(seed, RADIUS)
    sequential = sequential_closure(seed, RADIUS)
    full = matroid_closure(seed)
    assert named(parallel) == ["a", "b", "c", "x"]
    assert named(sequential) == ["a", "b", "c", "x", "y"]
    assert named(full) == ["a", "b", "c", "x", "y", "w"]

    certificate = {
        "task": "C229",
        "field": "GF(5)",
        "radius": RADIUS,
        "columns": {name: list(column) for name, column in zip(NAMES, COLUMNS)},
        "rank": rank(ground),
        "circuits": [named(circuit) for circuit in CIRCUITS],
        "seed": named(seed),
        "one_shot_radius_2": named(parallel),
        "sequential_radius_2": named(sequential),
        "full_span": named(full),
        "strict_hierarchy": parallel < sequential < full,
        "exhaustive_checks": {
            "seed_sets": closure_checks,
            "joint_target_helper_pairs": joint_checks,
            "full_circuit_horn_equals_matroid_closure": True,
            "unbounded_repair_closes_in_one_round": True,
            "small_circuit_horn_equals_sequential_closure": True,
            "joint_minimal_helpers_equal_minimal_unions": True,
        },
    }
    args.output.write_text(json.dumps(certificate, indent=2) + "\n")
    print(json.dumps(certificate, indent=2))


if __name__ == "__main__":
    main()
