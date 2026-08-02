#!/usr/bin/env python3
"""Independent replay of C620's q=16,32 intrinsic quotient certificates."""

from __future__ import annotations

import json
import hashlib
from itertools import combinations, product
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent


def degree(value: int) -> int:
    return value.bit_length() - 1


def polynomial_remainder(value: int, modulus: int) -> int:
    while degree(value) >= degree(modulus):
        value ^= modulus << (degree(value) - degree(modulus))
    return value


def polynomial_product(left: int, right: int) -> int:
    out = 0
    while right:
        if right & 1:
            out ^= left
        left <<= 1
        right >>= 1
    return out


def multiply(left: int, right: int, modulus: int) -> int:
    return polynomial_remainder(polynomial_product(left, right), modulus)


def power(value: int, exponent: int, modulus: int) -> int:
    out = 1
    while exponent:
        if exponent & 1:
            out = multiply(out, value, modulus)
        value = multiply(value, value, modulus)
        exponent >>= 1
    return out


def is_irreducible(polynomial: int, m: int) -> bool:
    x = 2
    value = x
    for _ in range(1, m // 2 + 1):
        value = multiply(value, value, polynomial)
        a, b = value ^ x, polynomial
        while b:
            a, b = b, polynomial_remainder(a, b)
        if a != 1:
            return False
    value = x
    for _ in range(m):
        value = multiply(value, value, polynomial)
    return value == x


def first_irreducible(m: int) -> int:
    for polynomial in range((1 << m) | 1, 1 << (m + 1), 2):
        if is_irreducible(polynomial, m):
            return polynomial
    raise AssertionError


def prime_factors(value: int) -> set[int]:
    out: set[int] = set()
    divisor = 2
    while divisor * divisor <= value:
        if value % divisor == 0:
            out.add(divisor)
            while value % divisor == 0:
                value //= divisor
        divisor += 1
    if value > 1:
        out.add(value)
    return out


def primitive(q: int, modulus: int) -> int:
    for value in range(2, q):
        if all(power(value, (q - 1) // prime, modulus) != 1 for prime in prime_factors(q - 1)):
            return value
    raise AssertionError


def action_coefficient(source: int, target: int, matrix: tuple[int, int, int, int], modulus: int) -> int:
    a, b, c, d = matrix
    out = 0
    for r in range(10 - target):
        s = 9 - source - r
        if 0 <= s <= target and comb(9 - target, r) & 1 and comb(target, s) & 1:
            term = power(a, r, modulus)
            term = multiply(term, power(b, 9 - target - r, modulus), modulus)
            term = multiply(term, power(c, s, modulus), modulus)
            term = multiply(term, power(d, target - s, modulus), modulus)
            out ^= term
    return out


def representation_matrix(matrix: tuple[int, int, int, int], modulus: int) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(action_coefficient(source, target, matrix, modulus) for target in range(2, 8))
        for source in range(2, 8)
    )


def normalized_action(
    u: tuple[int, int, int, int], matrix: tuple[tuple[int, ...], ...], q: int, modulus: int
) -> tuple[int, int, int, int]:
    point = (u[0], u[1], 1, 0, u[2], u[3])
    image = []
    for target in range(6):
        value = 0
        for source in range(6):
            value ^= multiply(point[source], matrix[source][target], modulus)
        image.append(value)
    assert image[2] and image[3] == 0
    inverse = power(image[2], q - 2, modulus)
    image = [multiply(value, inverse, modulus) for value in image]
    return image[0], image[1], image[4], image[5]


def quotient_representatives(q: int, modulus: int) -> list[tuple[int, int, int, int]]:
    matrices = [
        representation_matrix((1, 1, 0, 1), modulus),
        representation_matrix((primitive(q, modulus), 0, 0, 1), modulus),
    ]
    unseen = set(product(range(q), repeat=4))
    out = []
    while unseen:
        representative = min(unseen)
        orbit = {representative}
        frontier = [representative]
        while frontier:
            point = frontier.pop()
            for matrix in matrices:
                image = normalized_action(point, matrix, q, modulus)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen.difference_update(orbit)
        out.append(representative)
    return out


def root_polynomial(roots: tuple[int, ...], q: int, modulus: int) -> tuple[int, ...]:
    coefficients = [1]
    for root in roots:
        if root == q:
            continue
        new = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            new[index] ^= multiply(coefficient, root, modulus)
            new[index + 1] ^= coefficient
        coefficients = new
    coefficients += [0] * (9 - len(coefficients))
    return tuple(coefficients)


def dot(left: tuple[int, ...], right: tuple[int, ...], modulus: int) -> int:
    out = 0
    for x, y in zip(left, right):
        out ^= multiply(x, y, modulus)
    return out


def check_witness(u: tuple[int, ...], roots: tuple[int, ...], q: int, modulus: int) -> None:
    assert len(roots) == len(set(roots)) == 8
    assert all(0 <= root <= q for root in roots)
    coefficients = root_polynomial(roots, q, modulus)
    point = (u[0], u[1], 1, 0, u[2], u[3])
    assert dot(point, coefficients[1:7], modulus) == 0
    assert dot(point, coefficients[2:8], modulus) == 0


def mobius(point: int, matrix: tuple[int, int, int, int], q: int, modulus: int) -> int:
    a, b, c, d = matrix
    if point == q:
        return q if c == 0 else multiply(a, power(c, q - 2, modulus), modulus)
    numerator = multiply(a, point, modulus) ^ b
    denominator = multiply(c, point, modulus) ^ d
    return q if denominator == 0 else multiply(numerator, power(denominator, q - 2, modulus), modulus)


def projective_additive_rows(modulus: int) -> list[tuple[tuple[int, ...], tuple[int, ...]]]:
    q = 16
    generators = [(1, 1, 0, 1), (primitive(q, modulus), 0, 0, 1), (0, 1, 1, 0)]
    root_sets = {
        tuple(x for x in range(q) if (x & functional).bit_count() % 2 == value)
        for functional in range(1, q)
        for value in (0, 1)
    }
    frontier = list(root_sets)
    while frontier:
        roots = frontier.pop()
        for matrix in generators:
            image = tuple(sorted(mobius(root, matrix, q, modulus) for root in roots))
            if image not in root_sets:
                root_sets.add(image)
                frontier.append(image)
    rows = []
    for roots in root_sets:
        coefficients = root_polynomial(roots, q, modulus)
        rows.append((coefficients[1:7], coefficients[2:8]))
    assert len(rows) == 510
    return rows


def replay(q: int) -> dict[str, int]:
    data = json.loads((HERE / f"2026-08-02-c620-higher-lucas-modular-carriers-q{q}.json").read_text())
    assert data["schema"] == "c620-higher-lucas-quotient-v2"
    assert data["record_layout"] == [
        "u0", "u1", "u2", "u3",
        "root0", "root1", "root2", "root3", "root4", "root5", "root6", "root7",
        "projective_additive_flag",
    ]
    modulus = first_irreducible(q.bit_length() - 1)
    assert modulus == data["modulus"]
    c531 = HERE / "2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.py"
    assert hashlib.sha256(c531.read_bytes()).hexdigest() == data["c531_source_sha256"]
    representatives = quotient_representatives(q, modulus)
    recorded = [tuple(record[:4]) for record in data["records"]]
    assert representatives == recorded
    for record in data["records"]:
        assert len(record) == 13
        assert record[-1] in ((0, 1) if q == 16 else (-1,))
        check_witness(tuple(record[:4]), tuple(record[4:12]), q, modulus)
    if q == 16:
        rows = projective_additive_rows(modulus)
        without = 0
        for record in data["records"]:
            u = tuple(record[:4])
            point = (u[0], u[1], 1, 0, u[2], u[3])
            has = any(dot(point, row1, modulus) == 0 and dot(point, row2, modulus) == 0 for row1, row2 in rows)
            assert int(has) == record[-1]
            without += not has
        assert without == data["orbits_without_projective_additive_witness"] == 101
    return {"q": q, "orbit_count": len(representatives), "witnesses_checked": len(recorded)}


def main() -> None:
    print(json.dumps([replay(16), replay(32)], sort_keys=True))


if __name__ == "__main__":
    main()
