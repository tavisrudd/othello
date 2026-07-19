#!/usr/bin/env python3
"""Exact C355 certificates for coloured oval scheduling and its first hole."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from fractions import Fraction
from functools import lru_cache
from itertools import combinations, permutations, product
from pathlib import Path

Q = 7
PARAMETERS = ((5, 2), (6, 5))
SCHEMA = "c355-integral-oval-service-v1"
C353 = Path(__file__).with_name("2026-07-19-c353-mirror-mixed-failure-scheduling.py")
OUTPUT = Path(__file__).with_suffix(".json")
PRIME_FIXTURES = (5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43)


def load_c353():
    spec = importlib.util.spec_from_file_location("c353", C353)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def damaged_edges(module, parameters: tuple[int, int], failed: tuple[int, int]):
    live = tuple(server for server in range(Q + 1) if server not in failed)
    return tuple(
        (colour, tuple(index for index, server in enumerate(live) if mask >> server & 1))
        for colour, mask in module.recovery_sets(*parameters)
        if not any(mask >> server & 1 for server in failed)
    )


def canonical_key(edges):
    best = None
    for colour_permutation in permutations(range(4)):
        for server_permutation in permutations(range(6)):
            candidate = tuple(sorted(
                (colour_permutation[colour], tuple(sorted(server_permutation[index] for index in edge)))
                for colour, edge in edges
            ))
            if best is None or candidate < best:
                best = candidate
    return best


def representative_classes(module):
    classes: dict[object, dict[str, object]] = {}
    for parameters in PARAMETERS:
        for failed in combinations(range(Q + 1), 2):
            edges = damaged_edges(module, parameters, failed)
            key = canonical_key(edges)
            if key not in classes:
                classes[key] = {
                    "parameters": parameters,
                    "failed": failed,
                    "edges": edges,
                    "multiplicity": 0,
                }
            classes[key]["multiplicity"] += 1
    return tuple(classes[key] for key in sorted(classes))


class IntegralOracle:
    def __init__(self, edges, capacity: int):
        self.capacity = capacity
        self.by_colour = tuple(
            tuple(tuple(int(server in edge) for server in range(6))
                  for edge_colour, edge in edges if edge_colour == colour)
            for colour in range(4)
        )

    @lru_cache(maxsize=None)
    def visit(self, load: tuple[int, ...], remaining: tuple[int, ...]) -> bool:
        if not any(remaining):
            return True
        colours = [colour for colour in range(4) if remaining[colour]]
        colour = min(colours, key=lambda item: len(self.by_colour[item]))
        next_remaining = list(remaining)
        next_remaining[colour] -= 1
        for edge in self.by_colour[colour]:
            next_load = tuple(left + right for left, right in zip(load, edge))
            if (all(value <= self.capacity for value in next_load)
                    and self.visit(next_load, tuple(next_remaining))):
                return True
        return False

    def feasible(self, demand: tuple[int, int, int, int]) -> bool:
        return self.visit((0,) * 6, demand)


def demands(capacity: int):
    return tuple(
        demand for demand in product(range(3 * capacity + 1), repeat=4)
        if sum(demand) <= 3 * capacity
    )


def demand_digest(feasible) -> str:
    encoded = "".join(",".join(map(str, demand)) + "\n" for demand in feasible).encode()
    return hashlib.sha256(encoded).hexdigest()


def integral_census(edges, capacity: int):
    candidates = demands(capacity)
    base = 3 * capacity + 1
    shifts = tuple(base ** colour for colour in range(4))
    edge_steps = tuple(dict.fromkeys(
        (colour, tuple(int(server in edge) for server in range(6)))
        for colour, edge in edges
    ))
    loads = sorted(product(range(capacity + 1), repeat=6), key=sum)
    reachable_by_load = {(0,) * 6: 1}
    for load in loads:
        bits = reachable_by_load.get(load, 0)
        if not bits:
            continue
        for colour, step in edge_steps:
            next_load = tuple(left + right for left, right in zip(load, step))
            if all(value <= capacity for value in next_load):
                reachable_by_load[next_load] = (
                    reachable_by_load.get(next_load, 0) | (bits << shifts[colour])
                )
    reachable = 0
    for bits in reachable_by_load.values():
        reachable |= bits
    feasible = tuple(
        demand for demand in candidates
        if reachable >> sum(value * shifts[colour] for colour, value in enumerate(demand)) & 1
    )
    return candidates, feasible


def rationalize(value: float) -> Fraction:
    result = Fraction(float(value)).limit_denominator(1_000_000)
    assert abs(float(result) - value) < 1e-8
    return result


def fractional_allocation(edges, capacity: int, demand):
    from scipy.optimize import linprog

    result = linprog(
        [0] * len(edges),
        A_ub=[[int(server in edge) for _, edge in edges] for server in range(6)],
        b_ub=[capacity] * 6,
        A_eq=[[int(edge_colour == colour) for edge_colour, _ in edges]
              for colour in range(4)],
        b_eq=demand,
        bounds=(0, None),
        method="highs",
    )
    if not result.success:
        return None
    allocation = []
    for (colour, edge), value in zip(edges, result.x):
        weight = rationalize(value)
        if weight:
            allocation.append([colour, list(edge), weight.numerator, weight.denominator])
    return allocation


def verify_allocation(edges, capacity: int, demand, allocation) -> None:
    valid = set(edges)
    loads = [Fraction(0) for _ in range(6)]
    service = [Fraction(0) for _ in range(4)]
    for colour, edge_list, numerator, denominator in allocation:
        edge = tuple(edge_list)
        weight = Fraction(numerator, denominator)
        assert weight > 0 and (colour, edge) in valid
        service[colour] += weight
        for server in edge:
            loads[server] += weight
    assert tuple(service) == tuple(Fraction(value) for value in demand)
    assert all(load <= capacity for load in loads)


def nonsquare(prime: int) -> int:
    squares = {value * value % prime for value in range(1, prime)}
    return next(value for value in range(2, prime) if value not in squares and value != prime - 1)


def m_image(prime: int, a: int, value: int) -> int:
    if value == prime:
        return 0
    if value == 0:
        return prime
    return a * pow(value, prime - 2, prime) % prime


def n_image(prime: int, value: int) -> int:
    if value == prime:
        return prime
    return -value % prime


def pair_edges(prime: int, image, failed: tuple[int, int]):
    failed_set = set(failed)
    answer = set()
    for value in range(prime + 1):
        other = image(value)
        if value != other and value not in failed_set and other not in failed_set:
            answer.add(tuple(sorted((value, other))))
    return tuple(sorted(answer))


def family_fixture(prime: int) -> dict[str, object]:
    a = nonsquare(prime)
    shared = tuple(value for value in range(1, prime) if value * value % prime == -a % prime)
    failed = (0, prime) if prime % 4 == 1 else tuple(sorted(shared))
    assert len(failed) == 2
    m_edges = pair_edges(prime, lambda value: m_image(prime, a, value), failed)
    n_edges = pair_edges(prime, lambda value: n_image(prime, value), failed)
    assert not set(m_edges) & set(n_edges)
    cycle = None
    for first_m in m_edges:
        for first_n in n_edges:
            if first_m[0] not in first_n:
                continue
            vertices = set(first_m) | set(first_n)
            if len(vertices) != 3:
                continue
            fourth = next(edge for edge in m_edges if first_n[1] in edge)
            vertices.update(fourth)
            closing = tuple(sorted((next(iter(set(first_m) - set(first_n))),
                                    next(iter(set(fourth) - set(first_n))))))
            if closing in n_edges and len(vertices) == 4:
                cycle = (first_m, fourth, first_n, closing)
                break
        if cycle:
            break
    assert cycle is not None
    cycle_m = set(cycle[:2])
    fractional = [
        ["M", list(edge), 1, 2] for edge in cycle[:2]
    ] + [
        ["N", list(edge), 1, 2] for edge in cycle[2:]
    ] + [
        ["M", list(edge), 1, 1] for edge in m_edges if edge not in cycle_m
    ]
    chosen_n = n_edges[0]
    rounded = [["N", list(chosen_n)]] + [
        ["M", list(edge)] for edge in m_edges if not set(edge) & set(chosen_n)
    ]
    m = (prime - 1) // 2
    assert sum(Fraction(item[2], item[3]) for item in fractional if item[0] == "M") == m - 1
    assert sum(Fraction(item[2], item[3]) for item in fractional if item[0] == "N") == 1
    assert sum(item[0] == "M" for item in rounded) == m - 2
    return {
        "prime": prime,
        "a": a,
        "failed": list(failed),
        "m_edges": [list(edge) for edge in m_edges],
        "n_edges": [list(edge) for edge in n_edges],
        "cycle": [list(edge) for edge in cycle],
        "fractional_schedule": fractional,
        "rounded_schedule": rounded,
    }


def generate() -> dict[str, object]:
    module = load_c353()
    classes = representative_classes(module)
    census = []
    holes = []
    for index, item in enumerate(classes):
        edges = item["edges"]
        entry = {
            "class": index,
            "parameters": list(item["parameters"]),
            "failed": list(item["failed"]),
            "multiplicity": item["multiplicity"],
            "capacities": [],
        }
        for capacity in range(1, 5):
            candidates, feasible = integral_census(edges, capacity)
            entry["capacities"].append({
                "T": capacity,
                "candidate_count": len(candidates),
                "integral_count": len(feasible),
                "integral_sha256": demand_digest(feasible),
            })
            if capacity == 1:
                for demand in candidates:
                    if demand in feasible:
                        continue
                    allocation = fractional_allocation(edges, capacity, demand)
                    if allocation is not None:
                        holes.append({
                            "class": index,
                            "demand": list(demand),
                            "allocation": allocation,
                        })
        census.append(entry)
    return {
        "schema": SCHEMA,
        "c353_sha256": hashlib.sha256(C353.read_bytes()).hexdigest(),
        "damaged_instances": 56,
        "canonical_classes": len(classes),
        "census": census,
        "T1_fractional_holes": holes,
        "family_prime_fixtures": [family_fixture(prime) for prime in PRIME_FIXTURES],
    }


def check(data: dict[str, object]) -> None:
    assert data["schema"] == SCHEMA
    assert data["c353_sha256"] == hashlib.sha256(C353.read_bytes()).hexdigest()
    assert data["damaged_instances"] == 56
    module = load_c353()
    classes = representative_classes(module)
    assert data["canonical_classes"] == len(classes) == 25
    for index, (item, entry) in enumerate(zip(classes, data["census"])):
        assert entry["class"] == index
        assert entry["parameters"] == list(item["parameters"])
        assert entry["failed"] == list(item["failed"])
        assert entry["multiplicity"] == item["multiplicity"]
        for capacity, summary in enumerate(entry["capacities"], 1):
            candidates, feasible = integral_census(item["edges"], capacity)
            assert summary == {
                "T": capacity,
                "candidate_count": len(candidates),
                "integral_count": len(feasible),
                "integral_sha256": demand_digest(feasible),
            }
            if capacity == 1 or (index == 0 and capacity == 2):
                oracle = IntegralOracle(item["edges"], capacity)
                direct = tuple(demand for demand in candidates if oracle.feasible(demand))
                assert feasible == direct
    for hole in data["T1_fractional_holes"]:
        item = classes[hole["class"]]
        demand = tuple(hole["demand"])
        assert not IntegralOracle(item["edges"], 1).feasible(demand)
        verify_allocation(item["edges"], 1, demand, hole["allocation"])
    assert len(data["T1_fractional_holes"]) == 15
    assert data["family_prime_fixtures"] == [family_fixture(prime) for prime in PRIME_FIXTURES]


def serialized(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--generate", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.generate:
        OUTPUT.write_bytes(serialized(generate()))
    if args.check or not args.generate:
        data = json.loads(OUTPUT.read_text())
        check(data)
        print("verified 56 damaged pilots in 25 coloured-isomorphism classes through T=4")
        print("verified 15 exact T=1 holes, 1,085 direct replays, and 12 family fixtures")
        print(f"certificate sha256: {hashlib.sha256(OUTPUT.read_bytes()).hexdigest()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
