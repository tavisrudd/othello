#!/usr/bin/env python3
"""Deterministic finite replay for the C333 all-odd-q mirror family."""

from __future__ import annotations

import argparse
import hashlib
import json
import tempfile
from collections import Counter, deque
from itertools import combinations, product
from pathlib import Path


STEM = "2026-07-18-c333-all-odd-q-mirror-locus"
SCHEMA = "c333-mirror-locus-v1"


class FiniteField:
    """A small polynomial-basis field; the replay uses degrees at most three."""

    def __init__(self, p: int, degree: int) -> None:
        self.p = p
        self.degree = degree
        self.q = p**degree
        self.modulus = () if degree == 1 else self._first_irreducible()

    def _first_irreducible(self) -> tuple[int, ...]:
        assert self.degree in (2, 3)
        for coefficients in product(range(self.p), repeat=self.degree):
            if coefficients[0] == 0:
                continue
            if all(
                (x**self.degree + sum(coefficients[i] * x**i for i in range(self.degree)))
                % self.p
                for x in range(self.p)
            ):
                return tuple(coefficients)
        raise AssertionError("no irreducible polynomial found")

    def coefficients(self, value: int) -> tuple[int, ...]:
        answer = []
        for _ in range(self.degree):
            answer.append(value % self.p)
            value //= self.p
        return tuple(answer)

    def encode(self, coefficients: tuple[int, ...] | list[int]) -> int:
        answer = 0
        place = 1
        for coefficient in coefficients:
            answer += (coefficient % self.p) * place
            place *= self.p
        return answer

    def constant(self, value: int) -> int:
        return value % self.p

    def add(self, left: int, right: int) -> int:
        return self.encode([a + b for a, b in zip(self.coefficients(left), self.coefficients(right))])

    def neg(self, value: int) -> int:
        return self.encode([-a for a in self.coefficients(value)])

    def sub(self, left: int, right: int) -> int:
        return self.add(left, self.neg(right))

    def mul(self, left: int, right: int) -> int:
        if self.degree == 1:
            return left * right % self.p
        a = self.coefficients(left)
        b = self.coefficients(right)
        coefficients = [0] * (2 * self.degree - 1)
        for i in range(self.degree):
            for j in range(self.degree):
                coefficients[i + j] = (coefficients[i + j] + a[i] * b[j]) % self.p
        for power in range(2 * self.degree - 2, self.degree - 1, -1):
            leading = coefficients[power]
            for i, coefficient in enumerate(self.modulus):
                coefficients[power - self.degree + i] -= leading * coefficient
            coefficients[power] = 0
        return self.encode(coefficients[: self.degree])

    def pow(self, value: int, exponent: int) -> int:
        answer = self.constant(1)
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, value)
            value = self.mul(value, value)
            exponent >>= 1
        return answer

    def inverse(self, value: int) -> int:
        assert value
        return self.pow(value, self.q - 2)

    def div(self, left: int, right: int) -> int:
        return self.mul(left, self.inverse(right))

    def character(self, value: int) -> int:
        if value == 0:
            return 0
        result = self.pow(value, (self.q - 1) // 2)
        if result == self.constant(1):
            return 1
        assert result == self.constant(-1)
        return -1

    def full_degree(self, value: int) -> bool:
        for divisor in range(1, self.degree):
            if self.degree % divisor == 0 and self.pow(value, self.p**divisor) == value:
                return False
        return True


Matrix = tuple[int, int, int, int]
Point = tuple[int, int, int]


def mat_mul(field: FiniteField, left: Matrix, right: Matrix) -> Matrix:
    a, b, c, d = left
    e, f, g, h = right
    return (
        field.add(field.mul(a, e), field.mul(b, g)),
        field.add(field.mul(a, f), field.mul(b, h)),
        field.add(field.mul(c, e), field.mul(d, g)),
        field.add(field.mul(c, f), field.mul(d, h)),
    )


def mat_normalize(field: FiniteField, matrix: Matrix) -> Matrix:
    scale = field.inverse(next(entry for entry in matrix if entry))
    return tuple(field.mul(scale, entry) for entry in matrix)  # type: ignore[return-value]


def determinant(field: FiniteField, matrix: Matrix) -> int:
    a, b, c, d = matrix
    return field.sub(field.mul(a, d), field.mul(b, c))


def trace(field: FiniteField, matrix: Matrix) -> int:
    return field.add(matrix[0], matrix[3])


def sigma(field: FiniteField, centre: tuple[int, int]) -> Matrix:
    r, c = centre
    return (field.constant(1), field.neg(r), c, field.constant(-1))


def centres(field: FiniteField, delta: int, b: int) -> tuple[tuple[int, int], ...]:
    one = field.constant(1)
    return (
        (0, one),
        (delta, 0),
        (one, b),
        (field.mul(delta, b), field.inverse(delta)),
    )


def det3(field: FiniteField, points: tuple[Point, Point, Point]) -> int:
    a, b, c = points
    positive = field.add(
        field.add(field.mul(a[0], field.mul(b[1], c[2])), field.mul(a[1], field.mul(b[2], c[0]))),
        field.mul(a[2], field.mul(b[0], c[1])),
    )
    negative = field.add(
        field.add(field.mul(a[2], field.mul(b[1], c[0])), field.mul(a[1], field.mul(b[0], c[2]))),
        field.mul(a[0], field.mul(b[2], c[1])),
    )
    return field.sub(positive, negative)


def act(field: FiniteField, matrix: Matrix, value: int) -> int:
    """Act on P1(F_q), with infinity encoded by q."""
    a, b, c, d = matrix
    if value == field.q:
        return field.q if c == 0 else field.div(a, c)
    denominator = field.add(field.mul(c, value), d)
    if denominator == 0:
        return field.q
    return field.div(field.add(field.mul(a, value), b), denominator)


def conic_point(field: FiniteField, value: int) -> Point:
    if value == field.q:
        return (field.constant(1), 0, 0)
    if value == 0:
        return (0, field.constant(1), 0)
    return (value, field.inverse(value), field.constant(1))


def group_order(field: FiniteField, generators: list[Matrix]) -> int:
    generators = [mat_normalize(field, generator) for generator in generators]
    identity = (field.constant(1), 0, 0, field.constant(1))
    seen = {identity}
    todo = deque([identity])
    while todo:
        element = todo.popleft()
        for generator in generators:
            child = mat_normalize(field, mat_mul(field, generator, element))
            if child not in seen:
                seen.add(child)
                todo.append(child)
    return len(seen)


def admissible(field: FiniteField, delta: int, b: int) -> bool:
    one = field.constant(1)
    four = field.constant(4)
    if not field.full_degree(b):
        return False
    if b in (0, one, field.inverse(delta)):
        return False
    linear = field.add(one, field.mul(delta, field.sub(b, one)))
    quadratic = field.add(
        field.sub(one, delta),
        field.mul(field.mul(delta, delta), field.mul(b, field.sub(one, b))),
    )
    mirror = field.sub(
        field.mul(field.add(one, field.mul(delta, b)), field.add(one, field.mul(delta, b))),
        field.mul(four, delta),
    )
    if linear == 0 or quadratic == 0 or field.character(mirror) != -1:
        return False
    return field.character(field.constant(-1)) == -1 or field.character(field.sub(b, one)) == -1


def verify_parameter(field: FiniteField, delta: int, b: int, enumerate_group: bool) -> dict[str, object]:
    one = field.constant(1)
    four = field.constant(4)
    assert field.character(delta) == -1
    assert field.character(field.sub(delta, four)) == 1
    assert admissible(field, delta, b)
    centre_pairs = centres(field, delta, b)
    centre_points = tuple((r, c, one) for r, c in centre_pairs)
    opening = ((one, 0, 0), (0, one, 0))
    cap_determinants = [det3(field, triple) for triple in combinations(opening + centre_points, 3)]
    assert all(cap_determinants)

    generators = [sigma(field, centre) for centre in centre_pairs]
    tau = (0, delta, one, 0)
    tau_permutation = tuple(act(field, tau, value) for value in range(field.q + 1))
    assert all(tau_permutation[tau_permutation[value]] == value for value in range(field.q + 1))
    assert all(tau_permutation[value] != value for value in range(field.q + 1))
    actions = [tuple(act(field, generator, value) for value in range(field.q + 1)) for generator in generators]
    conjugation = []
    for action in actions:
        conjugate = tuple(tau_permutation[action[tau_permutation[value]]] for value in range(field.q + 1))
        conjugation.append(actions.index(conjugate))
    assert conjugation == [1, 0, 3, 2]

    dead: set[int] = set()
    for left, right in combinations(centre_points, 2):
        for value in range(field.q + 1):
            if det3(field, (left, right, conic_point(field, value))) == 0:
                dead.add(value)
    live = set(range(field.q + 1)) - dead
    assert {tau_permutation[value] for value in dead} == dead
    adjacency = {
        value: ({act(field, generator, value) for generator in generators} - {value}) & live
        for value in live
    }
    assert all(tau_permutation[value] in live for value in live)
    assert all(tau_permutation[value] not in adjacency[value] for value in live)
    assert all(
        {tau_permutation[neighbor] for neighbor in adjacency[value]}
        == adjacency[tau_permutation[value]]
        for value in live
    )

    word = (2, 0, 2, 0, 1, 0)
    unipotent = (one, 0, 0, one)
    for index in word:
        unipotent = mat_mul(field, unipotent, generators[index])
    discriminant = field.sub(field.mul(trace(field, unipotent), trace(field, unipotent)),
                             field.mul(four, determinant(field, unipotent)))
    assert discriminant == 0
    assert mat_normalize(field, unipotent) != (one, 0, 0, one)
    invariant = field.div(
        field.mul(trace(field, mat_mul(field, generators[2], generators[0])),
                  trace(field, mat_mul(field, generators[2], generators[0]))),
        determinant(field, mat_mul(field, generators[2], generators[0])),
    )
    assert invariant == field.inverse(field.sub(one, b))
    assert field.full_degree(invariant)

    order = group_order(field, generators) if enumerate_group else None
    expected_order = field.q * (field.q * field.q - 1)
    if order is not None:
        assert order == expected_order
    return {
        "b_coefficients": list(field.coefficients(b)),
        "cap_triples_checked": len(cap_determinants),
        "dead_conic_vertices": len(dead),
        "generated_group_order": order,
        "live_conic_vertices": len(live),
        "pgl2_order": expected_order,
    }


def check_field(p: int, degree: int) -> dict[str, object]:
    field = FiniteField(p, degree)
    four = field.constant(4)
    deltas = [
        value for value in range(field.q)
        if field.character(value) == -1 and field.character(field.sub(value, four)) == 1
    ]
    assert len(deltas) == (field.q - field.character(field.constant(-1))) // 4
    rows: list[tuple[int, int]] = []
    centre_sets: set[frozenset[tuple[int, int]]] = set()
    counts: Counter[int] = Counter()
    for delta in deltas:
        count = 0
        for b in range(field.q):
            if admissible(field, delta, b):
                rows.append((delta, b))
                centre_sets.add(frozenset(centres(field, delta, b)))
                count += 1
        counts[count] += 1
    assert rows
    assert len(centre_sets) == len(rows)
    delta, b = rows[0]
    sample = verify_parameter(field, delta, b, enumerate_group=field.q <= 49)
    return {
        "admissible_marked_parameter_count": len(rows),
        "canonical_b_coefficients": list(field.coefficients(b)),
        "canonical_delta_coefficients": list(field.coefficients(delta)),
        "delta_count": len(deltas),
        "distinct_normalized_centre_set_count": len(centre_sets),
        "extension_degree": degree,
        "modulus_coefficients_low_to_high": list(field.modulus) + ([1] if degree > 1 else []),
        "p": p,
        "per_delta_count_histogram": {str(key): value for key, value in sorted(counts.items())},
        "q": field.q,
        "sample": sample,
    }


def payload() -> dict[str, object]:
    cases = [check_field(p, degree) for p, degree in ((5, 1), (7, 1), (11, 1), (13, 1), (17, 1), (3, 2), (5, 2), (3, 3), (7, 2))]
    return {
        "cases": cases,
        "conventions": {
            "centre_order": ["(0,1)", "(delta,0)", "(1,b)", "(delta*b,1/delta)"],
            "full_degree": "F_p(b)=F_q",
            "infinity_encoding": "q",
            "mirror": "tau(t)=delta/t",
            "unipotent_word_zero_based": [2, 0, 2, 0, 1, 0],
        },
        "schema": SCHEMA,
    }


def serialized() -> bytes:
    return (json.dumps(payload(), indent=2, sort_keys=True) + "\n").encode()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    target = Path(__file__).with_name(f"{STEM}.json")
    generated = serialized()
    if args.write:
        target.write_bytes(generated)
        print(f"wrote {target.name} ({len(generated)} bytes, sha256={hashlib.sha256(generated).hexdigest()})")
        return 0
    with tempfile.TemporaryDirectory(prefix="c333-check-") as directory:
        replay = Path(directory) / target.name
        replay.write_bytes(generated)
        assert replay.read_bytes() == target.read_bytes()
    print(f"checked {target.name} ({len(generated)} bytes, sha256={hashlib.sha256(generated).hexdigest()})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
