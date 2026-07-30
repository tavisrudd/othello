#!/usr/bin/env python3
"""Independent modular replay for the exceptional C682 Schur blocks."""

import importlib.util
import json
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIMARY_PATH = HERE / "2026-07-30-c682-exceptional-monotone-schur.py"
REPLAY_PATH = (
    HERE / "2026-07-29-c682-monotone-entrance-propagation-replay.py"
)
OPERATORS = HERE / "2026-07-29-c682-monotone-weyl-operators.json"
PRIMES = (1_000_000_007, 1_000_000_009)
TYPES = (("4", 6), ("4s", 3), ("5", 4), ("6", 5))


def load(path, name):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


PRIMARY = load(PRIMARY_PATH, "exceptional_schur_primary")
REPLAY = load(REPLAY_PATH, "exceptional_schur_replay_base")
PHASE = REPLAY.PHASE_REPLAY


def reduce_fraction(value, prime):
    value = Fraction(value)
    return (
        value.numerator
        * pow(value.denominator % prime, prime - 2, prime)
    ) % prime


def modular_schur(label, degree, operators, prime):
    lower, current, incoming = PHASE.operator_matrix(
        label, degree - 6, 3, operators, prime
    )
    current_2, upper, outgoing = PHASE.operator_matrix(
        label, degree, 3, operators, prime
    )
    upper_2, current_3, ninth = PHASE.operator_matrix(
        label, degree + 6, 9, operators, prime
    )
    assert current == current_2 == current_3
    assert upper == upper_2
    lower_levels = [row[2] // 3 for row in lower]
    current_levels = [row[2] // 3 for row in current]
    lower_names = list(dict.fromkeys(name for name, *_ in lower))
    current_names = list(dict.fromkeys(name for name, *_ in current))
    lower_name_index = {name: index for index, name in enumerate(lower_names)}
    current_name_index = {
        name: index for index, name in enumerate(current_names)
    }
    lower_order = sorted(
        range(len(lower)),
        key=lambda index: (
            lower_levels[index],
            lower_name_index[lower[index][0]],
        ),
    )
    current_order = sorted(
        range(len(current)),
        key=lambda index: (
            current_levels[index],
            current_name_index[current[index][0]],
        ),
    )
    counts = {
        level: lower_levels.count(level) for level in set(lower_levels)
    }
    block_size = max(counts.values())
    last_full = max(
        level for level, count in counts.items() if count == block_size
    )
    pivot_indices = [
        index
        for index in lower_order
        if 1 <= lower_levels[index] <= last_full
    ]
    residual_indices = [
        index
        for index in lower_order
        if lower_levels[index] == 0 or lower_levels[index] > last_full
    ]
    head = [
        index
        for index in current_order
        if current_levels[index] < last_full
    ]
    tail = [
        index
        for index in current_order
        if current_levels[index] >= last_full
    ]
    endpoint = lower_order[-1]
    returned = PHASE.matvec(
        ninth,
        PHASE.matvec(outgoing, incoming[endpoint], prime),
        prime,
    )
    columns = [
        incoming[index][:] for index in pivot_indices + residual_indices
    ] + [returned]
    available = list(range(len(pivot_indices)))
    residual = list(
        range(len(pivot_indices), len(pivot_indices) + len(residual_indices))
    )
    for row in head:
        pivot = next(index for index in available if columns[index][row])
        available.remove(pivot)
        inverse = pow(columns[pivot][row], prime - 2, prime)
        for index in available + residual + [len(columns) - 1]:
            multiplier = columns[index][row] * inverse % prime
            if not multiplier:
                continue
            columns[index] = [
                (left - multiplier * right) % prime
                for left, right in zip(columns[index], columns[pivot])
            ]
    assert not available
    reduced = [
        [columns[index][row] for row in tail]
        for index in residual + [len(columns) - 1]
    ]
    return PHASE.determinant(reduced, prime)


def main():
    operators = json.loads(OPERATORS.read_text(encoding="utf-8"))
    for prime in PRIMES:
        for label, _ in TYPES:
            for order in (3, 9):
                operator = operators[label][str(order)]
                for generator_index, source_name in enumerate(
                    operator["generator_names"]
                ):
                    assert REPLAY.GLOBAL_REPLAY.direct_transition(
                        label,
                        order,
                        order + 4,
                        order + 3,
                        generator_index,
                        prime,
                    ) == REPLAY.GLOBAL_REPLAY.predicted_transition(
                        operator,
                        source_name,
                        order + 4,
                        order + 3,
                        prime,
                    )
        for label, residue in TYPES:
            for r in (13, 14, 15):
                degree = residue + 20 * r
                direct = modular_schur(label, degree, operators, prime)
                exact = PRIMARY.mod20_block_schur(
                    label, degree, operators
                )["determinant"]
                assert direct
                assert direct == reduce_fraction(exact, prime)
    print("PASS: independent exceptional monotone Schur replay")


if __name__ == "__main__":
    main()
