#!/usr/bin/env python3
"""Independent verifier for C232's fixed-radius, fixed-width relay family.

The centre component F_n is represented over GF(2) by

    p=e_0, q=e_n, x_i=e_i, s_i=e_{i-1}+e_i.

Its private seed is {s_1,...,s_n}.  A parallel-pair leaf supplies p at cost
one and another parallel-pair leaf turns the q-message into a terminal target.
At radius two, the resulting synchronous arrival layers are

    x_1, x_2, ..., x_{n-1}, y.

This script checks the representation, the complete three-element circuit
inventory, the local multi-interface recurrence, and the direct glued closure.
"""

from __future__ import annotations

import argparse
import itertools
import json


RADIUS = 2
INFINITY = RADIUS + 1


def family(n: int) -> dict[str, int]:
    if n < 1:
        raise ValueError("n must be positive")
    columns = {"p": 1, "q": 1 << n}
    columns.update({f"x{i}": 1 << i for i in range(1, n)})
    columns.update(
        {f"s{i}": (1 << (i - 1)) ^ (1 << i) for i in range(1, n + 1)}
    )
    return columns


def small_circuits(columns: dict[str, int]) -> tuple[frozenset[str], ...]:
    """Enumerate every circuit of cardinality at most three."""
    def column_xor(subset: tuple[str, ...]) -> int:
        value = 0
        for label in subset:
            value ^= columns[label]
        return value

    labels = tuple(columns)
    result = []
    for size in range(1, 4):
        for subset in itertools.combinations(labels, size):
            if column_xor(subset) != 0:
                continue
            if all(
                column_xor(proper) != 0
                for smaller in range(1, size)
                for proper in itertools.combinations(subset, smaller)
            ):
                result.append(frozenset(subset))
    return tuple(result)


def expected_triangles(n: int) -> set[frozenset[str]]:
    def endpoint(i: int) -> str:
        if i == 0:
            return "p"
        if i == n:
            return "q"
        return f"x{i}"

    return {
        frozenset((endpoint(i - 1), f"s{i}", endpoint(i)))
        for i in range(1, n + 1)
    }


def local_step(
    private: set[str],
    active: set[str],
    circuits: tuple[frozenset[str], ...],
    incoming: dict[str, int],
) -> set[str]:
    additions = set()
    boundary = set(incoming)
    for target in private - active:
        for circuit in circuits:
            if target not in circuit:
                continue
            private_helpers = (circuit - boundary) - {target}
            if not private_helpers <= active:
                continue
            cost = len(private_helpers) + sum(
                incoming[p] for p in circuit & boundary
            )
            if cost <= RADIUS:
                additions.add(target)
                break
    return active | additions


def outgoing_cost(
    target_boundary: str,
    active: set[str],
    circuits: tuple[frozenset[str], ...],
    other_incoming: dict[str, int],
) -> int:
    boundary = set(other_incoming) | {target_boundary}
    best = INFINITY
    for circuit in circuits:
        if target_boundary not in circuit:
            continue
        private_helpers = circuit - boundary
        if not private_helpers <= active:
            continue
        cost = len(private_helpers) + sum(
            other_incoming[p] for p in circuit & set(other_incoming)
        )
        best = min(best, cost)
    return min(best, INFINITY)


def direct_step(
    ground: set[str], active: set[str], circuits: tuple[frozenset[str], ...]
) -> set[str]:
    additions = {
        target
        for target in ground - active
        if any(
            target in circuit
            and len(circuit) - 1 <= RADIUS
            and circuit - {target} <= active
            for circuit in circuits
        )
    }
    return active | additions


def verify(n: int) -> dict[str, object]:
    columns = family(n)
    assert 0 not in columns.values()
    assert len(set(columns.values())) == len(columns)
    circuits = small_circuits(columns)
    assert set(circuits) == expected_triangles(n)
    assert any("p" in circuit for circuit in circuits)
    assert any("q" in circuit for circuit in circuits)

    private = set(columns) - {"p", "q"}
    active = {f"s{i}" for i in range(1, n + 1)}
    incoming = {"p": 1, "q": INFINITY}
    local_layers = []
    q_trace = []
    while True:
        q_trace.append(outgoing_cost("q", active, circuits, {"p": 1}))
        enlarged = local_step(private, active, circuits, incoming)
        layer = sorted(enlarged - active, key=lambda label: int(label[1:]))
        if not layer:
            break
        local_layers.append(layer)
        active = enlarged

    expected_local = [[f"x{i}"] for i in range(1, n)]
    assert local_layers == expected_local
    assert q_trace == [INFINITY] * (n - 1) + [RADIUS]

    # Gluing parallel-pair leaves replaces p by seeded z and q by target y.
    glued_columns = {
        ("z" if label == "p" else "y" if label == "q" else label): column
        for label, column in columns.items()
    }
    glued_circuits = small_circuits(glued_columns)
    ground = set(glued_columns)
    active = {"z"} | {f"s{i}" for i in range(1, n + 1)}
    direct_layers = []
    while True:
        enlarged = direct_step(ground, active, glued_circuits)
        layer = sorted(
            enlarged - active,
            key=lambda label: n if label == "y" else int(label[1:]),
        )
        if not layer:
            break
        direct_layers.append(layer)
        active = enlarged
    expected_direct = [[f"x{i}"] for i in range(1, n)] + [["y"]]
    assert direct_layers == expected_direct

    return {
        "n": n,
        "rank": n + 1,
        "centre_columns": len(columns),
        "three_element_circuits": len(circuits),
        "q_response_first_finite_round": n - 1,
        "terminal_arrival_round": n,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-n", type=int, default=32)
    args = parser.parse_args()
    records = [verify(n) for n in range(1, args.max_n + 1)]
    print(
        json.dumps(
            {
                "task": "C232 fixed-radius fixed-width transfer obstruction",
                "field": "GF(2)",
                "radius": RADIUS,
                "centre_interface_width": 2,
                "verified_n": [1, args.max_n],
                "families_checked": len(records),
                "checks": [
                    "simple nonzero binary columns",
                    "complete circuit inventory through cardinality three",
                    "both virtual elements noncoloops",
                    "local multi-interface response trace",
                    "direct closure after gluing parallel-pair leaves",
                ],
                "first_record": records[0],
                "last_record": records[-1],
            },
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
