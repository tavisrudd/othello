#!/usr/bin/env python3
"""Independent quotient and Hankel replay for C973's pointed GF(16) certificate.

Repaired 2026-08-28.  This file shares no code with the generator and does not
call the projective-Reed--Solomon toolkit.  It rebuilds GF(16), the degree-ten
divided-power action of the stabiliser of infinity, the full marked-root orbit
partition, and the complete apolarity system, then re-verifies every stored
witness from its root set alone.

The predecessor of this file imported C531's degree-NINE (R10) action and
truncated it to the non-invariant slice ``e_3..e_7``.  That truncation is not a
symmetry of the R11 Hankel system, so the recorded quotient was a quotient by
the wrong group.  Section ``check_equivariance`` below now fails closed on
exactly that mistake; it must stay in place.  Note that the discarded wrong
group has the same orbit count, so the count alone is not a valid check.
"""

from __future__ import annotations

import json
from itertools import combinations
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-08-28-r11-gf16-pointed-quotient.json"
SCHEMA = "c973-r11-gf16-pointed-quotient-v2"
Q = 16
MODULUS = 0b10011
CARRIER_SUPPORT = tuple(range(3, 8))
REDUNDANCY = 11
EQUIVARIANCE_PAIRS = 1000
EQUIVARIANCE_SEED = 0xC973_2026_0828


def width() -> int:
    return len(CARRIER_SUPPORT)


def syndrome_degree() -> int:
    return REDUNDANCY - 1


def locator_degree() -> int:
    return REDUNDANCY - 2


# --------------------------------------------------------------------------
# field arithmetic
# --------------------------------------------------------------------------


def mul(left: int, right: int) -> int:
    out = 0
    while right:
        if right & 1:
            out ^= left
        right >>= 1
        left <<= 1
        if left & Q:
            left ^= MODULUS
    return out


def power(base: int, exponent: int) -> int:
    out = 1
    for _ in range(exponent):
        out = mul(out, base)
    return out


def invert(value: int) -> int:
    if value == 0:
        raise ZeroDivisionError("invert(0)")
    return power(value, Q - 2)


# --------------------------------------------------------------------------
# the degree-(r-1) divided-power action of the stabiliser of infinity
# --------------------------------------------------------------------------


def carrier_is_borel_stable() -> bool:
    return all(
        comb(target, source) % 2 == 0
        for source in CARRIER_SUPPORT
        for target in range(max(CARRIER_SUPPORT) + 1, syndrome_degree() + 1)
    )


def translation_matrix(shift: int) -> list[list[int]]:
    return [
        [
            power(shift, target - source)
            if target >= source and comb(target, source) % 2
            else 0
            for target in CARRIER_SUPPORT
        ]
        for source in CARRIER_SUPPORT
    ]


def scaling_matrix(factor: int) -> list[list[int]]:
    base = CARRIER_SUPPORT[0]
    return [
        [power(factor, source - base) if source == target else 0 for target in CARRIER_SUPPORT]
        for source in CARRIER_SUPPORT
    ]


