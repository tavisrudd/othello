#!/usr/bin/env python3
"""Independent finite-field replay for C332 all-extension descent.

The checker deliberately uses only prime base fields.  It constructs extension
fields from the first monic irreducible polynomial in lexicographic coefficient
order, enumerates PGL(2,p) and PSL(2,p), finds a legal generating involution
triple for each group, and checks the orbit/deletion/colour decomposition on
representative odd and even extension degrees.
"""

from __future__ import annotations

import argparse
import functools
import hashlib
import itertools
import json
import tempfile
from dataclasses import dataclass
from pathlib import Path


def trim(poly: list[int]) -> list[int]:
    while len(poly) > 1 and poly[-1] == 0:
        poly.pop()
    return poly


def poly_mod(dividend: list[int], divisor: list[int], p: int) -> list[int]:
    value = trim(dividend[:])
    divisor = trim(divisor[:])
    while len(value) >= len(divisor) and value != [0]:
        scale = value[-1] * pow(divisor[-1], p - 2, p) % p
        shift = len(value) - len(divisor)
        for i, coefficient in enumerate(divisor):
            value[i + shift] = (value[i + shift] - scale * coefficient) % p
        trim(value)
    return value


def first_irreducible(p: int, degree: int) -> tuple[int, ...]:
    for low in itertools.product(range(p), repeat=degree):
        if low[0] == 0:
            continue
        candidate = list(low) + [1]
        reducible = False
        for factor_degree in range(1, degree // 2 + 1):
            for factor_low in itertools.product(range(p), repeat=factor_degree):
                factor = list(factor_low) + [1]
                if poly_mod(candidate, factor, p) == [0]:
                    reducible = True
                    break
            if reducible:
                break
        if not reducible:
            return tuple(candidate)
    raise AssertionError((p, degree))


@dataclass(frozen=True)
class Field:
    p: int
    degree: int
    modulus: tuple[int, ...]

    @property
    def order(self) -> int:
        return self.p**self.degree

    def digits(self, value: int) -> list[int]:
        result = []
        for _ in range(self.degree):
            result.append(value % self.p)
            value //= self.p
        return result

    def encode(self, coefficients: list[int]) -> int:
        return sum((coefficient % self.p) * self.p**i for i, coefficient in enumerate(coefficients))

    def add(self, left: int, right: int) -> int:
        return self.encode([(a + b) % self.p for a, b in zip(self.digits(left), self.digits(right))])

    def neg(self, value: int) -> int:
        return self.encode([(-a) % self.p for a in self.digits(value)])

    def mul(self, left: int, right: int) -> int:
        a, b = self.digits(left), self.digits(right)
        product = [0] * (2 * self.degree - 1)
        for i, x in enumerate(a):
            for j, y in enumerate(b):
                product[i + j] = (product[i + j] + x * y) % self.p
        for power in range(len(product) - 1, self.degree - 1, -1):
            scale = product[power]
            if scale:
                for i in range(self.degree):
                    product[power - self.degree + i] = (
                        product[power - self.degree + i] - scale * self.modulus[i]
                    ) % self.p
        return self.encode(product[: self.degree])

    def power(self, value: int, exponent: int) -> int:
        result = 1
        while exponent:
            if exponent & 1:
                result = self.mul(result, value)
            value = self.mul(value, value)
            exponent >>= 1
        return result

    def inv(self, value: int) -> int:
        if value == 0:
            raise ZeroDivisionError
        return self.power(value, self.order - 2)

    def div(self, numerator: int, denominator: int) -> int:
        return self.mul(numerator, self.inv(denominator))


Matrix = tuple[int, int, int, int]
Point = int | None


def determinant(matrix: Matrix, field: Field) -> int:
    a, b, c, d = matrix
    return field.add(field.mul(a, d), field.neg(field.mul(b, c)))


def matmul(left: Matrix, right: Matrix, field: Field) -> Matrix:
    a, b, c, d = left
    e, f, g, h = right
    return (
        field.add(field.mul(a, e), field.mul(b, g)),
        field.add(field.mul(a, f), field.mul(b, h)),
        field.add(field.mul(c, e), field.mul(d, g)),
        field.add(field.mul(c, f), field.mul(d, h)),
    )


def normalize_base(matrix: Matrix, p: int) -> Matrix:
    pivot = next(value for value in matrix if value)
    scale = pow(pivot, p - 2, p)
    return tuple(value * scale % p for value in matrix)  # type: ignore[return-value]


def action(matrix: Matrix, point: Point, field: Field) -> Point:
    a, b, c, d = matrix
    if point is None:
        return None if c == 0 else field.div(a, c)
    numerator = field.add(field.mul(a, point), b)
    denominator = field.add(field.mul(c, point), d)
    return None if denominator == 0 else field.div(numerator, denominator)


def base_groups(p: int) -> tuple[tuple[Matrix, ...], tuple[Matrix, ...]]:
    prime = Field(p, 1, (0, 1))
    pgl = {
        normalize_base((a, b, c, d), p)
        for a, b, c, d in itertools.product(range(p), repeat=4)
        if determinant((a, b, c, d), prime)
    }
    psl = {
        matrix
        for matrix in pgl
        if pow(determinant(matrix, prime), (p - 1) // 2, p) == 1
    }
    return tuple(sorted(pgl)), tuple(sorted(psl))


def generated(generators: tuple[Matrix, ...], p: int) -> frozenset[Matrix]:
    prime = Field(p, 1, (0, 1))
    identity = (1, 0, 0, 1)
    group = {identity}
    frontier = [identity]
    while frontier:
        element = frontier.pop()
        for generator in generators:
            product = normalize_base(matmul(element, generator, prime), p)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return frozenset(group)


def projective_centres(p: int) -> tuple[tuple[int, int, int], ...]:
    representatives = set()
    for raw in itertools.product(range(p), repeat=3):
        if raw == (0, 0, 0):
            continue
        pivot = next(value for value in raw if value)
        scale = pow(pivot, p - 2, p)
        point = tuple(value * scale % p for value in raw)
        a, b, c = point
        if (a * c - b * b) % p:
            representatives.add(point)
    return tuple(sorted(representatives))


def centre_matrix(centre: tuple[int, int, int], p: int) -> Matrix:
    a, b, c = centre
    return normalize_base((b, -a % p, c, -b % p), p)


def centre_determinant(triple: tuple[tuple[int, int, int], ...], p: int) -> int:
    (a, b, c), (d, e, f), (g, h, i) = triple
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % p


@functools.cache
def generating_triple(p: int, target_order: int) -> tuple[Matrix, Matrix, Matrix]:
    centres = projective_centres(p)
    prime = Field(p, 1, (0, 1))
    quadratic_field = Field(p, 2, first_irreducible(p, 2))
    quadratic_points = frozenset(range(quadratic_field.order)) - frozenset(range(p))
    best: tuple[Matrix, Matrix, Matrix] | None = None
    best_quadratic_dead = -1
    for triple in itertools.combinations(centres, 3):
        if not centre_determinant(triple, p):
            continue
        generators = tuple(centre_matrix(centre, p) for centre in triple)
        if len(generated(generators, p)) == target_order:
            pair_products = [
                matmul(generators[j], generators[i], prime)
                for i, j in itertools.combinations(range(3), 2)
            ]
            dead = frozenset().union(
                *(fixed_points(product, quadratic_field) for product in pair_products)
            )
            score = len(dead & quadratic_points)
            if score > best_quadratic_dead:
                best = generators  # type: ignore[assignment]
                best_quadratic_dead = score
            if score == 6:
                return generators  # type: ignore[return-value]
    if best is not None:
        return best
    raise AssertionError((p, target_order))


def orbit(group: tuple[Matrix, ...], seed: Point, field: Field) -> frozenset[Point]:
    return frozenset(action(element, seed, field) for element in group)


def point_key(point: Point) -> int:
    return -1 if point is None else point


def fixed_points(matrix: Matrix, field: Field) -> frozenset[Point]:
    points: tuple[Point, ...] = tuple(range(field.order)) + (None,)
    return frozenset(point for point in points if action(matrix, point, field) == point)


def extension_record(p: int, degree: int, sheet: str) -> dict[str, object]:
    modulus = first_irreducible(p, degree)
    field = Field(p, degree, modulus)
    pgl, psl = base_groups(p)
    group = pgl if sheet == "PGL" else psl
    generators = generating_triple(p, len(group))
    points: tuple[Point, ...] = tuple(range(field.order)) + (None,)

    unseen = set(points)
    orbits: list[frozenset[Point]] = []
    while unseen:
        current = orbit(group, min(unseen, key=point_key), field)
        orbits.append(current)
        unseen.difference_update(current)

    base = frozenset(range(p)) | {None}
    quadratic = (
        frozenset(x for x in range(field.order) if field.power(x, p * p) == x) - base
        if degree % 2 == 0
        else frozenset()
    )
    base_orbits = [item for item in orbits if item == base]
    quadratic_orbits = [item for item in orbits if quadratic and item == quadratic]
    regular_orbits = [item for item in orbits if item != base and item != quadratic]

    prime = Field(p, 1, (0, 1))
    pair_products = [
        matmul(generators[j], generators[i], prime)
        for i, j in itertools.combinations(range(3), 2)
    ]
    dead = frozenset().union(*(fixed_points(product, field) for product in pair_products))
    if not dead <= base | quadratic:
        raise AssertionError("dead point outside degree <= 2")

    for generator in generators:
        for item in orbits:
            if {action(generator, point, field) for point in item} != set(item):
                raise AssertionError("coloured edge crosses orbit")
    for item in regular_orbits:
        if len(item) != len(group):
            raise AssertionError("nonregular residual orbit")
        seed = min(item, key=point_key)
        if len({action(element, seed, field) for element in group}) != len(group):
            raise AssertionError("nontrivial regular stabilizer")

    if len(base_orbits) != 1:
        raise AssertionError("base subline is not one orbit")
    if degree % 2 == 0 and (len(quadratic_orbits) != 1 or len(quadratic) != p * (p - 1)):
        raise AssertionError("quadratic orbit mismatch")
    if degree % 2 and quadratic_orbits:
        raise AssertionError("unexpected quadratic orbit")

    if degree % 2:
        pgl_regular = (p ** (degree - 1) - 1) // (p * p - 1)
    else:
        pgl_regular = (p ** (degree - 1) - p) // (p * p - 1)
    expected_regular = pgl_regular if sheet == "PGL" else 2 * pgl_regular
    if len(regular_orbits) != expected_regular:
        raise AssertionError((len(regular_orbits), expected_regular))

    base_dead = len(dead & base)
    quadratic_dead = len(dead & quadratic)
    return {
        "base_dead": base_dead,
        "degree": degree,
        "extension_order": field.order,
        "group_order": len(group),
        "modulus_low_to_high": list(modulus),
        "quadratic_dead": quadratic_dead,
        "quadratic_orbits": len(quadratic_orbits),
        "quadratic_size": len(quadratic),
        "regular_multiplicity": len(regular_orbits),
        "regular_parity": len(regular_orbits) % 2,
        "sheet": sheet,
        "total_dead": len(dead),
        "total_orbits": len(orbits),
    }


def certificate() -> dict[str, object]:
    requested_cases = (
        *((3, degree, "PGL") for degree in (2, 3, 4, 5)),
        *((5, degree, sheet) for degree in (2, 3, 4) for sheet in ("PGL", "PSL")),
    )
    cases = [
        extension_record(p, degree, sheet)
        for p, degree, sheet in requested_cases
    ]
    return {
        "cases": cases,
        "conventions": {
            "base_fields": "odd prime fields",
            "dead_points": "union of fixed points of s_j s_i for i<j",
            "edge_action": "left fractional-linear action; colours retain generator index",
            "infinity_encoding": None,
            "quadratic_set": "F_(p^2) minus P1(F_p), present iff 2 divides n",
        },
        "exceptions": [
            "PSL(2,3) has no involutory generating triple: its three involutions form a proper V4"
        ],
        "schema": "c332-all-extension-subfield-descent-v1",
    }


def serialized(value: dict[str, object]) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", type=Path)
    parser.add_argument("--output", type=Path)
    arguments = parser.parse_args()
    if bool(arguments.check) == bool(arguments.output):
        parser.error("choose exactly one of --check or --output")

    content = serialized(certificate())
    if arguments.check:
        with tempfile.TemporaryDirectory(prefix="c332-check-") as directory:
            replay = Path(directory) / "replay.json"
            replay.write_bytes(content)
            expected = arguments.check.read_bytes()
            if content != expected:
                raise SystemExit(
                    f"mismatch: replay sha256={hashlib.sha256(content).hexdigest()} "
                    f"tracked sha256={hashlib.sha256(expected).hexdigest()}"
                )
        print(f"OK {arguments.check} {len(content)} bytes {hashlib.sha256(content).hexdigest()}")
    else:
        arguments.output.write_bytes(content)
        print(f"WROTE {arguments.output} {len(content)} bytes {hashlib.sha256(content).hexdigest()}")


if __name__ == "__main__":
    main()
