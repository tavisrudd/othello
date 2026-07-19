#!/usr/bin/env python3
"""Exact q=7 certificate for C353 two-helper-failure service robustness."""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from itertools import combinations
from pathlib import Path

Q = 7
SCHEMA = "c353-two-failure-equal-service-v1"
STEM = "2026-07-19-c353-mirror-mixed-failure-scheduling"
PARAMETERS = ((5, 2), (6, 5))


def inv(value: int) -> int:
    return pow(value, Q - 2, Q)


def normalize(point: tuple[int, int, int]) -> tuple[int, int, int]:
    pivot = next(value for value in point if value % Q)
    scale = inv(pivot)
    return tuple(value * scale % Q for value in point)


def determinant(a: tuple[int, int, int], b: tuple[int, int, int],
                c: tuple[int, int, int]) -> int:
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % Q


def servers() -> tuple[tuple[int, int, int], ...]:
    return tuple((t * t % Q, t, 1) for t in range(Q)) + ((1, 0, 0),)


def targets(delta: int, b: int) -> tuple[tuple[int, int, int], ...]:
    centres = ((0, 1), (delta, 0), (1, b), (delta * b % Q, inv(delta)))
    return tuple(normalize((row, 1, column)) for row, column in centres)


def point_type(point: tuple[int, int, int]) -> str:
    x, y, z = point
    discriminant = (y * y - x * z) % Q
    return "E" if pow(discriminant, (Q - 1) // 2, Q) == 1 else "I"


def recovery_sets(delta: int, b: int) -> tuple[tuple[int, int], ...]:
    carrier = servers()
    answer: list[tuple[int, int]] = []
    for colour, target in enumerate(targets(delta, b)):
        pairs = {
            sum(1 << index for index in pair)
            for pair in combinations(range(len(carrier)), 2)
            if determinant(target, carrier[pair[0]], carrier[pair[1]]) == 0
        }
        minimal = set(pairs)
        for triple in combinations(range(len(carrier)), 3):
            mask = sum(1 << index for index in triple)
            if not any(pair & mask == pair for pair in pairs):
                minimal.add(mask)
        answer.extend((colour, mask) for mask in sorted(minimal))
    return tuple(answer)


def direct_recovery_sets(delta: int, b: int) -> tuple[tuple[int, int], ...]:
    carrier = servers()
    answer: list[tuple[int, int]] = []
    for colour, target in enumerate(targets(delta, b)):
        spans: dict[int, bool] = {}
        for size in (1, 2, 3):
            for subset in combinations(range(len(carrier)), size):
                mask = sum(1 << index for index in subset)
                if size == 1:
                    spans[mask] = normalize(carrier[subset[0]]) == normalize(target)
                elif size == 2:
                    spans[mask] = determinant(target, carrier[subset[0]], carrier[subset[1]]) == 0
                else:
                    spans[mask] = determinant(carrier[subset[0]], carrier[subset[1]], carrier[subset[2]]) != 0
                if spans[mask] and not any(spans.get(mask ^ (1 << index), False) for index in subset):
                    answer.append((colour, mask))
    return tuple(sorted(answer))


def encode(value: Fraction) -> list[int]:
    return [value.numerator, value.denominator]


def decode(value: list[int]) -> Fraction:
    assert len(value) == 2 and value[1] > 0
    return Fraction(value[0], value[1])


def rationalize(value: float) -> Fraction:
    result = Fraction(float(value)).limit_denominator(100_000)
    assert abs(float(result) - value) < 1e-8
    return result


def solve(delta: int, b: int, failed: tuple[int, int]) -> dict[str, object]:
    try:
        from scipy.optimize import linprog
    except ImportError as error:
        raise SystemExit("generation requires scipy; --check uses only the standard library") from error

    failed_mask = sum(1 << index for index in failed)
    edges = [(colour, mask) for colour, mask in recovery_sets(delta, b) if not mask & failed_mask]
    rows: list[list[int]] = []
    bounds: list[int] = []
    for server in range(Q + 1):
        rows.append([int(mask >> server & 1) for _, mask in edges] + [0])
        bounds.append(1)
    for colour in range(4):
        rows.append([-int(edge_colour == colour) for edge_colour, _ in edges] + [1])
        bounds.append(0)
    result = linprog(
        [0] * len(edges) + [-1], A_ub=rows, b_ub=bounds,
        bounds=[(0, None)] * (len(edges) + 1), method="highs",
    )
    assert result.success
    primal = [rationalize(value) for value in result.x[:-1]]
    rate = rationalize(result.x[-1])
    dual = [rationalize(-value) for value in result.ineqlin.marginals]
    return {
        "failed": list(failed),
        "rate": encode(rate),
        "allocation": [
            [colour, mask, *encode(weight)]
            for (colour, mask), weight in zip(edges, primal) if weight
        ],
        "dual_servers": [encode(value) for value in dual[: Q + 1]],
        "dual_colours": [encode(value) for value in dual[Q + 1 :]],
    }


def verify_instance(delta: int, b: int, instance: dict[str, object]) -> Fraction:
    failed = tuple(instance["failed"])
    assert len(failed) == 2 and failed[0] < failed[1]
    failed_mask = sum(1 << index for index in failed)
    valid = set(recovery_sets(delta, b))
    rate = decode(instance["rate"])
    loads = [Fraction(0) for _ in range(Q + 1)]
    service = [Fraction(0) for _ in range(4)]
    for colour, mask, numerator, denominator in instance["allocation"]:
        weight = Fraction(numerator, denominator)
        assert weight > 0 and (colour, mask) in valid and not mask & failed_mask
        service[colour] += weight
        for server in range(Q + 1):
            if mask >> server & 1:
                loads[server] += weight
    assert all(load <= 1 for load in loads)
    assert all(value >= rate for value in service)

    server_dual = [decode(value) for value in instance["dual_servers"]]
    colour_dual = [decode(value) for value in instance["dual_colours"]]
    assert len(server_dual) == Q + 1 and len(colour_dual) == 4
    assert all(value >= 0 for value in server_dual + colour_dual)
    assert sum(colour_dual) >= 1
    for colour, mask in valid:
        if mask & failed_mask:
            continue
        assert sum(server_dual[j] for j in range(Q + 1) if mask >> j & 1) >= colour_dual[colour]
    assert sum(server_dual) == rate
    return rate


def payload() -> dict[str, object]:
    members = []
    for delta, b in PARAMETERS:
        instances = [solve(delta, b, failed) for failed in combinations(range(Q + 1), 2)]
        rates = [decode(instance["rate"]) for instance in instances]
        members.append({
            "delta": delta,
            "b": b,
            "types": [point_type(point) for point in targets(delta, b)],
            "recovery_set_count": len(recovery_sets(delta, b)),
            "robust_equal_rate": encode(min(rates)),
            "instances": instances,
        })
    return {"schema": SCHEMA, "field": Q, "server_labels": list(range(Q)) + ["infinity"], "members": members}


def serialized(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def check(data: dict[str, object]) -> None:
    assert data["schema"] == SCHEMA and data["field"] == Q
    assert data["server_labels"] == list(range(Q)) + ["infinity"]
    assert recovery_sets(*PARAMETERS[0]) == direct_recovery_sets(*PARAMETERS[0])
    assert recovery_sets(*PARAMETERS[1]) == direct_recovery_sets(*PARAMETERS[1])
    members = data["members"]
    assert [(member["delta"], member["b"]) for member in members] == list(PARAMETERS)
    expected_pairs = list(combinations(range(Q + 1), 2))
    robust = []
    for member in members:
        assert member["types"] == ["E", "E", "I", "I"]
        assert len(member["instances"]) == len(expected_pairs)
        assert [tuple(item["failed"]) for item in member["instances"]] == expected_pairs
        rates = [verify_instance(member["delta"], member["b"], item) for item in member["instances"]]
        assert decode(member["robust_equal_rate"]) == min(rates)
        robust.append(min(rates))
    assert robust == [Fraction(2, 3), Fraction(5, 8)]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--generate", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    path = Path(__file__).with_suffix(".json")
    if args.generate:
        path.write_bytes(serialized(payload()))
    if args.check or not args.generate:
        data = json.loads(path.read_text())
        check(data)
        print(f"verified {sum(len(member['instances']) for member in data['members'])} exact failure LPs")
        print("robust equal rates: 2/3 and 5/8")
        print(f"certificate sha256: {hashlib.sha256(path.read_bytes()).hexdigest()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
