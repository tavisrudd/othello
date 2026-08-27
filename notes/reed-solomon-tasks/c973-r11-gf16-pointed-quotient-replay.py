#!/usr/bin/env python3
"""Independent quotient and Hankel replay for C973's pointed GF(16) certificate."""

from __future__ import annotations

import importlib.util
import json
from itertools import combinations, product
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "c973-r11-gf16-pointed-quotient.json"
C531_PATH = ROOT / "notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.py"
Q = 16
MODULUS = 0b10011
INDICES = tuple(range(3, 8))

SPEC = importlib.util.spec_from_file_location("c531_replay", C531_PATH)
assert SPEC is not None and SPEC.loader is not None
C531 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(C531)


def mul(left: int, right: int) -> int:
    return C531.gf_mul(left, right, MODULUS)


def action_entry(source: int, target: int, matrix: tuple[int, int, int, int]) -> int:
    a, b, c, d = matrix
    total = 0
    for ea, eb, ec, ed in C531.action_entry(source, target):
        term = C531.gf_pow(a, ea, MODULUS)
        term = mul(term, C531.gf_pow(b, eb, MODULUS))
        term = mul(term, C531.gf_pow(c, ec, MODULUS))
        term = mul(term, C531.gf_pow(d, ed, MODULUS))
        total ^= term
    return total


def matrix(matrix_data: tuple[int, int, int, int]) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(action_entry(source, target, matrix_data) for target in INDICES)
        for source in INDICES
    )


def canonical(point: tuple[int, ...]) -> tuple[int, ...]:
    pivot = next(value for value in point if value)
    inverse = C531.gf_pow(pivot, Q - 2, MODULUS)
    return tuple(mul(value, inverse) for value in point)


def act(point: tuple[int, ...], action: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    image = []
    for target in range(5):
        value = 0
        for source in range(5):
            value ^= mul(point[source], action[source][target])
        image.append(value)
    return canonical(tuple(image))


def all_points() -> set[tuple[int, ...]]:
    return {
        (0,) * pivot + (1,) + tail
        for pivot in range(5)
        for tail in product(range(Q), repeat=4 - pivot)
    }


def replay_representatives(generators: list[list[int]]) -> list[tuple[int, ...]]:
    actions = [matrix(tuple(generator)) for generator in generators]
    unseen = all_points()
    representatives = []
    while unseen:
        representative = min(unseen)
        orbit = {representative}
        frontier = [representative]
        while frontier:
            point = frontier.pop()
            for action in actions:
                image = act(point, action)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen.difference_update(orbit)
        representatives.append(representative)
    return representatives


def root_polynomial(roots: list[int]) -> list[int]:
    coefficients = [1]
    for root in roots:
        extended = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            extended[index] ^= mul(coefficient, root)
            extended[index + 1] ^= coefficient
        coefficients = extended
    return coefficients


def dot(left: tuple[int, ...], right: list[int]) -> int:
    value = 0
    for x, y in zip(left, right):
        value ^= mul(x, y)
    return value


def is_locator(representative: tuple[int, ...], roots: list[int]) -> bool:
    degree = len(roots)
    coefficients = root_polynomial(roots)
    first_shift = 3 - (11 - degree - 1)
    for shift in range(first_shift, 4):
        padded = [0] * max(0, -shift) + coefficients
        start = max(shift, 0)
        row = padded[start : start + 5]
        row += [0] * (5 - len(row))
        if dot(representative, row) != 0:
            return False
    return True


def main() -> None:
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c973-r11-gf16-pointed-quotient-v1"
    assert data["projective_carrier_points"] == (Q**5 - 1) // (Q - 1)
    expected = replay_representatives(data["borel_generators"])
    recorded = [tuple(record["representative"]) for record in data["records"]]
    assert recorded == expected
    for representative, record in zip(recorded, data["records"]):
        if record["status"] == "NO_POINTED_LOCATOR":
            assert not any(
                is_locator(representative, list(roots))
                for degree in range(1, 10)
                for roots in combinations(range(Q), degree)
            )
            continue
        assert record["status"] in {
            "WITNESS",
            "LOWER_DEGREE_WITNESS",
            "EXHAUSTIVE_LOWER_DEGREE_WITNESS",
        }
        roots = record["support"]
        degree = len(roots)
        assert 1 <= degree <= 9 and len(set(roots)) == degree
        assert all(0 <= root < Q for root in roots)
        coefficients = root_polynomial(roots)
        assert len(coefficients) == degree + 1 and coefficients[-1] == 1
        assert is_locator(representative, roots)
    print(f"C973 independent GF(16) replay: PASS ({len(recorded)} pointed orbits)")


if __name__ == "__main__":
    main()