def product_matrix(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    size = width()
    out = []
    for row in range(size):
        line = []
        for column in range(size):
            total = 0
            for mid in range(size):
                total ^= mul(left[row][mid], right[mid][column])
            line.append(total)
        out.append(line)
    return out


def carrier_matrix(mobius) -> list[list[int]]:
    a, b, c, d = mobius
    if c != 0 or a == 0 or d == 0:
        raise ValueError("generator is not in the stabiliser of infinity")
    return product_matrix(
        translation_matrix(mul(b, invert(a))), scaling_matrix(mul(a, invert(d)))
    )


def mobius_image(mobius, point: int) -> int:
    a, b, c, d = mobius
    return mul(mul(a, point) ^ b, invert(d))


def canonical(point) -> tuple[int, ...]:
    pivot = next(value for value in point if value)
    scale = invert(pivot)
    return tuple(mul(value, scale) for value in point)


def act(point, matrix) -> tuple[int, ...]:
    size = width()
    out = []
    for target in range(size):
        total = 0
        for source in range(size):
            total ^= mul(point[source], matrix[source][target])
        out.append(total)
    return canonical(tuple(out))


# --------------------------------------------------------------------------
# the R11 apolarity system
# --------------------------------------------------------------------------


def root_polynomial(roots) -> list[int]:
    coefficients = [1]
    for root in roots:
        extended = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            extended[index] ^= mul(coefficient, root)
            extended[index + 1] ^= coefficient
        coefficients = extended
    return coefficients


def is_locator(point, roots) -> bool:
    """iota_g f = 0 in Gamma^(n-d): every one of the n-d+1 equations.

    A degree-d support with d < r-2 is therefore held to the full d-degree
    apolarity system, which is strictly stronger than reading the two
    degree-(r-2) equations off a form that vanishes at infinity.  That is the
    convention the pointed statement needs: the witness certifies a coset
    representation on d finite points, with no infinity column.
    """
    degree = len(roots)
    if degree > locator_degree():
        return False
    coefficients = root_polynomial(roots)
    for level in range(syndrome_degree() - degree + 1):
        total = 0
        for offset, index in enumerate(CARRIER_SUPPORT):
            position = index - level
            if 0 <= position < len(coefficients):
                total ^= mul(point[offset], coefficients[position])
        if total != 0:
            return False
    return True


def hankel_rows(roots) -> list[list[int]]:
    degree = len(roots)
    coefficients = root_polynomial(roots)
    rows = []
    for level in range(syndrome_degree() - degree + 1):
        rows.append(
            [
                coefficients[index - level]
                if 0 <= index - level < len(coefficients)
                else 0
                for index in CARRIER_SUPPORT
            ]
        )
    return rows


def nullspace(rows) -> list[list[int]]:
    size = width()
    matrix = [list(row) for row in rows]
    pivots: list[int] = []
    rank = 0
    for column in range(size):
        pivot_row = next(
            (index for index in range(rank, len(matrix)) if matrix[index][column]), None
        )
        if pivot_row is None:
            continue
        matrix[rank], matrix[pivot_row] = matrix[pivot_row], matrix[rank]
        scale = invert(matrix[rank][column])
        matrix[rank] = [mul(value, scale) for value in matrix[rank]]
        for index in range(len(matrix)):
            if index != rank and matrix[index][column]:
                factor = matrix[index][column]
                matrix[index] = [
                    matrix[index][j] ^ mul(factor, matrix[rank][j]) for j in range(size)
                ]
        pivots.append(column)
        rank += 1
    basis = []
    for free in (column for column in range(size) if column not in pivots):
        vector = [0] * size
        vector[free] = 1
        for index, column in enumerate(pivots):
            vector[column] = matrix[index][free]
        basis.append(vector)
    return basis


# --------------------------------------------------------------------------
# fail-closed equivariance gate
# --------------------------------------------------------------------------


class SplitMix64:
    def __init__(self, seed: int) -> None:
        self.state = seed & 0xFFFFFFFFFFFFFFFF

    def next(self) -> int:
        self.state = (self.state + 0x9E3779B97F4A7C15) & 0xFFFFFFFFFFFFFFFF
        value = self.state
        value = ((value ^ (value >> 30)) * 0xBF58476D1CE4E5B9) & 0xFFFFFFFFFFFFFFFF
        value = ((value ^ (value >> 27)) * 0x94D049BB133111EB) & 0xFFFFFFFFFFFFFFFF
        return value ^ (value >> 31)

    def below(self, bound: int) -> int:
        return self.next() % bound

    def sample(self, population: int, size: int) -> list[int]:
        chosen: list[int] = []
        while len(chosen) < size:
            candidate = self.below(population)
            if candidate not in chosen:
                chosen.append(candidate)
        return chosen


def check_equivariance(generators, pairs: int = EQUIVARIANCE_PAIRS) -> int:
    """Fail closed unless every recorded generator moves the Hankel system.

    For each seeded pair this asserts the biconditional
    ``is_locator(z, S) == is_locator(z.M, phi(S))``, on a syndrome taken from
    the kernel of S and on an independent uniform syndrome.
    """
    if not carrier_is_borel_stable():
        raise SystemExit("replay: the carrier slice is not translation stable")
    rng = SplitMix64(EQUIVARIANCE_SEED)
    matrices = [carrier_matrix(generator) for generator in generators]
    for _ in range(pairs):
        support = rng.sample(Q, locator_degree())
        basis = nullspace(hankel_rows(support))
        kernel_point = [0] * width()
        while not any(kernel_point):
            kernel_point = [0] * width()
            for vector in basis:
                coefficient = rng.below(Q)
                if coefficient:
                    for index in range(width()):
                        kernel_point[index] ^= mul(coefficient, vector[index])
        random_point = [0] * width()
        while not any(random_point):
            random_point = [rng.below(Q) for _ in range(width())]
        if not is_locator(tuple(kernel_point), support):
            raise SystemExit("replay: kernel construction is wrong")
        for generator, matrix in zip(generators, matrices):
            image_support = [mobius_image(generator, root) for root in support]
            if len(set(image_support)) != len(support):
                raise SystemExit("replay: Mobius image collided")
            for probe in (kernel_point, random_point):
                if is_locator(tuple(probe), support) != is_locator(
                    act(tuple(probe), matrix), image_support
                ):
                    raise SystemExit(
                        "replay: the recorded Borel action is NOT a symmetry of the "
                        f"R11 Hankel system (generator {tuple(generator)})"
                    )
    return pairs


# --------------------------------------------------------------------------
# orbit partition, computed from scratch on packed integers
# --------------------------------------------------------------------------


def pack(point) -> int:
    value = 0
    for entry in point:
        value = value * Q + entry
    return value


def unpack(value: int) -> tuple[int, ...]:
    out = []
    for _ in range(width()):
        out.append(value % Q)
        value //= Q
    return tuple(reversed(out))


def all_points() -> set[int]:
    points: set[int] = set()
    size = width()
    for pivot in range(size):
        tail_length = size - pivot - 1
        head = pack((0,) * pivot + (1,) + (0,) * tail_length)
        for tail in range(Q**tail_length):
            points.add(head + tail)
    return points


def orbit_representatives(generators) -> list[tuple[int, ...]]:
    matrices = [carrier_matrix(generator) for generator in generators]
    unseen = all_points()
    representatives = []
    while unseen:
        start = min(unseen)
        orbit = {start}
        frontier = [start]
        while frontier:
            current = unpack(frontier.pop())
            for matrix in matrices:
                image = pack(act(current, matrix))
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen.difference_update(orbit)
        representatives.append(unpack(start))
    return representatives


# --------------------------------------------------------------------------


def main() -> None:
    data = json.loads(CERTIFICATE.read_text())
    if data["schema"] != SCHEMA:
        raise SystemExit(f"replay: unexpected schema {data['schema']}")
    if tuple(data["carrier_support"]) != CARRIER_SUPPORT:
        raise SystemExit("replay: unexpected carrier support")
    if data["redundancy"] != REDUNDANCY or data["field_order"] != Q:
        raise SystemExit("replay: unexpected redundancy or field order")
    if data["modulus_integer"] != MODULUS or data["marked_root"] != "infinity":
        raise SystemExit("replay: unexpected field model or marked root")
    if data["projective_carrier_points"] != (Q ** width() - 1) // (Q - 1):
        raise SystemExit("replay: wrong projective carrier size")

    generators = [tuple(generator) for generator in data["borel_generators"]]
    checked = check_equivariance(generators, data.get("equivariance_pairs", EQUIVARIANCE_PAIRS))

    expected = orbit_representatives(generators)
    recorded = [tuple(record["representative"]) for record in data["records"]]
    if recorded != expected:
        raise SystemExit(
            f"replay: recorded representatives are not the {len(expected)} orbit minima"
        )
    if data["orbit_count"] != len(expected):
        raise SystemExit("replay: declared orbit count disagrees")

    degrees: dict[str, int] = {}
    for record in data["records"]:
        point = tuple(record["representative"])
        if record["status"] == "NO_POINTED_LOCATOR":
            if any(
                is_locator(point, roots)
                for degree in range(1, locator_degree() + 1)
                for roots in combinations(range(Q), degree)
            ):
                raise SystemExit(f"replay: a locator exists for {point}")
            continue
        if record["status"] != "WITNESS":
            raise SystemExit(f"replay: unknown status {record['status']}")
        roots = record["support"]
        degree = len(roots)
        if not 1 <= degree <= locator_degree() or len(set(roots)) != degree:
            raise SystemExit(f"replay: bad support for {point}")
        if any(not 0 <= root < Q for root in roots):
            raise SystemExit(f"replay: non-finite support entry for {point}")
        coefficients = root_polynomial(roots)
        if len(coefficients) != degree + 1 or coefficients[-1] != 1:
            raise SystemExit(f"replay: support is not a monic split polynomial for {point}")
        if not is_locator(point, roots):
            raise SystemExit(f"replay: stored support fails the apolarity system for {point}")
        degrees[str(degree)] = degrees.get(str(degree), 0) + 1

    witnesses = sum(degrees.values())
    if witnesses != data["witness_orbits"]:
        raise SystemExit("replay: declared witness count disagrees")
    if degrees != data["witness_degree_histogram"]:
        raise SystemExit("replay: declared degree histogram disagrees")
    if data["no_pointed_locator_orbits"] != len(recorded) - witnesses:
        raise SystemExit("replay: declared negative count disagrees")

    print(
        f"C973 independent GF({Q}) replay: PASS "
        f"({len(recorded)} pointed orbits, {witnesses} verified finite witnesses, "
        f"degrees {degrees}, {checked} equivariance pairs)"
    )


if __name__ == "__main__":
    main()
